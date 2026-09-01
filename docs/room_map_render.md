# Room map rendering

`DrawRoomMapToNametable` at `$9661-$96DB` renders the 16x12 playable interior
of `RoomMap` during room initialization. It first waits for the NMI-consumed
PPU update pointer to become idle, then enters the rendering-disabled direct
transfer guard.

The traversal counts packed map positions from `$D0` down through `$11`.
Positions whose low nibble is zero are sentinel-column boundaries; all other
positions map to RoomMap indices `$CF-$10`, exactly 192 cells. For each cell
the renderer reads its current nametable attribute byte, classifies the map
tile, and calls `BuildRoomCellUpdateBuffer` at `$9E21`.

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

The renderer shares `CalculateRoomMapAttributeAddressLow` with the cooperative
cell-update producer. Both helpers are now source-owned and their complete
contracts are documented in `docs/room_map_cell_update.md`.
