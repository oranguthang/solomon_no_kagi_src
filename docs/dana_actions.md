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
derived from Dana's saved action pose. The final initializer at `$A30C`
remains unnamed until its full range is reconstructed.

## Block magic

The block entry computes a target cell from Dana's saved pose, direction, and
integer coordinates. A negative map value takes the removal path at `$9C02`;
a nonnegative value calls `TryCreateBlockAtMapCell`. Both operations use the
magic-spark object at `$0593`, wait on `GameplayDelayCounter`, and request
map-cell updates through `BuildAndPublishRoomMapCellUpdate`.

The shared `$9C12` continuation restores Dana's action state and position. The
final `$9C3A` path filters the cached controller bits, deactivates the magic
spark, and stops scheduler context 1. Exact meanings for Dana record bytes 3
and 5 and fireball setup bytes `$0430-$0431` remain deliberately unassigned.
