# Special-room scripts

Scheduler code `$60` enters `RunSpecialRoomScriptThread` at `$B800`. It calls a
room-indexed handler and stops context 6 after that handler returns. The room
loader starts this context for every room, so ordinary rooms deliberately map
to one-byte `RTS` handlers.

## Dispatch format

`DispatchCurrentRoomScript` divides `CurrentRoomIndex` by eight and uses the
result to select one of seven group bases. A parallel 53-byte table supplies a
relative offset inside that group:

```text
group = room_index / 8
entry = group_base[group] + room_offset[room_index]
```

The seven bases occupy `$B824-$B831`; offsets occupy `$B832-$B866`. The final
four offsets are `$85,$00,$49,$4D`, selecting handlers `$BA34`, `$B9AF`,
`$B9F8`, and `$B9FC` for room indices 49-52. Those bytes form table data even
though `$85 $00 $49 $4D` can be decoded as `STA $00` and `EOR #$4D`. Treating
them as instructions both invents unreachable code and truncates the secret
room dispatch table.

Compile-time assertions hold the table at 53 entries and the reconstructed
module at exactly `$234` bytes.

## Trigger families

The reconstructed handlers fall into four mechanically verified families:

- no-op entries return immediately for rooms without a script;
- seal entries pass one of the bit values `$01,$02,$04,$08,$10,$20,$40,$80`
  to the shared reveal routine at `$BFAA`;
- enemy entries wait until Dana is active, set bit 6 in the first enemy AI
  record, or allocate a type-`$18` enemy at a scripted map cell;
- map entries cooperatively watch `RoomMap`, the block-cast target at `$007E`,
  the head-collision target at `$007F`, and Dana's action/state fields before
  publishing tile changes.

Room indices 16 and 38 count eleven hits at map positions `$7E` and `$56`, then
spawn type `$18` at cells `$6E` and `$36`. Indices 19 and 37 use the shared map
trigger at cells `$20` and `$9E`. The index-19 path first expands the level-20
bitplane at `$BFE2`; index 29 expands the level-30 bitplane at `$BFFA` and
enables the first enemy AI phase.

Room index 48 hides twelve fixed map cells, waits for casts at `$AD` and `$57`, and
checks the first enemy object's map position before changing cells `$82` and
`$65`. The two final secret-room handlers share a trigger that watches Dana's
map position and the last block-cast target, then changes either cell `$C7` or
the three cells `$46-$48`.

The room-index 49 offset selects `RunEndingRoomScript` at `$BA34`. That complete
ending handler is source-owned through `$BD93`. Its supporting waits, Solomon's
Seal reveal state, object-position table, text streams, and two special-room
bitplanes are source-owned in `src/game/ending_and_special_room_support.asm`.
