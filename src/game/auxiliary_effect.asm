; Initialize the shared auxiliary object from map or pixel coordinates

.segment "PRG_AUXILIARY_EFFECT"

AuxiliaryEffectTemplateSize = $04

SpawnAuxiliaryEffectAtMapCell:
    PHA
    JSR ConvertMapIndexToPixelCoordinates
    JSR SpawnAuxiliaryEffectAtCoordinates
    PLA
    RTS

SpawnAuxiliaryEffectAtCoordinates:
    LDA SpawnYPosition
    STA AuxiliaryYPosition
    LDA SpawnXPosition
    STA AuxiliaryXPosition
    LDX #AuxiliaryEffectTemplateSize - 1

CopyAuxiliaryEffectTemplate:
    LDA AuxiliaryEffectTemplate,X
    STA AuxiliaryObject,X
    DEX
    BPL CopyAuxiliaryEffectTemplate
    RTS

AuxiliaryEffectTemplate:
    .byte $C6, $1C, $FF, $0C

.assert * - AuxiliaryEffectTemplate = AuxiliaryEffectTemplateSize, error, "auxiliary effect template size changed"
