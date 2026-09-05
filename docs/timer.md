# Countdown timer

`src/game/timer.asm` owns CPU `$A15F-$A225`. The upstream Bisqwit map names
the public entries at `$A15F` and `$A183` as `DecrementTimer` and
`DecrementTimerByOne`; the instruction flow and RAM accesses independently
confirm countdown arithmetic over the four decimal timer digits.

`GameplayUpdateCount` selects how many pending updates are consumed. The same
count is later consumed and cleared by the enemy movement prepass. Each update
adds `TimerDecrementSpeed` to `TimerFraction`; a carry subtracts
`TimerDecrementStep` from `TimerDigit10` and propagates decimal borrow through
the higher digits. Bit 7 of `TimerDecrementStep` records that the displayed
digits changed.

When the PPU update stream is free, the routine calls
`BuildTimerDisplayUpdate` at `$A238`. If that builder reports an all-zero timer, scheduler code
`$33` is started. The final part compares the two high timer digits with a
four-entry BCD threshold table at `$A229`, queues one of two PPU update
streams, and toggles bit 4 of `TimerWarningState` as the threshold is crossed.
The thresholds are `$02`, `$04`, `$10`, and `$23`.

`src/data/timer_warning.asm` owns `$A226-$A237`. The fourth threshold byte at
`$A22C` is deliberately shared with `EnterTimerWarningPpuUpdate`: the two
six-byte streams write two literal bytes at PPU `$23C2`, using `$F0,$30` on
entry and `$A0,$20` on exit. The three bytes at `$A226-$A228` duplicate the
`$20,$69,$44` timer HUD command header, but their consumer has not yet been
proved, so the source keeps the conservative `PreTimerWarningTableBytes` name.

## Display update builder

`src/game/timer_display.asm` owns `$A238-$A273`. It constructs a small update
program in RAM at `$03E6`: a copied three-byte `JSR $4469` prefix, the four
timer digits in most-significant-first order, and two zero terminators. Leading
zero digits are replaced with blank tile `$24`. The OR of all four digits is
left in scratch byte `$02`, which lets `DecrementTimer` detect an all-zero
countdown after the builder returns.

The builder tail-calls `PublishPpuUpdateBuffer`, which publishes `$03E6`
through the shared PPU update pointer. The `$20,$69,$44` bytes decode as a
literal five-tile command targeting PPU `$2069`; their instruction-like
appearance as `JSR $4469` is incidental.

## Runtime cadence

The deterministic runtime harness counts `DecrementTimer` calls over the first
60 frames after `MainGameplayThread` starts. The lightly populated first room
executes 203 calls spanning all 60 frames. The attract demo, with nine active
enemies at its first gameplay frame, executes 52 calls spanning 52 frames.
This confirms that cooperative workload affects service cadence; the routine's
`GameplayUpdateCount` input is therefore essential to accumulated-time
handling rather than a redundant loop count.

`make trace-runtime` reproduces both measurements and validates their exact
summary strings against `scenarios/runtime_scenarios.json`.
