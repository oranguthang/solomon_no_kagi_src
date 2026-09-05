# Enemy AI record layout

The runtime enemy system has 17 eight-byte AI records at `$04F7-$057E`, in
parallel with 17 `$14`-byte object records at `$05CF-$0722`. The split pointer
tables and their arithmetic stride are machine-checked by
`make enemy-pointer-audit`.

Every byte now has a shared offset name. The last two bytes deliberately keep
multiple aliases because their role depends on the enemy family.

| Offset | Shared name | Established role |
| ---: | --- | --- |
| 0 | `EnemyAiFlagsOffset` | active bit 7 and family-specific state flags |
| 1 | `EnemyAiPhaseOffset` | independent eight-bit phase counter/state |
| 2 | `EnemyAiLifetimeLowOffset` | low byte of accumulated active lifetime |
| 3 | `EnemyAiLifetimeHighOffset` | high byte of accumulated active lifetime |
| 4 | `EnemyAiVerticalDeltaOffset` | signed half-distance component relative to Dana |
| 5 | `EnemyAiHorizontalDeltaOffset` | signed half-distance component relative to Dana |
| 6 | `EnemyAiFirstLinkedSlotOffset` / `EnemyAiPathDirectionOffset` | first child slot or current path direction |
| 7 | `EnemyAiSecondLinkedSlotOffset` / `EnemyAiAlternateDirectionOffset` | second child slot or alternate path direction |

`UpdateEnemiesMovement` processes only records whose flags byte is negative.
It consumes `GameplayUpdateCount`, adds it independently to byte 1, and adds
the same value as a 16-bit quantity to bytes 2-3. It then derives bytes 4-5
from the matching object's Y/X displacement from Dana. The phase field is
therefore not the low byte of the lifetime counter even though all three are
advanced in the same prepass.

`ApplyEnemyLifetimeThreshold` independently proves bytes 2-3 as a little-
endian pair by subtracting the room's 16-bit spawn-lifetime threshold. The
initializer clears bytes 1-3 for a newly allocated slot while preserving the
caller-supplied flags byte.

## Polymorphic tail fields

Linked-spawn families retain one or two allocated child indices in bytes 6-7.
Their cleanup and red-bottle paths read those indices through the linked-slot
aliases before deactivating the child records.

Path-following families instead store direction indices in the same bytes.
Values 0 through 3 mean right, left, up, and down. This contract is also used
by fireballs: NMI temporarily points `EnemyAiPointer` at `FireballActive`, so
`FireballDirectionIndex` and `FireballAlternateDirectionIndex` become offsets
6 and 7 of a synthetic AI record consumed by the shared path-mask handlers.

The overlapping names are intentional type-family views, not evidence that a
linked slot and a direction coexist in one record at the same time.
