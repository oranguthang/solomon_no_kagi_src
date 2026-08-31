; Cooperative wait for an incrementing zero-page counter

.segment "PRG_COUNTER_WAIT"

WaitForZeroPageCounterAboveThreshold:
    PHA
    TXA
    PHA
    JSR SwitchThreads
    PLA
    TAX
    PLA
    CMP ZeroPageCounterBase,X
    BCS WaitForZeroPageCounterAboveThreshold
    RTS
