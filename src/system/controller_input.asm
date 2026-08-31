; Two-port controller sampling and cached-input update

.segment "PRG_CONTROLLER_INPUT"

ControllerBitCount = $08
ControllerStrobeValue = $01

ReadJoyPads:
    LDA #ControllerStrobeValue
    STA a:JOYPAD1
    LSR A
    TAX
    STA a:JOYPAD1
    STA ControllerShiftRegister
    LDY #ControllerBitCount
    JSR ReadJoyPad
    STY ControllerShiftRegister
    INX
    LDY #ControllerBitCount
    JSR ReadJoyPad
    LDA GameStateFlags
    LSR A

UpdateJoypadCache:
    LDA Joypad1Raw,X
    BCS CacheCompleteJoypadState
    AND #JOY_BUTTON_START_SELECT_MASK
    STA ControllerPortSample
    LDA Joypad1Cached,X
    AND #JOY_BUTTON_GAMEPLAY_MASK
    ORA ControllerPortSample

CacheCompleteJoypadState:
    STA Joypad1Cached,X
    DEX
    BPL UpdateJoypadCache
    RTS

ReadJoyPad:
    LDA a:JOYPAD1,X
    STA ControllerPortSample
    ROR A
    ORA ControllerPortSample
    ROR A
    ROL ControllerShiftRegister
    DEY
    BNE ReadJoyPad
    LDA ControllerShiftRegister
    STA Joypad1Raw,X
    RTS
