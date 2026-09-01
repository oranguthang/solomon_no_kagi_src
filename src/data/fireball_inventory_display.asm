; Tile mappings and reverse-copy headers for the fireball inventory HUD

.segment "PRG_FIREBALL_INVENTORY_DISPLAY_DATA"

FireballInventoryTopTileByValue:
    .byte FireballInventoryTopUnusedTile, $b0, $b1

FireballInventoryTopRowHeaderReversed:
    .byte $4a, $54, $20

FireballInventoryBottomRowHeaderReversed:
    .byte $4a, $74, $20
