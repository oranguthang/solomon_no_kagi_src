; Sample both Demon Mirror bit schedules from the shared 16-bit frame counter

.segment "PRG_DEMON_MIRROR_SCHEDULE"

DemonMirrorPhaseMask = $3F
DemonMirrorLoopHalfMask = $20
DemonMirrorSchedulePendingMask = $C0
DemonMirrorScheduleBitMask = $07
DemonMirrorMaximumActiveEnemies = $0E

UpdateDemonMirrorSpawnSchedule:
    LDA DemonMirrorSpawnTimerHi
    ASL A
    ASL A
    AND #$3C
    STA TempPointer00
    LDA DemonMirrorSpawnTimerLo
    ROL A
    ROL A
    ROL A
    AND #$03
    ORA TempPointer00
    TAX
    LDA DemonMirrorSpawnState
    STA TempPointer00 + 1
    AND #$1F
    STA TempPointer00
    LDA #DemonMirrorSchedulePendingMask
    AND TempPointer00 + 1
    BNE FinishDemonMirrorScheduleUpdate
    TXA
    AND #$1F
    CMP TempPointer00
    BEQ FinishDemonMirrorScheduleUpdate
    STX TempPointer00
    LDA #DemonMirrorLoopHalfMask
    AND TempPointer00 + 1
    ORA TempPointer00
    STA DemonMirrorSpawnState
    TAY
    AND #DemonMirrorScheduleBitMask
    STA TempPointer00
    TAX
    TYA
    LSR A
    LSR A
    LSR A
    TAY
    LDA (DemonMirrorSchedulePointers),Y

SelectFirstDemonMirrorScheduleBit:
    ASL A
    DEX
    BPL SelectFirstDemonMirrorScheduleBit
    JSR CheckDemonMirrorSpawnCapacity
    ROL TempPointer00 + 1
    LDX TempPointer00
    LDA (DemonMirrorSchedulePointers + 2),Y

SelectSecondDemonMirrorScheduleBit:
    ASL A
    DEX
    BPL SelectSecondDemonMirrorScheduleBit
    JSR CheckDemonMirrorSpawnCapacity
    LDA TempPointer00 + 1
    ROR A
    ROR A
    AND #DemonMirrorSchedulePendingMask
    BEQ FinishDemonMirrorScheduleUpdate
    JMP SpawnScheduledDemonMirrorObjects

CheckDemonMirrorSpawnCapacity:
    BCC FinishDemonMirrorScheduleUpdate
    LDA #DemonMirrorMaximumActiveEnemies
    CMP ActiveEnemyCount

FinishDemonMirrorScheduleUpdate:
    RTS
