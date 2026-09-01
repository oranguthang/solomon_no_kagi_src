; Convert an unsigned value in X to blank-padded tens in X and ones in A

.segment "PRG_TWO_DIGIT_NUMBER"

FormatTwoDigitNumberTiles:
    TXA
    LDX #$00

CountTwoDigitTens:
    CMP #$0A
    BCC SelectTwoDigitTensTile
    SBC #$0A
    INX
    BNE CountTwoDigitTens

SelectTwoDigitTensTile:
    CPX #$00
    BNE FinishTwoDigitNumberTiles
    LDX #$24

FinishTwoDigitNumberTiles:
    RTS
