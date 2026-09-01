; Item type $00-$1C handlers selected by the inline appendix dispatcher

.segment "PRG_ITEM_HANDLER_TABLE"

ItemInteractionHandlerTable:
    .addr CollectRoomKey
    .addr EnterRoomDoor
    .addr AwardBlueCrystalScore
    .addr ApplySmallFireballBottleItem
    .addr AwardType04Or06Score
    .addr ApplyRedTzoItem
    .addr AwardType04Or06Score
    .addr ApplyLargeFireballBottleItem
    .addr IncreaseInventorySlotLimit
    .addr QueueFairyItem
    .addr FinishMapTileInteraction
    .addr ApplyDoubleTimerItem
    .addr ApplyQuintupleTimerItem
    .addr SetTimerTo10000
    .addr SetTimerTo05000
    .addr ApplySmallFireballBottleItem
    .addr ApplyLargeFireballBottleItem
    .addr IncreaseInventorySlotLimit
    .addr QueueFairyItem
    .addr ApplyRedBottleKillAllEnemiesItem
    .addr FinishMapTileInteraction
    .addr ApplyBlueTzoItem
    .addr ApplyConstellationSymbolItem
    .addr ApplyConstellationSymbolItem
    .addr ApplyConstellationSymbolItem
    .addr ApplyConstellationSymbolItem
    .addr ApplySolomonSealItem
    .addr ApplySpecialItem1B
    .addr ApplySpecialItem1C

ItemInteractionHandlerCount = (* - ItemInteractionHandlerTable) / 2
.assert ItemInteractionHandlerCount = $1D, error, "item handler table must contain 29 entries"
