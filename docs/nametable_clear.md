# Direct nametable clearing

The transition code has two public entries into one descriptor-driven direct
PPU writer:

| Entry | Descriptor | Cleared tile area |
| --- | ---: | --- |
| `Clear30x24NametableRegion` | 6 | 30 columns from `$2080`, 24 rows |
| `Clear32x26NametableRegion` | 3 | 32 columns from `$2080`, 26 rows |

Six callers use the 30x24 entry and one uses the 32x26 entry. Descriptor zero,
which describes 32 columns from `$2000` for 26 rows, has no direct static
wrapper in the reconstructed call inventory.

## Descriptor and address calculation

Each three-byte record is `(width, start_index, row_count)`. The routine turns
`start_index` into a PPU address with:

```text
address = $2000 + start_index * 4
```

It writes `width` copies of blank tile `$24`, adds 8 to `start_index`, and
continues for `row_count` rows. Since the address calculation multiplies by
four, each increment advances 32 PPU bytes to the next nametable row.

After the tile rectangle, every path writes zero to 48 bytes beginning at
`$23C8`, clearing `$23C8-$23F7` in the attribute table.

## Boundaries and contract

The code owns `$C9BD-$CA32`; the descriptor table owns `$CA33-$CA3B`. Keeping
them separate prevents the preservation disassembly from interpreting the
nine data bytes as three false 6502 instructions.

The helper at `$96F0` and both wrapper continuations at `$96DC` remain outside
this semantic range and deliberately retain raw addresses pending their own
reconstruction. The code reads `PPU_STATUS` to reset the address latch, writes
`PPU_ADDR`, restores `PpuCtrlShadow`, and streams bytes through `PPU_DATA`.
`NametableClearWidth` is scratch byte `$0002`; the descriptor table has an
assembly-time size assertion.

## Full two-nametable clear

`ClearBothNametables` at `$CB6F` drives a second direct PPU path. It calls
`ClearFullNametable` with high address bytes `$20` and `$28`, selecting the two
physical nametables used with horizontal mirroring.

For each nametable, the compact counter loop writes:

```text
192 + 3 * 256 = 960 bytes of blank tile $24
64 bytes of attribute value $FF
```

The result covers the complete 32x30 tile plane and its complete 64-byte
attribute table. All three static callers use the two-nametable wrapper at
screen-reset boundaries. The external direct-PPU setup/finish helpers at
`$96F0/$96DC` and the PPU-address helper at `$CD53` remain raw until their own
ranges are reconstructed.
