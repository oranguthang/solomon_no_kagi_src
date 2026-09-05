#!/usr/bin/env python3
"""Measure and audit semantic source-reconstruction progress."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


LABEL_RE = re.compile(r"^([A-Za-z_@.?][A-Za-z0-9_@.?]*):\s*$")
GENERATED_LABEL_RE = re.compile(r"^_label_bank[0-9]+_[0-9a-f]+$")
RAW_FLOW_RE = re.compile(
    r"^\s*(?:BCC|BCS|BEQ|BMI|BNE|BPL|BVC|BVS|JMP|JSR)\s+\$[0-9A-Fa-f]{4}\b"
)
MAP_SEGMENT_RE = re.compile(
    r"^(\S+)\s+([0-9A-Fa-f]{6})\s+([0-9A-Fa-f]{6})\s+([0-9A-Fa-f]{6})\s+[0-9A-Fa-f]{5}\s*$"
)
LABEL_FILE_RE = re.compile(r"^al\s+([0-9A-Fa-f]{6})\s+\.?([^\s]+)\s*$")
MAKE_TARGET_RE = re.compile(r"^([A-Za-z0-9_.-]+)(?:\s+[^:]*)?:")
CONFIDENCE_LEVELS = {"confirmed", "high", "tentative", "unknown"}


@dataclass(frozen=True)
class SourceLabel:
    path: Path
    line: int


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"expected a JSON object: {path}")
    return value


def parse_make_targets(path: Path) -> set[str]:
    targets: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith((" ", "\t", ".")):
            continue
        match = MAKE_TARGET_RE.match(line)
        if match:
            targets.add(match.group(1))
    return targets


def parse_number(value: object, field: str) -> int:
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        try:
            return int(value, 0)
        except ValueError:
            pass
    raise ValueError(f"invalid integer for {field}: {value!r}")


def assembly_paths(project_root: Path) -> list[Path]:
    return sorted(
        (
            path
            for path in (project_root / "src").rglob("*")
            if path.is_file() and path.suffix.lower() in {".asm", ".inc"}
        ),
        key=lambda path: path.as_posix().lower(),
    )


def source_labels(project_root: Path) -> dict[str, SourceLabel]:
    labels: dict[str, SourceLabel] = {}
    for path in assembly_paths(project_root):
        relative = path.relative_to(project_root)
        for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            match = LABEL_RE.match(line)
            if match:
                labels[match.group(1)] = SourceLabel(relative, line_number)
    return labels


def parse_linker_map(path: Path) -> dict[str, tuple[int, int, int]]:
    segments: dict[str, tuple[int, int, int]] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = MAP_SEGMENT_RE.match(line)
        if match:
            segments[match.group(1)] = tuple(
                int(match.group(index), 16) for index in range(2, 5)
            )
    return segments


def parse_label_file(path: Path) -> dict[str, int]:
    labels: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = LABEL_FILE_RE.match(line)
        if match:
            labels[match.group(2)] = int(match.group(1), 16)
    return labels


def collect_metrics(project_root: Path, manifest: dict[str, Any]) -> dict[str, Any]:
    paths = assembly_paths(project_root)
    labels = source_labels(project_root)
    generated = sum(GENERATED_LABEL_RE.fullmatch(name) is not None for name in labels)
    raw_flow = 0
    for path in paths:
        raw_flow += sum(
            RAW_FLOW_RE.match(line) is not None
            for line in path.read_text(encoding="utf-8").splitlines()
        )
    modules = manifest.get("modules", [])
    documented_bytes = sum(
        parse_number(module["end"], f"{module.get('id')}.end")
        - parse_number(module["start"], f"{module.get('id')}.start")
        + 1
        for module in modules
    )
    prg_size = parse_number(manifest.get("reference_prg_size"), "reference_prg_size")
    preservation = project_root / "src" / "preservation" / "prg.asm"
    preservation_lines = (
        len(preservation.read_text(encoding="utf-8").splitlines())
        if preservation.is_file()
        else 0
    )
    return {
        "assembly_files": len(paths),
        "semantic_modules": len(modules),
        "documented_prg_bytes": documented_bytes,
        "documented_prg_percent": round(documented_bytes * 100.0 / prg_size, 3),
        "preservation_lines": preservation_lines,
        "source_labels": len(labels),
        "semantic_labels": len(labels) - generated,
        "generated_labels": generated,
        "raw_control_flow_targets": raw_flow,
    }


def collect_provenance_metrics(ledger: dict[str, Any]) -> dict[str, int]:
    entries = ledger.get("entries")
    if not isinstance(entries, list):
        return {}
    counts = {
        confidence: sum(entry.get("confidence") == confidence for entry in entries)
        for confidence in CONFIDENCE_LEVELS
    }
    return {
        "provenance_entries": len(entries),
        "confirmed_provenance": counts["confirmed"],
        "high_provenance": counts["high"],
        "tentative_provenance": counts["tentative"],
        "unknown_provenance": counts["unknown"],
    }


def validate(
    project_root: Path,
    manifest: dict[str, Any],
    ledger: dict[str, Any],
    map_path: Path,
    labels_path: Path,
) -> tuple[dict[str, Any], list[str]]:
    errors: list[str] = []
    if manifest.get("schema_version") != 1:
        errors.append("unsupported reconstruction manifest schema")
    if ledger.get("schema_version") != 1:
        errors.append("unsupported label provenance schema")
    metrics = collect_metrics(project_root, manifest)
    metrics.update(collect_provenance_metrics(ledger))
    source = source_labels(project_root)
    segments = parse_linker_map(map_path)
    linked_labels = parse_label_file(labels_path)

    modules = manifest.get("modules")
    if not isinstance(modules, list):
        return metrics, errors + ["modules must be a list"]
    for module in modules:
        module_id = str(module.get("id", "<missing>"))
        relative = Path(str(module.get("path", "")))
        module_path = project_root / relative
        if not module_path.is_file():
            errors.append(f"module {module_id} is missing: {relative.as_posix()}")
            continue
        segment_name = str(module.get("segment", ""))
        expected_start = parse_number(module.get("start"), f"{module_id}.start")
        expected_end = parse_number(module.get("end"), f"{module_id}.end")
        expected_size = expected_end - expected_start + 1
        actual_segment = segments.get(segment_name)
        if actual_segment != (expected_start, expected_end, expected_size):
            errors.append(
                f"module {module_id} segment mismatch: expected "
                f"{expected_start:04X}-{expected_end:04X}/{expected_size:04X}, "
                f"got {actual_segment}"
            )
        for label in module.get("required_labels", []):
            location = source.get(str(label))
            if location is None or location.path != relative:
                errors.append(f"module {module_id} is missing required label {label}")

    entries = ledger.get("entries")
    if not isinstance(entries, list):
        return metrics, errors + ["provenance entries must be a list"]
    seen_addresses: set[int] = set()
    seen_names: set[str] = set()
    for entry in entries:
        current = str(entry.get("current", ""))
        address = parse_number(entry.get("address"), f"{current}.address")
        if address in seen_addresses:
            errors.append(f"duplicate provenance address: {address:04X}")
        if current in seen_names:
            errors.append(f"duplicate provenance name: {current}")
        seen_addresses.add(address)
        seen_names.add(current)
        if not entry.get("previous"):
            errors.append(f"provenance entry {current} has no previous identifier")
        if entry.get("confidence") not in CONFIDENCE_LEVELS:
            errors.append(f"provenance entry {current} has invalid confidence")
        evidence = entry.get("evidence")
        if not isinstance(evidence, list) or not evidence:
            errors.append(f"provenance entry {current} has no evidence")
        if current not in source:
            errors.append(f"provenance label is absent from source: {current}")
        if linked_labels.get(current) != address:
            errors.append(
                f"linked address mismatch for {current}: expected {address:04X}, "
                f"got {linked_labels.get(current)}"
            )

    original_labels = manifest.get("original_labels", [])
    if not isinstance(original_labels, list) or not all(
        isinstance(label, str) for label in original_labels
    ):
        errors.append("original_labels must be a list of strings")
        original_labels = []
    semantic_paths = {
        Path(str(module.get("path", "")))
        for module in modules
        if module.get("status") == "semantic"
    }
    for name, location in sorted(source.items()):
        if (
            location.path in semantic_paths
            and GENERATED_LABEL_RE.fullmatch(name) is None
            and name not in original_labels
            and name not in seen_names
        ):
            errors.append(f"semantic label has no provenance entry: {name}")
    for name in original_labels:
        location = source.get(name)
        if location is None or location.path not in semantic_paths:
            errors.append(f"declared original label is absent from semantic modules: {name}")

    thresholds = manifest.get("thresholds", {})
    minimums = {
        "minimum_semantic_modules": "semantic_modules",
        "minimum_documented_prg_bytes": "documented_prg_bytes",
        "minimum_provenance_entries": None,
    }
    for threshold_name, metric_name in minimums.items():
        expected = parse_number(thresholds.get(threshold_name), threshold_name)
        actual = len(entries) if metric_name is None else metrics[metric_name]
        if actual < expected:
            errors.append(f"{threshold_name} regression: got {actual}, require at least {expected}")
    maximums = {
        "maximum_preservation_lines": "preservation_lines",
        "maximum_generated_labels": "generated_labels",
        "maximum_raw_control_flow_targets": "raw_control_flow_targets",
    }
    for threshold_name, metric_name in maximums.items():
        expected = parse_number(thresholds.get(threshold_name), threshold_name)
        actual = metrics[metric_name]
        if actual > expected:
            errors.append(f"{threshold_name} regression: got {actual}, allow at most {expected}")
    return metrics, errors


def validate_release_paths(
    project_root: Path, release: dict[str, Any]
) -> list[str]:
    errors: list[str] = []
    documents = release.get("required_documents")
    if not isinstance(documents, list) or not all(
        isinstance(value, str) for value in documents
    ):
        errors.append("required_documents must be a list of paths")
    else:
        for relative in documents:
            if not (project_root / relative).is_file():
                errors.append(f"required release document is missing: {relative}")

    targets = release.get("required_make_targets")
    if not isinstance(targets, list) or not all(
        isinstance(value, str) for value in targets
    ):
        errors.append("required_make_targets must be a list of names")
    else:
        makefile_targets = parse_make_targets(project_root / "Makefile")
        for target in targets:
            if target not in makefile_targets:
                errors.append(f"required Make target is missing: {target}")

    deferred = release.get("deferred_to_2_0")
    if not isinstance(deferred, list) or not deferred:
        errors.append("deferred_to_2_0 must explicitly record later scope")
    return errors


def validate_release(
    project_root: Path,
    release: dict[str, Any],
    metrics: dict[str, Any],
) -> list[str]:
    errors: list[str] = []
    if release.get("schema_version") != 1:
        errors.append("unsupported Source Reconstruction 1.0 manifest schema")
    if release.get("status") != "tag-ready":
        errors.append("Source Reconstruction 1.0 status is not tag-ready")
    if release.get("tag") != "source-reconstruction-1.0":
        errors.append("Source Reconstruction 1.0 tag name differs")

    asset_path = project_root / str(release.get("asset_manifest", ""))
    runtime_path = project_root / str(release.get("runtime_manifest", ""))
    assets = load_json(asset_path)
    runtime = load_json(runtime_path)
    if assets.get("schema_version") != 1:
        errors.append("unsupported asset manifest schema")
    if runtime.get("schema_version") != 1:
        errors.append("unsupported runtime manifest schema")

    reference = release.get("reference")
    asset_reference = assets.get("reference_rom")
    if not isinstance(reference, dict) or not isinstance(asset_reference, dict):
        errors.append("release and asset reference contracts must be objects")
    else:
        for field in ("file_sha1", "prg_sha1", "chr_sha1"):
            if reference.get(field) != asset_reference.get(field):
                errors.append(f"release {field} differs from asset manifest")
        if runtime.get("rom_sha1") != reference.get("file_sha1"):
            errors.append("runtime ROM SHA-1 differs from release reference")

    expected_metrics = release.get("reconstruction_metrics")
    if not isinstance(expected_metrics, dict):
        errors.append("reconstruction_metrics must be an object")
    else:
        for name, expected in expected_metrics.items():
            if metrics.get(name) != expected:
                errors.append(
                    f"release metric {name} differs: "
                    f"expected {expected}, got {metrics.get(name)}"
                )

    expected_scenarios = release.get("runtime_scenarios")
    actual_scenarios = runtime.get("scenarios")
    if not isinstance(expected_scenarios, list) or not all(
        isinstance(value, str) for value in expected_scenarios
    ):
        errors.append("runtime_scenarios must be a list of names")
    elif not isinstance(actual_scenarios, list):
        errors.append("runtime scenario manifest has no scenario list")
    else:
        actual_names = [scenario.get("id") for scenario in actual_scenarios]
        if actual_names != expected_scenarios:
            errors.append("runtime scenario order differs from release manifest")

    errors.extend(validate_release_paths(project_root, release))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("report", "audit", "release-audit"))
    parser.add_argument("--project-root", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--ledger", type=Path)
    parser.add_argument("--map", dest="map_path", type=Path)
    parser.add_argument("--labels", type=Path)
    parser.add_argument("--release", type=Path)
    args = parser.parse_args()
    root = args.project_root.resolve()
    manifest_path = args.manifest or root / "config" / "reconstruction.json"
    ledger_path = args.ledger or root / "docs" / "provenance" / "label_renames.json"
    map_path = args.map_path or root / "build" / "native" / "solomons_key.map"
    labels_path = args.labels or root / "build" / "native" / "solomons_key.lbl"
    release_path = args.release or root / "config" / "source_reconstruction_1_0.json"
    try:
        manifest = load_json(manifest_path)
        ledger = load_json(ledger_path)
        if args.command == "report":
            metrics = collect_metrics(root, manifest)
            metrics.update(collect_provenance_metrics(ledger))
            print(json.dumps(metrics, indent=2, sort_keys=True))
            return 0
        metrics, errors = validate(root, manifest, ledger, map_path, labels_path)
        if args.command == "release-audit":
            release = load_json(release_path)
            errors.extend(validate_release(root, release, metrics))
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    if errors:
        for error in errors:
            print(f"[ERROR] {error}", file=sys.stderr)
        print(f"[FAIL] Reconstruction audit found {len(errors)} error(s)", file=sys.stderr)
        return 1
    if args.command == "release-audit":
        print(
            "[OK] Source Reconstruction 1.0 contract: "
            f"{metrics['semantic_modules']} modules, "
            f"{metrics['documented_prg_bytes']} PRG bytes, "
            f"{metrics['semantic_labels']} semantic labels, "
            f"{metrics['provenance_entries']} provenance entries"
        )
    else:
        print(
            "[OK] Reconstruction inventory: "
            f"{metrics['semantic_modules']} semantic module, "
            f"{metrics['documented_prg_bytes']}/{manifest['reference_prg_size']} "
            f"PRG bytes ({metrics['documented_prg_percent']:.3f}%), "
            f"{metrics['generated_labels']} generated labels, "
            f"{metrics['raw_control_flow_targets']} raw control-flow targets"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
