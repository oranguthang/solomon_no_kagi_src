# Room-clear and room-load pipeline

The complete `$8EC0-$915D` range is source-owned as the context-one room
transition pipeline. The scheduler tables prove three distinct entry contracts:

| Scheduler code | Entry | Role |
| ---: | ---: | --- |
| `$10` | `$901E` | reset new-game state, then load room zero |
| `$14` | `$8EE4` | finish a cleared room and convert time to score |
| `$15` | `$9021` | load the selected room without a new-game reset |

`RoomClearThread` first shuts down the other secondary contexts and waits for
the transition flags to settle. It builds the timer display, initializes two
temporary AI/object records, queues static PPU messages 2 through 4, and runs
the room-clear presentation. After a delay it calls `SubtractTimerBy8`, clears
the two temporary object states, clears the nametable area, plays the final
sound request, and replaces context 1 with scheduler selector `$15`.

The room-clear data has a deliberate overlap. `RoomClearAiStateTemplate` is
nine bytes beginning at `$8FA2`, while `RoomClearObjectHeaderPredecessors`
begins at `$8FAA`; byte `$8FAA` is therefore both the AI template's last byte
and the object-header table's first byte. The ca65 source preserves that shared
entry rather than duplicating data. The two initialized gameplay objects use
X positions `$28` and `$C8`, Y position `$50`, state `$C0`, type `$1C`, and
actions `$18/$19`.

`SubtractTimerBy8` is independently named in Bisqwit's map. It performs
decimal borrow propagation across the four unpacked timer digits at
`$0438-$043B`. Each successful subtraction adds eight at score digit index 6;
the final remainder is credited separately, all timer digits are cleared, and
the combined score/timer PPU update is published. The display loop uses carry
as a leading-zero latch, replacing only leading zeroes with tile `$24`.

`NewGameRoomLoadThread` calls `ResetNewGameState` and falls through to the
common `RoomLoadThread`; selector `$15` enters the common path directly. The
loader:

1. selects the normal or special room index;
2. initializes the block map and starts context 6;
3. queues the initial static PPU streams and waits for the presentation delay;
4. decodes room items, metadata, and enemies;
5. renders the 16x12 RoomMap interior;
6. copies and patches the room palette update in shared RAM;
7. initializes Dana's object header;
8. starts scheduler code `$30` (`MainGameplayThread`) and stops context 1.

`RoomLoadPaletteTemplate` begins with a `$3F00` literal command. The loader
copies its command header and first 16 colors, changes the control byte to a
16-byte literal command, selects one color from the 14-entry
`RoomPaletteColorByRoomGroup` table using `room_index / 4`, writes that color
at payload offsets `$01/$05/$09/$0D`, terminates the RAM program, and publishes
it for NMI consumption. The 14 groups cover every zero-based room index from
0 through 52.

`ResetNewGameState` selects room zero, grants three remaining lives and three
inventory slots, clears the eight decimal score digits and adjacent state
flags, then seeds `GameStateFlags`, `$0080`, and the high fireball-lifetime
byte with one.

The former raw dependencies at `$91EB`, `$91B9`, `$92BC`, `$9340`, `$C2A6`,
`$C3D4`, and `$C403` are now source-owned as `PrepareRoomIntro`,
`PublishRoomDoorAndKeyUpdates`, `RunRoomEntryAnimation`,
`RunTransitionObjectOrbit`, `AnimateDoorUnlockFromDanaPosition`,
`RefreshGameplayHud`, and `BuildScoreDisplayUpdate`. The shared coordinate
dependency at `$C364` is `BuildScaledCoordinateDeltas`. The room-load pipeline
therefore has no remaining raw call targets.

## Runtime transition evidence

The `room-1-door-transition` scenario creates only the four prerequisite RAM
conditions for an already collected key and an open-door overlap. From there,
the original ROM executes `EnterRoomDoor` at frame 721, enters
`RoomClearThread` in context 1 on the same frame, reaches the first
`SubtractTimerBy8` score conversion at frame 854, and invokes `RoomLoadThread`
for internal room `$01` at frame 1136. Every setup write and previous value is
declared in `scenarios/runtime_scenarios.json` and checked by
`make validate-runtime`.
