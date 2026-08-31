; Reset and select the standard gameplay delay counter

.segment "PRG_GAMEPLAY_DELAY_SETUP"

ResetAndSelectGameplayDelayCounter:
    LDA #$00
    STA GameplayDelayCounter
    LDX #GameplayDelayCounter
    RTS
