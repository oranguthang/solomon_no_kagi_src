# Cooperative counter wait

`WaitForZeroPageCounterAboveThreshold` at `$9C52-$9C5F` provides a shared
delay primitive for the cooperative scheduler. The caller supplies an
unsigned threshold in `A` and a zero-page counter address in `X`. The routine
preserves both values across `SwitchThreads` and returns only after the
selected counter becomes strictly greater than the threshold.

All current call sites select bytes in `$20-$27`. The active gameplay path in
NMI increments every byte in that range once per serviced frame, so callers
can reset one counter and wait without blocking the other cooperative
contexts. The comparison is `CMP ZeroPageCounterBase,X` followed by `BCS`:
equality therefore continues waiting, and counter wraparound is not handled
inside this routine.

## Standard gameplay delay setup

`ResetAndSelectGameplayDelayCounter` at `$915E-$9164` prepares the most common
calling convention. It clears `GameplayDelayCounter` at `$21` and returns
`X = $21`, ready for `WaitForZeroPageCounterAboveThreshold`. Seven call sites
use this pair for delays with thresholds from `$08` through `$A0`.
