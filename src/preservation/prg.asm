; Address-ordered PRG preservation listing beginning at CPU $A998
; Keep byte-identical through make verify

.segment "PRG_PRE_ENEMY_POINTERS"

    LDY #$01
    LDA ($2C),Y
    CMP #$20
    BCC _label_bank0_a9a8
    LDY #$03
    LDA #$18
    ORA ($2E),Y
    STA ($2E),Y

_label_bank0_a9a8:
    RTS

    LDY #$06
    LDA ($2C),Y
    ASL A
    TAX
    LDY #$03
    LDA ($2E),Y
    AND #$02
    CLC
    BNE _label_bank0_a9b9
    SEC

_label_bank0_a9b9:
    TXA
    ROR A
    STA $00
    LDY #$08
    LDA ($2E),Y
    EOR $00
    AND #$40
    BNE _label_bank0_a9d8
    LDY #$00
    LDA ($2C),Y
    AND #$10
    BNE _label_bank0_a9d1
    LDA #$80

_label_bank0_a9d1:
    AND #$80
    ROL $00
    ROR A
    BCC _label_bank0_a9dc

_label_bank0_a9d8:
    LDA #$40
    EOR $00

_label_bank0_a9dc:
    LDY #$06
    STA ($2C),Y
    LDY #$00
    LDA ($2C),Y
    AND #$F7
    STA $00
    LDY #$03
    LDA #$02
    AND ($2E),Y
    BEQ _label_bank0_a9f2
    LDA #$08

_label_bank0_a9f2:
    LDY #$00
    ORA $00
    STA ($2C),Y
    JMP $AA4C
    LDY #$06
    LDA ($2C),Y
    AND #$BF
    TAX
    LDY #$03
    LDA ($2E),Y
    LSR A
    TXA
    BCS _label_bank0_aa0c
    ORA #$40

_label_bank0_aa0c:
    STA $00
    LDY #$05
    LDA ($2E),Y
    ASL A
    EOR $00
    BPL _label_bank0_aa2b
    LDY #$00
    LDA ($2C),Y
    AND #$08
    BNE _label_bank0_aa21
    LDA #$80

_label_bank0_aa21:
    AND #$80
    ASL $00
    ASL A
    LDA $00
    ROR A
    BCC _label_bank0_aa2f

_label_bank0_aa2b:
    LDA #$80
    EOR $00

_label_bank0_aa2f:
    LDY #$06
    STA ($2C),Y
    LDY #$00
    LDA ($2C),Y
    AND #$EF
    STA $00
    LDY #$03
    LDA ($2E),Y
    ROR A
    LDA #$00
    BCC _label_bank0_aa46
    LDA #$10

_label_bank0_aa46:
    LDY #$00
    ORA $00
    STA ($2C),Y
    LDY #$03
    LDA ($2E),Y
    AND #$01
    ORA #$18
    STA ($2E),Y
    RTS

    LDY #$04

_label_bank0_aa59:
    LDA ($2C),Y
    ASL A
    ADC #$08
    CMP #$11
    BCS _label_bank0_aa68
    INY
    CPY #$06
    BNE _label_bank0_aa59
    CLC

_label_bank0_aa68:
    RTS

    LDX #$00
    BEQ _label_bank0_aa6f
    LDX #$04

_label_bank0_aa6f:
    LDY #$01
    LDA ($2C),Y
    BNE _label_bank0_aa76
    RTS

_label_bank0_aa76:
    LDA #$00
    STA ($2C),Y
    STX $00
    LDX #$06

_label_bank0_aa7e:
    STA $01,X
    DEX
    BPL _label_bank0_aa7e
    LDY #$06
    LDA ($2C),Y
    CLC
    ADC $00
    TAX
    LDA $AB1F,X
    STA $00
    LDA $AB27,X
    STA $01
    LDX #$01

_label_bank0_aa97:
    ASL $00,X
    BCC _label_bank0_aa9d
    DEC $02,X

_label_bank0_aa9d:
    ASL $00,X
    ROL $02,X
    ASL $00,X
    ROL $02,X
    DEX
    BPL _label_bank0_aa97
    LDX #$01
    LDY #$09

_label_bank0_aaac:
    LDA ($2E),Y
    CLC
    ADC $00,X
    STA ($2E),Y
    INY
    LDA ($2E),Y
    STA $00,X
    ADC $02,X
    STA $02,X
    LDY #$06
    DEX
    BPL _label_bank0_aaac
    LDX #$01
    STX $06

_label_bank0_aac5:
    LDY #$00
    STY $07
    LDY #$03

_label_bank0_aacb:
    LDA $06
    ASL A
    TAX
    LDA $AB2F,Y
    CLC
    ADC $00,X
    STA $04
    LDA $AB33,Y
    CLC
    ADC $01,X
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    LDA $0304,X
    ASL A
    ROL $07
    DEY
    BPL _label_bank0_aacb
    LDA $07
    PHA
    DEC $06
    BPL _label_bank0_aac5
    PLA
    STA $06
    PLA
    STA $07
    LDA $06
    LDX #$00
    JSR JumpWithParams

    .byte $37, $ab, $8b, $ab
    .byte $b0, $ab, $16, $ac, $d2, $ab, $ef, $ac, $77, $ac, $b3, $ac, $f4, $ab, $60, $ac
    .byte $f9, $ac, $9f, $ac, $43, $ac, $c7, $ac, $db, $ac, $53, $ac, $00, $00, $de, $22
    .byte $00, $00, $b4, $4c, $22, $de, $00, $00, $4c, $b4, $00, $00, $04, $04, $0e, $0e
    .byte $03, $0e, $0e, $03

    LDY #$07
    LDA #$00
    CMP $07,X
    BEQ _label_bank0_ab78
    LDA ($2C),Y
    STA $05,X
    DEY
    LDA ($2C),Y
    STA $04,X
    LDY #$00
    LDA $07,X

_label_bank0_ab4c:
    INY
    LSR A
    BCC _label_bank0_ab4c
    BEQ _label_bank0_ab5a
    LDY #$06
    LDA $05,X
    STA ($2C),Y
    BPL _label_bank0_ab78

_label_bank0_ab5a:
    DEY
    TYA
    ASL A
    TAY
    LDA $04,X
    CMP #$02
    BCC _label_bank0_ab65
    INY

_label_bank0_ab65:
    LDA $05,X
    CMP $AB7B,Y
    BNE _label_bank0_ab78
    PHA
    LDA $AB83,Y
    LDY #$07
    STA ($2C),Y
    PLA
    DEY
    STA ($2C),Y

_label_bank0_ab78:
    JMP $AC53

    .byte $02, $01, $02, $00, $03, $00, $03, $01
    .byte $00, $03, $01, $03, $01, $02, $00, $02

    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_ab98
    JSR $AD03
    BNE _label_bank0_ab9b

_label_bank0_ab98:
    JSR $AD15

_label_bank0_ab9b:
    LDA $07,X
    BNE _label_bank0_abad
    LDA #$01
    BCS _label_bank0_aba5
    LDA #$02

_label_bank0_aba5:
    STA ($2C),Y
    EOR #$02
    INY
    STA ($2C),Y
    RTS

_label_bank0_abad:
    JMP $AC53
    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_abbd
    JSR $AD03
    BNE _label_bank0_abc0

_label_bank0_abbd:
    JSR $AD1E

_label_bank0_abc0:
    LDA $07,X
    BNE _label_bank0_abad
    LDA #$00
    BCS _label_bank0_abca
    LDA #$02

_label_bank0_abca:
    STA ($2C),Y
    INY
    EOR #$03
    STA ($2C),Y
    RTS

    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_abdf
    JSR $AD0C
    BNE _label_bank0_abe2

_label_bank0_abdf:
    JSR $AD1E

_label_bank0_abe2:
    LDA $07,X
    BNE _label_bank0_abad
    LDA #$00
    BCS _label_bank0_abec
    LDA #$03

_label_bank0_abec:
    STA ($2C),Y
    INY
    EOR #$02
    STA ($2C),Y
    RTS

    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_ac01
    JSR $AD0C
    BNE _label_bank0_ac04

_label_bank0_ac01:
    JSR $AD15

_label_bank0_ac04:
    LDA $07,X
    BNE _label_bank0_ac53
    LDA #$01
    BCS _label_bank0_ac0e
    LDA #$03

_label_bank0_ac0e:
    STA ($2C),Y
    INY
    EOR #$03
    STA ($2C),Y
    RTS

    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_ac28
    JSR $AD03
    INY
    LDA #$03
    STA ($2C),Y
    BPL _label_bank0_ac53

_label_bank0_ac28:
    LSR A
    BCS _label_bank0_ac53

_label_bank0_ac2b:
    LDY #$0A
    LDA ($2E),Y
    AND #$0F
    CMP #$08
    LDA #$00
    BCC _label_bank0_ac39
    LDA #$01

_label_bank0_ac39:
    LDY #$06
    STA ($2C),Y
    RTS

_label_bank0_ac3e:
    LSR A
    BCC _label_bank0_ac53
    BCS _label_bank0_ac2b
    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCS _label_bank0_ac3e
    JSR $AD0C
    INY
    LDA #$02
    STA ($2C),Y

_label_bank0_ac53:
    LDY #$07
    LDA $02,X
    STA ($2E),Y
    LDY #$0A
    LDA $03,X
    STA ($2E),Y
    RTS

    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCC _label_bank0_ac72
    JSR $AD15
    INY
    LDA #$00
    STA ($2C),Y

_label_bank0_ac70:
    BPL _label_bank0_ac53

_label_bank0_ac72:
    LSR A
    BCC _label_bank0_ac70
    BCS _label_bank0_ac8d
    LDY #$06
    LDA ($2C),Y
    CMP #$02
    BCC _label_bank0_ac8a
    JSR $AD1E
    LDY #$07
    LDA #$01
    STA ($2C),Y

_label_bank0_ac88:
    BPL _label_bank0_ac53

_label_bank0_ac8a:
    LSR A
    BCS _label_bank0_ac88

_label_bank0_ac8d:
    LDY #$07
    LDA ($2C),Y
    AND #$0F
    CMP #$0B
    LDA #$02
    BCS _label_bank0_ac9b
    LDA #$03

_label_bank0_ac9b:
    DEY
    STA ($2C),Y
    RTS

_label_bank0_ac9f:
    LDY #$06
    LDA ($2C),Y
    TAY
    LDA $AD27,Y
    BMI _label_bank0_ac53
    LDY #$06
    STA ($2C),Y
    EOR #$03
    INY
    STA ($2C),Y
    RTS

_label_bank0_acb3:
    LDY #$06
    LDA ($2C),Y
    TAY
    LDA $AD2B,Y
    BMI _label_bank0_ac53
    LDY #$06
    STA ($2C),Y
    EOR #$02
    INY
    STA ($2C),Y
    RTS

_label_bank0_acc7:
    LDY #$06
    LDA ($2C),Y
    TAY
    LDA $AD2F,Y

_label_bank0_accf:
    BMI _label_bank0_ac53
    LDY #$06
    STA ($2C),Y
    EOR #$02
    INY
    STA ($2C),Y
    RTS

_label_bank0_acdb:
    LDY #$06
    LDA ($2C),Y
    TAY
    LDA $AD33,Y
    BMI _label_bank0_accf
    LDY #$06
    STA ($2C),Y
    EOR #$03
    INY
    STA ($2C),Y
    RTS

    LDA $02,X
    ADC #$01
    AND #$08
    BNE _label_bank0_acb3
    BEQ _label_bank0_acc7
    LDA $02,X
    ADC #$01
    AND #$08
    BNE _label_bank0_ac9f
    BEQ _label_bank0_acdb
    LDA #$F0
    AND $02,X
    ORA #$0B
    STA $02,X
    RTS

    LDA #$F0
    AND $02,X
    ORA #$02
    STA $02,X
    RTS

    LDA #$F0
    AND $03,X
    ORA #$04
    STA $03,X
    RTS

    LDA #$F0
    AND $03,X
    ORA #$0A
    STA $03,X
    RTS

    .byte $80, $03, $00, $80, $03, $80, $01, $80, $80, $02, $80, $00
    .byte $02, $80, $80, $01

    JSR $B341
    JSR JumpWithParams
    TAY
    LDA $AD45
    ASL $41AE,X
    LDX $01A0
    LDA ($2C),Y
    CMP #$0A
    BCC _label_bank0_ad78
    LDY #$03
    LDA ($2E),Y
    AND #$03
    ORA #$08
    STA ($2E),Y
    JSR $AD79
    LDY #$06
    LDA ($2C),Y
    JSR LoadEnemyObjectPointer
    LDA $07
    BEQ _label_bank0_ad78
    JSR $B156
    JSR ConvertPixelCoordinatesToMapIndex
    TAY
    LDA $0304,Y
    CMP #$F8
    BCS _label_bank0_ad78
    STY $04
    JSR ApplyMapTileInteractionToObject

_label_bank0_ad78:
    RTS

    LDY #$07
    LDA ($2E),Y
    STA $02
    LDY #$0A
    LDA ($2E),Y
    STA $03
    LDA #$00
    STA $07
    LDY #$03

_label_bank0_ad8b:
    LDA $AE19,Y
    CLC
    ADC $02
    STA $04
    LDA $AE1A,Y
    CLC
    ADC $03
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    LDA $0304,X
    ASL A
    ROL $07
    DEY
    BPL _label_bank0_ad8b
    RTS

    LDY #$03
    LDA ($2E),Y
    LSR A
    STA $00
    LDY #$05
    LDA ($2C),Y
    ROL A
    LDA $00
    ROL A
    LDY #$03
    STA ($2E),Y
    JSR $AD79
    LDA $07
    BNE _label_bank0_add2
    LDY #$08
    LDA ($2E),Y
    LDY #$05
    ORA ($2E),Y
    BNE _label_bank0_ae18
    DEY
    TYA
    STA ($2E),Y
    BPL _label_bank0_ae18

_label_bank0_add2:
    LDA #$00
    LDY #$05
    STA ($2E),Y
    LDY #$08
    STA ($2E),Y
    LDY #$01
    LDA ($2E),Y
    AND #$40
    BEQ _label_bank0_adf3
    LDA $07
    JSR $B156
    JSR ConvertPixelCoordinatesToMapIndex
    LDA $0304,X
    CMP #$F8
    BCS _label_bank0_ae34

_label_bank0_adf3:
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_ae18
    TXA
    LDY #$06
    STA ($2C),Y
    LDY #$00
    LDA #$80
    STA ($04),Y
    INY
    ASL A
    STA ($2C),Y
    DEY
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y
    LDY #$03
    LDA ($2E),Y
    AND #$03
    ORA #$04
    STA ($2E),Y

_label_bank0_ae18:
    RTS

    ORA ($01,X)
    ASL $010E
    LDY #$01
    LDA ($2C),Y
    CMP #$19
    BCC _label_bank0_ae40
    DEY
    LDA ($2C),Y
    LSR A
    BCC _label_bank0_ae34
    ASL A
    STA ($2C),Y
    LDX #$01
    JSR $B19E

_label_bank0_ae34:
    LDY #$03
    LDA #$02
    EOR ($2E),Y
    AND #$03
    ORA #$0C
    STA ($2E),Y

_label_bank0_ae40:
    RTS

    JSR $AD79
    LDA $07
    BNE _label_bank0_ae50
    LDY #$03
    LDA #$03
    AND ($2E),Y
    STA ($2E),Y

_label_bank0_ae50:
    RTS

    JSR $B341
    JSR JumpWithParams

    .byte $65, $ae, $08, $b0, $70, $af, $5c, $a5, $b2, $ae, $e2, $ae
    .byte $8f, $b1

    LDY #$01
    LDA ($2C),Y
    TAX
    LDY #$03
    LDA ($2E),Y
    AND #$02
    BNE _label_bank0_ae80
    CPX #$0C
    BCC _label_bank0_ae7f
    LDA ($2E),Y
    ORA #$02
    STA ($2E),Y
    JSR $B264

_label_bank0_ae7f:
    RTS

_label_bank0_ae80:
    CPX #$1B
    BCC _label_bank0_ae7f
    LDY #$00
    LDA #$FE
    AND ($2C),Y
    STA ($2C),Y
    LDX #$01
    JSR $B19E
    JSR $B410
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA $0304,X
    STA $00
    LDY #$08
    LDA #$01
    STA ($2E),Y
    LDY #$03
    AND ($2E),Y
    ROL $00
    BCC _label_bank0_aead
    EOR #$01

_label_bank0_aead:
    ORA #$14
    STA ($2E),Y
    RTS

    LDY #$03
    LDA ($2E),Y
    AND #$02
    BNE _label_bank0_aecb
    JSR $B0CE
    BNE _label_bank0_af02
    LDY #$03
    LDA #$01
    AND ($2E),Y
    ORA #$16
    STA ($2E),Y
    BNE _label_bank0_aefb

_label_bank0_aecb:
    LDY #$01
    LDA ($2C),Y
    CMP #$0C
    BCC _label_bank0_aee1
    LDY #$08
    LDA #$01
    STA ($2E),Y
    LDY #$03
    LDA #$FD
    AND ($2E),Y
    STA ($2E),Y

_label_bank0_aee1:
    RTS

    LDA #$08
    STA $00
    JSR $B0DE
    BCS _label_bank0_af02
    LDY #$03
    LDA ($2E),Y
    TAX
    AND #$02
    BNE _label_bank0_af02
    TXA
    AND #$01
    ORA #$12
    STA ($2E),Y

_label_bank0_aefb:
    LDY #$01
    LDA #$00
    STA ($2C),Y
    RTS

_label_bank0_af02:
    JSR $B0CE
    BEQ _label_bank0_af33
    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_af5b
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_af5b
    TXA
    LDY #$06
    STA ($2C),Y
    LDY #$00
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y
    LDA #$80
    STA ($04),Y
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y
    LDA #$01
    LDY #$03
    AND ($2E),Y
    STA ($2E),Y
    BPL _label_bank0_aefb

_label_bank0_af33:
    LDY #$03
    LDA ($2E),Y
    TAX
    AND #$02
    BNE _label_bank0_af45
    TXA
    AND #$01
    ORA #$16
    STA ($2E),Y
    BNE _label_bank0_aefb

_label_bank0_af45:
    LDY #$01
    LDA ($2C),Y
    CMP #$18
    BCC _label_bank0_af5b
    LDY #$08
    LDA #$01
    STA ($2E),Y
    LDY #$03
    EOR ($2E),Y
    AND #$FD
    STA ($2E),Y

_label_bank0_af5b:
    RTS

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
