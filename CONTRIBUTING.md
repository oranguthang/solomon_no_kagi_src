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

## Validation workflow

Run `make format` before committing assembly changes; it performs only the
project's safe whitespace normalization and then runs every linter. `make lint`
is read-only and checks assembly style, all Python and JSON syntax, local
documentation links, source contracts, and the private/generated file policy.
Run `make test` for contract tests and `make verify` whenever source or build
logic changes. The release boundary is accepted only by `make release-check`.

Never weaken an expected hash, runtime event, or source-layout fingerprint to
make a changed result pass. Update a contract only when the change is understood
and its evidence is committed with it.

## Commit messages

Write the subject and body in English. Use a concrete result-oriented subject
without a trailing period; standalone `Fix`, `Update`, `Changes`, and `WIP`
subjects are not acceptable. Follow the subject with two or three substantive
paragraphs that describe the actual diff, the affected boundary, and the reason
or evidence for the decision.

Keep one architectural or release task per commit. A commit prepared with Codex
ends, after a blank line, with exactly:

```text
Co-Authored-By: Codex <noreply@openai.com>
```

Do not add that trailer when Codex did not participate. The title `Complete
Source Reconstruction X.Y` is reserved for the final release commit after the
entire pre-tag gate has passed.
