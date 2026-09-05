# Unknowns and research queue

1. Map the seven remaining cooperative contexts to stable responsibilities
   (context 2 is the pause thread). The strict cyclic switch order and its
   load-dependent rate are now runtime-proved, but SP continuations still need
   to be tied to subsystem entry points.
2. Prove the remaining fields of the `$14`-byte object record, assign exact
   directional meanings to collision-mask byte 11, and complete the separate
   eight-byte enemy AI record.
3. Locate the complete CNROM bank-selection policy and identify which rooms,
   screens, and object states consume each CHR bank.
4. Document the exact room-map dimensions and all runtime tile values beginning
   at `$0304`.
5. Identify the remaining special-room selectors and data for Bomb Jacks,
   Tecmo Bunnies, and the Pages of Time and Space.
6. Explain how `GameplayUpdateCount` compensates for missed timer-service
   frames under load and whether the displayed countdown loses real time.
7. Prove sound-command priorities and virtual-to-hardware channel stealing at
   runtime, then assign musical names only where trace evidence supports them.
8. Compare USA, Japan, and Europe PRG revisions without merging assumptions
   from one profile into another.
9. Prove the exact meanings of Dana record bytes 3 and 5 plus fireball setup
    bytes `$0430-$0431`. The former `$A30C` dependency is now reconstructed as
    the packed fireball-inventory HUD builder.

## Resolved questions

- Every PRG byte is now separated into code, data, encoded stream, padding, or
  vector by `make prg-layout-audit`; there are no generated labels or raw
  control-flow addresses left.
- Timer-service frequency and scheduler switch rate under low and high object
  load are reproduced by the Room 1 and attract-demo runtime scenarios. The
  compensation semantics remain open as queue item 6 above.

Unknowns stay here until evidence resolves them; they are not silently removed
when a plausible name appears.
