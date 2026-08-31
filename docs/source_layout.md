# Source layout

`src/main.asm` owns the CPU selection, iNES header, hardware/RAM registries, and
address-ordered includes. Semantic modules own NMI at `$8000-$80FE`, controller
sampling at `$837D-$83C1`, object
surface clamping at `$8A62-$8AA3`, startup at `$8C00-$8D5E`, the scheduler at
`$8D5F-$8E46`, context 2's pause loop at `$8E47-$8E8C`, sound-effect request
queuing at `$8E8D-$8E9F`, PPU
update-buffer publication at `$8EA0-$8EA8`, inline appendix dispatch at
`$8EA9-$8EBF`, room-map coordinate conversion at `$918A-$91B8`, and the main
gameplay thread at `$A000-$A04B`.
Timer logic owns `$A15F-$A225`, and its display builder
at `$A238-$A273`, followed by the enemy movement prepass at `$A274-$A2DB`.
The adjacent AI dispatcher owns `$A2DC-$A30B`.
Fireball lifetime and delayed cleanup own `$A3A4-$A3D6`.
Enemy slot position/state initialization follows at `$A3D7-$A3F7`.
Type-specific object/AI configuration owns `$A3F8-$A44D`.
Its 27-byte packed flag table follows at `$A44E-$A468`.
The inline AI handler dispatcher and its 28 pointers own `$A469-$A4A5`.
The shared current-enemy position helper owns `$A4A6-$A4B2`.
The two indexed enemy-record pointer resolvers own `$B28A-$B2A1`.
The free enemy-slot allocator owns `$B42A-$B445`.
Their split record-pool pointer tables own `$B446-$B491`.
The adjacent enemy-slot deactivation helper owns `$B492-$B4B5`.
Current selected-enemy deactivation owns `$B4B6-$B4C3`.
Timer item effects own `$C628-$C697`.
Inventory, fairy, fireball-lifetime, and score item entries own `$C698-$C70F`.
Item score tables and the shared auxiliary-effect initializer own
`$C710-$C73A`.
Shared decimal score addition owns `$C73B-$C755`.
Non-Dana object state maintenance owns `$CA3C-$CA6D`, split into two sweep
routines around the shared pointer resolver.
`src/preservation/prg.asm` owns the unresolved ranges
between and after those modules. `src/graphics/chr.asm` includes the ignored CHR payload created by
`make split`; no CHR bytes are kept in Git.

The linker deliberately preserves the upstream segment names:

| Segment | Meaning | Output size |
| --- | --- | ---: |
| `HEADER` | 16-byte iNES header | 16 |
| `PRG_NMI` | semantic NMI and PPU commit module | 255 |
| `PRG_PRE_STARTUP` | unresolved `$80FF-$837C` range | 638 |
| `PRG_CONTROLLER_INPUT` | two-port serial controller sampling and caching | 69 |
| `PRG_POST_CONTROLLER_INPUT` | unresolved `$83C2-$8A61` range | 1,696 |
| `PRG_OBJECT_Y_CLAMP` | align object Y to a 16-pixel surface | 29 |
| `PRG_OBJECT_X_LEFT_CLAMP` | clamp X against a left-side surface | 37 |
| `PRG_POST_OBJECT_CLAMPS` | unresolved `$8AA4-$8BFF` range | 348 |
| `PRG_STARTUP` | reset and startup module | 351 |
| `PRG_SCHEDULER` | cooperative scheduler and entry tables | 232 |
| `PRG_PAUSE_THREAD` | context-two pause and Start debounce loop | 70 |
| `PRG_SOUND_EFFECT_QUEUE` | three-slot sound-effect request producer | 19 |
| `PRG_PPU_UPDATE_BUFFER` | shared RAM update-program publication | 9 |
| `PRG_JUMP_WITH_PARAMS` | inline appendix tail dispatcher | 23 |
| `PRG_POST_JUMP_WITH_PARAMS` | unresolved `$8EC0-$9189` range | 714 |
| `PRG_COORDINATE_CONVERSION` | pixel and packed room-index conversion | 47 |
| `PRG_POST_COORDINATE_CONVERSION` | unresolved `$91B9-$9FFF` range | 3,655 |
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
| `PRG_PRE_ENEMY_POINTER_TABLES` | unresolved `$B2A2-$B429` range | 392 |
| `PRG_FIND_FREE_ENEMY_SLOT` | seventeen-entry free-slot allocator | 28 |
| `PRG_ENEMY_POINTER_TABLES` | split object/AI record pointer tables | 76 |
| `PRG_ENEMY_DEACTIVATION` | parallel-record enemy slot retirement | 36 |
| `PRG_CURRENT_ENEMY_DEACTIVATION` | selected enemy-record retirement | 14 |
| `PRG_BANK_0` | unresolved `$B4C4-$C627` range | 4,452 |
| `PRG_TIMER_ITEM_EFFECTS` | timer multiplication and fixed-value item handlers | 112 |
| `PRG_INVENTORY_ITEM_EFFECTS` | inventory, fairy, lifetime, and score item handlers | 120 |
| `PRG_ITEM_SCORE_TABLES` | collectible score digit and amount lookups | 8 |
| `PRG_AUXILIARY_EFFECT` | shared auxiliary-object effect initializer | 35 |
| `PRG_SCORE_ADDITION` | gated unpacked-decimal score addition | 27 |
| `PRG_POST_SCORE_ADDITION` | unresolved `$C756-$CA3B` range | 742 |
| `PRG_SET_ACTIVE_OBJECT_STATES` | conditional non-Dana state sweep | 19 |
| `PRG_LOAD_OBJECT_POINTER` | non-Dana object pointer resolver | 11 |
| `PRG_DEACTIVATE_NON_DANA_OBJECTS` | whole non-Dana object teardown | 20 |
| `PRG_POST_NON_DANA_OBJECT_DEACTIVATION` | unresolved `$CA6E-$FFFF` range | 13,714 |
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
