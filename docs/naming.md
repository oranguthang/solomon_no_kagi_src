# Naming and evidence policy

The imported source contains generated labels and raw addresses. Renaming is a
semantic change to the research record even when it does not change bytes.

Use four confidence classes:

- **confirmed**: a format, control-flow path, and repeatable runtime observation
  agree;
- **high**: multiple independent static observations agree and no conflict is
  known;
- **tentative**: the name is a useful hypothesis but alternatives remain;
- **unknown**: retain an address-based name.

Prefer verbs for routines (`DecodeRoomItems`), nouns for storage
(`CurrentRoomIndex`), and explicit suffixes for representations
(`TimerDigit1000`, `PlayerXFraction`). Do not encode an uncertain interpretation
as a confident name. Preserve the old address in the rename ledger when source
labels begin to move.
