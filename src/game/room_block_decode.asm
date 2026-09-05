; Initialize the runtime room map and expand its two 16x12 block bitplanes

.segment "PRG_ROOM_BLOCK_DECODE"

RoomBlockBytesPerPlane = $18
RoomBlockBytesPerRoom = RoomBlockBytesPerPlane * 2
RoomMapInteriorTile = $10
RoomMapBoundaryTile = RoomMapImmutableTileMinimum
BrownBlockTile = RoomMapSolidBit | RoomMapInteriorTile
WhiteBlockTile = RoomMapImmutableTileMinimum
BitsPerBlockByte = $08

InitializeRoomBlockMap:
    LDX #RoomMapStorageSize
    LDA #RoomMapInteriorTile

FillRoomMapInterior:
    STA RoomMap - 1,X
    DEX
    BNE FillRoomMapInterior
    LDA #RoomMapBoundaryTile
    LDX #RoomMapWidth - 1

FillRoomMapTopBoundary:
    STA RoomMap,X
    DEX
    BPL FillRoomMapTopBoundary
    LDX #RoomMapWidth

FillRoomMapBottomBoundary:
    STA RoomMapBottomBoundary - 1,X
    DEX
    BNE FillRoomMapBottomBoundary
    STX RoomBlockDataPointer + 1
    LDA CurrentRoomIndex
    STA RoomBlockDataPointer
    ASL A
    CLC
    ADC RoomBlockDataPointer
    STA RoomBlockDataPointer
    TXA
    ROL A
    STA RoomBlockDataPointer + 1
    LDY #$04

ScaleRoomBlockDataOffset:
    ASL RoomBlockDataPointer
    ROL RoomBlockDataPointer + 1
    DEY
    BNE ScaleRoomBlockDataOffset
    LDA #<RoomBlockData
    ADC RoomBlockDataPointer
    STA RoomBlockDataPointer
    LDA #>RoomBlockData
    ADC RoomBlockDataPointer + 1
    STA RoomBlockDataPointer + 1
    LDA #BrownBlockTile
    JSR ExpandRoomMapBitplane
    CLC
    LDA #RoomBlockBytesPerPlane
    ADC RoomBlockDataPointer
    STA RoomBlockDataPointer
    LDA #$00
    ADC RoomBlockDataPointer + 1
    STA RoomBlockDataPointer + 1
    LDA #WhiteBlockTile
    JMP ExpandRoomMapBitplane

ExpandRoomMapBitplane:
    STA RoomBlockTile
    LDX #RoomMapPlayableLastIndex
    LDY #RoomBlockBytesPerPlane - 1
    STY RoomBlockByteIndex

LoadNextRoomBlockByte:
    LDY RoomBlockByteIndex
    LDA (RoomBlockDataPointer),Y
    STA RoomBlockBits
    LDY #BitsPerBlockByte
    LDA RoomBlockTile

DecodeNextRoomBlockBit:
    ROR RoomBlockBits
    BCC AdvanceRoomBlockBit
    STA RoomMap,X

AdvanceRoomBlockBit:
    DEX
    DEY
    BNE DecodeNextRoomBlockBit
    DEC RoomBlockByteIndex
    BPL LoadNextRoomBlockByte
    RTS

.assert RoomMapStorageSize = $E0, error, "unexpected RoomMap storage size"
.assert RoomMapPlayableFirstIndex = $10, error, "unexpected RoomMap playable start"
.assert RoomMapPlayableLastIndex = $CF, error, "unexpected RoomMap playable end"
