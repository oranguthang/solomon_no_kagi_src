# Room data formats

All offsets below are within the 32 KiB PRG. Add 16 for offsets in a headered
iNES file. Runtime pointers address the same bytes at CPU `$8000-$FFFF`.

## Section map

| Section | PRG offset | Size / count |
| --- | ---: | ---: |
| Demon Mirror schedule pointers | `$5C00` | 16 split pointers |
| Demon Mirror enemy-set pointers | `$5C20` | 17 split pointers |
| Enemy stream pointers | `$5CEC` | 53 split pointers |
| Block planes | `$602C` | 53 x 48 bytes |
| Item stream pointers | `$6A1C` | 53 split pointers |

Pointer tables store all low bytes first and all high bytes second. A runtime
pointer is converted to a PRG offset by subtracting `$8000`.

## Coordinates

One byte stores a grid coordinate:

```text
high nibble = y + 1
low nibble  = x
```

Thus `$B5` is `(5, 10)`. A zero high nibble represents `y = -1`, used to hide
metadata objects outside the visible room.

## Blocks

Each room has two 24-byte, 16x12 bitplanes: brown/breakable followed by
white/solid. Rows are stored top-to-bottom, two bytes per row, most-significant
bit first. If both planes contain a block at one position, the white block wins.

## Enemy stream

The first byte is the Demonhead/Saramandor lifetime rotated right by three bits.
Rotate it left by three to decode. Remaining records are `(type, position)`
pairs terminated by type `$00`.

## Item metadata and stream

Every item stream begins with ten bytes:

| Byte | Meaning |
| ---: | --- |
| 0 | mirror 2 spawn schedule |
| 1 | mirror 1 spawn schedule |
| 2 | mirror 2 enemy set |
| 3 | mirror 1 enemy set |
| 4 | key status plus time-decrease rate |
| 5 | door position |
| 6 | key position |
| 7 | player start position |
| 8 | mirror 1 position |
| 9 | mirror 2 position |

Normal items are `(type, position)` pairs. `$C0-$DF` encode one repeated type:
`count = code - $C0 + 1`, followed by the type and `count` position bytes.
`$00` and `$E0-$EF` terminate the stream and encode the tileset. `$F0-$FB`
encode a constellation plus one position and also terminate the stream.

The tested decoder is `scripts/room_data.py`. Its JSON keeps raw type values so
that naming uncertainty does not corrupt the lossless structural result.
