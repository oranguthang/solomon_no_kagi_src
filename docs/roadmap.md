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
semantic modules            49
documented PRG bytes      3647 / 32768 (11.130%)
generated address labels   675
raw control-flow targets   334
preservation lines       10060
```

These are non-regression bounds, not a completion claim. As reconstruction
advances, semantic coverage must increase while the three legacy counts only
decrease.

### 2. Mechanical modularization - In progress

- `$8000-$80FE`: NMI, CNROM bank selection, OAM DMA, and PPU scroll commit are
  isolated in `src/system/nmi.asm`;
- `$837D-$83C1`: both controller ports are serially sampled and merged into
  raw and policy-filtered cached input bytes in `src/system/controller_input.asm`;
- `$863C-$87DF`: the 21-record active-object traversal, signed fixed-point
  motion, six-cell RoomMap collision sampling, and packed animation sequencer
  are isolated as four adjacent modules;
- `$87E0-$8A61`: the object-state gate, 16-entry collision-handler table, all
  mask-specific responses, and shared `$...D` Y clamp are source-owned;
- `$8C00-$8D5E`: reset, warm-boot state, PPU initialization, and scheduler
  bootstrap are isolated in `src/system/startup.asm`;
- `$8D5F-$8E46`: the eight-context cooperative scheduler and its initial
  stack/entry tables are isolated in `src/system/scheduler.asm`;
- `$8A62-$8A7E`: the shared object Y-to-surface clamp is isolated in
  `src/game/object_y_clamp.asm`, with all three calls named;
- `$8A7F-$8AA3`: the left-surface object X clamp and motion reset are isolated
  in `src/game/object_x_left_clamp.asm`, with all three calls named;
- `$8AA4-$8ABF`: the complementary right-surface object X clamp is isolated,
  with all three calls named and the shared motion-clear tail documented;
- `$8AC0-$8B50`: type/action-driven Y/X motion and animation descriptor
  resolution is isolated in `src/game/object_motion_animation.asm`;
- `$8B51-$8B7E`: the NMI-side RoomMap attribute-byte read and stale-request
  timeout are isolated in `src/graphics/ppu_attribute_read.asm`;
- `$8BE2-$8BFF`: Bisqwit's 30-byte `FillerBefore8C00` range is explicitly
  classified in `src/data/pre_startup_padding.asm`;
- `$8E47-$8E8C`: context 2 selector 1's Start-button pause/debounce loop is
  isolated in `src/system/pause_thread.asm`;
- `$8E8D-$8E9F`: the three-slot sound-effect request producer is isolated in
  `src/system/sound_effect_queue.asm`, with all 34 calls named;
- `$8EA0-$8EA8`: the shared RAM PPU update-program publisher is isolated in
  `src/system/ppu_update_buffer.asm`, with all 16 calls named;
- `$8EA9-$8EBF`: the stack-consuming inline appendix tail dispatcher is
  isolated in `src/system/jump_with_params.asm`, with all 11 calls named;
- `$8EC0-$915D`: the room palette template, context-one room-clear flow,
  decimal remaining-time bonus, common room loader, selection tables, and
  new-game state reset are split into seven source-owned modules;
- `$9165-$9189`: inverse cooperative waits yield until selected masked
  zero-page bits clear or become set, with all ten callers named;
- `$918A-$91B8`: both directions of the pixel/packed-room-index conversion are
  isolated in `src/game/coordinate_conversion.asm`, with all 31 calls named;
- `$91B9-$9470`: initial door/key publication, intro UI and data, two-digit
  formatting, room-entry placement, the fifteen-object transition orbit,
  fixed-point scaling, and the quarter-sine table are source-owned;
- `$96DC-$970A`: thirteen direct PPU transfer boundaries use named begin/end
  helpers that coordinate update-stream idleness, rendering, and NMI state;
- `$970B-$97A2`: the room-init path draws the two right columns, two bottom
  rows, and attribute table surrounding the 30x24 room nametable area;
- `$97A3-$97C7`: two repeated PPU_DATA writers and their four source patterns
  are split into separate code/data modules with symbolic pointer operands;
- `$97C8-$99F1`: the runtime room item/header decoder and its constellation,
  timer-rate, and special-room lookup tables are source-owned;
- `$99F2-$9A6C`: room-map initialization computes `E02C + room*48` and expands
  both 24-byte block planes into the bordered 16x14 runtime map;
- `$9A6D-$9C51`: context 1's three Dana action entries handle head collisions,
  consume packed fireball inventory, and create or remove targeted blocks;
- `$9C60-$9DCF`: shared map/object interaction setup, block occupancy handling,
  object-header initialization, and coordinate overlap checks are source-owned;
- `$9DD0-$9F22`: one-cell PPU update construction, NMI attribute-read
  synchronization, and both packed-cell address conversions are source-owned;
- `$9F23-$9FFF`: 221 bytes before the main thread are explicitly classified as
  non-code filler rather than disassembled instructions;
- `$A000-$A04B`: scheduler context 3's main gameplay service loop and queued
  fairy path are isolated in `src/game/main_thread.asm`;
- `$A04C-$A15E`: both Demon Mirror schedules, capacity gating, placeholder
  allocation, cyclic enemy-set decoding, delayed activation, and coordinate
  initialization are isolated as four runtime modules;
- `$A15F-$A225`: countdown arithmetic, decimal borrow propagation, display
  dirty state, and threshold transitions are isolated in `src/game/timer.asm`;
- `$A226-$A237`: the overlapping four-entry BCD threshold table and two timer
  warning PPU streams are isolated with their shared `$A22C` byte preserved;
- `$A238-$A273`: timer digit formatting and NMI update-program construction
  are isolated in `src/game/timer_display.asm`;
- `$A274-$A2DB`: the 17-slot active-enemy movement prepass is isolated in
  `src/game/enemy_movement.asm`;
- `$A2DC-$A30B`: the eligibility scan and per-enemy AI dispatch are isolated
  in `src/game/enemy_ai_dispatch.asm`;
- `$A30C-$A3A3`: the two-row fireball-inventory HUD producer, two-bit slot
  decoding, tile mapping, and reverse-copy command headers are source-owned;
- `$A3A4-$A3D6`: fireball lifetime comparison, expiration, and delayed object
  cleanup are isolated in `src/game/fireball_lifetime.asm`;
- `$A3D7-$A3F7`: parallel AI/object slot initialization and coordinate setup
  are isolated in `src/game/enemy_initialization.asm`;
- `$A3F8-$A44D`: spawn-type decoding and conditional object/AI configuration
  are isolated in `src/game/enemy_type_configuration.asm`;
- `$A44E-$A468`: the directly indexed 27-byte enemy-type flag table is
  isolated in `src/data/enemy_types.asm`;
- `$A469-$A4A5`: selector normalization, inline dispatch, and all 28 handler
  pointers are isolated in `src/game/enemy_ai_handlers.asm`;
- `$A4A6-$A4B2`: the shared current-enemy position-copy helper is isolated in
  `src/game/enemy_position.asm`;
- `$B28A-$B2A1`: the indexed object/AI record pointer resolvers are isolated
  in `src/game/enemy_pointers.asm`, and all 28 call sites use their symbols;
- `$B2A2-$B429`: action dispatch for the `$50-$5B` type family, shared
  `$50-$67` direction helpers, forward map probes, and one/two linked-slot
  allocation paths are source-owned;
- `$B42A-$B445`: the seventeen-entry free enemy-slot allocator and its carry
  return contract are isolated in `src/game/enemy_slot_allocation.asm`;
- `$B446-$B491`: the 17-entry AI and 21-entry object split pointer tables are
  formula-generated and machine-audited in `src/data/enemy_record_pointers.asm`;
- `$B492-$B4B5`: linked enemy slots are retired from both parallel record
  pools by `DeactivateEnemySlot` in `src/game/enemy_deactivation.asm`;
- `$B4B6-$B4C3`: eleven enemy behavior tail-calls retire the dispatcher-
  selected slot through `DeactivateCurrentEnemy`;
- `$B4C4-$B7FF`: the shared room-configured enemy lifetime transition and the
  classified 783-byte filler before context 6 are source-owned;
- `$C23C-$C2A5`: scheduler code `$34` pauses Dana/fireball/enemy updates,
  removes the collected key, runs its door flight, restores object states, and
  restarts main gameplay in the existing key-item module;
- `$C2A6-$C363`: the cooperative key-to-door flight, object template, fixed-
  point integrator, pointer constants, and deliberately overlapping offset
  tables are source-owned in the existing key-item module;
- `$C364-$C385`: five transition callers share one signed two-axis coordinate
  delta builder with an explicit Y-low/Y-high/X-low/X-high output contract;
- `$C386-$C3D3`: all four context-4 item presentation entries, their timed
  common lifecycle, and auxiliary RoomMap cleanup are source-owned in the
  existing item-collision module;
- `$C3D4-$C42D`: the serialized score/inventory/fairy HUD refresh, fairy PPU
  template, and seven-digit leading-zero score formatter are source-owned;
- `$C42E-$C627`: the Dana-centered item classifier, all 29 dispatch pointers,
  bonus and special effects, key/door progression, and exact 556-byte object
  plus enemy-AI pool clear are split into seven semantic modules;
- `$C100-$C23B`: context-5 defeated-enemy processing, both drop tables, and
  the shared deterministic random-state mixer are source-owned;
- `$B800-$BA33`: all 53 context-6 room dispatch entries and the shared scripted
  block/enemy triggers are source-owned;
- `$BA34-$BD93`: the room-index 49 ending sequence, convergence animation,
  randomized object fall, message selection, palette fade, and input handoff
  are source-owned;
- `$BD94-$C0FF`: ending helpers and text, Solomon's Seal reveal state, special
  room position/bitplane tables, and the classified pre-`$C100` filler are
  source-owned;
- `$C628-$C697`: timer items perform four-digit decimal doubling, fivefold
  multiplication, and the fixed `10000`/`05000` assignments;
- `$C698-$C70F`: Scroll Extender, fireball bottles, Fairy Bell, Tzo, and score
  items operate on the packed inventory and confirmed lifetime/score helpers;
- `$C710-$C73A`: item score lookup tables and the shared auxiliary-effect
  initializer are classified as separate data and code modules;
- `$C73B-$C755`: score addition propagates carry across eight unpacked decimal
  digits and is gated by `GameStateFlags` bit 0;
- `$C756-$C789`: six transition paths stop all other secondary contexts and
  clear the pending-start area through one shared reset helper;
- `$C78A-$C980`: scheduler entries `$33`, `$31`, `$35`, and `$16` implement
  the cooperative `TIME OVER` and Dana-death presentations, shared pool
  cleanup, `YOUR GDV` calculation, best-score replacement, and next-thread
  selection;
- `$C981-$C9A6`: the life-loss PPU-mask cycle, `TIME OVER.` stream, and
  patchable post-game result template are source-owned;
- `$C9A7-$C9BC`: the larger `$C78A` transition scene shares one context,
  gameplay-flag, fireball, and sound reset helper across two paths;
- `$C9BD-$CA32`: two public wrappers select descriptor-driven direct PPU
  nametable clears, followed by their three records at `$CA33-$CA3B`;
- classifying `$CA33-$CA3B` as descriptor data removed three false decoded
  instructions and their four apparent control-flow targets from the legacy
  preservation inventory;
- `$CA3C-$CA6D`: two twenty-record state/teardown sweeps bracket
  `LoadObjectPointer`, all using source-owned plus-one pointer table aliases;
- `$CA6E-$CB6E`: scheduler codes `$17`, `$18`, and `$22` own the post-game
  summary/title attract loop, fixed demo-room setup, and duration-driven demo
  input playback with real Start/Select interruption;
- `$CB6F-$CBA5`: three screen-reset paths share a direct PPU helper that fills
  both physical nametables with 960 blank tiles and 64 attribute bytes each;
- `$CBA6-$CD52`: the packed title-data decoder, record/background and logo
  layers, current/best score formatting, best-GDV display, and fixed direct
  PPU patterns are source-owned;
- `$CD53-$CD5E`: all ten direct PPU writers share one latch-reset/address
  helper with an explicit `A:X` input contract;
- `$CD5F-$CEF0`: both packed title streams are classified at their `$7F`
  terminators and source-owned alongside their decoder;
- `$CEF1-$CF34`: the attract demo's two parallel 34-byte duration/controller
  tables are source-owned with count and adjacency assertions;
  - `$D000-$D0E7`: all 58 four-byte logical tile patterns consumed by buffered
    RoomMap cell updates are source-owned and record-count asserted;
  - `$D0E8-$D129`: all 33 object-type animation descriptor pointers are
    source-owned and count asserted;
  - the complete `$D12A-$D9D2` animation definition/frame layout is guarded by
    `make object-animation-audit`: 340 descriptors, four variant selectors,
    126 referenced sequences, 275 frame records, and three reviewed hashes;
    those definitions are now source-owned as readable macro records with
    symbolic pointer relationships;
  - `$D9D3-$DBDE` object motion data is structurally audited as 33 type
    pointers, 20 selector groups, 388 action selectors, and 35 Y/X vectors;
    it is now source-owned as macro records with symbolic group pointers;
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
