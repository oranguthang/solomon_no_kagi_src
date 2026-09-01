# Static PPU update queue

`QueueStaticPpuUpdateStream` at `$9471-$9487` is the producer for 18
ROM-resident PPU update programs. The caller supplies a zero-based stream
index in `A`.

If `PpuUpdateStreamPointer + 1` is nonzero, the producer preserves the index on
the current cooperative context's stack and yields through `SwitchThreads`.
Once the NMI consumer clears that high byte, the producer indexes parallel
low- and high-byte tables at `$9488` and `$949A` and publishes the selected
address through `PpuUpdateStreamPointer`.

The routine therefore serializes static updates with RAM-buffer producers; it
does not overwrite a stream still being consumed. Eleven call sites select
indices spanning the complete `$00-$11` table. The pointer tables and their
18 target programs occupy the adjacent `$9488-$961A` data range. They are
source-owned by `src/data/static_ppu_update_streams.asm`: pointer order follows
the public indices, while stream labels remain in physical ROM order.

`make ppu-update-report` emits the decoded pointers, commands, PPU addresses,
increments, modes, counts, and payloads. `make ppu-update-audit` binds the
tables and complete payload range to `config/ppu_update_streams.json`, checks
that the 18 programs cover every byte exactly once, and re-encodes each stream
byte-for-byte. The audit is part of `make release-check`.

The source representation uses `PpuUpdateCommand` headers rather than opaque
control bytes. Each header names its PPU address, repeat/literal mode, and
write count; payload bytes remain exact tile or palette values. The split
pointer tables use `<` and `>` references to the 18 stream labels, so linker
movement cannot silently detach an index from its program.
