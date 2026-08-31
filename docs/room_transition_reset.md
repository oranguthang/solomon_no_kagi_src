# Room-transition state reset

`src/game/room_transition_reset.asm` owns CPU `$C9A7-$C9BC`. Both callers are
inside the larger scene-transition flow beginning at `$C78A`.

`ResetRoomTransitionState` performs four operations:

1. keeps scheduler context 3 active while resetting the other secondary
   contexts through `ResetOtherSecondaryThreads`;
2. clears bits 6 and 2 of `GameplayFlags` with mask `$BB`;
3. clears `FireballActive`;
4. queues sound-effect command 3.

The helper exposes a repeated room-transition boundary while leaving the
surrounding animation, life handling, score comparison, and PPU work in the
preservation listing until those paths are independently understood.
