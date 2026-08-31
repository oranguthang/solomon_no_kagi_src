# Architecture

## Cartridge and CPU layout

The USA release is CNROM (mapper 3): one fixed 32 KiB PRG mapping at
`$8000-$FFFF` and one of four 8 KiB CHR banks selected by CPU writes in the
cartridge range. The reset vector points to `$8C00`; NMI begins at `$8000`.

The NMI handler saves X, Y, and A, performs PPU/OAM work, updates selected
frame services, restores the registers, and returns with `RTI`. The foreground
game code is not a single once-per-frame update loop.

The statically confirmed `$8000-$80FE` range is isolated in
`src/system/nmi.asm`. It disables NMI/rendering bits through the PPU shadow
registers, commits OAM page `$02`, selects one of four CNROM CHR banks through
`ChrBankSelectValues`, and finishes by restoring the PPU control shadow and
CPU registers. `WritePpuScroll` resets the PPU write latch by reading
`PPU_STATUS`, then performs the X and Y writes to `PPU_SCROLL`.

## Cooperative scheduler

The strongest unusual architectural feature is an eight-context cooperative
scheduler. `ThreadIndex` is at `$0302`, and the saved stack-pointer table begins
at `$0012`. The initial stack partitions are:

```text
$1C $3C $5C $7C $9C $BC $DC $FC
```

Each context owns roughly `$20` bytes of the 6502 hardware stack page. A
voluntary switch saves the current SP, chooses another context, restores its
SP, and returns into the continuation already present on that stack. This
explains why work is not guaranteed to occur exactly once per rendered frame:
the same activity may resume more than once, or receive less service when
other contexts are busy.

Bisqwit's map identified `$8DB4` as the switch, `$8DFC` as the default thread
entry, and `$A000` as the main gameplay loop. These are now source-owned as
`SwitchThreads`, `IdleThreadLoop`, and `MainGameplayThread`. Independently, the
decoded `$30` scheduler entry stores return address `$9FFF`, proving that its
RTS enters `$A000`. `StartThread` builds this continuation from a packed
context/entry selector; `StopThread` resets a context to the idle continuation
and clears its active bit. See `docs/scheduler.md`,
`docs/scheduler_entries.md`, and `docs/main_gameplay_thread.md`.

## Runtime objects

The primary object pool starts at `$057F` and uses a `$14`-byte stride:

```text
$057F Dana
$0593 magic spark
$05A7 player fireball
$05BB auxiliary slot
$05CF-$070F seventeen enemy slots
```

Coordinates have integer and fractional components. In the Dana record,
`+$06` is the integer Y coordinate and `+$0A` is the integer X coordinate;
neighboring fields participate in fractional motion and movement state.
Enemy-specific AI state is stored separately at `$04F7` with an eight-byte
stride for seventeen entries. This is a split-state design rather than one
fully self-contained structure per enemy.

Most consumers resolve either side of that split state through two shared
helpers. `LoadEnemyObjectPointer` and `LoadEnemyAiPointer` accept a slot index
in `A` and construct the chosen record address in `TempPointer00`. Each helper
uses separate low/high pointer tables, keeping pool bases and record strides
out of the calling code. All 28 source call sites now use these entry names.
The tables themselves are reconstructed from the two RAM bases and strides,
with seventeen AI entries and twenty-one object entries. Four leading object
entries cover Dana, the magic spark, the fireball, and an auxiliary record;
the enemy-only table labels begin at the fifth entry.

`UpdateEnemiesMovement` walks these parallel pools through four split pointer
tables. It advances active AI records using the shared gameplay update count,
caches direction components relative to Dana, and publishes an active-enemy
count for later services. Field-level semantics beyond the confirmed offsets
remain deliberately unresolved; see `docs/enemy_movement.md`.

The following `RunEnemyAiDispatcher` pass resolves the same parallel pointers,
applies two object-record eligibility tests, and invokes a per-enemy handler.
Keeping selection separate from behavior matches the two-stage movement/AI
pipeline visible in `MainGameplayThread`.

The fireball uses a separate two-phase lifetime service. An active fireball is
expired when its 16-bit counter passes the configured lifetime; the object is
retired only after a short low-counter grace interval. This state transition is
isolated from the later object initialization and rendering helpers.

Allocated enemy slots use a shared zero-page spawn contract. `InitializeEnemy`
clears AI-record offsets 1-3 and writes converted coordinates into the matching
object record before a separate type-specific service configures behavior and
rendering. This confirms the parallel-record initialization order without yet
assigning names to every field.

`ConfigureEnemyType` then decodes the spawn type through a compact table,
configures object state through a shared helper, and conditionally seeds the
last two bytes of the parallel AI record. Existing slots can also pass through
this stage without repeating coordinate initialization, so position setup and
type configuration are intentionally separate services.

The type decoder's compact 27-byte flag table is now source-owned separately
from executable code. Its size is assembly-asserted, while individual bit
names remain deferred until all consuming helpers are understood.

Eligible AI records are routed through an inline appendix dispatcher. A
two-bit shift selects one of 28 little-endian entries consumed by the generic
`JumpWithParams` convention; repeated entries collapse those selectors onto 14
behavior targets. The complete pointer inventory is machine-audited.

Two of those behavior families call `LoadCurrentEnemyPosition`. It copies the
selected enemy record's working Y/X bytes into the shared spawn scratch area,
making the current enemy position available to a related-object construction
path without coupling that helper to a particular enemy type.

## Countdown timer

The gameplay thread consumes pending timer ticks through `DecrementTimer`.
Fractional accumulation controls when a decimal decrement occurs; borrow then
propagates across four unpacked decimal digits. A dirty flag defers HUD work
until the shared PPU update stream is free. Separate state tracks crossing one
of four warning thresholds. See `docs/timer.md` for the owned range and current
evidence boundary.

## Room pipeline

The room loader combines independent sources:

```text
room index
  -> enemy pointer table -> lifetime + enemy records
  -> fixed block planes  -> brown and white collision layers
  -> item pointer table  -> metadata + item stream
  -> runtime room map at $0304
  -> object records and renderer
```

The 16x12 logical grid is distinct from the PPU nametable and from OAM. Room
items encode visibility/block modifiers in their type byte, while key/door,
player start, and Demon Mirror settings live in a ten-byte room header.

## Rendering and timing

OAM shadow storage begins at `$0210`; the NMI path performs DMA from page `$02`.
The logical object pool therefore feeds a separate sprite-composition stage.
Because gameplay services run through cooperative contexts, timing-sensitive
behavior must be validated with instruction/frame traces rather than inferred
from an idealized fixed update order.
