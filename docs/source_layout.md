# Source layout

`src/main.asm` owns the CPU selection, iNES header, hardware/RAM registries, and
address-ordered includes. Semantic system modules own NMI at `$8000-$80FE`,
startup at `$8C00-$8D5E`, the scheduler at `$8D5F-$8E46`, the main gameplay
thread at `$A000-$A04B`, timer logic at `$A15F-$A225`, and its display builder
at `$A238-$A273`, followed by the enemy movement prepass at `$A274-$A2DB`.
The adjacent AI dispatcher owns `$A2DC-$A30B`.
Fireball lifetime and delayed cleanup own `$A3A4-$A3D6`.
Enemy slot position/state initialization follows at `$A3D7-$A3F7`.
Type-specific object/AI configuration owns `$A3F8-$A44D`.
Its 27-byte packed flag table follows at `$A44E-$A468`.
The inline AI handler dispatcher and its 28 pointers own `$A469-$A4A5`.
The shared current-enemy position helper owns `$A4A6-$A4B2`.
The two indexed enemy-record pointer resolvers own `$B28A-$B2A1`.
Their split record-pool pointer tables own `$B446-$B491`.
`src/preservation/prg.asm` owns the unresolved ranges
between and after those modules. `src/graphics/chr.asm` includes the ignored CHR payload created by
`make split`; no CHR bytes are kept in Git.

The linker deliberately preserves the upstream segment names:

| Segment | Meaning | Output size |
| --- | --- | ---: |
| `HEADER` | 16-byte iNES header | 16 |
| `PRG_NMI` | semantic NMI and PPU commit module | 255 |
| `PRG_PRE_STARTUP` | unresolved `$80FF-$8BFF` range | 2,817 |
| `PRG_STARTUP` | reset and startup module | 351 |
| `PRG_SCHEDULER` | cooperative scheduler and entry tables | 232 |
| `PRG_PRE_MAIN_THREAD` | unresolved `$8E47-$9FFF` range | 4,537 |
| `PRG_MAIN_THREAD` | context-three gameplay loop | 76 |
| `PRG_PRE_TIMER` | unresolved `$A04C-$A15E` range | 275 |
| `PRG_TIMER` | countdown arithmetic and warning transitions | 199 |
| `PRG_PRE_TIMER_DISPLAY` | unresolved timer tables `$A226-$A237` | 18 |
| `PRG_TIMER_DISPLAY` | timer HUD update-program builder | 60 |
| `PRG_ENEMY_MOVEMENT` | active-enemy movement prepass | 104 |
| `PRG_ENEMY_AI_DISPATCH` | 17-slot enemy AI selector | 48 |
| `PRG_PRE_FIREBALL_LIFETIME` | unresolved `$A30C-$A3A3` range | 152 |
| `PRG_FIREBALL_LIFETIME` | fireball expiration and cleanup | 51 |
| `PRG_ENEMY_INITIALIZATION` | enemy slot coordinates and AI reset | 33 |
| `PRG_ENEMY_TYPE_CONFIGURATION` | spawn-type object/AI configuration | 86 |
| `PRG_ENEMY_TYPE_DATA` | packed enemy-type configuration flags | 27 |
| `PRG_ENEMY_AI_HANDLERS` | inline dispatcher and 28 handler pointers | 61 |
| `PRG_ENEMY_POSITION` | current-enemy position-copy helper | 13 |
| `PRG_PRE_ENEMY_POINTERS` | unresolved `$A4B3-$B289` range | 3,543 |
| `PRG_ENEMY_POINTERS` | indexed object/AI record pointer resolvers | 24 |
| `PRG_PRE_ENEMY_POINTER_TABLES` | unresolved `$B2A2-$B445` range | 420 |
| `PRG_ENEMY_POINTER_TABLES` | split object/AI record pointer tables | 76 |
| `PRG_BANK_0` | unresolved `$B492-$FFFF` range | 19,310 |
| `PRG_BANK_1` | generated CHR payload (historical name) | 32,768 |

This unusual naming is documented in `config/linker/cnrom.cfg`. Renaming a
segment is possible, but gives no semantic benefit until the PRG and CHR data
are divided into stable modules.

Every source split must remain address-ordered and pass `make verify` after
each boundary is introduced. `config/reconstruction.json` records accepted
module ranges and non-regression thresholds; `make reconstruction-audit`
checks those declarations against the linker map and label file. Tables that
cross a round-number address should not be split merely to create visually
neat files.
