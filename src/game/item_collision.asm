; Dana-centered RoomMap interaction classification and item dispatch

.segment "PRG_ITEM_COLLISION"

DanaItemInteractionStateLimit = $1C
DanaItemInteractionCenterOffset = $08
FirstInventoryItemTile = $06
FirstVisualInventoryItemTile = $08
IgnoredMapTile = $10
FirstBonusMapTile = $25
FirstExtraLifeMapTile = $32
MapTileInteractionLimit = $38
BonusItemGroupSize = $03
NoItemInteractionThread = $00
InventoryItemInteractionThread = $40
ExtraLifeInteractionThread = $41
ItemInteractionSound = $0D
ExtraLifeSound = $06

ItemInteractionThreadCode = $02

ReturnFromHudOrItemUpdate:
    RTS

; The three bytes are PPU data. Their accidental decoding as JSR $4760 in a
; linear disassembly is not an executable entry point
ScoreDisplayPpuCommandHeader:
    PpuUpdateCommand $2060, PpuUpdateLiteral, 8

CheckDanaMapTileInteraction:
    LDA DanaObject + ObjectActionOffset
    CMP #DanaItemInteractionStateLimit
    BCS ReturnFromHudOrItemUpdate
    LDA DanaYPosition
    ADC #DanaItemInteractionCenterOffset
    STA CoordinateY
    LDA DanaXPosition
    ADC #DanaItemInteractionCenterOffset
    STA CoordinateX
    JSR ConvertPixelCoordinatesToMapIndex
    LDA #NoItemInteractionThread
    STA ItemInteractionThreadCode
    LDA RoomMap,X
    JSR ClassifyDanaMapTileInteraction
    LDA ItemInteractionThreadCode
    BEQ ReturnFromHudOrItemUpdate
    JMP StartThread

ClassifyDanaMapTileInteraction:
    CMP #MapTileInteractionLimit
    BCS FinishMapTileInteraction
    CMP #IgnoredMapTile
    BEQ FinishMapTileInteraction
    CMP #FirstInventoryItemTile
    BCC FinishMapTileInteraction
    CMP #FirstBonusMapTile
    BCC DispatchInventoryItemInteraction
    TAX
    LDA $87
    LSR A
    BCS FinishMapTileInteraction
    LDA #InventoryItemInteractionThread
    STA ItemInteractionThreadCode
    TXA
    JSR SpawnAuxiliaryEffectAtMapCell
    CMP #FirstExtraLifeMapTile
    BCS CheckBonusItemExtraLifeScore
    LDY #ItemInteractionSound
    JSR AddSoundEffect
    SBC #FirstBonusMapTile - 1
    LDX #$FF

SelectBonusItemScore:
    SBC #BonusItemGroupSize
    INX
    BCS SelectBonusItemScore
    ADC #BonusItemGroupSize
    TAY
    LDA ItemBonusScoreDigitIndices,X
    TAX
    LDA ItemBonusScoreAmounts,Y
    JMP AddScoreByAAtDigitX

CheckBonusItemExtraLifeScore:
    BNE AwardExtraLifeFromMapTile
    LDX #$02
    LDA #$05
    JSR AddScoreByAAtDigitX

AwardExtraLifeFromMapTile:
    LDY #ExtraLifeSound
    JSR AddSoundEffect
    INC RemainingLives
    LDA #$00
    STA AuxiliaryObject + ObjectYMotionOffset
    INC ExtraLivesAcquiredTotal
    LDA #ExtraLifeInteractionThread
    STA ItemInteractionThreadCode

FinishMapTileInteraction:
    RTS

DispatchInventoryItemInteraction:
    CMP #FirstVisualInventoryItemTile
    BCC QueueInventoryItemInteraction
    TAY
    LDA $87
    LSR A
    TYA
    BCC SpawnInventoryItemEffect
    RTS

SpawnInventoryItemEffect:
    JSR SpawnAuxiliaryEffectAtMapCell

QueueInventoryItemInteraction:
    LDY #InventoryItemInteractionThread
    STY ItemInteractionThreadCode
    LDY #ItemInteractionSound
    JSR AddSoundEffect
; Carry is clear here, so subtracting 5 converts map tiles $06-$24 to
; zero-based handler selectors $00-$1E
    SBC #FirstInventoryItemTile - 1
    JSR JumpWithParams
