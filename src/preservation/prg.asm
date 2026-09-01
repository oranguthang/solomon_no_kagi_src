; Address-ordered PRG preservation listing beginning at CPU $80FF
; Keep byte-identical through make verify

.segment "PRG_PRE_STARTUP"
    LDA #$13
    STA $08
    JSR $8326

_label_bank0_8106:
    RTS
    LDA $28
    EOR #$80
    STA $28
    BPL _label_bank0_8106
    AND #$10
    BNE _label_bank0_8106
    LDA $057F
    CMP #$C0
    BCC _label_bank0_8106
    LDA $05A7
    CMP #$C0
    BCC _label_bank0_816a
    LDA #$10
    STA $0A
    LDX $05AE
    DEX
    DEX
    STX $0C
    LDX $05B1
    DEX
    STX $0D
    LDX #$00
    STX $0B

_label_bank0_8136:
    LDX $0A
    LDA EnemyObjectPointerLowTable,X
    STA $08
    LDA EnemyObjectPointerHighTable,X
    STA $09
    LDX #$00
    JSR $81B1
    BCS _label_bank0_815d
    STY $0B
    LDY #$00
    LDA #$01
    ORA ($08),Y
    STA ($08),Y
    LDA $05A8
    CMP #$10
    BCS _label_bank0_815d
    STA $042D

_label_bank0_815d:
    DEC $0A
    BPL _label_bank0_8136
    LDA $0B
    BEQ _label_bank0_816a
    LDA #$50
    JSR $836F

_label_bank0_816a:
    LDA #$10
    STA $0A
    LDA $0586
    SEC
    SBC #$05
    STA $0C
    LDX $0582
    CPX #$1C
    LDA #$00
    BCC _label_bank0_8187
    TXA
    ROR A
    LDA #$03
    BCS _label_bank0_8187
    LDA #$FC

_label_bank0_8187:
    ADC $0589
    STA $0D

_label_bank0_818c:
    LDX $0A
    LDA EnemyObjectPointerLowTable,X
    STA $08
    LDA EnemyObjectPointerHighTable,X
    STA $09
    LDX #$01
    JSR $81B1
    BCS _label_bank0_81ac
    LDA #$10
    ORA $28
    STA $28
    LDA #$31
    JSR $836F
    BPL _label_bank0_81b0

_label_bank0_81ac:
    DEC $0A
    BPL _label_bank0_818c

_label_bank0_81b0:
    RTS
    SEC
    LDY #$00
    LDA ($08),Y
    BPL _label_bank0_81d6
    AND $81DB,X
    BNE _label_bank0_81d6
    LDY #$07
    LDA ($08),Y
    SBC $0C
    ADC #$06
    CMP $81D7,X
    BCS _label_bank0_81d6
    LDY #$0A
    LDA ($08),Y
    SEC
    SBC $0D
    ADC #$05
    CMP $81D9,X

_label_bank0_81d6:
    RTS

    .byte $0f, $13, $0e, $0d, $05, $03

    LDA $042A
    BPL _label_bank0_825f
    LDA $05A7
    CMP #$C0
    BCC _label_bank0_825f
    LDX #$03
    LDA #$00

_label_bank0_81ed:
    STA $08,X
    DEX
    BPL _label_bank0_81ed
    LDY $0430
    STY $05AA
    LDA $8260,Y
    STA $0A
    LDA $8264,Y
    STA $0B
    LDA $05AD
    CLC
    ADC $08
    STA $05AD
    LDA $05AE
    STA $08
    ADC $0A
    STA $0A
    LDA $05B0
    ADC $09
    STA $05B0
    LDA $05B1
    STA $09
    ADC $0B
    STA $0B
    JSR $8299
    LDA $09
    STA $0E
    LDA $0A
    STA $08
    LDA $0B
    STA $09
    JSR $8299
    LDA $09
    STA $0F
    LDX #$2F
    LDY #$03

_label_bank0_823f:
    LDA $00,X
    STA $06,X
    LDA $8268,Y
    STA $00,X
    DEX
    DEY
    BPL _label_bank0_823f
    LDY $0E
    LDX #$08
    JSR $826C
    LDX #$2F
    LDY #$03

_label_bank0_8257:
    LDA $06,X
    STA $00,X
    DEX
    DEY
    BPL _label_bank0_8257

_label_bank0_825f:
    RTS

    .byte $00, $00, $fe
    .byte $02, $02, $fe, $00, $00, $2a, $04, $a7, $05

    LDA $8279,Y
    STA $08
    LDA $8289,Y
    STA $09
    JMP ($0008)

    .byte $37, $8b, $b0, $16, $d2, $ef, $77, $b3, $f4, $60
    .byte $f9, $9f, $43, $c7, $db, $37
    .byte $ab, $ab, $ab, $ac, $ab, $ac, $ac, $ac, $ab, $ac
    .byte $ac, $ac, $ac, $ac, $ac, $ab

    LDA #$00
    STA $0C
    LDA $08
    SEC
    SBC #$0C
    STA $08
    CLC
    LDA #$0A
    ADC $08
    EOR $08
    AND #$F0
    BNE _label_bank0_82b0
    SEC

_label_bank0_82b0:
    ROR $0C
    LDA $09
    SEC
    SBC #$05
    STA $09
    CLC
    LDA #$0B
    ADC $09
    EOR $09
    AND #$F0
    CLC
    BNE _label_bank0_82c6
    SEC

_label_bank0_82c6:
    ROR $0C
    LDA $09
    LSR A
    LSR A
    LSR A
    LSR A
    CMP #$0F
    STA $09
    LDA $08
    AND #$F0
    BCC _label_bank0_82da
    SBC #$10

_label_bank0_82da:
    ORA $09
    TAY
    LDA #$00
    STA $09
    LDA $0304,Y
    CLC
    BPL _label_bank0_82e8
    SEC

_label_bank0_82e8:
    ROR $09
    LDA $0C
    BMI _label_bank0_82ef
    INY

_label_bank0_82ef:
    LDA $0304,Y
    BPL _label_bank0_82f5
    SEC

_label_bank0_82f5:
    ROR $09
    LDA #$40
    AND $0C
    BNE _label_bank0_8301
    TYA
    ADC #$10
    TAY

_label_bank0_8301:
    LDA $0304,Y
    BPL _label_bank0_8307
    SEC

_label_bank0_8307:
    ROR $09
    LDA $0C
    BMI _label_bank0_830e
    DEY

_label_bank0_830e:
    LDA $0304,Y
    BPL _label_bank0_8314
    SEC

_label_bank0_8314:
    LDA $09
    ROR A
    LSR A
    LSR A
    LSR A
    LSR A
    STA $09
    RTS

    LDA #$11
    STA $08
    JSR $8326
    RTS

    LDA $28
    ROR A
    BCS _label_bank0_836d
    AND #$08
    BNE _label_bank0_836d
    LDA $0582
    TAX
    SEC
    SBC #$10
    CMP #$0C
    BCS _label_bank0_836d
    STX $2A
    CMP #$04
    TXA
    AND #$01
    BCS _label_bank0_8345
    ORA #$02

_label_bank0_8345:
    ORA #$1C
    STA $0582
    ROR A
    LDA #$04
    BCC _label_bank0_8351
    LDA #$FB

_label_bank0_8351:
    ADC $0589
    STA $0589
    LDA $0584
    STA $2B
    INC $28
    LDA $057F
    AND #$DE
    TAY
    INY
    STY $057F
    LDA $08
    JSR $836F

_label_bank0_836d:
    SEC
    RTS

    LDY #$03

_label_bank0_8371:
    LDX $041F,Y
    BEQ _label_bank0_8379
    DEY
    BNE _label_bank0_8371

_label_bank0_8379:
    STA $041F,Y
    RTS

.segment "PRG_POST_CONTROLLER_INPUT"

    LDA $057F
    CMP #$C0
    BCC _label_bank0_8403
    LDA $0582
    TAX
    LSR A
    LSR A
    CMP #$07
    BCS _label_bank0_8442
    TAY
    LDA $83F1,Y
    STA $08
    LDA $83F8,Y
    STA $09
    LDY $03E4
    TYA
    AND #$08
    BNE _label_bank0_83ec
    LDA #$FD
    AND $28
    STA $28

_label_bank0_83ec:
    LDA $20
    JMP ($0008)

    .byte $ff, $0a
    .byte $43, $42, $4d, $71, $ad
    .byte $83, $84, $84, $84, $84, $84, $84

    CMP #$05
    BCS _label_bank0_8404

_label_bank0_8403:
    RTS

_label_bank0_8404:
    TXA
    ORA #$0C
    JMP $84CA
    TXA
    LSR A
    LSR A
    LDA $20
    BCS _label_bank0_842b
    BNE _label_bank0_841a
    LDA #$12
    JSR $836F
    BPL _label_bank0_8442

_label_bank0_841a:
    CMP #$09
    BCC _label_bank0_8442
    LDA #$80
    STA $0584
    TXA
    AND #$03
    ORA #$1A
    JMP $84CA

_label_bank0_842b:
    CMP #$09
    LDY #$14
    STY $08
    BCS _label_bank0_843a
    LDA $03E4
    AND #$0F
    BEQ _label_bank0_8442

_label_bank0_843a:
    TXA
    AND #$03
    ORA $08
    JMP $84CA

_label_bank0_8442:
    RTS

    CMP #$07
    BCC _label_bank0_8442
    LDY #$1A
    STY $08
    BNE _label_bank0_843a
    TYA
    AND #$04
    BNE _label_bank0_845d
    TXA
    ROR A
    LDA #$0A
    ROL A
    TAX
    STX $0582
    BNE _label_bank0_8471

_label_bank0_845d:
    TYA
    AND #$03
    BNE _label_bank0_8468
    LDY #$12

_label_bank0_8464:
    STY $08
    BNE _label_bank0_843a

_label_bank0_8468:
    INY
    TYA
    AND #$01
    TAX
    LDY #$10
    BNE _label_bank0_8464

_label_bank0_8471:
    TYA
    AND #$0F
    TAY
    BNE _label_bank0_847c

_label_bank0_8477:
    TXA
    ORA #$02
    BNE _label_bank0_84ca

_label_bank0_847c:
    AND #$08
    BEQ _label_bank0_8494
    LDA #$02
    BIT $28
    BNE _label_bank0_8494
    ORA $28
    STA $28
    LDA #$00
    STA $20
    TXA
    AND #$01
    JMP $84CA

_label_bank0_8494:
    TYA
    CMP #$04
    BNE _label_bank0_84a0
    TXA
    AND #$03
    ORA #$10
    BNE _label_bank0_84ca

_label_bank0_84a0:
    TYA
    AND #$03
    BEQ _label_bank0_8477
    INY
    TYA
    AND #$01
    ORA #$14
    BNE _label_bank0_84ca
    TYA
    AND #$03
    BNE _label_bank0_84b7
    TXA
    ORA #$02
    BNE _label_bank0_84ca

_label_bank0_84b7:
    LDA $20
    CMP #$08
    BCC _label_bank0_84c4
    LDA #$00
    STA $20
    STA $0583

_label_bank0_84c4:
    INY
    TYA
    AND #$01
    ORA #$18

_label_bank0_84ca:
    STA $0582
    RTS

    LDX #$13
    LDY #$07

_label_bank0_84d2:
    LDA NonDanaObjectPointerLowTable,X
    STA $08
    LDA NonDanaObjectPointerHighTable,X
    STA $09
    LDA ($08),Y
    STA $40,X
    TXA
    ASL A
    STA $54,X
    DEX
    BPL _label_bank0_84d2
    LDA #$0A
    STA $08

_label_bank0_84eb:
    LDX #$00
    LDY $08

_label_bank0_84ef:
    LDA $0040,Y
    CMP $40,X
    BCS _label_bank0_851e
    STA $09
    LDA $40,X
    STA $0040,Y
    LDA $09
    STA $40,X
    LDA $0054,Y
    STA $09
    LDA $54,X
    STA $0054,Y
    LDA $09
    STA $54,X
    TXA
    SEC
    SBC $08
    BCS _label_bank0_8517
    LDA #$00

_label_bank0_8517:
    TAX
    CLC
    ADC $08
    TAY
    BCC _label_bank0_84ef

_label_bank0_851e:
    INY
    INX
    CPY #$14
    BNE _label_bank0_84ef
    DEC $08
    BNE _label_bank0_84eb
    LDX #$12
    LDY #$00
    LDA $53
    STA $08

_label_bank0_8530:
    SEC
    LDA $41,X
    SBC $40,X
    CMP #$10
    BCC _label_bank0_853c
    JSR $860D

_label_bank0_853c:
    ROR $55,X
    DEY
    DEX
    BPL _label_bank0_8530
    JSR $860D
    ROR $54
    LDX #$14
    STX $0C
    DEX
    BNE _label_bank0_8569

_label_bank0_854e:
    ROR A
    STA $54,X
    LDX $0A

_label_bank0_8553:
    LDA $54,X
    BMI _label_bank0_855a
    DEX
    BPL _label_bank0_8553

_label_bank0_855a:
    DEX
    BPL _label_bank0_8569
    LDA #$7F
    STA $08
    LDA #$05
    STA $09
    LDX #$00
    BEQ _label_bank0_85b5

_label_bank0_8569:
    STX $0A
    LDA $40,X
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    LDY $68,X
    TYA
    CLC
    ADC #$FD
    STA $68,X
    TYA
    CLC
    ADC $0A
    TAX
    STA $0B
    LDA #$40
    LDY $54,X
    BPL _label_bank0_8589
    LDA #$C0

_label_bank0_8589:
    STA $54,X
    TYA
    BMI _label_bank0_859b
    BPL _label_bank0_85a5

_label_bank0_8590:
    DEC $0B
    LDX $0B
    LDA $54,X
    CMP #$40
    TAY
    BCC _label_bank0_85a5

_label_bank0_859b:
    ASL A
    BMI _label_bank0_854e
    LSR A
    TAY
    LDX $0A
    INX
    STX $0B

_label_bank0_85a5:
    LDA NonDanaObjectPointerLowTable,Y
    STA $08
    LDA NonDanaObjectPointerHighTable,Y
    STA $09
    LDA $0C
    ASL A
    ASL A
    ASL A
    TAX

_label_bank0_85b5:
    LDY #$00
    LDA ($08),Y
    ASL A
    BCC _label_bank0_8600
    LDY #$07
    LDA ($08),Y
    STA $0210,X
    STA $0214,X
    LDY #$0A
    LDA ($08),Y
    STA $0213,X
    CLC
    ADC #$08
    STA $0217,X
    LDY #$11
    LDA ($08),Y
    STA $0211,X
    INY
    LDA ($08),Y
    STA $0215,X
    INY
    LDA ($08),Y
    STA $0F
    ROL A
    ROL A
    AND #$C1
    BCC _label_bank0_85ed
    ORA #$02

_label_bank0_85ed:
    STA $0212,X
    LDA $0F
    ROR A
    ROR A
    AND #$83
    BCC _label_bank0_85fa
    ORA #$40

_label_bank0_85fa:
    STA $0216,X
    JMP $8608

_label_bank0_8600:
    LDA #$F8
    STA $0210,X
    STA $0214,X
    DEC $0C
    BPL _label_bank0_8590
    RTS

    LDA $08
    LSR A
    LSR A
    LSR A
    LSR A
    STY $09
    DEY
    CPY #$FD
    TAY
    LDA $40,X
    STA $08
    LDA #$00
    BCS _label_bank0_8635
    LDA $0068,Y
    BEQ _label_bank0_8638
    CMP $09
    BCS _label_bank0_8638
    DEC $09

_label_bank0_862c:
    SEC
    SBC $09
    BEQ _label_bank0_8635
    CMP $09
    BCC _label_bank0_862c

_label_bank0_8635:
    STA $0068,Y

_label_bank0_8638:
    LDY #$01
    SEC
    RTS

.segment "PRG_PRE_TIMER"
    LDX $043E
    CPX #$40
    BCC _label_bank0_a0a6
    LDA $043C
    AND #$3F
    CMP #$18
    BCC _label_bank0_a0a6
    TXA
    AND #$3F
    STA $043E
    STX $02
    ASL $02
    BCC _label_bank0_a085
    LDA $0446
    STA $06

_label_bank0_a06d:
    LDY $043F
    LDA ($3A),Y
    INC $043F
    CMP #$90
    BCC _label_bank0_a080
    SBC #$90
    STA $043F
    BCS _label_bank0_a06d

_label_bank0_a080:
    STA $07
    JSR ConfigureEnemyType

_label_bank0_a085:
    ASL $02
    BCC _label_bank0_a0a6
    LDA $0445
    STA $06

_label_bank0_a08e:
    LDY $0440
    INC $0440
    LDA ($3C),Y
    CMP #$90
    BCC _label_bank0_a0a1
    SBC #$90
    STA $0440
    BCS _label_bank0_a08e

_label_bank0_a0a1:
    STA $07
    JSR ConfigureEnemyType

_label_bank0_a0a6:
    RTS

    LDA $043D
    ASL A
    ASL A
    AND #$3C
    STA $00
    LDA $043C
    ROL A
    ROL A
    ROL A
    AND #$03
    ORA $00
    TAX
    LDA $043E
    STA $01
    AND #$1F
    STA $00
    LDA #$C0
    AND $01
    BNE _label_bank0_a10f
    TXA
    AND #$1F
    CMP $00
    BEQ _label_bank0_a10f
    STX $00
    LDA #$20
    AND $01
    ORA $00
    STA $043E
    TAY
    AND #$07
    STA $00
    TAX
    TYA
    LSR A
    LSR A
    LSR A
    TAY
    LDA ($36),Y

_label_bank0_a0e9:
    ASL A
    DEX
    BPL _label_bank0_a0e9
    JSR $A108
    ROL $01
    LDX $00
    LDA ($38),Y

_label_bank0_a0f6:
    ASL A
    DEX
    BPL _label_bank0_a0f6
    JSR $A108
    LDA $01
    ROR A
    ROR A
    AND #$C0
    BEQ _label_bank0_a10f
    JMP $A110
    BCC _label_bank0_a10f
    LDA #$0E
    CMP $0447

_label_bank0_a10f:
    RTS

    STA $02
    LDX #$01
    STX $03

_label_bank0_a116:
    ROL $02
    BCC _label_bank0_a131
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_a131
    TXA
    LDX $03
    STA $0445,X
    STA $06
    LDA #$80
    LDY #$00
    STA ($04),Y
    JSR $A144
    SEC

_label_bank0_a131:
    DEC $03
    BPL _label_bank0_a116
    ROR $02
    ROR $02
    LDA $043E
    AND #$3F
    ORA $02
    STA $043E
    RTS

    LDA $0441,X
    STA $04
    LDA $0443,X
    STA $05
    JSR InitializeEnemy
    LDA #$04
    STA $05
    LDA #$C6
    STA $04
    LDA #$0C
    JSR InitializeObjectStateHeader
    RTS

.segment "PRG_PRE_TIMER_DISPLAY"
    .byte $20, $69, $44, $02, $04, $10, $23, $c2, $41, $f0, $30, $00, $23
    .byte $c2, $41, $a0, $20, $00

.segment "PRG_PRE_FIREBALL_LIFETIME"
    LDA #$FF
    LDX #$1B
    JSR WaitForMaskedBitsClear
    LDA #$E6
    STA $00
    LDA #$03
    STA $01
    LDY #$00
    LDA $042E
    STA $04
    LDA $042F
    STA $05
    LDX #$02

_label_bank0_a329:
    LDA $A39E,X
    STA ($00),Y
    INY
    DEX
    BPL _label_bank0_a329
    LDA $042B
    STA $02
    LDA #$0A
    STA $03
    LDA #$A5

_label_bank0_a33d:
    STA ($00),Y
    INY
    ASL $04
    ROL $05
    ROL A
    ASL $04
    ROL $05
    ROL A
    AND #$03
    BEQ _label_bank0_a358
    DEC $02
    DEC $03
    TAX
    LDA $A39B,X
    BNE _label_bank0_a33d

_label_bank0_a358:
    LDA #$B4

_label_bank0_a35a:
    STA ($00),Y
    INY
    DEC $03
    DEC $02
    BPL _label_bank0_a35a
    LDA #$24

_label_bank0_a365:
    STA ($00),Y
    INY
    DEC $03
    BNE _label_bank0_a365
    LDX #$02

_label_bank0_a36e:
    LDA $A3A1,X
    STA ($00),Y
    INY
    DEX
    BPL _label_bank0_a36e
    INX

_label_bank0_a378:
    LDA $03E9,X
    BPL _label_bank0_a386
    INX
    CLC
    ADC #$02
    STA ($00),Y
    INY
    BNE _label_bank0_a378

_label_bank0_a386:
    DEY
    LDA #$B7

_label_bank0_a389:
    STA ($00),Y
    INY
    LDA $03E9,X
    INX
    CMP #$20
    BNE _label_bank0_a389
    LDA #$00
    STA ($00),Y
    JMP PublishPpuUpdateBuffer

    .byte $b4, $b0, $b1, $4a, $54, $20, $4a, $74
    .byte $20

.segment "PRG_PRE_ENEMY_POINTERS"
    LDY #$03
    LDA ($2E),Y
    BNE _label_bank0_a4d4
    LDY #$01
    LDA ($2C),Y
    CMP #$2A
    BCC _label_bank0_a4ee
    LDY #$06
    LDA ($2C),Y
    BEQ _label_bank0_a4eb
    LDY #$03
    STA ($2E),Y
    LDA #$00
    STA ($2C),Y
    DEY
    STA ($2C),Y
    BPL _label_bank0_a4ee

_label_bank0_a4d4:
    LDA $87
    LSR A
    BCS _label_bank0_a4e3
    JSR $AA57
    BCS _label_bank0_a4e3
    JSR $A77D
    BCC _label_bank0_a55d

_label_bank0_a4e3:
    LDY #$03
    LDA ($2C),Y
    CMP #$04
    BCC _label_bank0_a4ee

_label_bank0_a4eb:
    JMP DeactivateCurrentEnemy

_label_bank0_a4ee:
    JSR $AD79
    LDA $07
    TAX
    AND #$0C
    BNE _label_bank0_a500
    LDY #$00
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y

_label_bank0_a500:
    TXA
    AND #$0F
    BEQ _label_bank0_a509
    CMP #$0F
    BNE _label_bank0_a512

_label_bank0_a509:
    LDY #$05
    LDA #$80
    ORA ($2E),Y
    STA ($2E),Y
    RTS

_label_bank0_a512:
    TXA
    AND #$03
    CMP #$03
    BEQ _label_bank0_a509
    TXA
    AND #$0C
    BEQ _label_bank0_a54a
    TXA
    AND #$03
    BNE _label_bank0_a54a
    LDY #$00
    LDA ($2C),Y
    LSR A
    BCC _label_bank0_a54a
    TXA
    AND #$03
    BEQ _label_bank0_a536
    TXA
    AND #$0C
    CMP #$0C
    BNE _label_bank0_a54a

_label_bank0_a536:
    LDY #$07
    LDA ($2E),Y
    AND #$0F
    CMP #$08
    BCS _label_bank0_a509
    INY
    LDA #$00
    STA ($2E),Y
    LDY #$05
    STA ($2E),Y
    RTS

_label_bank0_a54a:
    TXA
    LDY #$08
    AND #$06
    CMP #$06
    BNE _label_bank0_a557
    LDA #$74
    BPL _label_bank0_a559

_label_bank0_a557:
    LDA #$0C

_label_bank0_a559:
    STA ($2E),Y
    RTS

    RTS

_label_bank0_a55d:
    JSR LoadCurrentEnemyPosition
    JSR SpawnAuxiliaryEffectAtCoordinates
    LDY #$0D
    JSR AddSoundEffect
    LDY #$03
    LDA ($2E),Y
    CMP #$08
    BCS _label_bank0_a58c
    SBC #$01
    CMP #$04
    BCC _label_bank0_a581
    JSR $C4A1
    LDA #$43
    JSR StartThread
    JMP DeactivateCurrentEnemy

_label_bank0_a581:
    JSR $A5A3

_label_bank0_a584:
    LDA #$42
    JSR StartThread
    JMP DeactivateCurrentEnemy

_label_bank0_a58c:
    SBC #$08
    LDX #$06

_label_bank0_a590:
    DEX
    SBC #$03
    BCS _label_bank0_a590
    ADC #$03
    TAY
    LDA $A5A0,Y
    JSR AddScoreByAAtDigitX
    BMI _label_bank0_a584

    .byte $01, $02, $05
    .byte $20, $a9, $8e, $ae, $a5, $98, $c6, $c0, $c6, $aa, $c6

    LDA $042B
    STA $03
    LDX #$01
    LDA #$40
    STA $01

_label_bank0_a5b9:
    LDY #$04

_label_bank0_a5bb:
    LDA $01
    AND $042E,X
    CMP $01
    BEQ _label_bank0_a5d3
    DEC $03
    BEQ _label_bank0_a5d2
    LSR $01
    LSR $01
    DEY
    BNE _label_bank0_a5bb
    DEX
    BPL _label_bank0_a5b9

_label_bank0_a5d2:
    RTS

_label_bank0_a5d3:
    ASL A
    ORA $01
    EOR $042E,X
    STA $042E,X
    RTS

    LDY #$03
    LDA ($2C),Y
    CMP #$07
    BCC _label_bank0_a5e8
    JMP DeactivateCurrentEnemy

_label_bank0_a5e8:
    JSR $AA57
    BCS _label_bank0_a5f2
    JSR $A77D
    BCC _label_bank0_a662

_label_bank0_a5f2:
    JSR $AD79
    LDA $07
    TAX
    BEQ _label_bank0_a5fe
    CMP #$0F
    BNE _label_bank0_a62d

_label_bank0_a5fe:
    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_a612
    JSR $C1E3
    LSR A
    LDA #$0C
    BCS _label_bank0_a60e
    LDA #$74

_label_bank0_a60e:
    LDY #$08
    STA ($2E),Y

_label_bank0_a612:
    LDY #$05
    LDA ($2E),Y
    BNE _label_bank0_a620
    TAX
    LDA #$80
    ORA ($2E),Y
    STA ($2E),Y
    TXA

_label_bank0_a620:
    LDX #$00
    ASL A
    BMI _label_bank0_a627
    LDX #$02

_label_bank0_a627:
    LDY #$03
    TXA
    STA ($2E),Y
    RTS

_label_bank0_a62d:
    LDY #$05
    AND #$0C
    BNE _label_bank0_a63f
    LDA ($2E),Y
    AND #$40
    BEQ _label_bank0_a643
    LDA #$80
    STA ($2E),Y
    BMI _label_bank0_a641

_label_bank0_a63f:
    LDA #$C0

_label_bank0_a641:
    STA ($2E),Y

_label_bank0_a643:
    LDY #$08
    TXA
    AND #$09
    CMP #$09
    BNE _label_bank0_a650
    LDA #$0C
    BPL _label_bank0_a659

_label_bank0_a650:
    TXA
    AND #$06
    CMP #$06
    BNE _label_bank0_a661
    LDA #$7A

_label_bank0_a659:
    STA ($2E),Y
    LDA #$00
    LDY #$05
    STA ($2E),Y

_label_bank0_a661:
    RTS

_label_bank0_a662:
    LDX #$10

_label_bank0_a664:
    TXA
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA ($00),Y
    BPL _label_bank0_a682
    LDY #$03

_label_bank0_a670:
    LDA $A688,Y
    STA ($00),Y
    DEY
    BPL _label_bank0_a670
    TXA
    JSR LoadEnemyAiPointer
    LDY #$00
    TYA
    INY
    STA ($00),Y

_label_bank0_a682:
    DEX
    BPL _label_bank0_a664
    JMP DeactivateCurrentEnemy

    .byte $e2, $1c, $ff, $00

    JSR $B341
    JSR JumpWithParams
    LDA $A6,X
    STX $A6,Y
    LDY #$01
    LDA ($2C),Y
    CMP #$10
    BCC _label_bank0_a6b4
    LDY #$03
    LDA ($2E),Y
    AND #$03
    TAX
    JSR $AFB6
    LDY #$03
    TYA
    AND ($2E),Y
    STA ($2E),Y
    DEY
    LDA #$00
    STA ($2C),Y

_label_bank0_a6b4:
    RTS

    LDY #$02
    LDA ($2C),Y
    CMP #$C0
    BCC _label_bank0_a6df
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_a6df
    TXA
    LDY #$06
    STA ($2C),Y
    LDY #$00
    LDA #$80
    STA ($04),Y
    LDY #$03
    LDA #$03
    AND ($2E),Y
    ORA #$04
    STA ($2E),Y
    DEY
    LDA #$00
    STA ($2C),Y
    DEY
    STA ($2C),Y

_label_bank0_a6df:
    RTS

    .byte $20, $41, $b3
    .byte $20, $a9, $8e, $f9, $a6, $0e, $a7, $5c, $a5, $5c, $a5, $30, $a7, $42, $a7, $f4
    .byte $a6

    LDX #$16
    JMP $A75E
    LDY #$01
    LDA ($2C),Y
    CMP #$30
    BCS _label_bank0_a70b
    CMP #$20
    BCS _label_bank0_a70a
    LDX #$0A
    JSR $A75E

_label_bank0_a70a:
    RTS

_label_bank0_a70b:
    JMP DeactivateCurrentEnemy
    LDY #$01
    LDA ($2E),Y
    LSR A
    BCS _label_bank0_a729
    DEY
    LDA ($2C),Y
    TAX
    AND #$08
    BEQ _label_bank0_a724
    INY
    LDA #$00
    STA ($2C),Y
    BEQ _label_bank0_a72b

_label_bank0_a724:
    TXA
    ORA #$08
    STA ($2C),Y

_label_bank0_a729:
    LDA #$14

_label_bank0_a72b:
    LDY #$03
    STA ($2E),Y
    RTS

    LDX #$06
    JSR $A75E
    LDY #$01
    LDA ($2C),Y
    CMP #$D2
    BCS _label_bank0_a73e
    RTS

_label_bank0_a73e:
    LDA #$14
    BPL _label_bank0_a72b
    LDX #$10
    JSR $A75E
    LDY #$00
    LDA ($2E),Y
    TAX
    AND #$08
    BNE _label_bank0_a751
    RTS

_label_bank0_a751:
    TXA
    AND #$F7
    STA ($2E),Y
    TYA
    INY
    STA ($2C),Y
    LDA #$10
    BPL _label_bank0_a72b
    LDA $0582
    CMP #$1C
    BCS _label_bank0_a77c
    STX $00
    LDY #$04
    LDA ($2C),Y
    ASL A
    BCC _label_bank0_a77c
    CMP $00
    BCS _label_bank0_a77c
    JSR $A77D
    BCS _label_bank0_a77c
    LDA #$31
    JSR StartThread

_label_bank0_a77c:
    RTS

    LDA $0589
    LDY #$0A
    SEC
    SBC ($2E),Y
    ADC #$04
    CMP #$0A
    RTS

    .byte $20, $41, $b3, $20, $a9, $8e, $5c, $a5, $08
    .byte $b0, $9e, $a7, $b5, $b1, $5c, $a5, $a9, $a7, $8f, $b1, $a0, $03, $b1, $2e, $4a
    .byte $a9

    ASL A
    ROL A
    STA ($2E),Y
    RTS

    JSR $B329
    BCS _label_bank0_a7b3
    JSR $B2A7
    BNE _label_bank0_a7fe

_label_bank0_a7b3:
    JSR $B0CE
    BNE _label_bank0_a7dd
    LDA #$02
    LDY #$03
    LDA ($2E),Y
    ROR A
    ROR A
    BCS _label_bank0_a7ce
    SEC
    ROL A
    ROL A
    STA ($2E),Y
    LDA #$00
    LDY #$01
    STA ($2C),Y

_label_bank0_a7cd:
    RTS

_label_bank0_a7ce:
    LDY #$01
    LDA ($2C),Y
    CMP #$14
    BCC _label_bank0_a7cd
    LDY #$08
    TYA
    STA ($2E),Y
    BPL _label_bank0_a7f3

_label_bank0_a7dd:
    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_a7fd
    JSR $B410
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA $0304,X
    BPL _label_bank0_a7fd
    CMP #$F8
    BCC _label_bank0_a7fe

_label_bank0_a7f3:
    LDY #$03
    LDA #$01
    EOR ($2E),Y
    AND #$FD
    STA ($2E),Y

_label_bank0_a7fd:
    RTS

_label_bank0_a7fe:
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_a83f
    LDY #$06
    TXA
    STA ($2C),Y
    LDY #$00
    LDA #$80
    STA ($04),Y
    LDA $04
    STA $00
    LDA $05
    STA $01
    JSR FindFreeEnemySlotIndex
    LDY #$00
    BCS _label_bank0_a822
    TYA
    STA ($00),Y
    BCC _label_bank0_a83f

_label_bank0_a822:
    LDA #$80
    STA ($04),Y
    LDA ($2C),Y
    ORA #$03
    STA ($2C),Y
    TYA
    INY
    STA ($2C),Y
    LDY #$03
    LDA ($2E),Y
    AND #$01
    ORA #$0C
    STA ($2E),Y
    LDY #$07
    TXA
    STA ($2C),Y

_label_bank0_a83f:
    RTS

    LDA $87
    LSR A
    BCS _label_bank0_a869
    JSR $AA57
    BCS _label_bank0_a869
    JSR $A77D
    BCS _label_bank0_a869
    LDY #$03
    LDA ($2E),Y
    CMP #$0C
    BEQ _label_bank0_a869
    LDA #$DF
    LDY #$00
    AND ($2E),Y
    STA ($2E),Y
    TYA
    INY
    STA ($2C),Y
    LDY #$03
    LDA #$0C
    STA ($2E),Y

_label_bank0_a869:
    JSR $B341
    JSR JumpWithParams

    .byte $98, $a9, $a9, $a9
    .byte $fb, $a9, $7d, $a8, $5c, $a5, $5c, $a5, $e4, $a8

    LDY #$01
    LDA ($2C),Y
    BNE _label_bank0_a8ba
    TYA
    STA ($2C),Y
    DEY
    LDA #$04
    ORA ($2E),Y
    STA ($2E),Y
    LDY #$0F
    JSR AddSoundEffect
    LDX $0453
    INX
    LDA #$42
    CPX #$0A
    BCC _label_bank0_a8ab
    INC $86
    JSR LoadCurrentEnemyPosition
    JSR SpawnAuxiliaryEffectAtCoordinates
    JSR $C4A1
    LDX #$00
    LDA #$43

_label_bank0_a8ab:
    STX $0453
    JSR StartThread
    LDY #$01
    LDA ($2E),Y
    CMP #$1C
    BNE _label_bank0_a8c1

_label_bank0_a8b9:
    RTS

_label_bank0_a8ba:
    CMP #$12
    BCC _label_bank0_a8b9
    JMP DeactivateCurrentEnemy

_label_bank0_a8c1:
    DEY
    STY $31
    LDA #$04
    ORA $7C
    STA $7C
    LDY #$07
    LDA ($2E),Y
    STA $04
    LDY #$0A
    LDA ($2E),Y
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    STX $2F
    LDA #$2A
    STA $30
    LDA #$32
    JSR StartThread
    LDY #$08
    LDA ($2E),Y
    ASL A
    ASL A
    LDA #$18
    BCC _label_bank0_a8f0
    ADC #$00

_label_bank0_a8f0:
    LDY #$03
    STA ($2E),Y
    LDY #$01
    LDA ($2C),Y
    BNE _label_bank0_a8fb
    RTS

_label_bank0_a8fb:
    LDA #$00
    STA ($2C),Y
    LDA ($2E),Y
    SEC
    SBC #$1C
    ASL A
    STA $00
    LDY #$06
    LDA ($2C),Y
    STA $01
    DEY
    LDA ($2E),Y
    ASL A
    STA $02
    LDX $00
    LDA $01
    BPL _label_bank0_a91a
    INX

_label_bank0_a91a:
    LDA $02
    CLC
    ADC $A988,X
    LDX $00
    STA $02
    LDY #$04
    EOR ($2C),Y
    BPL _label_bank0_a92b
    INX

_label_bank0_a92b:
    LDA $02
    BPL _label_bank0_a931
    EOR #$FF

_label_bank0_a931:
    CMP $A98C,X
    BCC _label_bank0_a93d
    ASL $01
    LDA $02
    ASL A
    ROR $01

_label_bank0_a93d:
    LDY #$05
    LDA $02
    LSR A
    STA ($2E),Y
    LDY #$08
    LDA ($2E),Y
    ASL A
    STA $02
    LDA $01
    LDX $00
    ASL A
    BPL _label_bank0_a953
    INX

_label_bank0_a953:
    CLC
    LDA $02
    ADC $A990,X
    STA $02
    LDX $00
    LDY #$05
    EOR ($2C),Y
    BPL _label_bank0_a964
    INX

_label_bank0_a964:
    LDA $02
    BPL _label_bank0_a96a
    EOR #$FF

_label_bank0_a96a:
    CMP $A994,X
    BCC _label_bank0_a97a
    LDA #$80
    EOR $02
    ASL $01
    AND #$80
    ROR A
    STA $01

_label_bank0_a97a:
    LDY #$08
    LDA $02
    LSR A
    STA ($2E),Y
    LDY #$06
    LDA $01
    STA ($2C),Y
    RTS

    .byte $fc, $04, $fa, $06, $40, $20, $60, $30, $04, $fc, $06
    .byte $fa, $40, $20, $60, $30

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

    JSR $B4C4
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

.segment "PRG_PRE_ENEMY_POINTER_TABLES"

    LDY #$08
    TYA
    STA ($2E),Y
    LDX #$14
    LDY #$05
    LDA ($2C),Y
    BPL _label_bank0_b2b0
    INX

_label_bank0_b2b0:
    LDY #$03
    TXA
    STA ($2E),Y
    RTS

    JSR $B329
    BCS _label_bank0_b2c8
    LDY #$01
    LDA ($2C),Y
    CMP #$20
    BCC _label_bank0_b2c8
    JSR $B2A7
    BNE _label_bank0_b2e7

_label_bank0_b2c8:
    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_b328
    JSR $B410
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA $0304,X
    BPL _label_bank0_b2e6
    CMP #$F8
    BCC _label_bank0_b2e7
    LDY #$03
    LDA #$01
    EOR ($2E),Y
    STA ($2E),Y

_label_bank0_b2e6:
    RTS

_label_bank0_b2e7:
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_b328
    LDY #$06
    TXA
    STA ($2C),Y
    LDY #$00
    LDA #$80
    STA ($04),Y
    LDA $04
    STA $00
    LDA $05
    STA $01
    JSR FindFreeEnemySlotIndex
    LDY #$00
    BCS _label_bank0_b30b
    TYA
    STA ($00),Y
    BCC _label_bank0_b328

_label_bank0_b30b:
    LDA #$80
    STA ($04),Y
    LDA ($2C),Y
    ORA #$03
    STA ($2C),Y
    TYA
    INY
    STA ($2C),Y
    LDY #$03
    LDA ($2E),Y
    AND #$01
    ORA #$0C
    STA ($2E),Y
    LDY #$07
    TXA
    STA ($2C),Y

_label_bank0_b328:
    RTS

    LDY #$05
    LDA ($2C),Y
    ASL A
    BCS _label_bank0_b332
    EOR #$FF

_label_bank0_b332:
    CMP #$14
    BCS _label_bank0_b340
    DEY
    LDA ($2C),Y
    ASL A
    BCS _label_bank0_b33e
    EOR #$FF

_label_bank0_b33e:
    CMP #$10

_label_bank0_b340:
    RTS

    LDY #$03
    LDA ($2E),Y
    LSR A
    LSR A
    RTS

    JSR $B4C4
    JSR $B341
    JSR JumpWithParams

    .byte $5f, $b3
    .byte $6b, $b3, $70, $af, $5c, $a5, $5c, $a5, $7c, $b3, $5c, $a5

    LDY #$01
    LDA ($2C),Y
    CMP #$11
    BCS _label_bank0_b368
    RTS

_label_bank0_b368:
    JMP DeactivateCurrentEnemy
    LDY #$08
    LDA #$01
    STA ($2E),Y
    LDY #$03
    LDA #$01
    AND ($2E),Y
    ORA #$14
    STA ($2E),Y

_label_bank0_b37b:
    RTS

    LDY #$08
    LDA ($2E),Y
    BNE _label_bank0_b37b
    LDY #$00
    LDA ($2C),Y
    ROR A
    BCS _label_bank0_b3e2
    JSR $B410
    JSR ConvertPixelCoordinatesToMapIndex
    TAX
    LDA $0304,X
    BMI _label_bank0_b39c
    LDY #$04
    LDA #$FF
    STA ($2E),Y

_label_bank0_b39b:
    RTS

_label_bank0_b39c:
    STX $00
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_b37b
    LDY #$06
    TXA
    STA ($2C),Y
    LDY #$00
    LDA #$80
    STA ($04),Y
    LDA #$01
    ORA ($2C),Y
    STA ($2C),Y
    TYA
    INY
    STA ($2C),Y
    LDA $00
    STA $04
    LDA EnemyObjectPointerLowTable,X
    STA $00
    LDA EnemyObjectPointerHighTable,X
    STA $01
    LDY #$00
    LDA #$DF
    AND ($2E),Y
    STA ($2E),Y
    LDY #$03
    LDA ($2E),Y
    AND #$01
    STA $02
    ORA #$16
    STA ($2E),Y
    LDY $04
    LDA $0304,Y
    JSR ApplyMapTileInteractionToObject

_label_bank0_b3e2:
    LDY #$01
    LDA ($2C),Y
    CMP #$0F
    BCC _label_bank0_b39b
    LDY #$08
    LDA #$03
    STA ($2E),Y
    LDY #$03
    LDA #$01
    EOR ($2E),Y
    AND #$FD
    STA ($2E),Y
    LDY #$00
    LDA #$20
    ORA ($2E),Y
    STA ($2E),Y
    LDY #$00
    LDA #$FE
    AND ($2C),Y
    STA ($2C),Y
    LDX #$01
    JSR $B19E
    RTS

    LDY #$03
    LDA ($2E),Y
    ROR A
    LDA #$18
    BCC _label_bank0_b41b
    LDA #$F7

_label_bank0_b41b:
    LDY #$0A
    ADC ($2E),Y
    STA $05
    LDY #$07
    LDA #$08
    ADC ($2E),Y
    STA $04
    RTS

.segment "PRG_BANK_0"

    LDY #$00
    LDA ($2C),Y
    AND #$03
    BNE _label_bank0_b4f0
    LDY #$02
    LDA ($2C),Y
    SBC $0426
    INY
    LDA ($2C),Y
    SBC $0427
    BCC _label_bank0_b4f0
    LDY #$03
    LDA ($2E),Y
    BEQ _label_bank0_b4f0
    LDA #$00
    STA ($2E),Y
    LDY #$01
    STA ($2C),Y
    TAY
    LDA #$02
    ORA ($2E),Y
    STA ($2E),Y

_label_bank0_b4f0:
    RTS

    .byte $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

    JSR $B808
    LDA #$06
    JSR StopThread
    LDX $0428
    TXA
    LSR A
    LSR A
    LSR A
    ASL A
    TAY
    LDA $B832,X
    CLC
    ADC $B824,Y
    STA $00
    LDA #$00
    ADC $B825,Y
    STA $01
; jump engine
    JMP ($0000)

    .byte $67, $b8, $6b, $b8, $79, $b8, $59, $b9, $73, $b9, $a1, $b9, $af, $b9, $00
    .byte $00, $00, $01, $01, $00, $01, $00, $00, $06, $05, $05, $09, $05, $05, $05, $01
    .byte $2c, $2f, $37, $4e, $00, $00, $2c, $00, $00, $00, $00, $01, $06, $00, $00, $00
    .byte $00, $00, $00, $00, $27, $01, $00, $00, $00, $00, $00, $00, $01, $09, $00, $01

    STA $00
    EOR #$4D
    RTS

    JMP $B924
    LDA #$01
    JMP $BFAA
    RTS

    JMP $B924
    LDA #$02
    JMP $BFAA

_label_bank0_b879:
    RTS

    LDA #$04
    JSR $BFAA
    LDA #$00
    STA $88
    LDA $7C
    AND #$10
    BNE _label_bank0_b879

_label_bank0_b889:
    JSR SwitchThreads
    LDA $7F
    CMP #$7E
    BNE _label_bank0_b889
    LDA #$00
    STA $7F
    INC $88
    LDA $88
    CMP #$0B
    BCC _label_bank0_b889
    LDA #$6E
    STA $88
    JMP $B930
    JMP $B924
    LDA #$08
    JSR $BFAA
    JMP $B924
    JSR $BFCE
    LDA #$E2
    STA $00
    LDA #$BF
    STA $01
    LDA #$04
    JSR ExpandRoomMapBitplane
    LDA #$20
    STA $88
    JMP $B8CC
    LDA #$10
    JMP $BFAA
    LDA $7C
    AND #$10
    BNE _label_bank0_b91a

_label_bank0_b8d2:
    JSR $B91B
    BPL _label_bank0_b8d2

_label_bank0_b8d7:
    JSR $B91B
    BMI _label_bank0_b8d7

_label_bank0_b8dc:
    JSR SwitchThreads
    LDA $057F
    LSR A
    BCS _label_bank0_b8dc
    LDA $88
    STA $02
    LDA #$38
    STA $03
    JSR BuildAndPublishRoomMapCellUpdate

_label_bank0_b8f0:
    JSR $B91B
    BPL _label_bank0_b8f0

_label_bank0_b8f5:
    JSR $B91B
    BMI _label_bank0_b8f5
    LDA $7F
    CMP $88
    BNE _label_bank0_b91a

_label_bank0_b900:
    JSR SwitchThreads
    LDA $0582
    CMP #$14
    BNE _label_bank0_b900
    LDX $88
    LDA #$32
    STA $0304,X
    LDA #$39
    STA $03
    STX $02
    JSR BuildAndPublishRoomMapCellUpdate

_label_bank0_b91a:
    RTS

    JSR SwitchThreads
    LDX $88
    LDA $0304,X
    RTS

    JSR $BDEA
    LDA $04F7
    ORA #$40
    STA $04F7
    RTS

_label_bank0_b930:
    JSR SwitchThreads
    JSR FindFreeEnemySlotIndex
    BCC _label_bank0_b930
    LDA #$80
    STA ($04),Y
    LDA #$00
    LDY #$02
    STA ($04),Y
    INY
    STA ($04),Y
    STX $06
    LDA $88
    STA $04
    JSR ConvertMapIndexToPixelCoordinates
    LDA #$18
    STA $07
    JSR InitializeEnemy
    JSR ConfigureEnemyType
    RTS

    RTS

    LDA #$20
    JMP $BFAA
    JSR $BFCE
    LDA #$FA
    STA $00
    LDA #$BF
    STA $01
    LDA #$27
    JSR ExpandRoomMapBitplane
    JMP $B924
    RTS

_label_bank0_b973:
    RTS

    LDA #$00
    STA $88
    LDA $7C
    AND #$10
    BNE _label_bank0_b973

_label_bank0_b97e:
    JSR SwitchThreads
    LDA $7F
    CMP #$56
    BNE _label_bank0_b97e
    LDA #$00
    STA $7F
    INC $88
    LDA $88
    CMP #$0B
    BCC _label_bank0_b97e
    LDA #$36
    STA $88
    JMP $B930
    LDA #$9E
    STA $88
    JMP $B8CC
    RTS

    LDA #$40
    JSR $BFAA
    JMP $B924
    LDA #$80
    JMP $BFAA
    RTS

    JSR $BDEA
    LDA #$F8
    STA $0304
    LDA #$90
    LDX #$0B

_label_bank0_b9bc:
    LDY $BFD6,X
    STA $0304,Y
    DEX
    BPL _label_bank0_b9bc

_label_bank0_b9c5:
    JSR SwitchThreads
    LDA $7E
    CMP #$AD
    BNE _label_bank0_b9c5
    LDA $05CF
    BPL _label_bank0_b9f7
    LDA $05D6
    STA $04
    LDA $05D9
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    CPX #$AD
    BNE _label_bank0_b9f7
    LDA #$90
    STA $0386

_label_bank0_b9e9:
    JSR SwitchThreads
    LDA $7E
    CMP #$57
    BNE _label_bank0_b9e9
    LDA #$90
    STA $0369

_label_bank0_b9f7:
    RTS

    LDX #$37
    BNE _label_bank0_b9fe
    LDX #$A7

_label_bank0_b9fe:
    LDA #$21
    STA $0304,X
    JSR $BDEA
    LDA #$90
    STA $039B

_label_bank0_ba0b:
    JSR SwitchThreads
    LDA $0586
    STA $04
    LDA $0589
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    LDA #$90
    CPX #$57
    BEQ _label_bank0_ba2b
    LDX $7E
    CPX #$A1
    BNE _label_bank0_ba0b
    STA $03CB
    RTS

_label_bank0_ba2b:
    LDX #$02

_label_bank0_ba2d:
    STA $034A,X
    DEX
    BPL _label_bank0_ba2d
    RTS

    LDA #$00
    STA $042E
    STA $042F
    JSR $BDEA
    LDA #$02
    STA $036B
    LDA #$90
    STA $032B
    STA $0347
    STA $0390

_label_bank0_ba4f:
    JSR SwitchThreads
    LDA $7E
    CMP #$6C
    BNE _label_bank0_ba4f
    LDA #$90
    STA $036D

_label_bank0_ba5d:
    JSR SwitchThreads
    LDA $7E
    CMP #$67
    BNE _label_bank0_ba5d
    LDA #$82
    STA $02
    JSR SetActiveNonDanaObjectState
    LDX #$06
    JSR ResetOtherSecondaryThreads
    LSR $78
    ASL $78
    LDA #$08
    ORA $7C
    STA $7C
    LDA #$67
    LDX #$37
    JSR $BE1D
    LDA #$66
    LDX #$36
    JSR $BE1D
    LDA #$00
    STA $0593
    LDA #$10
    JSR $BE13
    LDA #$10
    STA $07

_label_bank0_ba98:
    LDA $07
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA #$40
    ORA ($00),Y
    STA ($00),Y
    INY
    LDA #$1C
    STA ($00),Y
    TYA
    LDY #$03
    STA ($00),Y
    LDY #$07
    LDA ($00),Y
    STA $02
    LDY #$0A
    LDA ($00),Y
    STA $03
    LDA #$67
    STA $04
    JSR ConvertMapIndexToPixelCoordinates
    JSR $C364
    LDA $07
    JSR LoadEnemyAiPointer
    LDX #$03
    LDY #$07

_label_bank0_bace:
    LDA $02,X
    STA ($00),Y
    DEY
    DEX
    BPL _label_bank0_bace
    DEC $07
    BPL _label_bank0_ba98
    LDA #$03
    JSR $BE13
    LDA #$80
    STA $057F
    LDY #$14
    JSR AddSoundEffect

_label_bank0_bae9:
    LDA #$10
    STA $07

_label_bank0_baed:
    LDA $07
    JSR LoadEnemyAiPointer
    TXA
    LDX #$00
    JSR $BE08
    JSR LoadEnemyObjectPointer
    LDX #$02
    JSR $BE08
    JSR $C342
    DEC $07
    BPL _label_bank0_baed

_label_bank0_bb07:
    LDA $26
    CMP $2B
    BEQ _label_bank0_bb07
    STA $2B
    CMP #$43
    BCC _label_bank0_bae9
    LDY #$18
    JSR AddSoundEffect
    LDA #$67
    LDX #$35
    JSR $BE1D
    LDA #$66
    LDX #$10
    JSR $BE1D
    JSR $C60E
    LDA #$40
    JSR $BE13
    JSR Clear32x26NametableRegion
    LDA #$03
    STA $7D

_label_bank0_bb35:
    LDA $1B
    BNE _label_bank0_bb35
    JSR $CCCD
    JSR $BD97
    LDA #$4F
    STA $03E8
    LDA #$0F
    STA $03F6
    LDA #$00
    STA $03F9
    JSR PublishPpuUpdateBuffer
    LDA #$EF
    STA $1F
    LDA #$D0
    STA $059A
    LDA #$78
    STA $059D
    LDX #$03

_label_bank0_bb61:
    LDA $BE39,X
    STA $0593,X
    DEX
    BPL _label_bank0_bb61
    LDA #$80
    JSR $BE13
    LDA #$00
    STA $0593
    LDA #$04
    AND $7C
    BEQ _label_bank0_bbb7
    LDY #$13
    JSR AddSoundEffect
    LDX #$09
    STX $30

_label_bank0_bb83:
    LDX #$0C

_label_bank0_bb85:
    LDA $BE3D,X
    STA $04F7,X
    DEX
    BPL _label_bank0_bb85
    LDX #$07
    STX $02

_label_bank0_bb92:
    LDA $02
    JSR LoadEnemyObjectPointer
    LDA #$C2
    STA $04
    LDA #$1C
    STA $05
    LDA #$08
    CPX #$04
    ADC #$00
    JSR InitializeObjectStateHeader
    DEC $02
    BPL _label_bank0_bb92
    LDA #$00
    STA $80
    JSR $935F
    DEC $30
    BPL _label_bank0_bb83

_label_bank0_bbb7:
    LDY #$19
    JSR AddSoundEffect
    LDA #$C0
    AND $78
    BEQ _label_bank0_bc15
    LDA #$F0
    STA $31

_label_bank0_bbc6:
    LDA $26
    CMP $2B
    BEQ _label_bank0_bbc6
    STA $2B
    LDA #$00
    STA $30
    LDA #$0A
    STA $2A

_label_bank0_bbd6:
    JSR $BDF3
    LDY #$00
    LDA ($2E),Y
    CMP #$C0
    BCS _label_bank0_bbf9
    INC $30
    LDA $30
    BMI _label_bank0_bc09
    LDA $31
    BEQ _label_bank0_bc09
    DEC $30
    DEC $31
    JSR $BDAC
    ASL $30
    SEC
    ROR $30
    BCC _label_bank0_bc09

_label_bank0_bbf9:
    LDY #$07
    LDA ($2E),Y
    CMP #$D0
    BCC _label_bank0_bc06
    LDA #$00
    TAY
    STA ($2E),Y

_label_bank0_bc06:
    JSR $C342

_label_bank0_bc09:
    DEC $2A
    BPL _label_bank0_bbd6
    LDA $30
    AND #$0F
    CMP #$0B
    BNE _label_bank0_bbc6

_label_bank0_bc15:
    LDA #$C0
    AND $78
    CMP #$C0
    BEQ _label_bank0_bc20
    JMP $BCAD

_label_bank0_bc20:
    LDA #$07
    JSR QueueStaticPpuUpdateStream
    LDY #$1A
    JSR AddSoundEffect
    LDA #$80
    JSR $BE13
    LDA #$1F
    STA $30
    LDA #$04
    STA $2A
    LDA #$EB
    STA $1F

_label_bank0_bc3b:
    JSR $BE11
    LDA $1F
    ADC $2A
    STA $1F
    LDA #$FF
    EOR $2A
    STA $2A
    INC $2A
    DEC $30
    BPL _label_bank0_bc3b
    JSR $BE11
    DEC $30

_label_bank0_bc55:
    LDA #$10
    STA $02

_label_bank0_bc59:
    LDA $02
    JSR LoadEnemyObjectPointer
    LDA #$F0
    SBC $1F
    LSR A
    LSR A
    STA $03
    JSR $C1E3

_label_bank0_bc69:
    CMP $03
    BCC _label_bank0_bc71
    SBC $03
    BCS _label_bank0_bc69

_label_bank0_bc71:
    EOR #$FF
    ADC #$D8
    LDY #$07
    STA ($00),Y
    JSR $C1E3
    ASL A
    LDY #$0A
    STA ($00),Y
    LDY #$03

_label_bank0_bc83:
    LDA $BE4A,Y
    STA ($00),Y
    DEY
    BPL _label_bank0_bc83
    DEC $02
    BPL _label_bank0_bc59
    INC $30
    BMI _label_bank0_bc55
    LDA #$FE
    STA $30
    DEC $1F
    LDA $1F
    CMP #$90
    BCS _label_bank0_bc55
    LDY #$00
    LDX #$10

_label_bank0_bca3:
    TXA
    JSR LoadEnemyObjectPointer
    TYA
    STA ($00),Y
    DEX
    BPL _label_bank0_bca3
    LDY #$18
    JSR AddSoundEffect
    LDA #$04
    AND $7C
    BEQ _label_bank0_bcee
    LDX #$01
    STX $02

_label_bank0_bcbc:
    LDA $1B
    BNE _label_bank0_bcbc
    LDY #$FF
    TAX
    LDA $02
    BNE _label_bank0_bcc9
    LDY #$1A

_label_bank0_bcc9:
    INX
    INY
    LDA $BE55,Y
    STA $03E7,X
    BNE _label_bank0_bcc9
    LDA $1F
    CMP #$A0
    BCS _label_bank0_bcdb
    INY
    INY

_label_bank0_bcdb:
    LDX #$01

_label_bank0_bcdd:
    INY
    LDA $BE55,Y
    STA $03E6,X
    DEX
    BPL _label_bank0_bcdd
    JSR PublishPpuUpdateBuffer
    DEC $02
    BPL _label_bank0_bcbc

_label_bank0_bcee:
    LDA $78
    ROL A
    ROL A
    AND #$01
    TAX
    BCC _label_bank0_bcf8
    INX

_label_bank0_bcf8:
    LDY $BE8F,X
    STY $00

_label_bank0_bcfd:
    LDA $1B
    BNE _label_bank0_bcfd
    LDY $00
    INC $00
    LDX $BE92,Y
    BMI _label_bank0_bd37
    LDY $BEA4,X
    TAX

_label_bank0_bd0e:
    INX
    INY
    LDA $BEAE,Y
    STA $03E7,X
    BNE _label_bank0_bd0e
    CPY #$6A
    BCS _label_bank0_bd24
    LDA $1F
    CMP #$A0
    BCS _label_bank0_bd24
    INY
    INY

_label_bank0_bd24:
    INY
    LDA $BEAE,Y
    STA $03E7
    INY
    LDA $BEAE,Y
    STA $03E6
    JSR PublishPpuUpdateBuffer
    BNE _label_bank0_bcfd

_label_bank0_bd37:
    LDX #$02
    STX $2A

_label_bank0_bd3b:
    LDA #$10
    JSR $BE13
    JSR $BD97
    LDX $2A
    LDA $BD94,X
    STA $03F6
    JSR PublishPpuUpdateBuffer
    DEC $2A
    BPL _label_bank0_bd3b
    LDA #$00
    STA $03E4
    LDY #$10
    JSR AddSoundEffect

_label_bank0_bd5c:
    LDA $82
    BEQ _label_bank0_bd5c
    LDY #$01
    STY $78
    LDA #$E7
    AND $0301
    STA $0301
    STA a:PPU_MASK
    LDA #$0C
    JSR QueueStaticPpuUpdateStream
    LDA #$01
    JSR QueueStaticPpuUpdateStream
    LDA #$08
    JSR QueueStaticPpuUpdateStream
    LDA #$00
    STA $1F
    LDA #$18
    ORA $0301
    STA $0301
    LDA #$16
    JSR StartThread
    LDA #$06
    JSR StopThread
    BIT $0C1C
    LDX #$12

_label_bank0_bd99:
    LDA $95F3,X
    STA $03E6,X
    DEX
    BPL _label_bank0_bd99
    INX
    STX $03F9
    LDA #$4F
    STA $03E8
    RTS

    JSR $C1E3
    LDY #$07
    STA ($2E),Y
    STA $02
    JSR $C1E3
    ASL A
    LDY #$0A
    STA ($2E),Y
    STA $03
    LDA #$D0
    STA $04
    LDA #$78
    STA $05
    JSR $C364
    LDX #$03
    LDY #$07

_label_bank0_bdce:
    LDA $02,X
    STA ($2C),Y
    DEY
    DEX
    BPL _label_bank0_bdce
    JSR $C1E3
    CLC
    AND #$07
    ADC #$0C
    LDX #$50
    STX $05
    LDX #$C0
    STX $04
    JSR InitializeObjectStateHeader
    RTS

_label_bank0_bdea:
    JSR SwitchThreads
    LDA $057F
    BPL _label_bank0_bdea
    RTS

    LDA $2A
    JSR LoadEnemyAiPointer
    LDX #$00
    JSR $BE08
    LDA $2A
    JSR LoadEnemyObjectPointer
    LDX #$02
    JSR $BE08
    RTS

    LDY $00
    STY $2C,X
    LDY $01
    STY $2D,X
    RTS

    LDA #$04
    LDX #$00
    STX $26
    LDX #$26
    JSR WaitForZeroPageCounterAboveThreshold
    RTS

    STA $02
    STX $03
    JSR BuildAndPublishRoomMapCellUpdate
    RTS

    .byte $e0, $00, $50, $01, $08, $03, $d0, $07, $20
    .byte $0a, $e0, $14, $50, $15
    .byte $09, $17, $d0, $1b, $30, $1e, $c0, $50, $ff, $0a, $a0, $00, $fe, $00, $00, $00
    .byte $d0, $78, $00, $80, $02, $00, $1f, $c0, $50, $ff, $0b, $1f, $1e, $2b, $00, $07
    .byte $50, $00, $54, $0f, $0a, $12, $1b, $12, $0e, $1c, $24, $20, $0e, $1b, $0e, $24
    .byte $1b, $0e, $15, $0e, $0a, $1c, $0e, $0d, $00, $64, $28, $a4, $22, $58, $0a, $17
    .byte $0d, $24, $0f, $15, $0e, $20, $24, $0a, $1b, $18, $1e, $17, $0d, $24, $1d, $11
    .byte $0e, $24, $20, $18, $1b, $15, $0d, $00, $a2, $28, $e2, $22, $00, $04, $0b, $00
    .byte $01, $02, $80, $00, $01, $03, $04, $05, $06, $80, $00, $01, $03, $07, $08, $09
    .byte $80, $ff, $20, $31, $4d, $6a, $7a, $99, $b5, $bc, $dc, $5a, $1d, $11, $0e, $24
    .byte $19, $18, $20, $0e, $1b, $24, $18, $0f, $28, $1c, $18, $15, $18, $16, $18, $17
    .byte $3b, $1c, $24, $14, $0e, $22, $3a, $00, $e2, $28, $22, $23, $4a, $1c, $0e, $0a
    .byte $15, $0e, $0d, $24, $0a, $20, $0a, $22, $00, $29, $29, $69, $23, $55, $1d, $11
    .byte $0e, $24, $0d, $0e, $1f, $12, $15, $1c, $24, $1e, $17, $0d, $0e, $1b, $10, $1b
    .byte $18, $1e, $17, $0d, $00, $64, $29, $a4, $23, $56, $0a, $15, $15, $24, $18, $0f
    .byte $24, $1d, $11, $0e, $24, $0e, $1f, $12, $15, $24, $1c, $19, $12, $1b, $12, $1d
    .byte $1c, $00, $63, $29, $a3, $23, $4b, $12, $17, $24, $1d, $11, $0e, $24, $20, $18
    .byte $1b, $15, $0d, $00, $a9, $29, $5a, $11, $18, $20, $0e, $1f, $0e, $1b, $25, $0a
    .byte $24, $1c, $16, $0a, $15, $15, $24, $19, $18, $1c, $1c, $12, $0b, $12, $15, $12
    .byte $1d, $22, $00, $e2, $29, $57, $18, $0f, $24, $1d, $11, $0e, $12, $1b, $24, $1b
    .byte $0e, $1f, $12, $1f, $0a, $15, $24, $1b, $0e, $16, $0a, $12, $17, $1c, $00, $23
    .byte $2a, $42, $0a, $17, $0d, $00, $2d, $28, $5b, $1d, $11, $0e, $24, $0c, $18, $17
    .byte $1c, $1d, $0e, $15, $15, $0a, $1d, $12, $18, $17, $24, $20, $0a, $1c, $24, $1b
    .byte $1e, $12, $17, $0e, $0d, $00, $61, $28, $5a, $19, $0e, $0a, $0c, $0e, $24, $20
    .byte $12, $15, $15, $24, $0b, $0e, $24, $18, $1e, $1b, $3b, $1c, $24, $0f, $18, $1b
    .byte $0e, $1f, $0e, $1b, $00, $a2, $28

    PHA
    JSR $BFCE
    PLA
    STA $7B
    AND $7A
    BNE _label_bank0_bfc5
    LDX #$FF
    LDA $7B
_label_bank0_bfb9:
    INX
    LSR A
    BCC _label_bank0_bfb9
    LDY $BFC6,X
    LDA #$60
    STA $0304,Y
_label_bank0_bfc5:
    RTS

; Solomon's Seal positions
; Levels 9, 13, 17, 19, 21, 29, 46, 47
    .byte $89, $97, $2d, $54, $6b, $b7, $1d, $1e

    LDA #$02
    LDX #$7C
    JSR WaitForMaskedBitsSet
    RTS

    .byte $41, $51, $61, $71, $81, $4d, $5d, $6d, $7d, $8d, $46, $48

; Level 20 Bat symbols, 24-byte bitmask (12 * 2-byte pairs, as per level block data)
    .byte $fe
    .byte $fe, $60, $cc, $5e, $f4, $7f, $cc, $df, $78, $f7, $dc, $79, $b6, $2f, $bc, $7d
    .byte $d8, $57, $7c, $7f, $f6, $db, $be

; Level 30 Blue opals, 24-byte bitmask (12 * 2-byte pairs, as per level block data)
    .byte $00, $00, $54, $54, $00, $00, $aa, $aa, $00
    .byte $00, $55, $54, $00, $00, $aa, $aa, $00, $00, $15, $50, $00, $00, $00, $00

    .byte $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $55, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $fd, $00, $ff
    .byte $01, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $58, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $6f, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $48, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $fe, $02, $ff
    .byte $02, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $bf, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

    LDA #$10
    STA $02

_label_bank0_c104:
    LDA $02
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA ($00),Y
    BPL _label_bank0_c16a
    LSR A
    BCC _label_bank0_c16a
    INY
    LDA ($00),Y
    LSR A
    LSR A
    SEC
    SBC #$06
    BCC _label_bank0_c16a
    TAX
    LDA $C178,X
    STA $03
    LDA $02
    JSR LoadEnemyAiPointer
    LDA #$00
    STA ($00),Y
    TAY
    LDA ($00),Y
    LSR A
    BCC _label_bank0_c13a
    PHA
    LDY #$06
    LDA ($00),Y
    JSR DeactivateEnemySlot
    PLA

_label_bank0_c13a:
    LSR A
    BCC _label_bank0_c144
    LDY #$07
    LDA ($00),Y
    JSR DeactivateEnemySlot

_label_bank0_c144:
    LDA #$80
    STA ($00),Y
    JSR $C1E3
    AND #$07
    CLC
    ADC $03
    TAX
    LDA $C193,X
    LDY #$06
    STA ($00),Y
    LDA $02
    JSR LoadEnemyObjectPointer
    LDA #$C6
    STA $04
    LDA #$14
    STA $05
    LDA #$00
    JSR InitializeObjectStateHeader

_label_bank0_c16a:
    DEC $02
    BPL _label_bank0_c104
    LDY #$09
    JSR AddSoundEffect
    LDA #$05
    JSR StopThread

    .byte $00, $00, $00, $48, $08, $08, $18, $10, $18, $10, $18
    .byte $10, $18, $10, $20, $20, $20, $28, $28, $28, $30, $30, $38, $38, $40, $40, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $04, $08, $08, $08, $09, $09, $09, $09
    .byte $04, $08, $08, $08, $09, $09, $09, $0a, $08, $08, $09, $09, $09, $09, $0a, $0a
    .byte $04, $0b, $0b, $0b, $0b, $0c, $0c, $0c, $0b, $0b, $0c, $0c, $0c, $0d, $0d, $02
    .byte $0b, $0b, $0b, $0c, $0c, $03, $03, $06, $04, $0b, $0c, $0c, $0d, $0d, $02, $02
    .byte $0e, $0e, $0e, $0e, $0f, $05, $05, $05, $0e, $0e, $0e, $0f, $0f, $0f, $05, $05

    LDA $043E
    CMP $3E
    BEQ _label_bank0_c1f7
    STA $3E
    LDA $043C
    STA $0448
    LDA $20
    STA $0449

_label_bank0_c1f7:
    LDA $0448
    ORA #$01
    STA $04
    LDA $0449
    STA $05
    LDA #$00
    STA $06
    STA $07
    LDY #$7C
    JSR $C221
    LDY #$FC
    JSR $C221
    LDA $07
    AND #$7F
    STA $0449
    LDA $06
    STA $0448
    LSR A
    RTS

    LDX #$08

_label_bank0_c223:
    TYA
    LSR A
    TAY
    BCS _label_bank0_c234
    LDA $06
    ADC $04
    STA $06
    LDA $07
    ADC $05
    STA $07

_label_bank0_c234:
    LSR $05
    ROR $04
    DEX
    BNE _label_bank0_c223
    RTS

_label_bank0_c23c:
    LDA $057F
    ROR A
    BCC _label_bank0_c247
    JSR SwitchThreads
    BCS _label_bank0_c23c

_label_bank0_c247:
    ASL A
    AND #$BF
    STA $057F
    LDA $05A7
    STA $05A9
    AND #$BF
    STA $05A7
    LDX #$10

_label_bank0_c25a:
    TXA
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA ($00),Y
    PHA
    AND #$BF
    STA ($00),Y
    LDY #$02
    PLA
    STA ($00),Y
    DEX
    BPL _label_bank0_c25a
    LDY #$06
    LDA ($30),Y
    STA $02
    TAX
    LDA #$10
    STA $0304,X
    STA $03
    JSR BuildAndPublishRoomMapCellUpdate
    LDY #$06
    JSR $C2A8
    LDX #$10

_label_bank0_c287:
    TXA
    JSR LoadEnemyObjectPointer
    LDY #$02
    LDA ($00),Y
    LDY #$00
    STA ($00),Y
    DEX
    BPL _label_bank0_c287
    LDA #$E0
    STA $057F
    LDA $05A9
    STA $05A7
    LDA #$30
    JSR StartThread
    LDY #$07
    LDA ($30),Y
    STA $04
    JSR ConvertMapIndexToPixelCoordinates
    LDA $04
    STA $02
    STA $05C2
    LDA $05
    STA $03
    STA $05C5
    LDY #$05
    LDA ($30),Y
    STA $04

_label_bank0_c2c3:
    LDA $C328,Y
    STA $05BB,Y
    DEY
    BPL _label_bank0_c2c3
    JSR ConvertMapIndexToPixelCoordinates
    JSR $C364
    DEC $03
    LDX #$03

_label_bank0_c2d6:
    LDA $02,X
    STA $0308,X
    DEX
    BPL _label_bank0_c2d6
    INX
    STX $23

_label_bank0_c2e1:
    LDA $23
    CMP #$40
    BCS _label_bank0_c2ff
    CMP $3E
    BEQ _label_bank0_c2fa
    STA $3E
    LDX #$03

_label_bank0_c2ef:
    LDA $C32E,X
    STA $2C,X
    DEX
    BPL _label_bank0_c2ef
    JSR $C332

_label_bank0_c2fa:
    JSR SwitchThreads
    BCS _label_bank0_c2e1

_label_bank0_c2ff:
    LDX #$07
    LDA #$F8

_label_bank0_c303:
    STA $0304,X
    DEX
    BPL _label_bank0_c303
    INX
    STX $05BB
    STX $23
    LDA #$34
    JSR $C31D
    LDX #$23
    LDA #$06
    JSR WaitForZeroPageCounterAboveThreshold
    LDA #$07
    STA $03
    LDY #$05
    LDA ($30),Y
    STA $02
    JMP BuildAndPublishRoomMapCellUpdate

    .byte $c2, $04, $ff, $0d, $ff, $c3, $04, $03, $bb, $05, $a0
    .byte $04

    LDA #$08
    CLC
    ADC ($2C),Y
    STA ($2C),Y
    INY
    LDA #$00
    ADC ($2C),Y
    STA ($2C),Y
    LDX #$00

_label_bank0_c344:
    CLC
    JSR $C350
    JSR $C350
    CPX #$04
    BNE _label_bank0_c344
    RTS

    LDY $C35E,X
    LDA ($2C),Y
    LDY $C360,X
    ADC ($2E),Y
    STA ($2E),Y
    INX
    RTS

    .byte $04, $05, $06, $07, $09
    .byte $0a

    LDX #$01

_label_bank0_c366:
    LDY #$00
    SEC
    LDA $04,X
    SBC $02,X
    BCS _label_bank0_c370
    DEY

_label_bank0_c370:
    STY $04,X
    ASL A
    ROL $04,X
    ASL A
    ROL $04,X
    STA $02,X
    DEX
    BPL _label_bank0_c366
    LDA $03
    LDX $04
    STA $04
    STX $03
    RTS

    JSR $C3B0
    LDA #$C0
    STA $05C0
    JSR $C3D4
    LDA #$40
    BNE _label_bank0_c39d
    JSR $C3B0
    JSR $C3D4
    LDA #$12

_label_bank0_c39d:
    LDX #$00
    STX $24
    LDX #$24
    JSR WaitForZeroPageCounterAboveThreshold
    LDA #$00
    STA $05BB
    LDA #$04
    JSR StopThread
    LDA #$01
    ORA $87
    STA $87
    LDA $05C2
    STA $04
    LDA $05C5
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    LDA #$10
    STA $0304,X
    STX $02
    STA $03
    JSR BuildAndPublishRoomMapCellUpdate
    LSR $87
    ASL $87
    RTS

    JSR $C403
    JSR PublishPpuUpdateBuffer
    JSR $A30C
    JMP $C3E7
    LDA #$FF
    LDX #$1B
    JMP WaitForMaskedBitsClear
    JSR $C3E0
    LDX #$04

_label_bank0_c3ec:
    LDA $C3FE,X
    STA $03E6,X
    DEX
    BPL _label_bank0_c3ec
    LDA $0453
    STA $03E9
    JMP PublishPpuUpdateBuffer

    .byte $20, $71, $40, $00, $00

    JSR $C3E0
    LDX #$02

_label_bank0_c408:
    LDA $C42F,X
    STA $03E6,X
    DEX
    BPL _label_bank0_c408
    CLC
    INX
    LDY #$07

_label_bank0_c415:
    LDA $044A,X
    BNE _label_bank0_c420
    BCS _label_bank0_c421
    LDA #$24
    BPL _label_bank0_c421

_label_bank0_c420:
    SEC

_label_bank0_c421:
    STA $03E9,X
    INX
    DEY
    BNE _label_bank0_c415
    STY $03F0
    STY $03F1

_label_bank0_c42e:
    RTS

    JSR $4760
    LDA $0582
    CMP #$1C
    BCS _label_bank0_c42e
    LDA $0586
    ADC #$08
    STA $04
    LDA $0589
    ADC #$08
    STA $05
    JSR ConvertPixelCoordinatesToMapIndex
    LDA #$00
    STA $02
    LDA $0304,X
    JSR $C45B
    LDA $02
    BEQ _label_bank0_c42e
    JMP $8D5F
    CMP #$38
    BCS _label_bank0_c4b5
    CMP #$10
    BEQ _label_bank0_c4b5
    CMP #$06
    BCC _label_bank0_c4b5
    CMP #$25
    BCC _label_bank0_c4b6
    TAX
    LDA $87
    LSR A
    BCS _label_bank0_c4b5
    LDA #$40
    STA $02
    TXA
    JSR SpawnAuxiliaryEffectAtMapCell
    CMP #$32
    BCS _label_bank0_c498
    LDY #$0D
    JSR AddSoundEffect
    SBC #$24
    LDX #$FF

_label_bank0_c486:
    SBC #$03
    INX
    BCS _label_bank0_c486
    ADC #$03
    TAY
    LDA ItemBonusScoreDigitIndices,X
    TAX
    LDA ItemBonusScoreAmounts,Y
    JMP AddScoreByAAtDigitX

_label_bank0_c498:
    BNE _label_bank0_c4a1
    LDX #$02
    LDA #$05
    JSR AddScoreByAAtDigitX

_label_bank0_c4a1:
    LDY #$06
    JSR AddSoundEffect
    INC $0452
    LDA #$00
    STA $05C0
    INC $05BE
    LDA #$41
    STA $02

_label_bank0_c4b5:
    RTS

_label_bank0_c4b6:
    CMP #$08
    BCC _label_bank0_c4c5
    TAY
    LDA $87
    LSR A
    TYA
    BCC _label_bank0_c4c2
    RTS

_label_bank0_c4c2:
    JSR SpawnAuxiliaryEffectAtMapCell

_label_bank0_c4c5:
    LDY #$40
    STY $02
    LDY #$0D
    JSR AddSoundEffect
    SBC #$05
    JSR JumpWithParams

    .byte $63, $c5, $87, $c5, $03, $c7, $a3, $c6, $0a, $c7, $c0, $c6, $0a, $c7, $ae, $c6
    .byte $98, $c6, $aa, $c6, $b5, $c4, $28, $c6, $4b, $c6, $7e, $c6, $82, $c6, $a3, $c6
    .byte $ae, $c6, $98, $c6, $aa, $c6, $0d, $c5, $b5, $c4, $b5, $c6, $5c, $c5, $5c, $c5
    .byte $5c, $c5, $5c, $c5, $53, $c5, $44, $c5, $3d, $c5

    LDX #$10

_label_bank0_c50f:
    TXA
    JSR LoadEnemyObjectPointer
    LDY #$00
    LDA ($00),Y
    CMP #$C0
    BCC _label_bank0_c52c
    INY
    LDA ($00),Y
    SBC #$50
    CMP #$18
    BCS _label_bank0_c52c
    TYA
    DEY
    ORA ($00),Y
    STA ($00),Y
    STY $02

_label_bank0_c52c:
    DEX
    BPL _label_bank0_c50f
    LDA $02
    BNE _label_bank0_c53c
    LDA #$50
    JSR StartThread
    LDA #$40
    STA $02

_label_bank0_c53c:
    RTS

    LDA #$40
    ORA $28
    STA $28
    RTS

    LDA $0428
    CMP #$1E
    LDA #$40
    BCC _label_bank0_c54e
    ASL A

_label_bank0_c54e:
    ORA $78
    STA $78
    RTS

    INC $79
    LDA $7A
    ORA $7B
    STA $7A
    RTS

    LDA $78
    ORA #$08
    STA $78
    RTS

    LDY #$05
    LDA ($30),Y
    TAY
    LDA #$07
    STA $0304,Y
    LDA $0429
    BNE _label_bank0_c578
    LDA #$20
    ORA $28
    STA $28

_label_bank0_c578:
    LDY #$16
    JSR AddSoundEffect
    LDA #$04
    JSR StopThread
    LDA #$34
    STA $02
    RTS

    LDA #$80
    STA $057F
    LDX #$03
    JSR ResetOtherSecondaryThreads
    LDY #$15
    JSR AddSoundEffect
    INC $85
    LDA #$40
    AND $28
    BEQ _label_bank0_c5a7
    CLC
    LDA #$05
    ADC $0428
    STA $0428

_label_bank0_c5a7:
    LDY $79
    LDA $0429
    BNE _label_bank0_c5cd
    LDX $0428
    CPX #$0A
    BCC _label_bank0_c5bd
    LDA $7C
    AND #$10
    BNE _label_bank0_c5bd
    INC $84

_label_bank0_c5bd:
    LDX $0428
    CPX #$2F
    BNE _label_bank0_c5c9
    CPY #$08
    BCS _label_bank0_c5c9
    INX

_label_bank0_c5c9:
    INX
    STX $0428

_label_bank0_c5cd:
    LDA #$08
    AND $78
    BEQ _label_bank0_c5ef
    CPY #$04
    BCC _label_bank0_c5e9
    LDA #$10
    LDX $0428
    CPX #$14
    BEQ _label_bank0_c5eb
    CPY #$06
    BCC _label_bank0_c5e9
    ASL A
    CPX #$2C
    BEQ _label_bank0_c5eb

_label_bank0_c5e9:
    LDA #$30

_label_bank0_c5eb:
    ORA $78
    STA $78

_label_bank0_c5ef:
    LDA #$DF
    AND $28
    STA $28
    JSR $C60E
    STA $042A
    STA $0429
    LDA #$EE
    AND $7C
    STA $7C
    LDA #$14
    JSR StartThread
    LDA #$03
    JSR StopThread
    LDA #$00
    LDY #$A4

_label_bank0_c612:
    DEY
    STA $067F,Y
    BNE _label_bank0_c612
    TAY

_label_bank0_c619:
    STA $057F,Y
    DEY
    BNE _label_bank0_c619
    LDY #$88

_label_bank0_c621:
    DEY
    STA $04F7,Y
    BNE _label_bank0_c621
    RTS

.segment "PRG_POST_SECONDARY_THREAD_RESET"

    JSR ResetRoomTransitionState
    LDA $0582
    AND #$01
    ORA #$20
    STA $0582
    LDA #$00
    PHA
    STA $02
    JSR SetActiveNonDanaObjectState
    INX

_label_bank0_c7a0:
    STX $23
    LDX #$23
    LDA #$04
    JSR WaitForZeroPageCounterAboveThreshold
    PLA
    CMP #$18
    BCS _label_bank0_c7c3
    ADC #$01
    PHA
    AND #$03
    TAX
    LDA $0301
    AND #$5E
    ORA $C981,X
    STA $0301
    LDX #$00
    BEQ _label_bank0_c7a0

_label_bank0_c7c3:
    LDA $1B
    BNE _label_bank0_c7c3
    LDA #$1E
    STA $0301
    STA a:PPU_MASK
    JSR Clear30x24NametableRegion
    LDA #$03
    STA $7D
    LDA #$85
    STA $1A
    LDA #$C9
    STA $1B
    LDX #$23
    LDA #$64
    JSR WaitForZeroPageCounterAboveThreshold
    BCC _label_bank0_c832
    JSR ResetRoomTransitionState
    LDA #$10
    ORA $28
    STA $28
    LDA $0582
    LSR A
    LDA #$10
    ROL A
    STA $0582
    LDA #$80
    STA $02
    ASL A
    STA $23
    JSR SetActiveNonDanaObjectState
    LDX #$23
    LDA #$09
    JSR WaitForZeroPageCounterAboveThreshold
    LDA #$C0
    STA $057F
    LDA #$C3
    STA $0584

_label_bank0_c815:
    LDA $0586
    CMP #$D1
    BCS _label_bank0_c821
    JSR SwitchThreads
    BCS _label_bank0_c815

_label_bank0_c821:
    INC $0582
    INC $0582
    LDA #$00
    STA $23
    LDX #$23
    LDA #$30
    JSR WaitForZeroPageCounterAboveThreshold

_label_bank0_c832:
    JSR DeactivateAllNonDanaObjects
    JSR Clear30x24NametableRegion
    JSR $C60E
    LDA #$10
    ORA $7C
    STA $7C
    LDA $78
    LSR A
    BCS _label_bank0_c849
    JMP $C928

_label_bank0_c849:
    LDX $0452
    DEX
    BEQ _label_bank0_c852
    JMP $C959

_label_bank0_c852:
    LDA $78
    ROL A
    ROL A
    AND #$01
    ADC #$00
    SEC
    ADC $86
    STA $00
    LDA $7C
    AND #$04
    CLC
    BEQ _label_bank0_c867
    SEC

_label_bank0_c867:
    LDA #$00
    ADC $00
    ASL A
    STA $00
    LDA $85
    ADC $79
    ADC $00
    ASL A
    ADC $84
    LSR A
    LSR A
    LSR A
    STA $00
    LDA $044A
    ORA $044B
    BNE _label_bank0_c88b
    LDX $044C
    CPX #$05
    BCC _label_bank0_c88d

_label_bank0_c88b:
    LDX #$05

_label_bank0_c88d:
    TXA
    CLC
    ADC $00
    STA $00
    LDA $7C
    AND #$08
    CLC
    BEQ _label_bank0_c89b
    SEC

_label_bank0_c89b:
    LDA #$00
    ADC $00
    ADC #$2F
    CMP $07F4
    BCC _label_bank0_c8a9
    STA $07F4

_label_bank0_c8a9:
    STA $0455
    LDX #$02
    LDA #$00

_label_bank0_c8b0:
    STA $84,X
    DEX
    BPL _label_bank0_c8b0
    LDX #$07
    SEC

_label_bank0_c8b8:
    LDA $044A,X
    SBC $07F6,X
    DEX
    BPL _label_bank0_c8b8
    BCC _label_bank0_c8ce
    LDY #$08

_label_bank0_c8c5:
    LDA $0449,Y
    STA $07F5,Y
    DEY
    BNE _label_bank0_c8c5

_label_bank0_c8ce:
    STY $0453
    LDX #$03
    TYA

_label_bank0_c8d4:
    STA $042C,X
    DEX
    BPL _label_bank0_c8d4
    STY $0432
    INY
    STY $0433
    LDX #$03
    STX $042B
    STX $7D
    LDY #$05
    JSR AddSoundEffect
    LDA #$06
    JSR QueueStaticPpuUpdateStream
    LDA #$FF
    LDX #$1B
    JSR WaitForMaskedBitsClear
    LDX #$0E

_label_bank0_c8fb:
    LDA $C998,X
    STA $03E6,X
    DEX
    BPL _label_bank0_c8fb
    LDX $0455
    JSR $92A9
    STX $03F2
    STA $03F3
    JSR PublishPpuUpdateBuffer

_label_bank0_c913:
    LDA $03E4
    CMP #$C8
    BEQ _label_bank0_c92c
    JSR SwitchThreads
    LDA $042D
    CMP #$02
    BCC _label_bank0_c913

_label_bank0_c924:
    LSR $78
    ASL $78
    LDA #$17
    BNE _label_bank0_c966

_label_bank0_c92c:
    LDA #$EE
    AND $7C
    STA $7C
    LDY #$18
    JSR AddSoundEffect
    LDX #$07
    LDA #$00

_label_bank0_c93b:
    STA $044A,X
    DEX
    BPL _label_bank0_c93b
    LDA #$DF
    AND $28
    STA $28
    LDX #$28
    CPX $0428
    BCS _label_bank0_c957
    LDA #$08
    BIT $7C
    BNE _label_bank0_c924
    STX $0428

_label_bank0_c957:
    LDX #$03
    LDA $0429
    BEQ _label_bank0_c964
    LDA #$EE
    AND $7C
    STA $7C

_label_bank0_c964:
    LDA #$15

_label_bank0_c966:
    STX $0452
    PHA
    JSR Clear30x24NametableRegion
    PLA
    JSR StartThread
    LDA #$00
    STA $0429
    STA $057F
    STA $042A
    LDA #$03
    JSR StopThread

    .byte $00, $21
    .byte $00, $81, $21, $ea, $48, $1d, $12, $16, $0e, $24, $18, $1f, $0e, $1b, $23, $da
    .byte $42, $c0, $f0, $f0, $00, $21, $e9, $4a, $22, $18, $1e, $1b, $24, $10, $0d, $1f
    .byte $24, $24, $24, $00

.segment "PRG_POST_NON_DANA_OBJECT_DEACTIVATION"

    LDX #$01
    JSR ResetOtherSecondaryThreads
    LDY #$18
    JSR AddSoundEffect
    LDA #$EF
    STA $1F
    LDA #$03
    STA $7D
    LDA $7C
    BPL _label_bank0_ca8c
    LDA #$7F
    AND $7C
    STA $7C
    BPL _label_bank0_cab9

_label_bank0_ca8c:
    JSR ClearBothNametables
    LDX #$0D

_label_bank0_ca91:
    TXA
    JSR QueueStaticPpuUpdateStream
    INX
    CPX #$12
    BNE _label_bank0_ca91
    LDA #$00
    STA $28
    STA $043C
    STA $043D

_label_bank0_caa4:
    LDA $043D
    CMP #$01
    BCS _label_bank0_cab9
    LDA $03E4
    AND #$30
    BEQ _label_bank0_caa4

_label_bank0_cab2:
    LDA $03E4
    AND #$30
    BNE _label_bank0_cab2

_label_bank0_cab9:
    LDX #$01
    JSR ResetOtherSecondaryThreads
    LDY #$18
    JSR AddSoundEffect
    LDA #$EF
    STA $1F
    LDA #$03
    STA $7D
    LDA #$00
    STA $28
    JSR ClearBothNametables
    JSR $CCCD
    JSR $CC0D
    LDA #$00
    STA $043C
    STA $043D

_label_bank0_cae0:
    LDA $043D
    CMP #$02
    BCC _label_bank0_caf0
    LDA #$00
    STA $1F
    LDA #$18
    JSR StartThread

_label_bank0_caf0:
    LDA $03E4
    AND #$30
    BEQ _label_bank0_cae0

_label_bank0_caf7:
    LDA $03E4
    AND #$30
    BNE _label_bank0_caf7
    LDA #$00
    STA $1F
    JSR ClearBothNametables
    LDA #$10
    JSR StartThread
    LDA #$22
    JSR StartThread
    LDX #$01
    STX $0433
    STX $80
    INX
    STX $0428
    INX
    STX $042B
    STX $0452
    LDX #$54
    STX $042F
    LDA #$15
    JSR StartThread
    LDA #$00
    STA $22
    STA $81

_label_bank0_cb31:
    JSR SwitchThreads
    LDA $03E4
    AND #$30
    BEQ _label_bank0_cb43
    LDA #$80
    ORA $7C
    STA $7C
    BMI _label_bank0_cb5e

_label_bank0_cb43:
    LDX $81
    LDA $CEF1,X
    CMP $22
    BCS _label_bank0_cb31
    CPX #$22
    BCS _label_bank0_cb65
    LDA $CF13,X
    STA $03E4
    INC $81
    LDA #$00
    STA $22
    BEQ _label_bank0_cb31

_label_bank0_cb5e:
    LDA $03E4
    AND #$30
    BNE _label_bank0_cb5e

_label_bank0_cb65:
    LDA #$35
    JSR StartThread
    LDA #$02
    JSR StopThread
.segment "PRG_POST_FULL_NAMETABLE_CLEAR"

    LDY a:PPU_STATUS
    LDY #$00
    STY $02
    STY $03
    DEY

_label_bank0_cbb0:
    INY
    LDA ($00),Y
    BMI _label_bank0_cbe2

_label_bank0_cbb5:
    TAX
    TYA
    CLC
    ADC $00
    STA $00
    BCC _label_bank0_cbc0
    INC $01

_label_bank0_cbc0:
    LDY #$00
    TXA
    CPX #$40
    BCC _label_bank0_cbde
    CPX #$60
    BCC _label_bank0_cbda
    INX
    BPL _label_bank0_cbd2
    LDX a:PPU_STATUS
    RTS

_label_bank0_cbd2:
    AND #$1F
    ADC $03
    STA $03
    BPL _label_bank0_cbb0

_label_bank0_cbda:
    STA $03
    BPL _label_bank0_cbb0

_label_bank0_cbde:
    STA $02
    BCC _label_bank0_cbb0

_label_bank0_cbe2:
    LDX $03
    TXA
    CLC
    ADC #$10
    LSR A
    LSR A
    AND #$2B
    ORA #$20
    STA a:PPU_ADDR
    TXA
    ROR A
    ROR A
    ROR A
    AND #$C0
    ORA $02
    STA a:PPU_ADDR
    LDA $0300
    STA a:PPU_CTRL
    DEY

_label_bank0_cc03:
    INY
    LDA ($00),Y
    BPL _label_bank0_cbb5
    STA a:PPU_DATA
    BMI _label_bank0_cc03
    JSR BeginDirectPpuTransfer
    LDA #$5F
    STA $00
    LDA #$CD
    STA $01
    JSR $CBA6
    LDY #$2F
    LDA #$2B
    LDX #$C9
    JSR SetPpuAddressAX
    LDA $0300
    STA a:PPU_CTRL
    LDY #$14

_label_bank0_cc2c:
    LDA $CCAF,Y
    STA a:PPU_DATA
    DEY
    BPL _label_bank0_cc2c
    LDX a:PPU_STATUS
    JSR EndDirectPpuTransfer
    LDX #$09

_label_bank0_cc3d:
    TXA
    JSR QueueStaticPpuUpdateStream
    INX
    CPX #$0C
    BCC _label_bank0_cc3d
    JSR $C403
    LDX #$02

_label_bank0_cc4b:
    LDA $CCC4,X
    STA $03E6,X
    DEX
    BPL _label_bank0_cc4b
    JSR PublishPpuUpdateBuffer
    LDA #$FF
    LDX #$1B
    JSR WaitForMaskedBitsClear
    LDX #$02

_label_bank0_cc60:
    LDA $CCC7,X
    STA $03E6,X
    DEX
    BPL _label_bank0_cc60
    CLC
    LDY #$07
    LDX #$00

_label_bank0_cc6e:
    LDA $07F6,X
    BNE _label_bank0_cc79
    BCS _label_bank0_cc7a
    LDA #$24
    BPL _label_bank0_cc7a

_label_bank0_cc79:
    SEC

_label_bank0_cc7a:
    STA $03E9,X
    INX
    DEY
    BNE _label_bank0_cc6e
    STY $03F0
    STY $03F1
    JSR PublishPpuUpdateBuffer
    LDA #$FF
    LDX #$1B
    JSR WaitForMaskedBitsClear
    LDX $07F4
    JSR $92A9
    STX $03E9
    STA $03EA
    LDX #$02

_label_bank0_cc9f:
    LDA $CCCA,X
    STA $03E6,X
    DEX
    BPL _label_bank0_cc9f
    INX
    STX $03EB
    JMP PublishPpuUpdateBuffer

    .byte $f5, $f5, $f5, $f5
    .byte $f7, $ff, $ff, $ff, $56, $5a, $5a, $5a, $77, $ff, $ff, $ff, $6f, $af, $af, $af
    .byte $7f, $28, $80, $47, $28, $8b, $47, $28, $98, $41

_label_bank0_cccd:
    LDA a:PPU_STATUS
    BPL _label_bank0_cccd
    LDA #$05
    JSR QueueStaticPpuUpdateStream
    JSR BeginDirectPpuTransfer
    LDA #$FA
    STA $00
    LDA #$CD
    STA $01
    JSR $CBA6
    LDA #$2B
    LDX #$80
    JSR SetPpuAddressAX
    LDA $0300
    STA a:PPU_CTRL
    LDA #$DF
    LDY #$DE
    LDX #$0F

_label_bank0_ccf8:
    STA a:PPU_DATA
    STY a:PPU_DATA
    DEX
    BPL _label_bank0_ccf8
    LDX a:PPU_STATUS
    LDA #$2B
    LDX #$F8
    JSR SetPpuAddressAX
    LDX $0300
    STX a:PPU_CTRL
    LDY #$F5
    LDX #$08

_label_bank0_cd15:
    STY a:PPU_DATA
    DEX
    BNE _label_bank0_cd15
    LDX a:PPU_STATUS
    LDA #$2B
    LDX #$EA
    JSR SetPpuAddressAX
    LDX $0300
    STX a:PPU_CTRL
    LDX #$CF
    STX a:PPU_DATA
    LDX #$F0
    JSR SetPpuAddressAX
    LDX $0300
    STX a:PPU_CTRL
    LDX #$06

_label_bank0_cd3d:
    LDA $CD4C,X
    STA a:PPU_DATA
    DEX
    BPL _label_bank0_cd3d
    LDX a:PPU_STATUS
    JMP EndDirectPpuTransfer

    .byte $3f, $cc, $cc, $00, $cc, $ff, $3f

.segment "PRG_POST_SET_PPU_ADDRESS"

    .byte $53, $06, $e8, $8f
    .byte $8e, $8e, $8f, $8e, $8e, $8f, $8e, $8e, $8f, $8e, $8e, $8e, $8e, $8f, $8f, $ea
    .byte $60, $ea, $e0, $82, $83, $86, $87, $92, $93, $96, $97, $ae, $af, $ba, $bb, $be
    .byte $bf, $d1, $ea, $60, $ea, $d1, $d1, $d1, $d1, $e3, $e6, $e7, $f2, $f3, $f6, $f7
    .byte $9a, $d1, $d1, $d1, $d1, $ea, $60, $ea, $d1, $d1, $d1, $d1, $eb, $ee, $ef, $fa
    .byte $fb, $fe, $ff, $a9, $d1, $9e, $9f, $d1, $ea, $53, $26, $ea, $d1, $80, $81, $84
    .byte $85, $90, $91, $94, $95, $ac, $ad, $b8, $b9, $bc, $bd, $d1, $ea, $60, $e8, $e2
    .byte $88, $89, $8c, $e1, $e4, $e5, $f0, $f1, $f4, $f5, $8d, $99, $8a, $8b, $d1, $ea
    .byte $60, $ea, $d1, $d1, $d1, $d1, $e9, $ec, $ed, $f8, $f9, $fc, $fd, $9b, $d1, $d1
    .byte $d1, $d1, $ea, $60, $ea, $9c, $9c, $9d, $9c, $9c, $9d, $9c, $9c, $9c, $9c, $9c
    .byte $9c, $9d, $9c, $9d, $9d, $ea, $7f, $59, $26, $d7, $d4, $d6, $d1, $d1, $d5, $d7
    .byte $d5, $d7, $d1, $d1, $d5, $d7, $d5, $d7, $d4, $d6, $5a, $05, $dd, $c5, $c5, $d0
    .byte $d6, $d5, $c5, $dc, $d3, $d3, $d6, $d4, $c5, $dc, $d0, $d3, $c5, $d3, $d6, $d7
    .byte $23, $d5, $d7, $d4, $d3, $c7, $c6, $c7, $c6, $c7, $c6, $d3, $c6, $c7, $c6, $d3
    .byte $c6, $d2, $dc, $c7, $c6, $d3, $d3, $d6, $5b, $02, $dd, $c5, $c4, $d0, $d3, $c5
    .byte $c0, $c1, $c4, $c5, $c4, $c5, $c4, $c5, $c4, $c5, $c4, $d0, $d3, $d0, $d3, $d0
    .byte $c6, $d3, $d7, $22, $d4, $c7, $c6, $d3, $c6, $c7, $c2, $c3, $c6, $c7, $c6, $c7
    .byte $c6, $c7, $c6, $c7, $c6, $d2, $dc, $d2, $dc, $d2, $dc, $dc, $d3, $d6, $5c, $01
    .byte $d5, $c4, $c5, $c4, $d0, $c4, $c5, $c0, $c1, $c4, $c5, $c8, $c9, $cc, $cd, $d8
    .byte $d9, $c4, $c5, $c0, $c1, $d0, $d0, $d3, $d0, $d3, $d0, $d7, $20, $d4, $c7, $c6
    .byte $c7, $d3, $c7, $c6, $c7, $c2, $c3, $c6, $c7, $ca, $cb, $ce, $cf, $da, $db, $c6
    .byte $c7, $c2, $c3, $d3, $d2, $dc, $d2, $dc, $d2, $d3, $d6, $60, $c6, $c7, $c2, $c3
    .byte $d3, $c7, $c6, $c7, $c2, $c3, $c6, $c7, $ca, $a8, $a8, $a8, $a8, $db, $c6, $c7
    .byte $c2, $c3, $d3, $d2, $dc, $d2, $c2, $c3, $d3, $d2, $d3, $c7, $00, $c4, $c5, $c0
    .byte $c1, $d0, $c5, $c4, $c5, $c0, $c1, $c4, $c5, $c8, $a8, $a8, $a8, $a8, $d9, $c4
    .byte $c5, $c0, $c1, $d0, $d0, $d3, $d0, $c0, $c1, $d0, $d0, $d7, $c5, $7f, $c0, $20
    .byte $80, $80, $20, $30, $40, $20, $03, $08, $20, $10, $20, $10, $20, $10, $68, $20
    .byte $10, $40, $20, $18, $10, $20, $20, $18, $80, $18, $20, $20, $20, $20, $03, $20
    .byte $00, $00, $40, $00, $02, $01, $80, $09, $00, $09, $89, $01, $80, $01, $80, $01
    .byte $84, $01, $00, $80, $01, $04, $86, $00, $02, $00, $02, $80, $0a, $80, $0a, $00
    .byte $0a, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $04, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $fe, $20, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $88, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ef, $02, $ff
    .byte $01, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $87, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $e3, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $91, $91, $92
    .byte $93, $95, $95, $96, $97, $41, $41, $42, $43, $84, $85, $86, $87, $3c, $3d, $3e
    .byte $3f, $59, $59, $5a, $5b, $2f, $8d, $8e, $8f, $45, $45, $46, $47, $72, $71, $72
    .byte $73, $62, $65, $66, $67, $37, $80, $36, $82, $6d, $6d, $6e, $6f, $73, $71, $72
    .byte $73, $61, $65, $66, $67, $2d, $99, $9a, $9b, $9f, $9d, $9e, $9f, $2c, $2d, $2e
    .byte $2f, $64, $b5, $4e, $4f, $4c, $4d, $4e, $4f, $7a, $79, $7a, $7b, $7d, $7d, $7e
    .byte $7f, $62, $65, $66, $67, $61, $65, $66, $67, $2d, $99, $9a, $9b, $9f, $9d, $9e
    .byte $9f, $4d, $4d, $4e, $4f, $2e, $8d, $8e, $8f, $6e, $6d, $6e, $6f, $53, $51, $52
    .byte $53, $57, $55, $56, $57, $5f, $5d, $5e, $5f, $77, $75, $76, $77, $68, $69, $6a
    .byte $6b, $8b, $89, $8a, $8b, $af, $ad, $ae, $af, $45, $45, $46, $47, $45, $45, $46
    .byte $47, $34, $35, $36, $37, $34, $80, $36, $82, $32, $31, $32, $33, $37, $35, $36
    .byte $37, $37, $80, $36, $82, $31, $31, $32, $33, $3b, $39, $3a, $3b, $3b, $81, $3a
    .byte $83, $33, $31, $32, $33, $ab, $a9, $49, $4b, $21, $21, $1a, $23, $11, $13, $19
    .byte $8c, $8b, $89, $8a, $8b, $17, $1d, $1e, $1f, $61, $61, $62, $63, $49, $45, $4a
    .byte $47, $ae, $ad, $ae, $af, $b9, $b9, $ba, $bb, $bd, $bd, $be, $bf, $b8, $b9, $ba
    .byte $bb, $b9, $b9, $ba, $bb, $2a, $d1, $ba, $d1, $2a, $d1, $fa, $d1, $1a, $d2, $3a
    .byte $d2, $7a, $d2, $8a, $d2, $0a, $d3, $3a, $d3, $5a, $d3, $5a, $d3, $6a, $d3, $aa
    .byte $d3, $6a, $d3, $aa, $d3, $6a, $d3, $aa, $d3, $6a, $d3, $aa, $d3, $ea, $d3, $ea
    .byte $d3, $ea, $d3, $5a, $d4, $5a, $d4, $5a, $d4, $ca, $d4, $ca, $d4, $3a, $d5, $3a
    .byte $d5, $aa, $d5, $aa, $d5, $1a, $d6, $10, $80, $ac, $d6, $10, $80, $b5, $d6, $10
    .byte $80, $ac, $d6, $10, $80, $b5, $d6, $10, $80, $9a, $d6, $10, $80, $9d, $d6, $10
    .byte $80, $ac, $d6, $10, $80, $b5, $d6, $10, $80, $9a, $d6, $10, $80, $9d, $d6, $10
    .byte $80, $9a, $d6, $10, $80, $9d, $d6, $10, $80, $a0, $d6, $10, $80, $a3, $d6, $10
    .byte $80, $a0, $d6, $10, $80, $a3, $d6, $32, $0c, $a6, $d6, $32, $0c, $af, $d6, $10
    .byte $80, $a6, $d6, $10, $80, $af, $d6, $43, $06, $b8, $d6, $43, $06, $c4, $d6, $10
    .byte $40, $a0, $d6, $10, $40, $a3, $d6, $10, $40, $be, $d6, $10, $40, $ca, $d6, $10
    .byte $40, $a0, $d6, $10, $40, $a3, $d6, $32, $0a, $d0, $d6, $32, $0a, $d9, $d6, $32
    .byte $0a, $e2, $d6, $32, $0a, $eb, $d6, $10, $40, $f4, $d6, $10, $40, $f7, $d6, $10
    .byte $40, $fa, $d6, $10, $40, $fa, $d6, $43, $0a, $fd, $d6, $32, $0a, $09, $d7, $21
    .byte $0c, $12, $d7, $21, $0c, $18, $d7, $21, $0c, $1e, $d7, $21, $0c, $24, $d7, $21
    .byte $0c, $2a, $d7, $21, $0c, $30, $d7, $21, $0c, $36, $d7, $10, $40, $09, $d7, $76
    .byte $08, $3c, $d7, $76, $08, $51, $d7, $54, $0c, $66, $d7, $21, $0a, $e7, $d7, $10
    .byte $40, $a0, $d6, $10, $40, $a3, $d6, $21, $08, $75, $d7, $21, $08, $7b, $d7, $21
    .byte $08, $81, $d7, $21, $08, $87, $d7, $10, $40, $1a, $d8, $10, $40, $1a, $d8, $10
    .byte $40, $1a, $d8, $10, $40, $1a, $d8, $21, $08, $8d, $d7, $21, $08, $93, $d7, $21
    .byte $08, $99, $d7, $21, $08, $9f, $d7, $10, $40, $1a, $d8, $10, $40, $1a, $d8, $10
    .byte $40, $1a, $d8, $10, $40, $1a, $d8, $76, $0c, $a5, $d7, $76, $0c, $a5, $d7, $10
    .byte $40, $ba, $d7, $10, $40, $bd, $d7, $10, $40, $c0, $d7, $10, $40, $c3, $d7, $10
    .byte $40, $c6, $d7, $10, $40, $c6, $d7, $10, $40, $c9, $d7, $10, $40, $cc, $d7, $10
    .byte $40, $cf, $d7, $10, $40, $d2, $d7, $10, $40, $d5, $d7, $10, $40, $d8, $d7, $10
    .byte $40, $db, $d7, $10, $40, $de, $d7, $10, $40, $e1, $d7, $10, $40, $e1, $d7, $10
    .byte $40, $e4, $d7, $10, $40, $e4, $d7, $21, $0a, $e7, $d7, $21, $0a, $e7, $d7, $21
    .byte $0a, $e7, $d7, $21, $0a, $e7, $d7, $21, $09, $fa, $d2, $21, $09, $02, $d3, $21
    .byte $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $02, $d3, $21
    .byte $09, $fa, $d2, $21, $09, $fa, $d2, $32, $0e, $ed, $d7, $43, $08, $f6, $d7, $32
    .byte $0c, $ed, $d7, $32, $0c, $ed, $d7, $21, $09, $fa, $d2, $21, $09, $02, $d3, $21
    .byte $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $02, $d3, $21
    .byte $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $fa, $d2, $21, $09, $02, $d3, $21
    .byte $09, $fa, $d2, $21, $09, $fa, $d2, $02, $d8, $0e, $d8, $02, $d8, $0e, $d8, $08
    .byte $d8, $14, $d8, $08, $d8, $14, $d8, $21, $08, $1a, $d8, $21, $08, $1a, $d8, $21
    .byte $08, $1a, $d8, $21, $08, $1a, $d8, $32, $0a, $09, $d7, $32, $0a, $09, $d7, $32
    .byte $0a, $09, $d7, $32, $0a, $09, $d7, $21, $08, $20, $d8, $21, $08, $26, $d8, $21
    .byte $08, $2c, $d8, $21, $08, $32, $d8, $10, $40, $3b, $d8, $10, $40, $41, $d8, $10
    .byte $40, $47, $d8, $10, $40, $4d, $d8, $21, $08, $38, $d8, $21, $08, $3e, $d8, $21
    .byte $08, $44, $d8, $21, $08, $4a, $d8, $43, $08, $50, $d8, $43, $08, $50, $d8, $43
    .byte $08, $50, $d8, $43, $08, $50, $d8, $21, $08, $5c, $d8, $21, $08, $62, $d8, $10
    .byte $08, $68, $d8, $10, $08, $6b, $d8, $10, $0a, $71, $d8, $10, $0a, $77, $d8, $21
    .byte $14, $6e, $d8, $21, $14, $74, $d8, $10, $14, $71, $d8, $10, $14, $77, $d8, $10
    .byte $14, $6e, $d8, $10, $14, $74, $d8, $21, $08, $5c, $d8, $21, $08, $62, $d8, $10
    .byte $08, $68, $d8, $10, $08, $6b, $d8, $21, $0c, $7a, $d8, $21, $0c, $7a, $d8, $21
    .byte $0c, $80, $d8, $21, $0c, $80, $d8, $21, $0a, $86, $d8, $21, $0a, $86, $d8, $21
    .byte $0a, $8c, $d8, $21, $0a, $8c, $d8, $10, $14, $92, $d8, $10, $14, $92, $d8, $10
    .byte $14, $95, $d8, $10, $14, $95, $d8, $21, $0c, $7a, $d8, $21, $0c, $7a, $d8, $21
    .byte $0c, $80, $d8, $21, $0c, $80, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $10, $40, $a1, $d8, $10, $40, $a4, $d8, $43
    .byte $06, $b8, $d6, $10, $40, $9b, $d8, $21, $08, $7a, $d8, $21, $0c, $5c, $d8, $43
    .byte $14, $a7, $d8, $21, $14, $c2, $d8, $43, $0c, $f5, $d8, $32, $10, $19, $d9, $43
    .byte $18, $61, $d9, $42, $08, $50, $d8, $43, $14, $a7, $d8, $43, $14, $a7, $d8, $43
    .byte $14, $a7, $d8, $43, $14, $a7, $d8, $43, $14, $a7, $d8, $43, $14, $a7, $d8, $43
    .byte $14, $a7, $d8, $43, $14, $a7, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $10, $40, $b3, $d8, $10, $40, $b9, $d8, $10
    .byte $40, $b3, $d8, $10, $40, $b9, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $21, $08, $b3, $d8, $21, $08, $b9, $d8, $10
    .byte $40, $b3, $d8, $10, $40, $b9, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $21, $14, $c2, $d8, $21, $14, $cb, $d8, $21
    .byte $14, $c2, $d8, $21, $14, $cb, $d8, $21, $08, $bf, $d8, $21, $08, $c8, $d8, $21
    .byte $08, $bf, $d8, $21, $08, $c8, $d8, $21, $08, $f5, $d8, $21, $08, $01, $d9, $21
    .byte $08, $f5, $d8, $21, $08, $01, $d9, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $21, $08, $f5, $d8, $21, $08, $01, $d9, $21
    .byte $08, $f5, $d8, $21, $08, $01, $d9, $65, $08, $d1, $d8, $65, $08, $e3, $d8, $10
    .byte $40, $d1, $d8, $10, $40, $e3, $d8, $21, $08, $f5, $d8, $21, $08, $01, $d9, $21
    .byte $08, $f5, $d8, $21, $08, $01, $d9, $43, $0c, $f5, $d8, $43, $0c, $01, $d9, $10
    .byte $40, $f5, $d8, $10, $40, $01, $d9, $21, $08, $0d, $d9, $21, $08, $13, $d9, $21
    .byte $08, $0d, $d9, $21, $08, $13, $d9, $32, $0c, $1f, $d9, $32, $0c, $2e, $d9, $10
    .byte $08, $1f, $d9, $10, $08, $2e, $d9, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $43, $08, $19, $d9, $43, $08, $28, $d9, $10
    .byte $40, $19, $d9, $10, $40, $28, $d9, $32, $10, $37, $d9, $32, $10, $40, $d9, $10
    .byte $40, $37, $d9, $10, $40, $40, $d9, $21, $08, $49, $d9, $21, $08, $4f, $d9, $21
    .byte $08, $49, $d9, $21, $08, $4f, $d9, $21, $08, $55, $d9, $21, $08, $5b, $d9, $10
    .byte $40, $55, $d9, $10, $40, $5b, $d9, $32, $0c, $98, $d8, $32, $0c, $98, $d8, $32
    .byte $0c, $98, $d8, $32, $0c, $98, $d8, $43, $18, $61, $d9, $43, $18, $6d, $d9, $10
    .byte $40, $55, $d9, $10, $40, $5b, $d9, $43, $18, $61, $d9, $43, $18, $6d, $d9, $10
    .byte $40, $55, $d9, $10, $40, $5b, $d9, $43, $18, $61, $d9, $43, $18, $6d, $d9, $10
    .byte $40, $55, $d9, $10, $40, $5b, $d9, $43, $18, $61, $d9, $43, $18, $6d, $d9, $10
    .byte $40, $55, $d9, $10, $40, $5b, $d9, $21, $08, $79, $d9, $21, $08, $7f, $d9, $21
    .byte $08, $79, $d9, $21, $08, $7f, $d9, $65, $10, $85, $d9, $65, $10, $85, $d9, $65
    .byte $10, $85, $d9, $65, $10, $85, $d9, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54
    .byte $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54
    .byte $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54
    .byte $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $92, $d6, $54, $05, $92, $d6, $54
    .byte $05, $92, $d6, $54, $05, $92, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54
    .byte $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54, $05, $8a, $d6, $54
    .byte $05, $8a, $d6, $54, $05, $8a, $d6, $b5, $d9, $c4, $d9, $b5, $d9, $c4, $d9, $97
    .byte $d9, $a6, $d9, $97, $d9, $a6, $d9, $0a, $e2, $12, $e2, $0a, $00, $02, $00, $12
    .byte $00, $02, $00, $22, $20, $12, $2a, $28, $12, $26, $24, $12, $20, $22, $00, $28
    .byte $2a, $00, $24, $26, $00, $12, $10, $12, $0e, $0c, $12, $0a, $08, $12, $06, $04
    .byte $12, $10, $12, $00, $0c, $0e, $00, $08, $0a, $00, $04, $06, $00, $16, $18, $12
    .byte $16, $18, $12, $16, $14, $12, $18, $16, $00, $18, $16, $00, $14, $16, $00, $1e
    .byte $1a, $12, $1e, $1a, $12, $1e, $1c, $12, $1a, $1e, $00, $1a, $1e, $00, $1c, $1e
    .byte $00, $be, $bc, $12, $bc, $be, $00, $9e, $9e, $86, $ae, $ae, $86, $ae, $ae, $86
    .byte $b2, $b2, $cf, $b0, $b0, $ce, $b6, $b6, $87, $b2, $b2, $cf, $b0, $b0, $ce, $de
    .byte $9e, $86, $de, $ae, $86, $9e, $de, $86, $ae, $de, $86, $9e, $de, $86, $8c, $de
    .byte $86, $de, $9e, $86, $de, $8c, $86, $b4, $b4, $86, $8c, $8c, $86, $b4, $b4, $86
    .byte $8c, $8c, $86, $b6, $b6, $86, $ae, $ae, $86, $82, $7e, $b7, $82, $7e, $96, $82
    .byte $80, $b7, $82, $7e, $96, $82, $80, $96, $82, $7e, $b7, $82, $7e, $96, $7e, $82
    .byte $a5, $7e, $82, $84, $80, $82, $a5, $7e, $82, $84, $80, $82, $84, $7e, $82, $a5
    .byte $7e, $82, $84, $b6, $b6, $4b, $ba, $ba, $6a, $b8, $b8, $6a, $ba, $ba, $4b, $b8
    .byte $b8, $4b, $86, $84, $96, $86, $84, $b7, $84, $86, $a5, $84, $86, $84, $8a, $88
    .byte $96, $88, $8a, $84, $88, $8a, $a5, $8a, $88, $b7, $86, $84, $7b, $86, $84, $96
    .byte $84, $86, $69, $84, $86, $84, $8a, $88, $5a, $88, $8a, $84, $8a, $88, $7b, $88
    .byte $8a, $a5, $d6, $d4, $de, $d4, $d6, $cc, $d6, $d4, $de, $d4, $d6, $cc, $d6, $d4
    .byte $de, $a6, $a6, $ce, $8c, $8c, $8f, $ea, $ea, $ce, $e4, $e6, $84, $e8, $e8, $86
    .byte $e0, $e0, $86, $ec, $ee, $84, $a8, $aa, $48, $ac, $aa, $48, $c4, $c6, $48, $a8
    .byte $aa, $84, $ac, $aa, $84, $c4, $c6, $84, $a8, $aa, $00, $ac, $aa, $00, $fc, $fc
    .byte $ce, $fe, $fe, $ce, $b2, $b2, $cf, $b0, $b0, $ce, $9e, $9e, $86, $9e, $9e, $86
    .byte $8c, $8c, $87, $f0, $f2, $84, $f0, $f2, $cc, $f0, $f2, $84, $f0, $f2, $00, $ce
    .byte $cc, $12, $ca, $c8, $12, $cc, $ce, $00, $c8, $ca, $00, $ce, $da, $de, $ca, $d8
    .byte $de, $da, $ce, $cc, $d8, $ca, $cc, $8c, $8c, $a7, $8c, $8c, $86, $8e, $8c, $96
    .byte $8e, $8c, $b7, $8c, $8e, $84, $8c, $8e, $a5, $90, $92, $84, $92, $90, $96, $90
    .byte $92, $a5, $92, $90, $b7, $42, $40, $96, $42, $40, $5a, $40, $42, $84, $40, $42
    .byte $48, $44, $46, $84, $44, $46, $48, $44, $46, $a5, $44, $46, $69, $3c, $3e, $21
    .byte $3e, $3c, $de, $3e, $3c, $b7, $3c, $3e, $cc, $9c, $94, $5a, $96, $94, $5a, $94
    .byte $9c, $48, $94, $96, $48, $9a, $98, $5a, $98, $9a, $48, $9a, $a4, $5a, $a2, $a0
    .byte $5a, $a4, $9a, $48, $a0, $a2, $48, $7c, $74, $5a, $76, $74, $5a, $74, $7c, $48
    .byte $74, $76, $48, $7a, $78, $5a, $76, $74, $5a, $78, $7a, $48, $74, $76, $48, $dc
    .byte $78, $5a, $78, $dc, $48, $b6, $b6, $4b, $ba, $ba, $4b, $b8, $b8, $4b, $fc, $fe
    .byte $48, $f8, $fa, $48, $30, $32, $cc, $2e, $2e, $ce, $32, $30, $de, $2c, $2c, $ce
    .byte $36, $34, $96, $36, $34, $12, $34, $36, $84, $34, $36, $00, $c2, $34, $96, $36
    .byte $34, $96, $3a, $38, $96, $34, $c2, $84, $34, $36, $84, $38, $3a, $84, $4e, $c0
    .byte $de, $4e, $4c, $12, $4e, $4c, $de, $4e, $4c, $12, $4e, $4c, $de, $4e, $4c, $12
    .byte $c0, $4e, $cc, $4c, $4e, $00, $4c, $4e, $cc, $4c, $4e, $00, $4c, $4e, $cc, $4c
    .byte $4e, $00, $4e, $4c, $de, $52, $50, $de, $4e, $4c, $de, $4a, $48, $de, $4c, $4e
    .byte $cc, $50, $52, $cc, $4c, $4e, $cc, $48, $4a, $cc, $52, $50, $ff, $4a, $48, $ff
    .byte $50, $52, $ed, $48, $4a, $ed, $5e, $5c, $de, $5a, $58, $de, $66, $64, $de, $62
    .byte $60, $de, $5e, $5c, $de, $5c, $5e, $cc, $58, $5a, $cc, $64, $66, $cc, $60, $62
    .byte $cc, $5c, $5e, $cc, $5e, $5c, $de, $5a, $58, $de, $56, $54, $de, $5c, $5e, $cc
    .byte $58, $5a, $cc, $54, $56, $cc, $5e, $5c, $ff, $5a, $58, $ff, $5c, $5e, $ed, $58
    .byte $5a, $ed, $6e, $6c, $5a, $6e, $6c, $96, $6c, $6e, $48, $6c, $6e, $84, $6e, $6c
    .byte $5a, $6a, $68, $5a, $6e, $6c, $5a, $72, $70, $5a, $6c, $6e, $48, $68, $6a, $48
    .byte $6c, $6e, $48, $70, $72, $48, $6a, $68, $7b, $6e, $6c, $7b, $68, $6a, $69, $6c
    .byte $6e, $69, $a6, $a6, $4a, $d4, $d6, $48, $a6, $a6, $4a, $d6, $d4, $de, $a6, $a6
    .byte $86, $d4, $d6, $cc, $d2, $d0, $96, $d2, $d0, $de, $d2, $d0, $5a, $d0, $d2, $cc
    .byte $d0, $d2, $84, $fa, $f8, $de, $d2, $d0, $5a, $fa, $f8, $de, $d0, $d2, $48, $f8
    .byte $fa, $cc, $d6, $d4, $de, $d6, $d4, $96, $d4, $d6, $48, $d4, $d6, $cc, $d4, $d6
    .byte $84, $f6, $f4, $de, $d4, $d6, $48, $f6, $f4, $de, $f4, $f6, $cc, $d6, $d4, $5a
    .byte $15, $da, $d9, $da, $15, $da, $d9, $da, $d9, $da, $51, $da, $75, $da, $55, $da
    .byte $69, $da, $7d, $db, $6d, $da, $6d, $da, $79, $da, $89, $da, $99, $da, $a9, $da
    .byte $79, $da, $89, $da, $99, $da, $a9, $da, $35, $da, $b9, $da, $d5, $da, $35, $da
    .byte $b9, $da, $f1, $da, $0d, $db, $35, $da, $29, $db, $45, $db, $61, $db, $35, $da
    .byte $7d, $db, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $02, $02
    .byte $02, $02, $04, $05, $03, $03, $06, $07, $03, $03, $08, $09, $01, $01, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $17, $18, $00, $00, $03, $03, $03, $03, $02, $0e
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0e
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0a, $0b
    .byte $0c, $0d, $0e, $0e, $0e, $0e, $10, $10, $0f, $0f, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $10, $10, $0f, $0f, $11, $11, $12, $12, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $11, $11, $12, $12, $14, $14, $13, $13, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $14, $14, $13, $13, $15, $15, $16, $16, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $15, $15, $16, $16, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1f, $20, $00, $00, $03, $03
    .byte $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $19, $1a, $00, $00, $03, $03, $03, $03, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $21, $22, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1b, $1c
    .byte $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $17, $18, $00, $00, $1b, $1c, $00, $00, $03, $03
    .byte $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $1d, $1e, $00, $00, $17, $18, $00, $00, $03, $03, $03, $03, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $1b, $1c, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03
    .byte $03, $03, $03, $03, $03, $03, $00, $00, $40, $00, $c3, $00, $80, $00, $80, $10
    .byte $80, $70, $80, $18, $80, $68, $40, $18, $40, $68, $00, $30, $00, $41, $41, $00
    .byte $30, $00, $40, $40, $1c, $00, $64, $00, $00, $1c, $00, $64, $2e, $00, $52, $00
    .byte $00, $27, $00, $52, $80, $13, $80, $6d, $80, $2b, $80, $55, $80, $0c, $80, $74
    .byte $80, $26, $80, $5a, $80, $1c, $80, $64, $80, $27, $80, $52, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

; DEMON MIRROR SPAWN RATE TABLE
; 16 pointers to demon mirror spawn rate data, e.g., rate 1 = $dc42, rate 16 = $dcba
; low bytes
    .byte $42, $4a, $52
    .byte $5a, $62, $6a, $72, $7a, $82, $8a, $92, $9a, $a2, $aa, $b2, $ba
; high bytes
    .byte $dc, $dc, $dc
    .byte $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc

; DEMON MIRROR ENEMY SETS TABLE
; 17 pointers to demon mirror enemy sets data, e.g., set 1 = $dcc2, set 17 = $dcea
; low bytes
    .byte $c2, $c4, $c6
    .byte $c8, $cb, $ce, $d0, $d4, $d8, $da, $dc, $de, $e0, $e2, $e4, $e6, $ea
; high bytes
    .byte $dc, $dc
    .byte $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc, $dc

; DEMON MIRROR SPAWN RATE DATA
; 16 elements, each 8 bytes long
; Each associated with one of the 17 enemy sets
; First 4 bytes define level start schedule
; Second 4 bytes define looping schedule
; Bytes are bitmasks, bit set means an enemy spawns at that time
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $88, $88, $88, $88, $88, $88, $88, $88
    .byte $84, $21, $08, $42, $08, $42, $10, $84
    .byte $00, $44, $44, $44, $44, $44, $44, $44
    .byte $92, $49, $24, $92, $24, $92, $49, $24
    .byte $22, $22, $22, $22, $22, $22, $22, $22
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $f5, $52, $49, $f5, $49, $f5, $52, $49
    .byte $05, $55, $55, $55, $55, $55, $55, $55
    .byte $00, $00, $00, $00, $00, $00, $00, $01
    .byte $80, $80, $80, $80, $80, $80, $80, $80
    .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
    .byte $44, $44, $44, $44, $44, $44, $44, $44
    .byte $00, $01, $00, $00, $00, $00, $00, $00
    .byte $00, $11, $11, $11, $11, $11, $11, $11
    .byte $00, $22, $22, $22, $22, $22, $22, $22

; DEMON MIRROR ENEMY SETS DATA
; Mirrors in a level are associated with one of these 17 sets
; Bytes are ENEMY TYPES, followed by a delimiter, 0x90
    .byte $78, $90
    .byte $50, $90
    .byte $51, $90
    .byte $50, $51, $90
    .byte $51, $50, $90
    .byte $5c, $90
    .byte $50, $51, $5c, $90
    .byte $51, $50, $5c, $90
    .byte $58, $90
    .byte $54, $90
    .byte $55, $90
    .byte $60, $90
    .byte $59, $90
    .byte $64, $90
    .byte $70, $90
    .byte $54, $55, $60, $90
    .byte $59, $90

; ENEMY DATA TABLE
; pointers to each level's enemy data, e.g., level 1 = $dd56, level 53 = $e02a
; low bytes
    .byte $56, $5a, $5c, $70, $84, $96, $a6
    .byte $c2, $d0, $d8, $e4, $f6, $f8, $0c, $10, $14, $28, $44, $52, $5a, $5c, $70, $7a
    .byte $8c, $a4, $a6, $a8, $b2, $c2, $ce, $d0, $e0, $ee, $06, $0c, $24, $2e, $3a, $4c
    .byte $5e, $70, $76, $88, $96, $ac, $ba, $cc, $de, $f8, $00, $1c, $28, $2a
; high bytes
    .byte $dd, $dd
    .byte $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $dd, $de, $de, $de, $de, $de
    .byte $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $de, $df
    .byte $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $df, $e0
    .byte $e0, $e0, $e0

; ENEMY DATA
; For each level:
; first byte: Demonhead/Saramander lifetime
; then pairs of bytes: enemy ID, enemy tile position (yx)
; then delimiter: 0x00
; Level 1
    .byte $20, $71, $67, $00
; Level 2
    .byte $02, $00
; Level 3
    .byte $82, $24, $31, $29, $3c, $2a, $4b
    .byte $2a, $b7, $36, $9b, $70, $b2, $78, $91, $68, $85, $69, $88, $00
; Level 4
    .byte $82, $69, $3d
    .byte $68, $31, $2b, $37, $2b, $55, $2b, $59, $2b, $94, $2b, $94, $2b, $77, $2b, $9a
    .byte $00
; Level 5
    .byte $82, $79, $4e, $79, $6e, $79, $8e, $79, $ae, $78, $30, $78, $50, $78, $70
    .byte $78, $90, $00
; Level 6
    .byte $82, $36, $5b, $36, $5e, $34, $70, $34, $73, $36, $9b, $36, $9e
    .byte $74, $c2, $00
; Level 7
    .byte $82, $78, $27, $2b, $24, $2b, $2a, $2b, $44, $2b, $4a, $2b, $84
    .byte $2b, $8a, $2a, $44, $2a, $4a, $2a, $84, $2a, $8a, $2a, $a4, $2a, $aa, $00
; Level 8
    .byte $82
    .byte $42, $17, $40, $b7, $44, $60, $44, $80, $46, $6e, $46, $8e, $00
; Level 9
    .byte $41, $78, $52
    .byte $79, $5c, $81, $a7, $00
; Level 10
    .byte $c0, $7d, $3d, $24, $50, $81, $6d, $74, $c2, $74, $c6
    .byte $00
; Level 11
    .byte $82, $26, $c2, $27, $11, $2e, $87, $2e, $99, $2e, $14, $2f, $75, $2f, $87
    .byte $2b, $a3, $00
; Level 12
    .byte $82, $00
; Level 13
    .byte $01, $3c, $37, $70, $71, $71, $7d, $28, $9d, $29, $9d
    .byte $2a, $9d, $2c, $ad, $2d, $ad, $2f, $ad, $00
; Level 14
    .byte $81, $48, $c7, $00
; Level 15
    .byte $82, $46, $2e
    .byte $00
; Level 16
    .byte $01, $80, $23, $80, $2b, $80, $81, $80, $8d, $3e, $75, $3c, $79, $71, $c5
    .byte $70, $c9, $2b, $97, $00
; Level 17
    .byte $82, $81, $6a, $81, $6c, $2b, $87, $2b, $89, $2b, $8b
    .byte $2b, $8d, $2b, $a6, $2b, $a8, $2b, $aa, $2b, $ac, $74, $c0, $74, $c5, $74, $cd
    .byte $00
; Level 18
    .byte $41, $78, $43, $81, $1a, $81, $38, $81, $56, $81, $74, $81, $92, $00
; Level 19
    .byte $82
    .byte $68, $4b, $2b, $6c, $2a, $aa, $00
; Level 20
    .byte $82, $00
; Level 21
    .byte $82, $81, $4b, $81, $4c, $81, $6a
    .byte $81, $76, $81, $77, $81, $78, $81, $79, $79, $80, $42, $19, $00
; Level 22
    .byte $82, $81, $99
    .byte $81, $9a, $81, $9c, $81, $9d, $00
; Level 23
    .byte $82, $36, $4b, $36, $4d, $34, $6b, $34, $6d
    .byte $36, $8b, $36, $8d, $81, $c9, $75, $ce, $00
; Level 24
    .byte $82, $69, $7b, $81, $16, $81, $47
    .byte $81, $78, $81, $aa, $79, $29, $2a, $81, $2a, $97, $2b, $85, $2b, $a5, $2b, $cd
    .byte $00
; Level 25
    .byte $c1, $00
; Level 26
    .byte $81, $00
; Level 27
    .byte $82, $2e, $66, $2e, $88, $2e, $a6, $2e, $c8, $00
; Level 28
    .byte $82
    .byte $81, $65, $81, $69, $81, $81, $81, $8d, $2b, $67, $46, $23, $46, $2b, $00
; Level 29
    .byte $c1
    .byte $7d, $97, $4d, $5e, $4d, $7e, $74, $c1, $75, $cd, $00
; Level 30
    .byte $02, $00
; Level 31
    .byte $c1, $81, $27
    .byte $81, $47, $81, $67, $81, $72, $81, $7c, $81, $96, $81, $98, $00  ; DED3
; Level 32
    .byte $01, $36, $36
    .byte $78, $51, $79, $5d, $81, $a3, $81, $a7, $81, $ab, $00
; Level 33
    .byte $82, $34, $33, $36, $27
    .byte $36, $3b, $2e, $71, $2e, $73, $2e, $a1, $2e, $a3, $2f, $61, $2f, $63, $2f, $91
    .byte $2f, $93, $00
; Level 34
    .byte $41, $44, $70, $46, $7e, $00
; Level 35
    .byte $02, $81, $53, $81, $55, $81, $59
    .byte $81, $5b, $81, $91, $81, $9d, $78, $11, $79, $1d, $46, $57, $46, $77, $46, $97
    .byte $00
; Level 36
    .byte $82, $75, $27, $74, $57, $75, $87, $25, $be, $00
; Level 37
    .byte $82, $24, $40, $24, $50
    .byte $24, $60, $24, $70, $24, $80, $00
; Level 38
    .byte $82, $81, $33, $81, $3b, $81, $74, $81, $7a
    .byte $81, $86, $81, $88, $46, $67, $36, $a7, $00
; Level 39
    .byte $42, $28, $27, $28, $6d, $29, $60
    .byte $29, $b7, $30, $6c, $32, $51, $34, $37, $36, $a7, $00
; Level 40
    .byte $82, $26, $a2, $26, $ac
    .byte $26, $b5, $26, $b9, $27, $24, $27, $2a, $2d, $6e, $79, $77, $00
; Level 41
    .byte $82, $44, $51
    .byte $46, $5d, $00
; Level 42
    .byte $82, $68, $c7, $36, $77, $81, $16, $81, $18, $80, $45, $80, $49
    .byte $81, $94, $81, $9a, $00
; Level 43
    .byte $82, $44, $41, $44, $71, $44, $a1, $46, $4d, $46, $7d
    .byte $46, $ad, $00
; Level 44
    .byte $82, $80, $1b, $80, $5a, $81, $11, $81, $34, $81, $42, $81, $4d
    .byte $81, $70, $81, $76, $81, $95, $81, $98, $00
; Level 45
    .byte $e1, $81, $62, $81, $6c, $81, $a2
    .byte $81, $ac, $79, $a6, $78, $a8, $00
; Level 46
    .byte $41, $70, $5a, $70, $16, $70, $38, $70, $7c
    .byte $70, $42, $70, $64, $70, $86, $70, $a8, $00
; Level 47
    .byte $42, $81, $1a, $81, $1e, $81, $55
    .byte $81, $7b, $81, $7e, $81, $9e, $81, $b0, $81, $ca, $00
; Level 48
    .byte $82, $81, $12, $81, $14
    .byte $81, $1b, $81, $1d, $81, $1e, $81, $5a, $81, $65, $81, $67, $81, $83, $81, $88
    .byte $81, $8b, $81, $8e, $00
; Level 49
    .byte $82, $80, $ad, $1d, $67, $80, $a1, $00
; Level 50
    .byte $82, $80, $21
    .byte $81, $2d, $68, $38, $79, $97, $75, $73, $26, $b1, $27, $4d, $29, $a6, $29, $aa
    .byte $2a, $b7, $36, $36, $30, $a3, $32, $ab, $00
; Level 51
    .byte $82, $74, $57, $6d, $77, $1c, $43
    .byte $1c, $4b, $1c, $b7, $00
; Level 52
    .byte $82, $00
; Level 53
    .byte $82, $00

; BLOCK DATA
; Each level's block data is 48 bytes long
; The first 24 bytes define the brown blocks, the second 24 bytes define the white blocks
; Block data is read starting at the top row, moving left to right, then to the next row, etc
; 2 bytes per level row
; Each bit in a byte defines the presence or absence of a block in the corresponding column
; e.g., If the first byte is 0xA5 (10100101), then blocks 1, 3, 6, and 8 will be brown on the top row (left)
; Level 1
    .byte $00, $00, $00, $00, $08, $20, $08
    .byte $20, $00, $00, $00, $80, $09, $20, $00, $00, $00, $10, $00, $00, $00, $00, $00
    .byte $00, $ff, $ff, $f8, $3f, $f0, $1f, $f0, $1f, $f8, $3f, $8e, $63, $80, $03, $8f
    .byte $e3, $fc, $6f, $e4, $4f, $f0, $1f, $ff, $ff
; Level 2
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $0c, $00, $30, $00, $c0, $00, $00, $07, $00, $1f, $c0, $60, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $60, $01, $18, $01, $06, $01, $00, $01, $00
    .byte $c1, $00, $31, $00, $0d, $00, $01, $00, $01
; Level 3
    .byte $00, $00, $03, $80, $01, $10, $00
    .byte $00, $00, $04, $00, $00, $78, $1b, $60, $04, $00, $00, $47, $c0, $02, $80, $00
    .byte $00, $83, $83, $80, $03, $82, $83, $83, $83, $ff, $fb, $f8, $3b, $80, $21, $98
    .byte $3b, $87, $c3, $80, $03, $84, $43, $ff, $c3
; Level 4
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $20, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $c1, $07, $00, $01, $04, $41, $00, $01, $f1
    .byte $1f, $00, $01, $00, $01, $00, $01, $00, $01
; Level 5
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $80, $01, $00, $03, $80, $01, $00, $03, $80
    .byte $01, $00, $03, $80, $01, $00, $03, $00, $01
; Level 6
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $ff, $e1, $00, $01, $0f, $ff, $00, $01, $ff
    .byte $e1, $00, $01, $0f, $ff, $00, $01, $00, $01
; Level 7
    .byte $00, $00, $00, $00, $3e, $f8, $41
    .byte $04, $49, $24, $55, $54, $49, $24, $41, $04, $3e, $f8, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $41, $05, $00, $01, $14, $51, $00, $01, $14, $51, $00
    .byte $01, $41, $05, $00, $01, $00, $01, $00, $01
; Level 8
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $02, $81, $00, $01, $02, $81, $00
    .byte $01, $02, $81, $00, $01, $00, $01, $01, $01
; Level 9
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $22, $89, $0e, $e1, $08
    .byte $21, $0e, $e1, $20, $09, $0c, $61, $00, $01
; Level 10
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $04, $44, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $0d, $7f, $00, $01, $0a, $a1, $f0, $11, $00
    .byte $01, $1f, $ff, $00, $01, $00, $01, $00, $01
; Level 11
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $38, $00, $00, $00, $00, $00, $00, $00, $00, $20, $10, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $3e, $01, $02, $01, $39, $81, $04
    .byte $41, $d3, $21, $01, $81, $00, $e1, $00, $21
; Level 12
    .byte $00, $00, $00, $00, $03, $00, $00
    .byte $00, $07, $a2, $00, $00, $0c, $00, $00, $00, $1e, $29, $00, $00, $20, $00, $00
    .byte $00, $00, $01, $00, $01, $54, $81, $00, $01, $08, $55, $00, $01, $52, $01, $00
    .byte $01, $21, $55, $00, $01, $50, $01, $00, $01
; Level 13
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $60, $0c, $a0, $0a, $a0, $0a, $e0, $0e, $a0
    .byte $0a, $00, $01, $00, $01, $00, $01, $04, $41, $04, $41, $08, $21, $08, $21, $90
    .byte $13, $10, $11, $10, $11, $10, $11, $10, $11
; Level 14
    .byte $00, $00, $00, $00, $ff, $fe, $ff
    .byte $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
    .byte $01, $00, $01, $00, $01, $00, $01, $00, $01
; Level 15
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $08, $00, $02, $00, $40, $00, $00, $00, $08, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $f0, $01, $02, $01, $37, $01, $00, $01, $b2, $01, $02
    .byte $01, $17, $81, $02, $01, $f2, $01, $02, $01
; Level 16
    .byte $00, $00, $00, $00, $10, $10, $0e
    .byte $e0, $00, $00, $00, $00, $00, $00, $00, $00, $40, $04, $00, $00, $00, $00, $02
    .byte $80, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $22, $89, $00
    .byte $01, $00, $01, $01, $01, $00, $01, $00, $01
; Level 17
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $28, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $11, $03, $c7, $0c
    .byte $01, $31, $55, $c0, $01, $02, $a9, $00, $03
; Level 18
    .byte $00, $00, $00, $20, $00, $0c, $00
    .byte $80, $00, $00, $02, $00, $00, $00, $08, $00, $00, $00, $e0, $00, $40, $00, $c0
    .byte $00, $00, $01, $00, $01, $00, $11, $00, $01, $30, $61, $00, $01, $01, $81, $00
    .byte $01, $06, $01, $00, $01, $18, $01, $00, $01
; Level 19
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $04, $99, $09, $21, $12, $49, $24
    .byte $91, $49, $21, $00, $01, $00, $01, $00, $01
; Level 20
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
    .byte $01, $00, $01, $00, $01, $00, $01, $00, $01
; Level 21
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $1c, $27, $03, $c0, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $f0, $19, $00, $41, $00, $19, $00
    .byte $11, $e0, $01, $00, $3f, $00, $41, $00, $01
; Level 22
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $38, $01, $c6, $01, $00, $01, $00, $01, $c5, $00, $3c, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $01, $c7, $00, $39, $00
    .byte $81, $00, $81, $00, $39, $01, $c1, $00, $01
; Level 23
    .byte $00, $00, $00, $00, $00, $00, $40
    .byte $00, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $78, $01, $48, $05, $08, $41, $68, $01, $00, $41, $00, $01, $04
    .byte $c1, $04, $81, $04, $8b, $04, $03, $04, $21
; Level 24
    .byte $00, $00, $02, $00, $00, $00, $00
    .byte $00, $01, $00, $14, $00, $04, $00, $0b, $0a, $04, $80, $2a, $00, $1e, $26, $ac
    .byte $0a, $00, $01, $00, $1f, $00, $e1, $04, $01, $04, $41, $00, $55, $4b, $01, $00
    .byte $f5, $0a, $01, $51, $09, $00, $89, $52, $01
; Level 25
    .byte $00, $00, $1c, $70, $00, $00, $e3
    .byte $8e, $00, $00, $18, $30, $00, $00, $c3, $86, $00, $00, $1c, $70, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $04, $41, $00, $01, $20
    .byte $09, $00, $01, $00, $01, $00, $01, $00, $01
; Level 26
    .byte $04, $40, $04, $40, $04, $40, $03
    .byte $80, $00, $00, $00, $00, $18, $30, $02, $80, $00, $00, $18, $30, $02, $80, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $04, $41, $00, $01, $00, $01, $24, $49, $01
    .byte $01, $00, $01, $24, $49, $01, $01, $00, $01
; Level 27
    .byte $00, $00, $00, $00, $00, $04, $00
    .byte $20, $41, $80, $08, $00, $03, $04, $00, $20, $41, $80, $08, $00, $03, $00, $00
    .byte $70, $00, $01, $00, $01, $00, $0b, $00, $51, $a2, $01, $14, $01, $00, $8b, $00
    .byte $51, $a2, $01, $14, $01, $00, $81, $00, $01
; Level 28
    .byte $00, $00, $00, $00, $a0, $0c, $02
    .byte $80, $5a, $2c, $00, $80, $ec, $56, $24, $48, $44, $46, $00, $00, $47, $c4, $00
    .byte $00, $00, $01, $00, $01, $5f, $f3, $20, $09, $a5, $d3, $22, $09, $12, $a9, $02
    .byte $81, $aa, $a9, $02, $81, $38, $39, $00, $01
; Level 29
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $40, $01, $00, $01, $40, $01, $00
    .byte $01, $00, $01, $07, $c1, $00, $01, $00, $01
; Level 30
    .byte $00, $00, $80, $02, $00, $00, $01
    .byte $00, $00, $00, $80, $02, $00, $00, $01, $00, $00, $00, $80, $02, $00, $00, $00
    .byte $00, $01, $01, $2a, $a9, $00, $01, $54, $55, $00, $01, $2a, $a9, $00, $01, $54
    .byte $55, $00, $01, $2a, $a9, $00, $01, $00, $01
; Level 31
    .byte $00, $00, $1a, $b0, $60, $0c, $38
    .byte $38, $44, $44, $12, $90, $4e, $e4, $20, $08, $44, $44, $9b, $b2, $e2, $8e, $00
    .byte $00, $01, $01, $44, $45, $11, $11, $44, $45, $11, $11, $44, $45, $11, $11, $44
    .byte $45, $11, $11, $44, $45, $11, $11, $00, $01
; Level 32
    .byte $00, $00, $00, $00, $01, $00, $00
    .byte $00, $00, $00, $40, $04, $40, $08, $00, $a0, $02, $80, $00, $20, $64, $7c, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $2a, $a9, $20, $05, $0a
    .byte $01, $48, $25, $08, $01, $1b, $81, $00, $01
; Level 33
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $f8, $00, $88, $00, $88, $00, $f8, $00, $88, $00, $88, $00, $f8, $00, $88
    .byte $00, $00, $01, $00, $01, $01, $01, $02, $01, $04, $01, $04, $01, $04, $01, $04
    .byte $01, $04, $01, $04, $01, $04, $01, $04, $01
; Level 34
    .byte $00, $00, $80, $02, $80, $02, $c1
    .byte $06, $e0, $0e, $f8, $3e, $3f, $f8, $f8, $3e, $e0, $0e, $c0, $06, $80, $02, $80
    .byte $02, $ff, $ff, $40, $05, $40, $05, $20, $09, $18, $31, $06, $c1, $00, $01, $06
    .byte $c1, $18, $31, $20, $09, $40, $05, $40, $05
; Level 35
    .byte $00, $00, $c8, $26, $42, $84, $10
    .byte $10, $40, $04, $5c, $74, $00, $00, $cc, $66, $10, $10, $50, $14, $07, $c0, $00
    .byte $00, $00, $01, $22, $89, $8c, $63, $22, $89, $08, $21, $22, $89, $88, $23, $22
    .byte $89, $08, $21, $22, $89, $88, $23, $00, $01
; Level 36
    .byte $00, $00, $00, $00, $00, $10, $00
    .byte $00, $00, $00, $10, $00, $00, $00, $00, $00, $00, $10, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $ff, $e1, $00, $01, $00, $01, $0f, $ff, $00, $01, $00
    .byte $01, $ff, $e1, $00, $01, $00, $01, $00, $01
; Level 37
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
    .byte $01, $00, $01, $00, $01, $00, $01, $00, $01
; Level 38
    .byte $00, $00, $c4, $4b, $00, $00, $56
    .byte $d6, $91, $10, $c6, $c6, $04, $40, $68, $26, $0e, $e0, $00, $00, $38, $3a, $00
    .byte $00, $00, $01, $3a, $b5, $02, $81, $a8, $29, $0a, $a3, $28, $29, $00, $01, $94
    .byte $59, $40, $05, $14, $51, $45, $45, $10, $11
; Level 39
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $ff, $ff, $00, $03, $00, $03, $1f, $e3, $1f, $e3, $1c, $63, $00, $63, $ff
    .byte $e3, $ff, $e3, $00, $03, $00, $03, $ff, $ff
; Level 40
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $08, $21, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $40, $01, $01
    .byte $01, $00, $01, $00, $01, $20, $09, $04, $41
; Level 41
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $0f, $e0, $07, $e0, $17, $d0, $18, $30, $10, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $10, $11, $10
    .byte $11, $00, $01, $05, $41, $3c, $79, $00, $01
; Level 42
    .byte $20, $08, $aa, $ac, $02, $80, $70
    .byte $1c, $08, $30, $6f, $e4, $00, $00, $6c, $6c, $00, $40, $6d, $6c, $de, $b6, $20
    .byte $08, $00, $01, $55, $53, $20, $09, $8a, $a3, $34, $49, $90, $1b, $24, $49, $92
    .byte $93, $24, $09, $92, $93, $21, $49, $00, $01
; Level 43
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $dd, $c1, $15, $51, $00, $01, $2a
    .byte $af, $00, $01, $00, $01, $00, $01, $00, $01
; Level 44
    .byte $00, $00, $53, $54, $44, $96, $48
    .byte $00, $a4, $94, $22, $24, $00, $40, $92, $04, $10, $00, $96, $a0, $14, $f0, $00
    .byte $00, $00, $01, $ac, $a9, $b2, $49, $01, $21, $52, $4b, $58, $99, $45, $01, $44
    .byte $d3, $20, $19, $09, $53, $2b, $09, $00, $01
; Level 45
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $2c, $a8, $64, $6c, $d3, $56, $08, $00, $e0, $0e, $00
    .byte $00, $00, $01, $00, $01, $00, $01, $00, $01, $aa, $ab, $00, $01, $52, $55, $19
    .byte $11, $24, $89, $00, $21, $1f, $f1, $00, $01
; Level 46
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $11, $03, $d1, $e0, $41, $01, $81, $38, $11, $00, $61, $0e, $05, $00
    .byte $19, $03, $81, $00, $01, $00, $e1, $00, $01
; Level 47
    .byte $bf, $dc, $b5, $e6, $22, $f0, $80
    .byte $8c, $49, $18, $37, $60, $51, $28, $a0, $56, $1d, $44, $16, $b6, $3c, $58, $08
    .byte $c4, $00, $01, $4a, $d9, $1a, $09, $4b, $53, $22, $47, $48, $9b, $2a, $c1, $1a
    .byte $29, $42, $81, $68, $49, $02, $81, $b6, $1b
; Level 48
    .byte $00, $00, $ab, $56, $24, $c0, $01
    .byte $08, $1c, $5a, $30, $ac, $05, $a0, $0d, $08, $31, $ba, $49, $10, $b6, $e6, $00
    .byte $00, $00, $01, $54, $a9, $41, $49, $34, $21, $42, $85, $48, $53, $4a, $09, $62
    .byte $21, $4e, $45, $22, $21, $49, $19, $00, $01
; Level 49
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $04, $00
    .byte $00, $00, $01, $1c, $71, $36, $d9, $63, $8d, $66, $cd, $64, $4d, $66, $cd, $63
    .byte $8d, $31, $19, $18, $31, $0c, $61, $04, $41
; Level 50
    .byte $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $ff, $ff, $81, $03, $e1, $0f, $bf, $fb, $8c, $63, $84, $43, $87, $c3, $bc
    .byte $7b, $80, $03, $85, $43, $80, $03, $ff, $ff
; Level 51
    .byte $ff, $fe, $fe, $fe, $fd, $7e, $e0
    .byte $0e, $ea, $ae, $f7, $de, $f7, $de, $eb, $ae, $e0, $0e, $fd, $7e, $fe, $fe, $ff
    .byte $fe, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
    .byte $01, $00, $01, $00, $01, $00, $01, $00, $01
; Level 52
    .byte $00, $00, $00, $00, $00, $00, $40
    .byte $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $04, $00
    .byte $00, $01, $01, $02, $81, $04, $41, $0f, $e1, $00, $01, $61, $f3, $9e, $0d, $00
    .byte $01, $0f, $e1, $04, $41, $02, $81, $01, $01
; Level 53
    .byte $00, $00, $00, $00, $00, $00, $40
    .byte $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $04, $00
    .byte $00, $01, $01, $02, $81, $04, $41, $0f, $e1, $00, $01, $61, $f3, $9e, $0d, $00
    .byte $01, $0f, $e1, $04, $41, $02, $81, $01, $01

; ITEM DATA TABLE
; pointers to each level's item data, e.g., level 1 = $ea86, level 53 = $efb7
; low bytes
    .byte $86, $9e, $af, $c2, $db, $f5, $16
    .byte $39, $62, $74, $8b, $9e, $bb, $e5, $19, $38, $59, $73, $8a, $9f, $b0, $cb, $e0
    .byte $ff, $1d, $41, $6c, $85, $a2, $c2, $d7, $ea, $0f, $27, $3a, $53, $6e, $8d, $a6
    .byte $b9, $ce, $e2, $f7, $0c, $1f, $38, $4f, $64, $7d, $8e, $9d, $aa, $b7
; high bytes
    .byte $ea, $ea
    .byte $ea, $ea, $ea, $ea, $eb, $eb, $eb, $eb, $eb, $eb, $eb, $eb, $ec, $ec, $ec, $ec
    .byte $ec, $ec, $ec, $ec, $ec, $ec, $ed, $ed, $ed, $ed, $ed, $ed, $ed, $ed, $ee, $ee
    .byte $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ef, $ef, $ef, $ef, $ef, $ef, $ef
    .byte $ef, $ef, $ef

; ITEM DATA
; First ten bytes are metadata:
; Byte 0 = Demon mirror #2 spawn schedule (0-15)
; Byte 1 = Demon mirror #1 spawn schedule (0-15)
; Byte 2 = Demon mirror #2 enemy set (0-16)
; Byte 3 = Demon mirror #1 enemy set (0-16)
; Byte 4 = Key status (left nibble) and time decrease rate (right nibble, 0 slow to 15 fast)
; If key nibble bit 1 set, key is behind a block
; If key nibble bit 2 set, key needs to be revealed by creating and destroying a block
; Byte 5 = Door position
; Byte 6 = Key position
; Byte 7 = Player start position
; Byte 8 = Demon mirror #1 position
; Byte 9 = Demon mirror #2 position
; Then item data pairs: Item ID and position
; If Item ID bit 1 set, item is behind a block
; If Item ID bit 2 set, item needs to be revealed by creating and destroying a block
; Code 0xC0-0xDF indicate that the next Item ID repeats (C0=1, DF=32), followed by its positions
; Final code indicates end-of-stream and level tileset

; Level 1
    .byte $00, $00, $00, $00, $01, $a7, $7c, $82, $27, $27, $18, $27, $58
    .byte $a3, $c1, $95, $44, $4a, $a7, $74, $88, $7a, $f0, $36
; Level 2
    .byte $0c, $0c, $01, $01, $01
    .byte $9d, $3d, $91, $21, $23, $18, $37, $95, $68, $99, $85, $e0
; Level 3
    .byte $00, $00, $00, $00
    .byte $01, $79, $9a, $43, $25, $25, $73, $1d, $aa, $7b, $18, $b1, $95, $a1, $e4
; Level 4
    .byte $0d
    .byte $0d, $0e, $0e, $01, $71, $67, $7d, $33, $3b, $c1, $98, $a4, $aa, $c1, $1b, $66
    .byte $68, $1b, $57, $08, $77, $1c, $27, $e0
; Level 5
    .byte $00, $00, $00, $00, $01, $27, $87, $c7
    .byte $24, $2a, $c5, $1b, $53, $6b, $73, $8b, $93, $ab, $c1, $08, $b3, $cb, $6b, $c0
    .byte $f8, $56
; Level 6
    .byte $00, $00, $00, $00, $01, $cd, $33, $31, $2d, $2d, $48, $1e, $c3, $1b
    .byte $4c, $62, $8c, $a2, $c3, $28, $4d, $61, $8d, $a1, $58, $50, $c1, $18, $c0, $b7
    .byte $16, $27, $e0
; Level 7
    .byte $00, $00, $00, $00, $01, $6a, $64, $c7, $14, $1a, $c7, $25, $43
    .byte $72, $45, $56, $58, $49, $4b, $7c, $18, $52, $15, $76, $1b, $78, $17, $5c, $54
    .byte $11, $6b, $c7, $62, $1d, $e4
; Level 8
    .byte $00, $00, $00, $00, $01, $cd, $77, $c1, $26, $28
    .byte $c3, $29, $66, $86, $68, $88, $c1, $15, $57, $97, $1d, $37, $c3, $67, $61, $63
    .byte $81, $83, $c1, $69, $67, $87, $c1, $58, $6d, $8b, $c1, $5b, $6b, $8d, $e0
; Level 9
    .byte $0c
    .byte $00, $03, $00, $01, $9c, $87, $92, $67, $67, $c1, $29, $54, $5a, $18, $85, $f1
    .byte $26
; Level 10
    .byte $00, $04, $00, $02, $01, $21, $6e, $cd, $7a, $23, $c1, $08, $46, $48, $17
    .byte $2d, $18, $c1, $6a, $80, $58, $77, $e4
; Level 11
    .byte $00, $00, $00, $00, $01, $bd, $86, $b5
    .byte $34, $92, $11, $3a, $c1, $98, $aa, $b3
    .byte $6b, $88, $e5
; Level 12
    .byte $01, $00, $05, $00, $01
    .byte $51, $5c, $c4, $15, $15, $c1, $1b, $c9, $cd, $15, $cb, $18, $11, $6b, $10, $58
    .byte $7c, $96, $5a, $aa, $5e, $1e, $2c, $e0
; Level 13
    .byte $05, $05, $05, $05, $02, $c1, $cd, $c7
    .byte $26, $28, $c1, $19, $c4, $ca, $c1, $08, $91, $a1, $c1, $28, $41, $4d, $14, $27
    .byte $c1, $6b, $21, $2d, $c1, $9b, $31, $3d, $a9, $b1, $ad, $bd, $c1, $98, $cc, $ce
    .byte $f4, $66
; Level 14
    .byte $01, $0c, $0f, $0f, $41, $17, $42, $cc, $12, $1c, $d3, $04, $20, $21
    .byte $22, $23, $24, $2a, $2b, $2c, $2d, $2e, $b0, $b1, $b2, $b3, $b4, $ba, $bb, $bc
    .byte $bd, $be, $c8, $9b, $64, $65, $66, $74, $75, $84, $86, $97, $a8, $c1, $93, $72
    .byte $7c, $98, $ac, $b3, $3c, $e0
; Level 15
    .byte $0b, $00, $0b, $00, $01, $c0, $22, $c5, $10, $10
    .byte $c5, $1b, $67, $68, $77, $78, $87, $88, $15, $34, $53, $61, $59, $5c, $c1, $98
    .byte $66, $9c, $62, $ca, $e4
; Level 16
    .byte $01, $01, $04, $03, $01, $67, $77, $c7, $26, $28, $13
    .byte $27, $18, $47, $c1, $2a, $66, $68, $c1, $1b, $86, $88, $c1, $88, $33, $3b, $c1
    .byte $aa, $46, $48, $1f, $57, $e0
; Level 17
    .byte $00, $00, $00, $00, $01, $91, $75, $be, $21, $21
    .byte $c1, $28, $94, $95, $94, $7a, $98, $7c, $52, $28, $69, $11, $58, $a2, $f9, $36
; Level 18
    .byte $00, $08, $00, $0c, $01, $b0, $4e, $c6, $2c, $22, $c1, $2a, $7b, $7c, $c1, $5b
    .byte $cc, $cd, $98, $3d, $58, $a4, $e8
; Level 19
    .byte $01, $05, $05, $05, $01, $77, $74, $c8, $2b
    .byte $28, $19, $63, $13, $72, $33, $81, $4c, $23, $6f, $21, $e0
; Level 20
    .byte $00, $00, $00, $00
    .byte $02, $17, $27, $37, $75, $79, $18, $a4, $53, $83, $5c, $2a, $e4
; Level 21
    .byte $01, $00, $01
    .byte $00, $01, $6c, $bd, $c7, $b3, $44, $c4, $27, $8c, $8d, $8e, $9c, $9e, $15, $9d
    .byte $94, $86, $ac, $89, $98, $bb, $f2, $36
; Level 22
    .byte $08, $08, $05, $05, $01, $be, $9b, $5e
    .byte $4e, $89, $0c, $8e, $6e, $8a, $c1, $98, $6a, $97, $92, $79, $e4
; Level 23
    .byte $00, $00, $00
    .byte $00, $01, $a3, $86, $2d, $96, $a6, $c3, $04, $2b, $2c, $3b, $3c, $18, $5c, $c1
    .byte $58, $32, $43, $6e, $ce, $62, $c3, $6b, $33, $6a, $42, $e8
; Level 24
    .byte $00, $00, $00, $00
    .byte $02, $4d, $91, $b1, $83, $68, $c4, $68, $c7, $c8, $c9, $ca, $cb, $58, $9d, $14
    .byte $51, $12, $46, $18, $3d, $97, $75, $9d, $ce, $e4
; Level 25
    .byte $08, $08, $06, $07, $01, $27
    .byte $67, $c7, $14, $1a, $c3, $27, $21, $2d, $a1, $ad, $c1, $58, $61, $6d, $c1, $a5
    .byte $42, $4c, $c1, $a6, $41, $4d, $c1, $a7, $40, $4e, $91, $47, $fa, $a6
; Level 26
    .byte $06, $06
    .byte $03, $04, $01, $27, $77, $a7, $22, $2c, $c1, $18, $42, $4c, $14, $67, $16, $c7
    .byte $c3, $a8, $a3, $a4, $aa, $ab, $c1, $98, $b6, $b8, $c3, $a6, $73, $74, $7a, $7b
    .byte $c1, $99, $86, $88, $ae, $15, $91, $19, $e8
; Level 27
    .byte $00, $00, $00, $00, $01, $2c, $c1
    .byte $cd, $21, $5d, $c1, $69, $2a, $b3, $2b, $6a, $2d, $34, $18, $60, $92, $cb, $b3
    .byte $3d, $e4
; Level 28
    .byte $00, $00, $00, $00, $02, $a7, $97, $c7, $93, $9b, $c1, $2c, $a0, $ae
    .byte $c1, $1b, $44, $4a, $2a, $47, $58, $13, $51, $a5, $5b, $a9, $5e, $1e, $e4
; Level 29
    .byte $0a
    .byte $0a, $01, $02, $01, $6d, $67, $61, $2c, $23, $c1, $26, $96, $98, $18, $27, $c1
    .byte $6b, $5b, $6e, $6a, $59, $69, $57, $68, $55, $67, $53, $4c, $62, $f5, $36
; Level 30
    .byte $01
    .byte $01, $01, $02, $02, $16, $18, $37, $1e, $10, $94, $47, $98, $87, $73, $a1, $59
    .byte $ad, $6f, $27, $e0
; Level 31
    .byte $03, $03, $10, $08, $02, $13, $1b, $c7, $11, $1d, $62, $ce
    .byte $52, $18, $58, $16, $70, $87, $e4
; Level 32
    .byte $08, $08, $01, $02, $02, $17, $67, $27, $19
    .byte $15, $c9, $1b, $25, $29, $35, $36, $38, $39, $95, $99, $a5, $a9, $c3, $27, $65
    .byte $69, $75, $79, $6e, $57, $58, $c7, $54, $9e, $5f, $7e, $e4
; Level 33
    .byte $00, $00, $00, $00
    .byte $01, $c7, $c2, $cc, $23, $2b, $c1, $58, $c1, $c6, $6c, $6c, $6d, $6d, $6e, $6e
    .byte $52, $17, $fb, $69
; Level 34
    .byte $08, $08, $09, $0a, $40, $c7, $77, $37, $2c, $22, $c1, $18
    .byte $35, $39, $12, $38, $54, $36, $e0
; Level 35
    .byte $04, $04, $01, $02, $02, $17, $27, $c7, $15
    .byte $19, $c3, $29, $75, $79, $95, $99, $13, $87, $73, $67, $c1, $ac, $36, $38, $e8
; Level 36
    .byte $07, $00, $08, $00, $01, $c1, $25, $c7, $11, $11, $c1, $68, $ac, $ad, $c1, $6b
    .byte $4c, $4d, $19, $71, $18, $47, $14, $1e, $1c, $23, $e8
; Level 37
    .byte $00, $00, $00, $00, $01
    .byte $2d, $cc, $cd, $a0, $a0, $ca, $1b, $83, $87, $93, $94, $96, $97, $a3, $a5, $a7
    .byte $b3, $b7, $c1, $58, $5d, $7d, $51, $b9, $f6, $46
; Level 38
    .byte $09, $09, $00, $00, $02, $17
    .byte $27, $47, $10, $1e, $c1, $55, $55, $59, $c1, $a6, $b0, $be, $98, $41, $53, $90
    .byte $0e, $9c, $e4
; Level 39
    .byte $00, $00, $00, $00, $02, $77, $2d, $b0, $67, $67, $53, $66, $58
    .byte $67, $4c, $68, $62, $70, $e8
; Level 40
    .byte $00, $00, $00, $00, $01, $6d, $67, $61, $47, $47
    .byte $c1, $58, $26, $28, $6d, $6b, $73, $1c, $5d, $63, $e8
; Level 41
    .byte $04, $04, $09, $0a, $01
    .byte $57, $b7, $67, $1a, $14, $2b, $84, $af, $a4, $92, $ab, $99, $c7, $f3, $26
; Level 42
    .byte $00
    .byte $00, $00, $00, $82, $10, $1e, $47, $11, $1d, $c1, $ad, $36, $38, $6f, $37, $58
    .byte $47, $93, $b4, $e4
; Level 43
    .byte $04, $00, $05, $00, $42, $21, $c1, $cd, $28, $28, $18, $52
    .byte $2d, $64, $12, $68, $58, $5b, $70, $56, $e4
; Level 44
    .byte $00, $00, $00, $00, $02, $10, $ce
    .byte $c7, $1e, $c0, $52, $87, $6e, $6e, $98, $23, $9e, $50, $e8
; Level 45
    .byte $0e, $03, $01, $02
    .byte $42, $60, $6e, $c7, $5b, $53, $c1, $18, $c0, $ce, $c2, $6b, $63, $6b, $c4, $ad
    .byte $9b, $ae, $82, $f7, $26
; Level 46
    .byte $01, $05, $05, $05, $42, $2d, $1a, $ce, $21, $20, $52
    .byte $58, $53, $7a, $58, $2a, $6e, $4b, $72, $6d, $54, $38, $e4, $0f, $00, $03, $00
    .byte $02, $b1, $35, $11, $ba, $30, $25, $b7, $73, $4a, $71, $6d, $c1, $98, $65, $cd
    .byte $e0
; Level 47
    .byte $00, $00, $00, $00, $02, $80, $a0, $c0, $57, $57, $5f, $44, $6d, $33, $6f
    .byte $50, $18, $a3, $ab, $41, $b3, $53, $ae, $3a, $e8
; Level 48
    .byte $00, $00, $00, $00, $81, $00
    .byte $00, $37, $19, $19, $6d, $19, $c1, $6e, $c4, $ca, $e8
; Level 49
    .byte $00, $00, $00, $00, $82
    .byte $67, $00, $2c, $62, $6c, $c1, $04, $a6, $a8, $e0
; Level 50
    .byte $00, $00, $00, $00, $00, $47
    .byte $9b, $93, $77, $77, $1b, $77, $e0
; Level 51
    .byte $00, $00, $00, $00, $01, $3d, $57, $31, $10
    .byte $10, $6a, $10, $e4
; Level 52
    .byte $00, $00, $00, $00, $01, $a1, $87, $ad, $ce, $ce, $6a, $ce
    .byte $e8

    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $bf, $00, $ff, $00, $ff, $00, $00, $ff, $00
    .byte $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $bf, $ff, $00, $ff
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

    LDX #$02

_label_bank0_f002:
    LDY $0423,X
    BEQ _label_bank0_f00a
    JSR $F134

_label_bank0_f00a:
    DEX
    BPL _label_bank0_f002
    LDA #$56
    STA $08
    LDA #$04
    STA $09
    LDA #$00
    STA $0A
    LDY #$08
    STY $0B

_label_bank0_f01d:
    LDA $04F6
    LSR A
    BCC _label_bank0_f025
    ORA #$80

_label_bank0_f025:
    STA $04F6
    BCC _label_bank0_f041
    LDX $0A
    DEC $04D6,X
    BNE _label_bank0_f034
    JSR $F190

_label_bank0_f034:
    LDX $0A
    DEC $04D8,X
    BNE _label_bank0_f03e
    JSR $F112

_label_bank0_f03e:
    JSR $F0E7

_label_bank0_f041:
    CLC
    LDA #$10
    ADC $08
    STA $08
    LDA #$00
    ADC $09
    STA $09
    LDA #$04
    ADC $0A
    STA $0A
    DEC $0B
    BNE _label_bank0_f01d
    LDA #$56
    STA $08
    LDA #$04
    STA $09
    LDA #$03
    STA $0A
    LDA #$03
    STA $0B

_label_bank0_f068:
    LDA $04F6
    AND $0B
    BEQ _label_bank0_f073
    AND #$55
    BNE _label_bank0_f07c

_label_bank0_f073:
    JSR $F093
    JSR $F0A1
    JMP $F082

_label_bank0_f07c:
    JSR $F0A1
    JSR $F093
    JSR $F093
    ASL $0B
    ASL $0B
    DEC $0A
    BPL _label_bank0_f068
    LDA #$0F
    STA a:APU_SND_CHN
    RTS

    CLC
    LDA #$10
    ADC $08
    STA $08
    LDA #$00
    ADC $09
    STA $09
    RTS

    LDA #$03
    EOR $0A
    ASL A
    ASL A
    TAX
    LDY #$06
    LDA ($08),Y
    DEY
    PHA
    LDA $0A
    CMP #$01
    BNE _label_bank0_f0bb
    PLA
    AND #$0F
    ORA #$80
    BNE _label_bank0_f0be

_label_bank0_f0bb:
    PLA
    ORA #$30

_label_bank0_f0be:
    STA a:APU_PL1_VOL,X
    LDA #$10
    AND ($08),Y
    BNE _label_bank0_f0cc
    LDA #$19
    STA a:APU_PL1_SWEEP,X

_label_bank0_f0cc:
    LDY #$08
    LDA ($08),Y
    BPL _label_bank0_f0e6
    PHA
    AND #$7F
    STA ($08),Y
    DEY
    LDA ($08),Y
    INY
    STA a:APU_PL1_LO,X
    LDA ($08),Y
    PLA
    ORA #$20
    STA a:APU_PL1_HI,X

_label_bank0_f0e6:
    RTS

    LDY #$05
    LDA ($08),Y
    TAX
    AND #$F0
    STA $0E
    AND #$20
    BEQ _label_bank0_f0fa
    LDA #$0F
    STA $0F
    BNE _label_bank0_f0ff

_label_bank0_f0fa:
    TXA
    AND #$0F
    STA $0F

_label_bank0_f0ff:
    LDX $0A
    LDA $04D9,X
    SEC
    SBC $0F
    BCS _label_bank0_f10b
    LDA #$00

_label_bank0_f10b:
    ORA $0E
    LDY #$06
    STA ($08),Y
    RTS

    LDY #$02
    LDA ($08),Y
    INY
    STA $0E
    LDA ($08),Y
    INY
    STA $0F
    LDA ($08),Y
    PHA
    CLC
    ADC #$02
    STA ($08),Y
    PLA
    TAY
    LDA ($0E),Y
    INY
    STA $04D8,X
    LDA ($0E),Y
    STA $04D9,X
    RTS

    STX $0D
    LDA #$00
    STA $0423,X
    DEY
    TYA
    ASL A
    TAY
    LDA $F47C,Y
    STA $08
    LDA $F47D,Y
    STA $09
    LDY #$00
    LDA ($08),Y
    AND #$7F
    BPL _label_bank0_f158

_label_bank0_f151:
    LDA ($08),Y
    BPL _label_bank0_f158
    LDX $0D
    RTS

_label_bank0_f158:
    INY
    STA $0C
    ASL A
    ASL A
    ASL A
    ASL A
    TAX
    LDA ($08),Y
    INY
    STA $0456,X
    LDA ($08),Y
    STA $0457,X
    LDA #$00
    STA $045B,X
    LDA #$0F
    STA $045F,X
    LDA $0C
    ASL A
    ASL A
    TAX
    LDA #$01
    STA $04D6,X
    LSR A
    LDX $0C
    SEC

_label_bank0_f183:
    ROL A
    DEX
    BPL _label_bank0_f183
    ORA $04F6
    STA $04F6
    INY
    BPL _label_bank0_f151
    LDA #$CF
    LDY #$05
    AND ($08),Y
    STA ($08),Y
    LDY #$00
    LDA ($08),Y
    INY
    STA $0C
    LDA ($08),Y
    STA $0D
    DEY

_label_bank0_f1a4:
    LDA ($0C),Y
    BPL _label_bank0_f1c2
    INY
    CMP #$F0
    BCC _label_bank0_f1b2
    JSR $F235
    BPL _label_bank0_f1a4

_label_bank0_f1b2:
    AND #$3F
    TAX
    LDA $F380,X
    LDX $0A
    STA $04D6,X
    STA $04D7,X
    BPL _label_bank0_f1a4

_label_bank0_f1c2:
    INY
    PHA
    TYA
    LDY #$00
    CLC
    ADC $0C
    STA ($08),Y
    INY
    LDA #$00
    ADC $0D
    STA ($08),Y
    PLA
    LDX #$02
    CPX $0B
    BCC _label_bank0_f1e6
    CMP #$10
    BEQ _label_bank0_f1ed
    STA $0C
    LDA #$00
    STA $0D
    BEQ _label_bank0_f214

_label_bank0_f1e6:
    TAX
    AND #$0F
    CMP #$0C
    BNE _label_bank0_f1f7

_label_bank0_f1ed:
    LDY #$05
    LDA #$20
    ORA ($08),Y
    STA ($08),Y
    BNE _label_bank0_f221

_label_bank0_f1f7:
    ASL A
    TAY
    LDA $F368,Y
    STA $0C
    LDA $F369,Y
    STA $0D
    TXA
    AND #$F0
    LSR A
    LSR A
    LSR A
    LSR A
    TAX
    BEQ _label_bank0_f214

_label_bank0_f20d:
    LSR $0D
    ROR $0C
    DEX
    BNE _label_bank0_f20d

_label_bank0_f214:
    LDY #$07
    LDA $0C
    STA ($08),Y
    INY
    LDA $0D
    ORA #$80
    STA ($08),Y

_label_bank0_f221:
    LDX $0A
    LDA $04D7,X
    STA $04D6,X
    LDA #$01
    STA $04D8,X
    LDA #$00
    LDY #$04
    STA ($08),Y
    RTS

    AND #$0F
    ASL A
    TAX
    LDA $F246,X
    STA $0E
    LDA $F247,X
    STA $0F
; jump engine
    JMP ($000E)

    .byte $5a, $f2, $75, $f2, $89, $f2, $96, $f2, $c0, $f2, $d7, $f2, $00
    .byte $f3, $28, $f3, $43, $f3, $57, $f3

    LDA ($0C),Y
    INY
    STY $0E
    ASL A
    TAX
    LDA $F39A,X
    TAY
    LDA $F39B,X
    TAX
    TYA
    LDY #$02
    STA ($08),Y
    INY
    TXA
    STA ($08),Y
    LDY $0E
    RTS

    LDA ($0C),Y
    INY
    STY $0E
    STA $0F
    LDA #$F0
    LDY #$05
    AND ($08),Y
    ORA $0F
    STA ($08),Y
    LDY $0E
    RTS

    LDA ($0C),Y
    INY
    TAX
    LDA ($0C),Y
    STX $0C
    STA $0D
    LDY #$00
    RTS

    LDA ($0C),Y
    INY
    TAX
    LDA ($0C),Y
    INY
    PHA
    TYA
    PHA
    LDY #$09
    LDA ($08),Y
    TAY
    PLA
    CLC
    ADC $0C
    STA ($08),Y
    DEY
    LDA #$00
    ADC $0D
    STA ($08),Y
    DEY
    TYA
    LDY #$09
    STA ($08),Y
    STX $0C
    PLA
    STA $0D
    LDY #$00
    RTS

    LDY #$09
    LDA ($08),Y
    TAY
    INY
    LDA ($08),Y
    INY
    STA $0D
    LDA ($08),Y
    STA $0C
    TYA
    LDY #$09
    STA ($08),Y
    LDY #$00
    RTS

    LDA ($0C),Y
    INY
    TAX
    TYA
    PHA
    LDY #$09
    LDA ($08),Y
    TAY
    PLA
    CLC
    ADC $0C
    STA $0C
    STA ($08),Y
    DEY
    LDA #$00
    ADC $0D
    STA $0D
    STA ($08),Y
    DEY
    TXA
    STA ($08),Y
    DEY
    TYA
    LDY #$09
    STA ($08),Y
    LDY #$00
    RTS

    STY $0E
    LDY #$09
    LDA ($08),Y
    TAY
    INY
    LDA ($08),Y
    CLC
    SBC #$00
    STA ($08),Y
    BEQ _label_bank0_f31e
    INY
    LDA ($08),Y
    INY
    STA $0D
    LDA ($08),Y
    STA $0C
    LDY #$00
    RTS

_label_bank0_f31e:
    INY
    INY
    TYA
    LDY #$09
    STA ($08),Y
    LDY $0E
    RTS

    STY $0E
    LDY #$05
    LDA #$10
    ORA ($08),Y
    STA ($08),Y
    LDA #$07
    EOR $0B
    LSR A
    ASL A
    ASL A
    TAX
    LDY $0E
    LDA ($0C),Y
    INY
    STA a:APU_PL1_SWEEP,X
    RTS

    LDA ($0C),Y
    INY
    STY $0E
    STA $0F
    LDY #$05
    LDA #$3F
    AND ($08),Y
    ORA $0F
    STA ($08),Y
    LDY $0E
    RTS

    LDA #$7F
    AND $04F6
    STA $04F6
    LDY #$05
    LDA #$0F
    STA ($08),Y
    PLA
    PLA
    RTS

    .byte $ae, $06, $4e, $06, $f3, $05, $9e, $05, $4d, $05, $01
    .byte $05, $b9, $04, $75, $04, $35, $04, $f8, $03, $bf, $03, $89, $03, $01, $02, $04
    .byte $06, $08, $0c, $10, $18, $20, $30, $40, $60, $80, $c0, $05, $0a, $0f, $14, $19
    .byte $1e, $28, $32, $3c, $46, $50, $50, $aa, $f3, $ca, $f3, $ea, $f3, $fc, $f3, $24
    .byte $f4, $3e, $f4, $58, $f4, $5c, $f4, $02, $0f, $02, $0e, $02, $0d, $02, $0c, $02
    .byte $0b, $02, $0a, $02, $09, $02, $08, $02, $07, $02, $06, $02, $05, $02, $04, $02
    .byte $03, $02, $02, $02, $01, $ff, $00, $01, $0f, $01, $0e, $01, $0d, $01, $0c, $01
    .byte $0b, $01, $0a, $01, $09, $01, $08, $01, $07, $01, $06, $01, $05, $01, $04, $01
    .byte $03, $01, $02, $01, $01, $ff, $00, $01, $0f, $01, $0d, $01, $0b, $01, $09, $01
    .byte $07, $01, $05, $01, $03, $01, $01, $ff, $00, $01, $0b, $01, $0c, $01, $0d, $01
    .byte $0e, $02, $0f, $02, $0e, $02, $0d, $02, $0c, $02, $0b, $02, $0a, $02, $09, $02
    .byte $08, $02, $07, $02, $06, $02, $05, $02, $04, $02, $03, $02, $02, $02, $01, $ff
    .byte $00, $02, $04, $02, $05, $02, $06, $02, $07, $02, $08, $02, $09, $02, $0a, $02
    .byte $08, $02, $06, $02, $04, $02, $02, $01, $02, $ff, $00, $01, $04, $01, $05, $01
    .byte $06, $01, $07, $01, $08, $01, $09, $01, $0a, $01, $08, $01, $06, $01, $04, $01
    .byte $02, $01, $01, $ff, $00, $ff, $0f, $ff, $00, $05, $0f, $05, $0e, $05, $0d, $05
    .byte $0b, $05, $0a, $05, $09, $05, $09, $05, $08, $05, $07, $05, $06, $05, $05, $05
    .byte $04, $05, $03, $05, $02, $05, $01, $ff, $00, $b0, $f4, $b9, $f4, $c2, $f4, $d4
    .byte $f4, $dd, $f4, $e9, $f4, $f2, $f4, $f5, $f4, $f8, $f4, $fe, $f4, $01, $f5, $04
    .byte $f5, $10, $f5, $13, $f5, $16, $f5, $1f, $f5, $2b, $f5, $2e, $f5, $31, $f5, $37
    .byte $f5, $43, $f5, $55, $f5, $5e, $f5, $61, $f5, $79, $f5, $85, $f5, $81, $92, $f5
    .byte $03, $50, $f6, $07, $23, $f8, $81, $5a, $f8, $03, $d3, $f8, $07, $a2, $ff, $80
    .byte $4f, $f9, $02, $74, $f9, $06, $99, $f9, $01, $7a, $ff, $03, $81, $ff, $07, $8f
    .byte $ff, $81, $b1, $f9, $03, $fc, $f9, $07, $47, $fa, $80, $a2, $fa, $02, $cd, $fa
    .byte $04, $dd, $fa, $07, $e9, $fa, $80, $f0, $fa, $02, $05, $fb, $04, $1a, $fb, $84
    .byte $1e, $fb, $86, $30, $fb, $84, $3f, $fb, $06, $5f, $fb, $84, $72, $fb, $86, $88
    .byte $fb, $80, $8f, $fb, $02, $96, $fb, $04, $9d, $fb, $06, $a7, $fb, $84, $ae, $fb
    .byte $84, $cc, $fb, $80, $d3, $fb, $02, $f7, $fb, $06, $1b, $fc, $81, $25, $fc, $03
    .byte $d8, $fc, $05, $83, $fd, $07, $33, $fe, $84, $68, $fe, $84, $77, $fe, $81, $81
    .byte $fe, $03, $8d, $fe, $81, $99, $fe, $03, $a5, $fe, $05, $b3, $fe, $07, $f7, $fe
    .byte $80, $fe, $fe, $02, $13, $ff, $04, $28, $ff, $01, $7a, $ff, $03, $81, $ff, $07
    .byte $8f, $ff, $80, $37, $ff, $02, $48, $ff, $06, $59, $ff, $84, $62, $ff, $80, $7a
    .byte $ff, $02, $81, $ff, $04, $88, $ff, $06, $8f, $ff, $01, $96, $ff, $03, $9a, $ff
    .byte $05, $9e, $ff, $07, $a2, $ff, $80, $a6, $ff, $02, $b6, $ff, $04, $c6, $ff, $07
    .byte $d6, $ff, $80, $dd, $ff, $02, $e0, $ff, $04, $e3, $ff, $07, $f3, $ff, $ff, $f0
    .byte $06, $f1, $09, $f8, $00, $88, $13, $84, $15, $13, $88, $12, $84, $13, $12, $88
    .byte $11, $84, $12, $11, $88, $10, $84, $11, $10, $87, $0b, $10, $12, $13, $f1, $0b
    .byte $83, $f5, $08, $08, $07, $f6, $f0, $00, $f1, $07, $f8, $00, $85, $f3, $e7, $f5
    .byte $f3, $e7, $f5, $f3, $08, $f6, $f3, $08, $f6, $f3, $e7, $f5, $f3, $e7, $f5, $f3
    .byte $08, $f6, $f3, $08, $f6, $f3, $29, $f6, $f3, $46, $f6, $f3, $29, $f6, $f3, $4b
    .byte $f6, $f2, $b9, $f5, $10, $13, $17, $13, $12, $15, $18, $12, $13, $17, $20, $13
    .byte $15, $18, $22, $15, $13, $17, $20, $13, $12, $15, $18, $12, $10, $13, $17, $10
    .byte $0b, $12, $15, $0b, $f4, $09, $10, $14, $09, $0b, $12, $15, $0b, $10, $14, $17
    .byte $10, $12, $15, $19, $12, $14, $17, $20, $14, $12, $15, $1b, $12, $10, $14, $19
    .byte $10, $0b, $12, $17, $0b, $f4, $10, $14, $19, $14, $0b, $12, $17, $12, $12, $16
    .byte $1b, $16, $14, $18, $1b, $18, $10, $14, $19, $14, $0b, $12, $17, $12, $09, $10
    .byte $15, $10, $f4, $08, $0b, $14, $0b, $f4, $0b, $12, $17, $12, $f4, $f0, $03, $f1
    .byte $03, $f8, $00, $85, $20, $27, $0c, $27, $26, $0c, $27, $27, $f0, $05, $f1, $02
    .byte $28, $27, $26, $27, $30, $27, $26, $27, $f0, $03, $f1, $04, $84, $22, $23, $25
    .byte $27, $28, $2b, $30, $2b, $28, $27, $25, $23, $f0, $05, $f1, $03, $85, $22, $1b
    .byte $1b, $22, $1b, $1b, $22, $1b, $f0, $03, $f1, $04, $f8, $00, $85, $f3, $c6, $f6
    .byte $f3, $df, $f6, $f3, $c6, $f6, $f3, $e8, $f6, $f3, $f1, $f6, $f3, $02, $f7, $f3
    .byte $f1, $f6, $f3, $13, $f7, $f3, $24, $f7, $f3, $e8, $f7, $f3, $00, $f8, $f3, $e8
    .byte $f7, $f3, $0b, $f8, $f3, $e8, $f7, $f3, $00, $f8, $f3, $e8, $f7, $f3, $17, $f8
    .byte $f2, $89, $f6, $0c, $0c, $30, $30, $2b, $0c, $30, $30, $32, $0c, $30, $2b, $30
    .byte $0c, $0c, $0c, $0c, $0c, $30, $30, $2b, $0c, $30, $30, $f4, $27, $0c, $23, $0c
    .byte $22, $0c, $27, $0c, $f4, $27, $0c, $23, $0c, $22, $0c, $20, $0c, $f4, $0c, $0c
    .byte $29, $29, $28, $0c, $29, $29, $2b, $0c, $29, $28, $29, $0c, $2b, $30, $f4, $32
    .byte $0c, $30, $2b, $30, $0c, $32, $34, $35, $0c, $34, $0c, $0c, $0c, $0c, $0c, $f4
    .byte $32, $30, $2b, $29, $30, $2b, $29, $28, $29, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    .byte $f4, $f0, $03, $f1, $06, $85, $f5, $02, $30, $33, $37, $40, $3b, $38, $35, $32
    .byte $f6, $85, $27, $30, $33, $37, $84, $35, $42, $40, $3b, $38, $37, $33, $37, $40
    .byte $37, $33, $30, $83, $2b, $30, $32, $33, $32, $30, $2b, $28, $84, $f5, $03, $37
    .byte $36, $f6, $35, $37, $38, $3b, $40, $42, $83, $43, $42, $40, $3b, $38, $37, $35
    .byte $33, $32, $30, $2b, $28, $27, $25, $23, $22, $85, $37, $30, $33, $37, $38, $32
    .byte $35, $38, $40, $33, $37, $40, $84, $f5, $03, $3b, $35, $f6, $85, $40, $39, $34
    .byte $30, $84, $38, $35, $34, $32, $34, $35, $87, $34, $84, $0c, $32, $30, $2b, $29
    .byte $28, $25, $24, $22, $f5, $03, $24, $30, $f6, $f5, $03, $25, $32, $f6, $34, $32
    .byte $30, $20, $22, $24, $83, $32, $30, $2b, $29, $22, $24, $25, $28, $29, $2b, $30
    .byte $32, $34, $35, $38, $39, $3b, $39, $38, $85, $35, $83, $38, $35, $34, $84, $f5
    .byte $03, $39, $30, $f6, $85, $39, $32, $39, $32, $84, $39, $34, $39, $34, $39, $34
    .byte $83, $3b, $38, $35, $32, $38, $35, $32, $2b, $87, $f1, $08, $29, $f1, $09, $30
    .byte $89, $f1, $0a, $2b, $f4, $f0, $03, $f1, $04, $f8, $00, $87, $0c, $39, $37, $81
    .byte $32, $31, $30, $2b, $2a, $29, $28, $27, $26, $25, $24, $23, $f4, $85, $36, $32
    .byte $36, $87, $34, $85, $0c, $36, $38, $f4, $85, $35, $40, $39, $35, $f1, $06, $34
    .byte $38, $3b, $38, $f4, $85, $35, $40, $39, $35, $f1, $07, $37, $3b, $42, $3b, $f4
    .byte $f0, $02, $f1, $06, $89, $f5, $08, $00, $f6, $85, $f3, $3f, $f8, $f3, $3f, $f8
    .byte $f3, $3f, $f8, $f3, $4d, $f8, $f3, $4d, $f8, $f2, $2d, $f8, $f0, $04, $f1, $04
    .byte $87, $04, $f0, $02, $f1, $04, $85, $07, $07, $f4, $f0, $05, $f1, $04, $85, $04
    .byte $f0, $02, $f1, $04, $85, $07, $f4, $f0, $03, $f8, $40, $84, $f1, $0c, $f3, $82
    .byte $f8, $f1, $0a, $f3, $82, $f8, $f1, $08, $f3, $82, $f8, $f1, $06, $f3, $82, $f8
    .byte $f3, $89, $f8, $f3, $89, $f8, $f3, $89, $f8, $f3, $96, $f8, $f2, $73, $f8, $35
    .byte $37, $35, $37, $35, $37, $f4, $42, $32, $47, $37, $45, $35, $42, $32, $3a, $2a
    .byte $40, $30, $f4, $41, $31, $45, $35, $48, $38, $47, $37, $43, $33, $40, $30, $41
    .byte $31, $3a, $2a, $36, $26, $35, $25, $39, $29, $40, $30, $3a, $2a, $42, $32, $45
    .byte $35, $48, $38, $45, $35, $42, $32, $47, $37, $43, $33, $40, $30, $39, $29, $37
    .byte $27, $39, $29, $3a, $2a, $42, $32, $45, $35, $4a, $3a, $3a, $2a, $4a, $3a, $f4
    .byte $f0, $03, $f8, $00, $84, $f1, $0c, $f3, $fe, $f8, $f1, $0a, $f3, $fe, $f8, $f1
    .byte $08, $f3, $fe, $f8, $f1, $06, $f3, $fe, $f8, $f1, $08, $84, $f3, $05, $f9, $f3
    .byte $05, $f9, $f3, $05, $f9, $f3, $12, $f9, $f2, $ec, $f8, $32, $33, $32, $33, $32
    .byte $33, $f4, $07, $0a, $17, $1a, $27, $2a, $05, $0a, $15, $1a, $25, $2a, $f4, $08
    .byte $11, $18, $21, $28, $31, $07, $10, $17, $20, $27, $30, $06, $0a, $16, $1a, $26
    .byte $2a, $05, $09, $15, $19, $25, $29, $02, $05, $12, $15, $22, $25, $05, $0a, $15
    .byte $1a, $25, $2a, $07, $10, $17, $20, $27, $30, $05, $09, $15, $19, $25, $29, $02
    .byte $05, $12, $15, $22, $25, $06, $0a, $16, $1a, $26, $2a, $f4, $f0, $03, $f1, $00
    .byte $f8, $00, $80, $17, $18, $19, $1a, $1b, $20, $85, $23, $83, $22, $85, $1b, $20
    .byte $80, $18, $19, $1a, $1b, $20, $21, $22, $23, $24, $25, $26, $27, $85, $28, $27
    .byte $f9, $f0, $03, $f1, $00, $f8, $00, $80, $37, $38, $39, $3a, $3b, $40, $85, $43
    .byte $83, $42, $85, $3b, $40, $80, $38, $39, $3a, $3b, $40, $41, $42, $43, $44, $45
    .byte $46, $47, $85, $48, $47, $f9, $f0, $02, $83, $f5, $02, $f1, $04, $04, $04, $f1
    .byte $02, $08, $08, $f6, $f1, $04, $04, $04, $85, $f1, $01, $08, $08, $f9, $f0, $03
    .byte $f8, $00, $84, $f1, $09, $f3, $f7, $f9, $f1, $08, $f3, $f7, $f9, $f1, $07, $f3
    .byte $f7, $f9, $f1, $06, $f3, $f7, $f9, $f1, $05, $f3, $f7, $f9, $f1, $04, $f3, $f7
    .byte $f9, $f1, $02, $81, $f3, $f7, $f9, $84, $08, $f1, $04, $81, $f3, $f7, $f9, $84
    .byte $08, $f1, $06, $81, $f3, $f7, $f9, $84, $08, $f1, $08, $81, $f3, $f7, $f9, $84
    .byte $08, $f2, $b1, $f9, $05, $05, $06, $07, $f4, $f0, $03, $f8, $00, $84, $f1, $0b
    .byte $f3, $42, $fa, $f1, $0a, $f3, $42, $fa, $f1, $09, $f3, $42, $fa, $f1, $08, $f3
    .byte $42, $fa, $f1, $07, $f3, $42, $fa, $f1, $06, $f3, $42, $fa, $f1, $05, $81, $f3
    .byte $42, $fa, $84, $28, $f1, $07, $81, $f3, $42, $fa, $84, $28, $f1, $09, $81, $f3
    .byte $42, $fa, $84, $28, $f1, $0b, $81, $f3, $42, $fa, $84, $28, $f2, $fc, $f9, $24
    .byte $25, $26, $27, $f4, $f0, $02, $84, $f3, $9b, $fa, $f1, $09, $08, $f1, $09, $04
    .byte $f3, $9b, $fa, $f1, $08, $08, $f1, $08, $04, $f3, $9b, $fa, $f1, $07, $08, $f1
    .byte $07, $04, $f3, $9b, $fa, $f1, $06, $08, $f1, $06, $04, $f3, $9b, $fa, $f1, $05
    .byte $08, $f1, $05, $04, $f3, $9b, $fa, $f1, $04, $08, $f1, $04, $04, $f1, $0a, $01
    .byte $f1, $02, $08, $f1, $0a, $01, $f1, $04, $08, $f1, $0a, $01, $f1, $06, $08, $f1
    .byte $0a, $01, $f1, $08, $08, $f2, $47, $fa, $f1, $0a, $01, $f1, $0a, $01, $f4, $f0
    .byte $03, $f1, $02, $f8, $00, $85, $35, $38, $3b, $40, $42, $40, $3b, $38, $42, $40
    .byte $3b, $38, $37, $35, $37, $38, $37, $35, $83, $f5, $05, $34, $35, $34, $35, $f6
    .byte $87, $32, $34, $f0, $06, $f1, $06, $8b, $35, $f9, $f0, $06, $f1, $06, $f8, $00
    .byte $89, $30, $2b, $30, $2b, $8b, $27, $27, $25, $f9, $f8, $80, $89, $15, $15, $15
    .byte $15, $8b, $10, $10, $09, $f9, $f0, $00, $f1, $0f, $80, $01, $f9, $f0, $06, $f1
    .byte $08, $f8, $00, $82, $10, $13, $17, $84, $18, $82, $20, $84, $21, $25, $26, $82
    .byte $28, $f9, $f0, $06, $f1, $08, $f8, $40, $82, $30, $33, $37, $84, $38, $82, $40
    .byte $84, $41, $45, $46, $82, $48, $f9, $f3, $05, $fb, $f9, $f0, $00, $f8, $c0, $80
    .byte $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $70, $71, $f9, $f0, $01, $f1
    .byte $00, $80, $0c, $0b, $0a, $82, $09, $85, $f1, $04, $06, $f9, $f0, $06, $f1, $00
    .byte $f8, $c0, $80, $27, $32, $26, $31, $25, $30, $24, $2b, $23, $2a, $22, $29, $21
    .byte $28, $20, $27, $1b, $26, $20, $21, $22, $23, $24, $25, $f9, $f0, $06, $f1, $00
    .byte $80, $09, $08, $07, $06, $05, $04, $03, $02, $f5, $05, $01, $02, $f6, $f9, $f0
    .byte $06, $f1, $00, $80, $71, $73, $71, $73, $71, $73, $71, $73, $61, $63, $61, $63
    .byte $61, $63, $61, $63, $f9, $f0, $06, $f1, $00, $88, $05, $f9, $f0, $06, $f8, $00
    .byte $94, $0c, $f9, $f0, $06, $f8, $00, $94, $0c, $f9, $f0, $06, $f1, $00, $8f, $32
    .byte $0c, $0c, $0c, $f9, $f0, $06, $f1, $0f, $94, $00, $f9, $f0, $06, $f1, $00, $80
    .byte $56, $57, $58, $59, $56, $53, $50, $49, $46, $43, $40, $39, $36, $33, $30, $29
    .byte $2b, $31, $33, $35, $37, $39, $3b, $41, $f9, $f0, $06, $f1, $00, $80, $0c, $f9
    .byte $f0, $03, $f8, $80, $81, $f1, $02, $f3, $ed, $fb, $f1, $04, $f3, $ed, $fb, $f1
    .byte $06, $f3, $ed, $fb, $f1, $08, $f3, $ed, $fb, $f9, $f5, $02, $27, $37, $47, $29
    .byte $39, $49, $f6, $f4, $f0, $03, $f8, $80, $81, $f1, $02, $f3, $11, $fc, $f1, $04
    .byte $f3, $11, $fc, $f1, $06, $f3, $11, $fc, $f1, $08, $f3, $11, $fc, $f9, $f5, $02
    .byte $24, $34, $44, $25, $35, $45, $f6, $f4, $f0, $00, $f1, $0f, $87, $f5, $07, $00
    .byte $f6, $f9, $f0, $03, $f1, $02, $f8, $40, $f3, $bb, $fc, $94, $35, $34, $f3, $bb
    .byte $fc, $94, $32, $34, $98, $f5, $07, $0c, $f6, $94, $28, $27, $f0, $00, $f5, $02
    .byte $93, $35, $8f, $35, $93, $35, $8f, $35, $0c, $35, $0c, $35, $91, $3a, $40, $f6
    .byte $f5, $02, $91, $19, $8f, $1a, $20, $0c, $35, $35, $35, $f6, $91, $22, $24, $25
    .byte $8f, $27, $29, $0c, $27, $0c, $25, $91, $29, $27, $f0, $07, $f5, $02, $93, $3a
    .byte $8f, $39, $94, $39, $93, $37, $8f, $39, $94, $39, $93, $3a, $8f, $40, $f0, $07
    .byte $98, $40, $94, $0c, $f6, $96, $42, $8f, $42, $42, $94, $44, $91, $40, $44, $8f
    .byte $49, $47, $45, $47, $45, $44, $45, $44, $98, $42, $8f, $3a, $40, $42, $44, $45
    .byte $44, $42, $44, $49, $47, $45, $47, $45, $44, $42, $44, $42, $44, $45, $47, $91
    .byte $49, $4a, $94, $48, $47, $f2, $25, $fc, $8f, $3a, $3a, $3a, $91, $39, $8f, $39
    .byte $39, $39, $37, $37, $37, $91, $39, $8f, $39, $39, $39, $35, $35, $35, $91, $37
    .byte $8f, $37, $37, $37, $f4, $f0, $03, $f1, $02, $f8, $40, $f3, $3a, $fd, $94, $30
    .byte $30, $f3, $3a, $fd, $94, $2a, $30, $f3, $57, $fd, $f0, $00, $f5, $02, $93, $30
    .byte $8f, $30, $93, $30, $8f, $30, $0c, $30, $0c, $30, $91, $35, $37, $f6, $f5, $02
    .byte $94, $0c, $8f, $0c, $30, $30, $30, $f6, $91, $1a, $1a, $1a, $8f, $1a, $20, $0c
    .byte $20, $0c, $20, $91, $1a, $20, $f5, $02, $93, $35, $8f, $35, $94, $35, $93, $34
    .byte $8f, $35, $94, $35, $93, $35, $8f, $37, $f0, $07, $98, $37, $94, $0c, $f6, $f1
    .byte $04, $f3, $57, $fd, $f2, $d8, $fc, $8f, $35, $35, $35, $91, $35, $8f, $35, $35
    .byte $35, $34, $34, $34, $91, $35, $8f, $35, $35, $35, $32, $32, $32, $91, $34, $8f
    .byte $34, $34, $34, $f4, $f0, $07, $f1, $02, $96, $12, $8f, $0a, $12, $94, $14, $91
    .byte $10, $09, $93, $19, $1a, $91, $19, $93, $17, $95, $15, $96, $1a, $8f, $19, $17
    .byte $94, $15, $14, $96, $15, $8f, $12, $15, $91, $18, $1a, $8f, $20, $93, $19, $f4
    .byte $f0, $06, $f1, $00, $f8, $80, $f3, $07, $fe, $98, $20, $f3, $07, $fe, $94, $1a
    .byte $20, $f3, $0f, $fe, $f3, $18, $fe, $f3, $21, $fe, $f3, $2a, $fe, $f3, $0f, $fe
    .byte $f3, $18, $fe, $f3, $2a, $fe, $98, $40, $f5, $02, $8f, $29, $0c, $0c, $29, $29
    .byte $0c, $0c, $29, $0c, $29, $0c, $29, $91, $32, $34, $f6, $f5, $02, $91, $19, $8f
    .byte $1a, $93, $20, $8f, $19, $20, $f6, $94, $22, $91, $1a, $8f, $22, $24, $0c, $24
    .byte $0c, $24, $91, $20, $24, $f5, $02, $98, $25, $96, $25, $8f, $24, $22, $93, $1a
    .byte $8f, $1b, $98, $20, $8f, $20, $20, $22, $24, $f6, $f3, $0f, $fe, $f3, $18, $fe
    .byte $f3, $21, $fe, $f3, $2a, $fe, $f3, $0f, $fe, $f3, $18, $fe, $f3, $2a, $fe, $98
    .byte $20, $f2, $83, $fd, $98, $25, $25, $93, $22, $95, $24, $f4, $f5, $04, $84, $42
    .byte $83, $3a, $35, $f6, $f4, $f5, $04, $84, $44, $83, $40, $37, $f6, $f4, $f5, $04
    .byte $84, $44, $83, $40, $39, $f6, $f4, $f5, $04, $84, $45, $83, $40, $39, $f6, $f4
    .byte $f0, $01, $98, $00, $00, $00, $95, $00, $f1, $00, $8f, $09, $09, $09, $f3, $5a
    .byte $fe, $04, $f0, $01, $09, $f0, $02, $04, $f0, $01, $09, $f3, $5a, $fe, $04, $f0
    .byte $01, $09, $09, $09, $f2, $41, $fe, $f5, $03, $f0, $02, $04, $04, $f0, $01, $09
    .byte $f0, $02, $04, $f6, $f4, $f0, $06, $f8, $80, $80, $20, $40, $60, $70, $75, $70
    .byte $75, $70, $75, $f9, $f0, $06, $f8, $80, $80, $46, $56, $66, $76, $f9, $f0, $04
    .byte $f1, $01, $f8, $80, $8f, $34, $35, $f2, $88, $fe, $f0, $04, $f1, $01, $f8, $80
    .byte $8f, $37, $39, $f2, $94, $fe, $f0, $07, $f1, $08, $f8, $80, $93, $57, $50, $57
    .byte $50, $f9, $f0, $07, $f1, $08, $f8, $80, $90, $0c, $93, $54, $49, $54, $49, $f9
    .byte $f0, $06, $f1, $00, $f8, $80, $81, $6b, $67, $6a, $66, $69, $65, $68, $64, $67
    .byte $63, $66, $62, $65, $61, $64, $60, $63, $5b, $62, $5a, $61, $59, $60, $58, $5b
    .byte $57, $5a, $56, $59, $55, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a
    .byte $2b, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $40, $41, $42
    .byte $43, $44, $45, $f9, $f0, $00, $f1, $0f, $80, $01, $f9, $f0, $07, $f1, $02, $f8
    .byte $40, $90, $24, $8e, $25, $8f, $27, $24, $8e, $25, $24, $25, $27, $91, $25, $f9
    .byte $f0, $07, $f1, $03, $f8, $80, $90, $34, $8e, $35, $8f, $37, $34, $8e, $35, $34
    .byte $35, $37, $91, $35, $f9, $f0, $06, $f1, $00, $f8, $80, $91, $20, $1a, $8f, $19
    .byte $17, $91, $15, $f9, $f0, $07, $f1, $03, $f8, $80, $84, $20, $1b, $20, $23, $85
    .byte $28, $25, $28, $25, $f9, $f0, $00, $f1, $03, $f8, $40, $84, $30, $2b, $30, $33
    .byte $85, $38, $35, $38, $35, $f9, $f0, $00, $f1, $0f, $88, $00, $89, $00, $f9, $f0
    .byte $06, $f1, $00, $f8, $80, $80, $11, $12, $21, $22, $31, $32, $41, $42, $41, $40
    .byte $3b, $3a, $39, $38, $37, $36, $f9, $f0, $00, $f8, $00, $80, $0c, $f9, $f0, $00
    .byte $f8, $00, $80, $0c, $f9, $f0, $00, $f8, $00, $80, $0c, $f9, $f0, $00, $f1, $0f
    .byte $80, $00, $f9, $f3, $7a, $ff, $f9, $f3, $81, $ff, $f9, $f3, $88, $ff, $f9, $f3
    .byte $8f, $ff, $f9, $f1, $08, $f0, $00, $f8, $80, $81, $07, $12, $06, $11, $05, $10
    .byte $f2, $a6, $ff, $f1, $08, $f0, $00, $f8, $80, $81, $02, $09, $01, $08, $00, $07
    .byte $f2, $b6, $ff, $f1, $00, $f0, $06, $f8, $c0, $81, $12, $19, $11, $18, $10, $17
    .byte $f2, $c6, $ff, $f0, $00, $f1, $0f, $80, $01, $f9, $f2, $a6, $ff, $f2, $b6, $ff
    .byte $f1, $00, $f0, $06, $f8, $c0, $81, $22, $29, $21, $28, $20, $27, $f2, $e3, $ff
    .byte $f0, $00, $f1, $0f, $80, $01, $f9

; .segment "VECTORS"

; NMI = $8000, Reset = $8C00, IRQ = $00FF
    .byte $00, $80, $00, $8c, $ff, $00

; .segment "TILES"
