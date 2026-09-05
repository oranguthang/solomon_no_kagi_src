# Dana action-state encoding

Dana's object record uses the shared `ObjectActionOffset` byte at `$0582` as
an action-state selector. The NMI controller dispatcher divides values
`$00-$1B` by four and selects one of seven handlers; the motion and animation
loaders use the original byte as a direct table index.

Bit 0 is the facing direction throughout the controllable states. Even values
face right and odd values face left. This follows from two independent paths:
room loading chooses `$14/$15` from the high bit of Dana's initial X position,
while right/left controller input selects `$14/$15` directly. Collision and
transition paths preserve the same bit when changing action pairs.

The statically established action pairs are:

| Values | Source or transition | Motion/control role |
| ---: | --- | --- |
| `$00/$01` | Up input from a grounded state | five-tick jump startup |
| `$02/$03` | no direct producer found | reserved members of startup group 0 |
| `$04/$05` | upper-surface collision | ceiling-contact delay; queues head-collision code `$12` |
| `$06/$07` | lower-surface collision | landing recovery before returning to `$16/$17` |
| `$08/$09` | horizontal-surface collision | wall-contact recovery |
| `$0A/$0B` | no direct producer found | reserved members of collision group 2 |
| `$0C/$0D` | startup `$00/$01` after five ticks | jump ascent with Y motion `$C3` |
| `$0E/$0F` | no direct producer found | reserved members of no-control group 3 |
| `$10/$11` | Down plus horizontal input | crouched horizontal movement |
| `$12/$13` | Down without horizontal input | crouched idle |
| `$14/$15` | horizontal input | normal horizontal movement |
| `$16/$17` | no directional input | standing idle |
| `$18/$19` | airborne horizontal input | preserve Y motion and apply horizontal motion |
| `$1A/$1B` | airborne without horizontal input | preserve Y motion without horizontal motion |
| `$1C/$1D` | A/B request from `$14-$1B` | regular casting pose while context 1 owns the action |
| `$1E/$1F` | A/B request from `$10-$13` | crouched casting pose while context 1 owns the action |
| `$20/$21` | Dana-death transition | facing-preserving death fall |
| `$22/$23` | death fall reaches Y `$D1` | final death presentation |

The three unused pairs are still valid table entries, but no reconstructed
writer selects them. They remain described structurally rather than assigned
gameplay names.

## Y motion and casting scratch

Object byte 5 at `$0584` is Dana's signed Y-motion field. The shared fixed-
point integrator updates it and carries its scaled delta through byte 6 into
integer Y byte 7. Surface collision paths reduce it to a sign-only `$00` or
`$80`. Cooperative A/B actions save and restore it through `DanaSavedYMotion`;
the death path explicitly writes `$C3`. This also corrects the former local
death constants, which had the state `$C0` and Y-motion `$C3` names reversed.

`FireballDirectionIndex` at `$0430` is an exact four-way index: 0 right, 1
left, 2 up, and 3 down. NMI uses it to select the matching signed coordinate
delta and copies it into the fireball action field before collision dispatch.
The normal cast producer currently writes only 0 or 1 because Dana's source
action contributes its facing bit.

`FireballAlternateDirectionIndex` at `$0431` receives 2 (up) for source
actions `$10-$17` and 3 (down) for airborne source actions `$18-$1B`. During
fireball collision handling, `EnemyAiPointer` is temporarily aimed at
`FireballActive`, making `$0430/$0431` offsets 6/7 of a synthetic AI record.
The shared path handlers read and update them as current and alternate
directions when selecting a route around solid RoomMap cells.
