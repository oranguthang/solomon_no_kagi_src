; Red-bottle effect that marks every eligible enemy for retirement

.segment "PRG_RED_BOTTLE_ITEM"

RedBottleEnemyStateMinimum = $C0
RedBottleEnemyTypeBase = $50
RedBottleEnemyTypeCount = $18
RedBottleThreadCode = $50

ApplyRedBottleKillAllEnemiesItem:
    LDX #EnemyObjectCount - 1

CheckNextRedBottleEnemy:
    TXA
    JSR LoadEnemyObjectPointer
    LDY #ObjectStateOffset
    LDA (TempPointer00),Y
    CMP #RedBottleEnemyStateMinimum
    BCC AdvanceRedBottleEnemy
    INY
    LDA (TempPointer00),Y
    SBC #RedBottleEnemyTypeBase
    CMP #RedBottleEnemyTypeCount
    BCS AdvanceRedBottleEnemy
    TYA
    DEY
    ORA (TempPointer00),Y
    STA (TempPointer00),Y
    STY ItemInteractionThreadCode

AdvanceRedBottleEnemy:
    DEX
    BPL CheckNextRedBottleEnemy
    LDA ItemInteractionThreadCode
    BNE FinishRedBottleItem
    LDA #RedBottleThreadCode
    JSR StartThread
    LDA #InventoryItemInteractionThread
    STA ItemInteractionThreadCode

FinishRedBottleItem:
    RTS
