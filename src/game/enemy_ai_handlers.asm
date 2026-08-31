; Dispatch one eligible enemy through the inline JumpWithParams appendix

.segment "PRG_ENEMY_AI_HANDLERS"

DispatchEnemyAiHandler:
    LSR A
    LSR A
    JSR $8EA9

EnemyAiHandlerTable:
    .addr $A4B3, $A5DD, $A840, $B0FB
    .addr $A68C, $AA69, $AA6D, $AD37
    .addr $AD37, $AD37, $AD37, $AD37
    .addr $AD37, $AD37, $AD37, $B348
    .addr $B348, $B348, $B178, $B178
    .addr $B178, $A78A, $A78A, $AE51
    .addr $AE51, $AF5C, $AF5C, $A6E0

EnemyAiHandlerCount = (* - EnemyAiHandlerTable) / 2
.assert EnemyAiHandlerCount = 28, error, "unexpected enemy AI handler count"
