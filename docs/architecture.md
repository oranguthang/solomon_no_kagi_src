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
