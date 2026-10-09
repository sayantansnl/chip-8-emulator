package chip8

import "core:math/rand"

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

jump_to_nnn_plus_V0 :: proc(cpu: ^CPU, nnn: u16) {
	cpu.program_counter = nnn + u16(cpu.v_registers[0])
}

set_Vx_equals_rand_byte_and_kk :: proc(cpu: ^CPU, x: u16, kk: u16) {
	b := rand.uint32()
	cpu.v_registers[x] = u8(b) & u8(kk)
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

skip_next_instruction_if_key_with_Vx_val_pressed :: proc(cpu: ^CPU, x: u16) {
	key := cpu.v_registers[x]
	if cpu.keypad[key] == 1 {
		cpu.program_counter += 2
	}
}

skip_next_instruction_if_key_with_Vx_val_not_pressed :: proc(cpu: ^CPU, x: u16) {
	key := cpu.v_registers[x]
	if cpu.keypad[key] == 0 {
		cpu.program_counter += 2
	}
}

set_Vx_equals_delay_timer_val :: proc(cpu: ^CPU, x: u16) {
	cpu.v_registers[x] = cpu.delay_timer
}

wait_for_key_press :: proc(cpu: ^CPU, x: u16) {
	for i in 0 ..< len(cpu.keypad) {
		if cpu.keypad[i] == 1 {
			cpu.v_registers[x] = u8(i)
			return
		}
	}

	cpu.program_counter -= 2
}

set_delay_timer_to_Vx :: proc(cpu: ^CPU, x: u16) {
	cpu.delay_timer = cpu.v_registers[x]
}

set_sound_timer_to_Vx :: proc(cpu: ^CPU, x: u16) {
	cpu.sound_timer = cpu.v_registers[x]
}

add_I_and_Vx :: proc(cpu: ^CPU, x: u16) {
	cpu.index_register += u16(cpu.v_registers[x])
}

set_I_to_sprite_location_for_Vx :: proc(cpu: ^CPU, x: u16) {
	digit := cpu.v_registers[x]
	cpu.index_register = u16(FONTSET_START_LOCATION + (5 * digit))
}

store_bcd :: proc(cpu: ^CPU, x: u16) {
	val := cpu.v_registers[x]
	//ones-place
	cpu.memory[cpu.index_register + 2] = val % 10
	val /= 10
	//tens-place
	cpu.memory[cpu.index_register + 1] = val % 10
	val /= 10
	//hundreds-place
	cpu.memory[cpu.index_register] = val % 10
}

store_V0_to_Vx_in_memory :: proc(cpu: ^CPU, x: u16) {
	for i in 0 ..= x {
		cpu.memory[cpu.index_register + i] = cpu.v_registers[i]
	}
}

read_registers_from_memory :: proc(cpu: ^CPU, x: u16) {
	for i in 0 ..= x {
		cpu.v_registers[i] = cpu.memory[cpu.index_register + i]
	}
}
