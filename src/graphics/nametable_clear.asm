; Descriptor-driven direct PPU nametable clearing

.segment "PRG_NAMETABLE_CLEAR"

NametableClearDescriptorSize = $03
NametableBlankTile = $24
NametableAttributeAddressHigh = $23
NametableAttributeAddressLow = $C8
NametableAttributeClearCount = $30

Clear30x24NametableRegion:
    LDX #NametableClearDescriptorSize * 2
    JSR ClearNametableRegionFromDescriptor
    JMP EndDirectPpuTransfer

Clear32x26NametableRegion:
    LDX #NametableClearDescriptorSize
    JSR ClearNametableRegionFromDescriptor
    JMP EndDirectPpuTransfer

ClearNametableRegionFromDescriptor:
    TXA
    PHA
    JSR BeginDirectPpuTransfer
    PLA
    LDX a:PPU_STATUS
    TAX
    LDA NametableClearDescriptors,X
    INX
    STA NametableClearWidth
    LDA NametableClearDescriptors,X
    INX
    STA TempPointer00
    LDY NametableClearDescriptors,X

ClearNextNametableRow:
    LDA TempPointer00
    ASL A
    ROL TempPointer00 + 1
    ASL A
    ROL TempPointer00 + 1
    TAX
    LDA TempPointer00 + 1
    AND #$03
    ORA #$20
    STA a:PPU_ADDR
    STX a:PPU_ADDR
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDX NametableClearWidth
    LDA #NametableBlankTile

WriteBlankNametableTile:
    STA a:PPU_DATA
    DEX
    BNE WriteBlankNametableTile
    LDA #$08
    CLC
    ADC TempPointer00
    STA TempPointer00
    DEY
    BNE ClearNextNametableRow
    LDA #NametableAttributeAddressHigh
    STA a:PPU_ADDR
    LDA #NametableAttributeAddressLow
    STA a:PPU_ADDR
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDX #NametableAttributeClearCount
    LDA #$00

ClearNametableAttributeByte:
    STA a:PPU_DATA
    DEX
    BNE ClearNametableAttributeByte
    LDX a:PPU_STATUS
    RTS
