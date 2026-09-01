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

The active NMI path calls `ReadJoyPads` once per service. It strobes and reads
both controller ports, records complete serial samples at `$0082-$0083`, and
updates the cached input at `$03E4-$03E5`. Depending on bit 0 of the global
game-state flags, the cache either receives the complete sample or refreshes
only Start and Select. See `docs/controller_input.md`.

Foreground producers build compact PPU update programs in the shared RAM
buffer at `$03E6`. `PublishPpuUpdateBuffer` points `$001A-$001B` at that
buffer; the NMI path uses the pointer's high byte to gate
`ExecutePpuUpdateStream`. That interpreter supports horizontal or vertical
addressing plus repeated or literal payloads, clears the pointer when done,
and restores PPU state. See `docs/ppu_update_buffer.md` and
`docs/ppu_update_stream.md`.

ROM-resident programs use `QueueStaticPpuUpdateStream`. The caller supplies
one of 18 indices in `A`; the routine cooperatively waits for the current
stream to finish, then publishes the indexed split-table pointer. See
`docs/static_ppu_update_queue.md`.

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

Context 2 selector 1 is now identified as `PauseGameThread`. Scheduler code
`$21` enters `$8E47`, enforces a `$28`-NMI-tick debounce, waits for distinct
Start release/press/release phases, then stops context 2 on resume. See
`docs/pause_thread.md`.

Two shared condition waits extend the scheduler ABI. A caller supplies a mask
and zero-page address, then `WaitForMaskedBitsClear` or
`WaitForMaskedBitsSet` repeatedly yields until the requested RAM condition is
true. Arguments are saved within the current context's stack partition across
every switch. See `docs/masked_ram_wait.md`.

Scene-transition paths use `ResetOtherSecondaryThreads` with the current
secondary context in `X`. It stops every other context from 1 through 7 while
leaving context 0 and the caller alive, then clears the four pending-start
slots and two transition flags. See `docs/secondary_thread_reset.md`.

The larger room-transition scene invokes `ResetRoomTransitionState` on two
paths. It retains context 3, clears gameplay flag bits 6 and 2, disables the
active fireball, and submits sound command 3. See
`docs/room_transition_reset.md`.

## Inline appendix dispatch

`JumpWithParams` implements a second important control-flow convention. A
selector in `A` chooses a little-endian handler pointer stored immediately
after the caller's `JSR`. The routine removes that JSR return address from the
hardware stack and jumps to the selected handler, so the handler's `RTS`
returns from the dispatching routine rather than falling into the appendix.
This convention drives eleven jump tables, including the 28-entry enemy AI
table.

## Sound-effect requests

Gameplay producers submit a sound-effect command in `Y` through
`AddSoundEffect`. The routine preserves `A` and places the command in the
three-byte `$0423-$0425` request area. It prefers the first empty slot while
searching indices 2 and 1; index 0 is overwritten as the fallback when both
higher slots are occupied. This producer-side behavior is proven, while the
consumer, command meanings, priority rules, music data, and APU driver remain
to be reconstructed. See `docs/sound_effect_queue.md`.

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
`+$07` is the integer Y coordinate and `+$0A` is the integer X coordinate;
neighboring fields participate in fractional motion and movement state.
Enemy-specific AI state is stored separately at `$04F7` with an eight-byte
stride for seventeen entries. This is a split-state design rather than one
fully self-contained structure per enemy.

Collision code uses `ObjectClampYCoordinateToSurface` on a record selected by
`TempPointer08`. It aligns object byte 7 down to a 16-pixel boundary and
reduces byte 5 to its old sign bit, exposing the shared integer-Y and signed
fraction/direction convention without yet generalizing every adjacent field.
`ObjectClampXCoordinateToLeftSurface` similarly moves byte 10 to the `...4`
inset of a 16-pixel cell and clears bytes 9 and 8 after a left-side surface
contact.

Most consumers resolve either side of that split state through two shared
helpers. `LoadEnemyObjectPointer` and `LoadEnemyAiPointer` accept a slot index
in `A` and construct the chosen record address in `TempPointer00`. Each helper
uses separate low/high pointer tables, keeping pool bases and record strides
out of the calling code. All 28 source call sites now use these entry names.
The tables themselves are reconstructed from the two RAM bases and strides,
with seventeen AI entries and twenty-one object entries. Four leading object
entries cover Dana, the magic spark, the fireball, and an auxiliary record;
the enemy-only table labels begin at the fifth entry.

A third helper, `LoadObjectPointer`, serves whole-pool operations that exclude
Dana. It accepts `X=0..19` and uses pointer-table index `X+1`, covering the
magic spark, fireball, auxiliary record, and all seventeen enemies. Its two
callers sweep every non-Dana object; eight other paths use the same source-owned
plus-one table aliases directly.

Two whole-pool services bracket that helper in PRG. One conditionally replaces
byte 0 for records whose state is negative; the other unconditionally clears
byte 0 and moves every non-Dana record offscreen with Y sentinel `$F8`. These
sweeps expose scene-wide state-transition and teardown boundaries without yet
assigning meanings to every negative state value.

Allocation scans the AI side first. `FindFreeEnemySlotIndex` walks all
seventeen AI state records and treats a non-negative byte 0 as available. On
success it returns carry set, the slot in `X`, and the selected AI pointer in
`TempPointer04`; exhaustion returns carry clear. Callers then initialize the
parallel object record with the same index.

`DeactivateEnemySlot` uses those tables to retire both halves of an enemy
slot atomically: it clears byte 0 in the AI and object records and writes the
offscreen `$F8` sentinel to object Y. Linked-enemy cleanup paths call this
service by slot index.

Enemy behavior code uses the smaller `DeactivateCurrentEnemy` variant when
the dispatcher has already populated `EnemyAiPointer` and
`EnemyObjectPointer`. Its eleven callers are tail-calls, so retiring the
selected slot also completes that behavior update.

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

Four item handlers operate directly on the same unpacked digits. They double
or multiply the timer by five with decimal carry, or replace it with `10000`
or `05000`; multiplication discards carry beyond four digits. The two
multipliers also adjust `TimerDecrementStep`. See
`docs/timer_item_effects.md`.

Fireball inventory is stored as eight two-bit entries across `$042E-$042F`.
Bottle handlers fill the first empty usable slot with value 1 or 2, while the
Scroll Extender raises the usable-slot limit to at most eight. Fairy Bell
queues a fairy for the gameplay thread, and the two Tzo handlers extend the
fireball lifetime while its high byte is below 2. See
`docs/inventory_item_effects.md`.

Score uses eight unpacked decimal digits at `$044A-$0451`. The shared addition
helper begins at a caller-selected digit and propagates carry toward the most
significant end. `GameStateFlags` bit 0 gates whether the supplied amount is
accepted; the flags byte is restored before the digit loop. See
`docs/score.md`.

Item and enemy paths share one auxiliary object at `$05BB`. One entry converts
a packed room-map cell to pixels while preserving the caller's item type;
another accepts coordinates directly. Both install the same four-byte object
template and integer Y/X fields. The visual meaning remains deliberately
unassigned pending traces. See `docs/auxiliary_effect.md`.

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

`LoadRoomItemsAndMetadata` is now the source-owned runtime consumer of that
format. It resolves both Demon Mirror schedules and enemy sets, initializes
door/key/mirror state, decodes normal and repeated item records into `RoomMap`,
and expands optional constellation metadata. See `docs/room_item_decode.md`.

`InitializeRoomBlockMap` owns the fixed block path. It prepares a 16x14 RAM
map with `$F8` sentinel rows around the 16x12 playable interior, computes the
48-byte room record at `$E02C + room*48`, and expands brown then white planes.
Writing white second implements the documented overlap priority. See
`docs/room_block_decode.md`.

Gameplay coordinates map onto that grid through a packed nibble index. The
conversion subtracts a Y=`$10`, X=`$08` pixel origin, uses 16-pixel cells, and
stores the row in the high nibble and column in the low nibble. The inverse
conversion is source-owned alongside it, and all 31 consumers use the two
semantic entry points.

## Rendering and timing

OAM shadow storage begins at `$0210`; the NMI path performs DMA from page `$02`.
The logical object pool therefore feeds a separate sprite-composition stage.

Direct CPU-to-PPU transfers are bracketed by `BeginDirectPpuTransfer` and
`EndDirectPpuTransfer`. The begin side waits until the shared update-stream
pointer is idle, disables NMI and rendering, and selects one-byte PPU address
increments. It writes the disabled rendering value only to hardware, leaving
`PpuMaskShadow` intact. The end side restores render-enable bits in that shadow
and re-enables NMI; the next NMI commits the shadowed mask. See
`docs/direct_ppu_transfer.md`.

The adjacent direct writer cluster has separate primitives for repeating a
four-byte pattern and filling PPU_DATA with one byte. Four source patterns are
kept in a dedicated data module rather than decoded as instructions. See
`docs/ppu_data_writers.md`.

Room initialization uses those primitives to frame the 30x24 tile interior.
`DrawRoomNametableFrame` writes two vertical columns at `$209E/$209F`, two
bottom rows at `$2380`, and clears all 64 attribute bytes at `$23C0`. See
`docs/room_nametable_frame.md`.

Room transitions also use a direct PPU clearing path at `$C9BD-$CA32`. Its
three-byte descriptors select width, a scaled nametable start index, and row
count. The routine writes blank tile `$24` across each row, advances by one
32-byte nametable row, and finally clears 48 attribute bytes at
`$23C8-$23F7`. See `docs/nametable_clear.md`.

A second direct path at `$CB6F-$CBA5` resets both physical nametables. For each
of `$2000` and `$2800`, it writes 960 blank tile bytes followed by all 64
attribute bytes. This is separate from the descriptor-driven partial clear and
from buffered NMI update programs.

Direct writers share `SetPpuAddressAX` at `$CD53`: `A` is the high address
byte and `X` is the low byte. The helper reads `PPU_STATUS` first to reset the
address latch, then writes both bytes to `PPU_ADDR`. Ten static callers now use
that contract by name.

Because gameplay services run through cooperative contexts, timing-sensitive
behavior must be validated with instruction/frame traces rather than inferred
from an idealized fixed update order.
