package chip8

import "core:log"
import "core:os"

chip8_cpu :: struct {
	opcode:          u16,
	memory:          [4096]u8,
	v_registers:     [16]u8,
	index_register:  u16,
	program_counter: u16,
	graphics:        [64 * 32]u8,
	delay_timer:     u8,
	sound_timer:     u8,
	keypad:          [16]u8,
	stack:           [16]u16,
	stack_ptr:       u16,
}

FONT_SET :: [80]u8 {
	0xF0,
	0x90,
	0x90,
	0x90,
	0xF0, // 0
	0x20,
	0x60,
	0x20,
	0x20,
	0x70, // 1
	0xF0,
	0x10,
	0xF0,
	0x80,
	0xF0, // 2
	0xF0,
	0x10,
	0xF0,
	0x10,
	0xF0, // 3
	0x90,
	0x90,
	0xF0,
	0x10,
	0x10, // 4
	0xF0,
	0x80,
	0xF0,
	0x10,
	0xF0, // 5
	0xF0,
	0x80,
	0xF0,
	0x90,
	0xF0, // 6
	0xF0,
	0x10,
	0x20,
	0x40,
	0x40, // 7
	0xF0,
	0x90,
	0xF0,
	0x90,
	0xF0, // 8
	0xF0,
	0x90,
	0xF0,
	0x10,
	0xF0, // 9
	0xF0,
	0x90,
	0xF0,
	0x90,
	0x90, // A
	0xE0,
	0x90,
	0xE0,
	0x90,
	0xE0, // B
	0xF0,
	0x80,
	0x80,
	0x80,
	0xF0, // C
	0xE0,
	0x90,
	0x90,
	0x90,
	0xE0, // D
	0xF0,
	0x80,
	0xF0,
	0x80,
	0xF0, // E
	0xF0,
	0x80,
	0xF0,
	0x80,
	0x80, // F
}

init :: proc() -> ^chip8_cpu {
	cpu := &chip8_cpu {
		memory = [4096]u8{},
		program_counter = 0x200,
		opcode = 0,
		v_registers = [16]u8{},
		index_register = 0,
		stack_ptr = 0,
		delay_timer = 0,
		sound_timer = 0,
		graphics = [64 * 32]u8{},
		keypad = [16]u8{},
		stack = [16]u16{},
	}
	for f, i in FONT_SET {
		cpu.memory[i] = f
	}
	return cpu
}

read_rom :: proc(cpu: ^chip8_cpu, rom_path: string) {
	data, err := os.read_entire_file(rom_path, context.allocator)
	if err != nil {
		log.errorf("couldn't read log file, error: %v", err)
	}
	defer delete(data, context.allocator)
	for i in 0 ..< len(data) {
		cpu.memory[0x200 + i] = data[i]
	}
}
