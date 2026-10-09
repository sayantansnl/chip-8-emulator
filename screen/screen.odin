package screen

import sdl "vendor:sdl2"

SCREEN :: struct {
	window:   ^sdl.Window,
	renderer: ^sdl.Renderer,
	texture:  ^sdl.Texture,
}

init_platform :: proc(
	title: cstring,
	window_width: i32,
	window_height: i32,
	texture_width: i32,
	texture_height: i32,
) -> ^SCREEN {
	sdl.Init(sdl.INIT_VIDEO)
	window := sdl.CreateWindow(title, 0, 0, window_width, window_height, sdl.WINDOW_SHOWN)
	renderer := sdl.CreateRenderer(window, -1, sdl.RENDERER_ACCELERATED)
	texture := sdl.CreateTexture(
		renderer,
		sdl.PixelFormatEnum.RGBA8888,
		sdl.TextureAccess.STREAMING,
		texture_width,
		texture_height,
	)
	screen := new(SCREEN)
	screen.window = window
	screen.renderer = renderer
	screen.texture = texture
	return screen
}

destroy_platform :: proc(screen: ^SCREEN) {
	sdl.DestroyTexture(screen.texture)
	sdl.DestroyRenderer(screen.renderer)
	sdl.DestroyWindow(screen.window)
	sdl.Quit()
	free(screen)
}

update :: proc(screen: ^SCREEN, buffer: []u32, pitch: i32) {
	sdl.UpdateTexture(screen.texture, nil, raw_data(buffer), pitch)
	sdl.RenderClear(screen.renderer)
	sdl.RenderCopy(screen.renderer, screen.texture, nil, nil)
	sdl.RenderPresent(screen.renderer)
}

process_input :: proc(screen: ^SCREEN, keypad: []u8) -> bool {
	quit := false
	event: sdl.Event

	for sdl.PollEvent(&event) {
		#partial switch event.type {
		case .QUIT:
			quit = true
		case .KEYDOWN:
			#partial switch event.key.keysym.sym {
			case .ESCAPE:
				quit = true
			case .x:
				keypad[0] = 1
			case .NUM1:
				keypad[1] = 1
			case .NUM2:
				keypad[2] = 1
			case .NUM3:
				keypad[3] = 1
			case .q:
				keypad[4] = 1
			case .w:
				keypad[5] = 1
			case .e:
				keypad[6] = 1
			case .a:
				keypad[7] = 1
			case .s:
				keypad[8] = 1
			case .d:
				keypad[9] = 1
			case .z:
				keypad[0xA] = 1
			case .c:
				keypad[0xB] = 1
			case .NUM4:
				keypad[0xC] = 1
			case .r:
				keypad[0xD] = 1
			case .f:
				keypad[0xE] = 1
			case .v:
				keypad[0xF] = 1
			case:
				continue
			}
		case .KEYUP:
			#partial switch event.key.keysym.sym {
			case .ESCAPE:
				quit = true
			case .x:
				keypad[0] = 0
			case .NUM1:
				keypad[1] = 0
			case .NUM2:
				keypad[2] = 0
			case .NUM3:
				keypad[3] = 0
			case .q:
				keypad[4] = 0
			case .w:
				keypad[5] = 0
			case .e:
				keypad[6] = 0
			case .a:
				keypad[7] = 0
			case .s:
				keypad[8] = 0
			case .d:
				keypad[9] = 0
			case .z:
				keypad[0xA] = 0
			case .c:
				keypad[0xB] = 0
			case .NUM4:
				keypad[0xC] = 0
			case .r:
				keypad[0xD] = 0
			case .f:
				keypad[0xE] = 0
			case .v:
				keypad[0xF] = 0
			case:
				continue
			}
		case:
			continue
		}
	}
	return quit
}

get_time :: proc() -> f64 {
	counter := sdl.GetPerformanceCounter()
	frequency := sdl.GetPerformanceFrequency()
	return f64(counter) / f64(frequency)
}

delay :: proc(milliseconds: u32) {
	sdl.Delay(milliseconds)
}
