# Roadmap

## Preservation baseline (complete)

- reproducible ca65/ld65 build with private extracted CHR;
- exact header/PRG/CHR/file identity manifest;
- strict verify and split commands;
- direct original/build comparisons with region-specific diagnostics;
- local toolchain provenance;
- initial unit-test and lint gates.

## Source reconstruction 1.0

### 0. Reproducible preservation baseline - Complete

- byte-identical ca65/ld65 build;
- private CHR extraction and manifest identity;
- layered lint, tests, room validation, and complete ROM comparison.

### 1. Measured reconstruction inventory - Complete

`config/reconstruction.json` records semantic module ranges and monotonic
cleanup thresholds. `make reconstruction-status` reports current progress;
`make reconstruction-audit` checks module ranges against the linker map and
accepted names against `docs/provenance/label_renames.json` and the ld65 label
file. The audit is part of `make release-check`.

Accepted baseline after the first split:

```text
semantic modules             9
documented PRG bytes      1376 / 32768 (4.199%)
generated address labels   761
raw control-flow targets   597
preservation lines       11276
```

These are non-regression bounds, not a completion claim. As reconstruction
advances, semantic coverage must increase while the three legacy counts only
decrease.

### 2. Mechanical modularization - In progress

- `$8000-$80FE`: NMI, CNROM bank selection, OAM DMA, and PPU scroll commit are
  isolated in `src/system/nmi.asm`;
- `$8C00-$8D5E`: reset, warm-boot state, PPU initialization, and scheduler
  bootstrap are isolated in `src/system/startup.asm`;
- `$8D5F-$8E46`: the eight-context cooperative scheduler and its initial
  stack/entry tables are isolated in `src/system/scheduler.asm`;
- `$A000-$A04B`: scheduler context 3's main gameplay service loop and queued
  fairy path are isolated in `src/game/main_thread.asm`;
- `$A15F-$A225`: countdown arithmetic, decimal borrow propagation, display
  dirty state, and threshold transitions are isolated in `src/game/timer.asm`;
- `$A238-$A273`: timer digit formatting and NMI update-program construction
  are isolated in `src/game/timer_display.asm`;
- `$A274-$A2DB`: the 17-slot active-enemy movement prepass is isolated in
  `src/game/enemy_movement.asm`;
- `$A2DC-$A30B`: the eligibility scan and per-enemy AI dispatch are isolated
  in `src/game/enemy_ai_dispatch.asm`;
- `$A3A4-$A3D6`: fireball lifetime comparison, expiration, and delayed object
  cleanup are isolated in `src/game/fireball_lifetime.asm`;
- split the remaining preservation range into reset/startup, scheduler, room,
  gameplay/object, rendering, audio, static-data, and vector modules at proven
  code/data boundaries;
- preserve address order and `make verify` after every split.

### 3. Semantic naming and provenance - In progress

- every accepted ROM-label rename enters the machine-readable provenance
  ledger with address, confidence, and evidence;
- replace generated labels and raw control-flow targets only when static or
  runtime evidence supports a behavioral name;
- export debugger symbols with the confirmed RAM aliases.

### 4. Code/data boundary classification - Planned

- classify every PRG byte as code, table, stream, padding, vector, or unresolved;
- ensure no instruction decoder silently consumes embedded data;
- expose coverage through the reconstruction audit.

### 5. Subsystem documentation and runtime evidence - Planned

- document contracts for reset, scheduler, room loading, objects, collision,
  rendering, audio, and progression;
- add deterministic emulator scenarios that bind runtime behavior to semantic
  source symbols.

### 6. Data-format round trips - In progress

- `make roundtrip-formats` now decodes and re-encodes all 53 block-plane
  records, enemy streams, item metadata/command streams, and their two split
  pointer tables, comparing 4,824 encoded bytes with the built PRG;
- mirror schedules, mirror enemy sets, graphics metadata, audio, and other
  discovered streams remain to be specified and added to the same gate.

### 7. Source Reconstruction 1.0 release - Planned

Release only when the fixed PRG is entirely owned by reviewed semantic modules,
all code/data boundaries are classified, required runtime scenarios and format
round trips pass, unknowns are explicitly registered, and one aggregate audit
proves the full contract.

## Semantic reconstruction 2.0

- full scheduler and object lifecycle documentation;
- room decode/encode round trips for all 53 rooms;
- object, enemy, item, and collision dispatch tables;
- deterministic runtime scenarios for movement, casting, room completion, and
  scheduler-sensitive timing;
- region profiles for Japanese and European releases.

Castle Excellent / Castlequest research is related but intentionally outside
this repository's byte-identity contract. It should receive its own project so
that engines, platforms, and evidence do not become conflated.
