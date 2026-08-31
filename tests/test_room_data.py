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
