# Dana action threads

`src/game/dana_actions.asm` owns `$9A6D-$9C51`, three cooperative action
entries selected from context 1's scheduler table and their shared cleanup
path.

| Scheduler selector | Entry | Behavior |
| ---: | --- | --- |
| 1 | `CastOrRemoveBlock` (`$9B7A`) | target the cell in front of Dana and create or remove a block |
| 2 | `HandleDanaHeadCollision` (`$9A6D`) | inspect the two cells above Dana after a head collision |
| 3 | `CastFireballFromInventory` (`$9B05`) | consume the next two-bit fireball slot and activate the projectile |

The pointer table stores return addresses because `StartThread` installs each
value as a synthetic RTS frame. The source therefore emits each pointer as
`.addr <entry> - 1`; `make scheduler-audit` verifies the resulting addresses
and selector mapping.

## Head collision

The head-collision entry samples Dana's Y minus 8 and both map cells crossed by
the sprite width. It derives their packed `RoomMap` indices through
`ConvertPixelCoordinatesToMapIndex`, uses the sign bits of both tile values to
choose the contacted cell, and rejects the `$F8-$FF` boundary class.

For values below `$C8`, the routine sets tile bit 6 and requests a cell redraw.
The `$C8-$F7` class instead initializes the magic-spark record through
`ApplyMapTileInteractionToObject`. Both paths wait eight ticks on the standard
gameplay-delay counter before common action cleanup.

## Fireball cast

Fireball inventory is eight two-bit values packed into `$042E-$042F`. The cast
entry shifts that pair twice, moving the consumed value into the accumulator:
zero cancels the spawn, while the two nonzero encodings select the fireball
configuration written to the record at `$05A7`. Position and facing are
derived from Dana's saved action pose. After activation, the action calls
`BuildFireballInventoryDisplayUpdate` to redraw both packed-inventory HUD
rows. See `docs/fireball_inventory_display.md`.

## Block magic

The block entry computes a target cell from Dana's saved pose, direction, and
integer coordinates. A negative map value takes the removal path at `$9C02`;
a nonnegative value calls `TryCreateBlockAtMapCell`. Both operations use the
magic-spark object at `$0593`, wait on `GameplayDelayCounter`, and request
map-cell updates through `BuildAndPublishRoomMapCellUpdate`.

The NMI request path snapshots `ObjectActionOffset` and `ObjectYMotionOffset`
as `DanaSavedAction` and `DanaSavedYMotion` at `$002A-$002B`. The cast entry
stores the source action's facing bit as `FireballDirectionIndex` at `$0430`.
It also stores 2 for source actions `$10-$17` or 3 for airborne actions
`$18-$1B` in `FireballAlternateDirectionIndex` at `$0431`. These are the up
and down alternatives used by the shared path-selection collision handlers.

The shared `$9C12` continuation restores Dana's action state, horizontal
position, and byte-5 Y motion. The final `$9C3A` path filters the cached
controller bits, deactivates the magic spark, and stops scheduler context 1.
The action pairs and casting transformations are documented in
`docs/dana_action_states.md`.
