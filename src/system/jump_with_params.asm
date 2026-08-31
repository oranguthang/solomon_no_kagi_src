; Dispatch through a little-endian pointer appendix following the caller's JSR

.segment "PRG_JUMP_WITH_PARAMS"

JumpWithParams:
    ASL A
    TAY
    INY
    PLA
    STA TempPointer00
    PLA
    STA TempPointer00 + 1
    LDA (TempPointer00),Y
    PHA
    INY
    LDA (TempPointer00),Y
    STA TempPointer00 + 1
    PLA
    STA TempPointer00
    JMP (TempPointer00)
