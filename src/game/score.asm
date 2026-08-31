; Decimal score addition with game-state gating

.segment "PRG_SCORE_ADDITION"

ScoreDigitBase = $0A

AddScoreByAAtDigitX:
    ROR GameStateFlags
    BCS AddPendingScore
    LDA #$00

AddPendingScore:
    ROL GameStateFlags
    CLC

AddNextScoreDigit:
    ADC ScoreDigits,X
    CMP #ScoreDigitBase
    BCC StoreScoreDigit
    SBC #ScoreDigitBase

StoreScoreDigit:
    STA ScoreDigits,X
    LDA #$00
    DEX
    BPL AddNextScoreDigit
    RTS
