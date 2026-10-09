package main

import "chip8"
import "screen"

ROM_PATH :: "./rom/tetris.rom"
VIDEO_WIDTH :: 64
VIDEO_HEIGHT :: 32
SCALE :: 20
NAME :: "Chip8"

CPU_HZ :: 700.0
TIMER_HZ :: 60.0

main :: proc() {
	platform := screen.init_platform(
		NAME,
		VIDEO_WIDTH * SCALE,
		VIDEO_HEIGHT * SCALE,
		VIDEO_WIDTH,
		VIDEO_HEIGHT,
	)
	defer screen.destroy_platform(platform)

	cpu := chip8.init()
	defer free(cpu)

	chip8.load_font(cpu)
	chip8.read_rom(cpu, ROM_PATH)

	video_pitch := i32(size_of(cpu.graphics[0]) * VIDEO_WIDTH)

	cpu_accumulator: f64 = 0
	timer_accumulator: f64 = 0
	previous_time := screen.get_time()

	for {
		current_time := screen.get_time()
		elapsed := current_time - previous_time
		previous_time = current_time

		if elapsed > 0.1 {
			elapsed = 0.1
		}

		if screen.process_input(platform, cpu.keypad[:]) {
			break
		}

		cpu_accumulator += elapsed * CPU_HZ
		timer_accumulator += elapsed * TIMER_HZ

		for cpu_accumulator >= 1 {
			chip8.emulate_cycle(cpu)
			cpu_accumulator -= 1
		}

		for timer_accumulator >= 1 {
			chip8.update_timers(cpu)
			timer_accumulator -= 1
		}

		screen.update(platform, cpu.graphics[:], video_pitch)

		screen.delay(1)
	}
}
