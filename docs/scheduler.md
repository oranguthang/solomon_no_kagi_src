# Cooperative scheduler

## Owned range and contexts

`src/system/scheduler.asm` owns CPU `$8D5F-$8E46` (232 bytes). It implements
eight cooperative contexts over the 6502 hardware stack page. The saved SP for
each context lives in `ThreadStackPointers`, and `ThreadIndex` selects the
current slot.

`InitialThreadStackPointers` contains:

```text
context 0  1  2  3  4  5  6  7
SP      FC DC BC 9C 7C 5C 3C 1C
```

The descending order gives each context a roughly `$20`-byte partition.

## Context switch

`SwitchThreads` performs the complete cooperative handoff:

1. copy the hardware SP to `ThreadStackPointers[ThreadIndex]`;
2. increment `ThreadIndex` modulo eight;
3. load the selected saved SP and execute `TXS`;
4. execute `RTS`, which returns through the continuation on the newly selected
   stack rather than the caller's original stack.

There is no register-file copy. Callers must treat A, X, Y, and flags according
to their own continuation contract; only the stack continuation is switched.

## Starting and stopping contexts

`StartThread` accepts a packed byte. Its high nibble chooses the context and its
low nibble chooses a two-byte entry from the base selected through
`ThreadEntryTableBases`. It marks the context active, resets its SP, copies the
selected return address onto its stack partition, and can immediately select
that context.

`StopThread` resets the requested SP, installs `IdleThreadLoop - 1` as its next
RTS continuation, and clears the corresponding `ActiveThreadMask` bit. If the
stopped context is current, it also restores the reset SP before returning.
Idle contexts repeatedly call `SwitchThreads`.

All 61 direct calls to the three scheduler entry points use these semantic
symbols; no source call site retains raw `$8D5F`, `$8DB4`, or `$8DCA` operands.

The packed entry table is now decoded and machine-checked. Sixteen distinct
static codes occur in 18 immediate call sites, plus three calls whose A value
is selected dynamically. See `docs/scheduler_entries.md` for the complete
context/selector/return/entry table and the important RTS-plus-one convention.

One dynamically selected target is independently identified: context 2
selector 1, packed code `$21`, stores `$8E46` and enters `PauseGameThread` at
`$8E47`. The semantic pointer is emitted as `PauseGameThread - 1` in the table.

## Runtime scheduling evidence

The first 24 `SwitchThreads` entries after gameplay begins follow the strict
cycle `3,4,5,6,7,0,1,2` in both the user-started first room and the populated
attract demo. Over the first 60 gameplay frames, Room 1 records context switch
counts of `829,828,828,829,829,829,829,829`; the attract demo records exactly
205 for every context. Idle contexts therefore preserve round-robin order but
cycle substantially faster when less cooperative work is runnable.

These observations are generated and checked by `make trace-runtime`; exact
event series and counts live in `scenarios/runtime_scenarios.json`.

The remaining evidence task is to assign all eight contexts stable subsystem
responsibilities. A deeper trace must add SP, `ActiveThreadMask`, all eight
saved SP bytes, and continuation addresses at each selected switch boundary.
