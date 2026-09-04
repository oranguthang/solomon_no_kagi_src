# Contributing

The first invariant is byte identity. Before and after a source change, run:

```bash
make check
```

Do not commit ROM images, extracted assets, build products, emulator states, or
screenshots containing private inputs. The ignore rules cover the usual paths,
and `make lint` rejects tracked ROM/build extensions.

## Source changes

Keep address order until a proposed split has a byte-identical proof. Prefer a
small semantic change followed immediately by `make verify`. When introducing
a name, record the evidence in the relevant document:

- confirmed: format, control flow, and runtime writes agree;
- high-confidence: several independent static observations agree;
- tentative: useful working hypothesis with explicit uncertainty;
- unknown: stable address-based name only.

Do not silently upgrade a tentative name to a fact. Preserve original
addresses in comments or the provenance registry when renaming labels.

Prefer subsystem-sized source files over one file per small address range.
New hand-written assembly files should normally contain roughly 300-700 lines
(slightly outside that range is fine when the subsystem boundary is clearer).
Add short, closely related ranges to an existing thematic file instead of
creating another 50-100-line module. Existing small files may remain separate
until a dedicated consolidation pass can preserve history and address order.

## Data tools

Codecs must reject malformed or truncated data, document their input address
space, and include round-trip or focused fixture tests. File-writing commands
must validate paths and write atomically where practical.
