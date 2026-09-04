# Scheduler entry tables

`StartThread` receives a packed byte: the high nibble selects one of eight
stack contexts and the low nibble selects a two-byte entry in that context's
table. The table word is an RTS return address, so the first executed address
is always the stored word plus one.

`scripts/scheduler_data.py` extracts these tables from the built PRG and scans
the assembly source for immediate `StartThread` calls. `make scheduler-audit`
compares the decoded result with `config/scheduler_entries.json`, including
entries independently reviewed behind dynamically selected calls. Any new
code, changed pointer, stack partition, or static/dynamic call count must be
reviewed before the manifest is updated.

The currently referenced static entries are:

| Code | Context | Selector | Base | Slot | Stored return | Entry |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `$10` | 1 | 0 | `$8E17` | `$8E17` | `$901D` | `$901E` |
| `$14` | 1 | 4 | `$8E17` | `$8E1F` | `$8EE3` | `$8EE4` |
| `$15` | 1 | 5 | `$8E17` | `$8E21` | `$9020` | `$9021` |
| `$16` | 1 | 6 | `$8E17` | `$8E23` | `$C851` | `$C852` |
| `$17` | 1 | 7 | `$8E17` | `$8E25` | `$CA6D` | `$CA6E` |
| `$18` | 1 | 8 | `$8E17` | `$8E27` | `$CB09` | `$CB0A` |
| `$22` | 2 | 2 | `$8E29` | `$8E2D` | `$CB2A` | `$CB2B` |
| `$30` | 3 | 0 | `$8E2F` | `$8E2F` | `$9FFF` | `$A000` |
| `$31` | 3 | 1 | `$8E2F` | `$8E31` | `$C7E6` | `$C7E7` |
| `$32` | 3 | 2 | `$8E2F` | `$8E33` | `$C586` | `$C587` |
| `$33` | 3 | 3 | `$8E2F` | `$8E35` | `$C789` | `$C78A` |
| `$35` | 3 | 5 | `$8E2F` | `$8E39` | `$C831` | `$C832` |
| `$42` | 4 | 2 | `$8E3B` | `$8E3F` | `$C397` | `$C398` |
| `$43` | 4 | 3 | `$8E3B` | `$8E41` | `$C388` | `$C389` |
| `$50` | 5 | 0 | `$8E43` | `$8E43` | `$C0FF` | `$C100` |
| `$60` | 6 | 0 | `$8E45` | `$8E45` | `$B7FF` | `$B800` |

Code `$50` is now source-owned as `ProcessDefeatedEnemyDrops`. The red-bottle
item marks eligible enemy records and starts this context, which converts all
marked records into table-selected drop objects before stopping context 5.

Context 4's complete selector family is now classified. `$40` enters
`RunMapItemPresentation`, `$41` enters
`RunExtraLifeMapItemPresentation`, `$42` enters
`RunEnemyItemPresentation`, and `$43` enters
`RunExtraLifeEnemyItemPresentation`. Only `$42/$43` appear as direct immediate
calls in the static inventory because `$40/$41` are selected through
`ItemInteractionThreadCode` after map-item dispatch.

There are 18 immediate calls using those 16 distinct codes and three calls
whose accumulator value is selected dynamically. Dynamic calls are recorded
as a count because static source inspection cannot prove their runtime values.

Four additional table slots are independently reconstructed even though their
callers select the code dynamically:

| Code | Context | Selector | Base | Slot | Stored return | Entry |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `$21` | 2 | 1 | `$8E29` | `$8E2B` | `$8E46` | `PauseGameThread` (`$8E47`) |
| `$34` | 3 | 4 | `$8E2F` | `$8E37` | `$C23B` | `RunKeyCollectionPresentation` (`$C23C`) |
| `$40` | 4 | 0 | `$8E3B` | `$8E3B` | `$C394` | `RunMapItemPresentation` (`$C395`) |
| `$41` | 4 | 1 | `$8E3B` | `$8E3D` | `$C385` | `RunExtraLifeMapItemPresentation` (`$C386`) |
