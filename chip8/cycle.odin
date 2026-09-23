package chip8


@(require_results)
fetch_opcode :: proc(cpu: ^chip8_cpu) -> u16 {
	opcode := u16(cpu.memory[cpu.program_counter]) << 8 | u16(cpu.memory[cpu.program_counter + 1])
	cpu.program_counter += 2
	return opcode
}

@(require_results)
decode_opcode :: proc(cpu: ^chip8_cpu, opcode: u16) -> decoded_opcode {
	type := opcode & 0xF000 // instruction identifier, the first digit
	nnn := opcode & 0x0FFF //lowest 12 bits of the instruction
	n := opcode & 0x000F // lowest 4 bits of the instruction
	x := (opcode & 0x0F00) >> 8 // lower bits of the high byte of the instruction
	y := (opcode & 0x00F0) >> 4 // upper bits of the low byte of the instruction
	kk := opcode & 0xFF // the lowest 8 bits of an instruction
	return decoded_opcode{type = type, x = x, y = y, n = n, nnn = nnn, kk = kk}
}

update_timers :: proc(cpu: ^chip8_cpu) {
	if cpu.delay_timer > 0 {
		cpu.delay_timer -= 1
	}
	if cpu.sound_timer > 0 {
		cpu.sound_timer -= 1
	}
}
