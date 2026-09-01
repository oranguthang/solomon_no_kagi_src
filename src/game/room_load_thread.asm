; Context-one new-game and room-transition loading pipeline

.segment "PRG_ROOM_LOAD_THREAD"

NewGameRoomLoadThread:
    JSR ResetNewGameState

RoomLoadThread:
    LDA #$FD
    AND RoomStateFlags
    STA RoomStateFlags
    JSR DrawRoomNametableFrame
    LDA #$30
    AND GameStateFlags
    BEQ LoadSelectedRoom
    LDX CurrentRoomIndex
    STX $0429
    LDX #$32
    CMP #$30
    BEQ StoreSpecialRoomIndex
    CMP #$20
    BCC AdvanceSpecialRoomIndex
    INX

AdvanceSpecialRoomIndex:
    INX

StoreSpecialRoomIndex:
    STX CurrentRoomIndex

LoadSelectedRoom:
    JSR InitializeRoomBlockMap
    LDA #$60
    JSR StartThread
    LDA #$00
    STA $7E
    STA $7F
    JSR QueueStaticPpuUpdateStream
    LDA #$01
    JSR QueueStaticPpuUpdateStream
    JSR RefreshGameplayHud
    JSR PrepareRoomIntro
    JSR ResetAndSelectGameplayDelayCounter
    LDA #$80
    JSR WaitForZeroPageCounterAboveThreshold
    LDA #$00
    STA MagicSparkObject + ObjectStateOffset
    JSR Clear30x24NametableRegion
    JSR LoadRoomItemsAndMetadata
    LDA #$02
    ORA RoomStateFlags
    STA RoomStateFlags
    JSR PublishRoomDoorAndKeyUpdates
    JSR ResetAndSelectGameplayDelayCounter
    LDA #$40
    JSR WaitForZeroPageCounterAboveThreshold
    JSR RunRoomEntryAnimation
    LDA #$20
    AND GameplayFlags
    BEQ LoadRoomEnemyStream
    JSR $C2A6

LoadRoomEnemyStream:
    JSR LoadRoomEnemies
    LDA #$AF
    AND GameplayFlags
    STA GameplayFlags
    JSR DrawRoomMapToNametable

WaitForRoomMapTransfer:
    LDA PpuUpdateStreamPointer + 1
    BNE WaitForRoomMapTransfer
    LDX #$12

CopyRoomPaletteTemplate:
    LDA RoomLoadPaletteTemplate,X
    STA PpuUpdateBuffer,X
    DEX
    BPL CopyRoomPaletteTemplate
    LDX CurrentRoomIndex
    LDA #$30
    AND GameStateFlags
    BEQ SelectRoomPaletteGroup
    LDY $0429
    STY CurrentRoomIndex
    DEY
    CMP #$30
    BNE SelectRoomPaletteGroup
    TYA
    TAX

SelectRoomPaletteGroup:
    TXA
    LSR A
    LSR A
    TAX
    LDA RoomPaletteColorByRoomGroup,X
    BPL ApplyRoomPaletteColor
    LDA #$16
    STA PpuUpdateBuffer + $0D
    LDA #$00

ApplyRoomPaletteColor:
    LDX #$03

ApplyRoomPaletteColorCopies:
    LDY RoomPaletteColorOffsets,X
    STA PpuUpdateBuffer + $03,Y
    DEX
    BPL ApplyRoomPaletteColorCopies
    INX
    STX PpuUpdateBuffer + $13
    LDA #$4F
    STA PpuUpdateBuffer + $02
    JSR PublishPpuUpdateBuffer
    LDA #$C7
    AND GameStateFlags
    STA GameStateFlags
    LDA DanaXPosition
    ROL A
    LDA #$0A
    ROL A
    LDY #ObjectActionOffset

InitializeDanaForLoadedRoom:
    STA DanaObject,Y
    LDA RoomLoadDanaHeaderPredecessors,Y
    DEY
    BPL InitializeDanaForLoadedRoom
    INY
    STY MagicSparkObject + ObjectStateOffset
    LDA GameStateFlags
    ROR A
    BCC StartLoadedRoomGameplay
    INY
    LDA $0429
    BEQ SelectRoomEntrySound
    INY

SelectRoomEntrySound:
    JSR AddSoundEffect

StartLoadedRoomGameplay:
    LDA #$30
    JSR StartThread
    LDA #$01
    JSR StopThread
