# Runtime evidence

The static reconstruction is supplemented by deterministic FCEUX scenarios.
They execute the byte-identical built ROM, import symbols generated from the
same ld65 build, apply only declared controller input, and record focused CSV
events under `build/native/runtime/`.

## Reproduction

Run:

```bash
make trace-runtime
```

`FCEUX` defaults to the shared sibling-project automation build at
`../fceux_automation/vc/x64/Release/fceux64.exe` and can be overridden on the
command line. The runner verifies the complete ROM SHA-1 before starting the
emulator. `make validate-runtime` can revalidate already captured traces
without rerunning FCEUX.

The traces are generated evidence and are not committed. The committed
contract is `scenarios/runtime_scenarios.json`: it records the method, exact
input frames, expected first execution of semantic routines, forbidden events,
and selected final RAM state.

## Initial scenarios

`cold-boot-idle` performs a natural 180-frame power-on with no input. It proves
the first NMI, controller read, and cooperative scheduler switch while ensuring
that room loading and gameplay do not begin spontaneously.

`start-room-1` supplies Start only on frames 300-301 and otherwise leaves the
controller untouched. It observes the room loader, intro preparation, main
gameplay thread, timer path, Dana control, object motion and collision, and the
enemy-AI dispatcher. At frame 1000 it checks the internal room index, timer
digits, Dana position, and active-enemy count.

`room-1-walk-right` extends the same natural entry with Right held on frames
720-780. The trace proves that the raw controller state reaches RAM and that
Dana's horizontal coordinate subsequently changes, then fixes a final gameplay
state at frame 900.

`room-1-cast-block` presses A on frames 720-780. It observes the block-magic
request, execution of `CreateBlockInRoomMap`, and the resulting write of `$90`
to RAM address `$0387`, map index `$83`. The expected event detail protects
both the selected cell and encoded tile value.

These scenarios establish the runtime harness and a reproducible boot-to-play
and movement baseline. Later subsystem traces should add focused, explicitly
declared state setup where reaching rare mechanics through input alone would
make the evidence prohibitively slow.
