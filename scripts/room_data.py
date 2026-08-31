#!/usr/bin/env python3
"""Decode all 53 Solomon's Key (USA) room records as JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys
from typing import Iterable


ROOM_COUNT = 53
ROOM_WIDTH = 16
ROOM_HEIGHT = 12
BITPLANE_SIZE = ROOM_WIDTH * ROOM_HEIGHT // 8
BLOCK_BYTES_PER_ROOM = BITPLANE_SIZE * 2

# Offsets within the 32 KiB PRG. Published file offsets include the 16-byte
# iNES header, hence the $10 difference from the ROM-map document.
MIRROR_SCHEDULE_TABLE = 0x5C00
MIRROR_ENEMY_SET_TABLE = 0x5C20
ENEMY_POINTER_TABLE = 0x5CEC
BLOCK_DATA = 0x602C
ITEM_POINTER_TABLE = 0x6A1C


class RoomDataError(ValueError):
    pass


def extract_prg(image: bytes) -> bytes:
    if image[:4] == b"NES\x1a":
        if len(image) < 16:
            raise RoomDataError("truncated iNES header")
        trainer_size = 512 if image[6] & 0x04 else 0
        prg_size = image[4] * 16_384
        start = 16 + trainer_size
        end = start + prg_size
        if len(image) < end:
            raise RoomDataError("truncated PRG")
        return image[start:end]
    if len(image) == 32_768:
        return image
    raise RoomDataError("expected a Solomon's Key iNES image or 32 KiB PRG")


def position(value: int) -> dict[str, int]:
    return {"x": value & 0x0F, "y": (value >> 4) - 1, "raw": value}


def rotate_left_3(value: int) -> int:
    return ((value & 0x1F) << 3) | (value >> 5)


def split_pointer(prg: bytes, table: int, index: int, count: int) -> int:
    low = prg[table + index]
    high = prg[table + count + index]
    cpu_address = low | (high << 8)
    if not 0x8000 <= cpu_address <= 0xFFFF:
        raise RoomDataError(f"pointer outside PRG CPU window: ${cpu_address:04X}")
    return cpu_address - 0x8000


def decode_bitplane(data: bytes) -> list[list[bool]]:
    if len(data) != BITPLANE_SIZE:
        raise RoomDataError(f"bitplane must be {BITPLANE_SIZE} bytes")
    rows: list[list[bool]] = []
    for y in range(ROOM_HEIGHT):
        row: list[bool] = []
        for packed in data[y * 2 : y * 2 + 2]:
            row.extend(bool(packed & (1 << bit)) for bit in range(7, -1, -1))
        rows.append(row)
    return rows


def true_positions(rows: Iterable[Iterable[bool]]) -> list[dict[str, int]]:
    return [
        {"x": x, "y": y}
        for y, row in enumerate(rows)
        for x, occupied in enumerate(row)
        if occupied
    ]


def decode_enemies(prg: bytes, room_index: int) -> dict[str, object]:
    offset = split_pointer(prg, ENEMY_POINTER_TABLE, room_index, ROOM_COUNT)
    encoded_lifetime = prg[offset]
    enemies: list[dict[str, object]] = []
    cursor = offset + 1
    while True:
        enemy_type = prg[cursor]
        cursor += 1
        if enemy_type == 0:
            break
        enemies.append({"type": enemy_type, "position": position(prg[cursor])})
        cursor += 1
    return {
        "prg_offset": offset,
        "spawn_lifetime": rotate_left_3(encoded_lifetime),
        "spawn_lifetime_encoded": encoded_lifetime,
        "enemies": enemies,
    }


def decode_items(prg: bytes, room_index: int) -> dict[str, object]:
    offset = split_pointer(prg, ITEM_POINTER_TABLE, room_index, ROOM_COUNT)
    header = prg[offset : offset + 10]
    if len(header) != 10:
        raise RoomDataError("truncated item metadata")
    status_rate = header[4]
    metadata: dict[str, object] = {
        "mirror_2_schedule": header[0],
        "mirror_1_schedule": header[1],
        "mirror_2_enemy_set": header[2],
        "mirror_1_enemy_set": header[3],
        "key_status": (
            "hidden" if status_rate >= 0x80 else
            "in_block" if status_rate >= 0x40 else
            "normal"
        ),
        "time_decrease_rate": status_rate & 0x0F,
        "door": position(header[5]),
        "key": position(header[6]),
        "player_start": position(header[7]),
        "mirror_1": position(header[8]),
        "mirror_2": position(header[9]),
    }
    items: list[dict[str, object]] = []
    constellation: dict[str, object] | None = None
    cursor = offset + 10
    tileset = 0
    while True:
        code = prg[cursor]
        cursor += 1
        if code == 0 or 0xE0 <= code <= 0xEF:
            tileset = (code >> 2) & 3
            break
        if 0xF0 <= code <= 0xFB:
            constellation = {"type": code, "position": position(prg[cursor])}
            cursor += 1
            tileset = (code >> 2) & 3
            break
        if 0xC0 <= code <= 0xDF:
            count = code - 0xC0 + 1
            item_type = prg[cursor]
            cursor += 1
            for _ in range(count):
                items.append({"type": item_type, "position": position(prg[cursor])})
                cursor += 1
            continue
        items.append({"type": code, "position": position(prg[cursor])})
        cursor += 1
    return {
        "prg_offset": offset,
        "metadata": metadata,
        "tileset": tileset,
        "constellation": constellation,
        "items": items,
    }


def decode_blocks(prg: bytes, room_index: int) -> dict[str, object]:
    offset = BLOCK_DATA + room_index * BLOCK_BYTES_PER_ROOM
    brown = decode_bitplane(prg[offset : offset + BITPLANE_SIZE])
    white = decode_bitplane(
        prg[offset + BITPLANE_SIZE : offset + BLOCK_BYTES_PER_ROOM]
    )
    return {
        "prg_offset": offset,
        "brown": true_positions(brown),
        "white": true_positions(white),
    }


def decode_room(prg: bytes, room_index: int) -> dict[str, object]:
    if not 0 <= room_index < ROOM_COUNT:
        raise RoomDataError(f"room index outside 0..{ROOM_COUNT - 1}: {room_index}")
    return {
        "room": room_index + 1,
        "index": room_index,
        "blocks": decode_blocks(prg, room_index),
        "enemy_stream": decode_enemies(prg, room_index),
        "item_stream": decode_items(prg, room_index),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", required=True, help="iNES image or bare 32 KiB PRG")
    parser.add_argument("--room", type=int, help="one-based room number (default: all)")
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument(
        "--validate",
        action="store_true",
        help="decode every room and print only a structural summary",
    )
    args = parser.parse_args()
    try:
        prg = extract_prg(Path(args.image).read_bytes())
        if args.validate:
            rooms = [decode_room(prg, index) for index in range(ROOM_COUNT)]
            enemy_count = sum(
                len(room["enemy_stream"]["enemies"]) for room in rooms
            )
            item_count = sum(len(room["item_stream"]["items"]) for room in rooms)
            print(
                f"[OK] decoded {len(rooms)} rooms, {enemy_count} placed enemies, "
                f"and {item_count} item records"
            )
            return 0
        if args.room is None:
            result: object = [decode_room(prg, index) for index in range(ROOM_COUNT)]
        else:
            result = decode_room(prg, args.room - 1)
    except (OSError, RoomDataError, IndexError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    print(json.dumps(result, indent=2 if args.pretty else None))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
