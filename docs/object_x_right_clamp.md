# Object X-coordinate right-surface clamp

`ObjectClampXCoordinateToRightSurface` owns CPU `$8AA4-$8ABF`. Its three
callers use the object record selected by `TempPointer08` during collision
response.

Calling convention:

```text
input:      TempPointer08 = object record
output:     object byte 10 has low nibble $C
            object bytes 9 and 8 are zero
preserved:  none of A, X, Y
clobbered:  A, X, Y, CoordinateClampDelta
```

The arithmetic subtracts `(X + 4) & $0F` from the original coordinate.
Exhaustive evaluation of all 256 input values therefore produces the `$...C`
inset of a 16-pixel cell. The final `DEY` leaves zero clear, so the original
`BNE` always reaches the shared `ClearObjectXMotion` tail at `$8A9D`; that tail
clears the motion and fractional fields and returns.

Together with the `$...4` result of `ObjectClampXCoordinateToLeftSurface`, the
two routines establish the object's horizontal collision insets on opposite
sides of a tile boundary.
