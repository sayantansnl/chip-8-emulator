package chip8

import "core:log"
import "core:os"

init :: proc() -> ^CPU {
	cpu := new(CPU)
	cpu.memory = [4096]u8{}
	cpu.program_counter = 0x200
	cpu.v_registers = [16]u8{}
	cpu.index_register = 0
	cpu.stack_ptr = 0
	cpu.delay_timer = 0
	cpu.sound_timer = 0
	cpu.graphics = [64 * 32]u32{}
	cpu.keypad = [16]u8{}
	cpu.stack = [16]u16{}
	return cpu
}

load_font :: proc(cpu: ^CPU) {
	for f, i in FONT_SET {
		cpu.memory[FONTSET_START_LOCATION + i] = f
	}
}

read_rom :: proc(cpu: ^CPU, rom_path: string) -> (int, READ_ROM_ERROR) {
	data, err := os.read_entire_file(rom_path, context.allocator)
	if err != nil {
		log.errorf("couldn't read log file, error: %v", err)
		return 0, .Unreadable
	}
	defer delete(data, context.allocator)
	for i in 0 ..< len(data) {
		cpu.memory[0x200 + i] = data[i]
	}
	file_size := len(data)
	if file_size <= 0 || file_size > MAX_ROM_SIZE {
		log.error("invalid file")
		return 0, .Unreadable
	}
	return file_size, .None
}

emulate_cycle :: proc(cpu: ^CPU) {
	opcode := fetch_opcode(cpu)
	deco_op := decode_opcode(cpu, opcode)
	execute_opcode(cpu, deco_op)
}
