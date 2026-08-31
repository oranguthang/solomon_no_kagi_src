# Solomon's Key NES Disassembly

A byte-identical ca65 reconstruction and reverse-engineering workspace for the
USA NES release of **Solomon's Key** (`NES-KE-USA`). The project follows the
preservation-first structure of the sibling `smb1_src` repository: a stable
baseline, explicit ROM identity, reproducible build artifacts, documented
evidence, and small tested tools for decoded game data.

## Current status

- The complete 65,552-byte iNES image assembles byte-for-byte.
- `make verify` checks the header, PRG, CHR, complete payload, and complete file.
- The address-ordered PRG source is included by a small `src/main.asm`
  entrypoint; CHR is a private generated asset and is not stored in Git.
- Confirmed NES registers and high-confidence RAM aliases are separated into
  `src/memory/`.
- Forty-nine semantic PRG modules own NMI (`$8000-$80FE`), controller input
  (`$837D-$83C1`), reset/startup
  (`$8C00-$8D5E`), the cooperative scheduler (`$8D5F-$8E46`), and the main
  gameplay thread (`$A000-$A04B`), plus countdown timer arithmetic and warning
  transitions (`$A15F-$A225`), its HUD update builder (`$A238-$A273`), and
  the enemy movement prepass (`$A274-$A2DB`) plus AI dispatcher
  (`$A2DC-$A30B`), and fireball lifetime service (`$A3A4-$A3D6`).
  Enemy slot position/state initialization owns `$A3D7-$A3F7`, followed by
  type-specific object/AI configuration at `$A3F8-$A44D` and its table at
  `$A44E-$A468`. The inline 28-entry enemy AI handler dispatcher owns
  `$A469-$A4A5`, followed by its shared position-copy helper at
  `$A4A6-$A4B2`. Shared object/AI record pointer helpers own `$B28A-$B2A1`,
  the free-slot allocator owns `$B42A-$B445`, their split pointer tables own
  `$B446-$B491`, and slot deactivation owns `$B492-$B4B5`.
  Current-record deactivation follows at `$B4B6-$B4C3`.
  Timer multiplication and fixed-value item handlers own `$C628-$C697`.
  Inventory and related item handlers continue through `$C70F`.
  Item score lookup tables and auxiliary-effect initialization own
  `$C710-$C73A`.
  Shared score addition owns `$C73B-$C755`.
  Secondary-context transition reset owns `$C756-$C789`.
  Shared room-transition state reset owns `$C9A7-$C9BC`.
  Direct PPU nametable clearing and its descriptor table own `$C9BD-$CA3B`.
  Non-Dana object-pool state and teardown sweeps own `$CA3C-$CA4E` and
  `$CA5A-$CA6D`, around the pointer resolver at `$CA4F-$CA59`.
  Full clearing of both physical nametables owns `$CB6F-$CBA5`.
  The common PPU latch/address writer owns `$CD53-$CD5E`.
  Pixel/room-map conversion owns `$918A-$91B8` and all 31 callers use symbols.
  Direct CPU-to-PPU transfer state owns `$96DC-$970A` and all 13 boundary calls
  use symbols.
  The 30x24 room nametable frame renderer owns `$970B-$97A2`.
  Repeated PPU writers and four source patterns own `$97A3-$97C7`.
  Runtime room item/header decoding and its tables own `$97C8-$99F1`.
  Room-map initialization and fixed block-plane expansion own `$99F2-$9A6C`.
  Object surface clamps own `$8A62-$8AA3`.
  Context 2's pause loop owns `$8E47-$8E8C`, the sound-effect request queue
  owns `$8E8D-$8E9F`, shared PPU-buffer publication owns `$8EA0-$8EA8`, and
  the inline appendix dispatcher is source-owned at `$8EA9-$8EBF`.
  Cooperative masked-RAM waits own `$9165-$9189`.
- `make reconstruction-status` reports monotonic cleanup metrics, while
  `make reconstruction-audit` binds module ranges and renamed labels to linker
  output.
- `scripts/room_data.py` decodes the block planes, enemy streams, item streams,
  and ten-byte metadata headers for all 53 room records.
- Architecture, RAM, room formats, provenance, naming policy, and unknowns are
  recorded under `docs/`.
- Initial Mesen watches and breakpoints live under `config/` with a trace
  workflow in `docs/debugger_workflow.md`.

The preservation source is not yet a fully semantic modular disassembly.
Most operands and generated labels still use raw addresses. The byte-identical
baseline is intentionally frozen first; semantic renames and subsystem splits
can now proceed behind a permanent verification gate.

## Reference image

The baseline is exactly:

```text
Solomon's Key (USA)
File size  65,552 bytes
File SHA-1 18102689fd35c7d531a5e6241b06b748accab2f6
ROM CRC32  40684e95 (headerless PRG + CHR)
Mapper     3 (CNROM), horizontal mirroring
PRG        32 KiB, loaded at $8000-$FFFF
CHR        32 KiB, four switchable 8 KiB banks
```

The full identity contract is in `assets/manifest.json`. ROM files and locally
extracted assets are ignored by Git.

## Building

On Windows, the repository includes matched ca65/ld65 2.19 executables:

```bash
make build
make verify
```

The build produces the ROM, listing, labels, linker map, and debug records in
`build/native/`. `make verify` validates the original and built images
independently against the manifest, then compares the header, PRG, CHR,
headerless payload, complete file, and extracted CHR asset byte-for-byte.
Mismatch diagnostics include the first differing file/region offset and a CPU
address for PRG differences.

Before the first build, place a legally obtained matching image outside Git and
extract its CHR payload with:

```bash
make split
```

The default filename is `Solomon's Key (U) [!].nes`. Override it when needed:

```bash
make split REFERENCE_ROM="path/to/Solomon's Key (USA).nes"
```

This validates the complete image plus its header, PRG, and CHR identities,
then writes only the ignored `assets/generated/chr/solomons_key.chr`. Builds
fail with a focused instruction if this private asset is absent.

## Useful targets

```bash
make build       # assemble and link the complete iNES image
make verify      # complete original-vs-build byte-identity contract
make verify-prg  # compare only the 32 KiB PRG region
make verify-chr  # compare only the 32 KiB CHR region in built/original ROMs
make verify-assets # compare extracted CHR directly with the original
make rom-info    # print sizes, SHA-1, CRC32, mapper, and mirroring
make format      # normalize ca65 source and run every linter
make format-check # check ca65 formatting without changing files
make lint        # validate assembly style, repository, and source contracts
make lint-source # validate manifests, includes, and tracked-binary policy
make test        # run Python unit tests
make quality-check # lint and test without requiring a reference ROM
make reconstruction-status # report semantic coverage and remaining raw source
make reconstruction-audit # validate module ranges, provenance, and thresholds
make scheduler-report # decode scheduler stack and entry tables as JSON
make scheduler-audit # check static/reviewed dynamic entries and call inventory
make enemy-ai-report # decode the 28-entry AI handler appendix
make enemy-ai-audit # compare every handler pointer with its reviewed manifest
make enemy-pointer-report # decode the split object/AI record pointer tables
make enemy-pointer-audit # verify pointer bases, strides, and counts
make roundtrip-formats # decode and re-encode all 53 room-data records
make release-check # complete static, test, identity, and room-data gate
make check       # alias for release-check
make rooms       # decode all 53 rooms as JSON
make validate-rooms # structurally decode every room without JSON output
make clean       # remove build artifacts only
```

Focused identity targets also include `verify-reference`, `verify-built`,
`verify-header`, `verify-payload`, and `verify-rom`. See
`docs/verification.md` for their exact contracts.

To inspect one room without emitting all room records:

```bash
python scripts/room_data.py --image build/native/solomons_key.nes --room 1 --pretty
```

## Repository structure

```text
assets/manifest.json       exact reference identity
bin/                       local ca65/ld65 toolchain and license
config/linker/cnrom.cfg    complete iNES/PRG/CHR linker layout
config/reconstruction.json machine-checked module inventory and progress floors
config/scheduler_entries.json reviewed scheduler-entry inventory
config/enemy_ai_handlers.json reviewed enemy AI handler pointer inventory
config/enemy_record_pointers.json reviewed record-pool pointer layouts
docs/                      architecture and reverse-engineering notes
scripts/project.py         split, verify, lint, and safe build helpers
scripts/asm_style.py       shared ca65 formatter and style checker
scripts/verify_rom.py      original/build/asset comparison and ROM reports
scripts/room_data.py       room-format decoder
scripts/reconstruction_status.py semantic coverage and provenance audit
scripts/scheduler_data.py scheduler-table decoder and source-call audit
scripts/enemy_ai_data.py enemy AI handler-table decoder and audit
scripts/enemy_pointer_data.py split record-pointer decoder and audit
src/main.asm               assembly entrypoint and iNES header
src/system/nmi.asm         semantic `$8000-$80FE` vertical-blank module
src/system/controller_input.asm serial sampling and cached controller input
src/system/startup.asm     reset, warm-boot state, PPU and thread bootstrap
src/system/scheduler.asm   eight-context cooperative stack scheduler
src/system/pause_thread.asm context-two Start-button pause loop
src/system/sound_effect_queue.asm three-slot sound command producer
src/system/ppu_update_buffer.asm publish shared RAM program to NMI
src/system/jump_with_params.asm inline appendix tail-dispatch ABI
src/system/masked_ram_wait.asm cooperative masked zero-page waits
src/system/secondary_thread_reset.asm stop other contexts during transitions
src/game/room_transition_reset.asm shared transition context and state reset
src/game/object_y_clamp.asm align object Y to a 16-pixel surface
src/game/object_x_left_clamp.asm clamp object X against its left surface
src/game/coordinate_conversion.asm pixel and packed room-index conversion
src/game/main_thread.asm   context-three gameplay service loop
src/game/timer.asm         countdown arithmetic and warning-state transitions
src/game/timer_item_effects.asm multiply or replace time from collected items
src/game/inventory_item_effects.asm packed inventory and related item handlers
src/data/item_scores.asm  collectible score digit and amount lookup tables
src/game/auxiliary_effect.asm shared auxiliary-object effect initialization
src/game/score.asm         game-state-gated decimal score addition
src/game/timer_display.asm NMI update-program builder for timer digits
src/game/enemy_movement.asm active-enemy movement prepass
src/game/enemy_ai_dispatch.asm 17-slot per-enemy AI selector
src/game/fireball_lifetime.asm fireball expiration and delayed cleanup
src/game/enemy_initialization.asm enemy slot position/state initialization
src/game/enemy_type_configuration.asm spawn-type object/AI configuration
src/data/enemy_types.asm  packed enemy-type configuration table
src/game/enemy_ai_handlers.asm inline handler dispatcher and pointer table
src/game/enemy_position.asm shared current-enemy position-copy helper
src/game/enemy_pointers.asm shared object/AI record pointer resolvers
src/game/enemy_slot_allocation.asm free enemy-record allocator
src/data/enemy_record_pointers.asm generated record-pool pointer tables
src/game/enemy_deactivation.asm parallel-record slot retirement
src/game/current_enemy_deactivation.asm selected enemy-record retirement
src/game/active_object_states.asm update active non-Dana record states
src/game/object_pointer.asm non-Dana object-record pointer resolver
src/game/non_dana_object_deactivation.asm clear the non-Dana object pool
src/preservation/prg.asm   remaining address-ordered PRG source
src/graphics/chr.asm       `.incbin` wrapper for ignored generated CHR
src/memory/                hardware and RAM symbol registries
tests/                     tooling and codec tests
```

## Evidence boundary

Names in source and documentation are classified as confirmed,
high-confidence, tentative, or unknown. A readable name is not treated as
proof by itself. Static control flow, pointer tables, read/write traces, and
repeatable runtime scenarios are the intended evidence layers. See
`docs/naming.md` and `docs/unknowns.md`.

## Upstream material and rights

The preservation listing was imported from
[rbmichael/solomons_key_disassembly](https://github.com/rbmichael/solomons_key_disassembly),
which attributes the original disassembly to `ninespaces`. That repository did
not contain an explicit license when imported. This project therefore does not
assert a blanket license over the imported listing or game data. Original
tooling and documentation should be treated separately from third-party and
copyrighted material. See `docs/provenance.md` for the complete source ledger.

This is an unofficial preservation and research project. Solomon's Key and its
game data remain property of their respective rights holders.
