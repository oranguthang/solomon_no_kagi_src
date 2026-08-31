# Non-Dana object-pool maintenance

Two routines surrounding `LoadObjectPointer` sweep all twenty object records
after Dana. Both initialize `X` to `$13`, use the pointer helper, decrement to
zero, and therefore cover the magic spark, fireball, auxiliary object, and all
seventeen enemy records exactly once.

`SetActiveNonDanaObjectState` owns `$CA3C-$CA4E`. For each record it tests byte
0 and replaces that byte with scratch value `$02` only when the old value is
negative. Nonnegative/inactive records are left unchanged. Four callers use
replacement values `$00`, `$80`, or `$82`; the exact meanings of those active
state values remain tied to their surrounding transitions.

`DeactivateAllNonDanaObjects` owns `$CA5A-$CA6D`. It unconditionally clears
byte 0 and writes the offscreen sentinel `$F8` to byte 7 in every non-Dana
record. Its two callers use it during whole-room or scene teardown.

The nine bytes at `$CA33-$CA3B` immediately before the first routine have no
control-flow references and remain preservation data. They are deliberately
not absorbed into either code module until their format and owner are proven.
