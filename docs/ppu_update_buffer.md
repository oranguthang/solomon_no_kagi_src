# PPU update-buffer publication

`src/system/ppu_update_buffer.asm` owns CPU `$8EA0-$8EA8`. Its single entry,
`PublishPpuUpdateBuffer`, publishes the shared RAM update-program buffer at
`$03E6` through `PpuUpdateStreamPointer` at `$001A-$001B`.

Calling convention:

```text
input:      PpuUpdateBuffer contains a complete update program
output:     PpuUpdateStreamPointer = PpuUpdateBuffer
preserved:  X, Y
clobbered:  A
```

Sixteen static sites call or tail-call the helper. They include the timer
display builder and several still-unreconstructed producers, which is why the
base alias is `PpuUpdateBuffer`; `TimerDisplayUpdateBuffer` remains an equal-
address alias for the decoded timer-specific layout.

During NMI, the high byte of `PpuUpdateStreamPointer` gates the update writer at
`$8B7F`. Reconstructing that consumer and the bytecode understood by its writer
is the next evidence boundary; this module only claims the fully visible
producer-side publication contract.
