package chip8

import "core:fmt"
import "core:log"
import "core:os"

init :: proc() -> ^chip8_cpu {
	cpu := &chip8_cpu {
		memory = [4096]u8{},
		program_counter = 0x200,
		v_registers = [16]u8{},
		index_register = 0,
		stack_ptr = 0,
		delay_timer = 0,
		sound_timer = 0,
		graphics = [64 * 32]u8{},
		keypad = [16]u8{},
		stack = [16]u16{},
	}
	return cpu
}

load_font :: proc(cpu: ^chip8_cpu) {
	for f, i in FONT_SET {
		cpu.memory[i] = f
	}
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
	fmt.printfln("CPU memory: %v", cpu.memory)
}

emulate_cycle :: proc(cpu: ^chip8_cpu) {
	opcode := fetch_opcode(cpu)
	deco_op := decode_opcode(cpu, opcode)
	update_timers(cpu)
}
