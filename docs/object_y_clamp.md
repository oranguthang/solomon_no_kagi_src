# Object Y-coordinate surface clamp

`src/game/object_y_clamp.asm` owns CPU `$8A62-$8A7E`. Bisqwit's map names its
single entry `ObjectClampYCoordinateToSurface`; all three static callers now
use that symbol.

Calling convention:

```text
input:      TempPointer08 = object record
output:     object byte 7 aligned down to a multiple of 16
            object byte 5 reduced to its previous sign bit ($00 or $80)
preserved:  none of A, X, Y
clobbered:  A, X, Y, TempPointer0A
```

Byte 7 is the integer Y coordinate shared by the `$14`-byte object layout. The
routine saves its low nibble in scratch byte `$0A` and subtracts it, snapping
the coordinate to the top of the containing 16-pixel row. It then rotates the
old high bit of byte 5 through carry into a fresh zero accumulator, retaining
only `$00` or `$80`.

The three callers combine the clamp with adjacent horizontal/vertical object
collision helpers. Those routines remain outside this module until their
directional contracts and object-field effects are independently proven.
