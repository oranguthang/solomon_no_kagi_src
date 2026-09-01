# Room intro and transition orbit

The complete `$91B9-$9470` range owns the visible room-entry setup after the
room data has been decoded. It publishes the initial door/key cells, builds the
room intro HUD, positions Dana, and drives a fifteen-object orbit presentation.

## Door and key cells

`PublishRoomDoorAndKeyUpdates` consumes the already-resolved `RoomItemPointer`.
Header byte 5 is the door's packed RoomMap position and byte 6 is the key
position. A nonzero door position receives tile `$02`, or tile `$35` when the
key position is zero. The key receives tile `$06` only when gameplay flag
`$20` and header flag mask `$C0` are both clear. Every visible change is sent
through `BuildAndPublishRoomMapCellUpdate`, so the RoomMap and nametable stay
synchronized.

## Intro PPU program

`PrepareRoomIntro` copies the 27-byte `RoomIntroPpuTemplate` to the shared RAM
buffer and patches room/life digits before publishing it. Decoded as the normal
PPU update bytecode, the template is:

| PPU address | Payload |
| ---: | --- |
| `$216B` | six tiles spelling `SHRINE` |
| `$21CB` | eight tiles: space, `ROOM`, space, two digits |
| `$226F` | glyph `$98` and two life-count digits |

`FormatTwoDigitNumberTiles` performs repeated subtraction by ten. It returns
the ones digit in A and the tens digit in X, replacing a zero tens digit with
blank tile `$24`.

Room indices `$30+` select one of three fixed eight-tile names. The source
preserves the literal ROM spelling `PRINSESS`, followed by ` SOLOMON` and
` HIDDEN `. Later special indices clamp to the third string. The intro also
derives a marker tile from four-room groups, publishes it at RoomMap index
`$49`, stores the group as `RoomTileset`, and initializes `MagicSparkObject`.

## Entry animation

`RunRoomEntryAnimation` reads header byte 7, the packed Dana start position.
It converts that cell to pixels, seeds 13 bytes of transition AI state, and
calls `RunTransitionObjectOrbit`. After the orbit completes, Dana and the
spark object receive the decoded coordinates. Two cooperative 16-tick waits
then select spark action `$07/$08` from the X side and replace its type with
`$04`.

The four-byte `TransitionAiCoordinateSourceOffsets` table is shared by room
entry and room clear. Values `0, 2, 1, 3` reorder the four zero-page scratch
bytes into the transition AI record; this shared use is now symbolic at both
call sites.

## Fifteen-object orbit

`RunTransitionObjectOrbit` deactivates the non-Dana pool, initializes records
0 through 14 with state `$C0`, type `$1C`, cached byte `$FF`, and action zero,
then resets `GameplayDelayCounter`. For each new counter value below `$40`, it:

1. calls `PositionTransitionOrbitObjects`;
2. advances two little-endian center accumulators;
3. advances a little-endian radius accumulator;
4. adds `$0080` as a phase step and masks the phase to six bits.

On completion it clears 25 transition AI bytes and changes every active
non-Dana object state to zero.

The positioner visits object indices 14 through 0. Each successive object adds
eight to the six-bit phase. `LoadQuarterSineMagnitude` reflects phase bit 5
into the 32-byte `QuarterSineTable`; phase bit 6 supplies the sign. A second
lookup shifted by `$20` produces the perpendicular component. The fixed-point
shift/add helper at `$9429` scales both magnitudes by the current radius before
they are added to the center and stored as object Y/X.

The table rises monotonically from `$00` to `$7F`, providing one quadrant of a
seven-bit sine magnitude. Reflection and conditional complement reconstruct
the full orbit without a 256-byte trigonometric table.

The coordinate preparation dependency at `$C364` is now source-owned as
`BuildScaledCoordinateDeltas`. It converts origin and target Y/X bytes into
two signed 16-bit differences scaled by four before the transition state is
seeded. See `docs/coordinate_delta.md`.
