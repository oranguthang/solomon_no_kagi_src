; Cooperative waits for masked zero-page state

.segment "PRG_MASKED_RAM_WAIT"

WaitForMaskedBitsClear:
    PHA
    TAY
    TXA
    PHA
    TYA
    AND WaitMaskAddressBase,X
    BEQ FinishMaskedRamWait
    JSR SwitchThreads
    PLA
    TAX
    PLA
    BCS WaitForMaskedBitsClear

FinishMaskedRamWait:
    PLA
    PLA
    RTS

WaitForMaskedBitsSet:
    PHA
    TAY
    TXA
    PHA
    TYA
    AND WaitMaskAddressBase,X
    BNE FinishMaskedRamWait
    JSR SwitchThreads
    PLA
    TAX
    PLA
    BCS WaitForMaskedBitsSet
