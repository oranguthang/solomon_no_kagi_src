# Object motion and animation definitions

`LoadObjectMotionAndAnimationDefinition` owns CPU `$8AC0-$8B50`. The active
object loop calls it when either the object type/variant byte or action byte
changes.

Calling convention:

```text
TempPointer08 = current $14-byte object record
X             = object byte 1, type plus low-two-bit variant
A             = object byte 3, current action
Y             = $04, cached-action record offset
```

The entry caches the action in byte 4, selects new signed motion values for
bytes 5 and 8, resets animation counter byte 12, and fills animation delay,
phase, and pointer bytes 13-16. A motion-table value of `$40` means that the
corresponding component is preserved rather than overwritten.

## Motion selection

`ObjectMotionSelectorPointers` at `$D9D3` contains 33 little-endian pointers.
The loader groups byte-1 values in sets of four by calculating
`(type >> 2) * 2`, then indexes the selected table by the action byte. A
nonnegative selector directly indexes paired Y/X values at `$DB99`.

A negative selector is a room-state mask. The loader intersects it with
`RoomStateFlags`, combines the result with the type's low-two-bit variant, and
uses that value for a second lookup in the same selector table. This accounts
for room-dependent motion without changing the object action.

## Animation selection

`ObjectAnimationDescriptorPointers` at `$D0E8` is a parallel 33-pointer table.
Each action selects a four-byte descriptor:

```text
byte 0    initial packed animation phase
byte 1    delay * 2 plus variant-pointer flag in bit 0
bytes 2-3 animation data pointer, or a pointer to variant pointers
```

When byte 1 bit 0 is set, the low two type bits choose one of four
little-endian animation pointers. Otherwise bytes 2-3 are used directly.
The named per-frame stage `AdvanceObjectAnimation` at `$8789` consumes record
bytes 12-16 as a counter, reload delay, packed phase, and animation-data
pointer, confirming the output contract independently of the table layout.
See `docs/object_update_pipeline.md`.

The three ROM table families remain inside the preservation range for now;
their pointer counts and consumers are understood, but their complete payload
will be extracted as a separate data reconstruction.
