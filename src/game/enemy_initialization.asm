; Initialize the position-bearing fields for one allocated enemy slot

.segment "PRG_ENEMY_INITIALIZATION"

InitializeEnemy:
    LDA SpawnSlotIndex
    JSR LoadEnemyAiPointer
    LDY #$00
    TYA

ClearEnemyAiStateFields:
    INY
    STA (TempPointer00),Y
    CPY #$03
    BNE ClearEnemyAiStateFields
    LDA SpawnSlotIndex
    JSR LoadEnemyObjectPointer
    LDY #$07
    LDA SpawnYPosition
    STA (TempPointer00),Y
    LDY #$0A
    LDA SpawnXPosition
    STA (TempPointer00),Y
    RTS
