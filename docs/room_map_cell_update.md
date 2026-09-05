# Buffered RoomMap cell updates

`BuildAndPublishRoomMapCellUpdate` at `$9DD0-$9EDF` converts one logical
`RoomMap` change into a compact RAM-resident PPU update program. The producer
runs in a cooperative thread and coordinates with NMI because an attribute
byte must be read before one two-bit quadrant can be replaced.

## Input and synchronization

The public cooperative entry accepts:

```text
RoomMapUpdateIndex ($02) = packed 16-column map cell
RoomMapUpdateTile  ($03) = logical tile/class to render
```

It waits for `GameplayFlags` bit 2 and `PpuAttributeReadState` to become idle,
calculates the target attribute-table address low byte, stores it in
`PpuAttributeAddressOrValue`, and sets the request bit. NMI reads `$23xx`
through the buffered PPU port and replaces that byte with the value read from
VRAM. The producer yields until completion, captures the byte, clears the
request, and then waits for `PpuUpdateStreamPointer` to become idle.

`ServiceRoomMapAttributeReadRequest` at `$8B51` is the NMI half of the
protocol. A nonnegative state triggers one dummy and one effective read from
`PPU_DATA`, after which `$001C` contains the attribute byte and state `$0029`
becomes `$80`. While the request remains unacknowledged, later NMIs increment
the state; once the pre-increment value reaches `$A8`, NMI clears the request
bit. With no request active, the main NMI path resets the state to `$00`.

`BuildRoomCellUpdateBuffer` at `$9E21` is a second public entry used by the
initial direct room renderer. That caller has already read the attribute byte
and prepared the saved index/tile fields, so it bypasses the cooperative
handshake and enters directly at buffer construction.

## Tile and attribute selection

Ordinary tile graphics are the 58 source-owned four-byte records in
`RoomTilePatternTable` at `$D000 + tile*4`. A size assertion binds the table to
that record count. Tile `$10` can select one of six expanded constellation
records at `$0407` when the map index falls in either of the two three-cell
rows rooted at `ConstellationPosition`.

The first record byte carries two independent values: palette in bits 0-1 and
the top-left tile in bits 2-7. The next three bytes are the top-right,
bottom-left, and bottom-right tiles. `make room-data-audit` decodes those five
fields and re-encodes all 232 table bytes without retaining a raw first byte.

`CalculateRoomMapAttributeAddressLow` also returns a quadrant selector in
`RoomMapUpdatePpuAddressHigh` (`$05`). The builder rotates the existing
attribute byte by two bits per quadrant, replaces only the selected low two
bits from the tile pattern, and rotates the byte back.

## Emitted update program

The 15-byte program at `PpuUpdateBuffer` contains:

| Offset | Meaning |
| ---: | --- |
| 0-4 | literal two-byte write for the top tile row |
| 5-9 | literal two-byte write 32 PPU bytes later for the bottom tile row |
| 10-13 | literal one-byte write to `$23xx` for the updated attribute byte |
| 14 | zero stream terminator |

Both tile commands use control `$41`; the attribute command uses `$40`.
`PublishPpuUpdateBuffer` publishes the finished program to the existing NMI
stream interpreter.

The adjacent `$9EE0-$9F22` module contains the packed-cell to nametable-address
and attribute-address conversions. `$9F23-$9FFF` is 221 bytes of non-code
filler, independently classified by Bisqwit's map and now held in a dedicated
data module.
