# Code quality

The quality targets follow the same split used by the sibling Pac-Man and
Super Mario Bros. preservation projects.

- `make format` normalizes every ca65 `.asm` and `.inc` source, then runs all
  linters
- `make format-check` checks assembly formatting without changing files
- `make lint-asm` checks the shared assembly style contract
- `make lint-source` checks the repository structure, manifests, source
  contract, debugger JSON, and tracked-binary policy
- `make lint-project` is a compatibility alias for `make lint-source`
- `make lint` runs every linter
- `make test` runs the Python unit-test suite
- `make quality-check` runs lint and tests without requiring a reference ROM
- `make release-check` adds byte-identical ROM verification, room-data
  validation and round trips, semantic reconstruction audit, and scheduler
  entry/call-site, enemy-AI handler-table, enemy-pointer, and static PPU-stream
  audits
- `make check` is the full release check

The address-ordered `src/preservation/prg.asm` is intentionally monolithic at
this stage. Module-size limits and semantic symbol-prefix rules from the more
mature sibling projects will be introduced only as routines and data tables are
identified and moved into named modules. Formatting is safe now because the
release check rebuilds the ROM and compares every byte with the reference.

Comments that contain only an address, optionally followed by encoded bytes,
such as `; $B173` or `; $82AD D0 01`, are rejected as
`machine-code-comment`. They duplicate the assembler listing without
explaining behavior. `make format` removes these pure address/byte dumps
automatically; a comment that also explains the code is kept.
