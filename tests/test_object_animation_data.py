from __future__ import annotations

import hashlib
import unittest

from scripts.object_animation_data import (
    collect_report,
    decode_descriptors,
    decode_frame_records,
    decode_words,
    encode_descriptors,
    encode_frame_records,
    encode_words,
    validate_report,
)


class ObjectAnimationDataTests(unittest.TestCase):
    def test_decodes_little_endian_words(self) -> None:
        prg = bytearray(32_768)
        prg[0:6] = bytes((0x2A, 0xD1, 0xBA, 0xD1, 0x1A, 0xD6))
        self.assertEqual(decode_words(bytes(prg), 0x8000, 3), [0xD12A, 0xD1BA, 0xD61A])
        self.assertEqual(encode_words([0xD12A, 0xD1BA, 0xD61A]), prg[0:6])

    def test_decodes_direct_and_variant_descriptors(self) -> None:
        prg = bytearray(32_768)
        prg[0:8] = bytes((0x32, 0x0C, 0x9A, 0xD6, 0x54, 0x05, 0x8A, 0xD6))
        direct, variant = decode_descriptors(bytes(prg), 0x8000, 2)
        self.assertEqual((direct.initial_phase, direct.delay), (0x32, 6))
        self.assertFalse(direct.uses_variants)
        self.assertEqual(direct.data_pointer, 0xD69A)
        self.assertTrue(variant.uses_variants)
        self.assertEqual(variant.data_pointer, 0xD68A)
        self.assertEqual(encode_descriptors([direct, variant]), prg[0:8])

    def test_frame_records_round_trip_without_field_guesses(self) -> None:
        prg = bytearray(32_768)
        prg[0:6] = bytes((0x81, 0x22, 0x43, 0x04, 0x85, 0x66))
        records = decode_frame_records(bytes(prg), 0x8000, 2)
        self.assertEqual(records[0].payload, (0x81, 0x22, 0x43))
        self.assertEqual(encode_frame_records(records), prg[0:6])

    def test_collects_a_minimal_complete_layout(self) -> None:
        prg = bytearray(32_768)
        prg[0:2] = bytes((0x10, 0x80))
        prg[0x10:0x14] = bytes((0x21, 0x04, 0x20, 0x80))
        prg[0x20:0x23] = bytes((0x11, 0x12, 0x03))
        manifest = {
            "object_type_pointers": ["0x8010"],
            "pointer_table_address": "0x8000",
            "definition_data_start": "0x8010",
            "definition_data_end": "0x8013",
            "descriptor_groups": [{"address": "0x8010", "action_count": 1}],
            "variant_selector_addresses": [],
            "frame_data_start": "0x8020",
            "frame_data_end": "0x8022",
            "descriptor_count": 1,
            "frame_sequence_count": 1,
            "frame_record_count": 1,
            "pointer_sha1": hashlib.sha1(prg[0:2]).hexdigest(),
            "definition_sha1": hashlib.sha1(prg[0x10:0x14]).hexdigest(),
            "frame_sha1": hashlib.sha1(prg[0x20:0x23]).hexdigest(),
        }
        report = collect_report(bytes(prg), manifest)
        self.assertEqual(report["object_type_pointers"], [0x8010])
        self.assertEqual(report["frame_sequence_starts"], [0x8020])
        self.assertTrue(report["round_trip"])
        self.assertEqual(report["round_trip_size"], 9)
        self.assertEqual(validate_report(report, manifest), [])

    def test_rejects_descriptor_range_past_prg(self) -> None:
        with self.assertRaisesRegex(ValueError, "CPU address outside PRG"):
            decode_descriptors(bytes(32_768), 0xFFFF, 1)

    def test_audit_detects_changed_hash_and_count(self) -> None:
        report = {
            "object_type_pointers": [0xD12A],
            "descriptor_count": 2,
            "frame_sequence_count": 1,
            "frame_record_count": 1,
            "pointer_sha1": "wrong",
            "definition_sha1": "definitions",
            "frame_sha1": "frames",
            "definition_coverage_exact": True,
            "invalid_variant_references": [],
            "invalid_frame_pointers": [],
            "round_trip": True,
        }
        manifest = {
            "object_type_pointers": ["0xd12a"],
            "descriptor_count": 1,
            "frame_sequence_count": 1,
            "frame_record_count": 1,
            "pointer_sha1": "pointers",
            "definition_sha1": "definitions",
            "frame_sha1": "frames",
        }
        errors = validate_report(report, manifest)
        self.assertEqual(len(errors), 2)
        self.assertTrue(any("descriptor_count differs" in error for error in errors))
        self.assertTrue(any("pointer_sha1 differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
