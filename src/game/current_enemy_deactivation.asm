; Deactivate the enemy selected by the shared AI and object pointers

.segment "PRG_CURRENT_ENEMY_DEACTIVATION"

DeactivateCurrentEnemy:
    LDA #$00
    TAY
    STA (EnemyAiPointer),Y
    STA (EnemyObjectPointer),Y
    LDY #$07
    LDA #$F8
    STA (EnemyObjectPointer),Y
    RTS
