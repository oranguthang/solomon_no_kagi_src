# Object collision response dispatcher

The complete `$87E0-$8A61` range turns the collision mask produced by
`SampleObjectRoomMapCollision` into coordinate, motion, and action changes.

`DispatchObjectCollisionResponse` first requires object state byte 0 to be at
least `$E0`. It caches action byte 3 and collision byte 11, doubles the low
nibble, and tail-dispatches through the 16-entry
`ObjectCollisionHandlerTable` at `$8806`.

| Mask | Handler address | Structure |
| ---: | ---: | --- |
| `$0/$F` | `$8826` | shared no/fully-surrounded response |
| `$1` | `$8843` | choose the smaller Y/X correction |
| `$2` | `$88A5` | mirrored X correction or shared Y path |
| `$3` | `$8982` | `$...D` Y clamp and action transition |
| `$4` | `$8949` | X correction or shared lower-Y path |
| `$5` | `$89F6` | Y-position test, then mask-7 response |
| `$6` | `$89D6` | right-surface X clamp |
| `$7` | `$89FE` | `$...D` Y plus right-surface X clamp |
| `$8` | `$88E1` | choose X correction or lower-Y response |
| `$9` | `$89B8` | left-surface X clamp |
| `$A` | `$8A0B` | Y-position test, then mask-B response |
| `$B` | `$8A13` | `$...D` Y plus left-surface X clamp |
| `$C` | `$8990` | `$...0` Y clamp and action/motion response |
| `$D` | `$8A20` | `$...0` Y plus left-surface X clamp |
| `$E` | `$8A2A` | `$...0` Y plus right-surface X clamp |

The mask-5/7 and mask-A/B pairs intentionally use shared entry tails rather
than duplicate code. The table is reconstructed with `.addr` expressions, so
these relationships are explicit and checked by byte-identical assembly.

The handlers clear the appropriate fractional/motion fields, preserve a
motion sign where required, and select new action values from `$04-$09` or
`$18-$1B`. Their exact coordinate postconditions are now source-visible.
Assigning game-facing directional names to the six collision bits remains a
runtime-trace task; handler names therefore retain the proven mask values.

`ObjectClampYCoordinateToThirteenInset` at `$8A41` is the shared lower-inset
helper. It maps every integer Y input to low nibble `$D`, clears Y fraction
byte 6, and reduces signed Y motion byte 5 to `$00` or `$80`.
