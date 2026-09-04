; Packed title graphics and current/best result presentation

.segment "PRG_TITLE_SCREEN"

PackedTitleColumnLimit = $40
PackedTitleRowLimit = $60
PackedTitleTerminator = $7F
PackedTitleRowDeltaMask = $1F
PackedTitleAddressHighMask = $2B
PackedTitleAddressLowMask = $C0
PackedTitleAddressBase = $20
PackedTitleAddressBias = $10
TitleRecordAddressHigh = $2B
TitleRecordAddressLow = $C9
TitleRecordTailSize = $15
TitleFirstPpuStream = $09
TitlePpuStreamEnd = $0C
TitleLogoPpuStream = $05
TitleBestScoreDigitCount = $07
TitlePpuWaitMask = $FF
TitlePpuWaitAddress = PpuUpdateStreamPointer + 1
TitleBlankDigit = $24
TitleLogoPatternAddressHigh = $2B
TitleLogoPatternAddressLow = $80
TitleLogoPatternFirstTile = $DF
TitleLogoPatternSecondTile = $DE
TitleLogoPatternPairCount = $10
TitleLogoFillAddressLow = $F8
TitleLogoFillTile = $F5
TitleLogoFillCount = $08
TitleLogoAccentAddressLow = $EA
TitleLogoAccentTile = $CF
TitleLogoAttributeAddressLow = $F0
TitleLogoAttributeSize = $07

PackedTitleColumn = TempPointer02
PackedTitleRow = TempPointer02 + 1

; Decode a command/literal stream addressed by TempPointer00 directly into
; the nametables. Negative bytes are literal tiles; positive bytes update the
; logical column/row cursor or terminate the stream
RenderPackedTitleData:
    LDY a:PPU_STATUS
    LDY #$00
    STY PackedTitleColumn
    STY PackedTitleRow
    DEY

ReadPackedTitleCommand:
    INY
    LDA (TempPointer00),Y
    BMI SetPackedTitlePpuAddress

AdvancePackedTitlePointer:
    TAX
    TYA
    CLC
    ADC TempPointer00
    STA TempPointer00
    BCC DecodePackedTitleCommand
    INC TempPointer00 + 1

DecodePackedTitleCommand:
    LDY #$00
    TXA
    CPX #PackedTitleColumnLimit
    BCC SetPackedTitleColumn
    CPX #PackedTitleRowLimit
    BCC SetPackedTitleRow
    INX
    BPL AddPackedTitleRowDelta
    LDX a:PPU_STATUS
    RTS

AddPackedTitleRowDelta:
    AND #PackedTitleRowDeltaMask
    ADC PackedTitleRow
    STA PackedTitleRow
    BPL ReadPackedTitleCommand

SetPackedTitleRow:
    STA PackedTitleRow
    BPL ReadPackedTitleCommand

SetPackedTitleColumn:
    STA PackedTitleColumn
    BCC ReadPackedTitleCommand

; Convert the logical cursor into a physical nametable address. The rotation
; carries the row's nametable bits into the high two bits of the low byte
SetPackedTitlePpuAddress:
    LDX PackedTitleRow
    TXA
    CLC
    ADC #PackedTitleAddressBias
    LSR A
    LSR A
    AND #PackedTitleAddressHighMask
    ORA #PackedTitleAddressBase
    STA a:PPU_ADDR
    TXA
    ROR A
    ROR A
    ROR A
    AND #PackedTitleAddressLowMask
    ORA PackedTitleColumn
    STA a:PPU_ADDR
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    DEY

WritePackedTitleLiterals:
    INY
    LDA (TempPointer00),Y
    BPL AdvancePackedTitlePointer
    STA a:PPU_DATA
    BMI WritePackedTitleLiterals

; Render the record/background layer, then publish current score, best score,
; and best GDV through the normal buffered PPU update path
DrawTitleRecordLayer:
    JSR BeginDirectPpuTransfer
    LDA #<TitleRecordPackedData
    STA TempPointer00
    LDA #>TitleRecordPackedData
    STA TempPointer00 + 1
    JSR RenderPackedTitleData
    LDY #$2F
    LDA #TitleRecordAddressHigh
    LDX #TitleRecordAddressLow
    JSR SetPpuAddressAX
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDY #TitleRecordTailSize - 1

WriteTitleRecordTail:
    LDA TitleRecordTailTiles,Y
    STA a:PPU_DATA
    DEY
    BPL WriteTitleRecordTail
    LDX a:PPU_STATUS
    JSR EndDirectPpuTransfer
    LDX #TitleFirstPpuStream

QueueNextTitlePpuStream:
    TXA
    JSR QueueStaticPpuUpdateStream
    INX
    CPX #TitlePpuStreamEnd
    BCC QueueNextTitlePpuStream
    JSR BuildScoreDisplayUpdate
    LDX #$02

CopyCurrentScoreHeader:
    LDA TitleCurrentScorePpuHeader,X
    STA PpuUpdateBuffer,X
    DEX
    BPL CopyCurrentScoreHeader
    JSR PublishPpuUpdateBuffer
    LDA #TitlePpuWaitMask
    LDX #TitlePpuWaitAddress
    JSR WaitForMaskedBitsClear
    LDX #$02

CopyBestScoreHeader:
    LDA TitleBestScorePpuHeader,X
    STA PpuUpdateBuffer,X
    DEX
    BPL CopyBestScoreHeader
    CLC
    LDY #TitleBestScoreDigitCount
    LDX #$00

FormatBestScoreDigits:
    LDA BestScoreDigits,X
    BNE MarkBestScoreNonzero
    BCS StoreBestScoreDigit
    LDA #TitleBlankDigit
    BPL StoreBestScoreDigit

MarkBestScoreNonzero:
    SEC

StoreBestScoreDigit:
    STA PpuUpdateBuffer + 3,X
    INX
    DEY
    BNE FormatBestScoreDigits
    STY PpuUpdateBuffer + 10
    STY PpuUpdateBuffer + 11
    JSR PublishPpuUpdateBuffer
    LDA #TitlePpuWaitMask
    LDX #TitlePpuWaitAddress
    JSR WaitForMaskedBitsClear
    LDX BestGdvValue
    JSR FormatTwoDigitNumberTiles
    STX PpuUpdateBuffer + 3
    STA PpuUpdateBuffer + 4
    LDX #$02

CopyBestGdvHeader:
    LDA TitleBestGdvPpuHeader,X
    STA PpuUpdateBuffer,X
    DEX
    BPL CopyBestGdvHeader
    INX
    STX PpuUpdateBuffer + 5
    JMP PublishPpuUpdateBuffer

TitleRecordTailTiles:
    .byte $F5, $F5, $F5, $F5
    .byte $F7, $FF, $FF, $FF
    .byte $56, $5A, $5A, $5A
    .byte $77, $FF, $FF, $FF
    .byte $6F, $AF, $AF, $AF, $7F

TitleCurrentScorePpuHeader:
    .byte $28, $80, $47

TitleBestScorePpuHeader:
    .byte $28, $8B, $47

TitleBestGdvPpuHeader:
    .byte $28, $98, $41

; Wait for vblank, render the logo layer, and write its fixed tile/attribute
; patterns before the record/background layer is drawn by the caller
DrawTitleLogoLayer:
    LDA a:PPU_STATUS
    BPL DrawTitleLogoLayer
    LDA #TitleLogoPpuStream
    JSR QueueStaticPpuUpdateStream
    JSR BeginDirectPpuTransfer
    LDA #<TitleLogoPackedData
    STA TempPointer00
    LDA #>TitleLogoPackedData
    STA TempPointer00 + 1
    JSR RenderPackedTitleData
    LDA #TitleLogoPatternAddressHigh
    LDX #TitleLogoPatternAddressLow
    JSR SetPpuAddressAX
    LDA PpuCtrlShadow
    STA a:PPU_CTRL
    LDA #TitleLogoPatternFirstTile
    LDY #TitleLogoPatternSecondTile
    LDX #TitleLogoPatternPairCount - 1

WriteTitleLogoPattern:
    STA a:PPU_DATA
    STY a:PPU_DATA
    DEX
    BPL WriteTitleLogoPattern
    LDX a:PPU_STATUS
    LDA #TitleLogoPatternAddressHigh
    LDX #TitleLogoFillAddressLow
    JSR SetPpuAddressAX
    LDX PpuCtrlShadow
    STX a:PPU_CTRL
    LDY #TitleLogoFillTile
    LDX #TitleLogoFillCount

WriteTitleLogoFill:
    STY a:PPU_DATA
    DEX
    BNE WriteTitleLogoFill
    LDX a:PPU_STATUS
    LDA #TitleLogoPatternAddressHigh
    LDX #TitleLogoAccentAddressLow
    JSR SetPpuAddressAX
    LDX PpuCtrlShadow
    STX a:PPU_CTRL
    LDX #TitleLogoAccentTile
    STX a:PPU_DATA
    LDX #TitleLogoAttributeAddressLow
    JSR SetPpuAddressAX
    LDX PpuCtrlShadow
    STX a:PPU_CTRL
    LDX #TitleLogoAttributeSize - 1

WriteTitleLogoAttributes:
    LDA TitleLogoAttributeBytes,X
    STA a:PPU_DATA
    DEX
    BPL WriteTitleLogoAttributes
    LDX a:PPU_STATUS
    JMP EndDirectPpuTransfer

TitleLogoAttributeBytes:
    .byte $3F, $CC, $CC, $00, $CC, $FF, $3F

.assert DrawTitleRecordLayer - RenderPackedTitleData = $67, error, "unexpected packed title decoder size"
.assert TitleRecordTailTiles - DrawTitleRecordLayer = $A2, error, "unexpected title record layer size"
.assert DrawTitleLogoLayer - TitleRecordTailTiles = $1E, error, "unexpected title record data size"
.assert TitleLogoAttributeBytes - DrawTitleLogoLayer = $7F, error, "unexpected title logo layer size"
.assert * - RenderPackedTitleData = $1AD, error, "unexpected title screen block size"

.segment "PRG_TITLE_PACKED_DATA"

TitleRecordPackedData:
    .byte $53, $06, $E8, $8F
    .byte $8E, $8E, $8F, $8E, $8E, $8F, $8E, $8E, $8F, $8E, $8E, $8E, $8E, $8F, $8F, $EA
    .byte $60, $EA, $E0, $82, $83, $86, $87, $92, $93, $96, $97, $AE, $AF, $BA, $BB, $BE
    .byte $BF, $D1, $EA, $60, $EA, $D1, $D1, $D1, $D1, $E3, $E6, $E7, $F2, $F3, $F6, $F7
    .byte $9A, $D1, $D1, $D1, $D1, $EA, $60, $EA, $D1, $D1, $D1, $D1, $EB, $EE, $EF, $FA
    .byte $FB, $FE, $FF, $A9, $D1, $9E, $9F, $D1, $EA, $53, $26, $EA, $D1, $80, $81, $84
    .byte $85, $90, $91, $94, $95, $AC, $AD, $B8, $B9, $BC, $BD, $D1, $EA, $60, $E8, $E2
    .byte $88, $89, $8C, $E1, $E4, $E5, $F0, $F1, $F4, $F5, $8D, $99, $8A, $8B, $D1, $EA
    .byte $60, $EA, $D1, $D1, $D1, $D1, $E9, $EC, $ED, $F8, $F9, $FC, $FD, $9B, $D1, $D1
    .byte $D1, $D1, $EA, $60, $EA, $9C, $9C, $9D, $9C, $9C, $9D, $9C, $9C, $9C, $9C, $9C
    .byte $9C, $9D, $9C, $9D, $9D, $EA, PackedTitleTerminator

TitleLogoPackedData:
    .byte $59, $26, $D7, $D4, $D6, $D1, $D1, $D5, $D7
    .byte $D5, $D7, $D1, $D1, $D5, $D7, $D5, $D7, $D4, $D6, $5A, $05, $DD, $C5, $C5, $D0
    .byte $D6, $D5, $C5, $DC, $D3, $D3, $D6, $D4, $C5, $DC, $D0, $D3, $C5, $D3, $D6, $D7
    .byte $23, $D5, $D7, $D4, $D3, $C7, $C6, $C7, $C6, $C7, $C6, $D3, $C6, $C7, $C6, $D3
    .byte $C6, $D2, $DC, $C7, $C6, $D3, $D3, $D6, $5B, $02, $DD, $C5, $C4, $D0, $D3, $C5
    .byte $C0, $C1, $C4, $C5, $C4, $C5, $C4, $C5, $C4, $C5, $C4, $D0, $D3, $D0, $D3, $D0
    .byte $C6, $D3, $D7, $22, $D4, $C7, $C6, $D3, $C6, $C7, $C2, $C3, $C6, $C7, $C6, $C7
    .byte $C6, $C7, $C6, $C7, $C6, $D2, $DC, $D2, $DC, $D2, $DC, $DC, $D3, $D6, $5C, $01
    .byte $D5, $C4, $C5, $C4, $D0, $C4, $C5, $C0, $C1, $C4, $C5, $C8, $C9, $CC, $CD, $D8
    .byte $D9, $C4, $C5, $C0, $C1, $D0, $D0, $D3, $D0, $D3, $D0, $D7, $20, $D4, $C7, $C6
    .byte $C7, $D3, $C7, $C6, $C7, $C2, $C3, $C6, $C7, $CA, $CB, $CE, $CF, $DA, $DB, $C6
    .byte $C7, $C2, $C3, $D3, $D2, $DC, $D2, $DC, $D2, $D3, $D6, $60, $C6, $C7, $C2, $C3
    .byte $D3, $C7, $C6, $C7, $C2, $C3, $C6, $C7, $CA, $A8, $A8, $A8, $A8, $DB, $C6, $C7
    .byte $C2, $C3, $D3, $D2, $DC, $D2, $C2, $C3, $D3, $D2, $D3, $C7, $00, $C4, $C5, $C0
    .byte $C1, $D0, $C5, $C4, $C5, $C0, $C1, $C4, $C5, $C8, $A8, $A8, $A8, $A8, $D9, $C4
    .byte $C5, $C0, $C1, $D0, $D0, $D3, $D0, $C0, $C1, $D0, $D0, $D7, $C5, PackedTitleTerminator

.assert TitleLogoPackedData - TitleRecordPackedData = $9B, error, "unexpected title record packed size"
.assert * - TitleLogoPackedData = $F7, error, "unexpected title logo packed size"
