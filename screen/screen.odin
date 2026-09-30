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
	sdl.DestroyWindow(screen.window)
	sdl.DestroyRenderer(screen.renderer)
	sdl.DestroyTexture(screen.texture)
	sdl.Quit()
	free(screen)
}

update :: proc(screen: ^SCREEN, buffer: []u32, pitch: i32) {
	sdl.UpdateTexture(screen.texture, nil, raw_data(buffer), pitch)
	sdl.RenderClear(screen.renderer)
	sdl.RenderCopy(screen.renderer, screen.texture, nil, nil)
	sdl.RenderPresent(screen.renderer)
}

process_input :: proc(screen: ^SCREEN) -> bool {
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
			case:
				continue
			}
		case:
			continue
		}
	}
	return quit
}
