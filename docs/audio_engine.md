# Audio engine

`src/system/audio_engine.asm` owns CPU `$F000-$F367`. `UpdateAudio` is called
from NMI after input sampling whenever the game-state audio-disable bit is
clear. It first consumes the three pending sound-effect mailboxes, then updates
and publishes channel state.

## Virtual channels

The driver maintains eight 16-byte channel records at `$0456-$04D5`. Four
interleaved bytes per virtual channel follow at `$04D6-$04F5`: note-duration
counter, duration reload, envelope counter, and envelope volume. `$04F6` is an
eight-bit active mask. The update pass rotates that mask once per record, so
the current channel is presented in carry and later in bit 7.

The publishing pass treats the virtual records as four pairs. It selects one
record from each pair using the corresponding two active bits, writes volume,
sweep, and a dirty period to the matching APU register group, then enables the
four ordinary APU voices through `$4015`. This statically proves the pairing;
which member wins under every music/SFX overlap still needs an emulator trace.

## Stream interpreter

Ordinary bytes encode notes. `$80-$EF` select a duration through the table at
`$F380`; `$F0-$F9` dispatch through the ten-entry handler table at `$F246`:

| Opcode | Observed operation |
| --- | --- |
| `$F0` | select a two-byte sequence pointer through `$F39A` |
| `$F1` | replace the low control nibble |
| `$F2` | jump to an absolute stream pointer |
| `$F3` | call an absolute stream pointer and push a return pointer |
| `$F4` | restore a saved return pointer |
| `$F5` | push a counted-loop frame |
| `$F6` | decrement/repeat or pop a counted-loop frame |
| `$F7` | write one hardware sweep register |
| `$F8` | replace the low six control bits |
| `$F9` | clear the current active bit and leave stream decoding |

The per-channel record provides a compact stack beginning at offset 9 for
calls and loops. Note bytes index the twelve-entry period table at `$F368` and
use their upper nibble as a right-shift count. The high bit in record offset 8
marks a period awaiting publication.

## Audio data

The engine's period, duration, envelope, sound-effect, and music streams are
source-owned at `$F368-$FFF9` in `src/data/audio.asm`. Periods and all pointer
operands use symbolic words; `$F2/$F3` bytecode targets reference 114 named
stream entries. The adjacent CPU vectors are symbolic through `$FFFF`.

`make audio-data-audit` independently checks 12 periods, 26 duration values,
eight envelope pointers, 26 overlapping effect descriptors, and every stream
entry reachable through descriptor and `$F2/$F3` command pointers. All 2,664
bytes at `$F592-$FFF9` must be reachable and every decoded path must re-encode
byte-for-byte.

`python scripts/audio_data.py source --image <rom>` reproduces the reviewed
ASM representation from a matching image.
