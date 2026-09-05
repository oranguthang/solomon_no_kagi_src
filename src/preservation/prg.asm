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
