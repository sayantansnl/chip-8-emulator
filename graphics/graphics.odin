package graphics

import rl "vendor:raylib"

new_window :: proc() {
	rl.InitWindow(640, 320, "CHIP-8 emulator")
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.DrawText("This is an emulator in development", 120, 160, 20, rl.WHITE)
		rl.EndDrawing()
	}
	rl.CloseWindow()
}
