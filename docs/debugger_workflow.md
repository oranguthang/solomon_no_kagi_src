# Debugger workflow

Use the exact image produced by `make verify`; a different regional revision
invalidates the addresses in this document.

## Mesen 2 setup

1. Run `make verify` and open `build/native/solomons_key.nes`.
2. Open the debugger and import `build/native/solomons_key.lbl` if Mesen does
   not discover it automatically.
3. Add the starting watches from `config/debugger_watches.json`.
4. Add only the breakpoints needed for the current question from
   `config/debugger_breakpoints.json`; the scheduler breakpoint is extremely
   hot and should normally log conditionally rather than pause.
5. Record ROM SHA-1, room, input frame, PC, context index, SP, and affected RAM
   bytes with every observation.

## Scheduler trace

At `$8DB4`, log the current `$0302`, CPU SP, and bytes `$0012-$0019`. Compare a
quiet room against a room with many spawned enemies. The first goal is to prove
which index owns Dana input, enemy AI, movement integration, room services, and
audio—not merely to count calls.

## Object-field trace

Use write breakpoints on one `$14`-byte record at a time. Start with Dana at
`$057F-$0592`, then compare the same offsets in the first enemy at
`$05CF-$05E2`. A field should receive a semantic name only after its writers,
readers, and visible effect agree.

## Room-loader trace

Break on writes beginning at `$0304` during a room transition. Correlate each
write with the decoded JSON from `scripts/room_data.py --room N`. This separates
fixed room input from later runtime mutations such as revealed items, broken
blocks, key state, and door state.

Runtime findings belong in a focused document or reproducible scenario, while
unresolved contradictions belong in `docs/unknowns.md`.
