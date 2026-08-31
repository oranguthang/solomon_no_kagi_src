from __future__ import annotations

import unittest

from scripts.enemy_pointer_data import decode_split_pointer_table, validate_report


class EnemyPointerDataTests(unittest.TestCase):
    def test_decodes_split_pointer_table(self) -> None:
        prg = bytearray(32_768)
        prg[0x3446:0x3449] = bytes((0xF7, 0xFF, 0x07))
        prg[0x3457:0x345A] = bytes((0x04, 0x04, 0x05))
        self.assertEqual(
            decode_split_pointer_table(bytes(prg), 0xB446, 0xB457, 3),
            [0x04F7, 0x04FF, 0x0507],
        )

    def test_rejects_truncated_table(self) -> None:
        with self.assertRaisesRegex(ValueError, "truncated"):
            decode_split_pointer_table(bytes(32_768), 0xFFFF, 0xB457, 2)

    def test_audit_detects_stride_mismatch(self) -> None:
        report = {"tables": [{"id": "enemy_ai", "pointers": [0x04F7, 0x0500]}]}
        manifest = {
            "tables": [
                {
                    "id": "enemy_ai",
                    "base_address": "0x04f7",
                    "stride": 8,
                    "count": 2,
                }
            ]
        }
        errors = validate_report(report, manifest)
        self.assertEqual(len(errors), 1)
        self.assertIn("enemy_ai pointers differ", errors[0])


if __name__ == "__main__":
    unittest.main()
