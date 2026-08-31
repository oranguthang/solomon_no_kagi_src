# Direct PPU address writes

`SetPpuAddressAX` at `$CD53-$CD5E` is the shared address setup helper for ten
direct PPU writers.

## Contract

- input `A`: high byte of the PPU address;
- input `X`: low byte of the PPU address;
- output: `PPU_ADDR` receives `A`, then `X`;
- clobbers processor flags; preserves the supplied values in `A` and `X`.

The helper temporarily pushes `A`, reads `PPU_STATUS` to reset the shared
`PPU_SCROLL`/`PPU_ADDR` write toggle, restores `A`, and performs the two address
writes. Callers restore `PpuCtrlShadow` separately when their transfer requires
it; this helper owns only latch reset and address selection. Longer transfers
use the separate begin/end contract documented in `docs/direct_ppu_transfer.md`.
