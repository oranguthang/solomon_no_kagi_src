# Unknowns and research queue

1. Map the seven remaining cooperative contexts to stable responsibilities
   (context 2 is the pause thread) and capture their switch order under low
   and high object load.
2. Prove the remaining fields of the `$14`-byte object record, assign exact
   directional meanings to collision-mask byte 11, and complete the separate
   eight-byte enemy AI record.
3. Separate code from embedded tables throughout `$8000-$FFFF`, replacing
   generated labels with evidence-backed names.
4. Locate the complete CNROM bank-selection policy and identify which rooms,
   screens, and object states consume each CHR bank.
5. Document the exact room-map dimensions and all runtime tile values beginning
   at `$0304`.
6. Identify the special-room selectors and data for Solomon Seals, Bomb Jacks,
   Tecmo Bunnies, and the Pages of Time and Space.
7. Prove timer service frequency under scheduler load and reproduce known
   timing volatility with a deterministic emulator scenario.
8. Reconstruct the sound-request consumer, command priorities, music/SFX
   pointer tables, and APU ownership.
9. Compare USA, Japan, and Europe PRG revisions without merging assumptions
   from one profile into another.
10. Resolve the remaining Dana action dependency at `$A30C`, and prove the
    exact meanings of Dana record bytes 3 and 5 plus fireball setup bytes
    `$0430-$0431`. The map interaction and cell-update dependencies are now
    documented in `docs/map_interactions.md` and
    `docs/room_map_cell_update.md`.
11. Resolve the remaining room-transition coordinate and buffer helpers at
    `$C364`, `$C3D4`, `$C2A6`, and `$C403`, then replace their raw calls from
    the now source-owned `$8EC0-$9470` pipeline.

Unknowns stay here until evidence resolves them; they are not silently removed
when a plausible name appears.
