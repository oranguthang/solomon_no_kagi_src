# Main gameplay thread

`src/game/main_thread.asm` owns CPU `$A000-$A04B`. Scheduler code `$30`
selects context 3, selector 0. Its table slot contains `$9FFF`; because the
scheduler enters the context with `RTS`, this proves `$A000` is the entry point.

The loop invokes four groups of services and yields through `SwitchThreads`
after each group. It then checks `FairiesQueued`, attempts to allocate and
initialize the next fairy when one is pending, and returns to
`MainGameplayThread`. Both the no-fairy path and the failed-allocation path
converge at `ContinueMainGameplayThread`.

The calls whose behavior has not yet been independently established remain
raw addresses. This is intentional: module ownership and loop structure are
confirmed, while names for rendering, object allocation, and fairy setup will
be accepted only with direct static or runtime evidence.

