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
encoded item is ordinary or conditional. Key `$06`, open door `$07`, Demon
Mirror `$05`, hidden key `$46`, and embedded key `$86` all therefore share
this byte contract. The shared source constants build `$46/$86` from key
identity `$06` plus the decoration or solid bit.

## Identities written by room setup and scripts

These identities have both a producer and an independently described visual
in the bundled `skchain` reference:

| Identity | Source name | Producer or use |
| ---: | --- | --- |
| `$02` | `RoomMapClosedDoorIdentity` | initial closed door and ending-room door |
| `$04` | `RoomMapBatSymbolIdentity` | room 20 special bitplane |
| `$05` | `RoomMapDemonMirrorIdentity` | both room Demon Mirror positions |
| `$06` | `RoomMapKeyIdentity` | visible, hidden `$46`, or embedded `$86` key |
| `$07` | `RoomMapOpenDoorIdentity` | unlocked door |
| `$10` | `RoomMapEmptyIdentity` | empty interior and cleared item cell |
| `$20` | `RoomMapSolomonSealIdentity` | hidden Seal is encoded as `$60` |
| `$21` | `RoomMapSolomonPageIdentity` | Page of Time or Page of Space |
| `$22` | `RoomMapGoldenWingsIdentity` | five-room skip item |
| `$27` | `RoomMapBlueOpalIdentity` | room 30 special bitplane and score bonus |
| `$32` | `RoomMapTecmoBunnyRewardIdentity` | Bunny reward; score plus extra life |
| `$35` | `RoomMapDeferredDoorIdentity` | placeholder when header key position is zero |

The only stock rooms with a zero key position are internal room 48 (Princess)
and room 49 (Solomon ending). Their scripts replace the placeholder map state;
`$35` is therefore named for its loader role rather than the generic extra-life
classification that would apply if Dana collected it as an ordinary exposed
cell.

Special-room scripts also write the encoded structural values
`RoomMapBrownBlock` (`$90`), `RoomMapWhiteBlock` (`$F8`), and
`RoomMapHiddenSolomonSeal` (`$60`). These are combinations of the shared
identity and class constants, not additional low-six-bit identities.

## Exposed item identities

`ClassifyDanaMapTileInteraction` gives a complete range-level contract for
exposed values:

- below `$06`, `$10`, and `$38+` do not enter item dispatch;
- `$06-$22` safely select the 29-entry item handler table, with `$10`
  explicitly ignored;
- `$23-$24` pass the original range check but index beyond that table into the
  following code bytes; neither identity occurs in the stock room streams;
- `$25-$31` select score bonuses in five three-value groups;
- `$32-$37` award an extra life, with `$32` also awarding score.

The safe handler-backed identities are:

| Identity | Visual name | Gameplay effect |
| ---: | --- | --- |
| `$08` | blue diamond | 500 points |
| `$09` | blue fire jar | small fireball inventory |
| `$0A` | gold double coin | 2,000 points |
| `$0B` | orange jewels / red Tzo | extend fireball lifetime |
| `$0C` | orange diamond | 2,000 points |
| `$0D` | orange fire jar | large fireball inventory |
| `$0E` | scroll | increase inventory capacity |
| `$0F` | bell | queue a fairy |
| `$11` | half time bottle | double timer rate and remaining time |
| `$12` | full time bottle | quintuple timer rate and remaining time |
| `$13` | blue hourglass | set timer to 10,000 |
| `$14` | orange hourglass | set timer to 5,000 |
| `$15` | blue fire jar | small fireball inventory |
| `$16` | orange fire jar | large fireball inventory |
| `$17` | scroll | increase inventory capacity |
| `$18` | bell | queue a fairy |
| `$19` | explosion jar | retire all eligible enemies |
| `$1A` | blue key | intentionally no effect |
| `$1B` | blue jewels / blue Tzo | 200 points and fireball lifetime |
| `$1C-$1F` | four constellation shrines | set the constellation flag |
| `$20` | Solomon's Seal | record the room's Seal |
| `$21` | Egyptian head | record the room-selected Solomon page |
| `$22` | warp item | grant the Golden Wings room skip |

The visual names come from the checked-in `skchain` item catalog. The gameplay
column comes from this reconstruction's handler table and handler bodies;
where the two vocabularies differ, source symbols use the proven gameplay
effect.

## Block-magic and head-hit thresholds

`TryCreateBlockAtMapCell` treats `$08-$0F` as two modifiable four-item groups.
Repeated casts advance the low two identity bits and wrap within `$08-$0B` or
`$0C-$0F`. Values below `$08` reject the cast, `$10-$37` other than empty
`$10` remain unchanged, and `$38+` may be replaced by a new block after the
object-overlap checks.

An item embedded in a brown block starts with the solid bit set. Dana's first
head hit adds the decoration bit; handler threshold
`RoomMapRevealedEmbeddedItemMinimum` (`$C8`) therefore means both class bits
plus the first modifiable item identity `$08`. A later interaction removes the
two class bits and exposes the underlying item. `$C8` is a class threshold,
not another identity.

## Presentation-only pattern values

`RoomMapUpdateTile` is a logical pattern input to incremental rendering; it is
not always copied into `RoomMap`. The Tecmo Bunny script first publishes
pattern `$38`, later stores reward identity `$32` in `RoomMap`, and publishes
the final orange Bunny pattern `$39`. Likewise, head collision publishes
covered-block pattern `$01`, and key flight publishes door-transition pattern
`$34` without changing the stored identity at those points. These values must
not be interpreted as additional runtime map identities merely because they
index `RoomTilePatternTable`.
