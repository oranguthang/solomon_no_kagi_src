# Repeated PPU data writers

Two small helpers at `$97A3-$97B7` support a direct screen renderer.

## Four-byte pattern writer

`WriteRepeatedFourBytePpuPattern` accepts:

- `TempPointer00`: address of a four-byte source pattern;
- `X`: number of pattern repetitions.

Each repetition resets `Y` to 3 and writes source offsets 3, 2, 1, and 0 to
`PPU_DATA`. The pointer is not advanced. The four current callers request 6,
6, 8, and 8 repetitions from the four records at `$97B8-$97C7`.

## Single-byte writer

`WriteRepeatedPpuByte` accepts the byte in `Y` and count in `X`, writing that
value to `PPU_DATA` until `X` reaches zero. Its current caller writes 64 zero
bytes.

## Pattern data

The four records are named `RepeatedPpuPattern0` through
`RepeatedPpuPattern3`. The first two form the outer and inner right frame
columns; the latter two fill the two bottom tile rows. The data module asserts
the complete 16-byte extent at assembly time. See
`docs/room_nametable_frame.md` for the PPU layout.
