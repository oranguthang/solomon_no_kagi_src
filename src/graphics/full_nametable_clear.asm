; Fill both physical nametables with blank tiles and reset their attributes

.segment "PRG_FULL_NAMETABLE_CLEAR"

FirstNametableAddressHigh = $20
SecondNametableAddressHigh = $28
FullNametableBlankTile = $24
InitialNametableTileCount = $C0
NametableAttributeByteCount = $40
NametableAttributeFill = $FF
NametableFillChunkCounter = $04

ClearBothNametables:
    JSR $96F0
    LDA #FirstNametableAddressHigh
    JSR ClearFullNametable
    LDA #SecondNametableAddressHigh
    JSR ClearFullNametable
    JSR $96DC
    RTS

ClearFullNametable:
    LDX #$00
    JSR $CD53
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #FullNametableBlankTile
    LDY #InitialNametableTileCount
    LDX #NametableFillChunkCounter

WriteFullNametableByte:
    STA a:PPU_DATA
    DEY
    BNE WriteFullNametableByte
    DEX
    BPL SelectNametableFillPhase
    LDX a:PPU_STATUS
    RTS

SelectNametableFillPhase:
    BNE WriteFullNametableByte
    LDY #NametableAttributeByteCount
    LDA #NametableAttributeFill
    BMI WriteFullNametableByte
