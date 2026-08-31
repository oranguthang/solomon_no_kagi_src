# Countdown timer

`src/game/timer.asm` owns CPU `$A15F-$A225`. The upstream Bisqwit map names
the public entries at `$A15F` and `$A183` as `DecrementTimer` and
`DecrementTimerByOne`; the instruction flow and RAM accesses independently
confirm countdown arithmetic over the four decimal timer digits.

`TimerUpdateCount` selects how many pending updates are consumed. Each update
adds `TimerDecrementSpeed` to `TimerFraction`; a carry subtracts
`TimerDecrementStep` from `TimerDigit10` and propagates decimal borrow through
the higher digits. Bit 7 of `TimerDecrementStep` records that the displayed
digits changed.

When the PPU update stream is free, the routine calls the still-unreconstructed
builder at `$A238`. If that builder reports an all-zero timer, scheduler code
`$33` is started. The final part compares the two high timer digits with a
four-entry threshold table at `$A229`, queues one of two PPU update streams,
and toggles bit 4 of `TimerWarningState` as the threshold is crossed.

The rendering builder, threshold table, PPU streams, and sound-queue helper
remain raw addresses because they lie outside this module or still need their
own evidence-backed reconstruction.
