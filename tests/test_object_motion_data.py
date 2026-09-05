from __future__ import annotations

import hashlib
import unittest

from scripts.object_motion_data import (
    collect_report,
    decode_motion_vectors,
    emit_source,
    validate_report,
)


class ObjectMotionDataTests(unittest.TestCase):
    def test_decodes_y_and_x_motion_pairs(self) -> None:
        prg = bytearray(32_768)
        prg[0:4] = bytes((0x80, 0x10, 0x40, 0x68))
        vectors = decode_motion_vectors(bytes(prg), 0x8000, 2)
        self.assertEqual(
            [(item.index, item.y_velocity, item.x_velocity) for item in vectors],
            [(0, 0x80, 0x10), (1, 0x40, 0x68)],
        )

    def test_collects_a_minimal_complete_layout(self) -> None:
        prg = bytearray(32_768)
        prg[0:2] = bytes((0x10, 0x80))
        prg[0x10:0x12] = bytes((0x00, 0x80))
        prg[0x20:0x22] = bytes((0x40, 0x68))
        manifest = {
            "object_type_pointers": ["0x8010"],
            "pointer_table_address": "0x8000",
            "selector_data_start": "0x8010",
            "selector_data_end": "0x8011",
            "selector_groups": [{"address": "0x8010", "action_count": 2}],
            "selector_count": 2,
            "motion_vector_address": "0x8020",
            "motion_vector_count": 1,
            "pointer_sha1": hashlib.sha1(prg[0:2]).hexdigest(),
            "selector_sha1": hashlib.sha1(prg[0x10:0x12]).hexdigest(),
            "vector_sha1": hashlib.sha1(prg[0x20:0x22]).hexdigest(),
        }
        report = collect_report(bytes(prg), manifest)
        self.assertEqual(report["direct_selector_count"], 1)
        self.assertEqual(report["room_state_mask_count"], 1)
        self.assertEqual(validate_report(report, manifest), [])
        source = emit_source(bytes(prg), manifest)
        self.assertIn("ObjectMotionSelectorsType00:", source)
        self.assertIn("ObjectRoomStateMotionSelector $80", source)
        self.assertIn("ObjectMotionVector $40, $68", source)

    def test_rejects_motion_vector_range_past_prg(self) -> None:
        with self.assertRaisesRegex(ValueError, "CPU address outside PRG"):
            decode_motion_vectors(bytes(32_768), 0xFFFF, 1)

    def test_audit_detects_invalid_selector_and_hash(self) -> None:
        report = {
            "object_type_pointers": [0xDA15],
            "selector_count": 1,
            "motion_vector_count": 1,
            "pointer_sha1": "pointers",
            "selector_sha1": "wrong",
            "vector_sha1": "vectors",
            "selector_coverage_exact": True,
            "invalid_direct_selectors": [1],
        }
        manifest = {
            "object_type_pointers": ["0xda15"],
            "selector_count": 1,
            "motion_vector_count": 1,
            "pointer_sha1": "pointers",
            "selector_sha1": "selectors",
            "vector_sha1": "vectors",
        }
        errors = validate_report(report, manifest)
        self.assertEqual(len(errors), 2)
        self.assertTrue(any("selector_sha1 differs" in error for error in errors))
        self.assertTrue(any("exceed" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
