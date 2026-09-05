from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from scripts.reconstruction_status import (
    collect_metrics,
    collect_provenance_metrics,
    parse_make_targets,
    validate,
    validate_release,
)


class ReconstructionStatusTests(unittest.TestCase):
    def make_release_fixture(
        self,
    ) -> tuple[Path, dict[str, object], dict[str, object]]:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        (root / "assets").mkdir()
        (root / "scenarios").mkdir()
        (root / "docs").mkdir()
        reference = {
            "file_sha1": "rom-sha1",
            "prg_sha1": "prg-sha1",
            "chr_sha1": "chr-sha1",
        }
        (root / "assets" / "manifest.json").write_text(
            json.dumps({"schema_version": 1, "reference_rom": reference}),
            encoding="utf-8",
        )
        (root / "scenarios" / "runtime.json").write_text(
            json.dumps(
                {
                    "schema_version": 1,
                    "rom_sha1": "rom-sha1",
                    "scenarios": [{"id": "boot"}, {"id": "gameplay"}],
                }
            ),
            encoding="utf-8",
        )
        (root / "docs" / "release.md").write_text("release\n", encoding="utf-8")
        (root / "Makefile").write_text(
            "build:\n\t@echo build\nsource-1-audit: build\n",
            encoding="utf-8",
        )
        metrics: dict[str, object] = {
            "documented_prg_bytes": 32768,
            "generated_labels": 0,
        }
        release: dict[str, object] = {
            "schema_version": 1,
            "status": "tag-ready",
            "tag": "source-reconstruction-1.0",
            "asset_manifest": "assets/manifest.json",
            "runtime_manifest": "scenarios/runtime.json",
            "reference": reference,
            "reconstruction_metrics": metrics.copy(),
            "runtime_scenarios": ["boot", "gameplay"],
            "required_documents": ["docs/release.md"],
            "required_make_targets": ["build", "source-1-audit"],
            "deferred_to_2_0": ["regional builds"],
        }
        return root, release, metrics

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

    def test_collects_exact_provenance_confidence_distribution(self) -> None:
        _root, _manifest, ledger, _map, _labels = self.make_fixture()
        ledger["entries"].append(
            {
                "address": "0x8001",
                "previous": "$8001",
                "current": "SecondLabel",
                "confidence": "high",
                "evidence": ["Static evidence"],
            }
        )
        self.assertEqual(
            collect_provenance_metrics(ledger),
            {
                "provenance_entries": 2,
                "confirmed_provenance": 1,
                "high_provenance": 1,
                "tentative_provenance": 0,
                "unknown_provenance": 0,
            },
        )

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

    def test_release_contract_accepts_consistent_manifests(self) -> None:
        root, release, metrics = self.make_release_fixture()
        self.assertEqual(validate_release(root, release, metrics), [])
        self.assertEqual(parse_make_targets(root / "Makefile"), {"build", "source-1-audit"})

    def test_release_contract_detects_metric_and_scenario_drift(self) -> None:
        root, release, metrics = self.make_release_fixture()
        metrics["generated_labels"] = 1
        release["runtime_scenarios"] = ["gameplay", "boot"]
        errors = validate_release(root, release, metrics)
        self.assertTrue(any("generated_labels" in error for error in errors))
        self.assertIn("runtime scenario order differs from release manifest", errors)

    def test_release_contract_requires_declared_files_and_targets(self) -> None:
        root, release, metrics = self.make_release_fixture()
        release["required_documents"] = ["docs/missing.md"]
        release["required_make_targets"] = ["missing-target"]
        errors = validate_release(root, release, metrics)
        self.assertTrue(any("document is missing" in error for error in errors))
        self.assertTrue(any("Make target is missing" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
