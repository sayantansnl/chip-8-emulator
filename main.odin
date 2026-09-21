package main

import "chip8"
import "core:fmt"
import "graphics"

main :: proc() {
	fmt.println("Let's make a CHIP-8 emulator")

	// TODO:
	// Setup render system and register input callbacks
	graphics.new_window()
	// Initialize the Chip8 system and load the game into memory
	// Emulation loop

}
