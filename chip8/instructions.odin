package chip8

clear_display :: proc(cpu: ^CPU) {
	cpu.graphics = {}
}

return_from_subroutine :: proc(cpu: ^CPU) {
	cpu.stack_ptr -= 1
	cpu.program_counter = cpu.stack[cpu.stack_ptr]
}

jump_to_nnn :: proc(cpu: ^CPU, nnn: u16) {
	cpu.program_counter = nnn
}

call_subroutine_at_nnn :: proc(cpu: ^CPU, nnn: u16) {
	cpu.stack[cpu.stack_ptr] = cpu.program_counter
	cpu.stack_ptr += 1
	cpu.program_counter = nnn
}

skip_next_instruction_if_Vx_equals_kk :: proc(cpu: ^CPU, x: u16, kk: u16) {
	if cpu.v_registers[x] == u8(kk) {
		cpu.program_counter += 2
	}
}

skip_next_instruction_if_Vx_not_equals_kk :: proc(cpu: ^CPU, x: u16, kk: u16) {
	if cpu.v_registers[x] != u8(kk) {
		cpu.program_counter += 2
	}
}

skip_next_instrution_if_Vx_equals_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	if cpu.v_registers[x] == cpu.v_registers[y] {
		cpu.program_counter += 2
	}
}

set_register_Vx_to_kk :: proc(cpu: ^CPU, x: u16, kk: u16) {
	cpu.v_registers[x] = u8(kk)
}

add_kk_to_register_Vx :: proc(cpu: ^CPU, x: u16, kk: u16) {
	cpu.v_registers[x] += u8(kk)
}

set_I_register_to_nnn :: proc(cpu: ^CPU, nnn: u16) {
	cpu.index_register = nnn
}

set_Vx_equals_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	cpu.v_registers[x] = cpu.v_registers[y]
}

set_Vx_equals_Vx_or_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	cpu.v_registers[x] |= cpu.v_registers[y]
}

set_Vx_equals_Vx_and_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	cpu.v_registers[x] &= cpu.v_registers[y]
}

set_Vx_equals_Vx_XOR_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	cpu.v_registers[x] ~= cpu.v_registers[y]
}

set_Vx_equals_Vx_plus_Vy_and_Vf_to_carry :: proc(cpu: ^CPU, x: u16, y: u16) {
	sum := cpu.v_registers[x] + cpu.v_registers[y]
	cpu.v_registers[x] = sum & 0xFF
	if sum > 0xFF {
		cpu.v_registers[FLAG_REGISTER] = 1
	} else {
		cpu.v_registers[FLAG_REGISTER] = 0
	}
}

set_Vx_equals_Vx_minus_Vy_and_Vf_to_not_borrow :: proc(cpu: ^CPU, x: u16, y: u16) {
	if cpu.v_registers[x] > cpu.v_registers[y] {
		cpu.v_registers[FLAG_REGISTER] = 1
	} else {
		cpu.v_registers[FLAG_REGISTER] = 0
	}
	cpu.v_registers[x] -= cpu.v_registers[y]
}

set_Vx_equals_Vy_minus_Vx_and_Vf_to_not_borrow :: proc(cpu: ^CPU, x: u16, y: u16) {
	if cpu.v_registers[y] > cpu.v_registers[x] {
		cpu.v_registers[FLAG_REGISTER] = 1
	} else {
		cpu.v_registers[FLAG_REGISTER] = 0
	}
	cpu.v_registers[x] = cpu.v_registers[y] - cpu.v_registers[x]
}

set_Vx_equals_Vx_SHR_1 :: proc(cpu: ^CPU, x: u16) {
	//Save LSB in Vf
	cpu.v_registers[FLAG_REGISTER] = cpu.v_registers[x] & 0x1
	cpu.v_registers[x] >>= 1
}

set_Vx_equals_Vx_SHL_1 :: proc(cpu: ^CPU, x: u16) {
	//Save MSB in Vf
	cpu.v_registers[FLAG_REGISTER] = (cpu.v_registers[x] & 0x80) >> 7
	cpu.v_registers[x] <<= 1
}

skip_next_instruction_if_Vx_not_equals_Vy :: proc(cpu: ^CPU, x: u16, y: u16) {
	if cpu.v_registers[x] != cpu.v_registers[y] {
		cpu.program_counter += 2
	}
}

draw_sprite :: proc(cpu: ^CPU, x: u16, y: u16, n: u16) {
	pos_x := int(cpu.v_registers[x]) % 64
	pos_y := int(cpu.v_registers[y]) % 32

	cpu.v_registers[0xF] = 0

	for row in 0 ..< int(n) {
		pixel_y := pos_y + row
		if pixel_y >= 32 {
			break
		}

		sprite_byte := cpu.memory[int(cpu.index_register) + row]

		for col in 0 ..< 8 {
			pixel_x := pos_x + col
			if pixel_x >= 64 {
				break
			}

			if sprite_byte & (u8(0x80) >> uint(col)) != 0 {
				index := pixel_y * 64 + pixel_x

				if cpu.graphics[index] == 0xFFFFFFFF {
					cpu.v_registers[0xF] = 1
				}
				cpu.graphics[index] ~= 0xFFFFFFFF
			}
		}
	}
}
