# Enemy AI handler dispatch

`src/game/enemy_ai_handlers.asm` owns CPU `$A469-$A4A5`. Bisqwit's map names
the entry at `$A469` `MaybeRunOneEnemyAI`; this reconstruction uses
`DispatchEnemyAiHandler` because the routine performs two shifts and delegates
through the generic appendix dispatcher at `$8EA9`.

The 28 words immediately following that `JSR` are not executable fallthrough
bytes. `JumpWithParams` consumes them as an inline little-endian handler table
and transfers control to the selected target. Repeated targets are meaningful:
the table contains 28 entries but only 14 unique handler addresses.

`make enemy-ai-report` prints the decoded table from the built PRG.
`make enemy-ai-audit` compares every pointer with
`config/enemy_ai_handlers.json`; the audit is part of `make release-check`.
An assembly assertion independently fixes the source table at 28 entries.

The individual targets remain raw addresses until each behavior family is
reconstructed. The first local target is `$A4B3`; the short helper at
`$A4A6-$A4B2` precedes it and is the next code boundary.
