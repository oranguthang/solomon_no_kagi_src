# Item interactions

The source-owned item subsystem now spans CPU `$C42E-$C627`. The main gameplay
thread calls `CheckDanaMapTileInteraction` once per service cycle. It rejects
Dana action states `$1C+`, samples the `RoomMap` cell at Dana's center
coordinate `(Y+8, X+8)`, and passes the tile value to
`ClassifyDanaMapTileInteraction`.

The classifier ignores values below `$06`, value `$10`, and values `$38+`.
Tiles `$06-$24` select one of 29 item handlers. Tiles `$25-$31` use the compact
score digit/amount tables, while `$32-$37` award an extra life; tile `$32`
also adds five at score digit index 2. `ItemInteractionThreadCode` at scratch
byte `$02` is zero when no cooperative follow-up is needed, `$40` for ordinary
item presentation, `$41` for an extra life, `$34` for the key, or another code
selected by a specialized handler. The caller starts that code through
`StartThread` after classification returns.

Item tiles `$08-$24` are suppressed when `$0087` bit 0 is set. Otherwise the
classifier initializes `AuxiliaryObject` at the collected map cell before
dispatch. Key and door tiles `$06-$07` bypass that visual gate and use their
own state transitions. The exact meaning of `$0087` remains unassigned.

## Handler appendix

`ItemInteractionHandlerTable` at `$C4D3-$C50C` is an inline appendix consumed
by `JumpWithParams`. Carry is deliberately clear before `SBC #$05`, so map
tiles `$06-$24` become selectors `$00-$1E`.

| Selector | Map tile | Handler |
| ---: | ---: | --- |
| `$00` | `$06` | `CollectRoomKey` |
| `$01` | `$07` | `EnterRoomDoor` |
| `$02` | `$08` | `AwardBlueCrystalScore` |
| `$03` | `$09` | `ApplySmallFireballBottleItem` |
| `$04` | `$0A` | `AwardType04Or06Score` |
| `$05` | `$0B` | `ApplyRedTzoItem` |
| `$06` | `$0C` | `AwardType04Or06Score` |
| `$07` | `$0D` | `ApplyLargeFireballBottleItem` |
| `$08` | `$0E` | `IncreaseInventorySlotLimit` |
| `$09` | `$0F` | `QueueFairyItem` |
| `$0A` | `$10` | no effect |
| `$0B` | `$11` | `ApplyDoubleTimerItem` |
| `$0C` | `$12` | `ApplyQuintupleTimerItem` |
| `$0D` | `$13` | `SetTimerTo10000` |
| `$0E` | `$14` | `SetTimerTo05000` |
| `$0F` | `$15` | `ApplySmallFireballBottleItem` |
| `$10` | `$16` | `ApplyLargeFireballBottleItem` |
| `$11` | `$17` | `IncreaseInventorySlotLimit` |
| `$12` | `$18` | `QueueFairyItem` |
| `$13` | `$19` | `ApplyRedBottleKillAllEnemiesItem` |
| `$14` | `$1A` | no effect |
| `$15` | `$1B` | `ApplyBlueTzoItem` |
| `$16-$19` | `$1C-$1F` | `ApplyConstellationSymbolItem` |
| `$1A` | `$20` | `ApplySolomonSealItem` |
| `$1B` | `$21` | `ApplySpecialItem1B` |
| `$1C` | `$22` | `ApplySpecialItem1C` |

These selector names agree with Bisqwit's independently published item map.
The reconstruction preserves repeated pointers instead of inventing wrapper
routines for item types that intentionally share behavior.
`make item-handler-audit` independently decodes the built ROM and checks every
selector, semantic name, address, and the complete table SHA-1 against
`config/item_handlers.json`.

## Bonus and red-bottle paths

Bonus tiles `$25-$31` are grouped in threes. Repeated subtraction selects one
of five score digit indices and the within-group remainder selects amount 1,
2, or 5. The two adjacent tables at `$C710-$C717` encode those choices.

The red-bottle handler scans all 17 enemy object records. Active records with
types in `$50-$67` receive state bit 0. If at least one record changed, it
starts scheduler code `$50`; the ordinary item presentation remains queued in
`ItemInteractionThreadCode`.

## Key, door, and pool reset

`CollectRoomKey` reads the door map index from room-item header offset 5,
replaces that cell with tile `$07`, conditionally sets `GameplayFlags` bit
`$20`, queues sound `$16`, stops context 4, and selects follow-up code `$34`.

`EnterRoomDoor` deactivates Dana, resets the other secondary contexts, applies
the five-room skip flag when present, advances `CurrentRoomIndex`, and derives
special-room flag bits from the constellation flag, `SolomonSealCount`, and
room indices `$14/$2C`. Two counters at `$0084-$0085` participate in this
progression but remain unnamed pending stronger evidence. The routine clears
the key flag, resets fireball and room state, starts `RoomClearThread` through
code `$14`, and stops context 3.

`ClearGameplayObjectAndEnemyState` clears exactly 21 `$14`-byte object records
from `$057F-$0722` and all 17 eight-byte enemy AI records at `$04F7-$057E`.
The object clear is split into a 256-byte loop and a `$A4`-byte tail because a
single 8-bit Y index cannot cover the complete 420-byte pool.
