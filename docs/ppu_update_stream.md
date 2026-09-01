# PPU update stream interpreter

`ExecutePpuUpdateStream` at `$8B7F-$8BE1` is the NMI-side consumer for both
ROM-resident update streams and programs assembled in `PpuUpdateBuffer`.
The NMI enters with `Y = 1`; the routine decrements it to zero and reads the
first command through `PpuUpdateStreamPointer`.

Each command has this layout:

```text
byte 0    PPU address high byte; zero terminates the entire stream
byte 1    PPU address low byte
byte 2    control
bytes...  one repeated value or N literal values
```

The control byte is packed as follows:

```text
bit 7       PPU address step: 0 = +1, 1 = +32
bit 6       payload mode: 0 = repeat one byte, 1 = literal bytes
bits 5..0   write count minus one (1-64 writes)
```

The interpreter writes each command directly through `PPU_ADDR` and
`PPU_DATA`. A repeat command advances past its single payload byte after all
writes; a literal command advances after every byte. The next address-high
byte starts another command, while zero finishes the program.

Completion clears `PpuUpdateStreamPointer + 1`, making the shared producer
slot available again. It then performs the game's `$3F00`/`$0000` PPU-address
sequence, resets the PPU latch through `PPU_STATUS`, and restores `PpuScrollX`,
`PpuScrollY`, and `PpuCtrlShadow`. `RestorePpuStateAfterUpdate` at `$8BCE` is
also a shared entry used by the adjacent status-read path.
