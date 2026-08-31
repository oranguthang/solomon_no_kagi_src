; Publish the shared RAM update-program buffer for the NMI PPU writer

.segment "PRG_PPU_UPDATE_BUFFER"

PublishPpuUpdateBuffer:
    LDA #<PpuUpdateBuffer
    STA PpuUpdateStreamPointer
    LDA #>PpuUpdateBuffer
    STA PpuUpdateStreamPointer + 1
    RTS
