package main

import "chip8"
import "screen"

ROM_PATH :: "./rom/ibm.ch8"
VIDEO_WIDTH :: 64
VIDEO_HEIGHT :: 32
SCALE :: 10
NAME :: "Chip8"

main :: proc() {
	platform := screen.init_platform(
		NAME,
		VIDEO_WIDTH * SCALE,
		VIDEO_HEIGHT * SCALE,
		VIDEO_WIDTH,
		VIDEO_HEIGHT,
	)
	cpu := chip8.init()
	defer free(cpu)
	chip8.load_font(cpu)
	chip8.read_rom(cpu, ROM_PATH)

	video_pitch: i32 = size_of(cpu.graphics[0]) * VIDEO_WIDTH

	for {
		quit := screen.process_input(platform, cpu.keypad[:])
		if quit {
			screen.destroy_platform(platform)
			break
		}
		chip8.emulate_cycle(cpu)
		screen.update(platform, cpu.graphics[:], video_pitch)
	}
}
