from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from scripts.reconstruction_status import collect_metrics, validate


class ReconstructionStatusTests(unittest.TestCase):
    def make_fixture(self) -> tuple[Path, dict[str, object], dict[str, object], Path, Path]:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        (root / "src" / "system").mkdir(parents=True)
        (root / "src" / "preservation").mkdir(parents=True)
        (root / "src" / "system" / "nmi.asm").write_text(
            '.segment "PRG_NMI"\nNMI:\n    RTI\n',
            encoding="utf-8",
        )
        (root / "src" / "preservation" / "prg.asm").write_text(
            "_label_bank0_9000:\n    JSR $9003\n",
            encoding="utf-8",
        )
        manifest: dict[str, object] = {
            "schema_version": 1,
            "reference_prg_size": 32768,
            "original_labels": [],
            "modules": [
                {
                    "id": "nmi",
                    "path": "src/system/nmi.asm",
                    "segment": "PRG_NMI",
                    "start": "0x8000",
                    "end": "0x8000",
                    "status": "semantic",
                    "required_labels": ["NMI"],
                }
            ],
            "thresholds": {
                "minimum_semantic_modules": 1,
                "minimum_documented_prg_bytes": 1,
                "minimum_provenance_entries": 1,
                "maximum_preservation_lines": 2,
                "maximum_generated_labels": 1,
                "maximum_raw_control_flow_targets": 1,
            },
        }
        ledger: dict[str, object] = {
            "schema_version": 1,
            "entries": [
                {
                    "address": "0x8000",
                    "previous": "$8000",
                    "current": "NMI",
                    "confidence": "confirmed",
                    "evidence": ["Vector target"],
                }
            ],
        }
        map_path = root / "game.map"
        map_path.write_text(
            "PRG_NMI              008000  008000  000001  00001\n",
            encoding="utf-8",
        )
        labels_path = root / "game.lbl"
        labels_path.write_text("al 008000 .NMI\n", encoding="utf-8")
        return root, manifest, ledger, map_path, labels_path

    def test_collects_monotonic_progress_metrics(self) -> None:
        root, manifest, _ledger, _map, _labels = self.make_fixture()
        metrics = collect_metrics(root, manifest)
        self.assertEqual(metrics["semantic_modules"], 1)
        self.assertEqual(metrics["documented_prg_bytes"], 1)
        self.assertEqual(metrics["generated_labels"], 1)
        self.assertEqual(metrics["raw_control_flow_targets"], 1)

    def test_accepts_consistent_module_and_provenance(self) -> None:
        root, manifest, ledger, map_path, labels_path = self.make_fixture()
        _metrics, errors = validate(root, manifest, ledger, map_path, labels_path)
        self.assertEqual(errors, [])

    def test_rejects_linked_label_address_mismatch(self) -> None:
        root, manifest, ledger, map_path, labels_path = self.make_fixture()
        labels_path.write_text("al 008001 .NMI\n", encoding="utf-8")
        _metrics, errors = validate(root, manifest, ledger, map_path, labels_path)
        self.assertTrue(any("linked address mismatch" in error for error in errors))

    def test_rejects_semantic_label_without_provenance(self) -> None:
        root, manifest, ledger, map_path, labels_path = self.make_fixture()
        module = root / "src" / "system" / "nmi.asm"
        module.write_text(
            module.read_text(encoding="utf-8") + "UndocumentedName:\n    RTS\n",
            encoding="utf-8",
        )
        _metrics, errors = validate(root, manifest, ledger, map_path, labels_path)
        self.assertIn(
            "semantic label has no provenance entry: UndocumentedName",
            errors,
        )


if __name__ == "__main__":
    unittest.main()
