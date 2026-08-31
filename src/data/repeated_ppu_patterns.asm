; Four-byte patterns consumed in descending byte order by the direct PPU writer

.segment "PRG_REPEATED_PPU_PATTERNS"

RepeatedPpuPattern0:
    .byte $a3, $a6, $a6, $a4

RepeatedPpuPattern1:
    .byte $aa, $a2, $a2, $a0

RepeatedPpuPattern2:
    .byte $a4, $a1, $a1, $a0

RepeatedPpuPattern3:
    .byte $a3, $ab, $ab, $aa

.assert * - RepeatedPpuPattern0 = RepeatedPpuPatternSize * 4, error, "repeated PPU pattern data size changed"
