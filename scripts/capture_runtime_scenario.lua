-- Capture focused Solomon's Key events from deterministic controller input.

local output_path = assert(os.getenv("SOLOMON_RUNTIME_TRACE"))
local scenario = assert(os.getenv("SOLOMON_RUNTIME_SCENARIO"))
local max_frames = assert(tonumber(os.getenv("SOLOMON_RUNTIME_MAX_FRAMES")))
local input_spec = os.getenv("SOLOMON_RUNTIME_INPUTS") or ""
local output = assert(io.open(output_path, "w"))

local function symbol(name)
    local address = debugger.getsymboloffset(name)
    assert(address ~= nil and address >= 0, "missing debugger symbol: " .. name)
    return address
end

local ram = {
    thread = symbol("ThreadIndex"),
    joypad = symbol("Joypad1Raw"),
    room = symbol("CurrentRoomIndex"),
    timer = symbol("TimerDecrementStep"),
    mirror = symbol("RoomItemRuntimeData"),
    map = symbol("RoomMap"),
    dana = symbol("DanaObject"),
}

local function byte(address)
    return memory.readbyte(address)
end

local function timer_digits()
    return string.format(
        "%02X%02X%02X%02X",
        byte(ram.timer + 3),
        byte(ram.timer + 4),
        byte(ram.timer + 5),
        byte(ram.timer + 6))
end

local function emit(event, detail)
    output:write(string.format(
        "%d,%s,%s,%02X,%02X,%s,%02X,%02X,%02X\n",
        emu.framecount(), event, detail or "", byte(ram.thread), byte(ram.room),
        timer_digits(), byte(ram.dana + 7), byte(ram.dana + 10),
        byte(ram.mirror + 11)))
    output:flush()
end

local seen = {}
local function emit_once(event, detail)
    if seen[event] then
        return
    end
    seen[event] = true
    emit(event, detail)
end

local hooks = {
    {"NMI", "first_nmi"},
    {"ReadJoyPads", "first_joypad_read"},
    {"SwitchThreads", "first_thread_switch"},
    {"RoomLoadThread", "room_load"},
    {"PrepareRoomIntro", "room_intro"},
    {"MainGameplayThread", "gameplay_start"},
    {"DecrementTimer", "first_timer_tick"},
    {"UpdateDanaControlState", "dana_control", true},
    {"UpdateObjectMotionAndCollision", "object_motion", true},
    {"SampleObjectRoomMapCollision", "object_collision", true},
    {"RunEnemyAiDispatcher", "enemy_ai", true},
    {"TryStartBlockMagicAction", "block_magic_request", true},
    {"CreateBlockInRoomMap", "block_created", true},
}

for _, hook in ipairs(hooks) do
    local routine = hook[1]
    local event = hook[2]
    local requires_gameplay = hook[3]
    memory.registerexecute(symbol(routine), function()
        if not requires_gameplay or seen["gameplay_start"] then
            emit_once(event, routine)
        end
    end)
end

memory.registerwrite(ram.map, 192, function(address, size, value)
    if seen["block_magic_request"] then
        emit_once(
            "room_map_write",
            string.format("%04X=%02X", address, value))
    end
end)

local input_ranges = {}
for first, last, buttons in string.gmatch(input_spec, "(%d+)%-(%d+):([^;]+)") do
    table.insert(input_ranges, {
        first = tonumber(first),
        last = tonumber(last),
        buttons = buttons,
    })
end

local function controller_for_frame(frame)
    local state = {}
    for _, range in ipairs(input_ranges) do
        if frame >= range.first and frame <= range.last then
            for button in string.gmatch(range.buttons, "[^+]+") do
                if button == "a" or button == "b" then
                    state[string.upper(button)] = true
                else
                    state[button] = true
                end
            end
        end
    end
    return state
end

output:write("frame,event,detail,thread,room,timer,dana_y,dana_x,active_enemies\n")
emit("trace_start", scenario)

local previous_dana_x = byte(ram.dana + 10)
while emu.framecount() < max_frames do
    joypad.set(1, controller_for_frame(emu.framecount()))
    emu.frameadvance()
    local current_dana_x = byte(ram.dana + 10)
    if bit.band(byte(ram.joypad), 0x01) ~= 0 then
        emit_once("right_input_seen", "Joypad1Raw")
    end
    if bit.band(byte(ram.joypad), 0x40) ~= 0 then
        emit_once("b_input_seen", "Joypad1Raw")
    end
    if bit.band(byte(ram.joypad), 0x80) ~= 0 then
        emit_once("a_input_seen", "Joypad1Raw")
    end
    if bit.band(byte(ram.joypad), 0x10) ~= 0 then
        emit_once("start_input_seen", "Joypad1Raw")
    end
    if seen["right_input_seen"] and current_dana_x ~= previous_dana_x then
        emit_once(
            "dana_horizontal_move",
            string.format("%02X>%02X", previous_dana_x, current_dana_x))
    end
    previous_dana_x = current_dana_x
end

emit("trace_end", scenario)
output:close()
emu.exit()
