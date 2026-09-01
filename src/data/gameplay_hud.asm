; Single-byte PPU update template for the collected-fairy HUD field

.segment "PRG_GAMEPLAY_HUD_DATA"

FairyCountDisplayPpuUpdateTemplate:
    .byte $20, $71, $40, $00, $00
