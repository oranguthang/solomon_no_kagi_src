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
    JSR AwardExtraLifeFromMapTile
    LDA #ExtraLifeEnemyInteractionThread
    JSR StartThread
    JMP DeactivateCurrentEnemy

_label_bank0_a581:
    JSR $A5A3

_label_bank0_a584:
    LDA #EnemyItemInteractionThread
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
    JSR AdvanceRandomState
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
    LDA #EnemyItemInteractionThread
    CPX #$0A
    BCC _label_bank0_a8ab
    INC $86
    JSR LoadCurrentEnemyPosition
    JSR SpawnAuxiliaryEffectAtCoordinates
    JSR AwardExtraLifeFromMapTile
    LDX #$00
    LDA #ExtraLifeEnemyInteractionThread

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

.segment "PRG_DATA_BEFORE_ROOM_TILE_PATTERNS"

    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $04, $ff, $00
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
    .byte $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00

.segment "PRG_POST_ROOM_ITEM_DATA"

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
