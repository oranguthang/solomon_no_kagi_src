; Flag-only handlers for item types $16-$1C

.segment "PRG_SPECIAL_ITEM_FLAGS"

SpecialItem1CGameplayFlag = $40
SpecialItem1BLowRoomFlag = $40
SpecialItem1BHighRoomFlag = $80
SpecialItem1BRoomThreshold = $1E
ConstellationCollectedFlag = $08

ApplySpecialItem1C:
    LDA #SpecialItem1CGameplayFlag
    ORA GameplayFlags
    STA GameplayFlags
    RTS

ApplySpecialItem1B:
    LDA CurrentRoomIndex
    CMP #SpecialItem1BRoomThreshold
    LDA #SpecialItem1BLowRoomFlag
    BCC StoreSpecialItem1BFlag
    ASL A

StoreSpecialItem1BFlag:
    ORA GameStateFlags
    STA GameStateFlags
    RTS

ApplySolomonSealItem:
    INC SolomonSealCount
    LDA CollectedSolomonSealFlags
    ORA CurrentRoomSolomonSealFlag
    STA CollectedSolomonSealFlags
    RTS

ApplyConstellationSymbolItem:
    LDA GameStateFlags
    ORA #ConstellationCollectedFlag
    STA GameStateFlags
    RTS
