from __future__ import annotations

from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import room_data


class RoomDataTests(unittest.TestCase):
    def test_position_encoding(self) -> None:
        self.assertEqual(room_data.position(0xB5), {"x": 5, "y": 10, "raw": 0xB5})
        self.assertEqual(room_data.position(0x05)["y"], -1)

    def test_spawn_lifetime_rotation(self) -> None:
        self.assertEqual(room_data.rotate_left_3(0x20), 1)
        self.assertEqual(room_data.rotate_left_3(0xFF), 0xFF)

    def test_bitplane_is_row_major_and_msb_first(self) -> None:
        data = bytes([0x80, 0x01]) + bytes(room_data.BITPLANE_SIZE - 2)
        rows = room_data.decode_bitplane(data)
        self.assertTrue(rows[0][0])
        self.assertTrue(rows[0][15])
        self.assertEqual(sum(map(sum, rows)), 2)
        self.assertEqual(room_data.encode_bitplane(room_data.true_positions(rows)), data)

    def test_enemy_stream_round_trip(self) -> None:
        prg = bytearray(32_768)
        offset = 0x1000
        cpu_address = offset + 0x8000
        prg[room_data.ENEMY_POINTER_TABLE] = cpu_address & 0xFF
        prg[room_data.ENEMY_POINTER_TABLE + room_data.ROOM_COUNT] = cpu_address >> 8
        encoded = bytes((0x20, 0x04, 0xB5, 0x07, 0x31, 0x00))
        prg[offset : offset + len(encoded)] = encoded
        decoded = room_data.decode_enemies(bytes(prg), 0)
        self.assertEqual(room_data.encode_enemies(decoded), encoded)

        low = bytes((cpu_address & 0xFF,)) * room_data.ROOM_COUNT
        high = bytes((cpu_address >> 8,)) * room_data.ROOM_COUNT
        table = room_data.ENEMY_POINTER_TABLE
        prg[table : table + room_data.ROOM_COUNT] = low
        prg[table + room_data.ROOM_COUNT : table + room_data.ROOM_COUNT * 2] = high
        source = room_data.emit_enemy_source(bytes(prg))
        self.assertIn("RoomEnemyStream01:", source)
        self.assertIn("RoomEnemyRecord $04, $B5", source)
        self.assertIn("RoomEnemyStream53:", source)

    def test_item_stream_round_trip_preserves_rle_commands(self) -> None:
        prg = bytearray(32_768)
        offset = 0x1100
        cpu_address = offset + 0x8000
        prg[room_data.ITEM_POINTER_TABLE] = cpu_address & 0xFF
        prg[room_data.ITEM_POINTER_TABLE + room_data.ROOM_COUNT] = cpu_address >> 8
        encoded = bytes(
            (
                1, 2, 3, 4, 0x8F, 0x21, 0x32, 0x43, 0x54, 0x65,
                0xC1, 0x22, 0x76, 0x87,
                0xF0, 0x98,
            )
        )
        prg[offset : offset + len(encoded)] = encoded
        decoded = room_data.decode_items(bytes(prg), 0)
        self.assertEqual(decoded["commands"][0]["kind"], "repeat")
        self.assertEqual(room_data.encode_items(decoded), encoded)

    def test_split_pointer_round_trip(self) -> None:
        offsets = [0x0100, 0x1234, 0x7FFF]
        encoded = room_data.encode_split_pointers(offsets)
        self.assertEqual(encoded, bytes((0x00, 0x34, 0xFF, 0x81, 0x92, 0xFF)))

    def test_mirror_schedule_round_trip(self) -> None:
        prg = bytearray(32_768)
        offset = 0x1000
        cpu_address = offset + 0x8000
        table = room_data.MIRROR_SCHEDULE_TABLE
        count = room_data.MIRROR_SCHEDULE_COUNT
        prg[table : table + count] = bytes((cpu_address & 0xFF,)) * count
        prg[table + count : table + count * 2] = bytes((cpu_address >> 8,)) * count
        encoded = bytes((0x84, 0x21, 0x08, 0x42, 0x08, 0x42, 0x10, 0x84))
        prg[offset : offset + len(encoded)] = encoded
        schedule = room_data.decode_mirror_schedules(bytes(prg))[0]
        self.assertEqual(schedule["initial_phase"], [0x84, 0x21, 0x08, 0x42])
        self.assertEqual(room_data.encode_mirror_schedule(schedule), encoded)

    def test_mirror_enemy_set_round_trip(self) -> None:
        prg = bytearray(32_768)
        offset = 0x1000
        cpu_address = offset + 0x8000
        table = room_data.MIRROR_ENEMY_SET_TABLE
        count = room_data.MIRROR_ENEMY_SET_COUNT
        prg[table : table + count] = bytes((cpu_address & 0xFF,)) * count
        prg[table + count : table + count * 2] = bytes((cpu_address >> 8,)) * count
        encoded = bytes((0x50, 0x51, 0x5C, 0x90))
        prg[offset : offset + len(encoded)] = encoded
        enemy_set = room_data.decode_mirror_enemy_sets(bytes(prg))[0]
        self.assertEqual(enemy_set["enemy_types"], [0x50, 0x51, 0x5C])
        self.assertEqual(enemy_set["loop_offset"], 0)
        self.assertEqual(room_data.encode_mirror_enemy_set(enemy_set), encoded)

    def test_extracts_prg_from_ines(self) -> None:
        header = b"NES\x1a" + bytes((2, 4, 0x30, 0)) + bytes(8)
        prg = bytes([0xA5]) * 32_768
        image = header + prg + bytes(32_768)
        self.assertEqual(room_data.extract_prg(image), prg)

    def test_rejects_bad_bare_image(self) -> None:
        with self.assertRaisesRegex(room_data.RoomDataError, "expected"):
            room_data.extract_prg(b"not a ROM")


if __name__ == "__main__":
    unittest.main()
