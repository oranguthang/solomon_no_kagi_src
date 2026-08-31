# Enemy movement prepass

`src/game/enemy_movement.asm` owns CPU `$A274-$A2DB`. Bisqwit's map identifies
the entry as `UpdateEnemiesMovement`; the routine is called once near the
start of `MainGameplayThread`.

The routine snapshots Dana's integer Y and X positions, consumes and clears
the shared `GameplayUpdateCount`, and visits all 17 enemy slots. Four split
pointer tables at `$B446`, `$B457`, `$B46C`, and `$B481` select the eight-byte
enemy AI record and the corresponding `$14`-byte object record.

Only AI records whose byte 0 has bit 7 set are processed and counted in
`ActiveEnemyCount`. The shared update count advances record bytes 1-3. Object
offsets 7 and 10 are compared with Dana's coordinates, divided by two with a
sign-preserving `ROR`, and cached in AI-record bytes 4 and 5. These field
descriptions stay offset-based until the downstream AI consumers establish
their complete contracts.

The four pointer tables remain raw addresses pending their own semantic data
module and round-trip audit. `docs/enemy_ai_dispatch.md` describes the next
consumer of the same parallel records.
