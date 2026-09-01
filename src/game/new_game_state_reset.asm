; Establish the persistent counters and flags for a new game

.segment "PRG_NEW_GAME_STATE_RESET"

ResetNewGameState:
    LDA #$00
    STA CurrentRoomIndex
    STA InventorySlotsLow
    STA $0430
    LDX #$03
    STX RemainingLives
    STX InventorySlotCount
    INX

ClearNewGameStateFlags:
    STA GameStateFlags,X
    DEX
    BNE ClearNewGameStateFlags
    LDX #$08

ClearNewGameScoreDigits:
    STA ScoreDigits - 1,X
    DEX
    BNE ClearNewGameScoreDigits
    INX
    STX GameStateFlags
    STX $80
    STX FireballLifetimeHi
    RTS
