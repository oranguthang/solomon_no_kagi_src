# Gameplay object record layout

The gameplay pool contains 21 contiguous `$14`-byte records at
`$057F-$0722`: Dana, the magic spark, the fireball, one auxiliary object, and
17 enemy objects. `ObjectRecordPointerLowTable` and
`ObjectRecordPointerHighTable` address every record and are checked by
`make enemy-pointer-audit`.

| Offset | Name | Role |
| ---: | --- | --- |
| 0 | `ObjectStateOffset` | active/lifecycle flags; values `$C0+` enter the update pipeline |
| 1 | `ObjectTypeOffset` | type-group selector plus low-two-bit variant |
| 2 | `ObjectCachedTypeOffset` | cached type used to detect definition changes |
| 3 | `ObjectActionOffset` | action selector into motion and animation definitions |
| 4 | `ObjectCachedActionOffset` | cached action used to detect definition changes |
| 5 | `ObjectYMotionOffset` | signed Y motion |
| 6 | `ObjectYFractionOffset` | fractional Y coordinate |
| 7 | `ObjectYPositionOffset` | integer Y coordinate |
| 8 | `ObjectXMotionOffset` | signed X motion |
| 9 | `ObjectXFractionOffset` | fractional X coordinate |
| 10 | `ObjectXPositionOffset` | integer X coordinate |
| 11 | `ObjectCollisionMaskOffset` | six RoomMap solidity samples |
| 12 | `ObjectAnimationCounterOffset` | current animation countdown |
| 13 | `ObjectAnimationDelayOffset` | animation countdown reload value |
| 14 | `ObjectAnimationPhaseOffset` | packed animation frame phase |
| 15 | `ObjectAnimationPointerLowOffset` | animation stream pointer low byte |
| 16 | `ObjectAnimationPointerHighOffset` | animation stream pointer high byte |
| 17 | `ObjectSpriteTile1Offset` | first 8x16 sprite tile |
| 18 | `ObjectSpriteTile2Offset` | second 8x16 sprite tile |
| 19 | `ObjectSpriteFlagsOffset` | packed attributes for both sprite halves |

The per-frame traversal independently establishes the cached type/action
contract. A change reloads motion and animation definitions; otherwise the
record proceeds directly through fixed-point integration, collision response,
and animation sequencing. Rendering copies the final Y, X, tile, and flags
fields into two OAM entries.

## Collision mask geometry

`SampleObjectRoomMapCollision` samples a two-column footprint at three nearby
Y coordinates. Duplicate cells are retained when the footprint does not cross
a 16-pixel tile boundary. The six sign tests are packed in this exact order:

| Bit | Mask | Sample coordinate |
| ---: | ---: | --- |
| 0 | `$01` | upper left: `(X-4, Y-13)` |
| 1 | `$02` | upper right: `(X+3, Y-13)` |
| 2 | `$04` | lower right: `(X+3, Y-1)` |
| 3 | `$08` | lower left: `(X-4, Y-1)` |
| 4 | `$10` | below left: `(X-4, Y)` |
| 5 | `$20` | below right: `(X+3, Y)` |

Bits 0-3 form `ObjectCollisionResponseMask` and select the 16-entry collision
handler table. For example, mask `$03` means both upper probes are solid and
uses the ceiling response; mask `$0C` means both lower probes are solid and
uses the floor response. Bits 4-5 are the immediately lower support probes;
enemy forward-path logic selects left or right according to facing, and the
mask-0/F response tests them together through `ObjectCollisionBelowMask`.

The mask records RoomMap sign-bit solidity, not tile identity. Its geometry is
therefore independent of the low-six-bit tile catalog still being researched.
