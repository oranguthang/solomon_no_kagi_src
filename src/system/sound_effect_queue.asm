; Queue a sound-effect command while preserving the caller's accumulator

.segment "PRG_SOUND_EFFECT_QUEUE"

AddSoundEffect:
    PHA
    TYA
    PHA
    LDY #SoundEffectQueueSize - 1

FindSoundEffectQueueSlot:
    LDA SoundEffectQueue,Y
    BEQ StoreSoundEffectRequest
    DEY
    BNE FindSoundEffectQueueSlot

StoreSoundEffectRequest:
    PLA
    STA SoundEffectQueue,Y
    PLA
    RTS
