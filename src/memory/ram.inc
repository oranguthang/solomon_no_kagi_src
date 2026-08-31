; Confirmed and high-confidence RAM aliases from Bisqwit's map
; These aliases are introduced without rewriting operands in the preservation
; listing yet. See docs/naming.md for the evidence rule

TempPointer00 = $0000
TempPointer04 = $0004
TempPointer08 = $0008
TempPointer0A = $000A
TempPointer0C = $000C
TempPointer0E = $000E
NmiSavedX = $0010
NmiSavedY = $0011
PpuUpdateStreamPointer = $001A
TimerUpdateCount = $0023

ThreadStackPointers = $0012
ThreadStackPointerCount = 8
PpuScrollX = $001E
PpuScrollY = $001F
ThreadIndex = $0302

PpuCtrlShadow = $0300
PpuMaskShadow = $0301
ActiveThreadMask = $0303
PendingThreadStarts = $041F

WarmBootSignature = $07F0
WarmBootMarker = $07F4
WarmBootDefaultState = $07F6

Joypad1Raw = $0082
Joypad2Raw = $0083
Joypad1Cached = $03E4
Joypad2Cached = $03E5

OamBuffer = $0210
OamBufferSize = $0100
RoomMap = $0304

CurrentRoomIndex = $0428
FireballState = $0429
FireballActive = $042A
InventorySlotCount = $042B
FireballLifeCounter1Lo = $042C
FireballLifeCounter1Hi = $042D
InventorySlotsHigh = $042E
InventorySlotsLow = $042F
FireballLifetimeLo = $0432
FireballLifetimeHi = $0433
TimerWarningState = $0434
TimerDecrementStep = $0435
TimerDecrementSpeed = $0436
TimerFraction = $0437
TimerDigit10 = $0438
TimerDigit100 = $0439
TimerDigit1000 = $043A
TimerDigit10000 = $043B
ScoreDigits = $044A
RemainingLives = $0452
FairiesCollected = $0453
FairiesQueued = $0454

EnemyAiState = $04F7
EnemyAiStateStride = 8
EnemyAiStateCount = 17

ObjectRecordSize = $14
DanaObject = $057F
MagicSparkObject = $0593
FireballObject = $05A7
EnemyObjects = $05CF
EnemyObjectCount = 17
