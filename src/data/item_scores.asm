; Score digit and amount lookup tables used by collectible bonus items

.segment "PRG_ITEM_SCORE_TABLES"

ItemBonusScoreDigitIndices:
    .byte $05, $04, $03, $02, $01

ItemBonusScoreAmounts:
    .byte $01, $02, $05

.assert ItemBonusScoreAmounts - ItemBonusScoreDigitIndices = 5, error, "item score digit table must contain five entries"
.assert * - ItemBonusScoreAmounts = 3, error, "item score amount table must contain three entries"
