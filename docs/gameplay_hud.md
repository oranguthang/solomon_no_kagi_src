# Gameplay HUD refresh

`src/graphics/gameplay_hud.asm` owns CPU `$C3D4-$C3FD`, the five-byte fairy
template owns `$C3FE-$C402`, and `src/graphics/score_display.asm` owns
`$C403-$C42D`. Together they construct and serialize the score, packed
fireball-inventory, and collected-fairy updates that form the gameplay HUD.

`RefreshGameplayHud` builds the score update, publishes it, calls
`BuildFireballInventoryDisplayUpdate`, and tail-calls the fairy-count builder.
Both later builders begin by waiting for `PpuUpdateStreamPointer + 1` to clear,
so none overwrites `PpuUpdateBuffer` before NMI has consumed the preceding
program.

## Collected fairies

`BuildAndPublishFairyCountDisplay` copies a five-byte template to the shared
buffer, replaces its payload byte with `FairiesCollected`, and publishes it.
The template is one literal byte at PPU `$2071`, followed by the stream
terminator.

## Score

`BuildScoreDisplayUpdate` waits for the update slot but deliberately does not
publish it; callers may extend the buffer before publication. It copies the
three-byte header `$20,$60,$47`, which describes eight literal bytes at PPU
`$2060`. Seven bytes come from `ScoreDigits[0..6]`; leading zero digits become
blank tile `$24`, and the eighth displayed byte is fixed to zero. A second zero
terminates the update program.

The score header at `$C42F` is also the machine-code sequence `JSR $4760` at
the start of the following item routine. Likewise, that routine branches back
to the shared `RTS` at `$C42E`. The source models both facts explicitly:
`ScoreDisplayPpuCommandHeader` and `ReturnFromHudOrItemUpdate` remain in the
adjacent preservation segment, while the semantic score builder ends at
`$C42D` and falls through to that return byte.
