# Room map rendering

`DrawRoomMapToNametable` at `$9661-$96DB` renders the 16x12 playable interior
of `RoomMap` during room initialization. It first waits for the NMI-consumed
PPU update pointer to become idle, then enters the rendering-disabled direct
transfer guard.

The traversal counts packed map positions from `$D0` down through `$11`.
Positions whose low nibble is zero are sentinel-column boundaries; all other
positions map to RoomMap indices `$CF-$10`, exactly 192 cells. For each cell
the renderer reads its current nametable attribute byte, classifies the map
tile, and calls the still-unreconstructed builder at `$9E21`.

Tile classification passed in `RoomRenderTileClass` is:

| RoomMap value | Class |
| --- | ---: |
| `$F8-$FF` | `$03` |
| `$80-$F7` | `$00` |
| `$40-$7F` | `$10` |
| `$00-$3F` | original value |

The builder emits address/data chunks into `PpuUpdateBuffer`. The renderer
immediately writes each two-byte address and each two-byte data pair to the
PPU, stopping on a zero data marker. After all cells it tail-calls
`EndDirectPpuTransfer`, restoring the normal rendering/NMI state.

The helper at `$9F01` that derives the attribute address and the builder at
`$9E21` remain explicit raw dependencies. Their contracts are visible here,
but their own ranges need independent reconstruction before naming them.
