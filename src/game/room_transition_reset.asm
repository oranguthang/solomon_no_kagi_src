; Shared room-transition reset for scheduler contexts and fireball state

.segment "PRG_ROOM_TRANSITION_RESET"

RoomTransitionWorkerContext = $03
RoomTransitionGameplayFlagsMask = $BB
RoomTransitionSoundEffect = $03

ResetRoomTransitionState:
    LDX #RoomTransitionWorkerContext
    JSR ResetOtherSecondaryThreads
    LDA GameplayFlags
    AND #RoomTransitionGameplayFlagsMask
    STA GameplayFlags
    LDA #$00
    STA FireballActive
    LDY #RoomTransitionSoundEffect
    JSR AddSoundEffect
    RTS
