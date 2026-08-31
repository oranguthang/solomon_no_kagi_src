; Select enemy records eligible for the per-enemy AI handler

.segment "PRG_ENEMY_AI_DISPATCH"

RunEnemyAiDispatcher:
    LDX #EnemyObjectCount - 1

CheckNextEnemyAiSlot:
    TXA
    PHA
    LDA EnemyAiRecordPointerLowTable,X
    STA EnemyAiPointer
    LDA EnemyAiRecordPointerHighTable,X
    STA EnemyAiPointer + 1
    LDA EnemyObjectPointerLowTable,X
    STA EnemyObjectPointer
    LDA EnemyObjectPointerHighTable,X
    STA EnemyObjectPointer + 1
    LDY #$00
    LDA (EnemyObjectPointer),Y
    CMP #$C0
    BCC NextEnemyAiSlot
    INY
    LDA (EnemyObjectPointer),Y
    SBC #$14
    BCC NextEnemyAiSlot
    JSR DispatchEnemyAiHandler

NextEnemyAiSlot:
    PLA
    TAX
    DEX
    BPL CheckNextEnemyAiSlot
    RTS
