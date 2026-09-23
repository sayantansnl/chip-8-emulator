package main

import "chip8"

ROM_PATH :: "./rom/2-ibm-logo.ch8"

main :: proc() {
	// TODO:
	// Setup render system and register input callbacks
	//graphics.new_window()
	// Initialize the Chip8 system and load the game into memory
	cpu := chip8.init()
	chip8.load_font(cpu)
	chip8.read_rom(cpu, ROM_PATH)
	// Emulation loop
}
