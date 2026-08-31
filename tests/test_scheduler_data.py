from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from scripts.scheduler_data import (
    INITIAL_STACK_POINTERS,
    THREAD_ENTRY_TABLE_BASES,
    decode_thread_code,
    discover_start_calls,
    prg_offset,
    validate_report,
)


class SchedulerDataTests(unittest.TestCase):
    def test_decodes_packed_thread_code(self) -> None:
        prg = bytearray(32_768)
        base = 0x9000
        prg[prg_offset(THREAD_ENTRY_TABLE_BASES + 2) : prg_offset(THREAD_ENTRY_TABLE_BASES + 2) + 2] = bytes((0x00, 0x90))
        prg[prg_offset(base + 6) : prg_offset(base + 8)] = bytes((0x34, 0xA2))
        self.assertEqual(
            decode_thread_code(bytes(prg), 0x13),
            {
                "code": 0x13,
                "context": 1,
                "selector": 3,
                "base": 0x9000,
                "pointer_address": 0x9006,
                "return_address": 0xA234,
                "entry": 0xA235,
            },
        )

    def test_discovers_immediate_and_dynamic_calls(self) -> None:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        (root / "src").mkdir()
        (root / "src" / "main.asm").write_text(
            "    LDA #$17\n    JSR StartThread\n    TXA\n    JSR StartThread\n",
            encoding="utf-8",
        )
        static, dynamic = discover_start_calls(root)
        self.assertEqual([call["code"] for call in static], [0x17])
        self.assertEqual(len(dynamic), 1)

    def test_table_addresses_are_inside_prg(self) -> None:
        self.assertEqual(prg_offset(INITIAL_STACK_POINTERS), 0x0E01)
        self.assertEqual(prg_offset(THREAD_ENTRY_TABLE_BASES), 0x0E09)

    def test_audit_accepts_registered_entry_and_counts(self) -> None:
        entry = {
            "code": 0x30,
            "context": 3,
            "selector": 0,
            "base": 0x8E2F,
            "pointer_address": 0x8E2F,
            "return_address": 0x9FFF,
            "entry": 0xA000,
        }
        report = {
            "initial_stack_pointers": [0xFC, 0xDC, 0xBC, 0x9C, 0x7C, 0x5C, 0x3C, 0x1C],
            "static_call_count": 2,
            "dynamic_call_count": 1,
            "entries": [entry],
        }
        manifest = {
            "initial_stack_pointers": report["initial_stack_pointers"],
            "static_call_count": 2,
            "dynamic_call_count": 1,
            "static_entries": [entry],
        }
        self.assertEqual(validate_report(report, manifest), [])

    def test_audit_rejects_changed_entry(self) -> None:
        report = {
            "initial_stack_pointers": [0xFC],
            "static_call_count": 1,
            "dynamic_call_count": 0,
            "entries": [{
                "code": 0x30,
                "context": 3,
                "selector": 0,
                "base": 0x8E2F,
                "pointer_address": 0x8E2F,
                "return_address": 0x9FFF,
                "entry": 0xA000,
            }],
        }
        manifest = {
            "initial_stack_pointers": [0xFC],
            "static_call_count": 1,
            "dynamic_call_count": 0,
            "static_entries": [{**report["entries"][0], "entry": 0xA001}],
        }
        errors = validate_report(report, manifest)
        self.assertTrue(any("entry differs" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
