# Enemy AI dispatcher

`src/game/enemy_ai_dispatch.asm` owns CPU `$A2DC-$A30B`. Bisqwit's map calls
the entry `MaybeRunAllEnemyAI`; this reconstruction uses
`RunEnemyAiDispatcher` because the routine's proven responsibility is slot
selection, while the behavior-specific work remains in `$A469`.

The dispatcher walks all 17 slots in descending order and resolves parallel AI
and object pointers through the same four split tables used by the movement
prepass. It calls `$A469` only when object byte 0 is at least `$C0` and object
byte 1 is at least `$14`. X is preserved around each potential call so the
outer slot scan remains stable.

The exact meaning of the two eligibility fields and the per-enemy handler are
still unresolved. Their numeric tests remain visible in source rather than
being assigned speculative state names.
