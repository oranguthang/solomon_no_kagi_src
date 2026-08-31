; Stop every secondary scheduler context except the caller-selected context

.segment "PRG_SECONDARY_THREAD_RESET"

ThreadShutdownWaitMask = $02
ThreadShutdownWaitAddress = $78
SchedulerThreadIndexMask = $07
OtherSecondaryThreadCount = $07
PendingThreadStartCount = $04
TransitionGameplayFlagsMask = $FB

ResetOtherSecondaryThreads:
    TXA
    PHA
    LDA #ThreadShutdownWaitMask
    LDX #ThreadShutdownWaitAddress
    JSR WaitForMaskedBitsClear
    PLA
    STA ThreadStopIndex
    LDA #OtherSecondaryThreadCount
    STA RemainingThreadStops

StopNextSecondaryThread:
    INC ThreadStopIndex
    LDA ThreadStopIndex
    AND #SchedulerThreadIndexMask
    BEQ AdvanceSecondaryThreadReset
    JSR StopThread

AdvanceSecondaryThreadReset:
    DEC RemainingThreadStops
    BNE StopNextSecondaryThread
    LDX #PendingThreadStartCount - 1
    LDA #$00

ClearPendingThreadStart:
    STA PendingThreadStarts,X
    DEX
    BPL ClearPendingThreadStart
    LDA GameplayFlags
    AND #TransitionGameplayFlagsMask
    STA GameplayFlags
    LSR $87
    ASL $87
    RTS
