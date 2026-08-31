; Confirmed and high-confidence RAM aliases from Bisqwit's map
; These aliases are introduced without rewriting operands in the preservation
; listing yet. See docs/naming.md for the evidence rule

TempPointer00 = $0000
TempPointer02 = $0002
TempPointer04 = $0004
CoordinateY = $0004
CoordinateX = $0005
MapCellIndex = $0004
SpawnYPosition = $0004
SpawnXPosition = $0005
SpawnSlotIndex = $0006
SpawnType = $0007
TempPointer08 = $0008
ControllerPortSample = $0008
ControllerShiftRegister = $0009
TempPointer0A = $000A
CoordinateClampRemainder = $000A
CoordinateClampDelta = $000B
TempPointer0C = $000C
TempPointer0E = $000E
NmiSavedX = $0010
NmiSavedY = $0011
PpuUpdateStreamPointer = $001A
GameplayUpdateCount = $0023
EnemyAiPointer = $002C
EnemyObjectPointer = $002E

ThreadStackPointers = $0012
ThreadStackPointerCount = 8
PpuScrollX = $001E
PpuScrollY = $001F
NmiFrameCounter = $0022
ThreadIndex = $0302

PpuCtrlShadow = $0300
PpuMaskShadow = $0301
ActiveThreadMask = $0303
PendingThreadStarts = $041F
SoundEffectQueue = $0423
SoundEffectQueueSize = 3

WarmBootSignature = $07F0
WarmBootMarker = $07F4
WarmBootDefaultState = $07F6

Joypad1Raw = $0082
Joypad2Raw = $0083
GameStateFlags = $0078
Joypad1Cached = $03E4
Joypad2Cached = $03E5
PpuUpdateBuffer = $03E6
TimerDisplayUpdateBuffer = PpuUpdateBuffer
TimerDisplayDigits = $03E9
TimerDisplayTerminator = $03ED

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
ActiveEnemyCount = $0447
ScoreDigits = $044A
RemainingLives = $0452
FairiesCollected = $0453
FairiesQueued = $0454

EnemyAiState = $04F7
EnemyAiStateStride = 8
EnemyAiStateCount = 17

ObjectRecordSize = $14
ObjectYFractionOffset = $05
ObjectYPositionOffset = $07
ObjectXMotionOffset = $08
ObjectXFractionOffset = $09
ObjectXPositionOffset = $0A
DanaObject = $057F
DanaYPosition = DanaObject + ObjectYPositionOffset
DanaXPosition = DanaObject + ObjectXPositionOffset
MagicSparkObject = $0593
FireballObject = $05A7
AuxiliaryObject = $05BB
EnemyObjects = $05CF
EnemyObjectCount = 17
ObjectRecordCount = 4 + EnemyObjectCount
