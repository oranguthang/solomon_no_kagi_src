# RoomMap tile byte contract

Each of the 224 `RoomMap` cells stores one byte. The room decoder, collision
samplers, full renderer, item dispatcher, and block-magic paths establish a
shared structural encoding even where a creature or hazard name is not yet
known.

## Bit fields and ranges

`RoomMapTileIdentityMask` (`$3F`) preserves the low-six-bit identity.
`RoomMapDecorationBit` (`$40`) and `RoomMapSolidBit` (`$80`) are independent
class bits until the immutable range begins at `$F8`.

| Runtime value | Collision | Initial full-room pattern |
| ---: | --- | ---: |
| `$00-$3F` | passable | the value itself |
| `$40-$7F` | passable | `$10` |
| `$80-$F7` | solid | `$00` |
| `$F8-$FF` | solid and immutable to map interaction | `$03` |

`SampleObjectRoomMapCollision` and `BuildFireballRoomCollisionMask` test the
sign bit only, proving that `RoomMapSolidBit` is the collision bit. The
full-room renderer applies the four ranges above before indexing the 58-record
`RoomTilePatternTable`. Incremental redraws receive a logical pattern value
already selected by their caller.

## Interaction normalization

`ApplyMapTileInteractionToObject` leaves `$F8-$FF` unchanged. For every lower
value it stores `value & RoomMapTileIdentityMask` back into `RoomMap`. This
removes both class bits and exposes the underlying identity after a block or
concealment interaction. Its effect object retains the original byte long
enough to choose direction, coordinates, and action.

The fixed block planes make the encoding concrete:

- empty interior is `$10`;
- a brown/breakable block is `$90` (`RoomMapSolidBit | $10`);
- a white block and both boundary rows use immutable sentinel `$F8`.

The item decoder uses the same low-six-bit mask when deciding whether an
encoded item is ordinary or conditional. Key `$06`, door `$07`, Demon Mirror
`$05`, hidden-key variants `$46/$86`, and no-key door `$35` all therefore
share this byte contract.

## Exposed item identities

`ClassifyDanaMapTileInteraction` gives a complete range-level contract for
exposed values:

- below `$06`, `$10`, and `$38+` do not enter item dispatch;
- `$06-$22` select the 29-entry item handler table, with `$10` explicitly
  ignored;
- `$25-$31` select score bonuses in five three-value groups;
- `$32-$37` award an extra life, with `$32` also awarding score.

Exact names for the remaining non-item identities are deliberately deferred.
Their numeric values stay visible in hazard and special-room code until static
or runtime evidence supports stronger names.
