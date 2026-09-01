; Countdown thresholds and the two timer-warning PPU update streams

.segment "PRG_TIMER_WARNING_DATA"

; This three-byte prefix matches the timer HUD writer header at $A271, but no
; direct reference to this copy has been proved yet
PreTimerWarningTableBytes:
    .byte $20, $69, $44

; The fourth BCD threshold is also the high address byte of the following PPU
; command. The original data deliberately shares that byte
TimerWarningThresholds:
    .byte $02, $04, $10

EnterTimerWarningPpuUpdate:
    .byte $23, $c2, $41, $f0, $30, $00

LeaveTimerWarningPpuUpdate:
    .byte $23, $c2, $41, $a0, $20, $00
