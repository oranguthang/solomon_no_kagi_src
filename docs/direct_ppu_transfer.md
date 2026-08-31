# Direct PPU transfer guard

The game brackets bulk CPU-to-PPU writes with two adjacent helpers:

| Entry | Range | Static uses |
| --- | --- | ---: |
| `EndDirectPpuTransfer` | `$96DC-$96EF` | 7 |
| `BeginDirectPpuTransfer` | `$96F0-$970A` | 6 |

## Begin contract

`BeginDirectPpuTransfer` waits cooperatively until the high byte of
`PpuUpdateStreamPointer` is zero. It then:

- clears `PPU_CTRL` bit 7 to disable NMI;
- clears `PPU_CTRL` bit 2 to select one-byte address increments;
- stores that control value in both `PpuCtrlShadow` and hardware;
- clears the background/sprite enable bits in the value written to `PPU_MASK`.

The last operation intentionally does not overwrite `PpuMaskShadow`. The
disabled rendering state is temporary hardware state for the transfer.

## End contract

`EndDirectPpuTransfer` sets background/sprite enable bits 3 and 4 in
`PpuMaskShadow`, sets NMI-enable bit 7 in `PpuCtrlShadow`, writes the latter to
`PPU_CTRL`, and returns. It does not write `PPU_MASK` directly; the NMI path
later commits the restored shadow value.

Callers may use `JSR` or tail-call the end helper with `JMP`. The descriptor
nametable clear, full two-nametable clear, and several still-preserved screen
renderers all share this contract. The adjacent room-frame renderer uses the
repeated writers documented in `docs/ppu_data_writers.md`.
