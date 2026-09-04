# Enemy lifetime transition

`ApplyEnemyLifetimeThreshold` at `$B4C4-$B4F0` is shared by two enemy behavior
dispatch paths. Both are reached only after `RunEnemyAiDispatcher` accepts the
object type with a successful subtraction, so carry is set on entry. The
helper deliberately relies on that carry for its 16-bit low/high subtraction.

AI records whose low two state bits are nonzero bypass the lifetime check.
Otherwise, bytes 2-3 are compared with the room-configured threshold at
`$0426-$0427`. Once the threshold has been reached and object action byte 3 is
nonzero, the helper:

1. clears object action byte 3;
2. clears AI-record byte 1;
3. sets bit 1 in object state byte 0.

The exact interpretation of every AI-record state remains open, so the source
names describe the observed lifetime transition without assigning an enemy-
specific behavior to the resulting state.

The adjacent `$B4F1-$B7FF` range is not executable. Bisqwit's map identifies
all 783 bytes as `FillerBeforeB800`; they remain explicit in the existing
enemy-deactivation source file to preserve the matching ROM without creating
a tiny standalone assembly file.
