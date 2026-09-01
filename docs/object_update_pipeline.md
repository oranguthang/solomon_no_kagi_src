# Per-frame object update pipeline

The NMI gameplay path calls `UpdateActiveObjects` at `$863C` once per serviced
frame. Four adjacent source modules own the complete `$863C-$87DF` pipeline.

## Record traversal and definition changes

`UpdateActiveObjects` walks all 21 `$14`-byte object records from index 20 down
to zero through `ObjectRecordPointerLowTable` and
`ObjectRecordPointerHighTable`. Records whose state byte 0 is below `$C0` are
skipped.

For active records, byte 1 is compared with cached byte 2 and action byte 3 is
compared with cached byte 4. A change calls
`LoadObjectMotionAndAnimationDefinition`; otherwise the existing definition
remains active. Each record then passes through:

```text
UpdateObjectMotionAndCollision
  -> fixed-point motion integration
  -> six-cell RoomMap collision sampling
DispatchObjectCollisionResponse
AdvanceObjectAnimation
```

After the sweep, a nonzero low nibble in Dana's collision mask clears gameplay
frame counter `$20`. The precise responsibility of that counter and the
game-facing directional names of the collision bits remain open. The response
dispatcher is documented in `docs/object_collision_response.md`.

## Fixed-point motion

`UpdateObjectMotionAndCollision` starts at `$8689`. Object bytes 5-7 form
signed Y motion, fractional Y, and integer Y; bytes 8-10 are the corresponding
X fields. The routine applies the original signed Y adjustment, sign-extends
both axis deltas, and adds them through the fractional byte into the integer
coordinate.

The code falls directly from segment `PRG_OBJECT_MOTION` into
`SampleObjectRoomMapCollision` at `$86D4`; the callable operation returns only
after collision sampling at `$8788`.

## RoomMap collision sampling

The sampler derives vertical probes from integer Y offsets `-13`, `-1`, and
the following row, and horizontal probes around integer X offsets `-4` and
`+3`. Nibble-boundary tests choose which neighboring packed RoomMap indices
are used. Six selected cells are tested by sign: a negative RoomMap byte sets
the current collision bit.

Those six results are shifted into object byte 11. This proves byte 11 is the
per-frame RoomMap collision mask; exact directional names for all six bits
still require behavior-dispatch traces.

## Animation sequencing

`AdvanceObjectAnimation` at `$8789` decrements byte 12. On underflow it reloads
the counter from byte 13, steps packed phase byte 14 by `$F0`, and normalizes a
wrapped low nibble into both halves. The phase calculation produces
`frame_index * 3`, which indexes the animation pointer in bytes 15-16.

The selected three-byte frame is copied into bytes 17-19: two sprite tile
values and their flags. This is the per-frame consumer of the definition
loaded by `LoadObjectMotionAndAnimationDefinition`.
