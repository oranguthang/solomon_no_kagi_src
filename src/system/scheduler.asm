; Eight-context cooperative scheduler and its initial stack/entry tables

.segment "PRG_SCHEDULER"

StartThread:
    STA $00
    LSR A
    LSR A
    LSR A
    LSR A
    STA $01
    TAY
    LDA #$00
    SEC

BuildThreadMask:
    ROL A
    DEY
    BPL BuildThreadMask
    ORA ActiveThreadMask
    STA ActiveThreadMask
    LDY $01
    LDX InitialThreadStackPointers,Y
    STX ThreadStackPointers,Y
    INX
    STX $02
    LDX #$01
    STX $03
    LDA $01
    ASL A
    TAY
    LDA $00
    AND #$0F
    ASL A
    STA $04
    LDA ThreadEntryTableBases,Y
    ADC $04
    STA $04
    LDA ThreadEntryTableBases+1,Y
    ADC #$00
    STA $05
    LDY #$00

CopyThreadEntryAddress:
    LDA ($04),Y
    STA ($02),Y
    INY
    CPY #$02
    BNE CopyThreadEntryAddress
    LDA $00
    STA ($02),Y
    LDY $01
    CPY ThreadIndex
    BNE FinishStartThread
    BEQ SelectThreadContext

SwitchThreads:
    TSX
    LDY ThreadIndex
    STX ThreadStackPointers,Y
    LDY ThreadIndex
    INY
    TYA
    AND #$07
    STA ThreadIndex
    TAY

SelectThreadContext:
    LDX ThreadStackPointers,Y
    TXS

FinishStartThread:
    SEC
    RTS

StopThread:
    TAX
    LDA InitialThreadStackPointers,X
    STA ThreadStackPointers,X
    STA $00
    STA $02
    INC $00
    LDY #$01
    STY $01
    LDA #>(IdleThreadLoop - 1)
    STA ($00),Y
    DEY
    LDA #<(IdleThreadLoop - 1)
    STA ($00),Y
    TXA
    CMP ThreadIndex
    BNE StopOtherThread
    LDX $02
    TXS

StopOtherThread:
    TAX
    LDA #$FF
    CLC

BuildInactiveThreadMask:
    ROL A
    DEX
    BPL BuildInactiveThreadMask
    AND ActiveThreadMask
    STA ActiveThreadMask
    SEC
    RTS

IdleThreadLoop:
    JSR SwitchThreads
    BCS IdleThreadLoop

InitialThreadStackPointers:
    .byte $fc, $dc, $bc, $9c, $7c, $5c, $3c, $1c

ThreadEntryTableBases:
    .byte $17, $8e, $17, $8e, $29, $8e, $2f, $8e
    .byte $3b, $8e, $43, $8e, $45, $8e
    .addr NewGameRoomLoadThread - 1
    .addr CastOrRemoveBlock - 1
    .addr HandleDanaHeadCollision - 1
    .addr CastFireballFromInventory - 1
    .addr RoomClearThread - 1
    .addr RoomLoadThread - 1
    .addr PreparePostGameResult - 1
    .addr RunPostGameAttractThread - 1
    .addr StartDemoPlayback - 1
    .byte $9e, $8e
    .addr PauseGameThread - 1
    .addr RunDemoInputPlayback - 1
    .byte $ff, $9f
    .addr RunDanaDeathTransition - 1
    .byte $86, $c5
    .addr RunTimeOverTransition - 1
    .addr RunKeyCollectionPresentation - 1
    .addr FinalizeGameplayExit - 1
    .addr RunMapItemPresentation - 1
    .addr RunExtraLifeMapItemPresentation - 1
    .addr RunEnemyItemPresentation - 1
    .addr RunExtraLifeEnemyItemPresentation - 1
    .addr ProcessDefeatedEnemyDrops - 1
    .addr RunSpecialRoomScriptThread - 1
