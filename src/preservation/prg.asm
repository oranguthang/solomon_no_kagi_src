; Address-ordered PRG preservation listing beginning at CPU $AF5C
; Keep byte-identical through make verify

.segment "PRG_PRE_ENEMY_POINTERS"

    JSR $B341
    JSR JumpWithParams

    .byte $7b
    .byte $af, $08, $b0, $70, $af, $5c, $a5, $5c, $a5, $55, $b0, $5c, $a5

    LDY #$03
    LDA #$01
    AND ($2E),Y
    ORA #$18
    STA ($2E),Y
    RTS

    LDY #$01
    LDA ($2C),Y
    TAX
    LDY #$03
    LDA ($2E),Y
    AND #$02
    BEQ _label_bank0_afab
    CPX #$50
    BCC _label_bank0_b001
    LDA #$00
    LDY #$01
    STA ($2C),Y
    TYA
    LDY #$08
    STA ($2E),Y
    LDX #$00
    JSR $B0CE
    BNE _label_bank0_af9f
    INX

_label_bank0_af9f:
    LDY #$03
    LDA ($2E),Y
    LSR A
    TXA
    ROL A
    ORA #$14
    STA ($2E),Y
    RTS

_label_bank0_afab:
    CPX #$10
    BCC _label_bank0_b001
    LDA ($2E),Y
    TAX
    ORA #$02
    STA ($2E),Y
    STX $03
    LDA $B004,X
    STA $04
    LDA $B002,X
    STA $05
    LDY #$06
    LDA ($2C),Y
    STA $02
    JSR LoadEnemyAiPointer
    LDY #$00
    LDA #$FE
    AND ($2C),Y
    STA ($2C),Y
    INY
    LDA #$00
    STA ($00),Y
    LDA $02
    JSR LoadEnemyObjectPointer
    LDY #$07
    LDA ($2E),Y
    CLC
    ADC $04
    STA ($00),Y
    LDY #$0A
    LDA ($2E),Y
    CLC
    ADC $05
    STA ($00),Y
    LDA #$C0
    STA $04
    LDA #$20
    STA $05
    LDA $03
    JSR InitializeObjectStateHeader
    LDY #$17
    JSR AddSoundEffect

_label_bank0_b001:
    RTS

    .byte $06
    .byte $fa, $00, $00, $fa, $06

    LDY #$00
    LDA ($2C),Y
    TAX
    AND #$08
    BNE _label_bank0_b021
    TXA
    ORA #$08
    STA ($2C),Y
    LDA #$01
    LDY #$03
    AND ($2E),Y
    ORA #$14
    STA ($2E),Y
    RTS

_label_bank0_b021:
    LDY #$03
    LDA ($2E),Y
    AND #$02
    BEQ _label_bank0_b034
    LDA #$04
    STA ($2E),Y
    LDY #$01
    LDA #$00
    STA ($2C),Y

_label_bank0_b033:
    RTS

_label_bank0_b034:
    LDY #$01
    LDA ($2C),Y
    CMP #$11
    BCC _label_bank0_b033
    DEY
    LDA #$40
    AND ($2C),Y
    BNE _label_bank0_b046
    JMP DeactivateCurrentEnemy

_label_bank0_b046:
    LDY #$03

_label_bank0_b048:
    LDA $B051,Y
    STA ($2E),Y
    DEY
    BPL _label_bank0_b048
    RTS

    .byte $e2, $1c
    .byte $ff, $00

    LDA #$18
    STA $00
    JSR $B0CE
    BNE _label_bank0_b098
    JSR $B0DE
    BCS _label_bank0_b0a3
    LDY #$03
    LDA #$02
    ORA ($2E),Y
    STA ($2E),Y

_label_bank0_b06b:
    LDY #$01
    LDA ($2C),Y
    CMP #$68
    BCC _label_bank0_b097
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_b097
    LDY #$00
    LDA #$80
    STA ($04),Y
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y
    TXA
    LDY #$06
    STA ($2C),Y
    LDA #$00
    LDY #$01
    STA ($2C),Y
    LDY #$03
    LDA #$01
    AND ($2E),Y
    STA ($2E),Y

_label_bank0_b097:
    RTS

_label_bank0_b098:
    JSR $B0DE
    BCC _label_bank0_b06b
    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_b097

_label_bank0_b0a3:
    LDY #$03
    LDA ($2E),Y
    TAX
    AND #$02
    BNE _label_bank0_b0b7
    TXA
    ORA #$02
    STA ($2E),Y
    LDY #$02
    LDA #$00
    STA ($2C),Y

_label_bank0_b0b7:
    LDY #$02
    LDA ($2C),Y
    CMP #$18
    BCC _label_bank0_b0cd
    LDY #$08
    LDA #$01
    STA ($2E),Y
    LDY #$03
    EOR ($2E),Y
    AND #$FD
    STA ($2E),Y

_label_bank0_b0cd:
    RTS

    LDY #$03
    LDA ($2E),Y
    LSR A
    LDA #$20
    BCC _label_bank0_b0d9
    LDA #$10

_label_bank0_b0d9:
    LDY #$0B
    AND ($2E),Y
    RTS

    LDY #$04
    LDA ($2C),Y
    ASL A
    BCS _label_bank0_b0e7
    EOR #$FF

_label_bank0_b0e7:
    CMP $00
    BCS _label_bank0_b0fa
    INY
    LDA ($2C),Y
    ROL A
    ROL A
    CLC
    LDY #$03
    EOR ($2E),Y
    AND #$01
    BEQ _label_bank0_b0fa
    SEC

_label_bank0_b0fa:
    RTS

    JSR $B341
    JSR JumpWithParams

    .byte $07, $b1
    .byte $4a, $b1, $18, $b1

    LDY #$01
    LDA ($2C),Y
    CMP #$0A
    BCC _label_bank0_b117
    LDY #$03
    LDA #$08
    ORA ($2E),Y
    STA ($2E),Y

_label_bank0_b117:
    RTS

    JSR $AD79
    LDA $07
    BEQ _label_bank0_b149
    JSR $B156
    JSR ConvertPixelCoordinatesToMapIndex
    TAY
    LDA $0304,Y
    CMP #$F8
    BCC _label_bank0_b130
    JMP DeactivateCurrentEnemy

_label_bank0_b130:
    STY $04
    LDX $2E
    STX $00
    LDX $2F
    STX $01
    JSR ApplyMapTileInteractionToObject
    LDY #$01
    LDA #$20
    STA ($2E),Y
    LDY #$03
    LDA #$04
    STA ($2E),Y

_label_bank0_b149:
    RTS

    LDY #$01
    LDA ($2C),Y
    CMP #$0F
    BCS _label_bank0_b153
    RTS

_label_bank0_b153:
    JMP DeactivateCurrentEnemy
    AND #$0F
    LDX #$FF

_label_bank0_b15a:
    INX
    LSR A
    BCC _label_bank0_b15a
    LDY #$07
    LDA $B173,X
    CLC
    ADC ($2E),Y
    STA $04
    LDY #$0A
    LDA $B174,X
    CLC
    ADC ($2E),Y
    STA $05
    RTS

    .byte $00, $00, $0f, $0f, $00

    JSR ApplyEnemyLifetimeThreshold
    JSR $B341
    JSR JumpWithParams

    .byte $5f, $b3
    .byte $a2, $b2, $70, $af, $b5, $b1, $5c, $a5, $b6, $b2, $8f, $b1

    LDY #$00
    LDA ($2C),Y
    AND #$03
    BEQ _label_bank0_b1aa
    TAX
    LDA ($2C),Y
    AND #$F8
    STA ($2C),Y
    STX $00
    LDY #$06
    JSR $B1AB
    LDY #$07
    JSR $B1AB

_label_bank0_b1aa:
    RTS

    LSR $00
    BCC _label_bank0_b1aa
    LDA ($2C),Y
    JSR DeactivateEnemySlot
    RTS
    LDY #$03
    LDA ($2E),Y
    LDY #$01
    AND #$02
    BEQ _label_bank0_b225
    LDA ($2C),Y
    CMP #$20
    BCC _label_bank0_b218
    TAX
    DEY
    LDA ($2C),Y
    AND #$04
    BNE _label_bank0_b1df
    CPX #$2C
    BCS _label_bank0_b1f3
    LDA #$04
    ORA ($2C),Y
    STA ($2C),Y
    JSR $B219
    AND #$FD
    STA ($00),Y
    RTS

_label_bank0_b1df:
    CPX #$2C
    BCC _label_bank0_b218
    LDA ($2C),Y
    AND #$FB
    STA ($2C),Y
    JSR $B219
    ORA #$02
    STA ($00),Y
    JSR $B402

_label_bank0_b1f3:
    CPX #$34
    BCC _label_bank0_b218
    LDA ($2C),Y
    AND #$03
    TAX
    LDA ($2C),Y
    AND #$F8
    STA ($2C),Y
    TYA
    INY
    STA ($2C),Y
    JSR $B19E
    LDY #$03
    LDA ($2E),Y
    LSR A
    LDA #$0A
    ROL A
    STA ($2E),Y
    TYA
    LDY #$08
    STA ($2E),Y

_label_bank0_b218:
    RTS

    LDY #$07
    LDA ($2C),Y
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA ($00),Y
    RTS

_label_bank0_b225:
    LDA ($2C),Y
    CMP #$18
    BCC _label_bank0_b218
    LDY #$03
    LDA ($2E),Y
    ORA #$02
    STA ($2E),Y
    STA $02
    LDY #$0B
    JSR AddSoundEffect
    LDY #$07
    LDA ($2C),Y
    JSR LoadEnemyObjectPointer
    LDA ($2E),Y
    STA ($00),Y
    LDA #$04
    STA $05
    LDA #$C6
    STA $04
    ROR $02
    LDA #$05
    ROL A
    TAX
    ROR A
    LDA #$EF
    BCS _label_bank0_b25a
    LDA #$10

_label_bank0_b25a:
    LDY #$0A
    ADC ($2E),Y
    STA ($00),Y
    TXA
    JSR InitializeObjectStateHeader
    JSR $B410
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA $0304,X
    BPL _label_bank0_b289
    STX $04
    LDY #$06
    LDA ($2C),Y
    JSR LoadEnemyObjectPointer
    LDY #$03
    LDA ($2E),Y
    AND #$01
    STA $02
    LDY $04
    LDA $0304,Y
    JSR ApplyMapTileInteractionToObject

_label_bank0_b289:
    RTS
