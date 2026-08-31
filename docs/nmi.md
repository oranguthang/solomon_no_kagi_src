# Vertical-blank subsystem

## Owned range

`src/system/nmi.asm` owns CPU `$8000-$80FE` (255 bytes). The linker places its
`PRG_NMI` segment before the remaining fixed PRG, and
`make reconstruction-audit` checks its start, end, size, and required labels.

## Entry and exit contract

The vector at `$FFFA` enters `NMI`. The handler saves X, Y, and A, performs its
PPU and frame services, restores those registers at `NmiRestoreRegisters`, and
returns with `RTI`. It deliberately does not save processor status because the
6502 interrupt sequence already pushes it.

At entry, `PpuCtrlShadow` and `PpuMaskShadow` provide the software-owned PPU
state. The handler temporarily clears control/mask bits while it prepares the
frame, then sets bit 7 in `PpuCtrlShadow` before restoring `PPU_CTRL` on exit.

## PPU and mapper transactions

- OAM DMA always uses page `>OamBuffer`, which is `$02` for the shadow OAM
  allocation beginning at `$0210`.
- `WritePpuScroll` reads `PPU_STATUS` to reset the shared PPU address latch,
  writes `PpuScrollX`, then writes the Y value passed in X to `PPU_SCROLL`.
- `ChrBankSelectValues` contains `$10,$11,$12,$13`. The NMI masks the selector
  to two bits, reads the corresponding value, and writes it to an address in
  the CNROM cartridge range. The low two data bits therefore select one of the
  four 8 KiB CHR banks; the high nibble is retained from the original bus value.

## Evidence boundary

The register save/restore, PPU writes, OAM page, and four-way CNROM selection
are statically confirmed. Several conditional frame services inside the NMI
still call raw addresses and use unclassified RAM fields. Their generated
branch labels remain intentionally unresolved rather than receiving guessed
behavioral names. Those paths require call-graph work and focused runtime
traces before further renaming.
