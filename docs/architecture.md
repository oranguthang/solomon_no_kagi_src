# Architecture

## Cartridge and CPU layout

The USA release is CNROM (mapper 3): one fixed 32 KiB PRG mapping at
`$8000-$FFFF` and one of four 8 KiB CHR banks selected by CPU writes in the
cartridge range. The reset vector points to `$8C00`; NMI begins at `$8000`.

The NMI handler saves X, Y, and A, performs PPU/OAM work, updates selected
frame services, restores the registers, and returns with `RTI`. The foreground
game code is not a single once-per-frame update loop.

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

Working addresses inherited from Bisqwit's map are `$8DB4` for the switch,
`$8DFC` for the default thread entry, and `$A000` for the main gameplay loop.
They remain evidence-backed working names until runtime traces are added here.

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
