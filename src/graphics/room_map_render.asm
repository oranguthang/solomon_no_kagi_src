; Render the 16x12 interior RoomMap cells through direct PPU transfers

.segment "PRG_ROOM_MAP_RENDER"

RoomMapRenderStartIndex = $D0
RoomMapRenderStopIndex = $11
RoomMapColumnMask = $0F
NametableAttributeHigh = $23
SolidRoomMapTile = $F8
SpecialRoomMapTile = $80
DecoratedRoomMapTile = $40
SolidRoomMapTileClass = $03
SpecialRoomMapTileClass = $00
DecoratedRoomMapTileClass = $10

DrawRoomMapToNametable:
    LDA a:PpuUpdateStreamPointer + 1
    BNE DrawRoomMapToNametable
    JSR BeginDirectPpuTransfer
    LDA a:PPU_STATUS
    LDA #RoomMapRenderStartIndex

DrawNextRoomMapCell:
    PHA
    TAX
    AND #RoomMapColumnMask
    BEQ AdvanceRoomMapCell
    DEX
    STX RoomRenderMapIndex
    JSR $9F01
    STA RoomRenderPpuAddressLow
    LDY #NametableAttributeHigh
    STY a:PPU_ADDR
    STA a:PPU_ADDR
    LDA a:PPU_DATA
    LDA a:PPU_DATA
    STA RoomRenderAttributeByte
    LDX RoomRenderMapIndex
    LDA RoomMap,X
    LDX #SolidRoomMapTileClass
    CMP #SolidRoomMapTile
    BCS SelectRoomMapTileClass
    CMP #SpecialRoomMapTile
    LDX #SpecialRoomMapTileClass
    BCS SelectRoomMapTileClass
    LDX #DecoratedRoomMapTileClass
    CMP #DecoratedRoomMapTile
    BCS SelectRoomMapTileClass
    TAX

SelectRoomMapTileClass:
    STX RoomRenderTileClass
    JSR $9E21
    LDX #$00

WriteNextRoomCellPpuChunk:
    LDY #$02

WriteRoomCellPpuAddress:
    LDA PpuUpdateBuffer,X
    INX
    STA a:PPU_ADDR
    DEY
    BNE WriteRoomCellPpuAddress
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    INX
    LDY #$02

WriteRoomCellPpuData:
    LDA PpuUpdateBuffer,X
    BEQ AdvanceRoomMapCell
    INX
    STA a:PPU_DATA
    DEY
    BNE WriteRoomCellPpuData
    BEQ WriteNextRoomCellPpuChunk

AdvanceRoomMapCell:
    PLA
    TAX
    DEX
    CPX #RoomMapRenderStopIndex
    TXA
    BCS DrawNextRoomMapCell
    LDA a:PPU_STATUS
    JMP EndDirectPpuTransfer
