# Drawing, windows and audio

## What it is

`Simp` is the immediate-mode 2D renderer: queued triangles and quads, shaders, textures, bitmaps, fonts and a CPU backend. `Window_Creation` and `Window_Type` create and identify native windows. `Sound_Player` plays audio; the `SDL` and `GL` bindings sit beside them. The widget library on top is [getrect](getrect.md). Simp is documented in detail in [simp](simp.md).

## How it works

`Simp` takes a module parameter `render_api` (`NONE`, `SOFTWARE`, `OPENGL` (default) or `METAL`). Files: `immediate.jai` (vertex queue: `immediate_begin`, `immediate_vertex`, `immediate_quad`, `immediate_triangle`, `immediate_rounded_rect`, `immediate_flush`), `shader.jai` (`set_shader_for_color/images/text/rects/gradient`), `texture.jai` and `texture_format.jai` (`texture_load_from_file/memory/bitmap`, `get_image_size`), `bitmap.jai`, `font.jai` (`get_font_at_size`, `prepare_text`, `draw_text`, FreeType glyph atlases), `readback.jai` (pixel reads and screenshots), and `backend/gl.jai`, which is loaded only when `render_api == .OPENGL`. With `.SOFTWARE`, `software_submit` rasterizes into a CPU render target (colors, sampled images, glyph coverage, rounded rectangles, gradients).

Changing the shader, texture, render target or scissor flushes queued vertices first. CPU render targets store top-first rows while draw coordinates are bottom-first. The OpenGL backend compiles its own GLSL 330 programs and expects the application to make a GL context current and to pass loaded `GL` procedures; window creation and presentation are the caller's job (`Window_Creation.create_window`, `update_window_events`, `swap_buffers`).

`Window_Creation` has one file per OS (`linux.jai`, `osx.jai`, `windows.jai`, `android.jai`) behind `module.jai`, with `DEFAULT_MSAA` as a module parameter. `Window_Type` is the native handle type. `Sound_Player` mixes WAV, IMA ADPCM and Ogg Vorbis sounds into the default output device (ALSA, Core Audio, DirectSound, AAudio); see [sound-player](sound-player.md).

```jai
#import "Basic";
S :: #import "Simp"(render_api=.SOFTWARE);

main :: () {
    size, stride := S.get_image_size(.BC1, 5, 7);
    print("% %\n", size, stride);
}
```

## How to change it

- A new Simp backend means a `render_api` enum value, a `backend/<name>.jai` loaded behind `#if render_api == ...` in `module.jai`, and the matching `#if` calls in `immediate.jai`.
- Tests: `stdlib/Simp/tests/{software-render,texture-format,readback}-tests.jai` (compile-time checks; run with `jaic run`) and `tests/stdlib/simp-compat-api.jai`. GL and window paths need a display and are not covered.
- Fonts: glyph lookup keys include codepoint, anti-aliasing and hinting; `deinit(font)` releases the face and glyphs but leaves the descriptor to the caller, and `deinit_fonts()` frees the remaining ones. There is no text shaping and no grapheme-aware editing.
- LCD glyph rendering averages the subpixel coverage into normal alpha.

## Configuration

`Simp(render_api := .OPENGL)`, `Window_Creation(DEFAULT_MSAA = 4)`, `Sound_Player(MAX_SOUND_CATEGORIES = 64, VERBOSE = false, OFFLINE = false, OFFLINE_CHANNELS = 2)`.

## Dependencies

`Math`, `Hash_Table`, `String`, `Window_Type`; FreeType (`freetype-2.12.1`) and stb libraries (`stb_image`, `stb_image_write`) for fonts and images, built with `tools/build_native_libs.py` (see [native-bindings](native-bindings.md)); `GL` for the OpenGL backend.
