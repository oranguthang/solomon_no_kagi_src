; Advance active enemy movement records and cache their direction to Dana

.segment "PRG_ENEMY_MOVEMENT"

UpdateEnemiesMovement:
    LDA DanaYPosition
    STA $06
    LDA DanaXPosition
    STA $07
    LDA GameplayUpdateCount
    STA $00
    LDA #$00
    STA GameplayUpdateCount
    STA ActiveEnemyCount
    LDX #EnemyObjectCount - 1

UpdateNextEnemyMovement:
    LDA $B46C,X
    STA TempPointer02
    LDA $B481,X
    STA TempPointer02 + 1
    LDA $B446,X
    STA TempPointer04
    LDA $B457,X
    STA TempPointer04 + 1
    LDY #$00
    LDA (TempPointer04),Y
    BPL NextEnemyMovement
    INC ActiveEnemyCount
    INY
    LDA $00
    CLC
    ADC (TempPointer04),Y
    STA (TempPointer04),Y
    INY
    LDA $00
    CLC
    ADC (TempPointer04),Y
    STA (TempPointer04),Y
    INY
    LDA #$00
    ADC (TempPointer04),Y
    STA (TempPointer04),Y
    LDY #$07
    LDA (TempPointer02),Y
    SEC
    SBC $06
    ROR A
    PHA
    LDY #$0A
    LDA (TempPointer02),Y
    SEC
    SBC $07
    ROR A
    LDY #$05
    STA (TempPointer04),Y
    DEY
    PLA
    STA (TempPointer04),Y

NextEnemyMovement:
    DEX
    BPL UpdateNextEnemyMovement
    RTS
