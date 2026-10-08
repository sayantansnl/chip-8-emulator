package chip8

@(require_results)
fetch_opcode :: proc(cpu: ^CPU) -> u16 {
	opcode := u16(cpu.memory[cpu.program_counter]) << 8 | u16(cpu.memory[cpu.program_counter + 1])
	cpu.program_counter += 2
	return opcode
}

@(require_results)
decode_opcode :: proc(cpu: ^CPU, opcode: u16) -> decoded_opcode {
	type := opcode & 0xF000 // instruction identifier, the first digit
	nnn := opcode & 0x0FFF //lowest 12 bits of the instruction
	n := opcode & 0x000F // lowest 4 bits of the instruction
	x := (opcode & 0x0F00) >> 8 // lower bits of the high byte of the instruction
	y := (opcode & 0x00F0) >> 4 // upper bits of the low byte of the instruction
	kk := opcode & 0x00FF // the lowest 8 bits of an instruction
	return decoded_opcode{type = type, x = x, y = y, n = n, nnn = nnn, kk = kk}
}

execute_opcode :: proc(cpu: ^CPU, deco_op: decoded_opcode) {
	switch deco_op.type {
	case 0x0000:
		switch deco_op.kk {
		case 0x00E0:
			clear_display(cpu)
		case 0x00EE:
			return_from_subroutine(cpu)
		}
	case 0x1000:
		jump_to_nnn(cpu, deco_op.nnn)
	case 0x2000:
		call_subroutine_at_nnn(cpu, deco_op.nnn)
	case 0x3000:
		skip_next_instruction_if_Vx_equals_kk(cpu, deco_op.x, deco_op.kk)
	case 0x4000:
		skip_next_instruction_if_Vx_not_equals_kk(cpu, deco_op.x, deco_op.kk)
	case 0x6000:
		set_register_Vx_to_kk(cpu, deco_op.x, deco_op.kk)
	case 0x7000:
		add_kk_to_register_Vx(cpu, deco_op.x, deco_op.kk)
	case 0x8000:
		switch deco_op.n {
		case 0x0000:
			set_Vx_equals_Vy(cpu, deco_op.x, deco_op.y)
		case 0x0001:
			set_Vx_equals_Vx_or_Vy(cpu, deco_op.x, deco_op.y)
		case 0x0002:
			set_Vx_equals_Vx_and_Vy(cpu, deco_op.x, deco_op.y)
		case 0x0003:
			set_Vx_equals_Vx_XOR_Vy(cpu, deco_op.x, deco_op.y)
		case 0x0004:
			set_Vx_equals_Vx_plus_Vy_and_Vf_to_carry(cpu, deco_op.x, deco_op.y)
		case 0x0005:
			set_Vx_equals_Vx_minus_Vy_and_Vf_to_not_borrow(cpu, deco_op.x, deco_op.y)
		case 0x0006:
			set_Vx_equals_Vx_SHR_1(cpu, deco_op.x)
		case 0x0007:
			set_Vx_equals_Vy_minus_Vx_and_Vf_to_not_borrow(cpu, deco_op.x, deco_op.y)
		case 0x000E:
			set_Vx_equals_Vx_SHL_1(cpu, deco_op.x)
		}
	case 0xA000:
		set_I_register_to_nnn(cpu, deco_op.nnn)
	case 0xD000:
		draw_sprite(cpu, deco_op.x, deco_op.y, deco_op.n)
	}
}

update_timers :: proc(cpu: ^CPU) {
	if cpu.delay_timer > 0 {
		cpu.delay_timer -= 1
	}
	if cpu.sound_timer > 0 {
		cpu.sound_timer -= 1
	}
}
