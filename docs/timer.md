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

When the PPU update stream is free, the routine calls the still-unreconstructed
builder at `$A238`. If that builder reports an all-zero timer, scheduler code
`$33` is started. The final part compares the two high timer digits with a
four-entry threshold table at `$A229`, queues one of two PPU update streams,
and toggles bit 4 of `TimerWarningState` as the threshold is crossed.

## Display update builder

`src/game/timer_display.asm` owns `$A238-$A273`. It constructs a small update
program in RAM at `$03E6`: a copied three-byte `JSR $4469` prefix, the four
timer digits in most-significant-first order, and two zero terminators. Leading
zero digits are replaced with blank tile `$24`. The OR of all four digits is
left in scratch byte `$02`, which lets `DecrementTimer` detect an all-zero
countdown after the builder returns.

The builder tail-calls `PublishPpuUpdateBuffer`, which publishes `$03E6`
through the shared PPU update pointer. The generic writer at `$4469`, threshold
table, and warning PPU streams remain raw addresses until their containing
systems are independently reconstructed.
