; Width, start-index, and row-count descriptors for direct nametable clearing

.segment "PRG_NAMETABLE_CLEAR_DATA"

NametableClearDescriptors:
    .byte 32, $00, 26  ; 32 columns from PPU $2000 for 26 rows
    .byte 32, $20, 26  ; 32 columns from PPU $2080 for 26 rows
    .byte 30, $20, 24  ; 30 columns from PPU $2080 for 24 rows

.assert * - NametableClearDescriptors = NametableClearDescriptorSize * 3, error, "nametable clear descriptor count changed"
