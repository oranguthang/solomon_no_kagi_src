# RAM map

This is the initial evidence registry, not a claim that every byte in each
range is understood.

| Address / range | Working meaning | Confidence |
| --- | --- | --- |
| `$0000-$000F` | temporary pointers and scratch values | high |
| `$0004-$0007` | spawn Y, X, slot index, and type calling convention | high |
| `$0004-$0005` | room-map conversion Y/index and X calling convention | confirmed |
| `$0012-$0019` | saved SP values for eight cooperative contexts | high |
| `$001A-$001B` | NMI-consumed PPU update-stream pointer | confirmed |
| `$0020-$0027` | independently incremented active-gameplay frame counters | confirmed |
| `$0021` | standard gameplay delay counter | confirmed |
| `$0022` | NMI-incremented frame counter used by pause debounce | confirmed |
| `$0023` | shared pending gameplay/timer update count | high |
| `$0028` | gameplay flags; transition reset clears bit 2 | high |
| `$0030-$0031` | current room item/header stream pointer | confirmed |
| `$0036-$0039` | two resolved Demon Mirror schedule pointers | confirmed |
| `$003A-$003D` | two resolved Demon Mirror enemy-set pointers | confirmed |
| `$007C-$007D` | room-state flags and decoded tileset | high |
| `$0078` | global game-state flags; pause thread modifies bits 1-2 | high |
| `$0082-$0083` | raw controller values in A/B/Select/Start/Up/Down/Left/Right bit order | confirmed |
| `$0087` | unidentified state flags; transition reset clears bit 0 | unknown |
| `$0210-$030F` | OAM shadow buffer, 64 four-byte sprites | high |
| `$0302` | current scheduler context index | high |
| `$0304-$03E3` | 16x14 room map: 16x12 interior plus two sentinel rows | confirmed |
| `$0406-$041E` | constellation position and expanded 24-byte pattern | confirmed |
| `$03E4-$03E5` | cached controller state with game-state-dependent filtering | confirmed |
| `$03E6...` | shared RAM PPU update-program buffer | confirmed base |
| `$0423-$0425` | three sound-effect request slots | confirmed |
| `$0428` | zero-based current room index | confirmed |
| `$0429-$043D` | fireball, inventory, and lifetime state | mixed/high |
| `$042B` | number of usable two-bit fireball inventory slots, maximum 8 | confirmed |
| `$042E-$042F` | eight packed two-bit fireball inventory slots | confirmed |
| `$0434-$043B` | timer warning state, step, fraction, and decimal digits | high |
| `$043C-$0446` | room item/mirror runtime state and coordinates | high |
| `$0447` | active enemy count produced by the movement prepass | high |
| `$044A-$0451` | eight unpacked decimal score digits, most significant first | confirmed |
| `$0452` | remaining lives | high |
| `$0453-$0454` | collected and queued fairies | high |
| `$04F7-$057E` | 17 eight-byte enemy AI records | tentative/high |
| `$057F-$070F` | `$14`-byte gameplay object records | high |

The last object base is `$070F`; a full `$14`-byte record therefore reaches
`$0722`. Exact ownership above that boundary still needs write-watch evidence.

Important object fields observed on Dana include integer Y at `$0586`, integer
X at `$0589`, and adjacent fractional/movement fields. Equivalent offsets are
expected across the object pool, but each field should be proven before global
renaming.

Across shared object helpers, record byte 7 is the integer Y coordinate and
byte 5 carries a signed fractional/directional component. The surface clamp
aligns byte 7 to 16 pixels and preserves only byte 5's sign bit.
Record byte 10 is integer X; its left-surface clamp clears fractional byte 9
and motion byte 8 after aligning X to low nibble `$4`.
The shared auxiliary record at `$05BB` uses the same confirmed integer Y/X
offsets. `SpawnAuxiliaryEffectAtCoordinates` writes them from zero-page
`$04/$05` before replacing object bytes 0 through 3 from a fixed template.
