; Solomon's Key NES ROM Disassembly
; PRG CRC32 checksum: 0771c34f
; CHR CRC32 checksum: fad8a464
; Overall CRC32 checksum: 40684e95
; Code base address: $8000
; author: ninespaces
; ROM map info from https://www.romhacking.net/documents/902/
; see also: https://docs.google.com/spreadsheets/d/1EKLm0fHJ-rp5udljMHu-O83MaiY2XTmdcYA7ya-KYNQ/edit?usp=sharing
; preservation baseline imported from:
; https://github.com/rbmichael/solomons_key_disassembly

.setcpu "6502x"
.segment "HEADER"

    .byte "NES", $1a  ; Magic string that always begins an iNES header
    .byte $02  ; Number of 16KB PRG-ROM banks
    .byte $04  ; Number of 8KB CHR-ROM banks
    .byte $30  ; Control bits 1
    .byte $00  ; Control bits 2
    .byte $00  ; Number of 8KB PRG-RAM banks
    .byte $00  ; Video format NTSC/PAL

.include "memory/hardware.inc"
.include "memory/ram.inc"

.include "system/nmi.asm"
.include "system/startup.asm"
.include "system/scheduler.asm"
.include "system/pause_thread.asm"
.include "system/sound_effect_queue.asm"
.include "system/ppu_update_buffer.asm"
.include "system/jump_with_params.asm"
.include "game/coordinate_conversion.asm"
.include "game/main_thread.asm"
.include "game/timer.asm"
.include "game/timer_display.asm"
.include "game/enemy_movement.asm"
.include "game/enemy_ai_dispatch.asm"
.include "game/fireball_lifetime.asm"
.include "game/enemy_initialization.asm"
.include "game/enemy_type_configuration.asm"
.include "data/enemy_types.asm"
.include "game/enemy_ai_handlers.asm"
.include "game/enemy_position.asm"
.include "game/enemy_pointers.asm"
.include "game/enemy_slot_allocation.asm"
.include "data/enemy_record_pointers.asm"
.include "game/enemy_deactivation.asm"
.include "game/current_enemy_deactivation.asm"
.include "preservation/prg.asm"
.include "graphics/chr.asm"
