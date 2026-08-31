; Select enemy records eligible for the per-enemy AI handler

.segment "PRG_ENEMY_AI_DISPATCH"

RunEnemyAiDispatcher:
    LDX #EnemyObjectCount - 1

CheckNextEnemyAiSlot:
    TXA
    PHA
    LDA $B446,X
    STA EnemyAiPointer
    LDA $B457,X
    STA EnemyAiPointer + 1
    LDA $B46C,X
    STA EnemyObjectPointer
    LDA $B481,X
    STA EnemyObjectPointer + 1
    LDY #$00
    LDA (EnemyObjectPointer),Y
    CMP #$C0
    BCC NextEnemyAiSlot
    INY
    LDA (EnemyObjectPointer),Y
    SBC #$14
    BCC NextEnemyAiSlot
    JSR $A469

NextEnemyAiSlot:
    PLA
    TAX
    DEX
    BPL CheckNextEnemyAiSlot
    RTS
