; Cooperative Dana actions for head collision, fireballs, and block magic

.segment "PRG_DANA_ACTIONS"

HeadCollisionX = $0000
DanaHeadCollisionBits = $0001
FireballSourceAction = $0000
DanaActionY = $0004
DanaActionX = $0005
DanaBlockCastTarget = $007E
DanaHeadCollisionTarget = $007F

HeadCollisionSound = $11
BlockCreateSound = $07
BlockRemoveSound = $08
SolidBlockRemoveSound = $12
FireballCastSound = $0A

HandleDanaHeadCollision:
    LDY #HeadCollisionSound
    JSR AddSoundEffect
    LDA DanaYPosition
    SBC #$08
    STA DanaActionY
    LDX DanaXPosition
    TXA
    LDY #$00
    AND #$08
    BNE EncodeHeadCollisionSide
    INY

EncodeHeadCollisionSide:
    STY DanaHeadCollisionBits
    TXA
    CLC
    ADC #$04
    STA HeadCollisionX
    STA DanaActionX
    JSR ConvertPixelCoordinatesToMapIndex
    TAY
    TAX
    LDA RoomMap,Y
    ROL A
    ROL DanaHeadCollisionBits
    CLC
    LDA #$F8
    ADC HeadCollisionX
    STA HeadCollisionX
    CLC
    LDA #$09
    ADC HeadCollisionX
    EOR HeadCollisionX
    AND #$F0
    BEQ ReadSecondHeadCollisionCell
    INX

ReadSecondHeadCollisionCell:
    LDA RoomMap,X
    ROL A
    ROL DanaHeadCollisionBits
    LDA #$03
    AND DanaHeadCollisionBits
    BEQ FinishHeadCollisionAction
    ROR DanaHeadCollisionBits
    LDA #$02
    AND DanaHeadCollisionBits
    BEQ TestFirstHeadCollisionCell
    BCC SelectSecondHeadCollisionCell

SelectNonzeroHeadCollisionCell:
    TXA
    BNE StoreHeadCollisionTarget

TestFirstHeadCollisionCell:
    ROR DanaHeadCollisionBits
    BCC SelectNonzeroHeadCollisionCell

SelectSecondHeadCollisionCell:
    TYA

StoreHeadCollisionTarget:
    STA DanaHeadCollisionTarget
    TAY
    LDA RoomMap,Y
    CMP #$F8
    BCS FinishHeadCollisionAction
    CMP #$C8
    BCS SpawnHeadCollisionSpark
    ORA #$40
    STA RoomMap,Y
    STY RoomMapUpdateIndex
    LDA #$01
    STA RoomMapUpdateTile
    JSR BuildAndPublishRoomMapCellUpdate
    BNE WaitAfterHeadCollision

SpawnHeadCollisionSpark:
    LDX #<MagicSparkObject
    STX MapInteractionObjectPointer
    LDX #>MagicSparkObject
    STX MapInteractionObjectPointer + 1
    STY DanaActionY
    JSR ApplyMapTileInteractionToObject
    LDA #$09
    STA MagicSparkObject + ObjectActionOffset

WaitAfterHeadCollision:
    JSR ResetAndSelectGameplayDelayCounter
    LDA #$08
    JSR WaitForZeroPageCounterAboveThreshold

FinishHeadCollisionAction:
    JMP FinishDanaAction

CastFireballFromInventory:
    LDY #$00
    STY GameplayDelayCounter
    LDA FireballObject + ObjectStateOffset
    BMI FinishFireballCast
    LDA DanaSavedAction
    CMP #DanaAirborneMoveActionBase
    LDX #FireballGroundedAlternateDirection
    BCC StoreFireballInitialDirections
    INX

StoreFireballInitialDirections:
    STX FireballAlternateDirectionIndex
    STA FireballSourceAction
    AND #DanaFacingMask
    STA FireballDirectionIndex
    LSR A
    LDA #$04
    BCS PositionFireballHorizontally
    LDA #$FB

PositionFireballHorizontally:
    ADC DanaXPosition
    STA FireballObject + ObjectXPositionOffset
    LDA FireballSourceAction
    AND #$FC
    STY FireballObject + ObjectActionOffset
    STY FireballObject + ObjectCachedTypeOffset
    STY FireballLifeCounter1Lo
    STY FireballLifeCounter1Hi
    CMP #$10
    BNE PositionFireballVertically
    LDY #$02

PositionFireballVertically:
    TYA
    CLC
    ADC DanaYPosition
    STA FireballObject + ObjectYPositionOffset
    LDX #$02

ConsumeNextFireballInventorySlot:
    ASL InventorySlotsHigh
    ROL InventorySlotsLow
    ROL A
    DEX
    BNE ConsumeNextFireballInventorySlot
    AND #$03
    BEQ FinishFireballCast
    LSR A
    LDY #FireballCastSound
    JSR AddSoundEffect
    LDA #$0C
    BCS ActivateFireball
    LDA #$10

ActivateFireball:
    STA FireballObject + ObjectTypeOffset
    LDA #$C0
    STA FireballObject + ObjectStateOffset
    ASL A
    STA FireballActive
    JSR BuildFireballInventoryDisplayUpdate

FinishFireballCast:
    JMP FinishDanaCasting

CastOrRemoveBlock:
    LDA #$00
    STA GameplayDelayCounter
    STA RoomMapUpdateIndex
    LDA DanaSavedAction
    LDX #$08
    AND #DanaActionGroupMask
    CMP #DanaCrouchMoveActionBase
    BNE SelectBlockCastVerticalOffset
    LDX #$18
    INC RoomMapUpdateIndex

SelectBlockCastVerticalOffset:
    STX DanaActionY
    LDA DanaYPosition
    CLC
    ADC DanaActionY
    STA DanaActionY
    LDA DanaSavedAction
    ROR A
    LDA #$15
    BCC SelectBlockCastHorizontalOffset
    LDA #$FB

SelectBlockCastHorizontalOffset:
    ROL RoomMapUpdateIndex
    ADC DanaXPosition
    STA DanaActionX
    JSR ConvertPixelCoordinatesToMapIndex
    TAY
    LDX #<MagicSparkObject
    STX MapInteractionObjectPointer
    LDX #>MagicSparkObject
    STX MapInteractionObjectPointer + 1
    LDA RoomMap,Y
    STY DanaBlockCastTarget
    BMI RemoveBlockAtTarget

CreateBlockAtTarget:
    JSR TryCreateBlockAtMapCell
    LDA MagicSparkObject + ObjectStateOffset
    BPL WaitForBlockCast
    LDY #SolidBlockRemoveSound
    LDA MagicSparkObject + ObjectActionOffset
    CMP #$02
    BCS QueueBlockCastSound
    LDY #BlockCreateSound

QueueBlockCastSound:
    JSR AddSoundEffect

WaitForBlockCast:
    LDX #GameplayDelayCounter
    LDA #$0F
    JSR WaitForZeroPageCounterAboveThreshold
    LDA MagicSparkObject + ObjectStateOffset
    BPL FinishBlockCast
    LDA MagicSparkObject + ObjectActionOffset
    CMP #$02
    BCS FinishBlockCast
    LDA MagicSparkObject + ObjectYPositionOffset
    STA DanaActionY
    LDA MagicSparkObject + ObjectXPositionOffset
    STA DanaActionX
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA RoomMap,X
    BPL FinishBlockCast
    STX RoomMapUpdateIndex
    LDA #$00
    STA RoomMapUpdateTile
    JSR BuildAndPublishRoomMapCellUpdate
    BNE FinishBlockCast

RemoveBlockAtTarget:
    PHA
    JSR ApplyMapTileInteractionToObject
    PLA
    LDY #SolidBlockRemoveSound
    CMP #$F8
    BCS QueueBlockRemovalSound
    LDY #BlockRemoveSound

QueueBlockRemovalSound:
    JSR AddSoundEffect

FinishDanaCasting:
    LDX #GameplayDelayCounter
    LDA #$0F
    JSR WaitForZeroPageCounterAboveThreshold

FinishBlockCast:
    LDA DanaObject + ObjectStateOffset
    AND #$FE
    ORA #$20
    STA DanaObject + ObjectStateOffset
    LDA DanaSavedAction
    STA DanaObject + ObjectActionOffset
    ROR A
    LDA #$FC
    BCC RestoreDanaHorizontalPosition
    LDA #$03

RestoreDanaHorizontalPosition:
    ADC DanaXPosition
    STA DanaXPosition
    LDA DanaSavedYMotion
    STA DanaObject + ObjectYMotionOffset

FinishDanaAction:
    LDX Joypad1Cached
    TXA
    AND #$08
    BNE DeactivateMagicSpark
    TXA
    AND #$F0
    STA Joypad1Cached

DeactivateMagicSpark:
    LDA #$00
    STA MagicSparkObject + ObjectStateOffset
    LDA #$01
    JSR StopThread
