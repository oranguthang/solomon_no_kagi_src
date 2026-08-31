# Source layout

`src/main.asm` owns the CPU selection, iNES header, hardware/RAM registries, and
address-ordered includes. `src/preservation/prg.asm` emits exactly 32 KiB at
CPU `$8000-$FFFF`. `src/graphics/chr.asm` includes the ignored CHR payload
created by `make split`; no CHR bytes are kept in Git.

The linker deliberately preserves the upstream segment names:

| Segment | Meaning | Output size |
| --- | --- | ---: |
| `HEADER` | 16-byte iNES header | 16 |
| `PRG_BANK_0` | complete fixed CPU PRG | 32,768 |
| `PRG_BANK_1` | generated CHR payload (historical name) | 32,768 |

This unusual naming is documented in `config/linker/cnrom.cfg`. Renaming a
segment is possible, but gives no semantic benefit until the PRG and CHR data
are divided into stable modules.

The next source split must remain address-ordered and pass `make verify` after
each boundary is introduced. Tables that cross a round-number address should
not be split merely to create visually neat files.
