# Verification contract

The preservation proof has three independent inputs:

1. `assets/manifest.json`, the immutable expected identity;
2. `Solomon's Key (U) [!].nes`, the ignored original image;
3. `build/native/solomons_key.nes`, assembled from tracked PRG source plus the
   ignored CHR extracted by `make split`.

`make verify` does not trust any one of these in isolation. It validates both
complete images against the manifest, then performs direct byte comparisons of
the iNES header, PRG, CHR, headerless payload, full image, and extracted CHR.

## Targets

| Target | Contract |
| --- | --- |
| `verify-reference` | original image matches every manifest field |
| `verify-built` | built image matches every manifest field |
| `verify-header` | built and original iNES header/trainer regions match |
| `verify-prg` | built and original 32 KiB PRG match |
| `verify-chr` | CHR inside built and original images match |
| `verify-payload` | headerless PRG+CHR payloads match |
| `verify-rom` | complete headered files match |
| `verify-assets` | ignored extracted CHR matches original CHR |
| `check-assets` | alias for `verify-assets` |
| `verify` | aggregate of every target above |
| `rom-info` | print and validate identities for original and built images |
| `release-check` | lint, tests, complete verification, room decoding |
| `check` | alias for `release-check` |

Focused region targets deliberately compare only their named output region.
For example, `verify-prg` can prove that a source-only PRG reconstruction is
correct even while investigating a separate CHR problem. `verify` remains the
release gate and accepts no differences anywhere.

## Failure diagnostics

The comparison script reports the first different byte. PRG failures include
both the PRG offset and mapped CPU address; CHR failures include the 8 KiB CNROM
bank and bank-relative offset. Length differences report `EOF` on the missing
side. This makes a failed proof actionable without opening a hex editor first.

## Typical workflow

```bash
make split
make verify-prg
make verify
make release-check
```

`make clean` removes only `build/`; it preserves the ignored extracted CHR so a
clean rebuild does not require repeating `make split`.
