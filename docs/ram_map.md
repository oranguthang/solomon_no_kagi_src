# RAM map

This is the initial evidence registry, not a claim that every byte in each
range is understood.

| Address / range | Working meaning | Confidence |
| --- | --- | --- |
| `$0000-$000F` | temporary pointers and scratch values | high |
| `$0004-$0007` | spawn Y, X, slot index, and type calling convention | high |
| `$0012-$0019` | saved SP values for eight cooperative contexts | high |
| `$001A-$001B` | NMI-consumed PPU update-stream pointer | confirmed |
| `$0023` | shared pending gameplay/timer update count | high |
| `$0082-$0083` | raw controller values | high |
| `$0210-$030F` | OAM shadow buffer, 64 four-byte sprites | high |
| `$0302` | current scheduler context index | high |
| `$0304...` | logical room map / tile state | high |
| `$03E4-$03E5` | cached controller state | high |
| `$0428` | zero-based current room index | confirmed |
| `$0429-$043D` | fireball, inventory, and lifetime state | mixed/high |
| `$0434-$043B` | timer warning state, step, fraction, and decimal digits | high |
| `$0447` | active enemy count produced by the movement prepass | high |
| `$044A-$0451` | decimal score digits | high |
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
