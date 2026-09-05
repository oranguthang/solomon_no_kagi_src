# Unknowns and research queue

1. Map the seven remaining cooperative contexts to stable responsibilities
   (context 2 is the pause thread). The strict cyclic switch order and its
   load-dependent rate are now runtime-proved, but SP continuations still need
   to be tied to subsystem entry points.
2. Prove the remaining fields of the `$14`-byte object record, assign exact
   directional meanings to collision-mask byte 11, and complete the separate
   eight-byte enemy AI record.
3. Assign gameplay names to the remaining low-six-bit `RoomMap` identities
   used by hazards and special-room scripts. Geometry and the four exhaustive
   decoration/solid/immutable byte classes are now shared source contracts.
4. Identify the remaining special-room selectors and data for Bomb Jacks,
   Tecmo Bunnies, and the Pages of Time and Space.
5. Explain how `GameplayUpdateCount` compensates for missed timer-service
   frames under load and whether the displayed countdown loses real time.
6. Prove sound-command priorities and virtual-to-hardware channel stealing at
   runtime, then assign musical names only where trace evidence supports them.
7. Compare USA, Japan, and Europe PRG revisions without merging assumptions
   from one profile into another.
8. Prove the exact meanings of Dana record bytes 3 and 5 plus fireball setup
    bytes `$0430-$0431`. The former `$A30C` dependency is now reconstructed as
    the packed fireball-inventory HUD builder.

## Resolved questions

- Every PRG byte is now separated into code, data, encoded stream, padding, or
  vector by `make prg-layout-audit`; there are no generated labels or raw
  control-flow addresses left.
- The complete CNROM policy is documented in `docs/chr_bank_policy.md`.
  `make chr-bank-audit` proves the decoded 53-room bank distribution; source
  inspection accounts for reset, intro, gameplay, transition, title, and
  ending requests.
- `RoomMap` geometry is fixed by shared assembly constants: 16 columns by 14
  stored rows, with a 16x12 playable range at indices `$10-$CF` and sentinel
  rows at `$00-$0F` and `$D0-$DF`.
- Every `RoomMap` byte is structurally classified by
  `docs/room_map_tiles.md`: low six identity bits, decoration bit 6, collision
  bit 7, and the immutable `$F8-$FF` range.
- Timer-service frequency and scheduler switch rate under low and high object
  load are reproduced by the Room 1 and attract-demo runtime scenarios. The
  compensation semantics remain open as queue item 5 above.

Unknowns stay here until evidence resolves them; they are not silently removed
when a plausible name appears.
