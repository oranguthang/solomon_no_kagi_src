# Roadmap

## Preservation baseline (complete)

- reproducible ca65/ld65 build with private extracted CHR;
- exact header/PRG/CHR/file identity manifest;
- strict verify and split commands;
- direct original/build comparisons with region-specific diagnostics;
- local toolchain provenance;
- initial unit-test and lint gates.

## Source reconstruction 1.0

- split the address-ordered PRG preservation module further into system, game,
  rendering, audio, room-data, and vector modules without changing a byte;
- introduce a machine-readable label provenance ledger;
- export Mesen/FCEUX symbols with RAM aliases;
- classify every code/data boundary;
- preserve `make verify` as the release gate.

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
