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
MIRROR_SCHEDULE_DATA = 0x5C42
MIRROR_SCHEDULE_COUNT = 16
MIRROR_SCHEDULE_SIZE = 8
MIRROR_ENEMY_SET_COUNT = 17
MIRROR_ENEMY_SET_LOOP_BASE = 0x90
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


def encode_position(value: dict[str, int]) -> int:
    raw = value.get("raw")
    if raw is not None:
        if position(raw) != value:
            raise RoomDataError(f"position fields disagree: {value!r}")
        return raw
    x = value.get("x")
    y = value.get("y")
    if not isinstance(x, int) or not isinstance(y, int) or not 0 <= x < ROOM_WIDTH:
        raise RoomDataError(f"invalid position: {value!r}")
    encoded_y = y + 1
    if not 0 <= encoded_y <= 0x0F:
        raise RoomDataError(f"invalid position: {value!r}")
    return (encoded_y << 4) | x


def encode_bitplane(positions: Iterable[dict[str, int]]) -> bytes:
    output = bytearray(BITPLANE_SIZE)
    occupied: set[tuple[int, int]] = set()
    for value in positions:
        x = value.get("x")
        y = value.get("y")
        if not isinstance(x, int) or not isinstance(y, int):
            raise RoomDataError(f"invalid block position: {value!r}")
        if not 0 <= x < ROOM_WIDTH or not 0 <= y < ROOM_HEIGHT:
            raise RoomDataError(f"block position outside room: {value!r}")
        coordinate = (x, y)
        if coordinate in occupied:
            raise RoomDataError(f"duplicate block position: {value!r}")
        occupied.add(coordinate)
        output[y * 2 + x // 8] |= 0x80 >> (x % 8)
    return bytes(output)


def encode_split_pointers(offsets: Iterable[int]) -> bytes:
    cpu_addresses = [offset + 0x8000 for offset in offsets]
    if any(not 0x8000 <= address <= 0xFFFF for address in cpu_addresses):
        raise RoomDataError("pointer outside PRG CPU window")
    return bytes(address & 0xFF for address in cpu_addresses) + bytes(
        address >> 8 for address in cpu_addresses
    )


def decode_mirror_schedules(prg: bytes) -> list[dict[str, object]]:
    schedules: list[dict[str, object]] = []
    for index in range(MIRROR_SCHEDULE_COUNT):
        offset = split_pointer(prg, MIRROR_SCHEDULE_TABLE, index, MIRROR_SCHEDULE_COUNT)
        data = prg[offset : offset + MIRROR_SCHEDULE_SIZE]
        if len(data) != MIRROR_SCHEDULE_SIZE:
            raise RoomDataError(f"truncated Demon Mirror schedule {index}")
        schedules.append(
            {
                "index": index,
                "prg_offset": offset,
                "initial_phase": list(data[:4]),
                "loop_phase": list(data[4:]),
            }
        )
    return schedules


def encode_mirror_schedule(schedule: dict[str, object]) -> bytes:
    initial = schedule.get("initial_phase")
    loop = schedule.get("loop_phase")
    if (
        not isinstance(initial, list)
        or not isinstance(loop, list)
        or len(initial) != 4
        or len(loop) != 4
        or any(not isinstance(value, int) or not 0 <= value <= 0xFF for value in initial + loop)
    ):
        raise RoomDataError(f"invalid Demon Mirror schedule: {schedule!r}")
    return bytes(initial + loop)


def decode_mirror_enemy_sets(prg: bytes) -> list[dict[str, object]]:
    enemy_sets: list[dict[str, object]] = []
    for index in range(MIRROR_ENEMY_SET_COUNT):
        offset = split_pointer(
            prg, MIRROR_ENEMY_SET_TABLE, index, MIRROR_ENEMY_SET_COUNT
        )
        cursor = offset
        enemy_types: list[int] = []
        while cursor < ENEMY_POINTER_TABLE:
            value = prg[cursor]
            cursor += 1
            if value >= MIRROR_ENEMY_SET_LOOP_BASE:
                enemy_sets.append(
                    {
                        "index": index,
                        "prg_offset": offset,
                        "encoded_size": cursor - offset,
                        "enemy_types": enemy_types,
                        "loop_offset": value - MIRROR_ENEMY_SET_LOOP_BASE,
                    }
                )
                break
            enemy_types.append(value)
        else:
            raise RoomDataError(f"unterminated Demon Mirror enemy set {index}")
    return enemy_sets


def encode_mirror_enemy_set(enemy_set: dict[str, object]) -> bytes:
    enemy_types = enemy_set.get("enemy_types")
    loop_offset = enemy_set.get("loop_offset")
    if not isinstance(enemy_types, list) or any(
        not isinstance(value, int) or not 0 <= value < MIRROR_ENEMY_SET_LOOP_BASE
        for value in enemy_types
    ):
        raise RoomDataError(f"invalid Demon Mirror enemy types: {enemy_types!r}")
    if not isinstance(loop_offset, int) or not 0 <= loop_offset <= 0x6F:
        raise RoomDataError(f"invalid Demon Mirror loop offset: {loop_offset!r}")
    return bytes(enemy_types + [MIRROR_ENEMY_SET_LOOP_BASE + loop_offset])


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
        "encoded_size": cursor - offset,
        "spawn_lifetime": rotate_left_3(encoded_lifetime),
        "spawn_lifetime_encoded": encoded_lifetime,
        "enemies": enemies,
    }


def encode_enemies(stream: dict[str, object]) -> bytes:
    encoded_lifetime = stream.get("spawn_lifetime_encoded")
    enemies = stream.get("enemies")
    if not isinstance(encoded_lifetime, int) or not 0 <= encoded_lifetime <= 0xFF:
        raise RoomDataError("invalid encoded enemy lifetime")
    if not isinstance(enemies, list):
        raise RoomDataError("enemy list is missing")
    output = bytearray((encoded_lifetime,))
    for enemy in enemies:
        if not isinstance(enemy, dict) or not isinstance(enemy.get("type"), int):
            raise RoomDataError(f"invalid enemy record: {enemy!r}")
        enemy_type = enemy["type"]
        if not 1 <= enemy_type <= 0xFF:
            raise RoomDataError(f"invalid enemy type: {enemy_type!r}")
        enemy_position = enemy.get("position")
        if not isinstance(enemy_position, dict):
            raise RoomDataError(f"invalid enemy position: {enemy_position!r}")
        output.extend((enemy_type, encode_position(enemy_position)))
    output.append(0)
    return bytes(output)


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
        "status_rate_raw": status_rate,
        "door": position(header[5]),
        "key": position(header[6]),
        "player_start": position(header[7]),
        "mirror_1": position(header[8]),
        "mirror_2": position(header[9]),
    }
    items: list[dict[str, object]] = []
    commands: list[dict[str, object]] = []
    constellation: dict[str, object] | None = None
    cursor = offset + 10
    tileset = 0
    while True:
        code = prg[cursor]
        cursor += 1
        if code == 0 or 0xE0 <= code <= 0xEF:
            commands.append({"kind": "end", "opcode": code})
            tileset = (code >> 2) & 3
            break
        if 0xF0 <= code <= 0xFB:
            constellation = {"type": code, "position": position(prg[cursor])}
            commands.append(
                {
                    "kind": "constellation",
                    "opcode": code,
                    "position": position(prg[cursor]),
                }
            )
            cursor += 1
            tileset = (code >> 2) & 3
            break
        if 0xC0 <= code <= 0xDF:
            count = code - 0xC0 + 1
            item_type = prg[cursor]
            cursor += 1
            positions: list[dict[str, int]] = []
            for _ in range(count):
                item_position = position(prg[cursor])
                positions.append(item_position)
                items.append({"type": item_type, "position": item_position})
                cursor += 1
            commands.append(
                {
                    "kind": "repeat",
                    "opcode": code,
                    "type": item_type,
                    "positions": positions,
                }
            )
            continue
        item_position = position(prg[cursor])
        commands.append(
            {"kind": "item", "type": code, "position": item_position}
        )
        items.append({"type": code, "position": item_position})
        cursor += 1
    return {
        "prg_offset": offset,
        "encoded_size": cursor - offset,
        "metadata": metadata,
        "tileset": tileset,
        "constellation": constellation,
        "items": items,
        "commands": commands,
    }


def encode_items(stream: dict[str, object]) -> bytes:
    metadata = stream.get("metadata")
    commands = stream.get("commands")
    if not isinstance(metadata, dict) or not isinstance(commands, list):
        raise RoomDataError("item metadata or commands are missing")
    status_rate = metadata.get("status_rate_raw")
    if not isinstance(status_rate, int) or not 0 <= status_rate <= 0xFF:
        raise RoomDataError("invalid raw key-status/time-rate byte")
    header_values: list[int] = []
    for field in (
        "mirror_2_schedule",
        "mirror_1_schedule",
        "mirror_2_enemy_set",
        "mirror_1_enemy_set",
    ):
        value = metadata.get(field)
        if not isinstance(value, int) or not 0 <= value <= 0xFF:
            raise RoomDataError(f"invalid item metadata field: {field}")
        header_values.append(value)
    header_values.append(status_rate)
    for field in ("door", "key", "player_start", "mirror_1", "mirror_2"):
        value = metadata.get(field)
        if not isinstance(value, dict):
            raise RoomDataError(f"invalid item metadata position: {field}")
        header_values.append(encode_position(value))
    output = bytearray(header_values)
    for command in commands:
        if not isinstance(command, dict):
            raise RoomDataError(f"invalid item command: {command!r}")
        kind = command.get("kind")
        if kind == "end":
            opcode = command.get("opcode")
            if not isinstance(opcode, int) or not (opcode == 0 or 0xE0 <= opcode <= 0xEF):
                raise RoomDataError(f"invalid item end command: {command!r}")
            output.append(opcode)
        elif kind == "constellation":
            opcode = command.get("opcode")
            value = command.get("position")
            if not isinstance(opcode, int) or not 0xF0 <= opcode <= 0xFB or not isinstance(value, dict):
                raise RoomDataError(f"invalid constellation command: {command!r}")
            output.extend((opcode, encode_position(value)))
        elif kind == "repeat":
            opcode = command.get("opcode")
            item_type = command.get("type")
            positions = command.get("positions")
            if (
                not isinstance(opcode, int)
                or not 0xC0 <= opcode <= 0xDF
                or not isinstance(item_type, int)
                or not 0 <= item_type <= 0xFF
                or not isinstance(positions, list)
                or len(positions) != opcode - 0xC0 + 1
            ):
                raise RoomDataError(f"invalid repeated-item command: {command!r}")
            output.extend((opcode, item_type))
            for value in positions:
                if not isinstance(value, dict):
                    raise RoomDataError(f"invalid repeated-item position: {value!r}")
                output.append(encode_position(value))
        elif kind == "item":
            item_type = command.get("type")
            value = command.get("position")
            if (
                not isinstance(item_type, int)
                or not (1 <= item_type < 0xC0 or 0xFC <= item_type <= 0xFF)
                or not isinstance(value, dict)
            ):
                raise RoomDataError(f"invalid item command: {command!r}")
            output.extend((item_type, encode_position(value)))
        else:
            raise RoomDataError(f"unknown item command: {kind!r}")
    if not commands or commands[-1].get("kind") not in {"end", "constellation"}:
        raise RoomDataError("item command stream has no terminator")
    return bytes(output)


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


def encode_blocks(blocks: dict[str, object]) -> bytes:
    brown = blocks.get("brown")
    white = blocks.get("white")
    if not isinstance(brown, list) or not isinstance(white, list):
        raise RoomDataError("block planes are missing")
    return encode_bitplane(brown) + encode_bitplane(white)


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


def emit_enemy_source(prg: bytes) -> str:
    """Render all room enemy pointers and records as readable ca65 source."""
    rooms = [decode_enemies(prg, index) for index in range(ROOM_COUNT)]
    labels = [f"RoomEnemyStream{index + 1:02d}" for index in range(ROOM_COUNT)]
    lines = [
        "; Per-room enemy pointers, encoded lifetimes, and spawn records",
        "",
        "RoomEnemyStreamCount = 53",
        "",
        ".macro RoomEnemySpawnLifetime encoded_value",
        "    .byte encoded_value",
        ".endmacro",
        "",
        ".macro RoomEnemyRecord enemy_type, map_position",
        "    .byte enemy_type, map_position",
        ".endmacro",
        "",
        ".macro EndRoomEnemyStream",
        "    .byte $00",
        ".endmacro",
        "",
        '.segment "PRG_ROOM_ENEMY_POINTERS"',
        "",
        "RoomEnemyPointerLowTable:",
    ]
    for index in range(0, ROOM_COUNT, 2):
        row = labels[index : index + 2]
        lines.append("    .byte " + ", ".join(f"<{label}" for label in row))
    lines.extend(("", "RoomEnemyPointerHighTable:"))
    for index in range(0, ROOM_COUNT, 2):
        row = labels[index : index + 2]
        lines.append("    .byte " + ", ".join(f">{label}" for label in row))
    lines.extend(
        (
            "",
            ".assert RoomEnemyPointerHighTable - RoomEnemyPointerLowTable = "
            "RoomEnemyStreamCount, error, \"unexpected room enemy pointer count\"",
            ".assert * - RoomEnemyPointerHighTable = RoomEnemyStreamCount, "
            "error, \"unexpected room enemy pointer count\"",
            "",
            '.segment "PRG_ROOM_ENEMY_DATA"',
            "",
        )
    )
    for label, stream in zip(labels, rooms):
        encoded_lifetime = stream["spawn_lifetime_encoded"]
        enemies = stream["enemies"]
        if not isinstance(encoded_lifetime, int) or not isinstance(enemies, list):
            raise RoomDataError("decoded enemy stream has invalid fields")
        lines.append(f"{label}:")
        lines.append(f"    RoomEnemySpawnLifetime ${encoded_lifetime:02X}")
        for enemy in enemies:
            if not isinstance(enemy, dict):
                raise RoomDataError("decoded enemy record is invalid")
            enemy_type = enemy.get("type")
            enemy_position = enemy.get("position")
            if not isinstance(enemy_type, int) or not isinstance(enemy_position, dict):
                raise RoomDataError("decoded enemy record has invalid fields")
            lines.append(
                f"    RoomEnemyRecord ${enemy_type:02X}, "
                f"${encode_position(enemy_position):02X}"
            )
        lines.append("    EndRoomEnemyStream")
    data_size = BLOCK_DATA - rooms[0]["prg_offset"]
    if not isinstance(data_size, int):
        raise RoomDataError("invalid room enemy data extent")
    lines.extend(
        (
            "",
            f".assert * - {labels[0]} = ${data_size:04X}, error, "
            '"unexpected room enemy data size"',
            "",
        )
    )
    return "\n".join(lines)


def roundtrip_rooms(prg: bytes) -> dict[str, int]:
    rooms = [decode_room(prg, index) for index in range(ROOM_COUNT)]
    mirror_schedules = decode_mirror_schedules(prg)
    mirror_enemy_sets = decode_mirror_enemy_sets(prg)
    enemy_offsets: list[int] = []
    item_offsets: list[int] = []
    checked_bytes = 0
    for room in rooms:
        blocks = room["blocks"]
        enemies = room["enemy_stream"]
        items = room["item_stream"]
        if not isinstance(blocks, dict) or not isinstance(enemies, dict) or not isinstance(items, dict):
            raise RoomDataError("decoded room has an invalid structure")
        block_offset = int(blocks["prg_offset"])
        encoded_blocks = encode_blocks(blocks)
        if encoded_blocks != prg[block_offset : block_offset + len(encoded_blocks)]:
            raise RoomDataError(f"room {room['room']} block round trip differs")
        enemy_offset = int(enemies["prg_offset"])
        encoded_enemies = encode_enemies(enemies)
        if encoded_enemies != prg[enemy_offset : enemy_offset + len(encoded_enemies)]:
            raise RoomDataError(f"room {room['room']} enemy round trip differs")
        item_offset = int(items["prg_offset"])
        encoded_items = encode_items(items)
        if encoded_items != prg[item_offset : item_offset + len(encoded_items)]:
            raise RoomDataError(f"room {room['room']} item round trip differs")
        enemy_offsets.append(enemy_offset)
        item_offsets.append(item_offset)
        checked_bytes += len(encoded_blocks) + len(encoded_enemies) + len(encoded_items)

    enemy_pointers = encode_split_pointers(enemy_offsets)
    item_pointers = encode_split_pointers(item_offsets)
    if enemy_pointers != prg[ENEMY_POINTER_TABLE : ENEMY_POINTER_TABLE + len(enemy_pointers)]:
        raise RoomDataError("enemy pointer-table round trip differs")
    if item_pointers != prg[ITEM_POINTER_TABLE : ITEM_POINTER_TABLE + len(item_pointers)]:
        raise RoomDataError("item pointer-table round trip differs")
    checked_bytes += len(enemy_pointers) + len(item_pointers)

    schedule_offsets: list[int] = []
    for schedule in mirror_schedules:
        offset = int(schedule["prg_offset"])
        encoded = encode_mirror_schedule(schedule)
        if encoded != prg[offset : offset + len(encoded)]:
            raise RoomDataError(f"Demon Mirror schedule {schedule['index']} differs")
        schedule_offsets.append(offset)
        checked_bytes += len(encoded)
    schedule_pointers = encode_split_pointers(schedule_offsets)
    if schedule_pointers != prg[
        MIRROR_SCHEDULE_TABLE : MIRROR_SCHEDULE_TABLE + len(schedule_pointers)
    ]:
        raise RoomDataError("Demon Mirror schedule pointer round trip differs")
    checked_bytes += len(schedule_pointers)

    enemy_set_offsets: list[int] = []
    for enemy_set in mirror_enemy_sets:
        offset = int(enemy_set["prg_offset"])
        encoded = encode_mirror_enemy_set(enemy_set)
        if encoded != prg[offset : offset + len(encoded)]:
            raise RoomDataError(f"Demon Mirror enemy set {enemy_set['index']} differs")
        enemy_set_offsets.append(offset)
        checked_bytes += len(encoded)
    enemy_set_pointers = encode_split_pointers(enemy_set_offsets)
    if enemy_set_pointers != prg[
        MIRROR_ENEMY_SET_TABLE : MIRROR_ENEMY_SET_TABLE + len(enemy_set_pointers)
    ]:
        raise RoomDataError("Demon Mirror enemy-set pointer round trip differs")
    checked_bytes += len(enemy_set_pointers)

    return {"rooms": len(rooms), "format_families": 5, "checked_bytes": checked_bytes}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", required=True, help="iNES image or bare 32 KiB PRG")
    parser.add_argument("--room", type=int, help="one-based room number (default: all)")
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument(
        "--source-enemies",
        action="store_true",
        help="emit reviewed ca65 source for all room enemy data",
    )
    parser.add_argument(
        "--validate",
        action="store_true",
        help="decode every room and print only a structural summary",
    )
    parser.add_argument(
        "--roundtrip",
        action="store_true",
        help="decode and re-encode every room-data record and pointer table",
    )
    args = parser.parse_args()
    try:
        prg = extract_prg(Path(args.image).read_bytes())
        if args.source_enemies:
            print(emit_enemy_source(prg), end="")
            return 0
        if args.roundtrip:
            result = roundtrip_rooms(prg)
            print(
                f"[OK] round-tripped {result['format_families']} room format "
                f"families across {result['rooms']} rooms "
                f"({result['checked_bytes']} checked bytes)"
            )
            return 0
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
