#!/usr/bin/env python3
"""Build-support commands for the Solomon's Key preservation project."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import sys
import zlib


ROOT = Path(__file__).resolve().parent.parent


class ProjectError(ValueError):
    """A validation error that should be shown without a traceback."""


def digest(data: bytes, algorithm: str = "sha1") -> str:
    return hashlib.new(algorithm, data).hexdigest()


def crc32(data: bytes) -> str:
    return f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def parse_number(value: object, field: str) -> int:
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        try:
            return int(value, 0)
        except ValueError:
            pass
    raise ProjectError(f"invalid integer for {field}: {value!r}")


def load_manifest(path: Path) -> dict[str, object]:
    try:
        manifest = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ProjectError(f"cannot read manifest {path}: {exc}") from exc
    if manifest.get("schema_version") != 1:
        raise ProjectError("unsupported manifest schema")
    return manifest


def parse_ines(data: bytes) -> dict[str, object]:
    if len(data) < 16 or data[:4] != b"NES\x1a":
        raise ProjectError("image is not an iNES ROM")
    trainer_size = 512 if data[6] & 0x04 else 0
    prg_size = data[4] * 16_384
    chr_size = data[5] * 8_192
    prg_start = 16 + trainer_size
    chr_start = prg_start + prg_size
    expected_size = chr_start + chr_size
    if len(data) != expected_size:
        raise ProjectError(
            f"image size is {len(data)}, expected exactly {expected_size}"
        )
    return {
        "header": data[:prg_start],
        "prg": data[prg_start:chr_start],
        "chr": data[chr_start:],
        "payload": data[prg_start:],
        "trainer_size": trainer_size,
        "prg_size": prg_size,
        "chr_size": chr_size,
        "mapper": (data[6] >> 4) | (data[7] & 0xF0),
        "mirroring": "vertical" if data[6] & 0x01 else "horizontal",
    }


def validate_image(data: bytes, manifest: dict[str, object]) -> dict[str, object]:
    reference = manifest.get("reference_rom")
    if not isinstance(reference, dict):
        raise ProjectError("manifest has no reference_rom object")
    parsed = parse_ines(data)
    checks = {
        "file_size": len(data),
        "file_sha1": digest(data),
        "file_md5": digest(data, "md5"),
        "file_crc32": crc32(data),
        "payload_sha1": digest(parsed["payload"]),
        "payload_crc32": crc32(parsed["payload"]),
        "header_sha1": digest(parsed["header"]),
        "prg_sha1": digest(parsed["prg"]),
        "prg_crc32": crc32(parsed["prg"]),
        "chr_sha1": digest(parsed["chr"]),
        "chr_crc32": crc32(parsed["chr"]),
        "trainer_size": parsed["trainer_size"],
        "prg_size": parsed["prg_size"],
        "chr_size": parsed["chr_size"],
        "mapper": parsed["mapper"],
        "mirroring": parsed["mirroring"],
    }
    for field, actual in checks.items():
        expected = reference.get(field)
        if isinstance(actual, int):
            expected = parse_number(expected, field)
        elif isinstance(expected, str):
            expected = expected.lower()
        if actual != expected:
            raise ProjectError(
                f"{field} mismatch: got {actual!r}, expected {expected!r}"
            )
    return parsed


def safe_asset_path(root: Path, relative: str) -> Path:
    posix = PurePosixPath(relative)
    if posix.is_absolute() or not posix.parts or ".." in posix.parts:
        raise ProjectError(f"unsafe asset path: {relative!r}")
    destination = root.joinpath(*posix.parts)
    try:
        destination.resolve().relative_to(root.resolve())
    except ValueError as exc:
        raise ProjectError(f"asset path escapes output directory: {relative!r}") from exc
    return destination


def write_if_changed(path: Path, data: bytes) -> str:
    if path.is_file() and path.read_bytes() == data:
        return "OK"
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_bytes(data)
    os.replace(temporary, path)
    return "WRITE"


def command_verify(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"image not found: {image}")
    manifest = load_manifest(Path(args.manifest))
    validate_image(image.read_bytes(), manifest)
    print(f"[OK] byte-identical Solomon's Key image: {image}")


def command_split(args: argparse.Namespace) -> None:
    image = Path(args.image)
    if not image.is_file():
        raise ProjectError(f"reference ROM not found: {image}")
    manifest = load_manifest(Path(args.manifest))
    parsed = validate_image(image.read_bytes(), manifest)
    assets = manifest.get("extracted_assets")
    if not isinstance(assets, list):
        raise ProjectError("manifest has no extracted_assets list")
    output_root = Path(args.output_dir)
    for entry in assets:
        if not isinstance(entry, dict):
            raise ProjectError("invalid asset entry")
        region = str(entry.get("region", ""))
        if region not in ("header", "prg", "chr"):
            raise ProjectError(f"unsupported asset region: {region!r}")
        payload = parsed[region]
        expected_size = parse_number(entry.get("size"), f"{region}.size")
        expected_sha1 = str(entry.get("sha1", "")).lower()
        if len(payload) != expected_size or digest(payload) != expected_sha1:
            raise ProjectError(f"manifest does not describe extracted {region}")
        destination = safe_asset_path(output_root, str(entry.get("path", "")))
        action = write_if_changed(destination, payload)
        print(f"[{action}] {destination} ({len(payload)} bytes)")


def command_mkdir(args: argparse.Namespace) -> None:
    Path(args.path).mkdir(parents=True, exist_ok=True)


def command_require(args: argparse.Namespace) -> None:
    path = Path(args.path)
    if not path.is_file():
        raise ProjectError(f"required generated asset not found: {path}; {args.hint}")


def command_clean(args: argparse.Namespace) -> None:
    target = Path(args.path).resolve()
    build_root = (ROOT / "build").resolve()
    if target != build_root and build_root not in target.parents:
        raise ProjectError(f"refusing to clean outside {build_root}: {target}")
    if target.exists():
        shutil.rmtree(target)
        print(f"[CLEAN] {target}")


def command_lint(_args: argparse.Namespace) -> None:
    required = (
        "README.md",
        "Makefile",
        "assets/manifest.json",
        "config/linker/cnrom.cfg",
        "docs/code_quality.md",
        "scripts/asm_style.py",
        "scripts/verify_rom.py",
        "src/main.asm",
    )
    missing = [name for name in required if not (ROOT / name).is_file()]
    if missing:
        raise ProjectError("missing project files: " + ", ".join(missing))
    load_manifest(ROOT / "assets/manifest.json")
    for relative in (
        "config/debugger_watches.json",
        "config/debugger_breakpoints.json",
    ):
        try:
            debug_config = json.loads((ROOT / relative).read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise ProjectError(f"cannot read {relative}: {exc}") from exc
        if debug_config.get("schema_version") != 1:
            raise ProjectError(f"unsupported schema in {relative}")
    source_contract = {
        "src/main.asm": ('.setcpu "6502x"', '.segment "HEADER"'),
        "src/preservation/prg.asm": ('.segment "PRG_BANK_0"',),
        "src/graphics/chr.asm": (
            '.segment "PRG_BANK_1"',
            '.incbin "../../assets/generated/chr/solomons_key.chr"',
        ),
    }
    for relative, markers in source_contract.items():
        path = ROOT / relative
        if not path.is_file():
            raise ProjectError(f"missing source module: {relative}")
        source = path.read_text(encoding="utf-8")
        for marker in markers:
            if marker not in source:
                raise ProjectError(f"{relative} is missing required marker: {marker}")
    try:
        tracked = subprocess.run(
            ["git", "ls-files", "*.nes", "*.chr", "*.prg", "*.o"],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.splitlines()
    except (OSError, subprocess.CalledProcessError) as exc:
        raise ProjectError(f"cannot inspect tracked binary files: {exc}") from exc
    if tracked:
        raise ProjectError("ROM/build binaries must not be tracked: " + ", ".join(tracked))
    print("[OK] project structure, manifest, source contract, and binary policy")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    verify = subparsers.add_parser("verify", help="verify a complete built image")
    verify.add_argument("--image", required=True)
    verify.add_argument("--manifest", required=True)
    verify.set_defaults(handler=command_verify)

    split = subparsers.add_parser("split", help="validate and split a reference ROM")
    split.add_argument("--image", required=True)
    split.add_argument("--manifest", required=True)
    split.add_argument("--output-dir", required=True)
    split.set_defaults(handler=command_split)

    mkdir = subparsers.add_parser("mkdir", help="create a build directory")
    mkdir.add_argument("--path", required=True)
    mkdir.set_defaults(handler=command_mkdir)

    require = subparsers.add_parser("require", help="require a generated asset")
    require.add_argument("--path", required=True)
    require.add_argument("--hint", required=True)
    require.set_defaults(handler=command_require)

    clean = subparsers.add_parser("clean", help="remove a path below build/")
    clean.add_argument("--path", required=True)
    clean.set_defaults(handler=command_clean)

    lint = subparsers.add_parser("lint", help="check the repository contract")
    lint.set_defaults(handler=command_lint)
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        args.handler(args)
    except ProjectError as exc:
        print(f"[ERROR] {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
