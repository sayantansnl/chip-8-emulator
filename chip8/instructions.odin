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

set_register_Vx_to_kk :: proc(cpu: ^CPU, x: u16, kk: u16) {
	cpu.v_registers[x] = u8(kk)
}

add_kk_to_register_Vx :: proc(cpu: ^CPU, x: u16, kk: u16) {
	cpu.v_registers[x] += u8(kk)
}

set_I_register_to_nnn :: proc(cpu: ^CPU, nnn: u16) {
	cpu.index_register = nnn
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
