; Context-three gameplay service loop entered by scheduler code $30

.segment "PRG_MAIN_THREAD"

MainGameplayThread:
    JSR DecrementTimer
    JSR $A274
    JSR $A0A7
    JSR $A04C
    JSR SwitchThreads
    JSR $A2DC
    JSR SwitchThreads
    JSR $C432
    JSR SwitchThreads
    JSR $A3A4
    JSR SwitchThreads
    LDA FairiesQueued
    BEQ ContinueMainGameplayThread
    JSR $B42A
    BCC ContinueMainGameplayThread
    DEC FairiesQueued
    LDA #$80
    LDY #$00
    STA ($04),Y
    STX $06
    LDY #$05
    LDA ($30),Y
    STA $04
    JSR $91A3
    LDA #$1C
    STA $07
    JSR $A3D7
    JSR $A3F8

ContinueMainGameplayThread:
    JMP MainGameplayThread
