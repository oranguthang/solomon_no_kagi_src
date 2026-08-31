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

The tested codec is `scripts/room_data.py`. Its JSON keeps raw type values and
the original item command grouping so that naming uncertainty or RLE expansion
does not corrupt the lossless structural result.

`make roundtrip-formats` decodes and re-encodes all 53 block-plane records,
enemy streams, item metadata/command streams, and both 53-entry split-pointer
tables. It compares every encoded result directly with the built PRG and is
part of `make release-check`.

## Nametable clear descriptors

The three records at CPU `$CA33-$CA3B` are independent of room streams. Each
record is `(width, start_index, row_count)`. The direct PPU clear routine maps
the start index to `$2000 + start_index * 4`; adding 8 to the index after each
row advances the PPU address by 32 bytes.

| Offset | Width | Start index | First PPU address | Rows |
| ---: | ---: | ---: | ---: | ---: |
| 0 | 32 | `$00` | `$2000` | 26 |
| 3 | 32 | `$20` | `$2080` | 26 |
| 6 | 30 | `$20` | `$2080` | 24 |

The source keeps the records in `src/data/nametable_clear.asm` and asserts the
three-record extent at assembly time.
