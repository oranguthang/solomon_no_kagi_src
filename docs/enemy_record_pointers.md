# Enemy and object record pointer tables

`src/data/enemy_record_pointers.asm` owns CPU `$B446-$B491`. The 76-byte
region contains four split pointer tables:

| Table | Entries | Address sequence |
| --- | ---: | --- |
| enemy AI low/high | 17 | `$04F7 + index * 8` |
| all object low/high | 21 | `$057F + index * $14` |

The first four object entries address Dana (`$057F`), the magic spark
(`$0593`), the fireball (`$05A7`), and an auxiliary record (`$05BB`). The
remaining seventeen begin at `EnemyObjects` (`$05CF`). Consequently,
`EnemyObjectPointerLowTable` and `EnemyObjectPointerHighTable` are labels four
entries into the complete object tables, not separate duplicated data.

The source expresses both sequences from their RAM bases and strides with
assembly-time count and offset assertions. This keeps the byte-identical
layout while making the pool relationship reviewable.

`make enemy-pointer-report` decodes the four byte planes from the built PRG.
`make enemy-pointer-audit` compares the reconstructed 16-bit pointers with
`config/enemy_record_pointers.json`; the audit is part of `make release-check`.
Bisqwit's map independently classifies the same ranges as the enemy AI and
object pointer tables.
