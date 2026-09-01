; Build and publish the buffered PPU update for one logical RoomMap cell

.segment "PRG_ROOM_MAP_CELL_UPDATE"

RoomTilePatternTable = $D000
RoomCellTwoByteLiteralCommand = $41
RoomCellOneByteLiteralCommand = $40

RoomMapUpdateSavedIndex = $0000
RoomMapUpdateSavedTile = $0001
RoomMapUpdateAttributeByte = $0002
RoomMapUpdateAttributeAddressLow = $0003
RoomMapUpdatePpuAddressLow = $0004
RoomMapUpdatePpuAddressHigh = $0005
RoomMapUpdateTilePatternPointer = $0006

RoomCellUpdateTopAddressHigh = PpuUpdateBuffer + $00
RoomCellUpdateTopAddressLow = PpuUpdateBuffer + $01
RoomCellUpdateTopCommand = PpuUpdateBuffer + $02
RoomCellUpdateTopTiles = PpuUpdateBuffer + $03
RoomCellUpdateBottomAddressHigh = PpuUpdateBuffer + $05
RoomCellUpdateBottomAddressLow = PpuUpdateBuffer + $06
RoomCellUpdateBottomCommand = PpuUpdateBuffer + $07
RoomCellUpdateBottomTiles = PpuUpdateBuffer + $08
RoomCellUpdateAttributeAddressHigh = PpuUpdateBuffer + $0A
RoomCellUpdateAttributeAddressLow = PpuUpdateBuffer + $0B
RoomCellUpdateAttributeCommand = PpuUpdateBuffer + $0C
RoomCellUpdateAttributeValue = PpuUpdateBuffer + $0D
RoomCellUpdateTerminator = PpuUpdateBuffer + $0E

BuildAndPublishRoomMapCellUpdate:
    LDA RoomMapUpdateTile
    PHA
    LDA RoomMapUpdateIndex
    PHA

WaitForPreviousAttributeReadRequest:
    LDA #GameplayFlagAttributeReadRequest
    AND GameplayFlags
    BEQ WaitForAttributeReadStateIdle
    JSR SwitchThreads
    BCS WaitForPreviousAttributeReadRequest

WaitForAttributeReadStateIdle:
    LDA PpuAttributeReadState
    BPL RequestRoomCellAttributeRead
    JSR SwitchThreads
    BCS WaitForAttributeReadStateIdle

RequestRoomCellAttributeRead:
    PLA
    TAX
    PHA
    JSR CalculateRoomMapAttributeAddressLow
    STA PpuAttributeAddressOrValue
    LDA #GameplayFlagAttributeReadRequest
    ORA GameplayFlags
    STA GameplayFlags

WaitForRoomCellAttributeRead:
    JSR SwitchThreads
    LDA PpuAttributeReadState
    BMI CaptureRoomCellAttributeByte
    LDA GameplayFlags
    AND #GameplayFlagAttributeReadRequest
    BNE WaitForRoomCellAttributeRead

CaptureRoomCellAttributeByte:
    LDA PpuAttributeAddressOrValue
    PHA
    LDA #GameplayFlagAttributeReadRequestMask
    AND GameplayFlags
    STA GameplayFlags

WaitForRoomCellUpdateBuffer:
    LDA PpuUpdateStreamPointer + 1
    BEQ RestoreRoomCellUpdateInputs
    JSR SwitchThreads
    BCS WaitForRoomCellUpdateBuffer

RestoreRoomCellUpdateInputs:
    PLA
    STA RoomMapUpdateAttributeByte
    PLA
    STA RoomMapUpdateSavedIndex
    TAY
    PLA
    STA RoomMapUpdateSavedTile

BuildRoomCellUpdateBuffer:
    LDA #<RoomTilePatternTable
    STA RoomMapUpdateTilePatternPointer
    LDA #>RoomTilePatternTable
    STA RoomMapUpdateTilePatternPointer + 1
    LDX RoomMapUpdateSavedIndex
    JSR CalculateRoomMapAttributeAddressLow
    STA RoomMapUpdateAttributeAddressLow
    LDA RoomMapUpdateSavedTile
    CMP #$10
    BNE SelectRoomCellTilePattern
    LDA ConstellationPosition
    BEQ SelectDefaultRoomCellTilePattern
    LDA RoomMapUpdateSavedIndex
    LDX #$00
    SEC
    SBC ConstellationPosition
    BCC SelectDefaultRoomCellTilePattern
    CMP #$03
    BCC SelectConstellationTilePattern
    CMP #$10
    BCC SelectDefaultRoomCellTilePattern
    CMP #$13
    BCC SelectLowerConstellationTilePattern

SelectDefaultRoomCellTilePattern:
    LDA #$10
    BPL SelectRoomCellTilePattern

SelectLowerConstellationTilePattern:
    LDX #$03

SelectConstellationTilePattern:
    STX RoomMapUpdatePpuAddressLow
    AND #$03
    ADC RoomMapUpdatePpuAddressLow
    LDX #<ConstellationPattern
    STX RoomMapUpdateTilePatternPointer
    LDX #>ConstellationPattern
    STX RoomMapUpdateTilePatternPointer + 1

SelectRoomCellTilePattern:
    ASL A
    ASL A
    TAY
    LDA RoomMapUpdateAttributeByte
    LDX RoomMapUpdatePpuAddressHigh
    BEQ ClearRoomCellAttributeQuadrant

RotateRoomCellAttributeToLowBits:
    ROR A
    ROR A
    DEX
    BNE RotateRoomCellAttributeToLowBits

ClearRoomCellAttributeQuadrant:
    AND #$FC
    STA RoomMapUpdateAttributeByte
    LDA (RoomMapUpdateTilePatternPointer),Y
    AND #$03
    ORA RoomMapUpdateAttributeByte
    LDX RoomMapUpdatePpuAddressHigh
    BEQ StoreRoomCellAttributeByte

RestoreRoomCellAttributeQuadrant:
    ROL A
    ROL A
    DEX
    BNE RestoreRoomCellAttributeQuadrant

StoreRoomCellAttributeByte:
    STA RoomMapUpdateAttributeByte
    LDA RoomMapUpdateSavedIndex
    STA RoomMapUpdatePpuAddressLow
    JSR ConvertRoomMapIndexToNametableAddress
    LDA RoomMapUpdatePpuAddressHigh
    LDX #$00
    STA RoomCellUpdateTopAddressHigh,X
    STA RoomCellUpdateBottomAddressHigh,X
    LDA RoomMapUpdatePpuAddressLow
    STA RoomCellUpdateTopAddressLow,X
    CLC
    ADC #$20
    STA RoomCellUpdateBottomAddressLow,X
    LDA (RoomMapUpdateTilePatternPointer),Y
    INY
    AND #$FC
    STA RoomCellUpdateTopTiles,X
    LDA (RoomMapUpdateTilePatternPointer),Y
    INY
    STA RoomCellUpdateTopTiles + 1,X
    LDA (RoomMapUpdateTilePatternPointer),Y
    INY
    STA RoomCellUpdateBottomTiles,X
    LDA (RoomMapUpdateTilePatternPointer),Y
    STA RoomCellUpdateBottomTiles + 1,X
    LDA #$23
    STA RoomCellUpdateAttributeAddressHigh,X
    LDA RoomMapUpdateAttributeAddressLow
    STA RoomCellUpdateAttributeAddressLow,X
    LDA RoomMapUpdateAttributeByte
    STA RoomCellUpdateAttributeValue,X
    TXA
    STA RoomCellUpdateTerminator,X
    LDA #RoomCellTwoByteLiteralCommand
    STA RoomCellUpdateTopCommand,X
    STA RoomCellUpdateBottomCommand,X
    LDA #RoomCellOneByteLiteralCommand
    STA RoomCellUpdateAttributeCommand,X
    JMP PublishPpuUpdateBuffer
