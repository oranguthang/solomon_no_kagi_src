PYTHON ?= python
CA65 ?= bin/ca65.exe
LD65 ?= bin/ld65.exe
REFERENCE_ROM ?= Solomon's Key (U) [!].nes
MANIFEST := assets/manifest.json
VERIFY_ROM := scripts/verify_rom.py

BUILD_DIR := build/native
GENERATED_ASSET_DIR := assets/generated
CHR_ASSET := $(GENERATED_ASSET_DIR)/chr/solomons_key.chr
OBJECT := $(BUILD_DIR)/solomons_key.o
ROM := $(BUILD_DIR)/solomons_key.nes
LABELS := $(BUILD_DIR)/solomons_key.lbl
MAP := $(BUILD_DIR)/solomons_key.map
DEBUG := $(BUILD_DIR)/solomons_key.dbg
SOURCE_FILES := src/main.asm src/system/nmi.asm src/system/controller_input.asm \
	src/system/startup.asm \
	src/system/scheduler.asm src/system/pause_thread.asm \
	src/system/sound_effect_queue.asm \
	src/system/ppu_update_buffer.asm src/system/jump_with_params.asm \
	src/system/masked_ram_wait.asm \
	src/system/secondary_thread_reset.asm \
	src/game/room_transition_reset.asm \
	src/graphics/nametable_clear.asm src/data/nametable_clear.asm \
	src/graphics/full_nametable_clear.asm \
	src/graphics/ppu_address.asm \
	src/graphics/direct_ppu_transfer.asm \
	src/graphics/ppu_data_writers.asm src/data/repeated_ppu_patterns.asm \
	src/graphics/room_nametable_frame.asm \
	src/game/object_y_clamp.asm \
	src/game/object_x_left_clamp.asm \
	src/game/main_thread.asm src/game/timer.asm \
	src/game/timer_item_effects.asm \
	src/game/inventory_item_effects.asm \
	src/data/item_scores.asm src/game/auxiliary_effect.asm \
	src/game/score.asm \
	src/game/coordinate_conversion.asm \
	src/game/timer_display.asm src/game/enemy_movement.asm \
	src/game/enemy_ai_dispatch.asm \
	src/game/fireball_lifetime.asm \
	src/game/enemy_initialization.asm \
	src/game/enemy_type_configuration.asm \
	src/data/enemy_types.asm \
	src/game/enemy_ai_handlers.asm \
	src/game/enemy_position.asm \
	src/game/enemy_pointers.asm \
	src/game/enemy_slot_allocation.asm \
	src/data/enemy_record_pointers.asm \
	src/game/enemy_deactivation.asm \
	src/game/current_enemy_deactivation.asm \
	src/game/active_object_states.asm \
	src/game/object_pointer.asm \
	src/game/non_dana_object_deactivation.asm \
	src/preservation/prg.asm \
	src/graphics/chr.asm src/memory/hardware.inc src/memory/ram.inc

.PHONY: all build split verify verify-reference verify-built verify-header \
	verify-prg verify-chr verify-payload verify-rom verify-assets check-assets \
	rom-info rom-info-reference rom-info-built format format-check lint lint-asm \
	lint-source lint-project test quality-check check release-check rooms \
	validate-rooms roundtrip-formats reconstruction-status reconstruction-audit \
	scheduler-report scheduler-audit enemy-ai-report enemy-ai-audit \
	enemy-pointer-report enemy-pointer-audit clean

all: verify

$(BUILD_DIR):
	$(PYTHON) scripts/project.py mkdir --path "$(BUILD_DIR)"

$(CHR_ASSET):
	$(PYTHON) scripts/project.py require --path "$@" --hint "run 'make split' first"

$(OBJECT): $(SOURCE_FILES) $(CHR_ASSET) | $(BUILD_DIR)
	$(CA65) --debug-info -g -o "$@" -l "$(BUILD_DIR)/solomons_key.lst" "src/main.asm"

$(ROM): $(OBJECT) config/linker/cnrom.cfg
	$(LD65) -C config/linker/cnrom.cfg -o "$@" "$<" -Ln "$(LABELS)" -m "$(MAP)" --dbgfile "$(DEBUG)"

build: $(ROM)

verify-reference:
	$(PYTHON) scripts/project.py verify --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

verify-built: $(ROM)
	$(PYTHON) scripts/project.py verify --image "$(ROM)" --manifest "$(MANIFEST)"

verify-header: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region header

verify-prg: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region prg

verify-chr: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

verify-payload: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region payload

verify-rom: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" compare --built "$(ROM)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region rom

verify-assets: $(CHR_ASSET)
	$(PYTHON) "$(VERIFY_ROM)" asset --asset "$(CHR_ASSET)" --reference "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --region chr

check-assets: verify-assets

verify: verify-reference verify-built verify-header verify-prg verify-chr verify-payload verify-rom verify-assets

split:
	$(PYTHON) scripts/project.py split --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)" --output-dir "$(GENERATED_ASSET_DIR)"

rom-info-reference:
	$(PYTHON) "$(VERIFY_ROM)" report --image "$(REFERENCE_ROM)" --manifest "$(MANIFEST)"

rom-info-built: $(ROM)
	$(PYTHON) "$(VERIFY_ROM)" report --image "$(ROM)" --manifest "$(MANIFEST)"

rom-info: rom-info-reference rom-info-built

format:
	$(PYTHON) scripts/asm_style.py --fix src
	$(MAKE) lint

format-check: lint-asm

lint-asm:
	$(PYTHON) scripts/asm_style.py src

lint-source:
	$(PYTHON) scripts/project.py lint

lint-project: lint-source

lint: lint-asm lint-source

test:
	$(PYTHON) -m unittest discover -s tests -v

rooms: $(ROM)
	$(PYTHON) scripts/room_data.py --image "$(ROM)" --pretty

validate-rooms: $(ROM)
	$(PYTHON) scripts/room_data.py --image "$(ROM)" --validate

roundtrip-formats: $(ROM)
	$(PYTHON) scripts/room_data.py --image "$(ROM)" --roundtrip

reconstruction-status:
	$(PYTHON) scripts/reconstruction_status.py report

reconstruction-audit: $(ROM)
	$(PYTHON) scripts/reconstruction_status.py audit --map "$(MAP)" --labels "$(LABELS)"

scheduler-report: $(ROM)
	$(PYTHON) scripts/scheduler_data.py report --image "$(ROM)"

scheduler-audit: $(ROM)
	$(PYTHON) scripts/scheduler_data.py audit --image "$(ROM)"

enemy-ai-report: $(ROM)
	$(PYTHON) scripts/enemy_ai_data.py report --image "$(ROM)"

enemy-ai-audit: $(ROM)
	$(PYTHON) scripts/enemy_ai_data.py audit --image "$(ROM)"

enemy-pointer-report: $(ROM)
	$(PYTHON) scripts/enemy_pointer_data.py report --image "$(ROM)"

enemy-pointer-audit: $(ROM)
	$(PYTHON) scripts/enemy_pointer_data.py audit --image "$(ROM)"

quality-check: lint test

release-check: quality-check verify validate-rooms roundtrip-formats \
	reconstruction-audit scheduler-audit enemy-ai-audit enemy-pointer-audit

check: release-check

clean:
	$(PYTHON) scripts/project.py clean --path build
