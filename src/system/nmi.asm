; Vertical-blank handler, CNROM bank selection, OAM DMA, and PPU scroll commit

.segment "PRG_NMI"

NMI:
    STX NmiSavedX
    STY NmiSavedY
    PHA
    LDA PpuCtrlShadow
    AND #$7F
    TAY
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA PpuMaskShadow
    AND #$E7
    STA a:PPU_MASK
    LDX PpuScrollY
    JSR WritePpuScroll
    STY a:PPU_CTRL
    LDA #$00
    STA a:OAM_ADDR
    LDA #>OamBuffer
    STA a:OAM_DMA
    LDY #$01
    CPY PpuUpdateStreamPointer + 1
    BCS CheckRoomMapAttributeReadRequest
    JSR ExecutePpuUpdateStream

CheckRoomMapAttributeReadRequest:
    LDA GameplayFlags
    AND #GameplayFlagAttributeReadRequest
    BEQ ResetRoomMapAttributeReadState
    JSR ServiceRoomMapAttributeReadRequest
    JMP UpdateNmiChrBank

ResetRoomMapAttributeReadState:
    LDA #PpuAttributeReadIdleState
    STA PpuAttributeReadState

UpdateNmiChrBank:
    LDA $7D
    BMI _label_bank0_8055
    AND #$03
    TAX
    LDA ChrBankSelectValues,X
    STA ChrBankSelectValues,X
    LDA #$80
    STA $7D

_label_bank0_8055:
    LDA PpuMaskShadow
    STA a:PPU_MASK
    TSX
    TXA
    AND #$1F
    CMP #$08
    BCS _label_bank0_8065
    BCC NmiRestoreRegisters

_label_bank0_8065:
    JSR $8107
    LDA $78
    TAX
    AND #$02
    BNE _label_bank0_80cd
    LDA #$10
    AND Joypad1Cached
    BEQ _label_bank0_8087
    TXA
    ROR A
    BCC _label_bank0_8087
    LDA #$02
    ORA $78
    STA $78
    LDA #$21
    JSR $836F
    BPL _label_bank0_80cd

_label_bank0_8087:
    JSR $83C2
    LDX #$07

_label_bank0_808c:
    INC $20,X
    DEX
    BPL _label_bank0_808c
    JSR $81DD
    JSR UpdateActiveObjects
    INC FireballLifeCounter1Lo
    BNE _label_bank0_809f
    INC FireballLifeCounter1Hi

_label_bank0_809f:
    INC $043C
    BNE _label_bank0_80a7
    INC $043D

_label_bank0_80a7:
    LDA DanaObject
    CMP #$C0
    BCC _label_bank0_80c4
    ROR A
    BCS _label_bank0_80ca
    LDA Joypad1Cached
    ASL A
    BCC _label_bank0_80bc
    JSR $831E
    BCS _label_bank0_80ca

_label_bank0_80bc:
    ASL A
    BCC _label_bank0_80c4
    JSR $80FF
    BCS _label_bank0_80ca

_label_bank0_80c4:
    LDA #$FE
    AND $28
    STA $28

_label_bank0_80ca:
    JMP $80CF

_label_bank0_80cd:
    INC NmiFrameCounter
    JSR $84CE
    JSR ReadJoyPads
    LDA $78
    AND #$04
    BNE NmiRestoreRegisters
    JSR $F000

NmiRestoreRegisters:
    LDX NmiSavedX
    LDY NmiSavedY
    LDA PpuCtrlShadow
    ORA #$80
    STA PpuCtrlShadow
    STA a:PPU_CTRL
    PLA
    RTI

ChrBankSelectValues:
    .byte $10, $11, $12, $13

WritePpuScroll:
    LDA a:PPU_STATUS
    LDA PpuScrollX
    STA a:PPU_SCROLL
    STX a:PPU_SCROLL
    RTS
