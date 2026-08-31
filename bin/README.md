# Bundled cc65 Tools

This directory contains the two Windows executables required by the native
preservation build. They are development tools only and contain no Solomon's
Key ROM, CHR, audio, screenshot, or save-state data.

## Provenance

Both executables report cc65 version 2.19 at upstream Git revision `0fca835`:

```text
ca65 V2.19 - Git 0fca835
ld65 V2.19 - Git 0fca835
```

Revision `0fca835` was built by the official
[cc65 snapshot workflow](https://github.com/cc65/cc65/actions/workflows/snapshot-on-push-master.yml)
as Snapshot Build 795. The copies tracked here were imported byte-for-byte from
the sibling `smb1_src` preservation project; they have not been patched or
rebuilt locally. Upstream source for the identified revision is available from
the [cc65 repository](https://github.com/cc65/cc65/tree/0fca835).

The files can be identified independently with SHA-256:

| File | Size | SHA-256 |
| --- | ---: | --- |
| `ca65.exe` | 721,629 bytes | `9109d7118ff070e78f031bee4eb776061e56b74e7c8f9f40c70fd6707ea0ac5a` |
| `ld65.exe` | 575,874 bytes | `5f68367a135c578c88744e27ba0b1234604d87ef1ff6294b46fcb031ff984db4` |

The matched assembler/linker pair retains source-file, definition-line, span,
and output-offset records for future debugger integration. Tool provenance does
not replace the byte-identity gate: `make verify` independently checks the
complete image.

## License

The bundled `ca65.exe` and `ld65.exe` are distributed under the cc65 zlib
license. The upstream notice is reproduced unchanged in
[`cc65-LICENSE.txt`](cc65-LICENSE.txt).
