package chip8

clear_display :: proc(cpu: ^chip8_cpu) {
	cpu.graphics = {}
}
