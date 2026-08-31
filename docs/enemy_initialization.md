# Enemy slot initialization

`src/game/enemy_initialization.asm` owns CPU `$A3D7-$A3F7`. Bisqwit's map
identifies the entry as `InitializeEnemy`. Four call sites use the same
zero-page input contract:

- `SpawnSlotIndex` selects one of the 17 parallel enemy slots;
- `SpawnYPosition` and `SpawnXPosition` contain converted pixel coordinates;
- the caller invokes the adjacent type-specific initializer at `$A3F8` when a
  complete spawn is required.

The helper at `$B296` resolves the selected eight-byte AI record. The routine
clears offsets 1-3, then `$B28A` resolves the matching `$14`-byte object record
and receives Y/X at offsets 7 and 10. These two helpers and their split pointer
tables remain raw until their own data/code module is reconstructed.

One call site at `$A144` uses only this position/state initialization before a
separate rendering call, while room actors, fairies, and the `$B930` spawn path
continue directly into the type-specific `$A3F8` service.
