# Source Reconstruction 1.0

Source Reconstruction 1.0 is the stable, behavior-preserving reconstruction of
the USA NES release of Solomon's Key (`NES-KE-USA`). Its default ca65 build is
byte-identical to the reviewed reference image. The release makes no claim
that present names are the historical names used by Tecmo; it guarantees that
names and comments are evidence-backed, uncertainty is explicit, and the game
can be rebuilt, inspected, traced, and changed at source level.

## Identity and scope

| Property | Value |
| --- | --- |
| Complete ROM SHA-1 | `18102689fd35c7d531a5e6241b06b748accab2f6` |
| PRG SHA-1 | `4e8c6c33897e6c0dc6297f67e8f5699b1b5ca4e6` |
| CHR SHA-1 | `59f98252ca72dd3908964e2ad70aba5dda2e84bf` |
| Mapper | CNROM mapper 3, horizontal mirroring |
| CPU layout | 32 KiB PRG at `$8000-$FFFF` |
| Graphics | Four switchable 8 KiB CHR banks |

The tracked repository contains the complete PRG source, build configuration,
tools, tests, manifests, and documentation. It does not contain the original
ROM or extracted CHR. `make split` derives the private CHR asset from a legally
obtained matching image, and every complete build validates that asset before
use.

Japan and Europe are not source profiles in 1.0. Their distinct PRG revisions,
PAL timing changes, graphics, source conditionals, and independent identity
gates belong to Source Reconstruction 2.0. Region-aware research helpers may
exist in 1.0, but they do not broaden its preservation contract beyond USA.

## Stable contract

- All 32,768 PRG bytes are owned by 160 reviewed semantic modules and are
  classified as code, ordinary data, encoded stream, padding, or vectors.
- No preservation listing, generated address label, or raw numeric control-flow
  target remains.
- The provenance ledger binds every introduced semantic label to its address,
  previous identifier, confidence, and evidence.
- RAM fields, hardware registers, scheduler contexts, object records, room-map
  cells, collision geometry, progression, rendering, and audio arbitration have
  source-level contracts under `docs/`.
- Every stream-classified PRG byte has exactly one decoder/encoder owner. Room,
  PPU, title, animation, motion, and audio formats round-trip against the built
  image.
- Ten deterministic FCEUX scenarios cover cold boot, normal room entry,
  movement, pause/resume, life loss and room reload, both casting paths, room
  completion, scheduler/timer behavior, and audio channel priority. Controlled
  writes are declared in the scenario manifest and checked by the validator.
- ld65 labels, FCEUX symbols, breakpoints, and RAM watches are generated from
  the current source and checked for stale addresses.

Byte identity proves faithful output, not historical intent. Neutral names are
preferred where static data and traces do not justify a stronger interpretation.
Future findings must preserve that distinction and update the provenance or
unknowns registry together with the source.

## Release gates

The normal development gate is:

```text
make check
```

It runs formatting/lint policy, unit tests, full image verification, every
format round trip, the complete PRG classification fingerprint, reconstruction
and subsystem audits, and debugger-symbol validation.

The tag gate is:

```text
make source-1-audit
```

It first runs `make release-check`, including the machine-readable contract in
`config/source_reconstruction_1_0.json`, then freshly captures and validates all
ten runtime scenarios. A previously generated trace cannot satisfy this gate
because `trace-runtime` invokes the emulator for each run before validation.

Passing an individual hash, unit-test, or trace layer is insufficient. The
release manifest cross-checks the immutable ROM identity, exact reconstruction
metrics, ordered runtime scenario list, required documentation, and stable Make
targets so those layers cannot silently drift apart.

## Tag procedure

Merge the reviewed milestone to `main`, run `make source-1-audit` on that exact
commit, and require a clean worktree. Then create the annotated tag
`source-reconstruction-1.0` at the audited `main` commit. Do not tag an
intermediate reconstruction branch.

Behavior-changing work and regional builds begin only after that tag. The
default `make build` and `make verify` commands permanently remain the preserved
USA profile.
