# Provenance

## Preservation listing

- Repository: <https://github.com/rbmichael/solomons_key_disassembly>
- Imported file: `solomonskey.asm`
- Attribution in file: `ninespaces`
- Upstream state: two commits, no explicit license observed at import time
- Role here: byte-identical address-ordered baseline

The imported comments record PRG CRC32 `0771c34f`, CHR CRC32 `fad8a464`, and
headerless combined CRC32 `40684e95`. This project's independent build produces
the known headered SHA-1 `18102689fd35c7d531a5e6241b06b748accab2f6`.

## RAM and code map

- Bisqwit map: <https://bisqwit.iki.fi/jutut/solokey.map>
- TASVideos discussion: <https://tasvideos.org/Forum/Posts/User/Bisqwit?CurrentPage=38&PageSize=25&Sort=CreateTimestamp>
- Role here: scheduler, object-pool, RAM, and initial routine hypotheses

## Room formats

- Repository: <https://github.com/kaimitai/skchain>
- ROM map: `docs/solomon's_key_rom_map.md` in that repository
- Role here: room pointers, block planes, enemy/item streams, metadata, and
  multi-region offsets

## Additional upstream links

- RHDN document 902 archive entry: <https://www.romhacking.net/documents/902/>
- Shared research spreadsheet: <https://docs.google.com/spreadsheets/d/1EKLm0fHJ-rp5udljMHu-O83MaiY2XTmdcYA7ya-KYNQ/edit?usp=sharing>
- Cartridge record: <https://nescartdb.com/profile/view/900/solomons-key>

Local clones used during research live beneath ignored `references/` and are
not part of the project history.

## Semantic rename ledger

`docs/provenance/label_renames.json` records every accepted ROM-label rename
with its linked address, previous identifier, confidence, and concise evidence.
`make reconstruction-audit` rejects duplicate entries, missing evidence,
missing source labels, and any disagreement with the ld65 label file.
