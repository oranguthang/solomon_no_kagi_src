; Reveal the room door after collecting the key

.segment "PRG_KEY_ITEM"

RoomDoorPositionOffset = $05
OpenDoorTile = $07
KeyCollectedGameplayFlag = $20
KeyCollectedSound = $16
KeyObjectThreadIndex = $04
KeyInteractionThreadCode = $34

CollectRoomKey:
    LDY #RoomDoorPositionOffset
    LDA (RoomItemPointer),Y
    TAY
    LDA #OpenDoorTile
    STA RoomMap,Y
    LDA FireballState
    BNE QueueKeyCollectedSound
    LDA #KeyCollectedGameplayFlag
    ORA GameplayFlags
    STA GameplayFlags

QueueKeyCollectedSound:
    LDY #KeyCollectedSound
    JSR AddSoundEffect
    LDA #KeyObjectThreadIndex
    JSR StopThread
    LDA #KeyInteractionThreadCode
    STA ItemInteractionThreadCode
    RTS
