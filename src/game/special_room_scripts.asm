; Context-6 dispatch and room-specific triggers for all 53 room indices

.segment "PRG_SPECIAL_ROOM_SCRIPTS"

SpecialRoomThreadIndex = $06
RoomsPerScriptGroup = 8
RoomScriptGroupPointerSize = 2
RoomScriptDisabledFlag = $10
RoomScriptTargetMapIndex = $88
RoomScriptRepeatCount = $0B
RoomScriptEnemyType = $18
RoomScriptEnemyAiFlag = $40
RoomScriptEnemyAiActive = $80
RoomScriptEnemyObjectState = $90
RoomScriptDanaAction = DanaWalkActionBase

RunSpecialRoomScriptThread:
    JSR DispatchCurrentRoomScript
    LDA #SpecialRoomThreadIndex
    JSR StopThread

DispatchCurrentRoomScript:
    LDX CurrentRoomIndex
    TXA
    LSR A
    LSR A
    LSR A
    ASL A
    TAY
    LDA SpecialRoomScriptOffsets,X
    CLC
    ADC SpecialRoomScriptGroupBases,Y
    STA TempPointer00
    LDA #$00
    ADC SpecialRoomScriptGroupBases + 1,Y
    STA TempPointer00 + 1
    JMP (TempPointer00)

SpecialRoomScriptGroupBases:
    .addr NoSpecialRoomScript
    .addr RevealRoomSealFlag01
    .addr NoGroup2RoomScript
    .addr NoGroup3RoomScript
    .addr NoGroup4RoomScript
    .addr NoGroup5RoomScript
    .addr NoGroup6RoomScript

; Each byte is relative to the base shared by its eight-room group. The final
; four values are data despite decoding as valid 6502 opcodes in isolation
SpecialRoomScriptOffsets:
    .byte $00
    .byte $00, $00, $01, $01, $00, $01, $00, $00
    .byte $06, $05, $05, $09, $05, $05, $05, $01
    .byte $2C, $2F, $37, $4E, $00, $00, $2C, $00
    .byte $00, $00, $00, $01, $06, $00, $00, $00
    .byte $00, $00, $00, $00, $27, $01, $00, $00
    .byte $00, $00, $00, $00, $01, $09, $00, $01
    .byte $85, $00, $49, $4D

SpecialRoomScriptCount = * - SpecialRoomScriptOffsets
.assert SpecialRoomScriptCount = 53, error, "unexpected special-room script count"

NoSpecialRoomScript:
    RTS

EnablePrimaryEnemyScript:
    JMP EnablePrimaryEnemyAiPhase

RevealRoomSealFlag01:
    LDA #$01
    JMP RevealCurrentRoomSeal

NoGroup1RoomScript:
    RTS

EnablePrimaryEnemyScriptGroup1:
    JMP EnablePrimaryEnemyAiPhase

RevealRoomSealFlag02:
    LDA #$02
    JMP RevealCurrentRoomSeal

NoGroup2RoomScript:
    RTS

RunRepeatedHeadCollision7ETrigger:
    LDA #$04
    JSR RevealCurrentRoomSeal
    LDA #$00
    STA RoomScriptTargetMapIndex
    LDA RoomStateFlags
    AND #RoomScriptDisabledFlag
    BNE NoGroup2RoomScript

WaitForHeadCollision7E:
    JSR SwitchThreads
    LDA HeadCollisionTargetMapIndex
    CMP #$7E
    BNE WaitForHeadCollision7E
    LDA #$00
    STA HeadCollisionTargetMapIndex
    INC RoomScriptTargetMapIndex
    LDA RoomScriptTargetMapIndex
    CMP #RoomScriptRepeatCount
    BCC WaitForHeadCollision7E
    LDA #$6E
    STA RoomScriptTargetMapIndex
    JMP SpawnType18AtScriptTarget

EnablePrimaryEnemyScriptGroup2:
    JMP EnablePrimaryEnemyAiPhase

RevealRoomSealFlag08AndEnableEnemy:
    LDA #$08
    JSR RevealCurrentRoomSeal
    JMP EnablePrimaryEnemyAiPhase

RunRoomIndex19BlockTrigger:
    JSR PrepareSpecialRoomTrigger
    LDA #<Room20SpecialBlockPlane
    STA RoomBlockDataPointer
    LDA #>Room20SpecialBlockPlane
    STA RoomBlockDataPointer + 1
    LDA #$04
    JSR ExpandRoomMapBitplane
    LDA #$20
    STA RoomScriptTargetMapIndex
    JMP RunRoomMapTrigger

RevealRoomSealFlag10:
    LDA #$10
    JMP RevealCurrentRoomSeal

RunRoomMapTrigger:
    LDA RoomStateFlags
    AND #RoomScriptDisabledFlag
    BNE FinishRoomMapTrigger

WaitForTargetTileSet:
    JSR ReadScriptTargetTileAfterYield
    BPL WaitForTargetTileSet

WaitForTargetTileClear:
    JSR ReadScriptTargetTileAfterYield
    BMI WaitForTargetTileClear

WaitForDanaActionToFinish:
    JSR SwitchThreads
    LDA DanaObject + ObjectStateOffset
    LSR A
    BCS WaitForDanaActionToFinish
    LDA RoomScriptTargetMapIndex
    STA RoomMapUpdateIndex
    LDA #$38
    STA RoomMapUpdateTile
    JSR BuildAndPublishRoomMapCellUpdate

WaitForSecondTargetTileSet:
    JSR ReadScriptTargetTileAfterYield
    BPL WaitForSecondTargetTileSet

WaitForSecondTargetTileClear:
    JSR ReadScriptTargetTileAfterYield
    BMI WaitForSecondTargetTileClear
    LDA HeadCollisionTargetMapIndex
    CMP RoomScriptTargetMapIndex
    BNE FinishRoomMapTrigger

WaitForDanaRoomScriptAction:
    JSR SwitchThreads
    LDA DanaObject + ObjectActionOffset
    CMP #RoomScriptDanaAction
    BNE WaitForDanaRoomScriptAction
    LDX RoomScriptTargetMapIndex
    LDA #$32
    STA RoomMap,X
    LDA #$39
    STA RoomMapUpdateTile
    STX RoomMapUpdateIndex
    JSR BuildAndPublishRoomMapCellUpdate

FinishRoomMapTrigger:
    RTS

ReadScriptTargetTileAfterYield:
    JSR SwitchThreads
    LDX RoomScriptTargetMapIndex
    LDA RoomMap,X
    RTS

EnablePrimaryEnemyAiPhase:
    JSR WaitForDanaActive
    LDA EnemyAiState
    ORA #RoomScriptEnemyAiFlag
    STA EnemyAiState
    RTS

SpawnType18AtScriptTarget:
    JSR SwitchThreads
    JSR FindFreeEnemySlotIndex
    BCC SpawnType18AtScriptTarget
    LDA #RoomScriptEnemyAiActive
    STA (TempPointer04),Y
    LDA #$00
    LDY #$02
    STA (TempPointer04),Y
    INY
    STA (TempPointer04),Y
    STX SpawnSlotIndex
    LDA RoomScriptTargetMapIndex
    STA SpawnYPosition
    JSR ConvertMapIndexToPixelCoordinates
    LDA #RoomScriptEnemyType
    STA SpawnType
    JSR InitializeEnemy
    JSR ConfigureEnemyType
    RTS

NoGroup3RoomScript:
    RTS

RevealRoomSealFlag20:
    LDA #$20
    JMP RevealCurrentRoomSeal

RunRoomIndex29BlockTrigger:
    JSR PrepareSpecialRoomTrigger
    LDA #<Room30SpecialBlockPlane
    STA RoomBlockDataPointer
    LDA #>Room30SpecialBlockPlane
    STA RoomBlockDataPointer + 1
    LDA #$27
    JSR ExpandRoomMapBitplane
    JMP EnablePrimaryEnemyAiPhase

UnusedRoomIndex29ScriptReturn:
    RTS

NoGroup4RoomScript:
    RTS

RunRepeatedHeadCollision56Trigger:
    LDA #$00
    STA RoomScriptTargetMapIndex
    LDA RoomStateFlags
    AND #RoomScriptDisabledFlag
    BNE NoGroup4RoomScript

WaitForHeadCollision56:
    JSR SwitchThreads
    LDA HeadCollisionTargetMapIndex
    CMP #$56
    BNE WaitForHeadCollision56
    LDA #$00
    STA HeadCollisionTargetMapIndex
    INC RoomScriptTargetMapIndex
    LDA RoomScriptTargetMapIndex
    CMP #RoomScriptRepeatCount
    BCC WaitForHeadCollision56
    LDA #$36
    STA RoomScriptTargetMapIndex
    JMP SpawnType18AtScriptTarget

RunRoomIndex37MapTrigger:
    LDA #$9E
    STA RoomScriptTargetMapIndex
    JMP RunRoomMapTrigger

NoGroup5RoomScript:
    RTS

RevealRoomSealFlag40AndEnableEnemy:
    LDA #$40
    JSR RevealCurrentRoomSeal
    JMP EnablePrimaryEnemyAiPhase

RevealRoomSealFlag80:
    LDA #$80
    JMP RevealCurrentRoomSeal

NoGroup6RoomScript:
    RTS

RunRoomIndex48ObjectTrigger:
    JSR WaitForDanaActive
    LDA #$F8
    STA RoomMap
    LDA #RoomScriptEnemyObjectState
    LDX #$0B

HideRoomIndex48Objects:
    LDY SpecialRoomObjectMapOffsets,X
    STA RoomMap,Y
    DEX
    BPL HideRoomIndex48Objects

WaitForRoomIndex48FirstCastTarget:
    JSR SwitchThreads
    LDA BlockCastTargetMapIndex
    CMP #$AD
    BNE WaitForRoomIndex48FirstCastTarget
    LDA EnemyObjects + ObjectStateOffset
    BPL FinishRoomIndex48ObjectTrigger
    LDA EnemyObjects + ObjectYPositionOffset
    STA CoordinateY
    LDA EnemyObjects + ObjectXPositionOffset
    STA CoordinateX
    JSR ConvertPixelCoordinatesToMapIndex
    CPX #$AD
    BNE FinishRoomIndex48ObjectTrigger
    LDA #RoomScriptEnemyObjectState
    STA RoomMap + $82

WaitForRoomIndex48SecondCastTarget:
    JSR SwitchThreads
    LDA BlockCastTargetMapIndex
    CMP #$57
    BNE WaitForRoomIndex48SecondCastTarget
    LDA #RoomScriptEnemyObjectState
    STA RoomMap + $65

FinishRoomIndex48ObjectTrigger:
    RTS

RunRoomIndex51ObjectTrigger:
    LDX #$37
    BNE MarkRoomIndex51Or52TriggerTile

RunRoomIndex52ObjectTrigger:
    LDX #$A7

MarkRoomIndex51Or52TriggerTile:
    LDA #$21
    STA RoomMap,X
    JSR WaitForDanaActive
    LDA #RoomScriptEnemyObjectState
    STA RoomMap + $97

WaitForRoomIndex51Or52DanaPosition:
    JSR SwitchThreads
    LDA DanaObject + ObjectYPositionOffset
    STA CoordinateY
    LDA DanaObject + ObjectXPositionOffset
    STA CoordinateX
    JSR ConvertPixelCoordinatesToMapIndex
    LDA #RoomScriptEnemyObjectState
    CPX #$57
    BEQ OpenRoomIndex51Or52Tiles
    LDX BlockCastTargetMapIndex
    CPX #$A1
    BNE WaitForRoomIndex51Or52DanaPosition
    STA RoomMap + $C7
    RTS

OpenRoomIndex51Or52Tiles:
    LDX #$02

OpenNextRoomIndex51Or52Tile:
    STA RoomMap + $46,X
    DEX
    BPL OpenNextRoomIndex51Or52Tile
    RTS

.assert * - RunSpecialRoomScriptThread = $234, error, "unexpected special-room script module size"
