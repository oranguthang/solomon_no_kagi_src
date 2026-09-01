; Non-code filler between the NMI PPU services and Reset

.segment "PRG_PRE_STARTUP_PADDING"

PreStartupPadding:
    .byte $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
