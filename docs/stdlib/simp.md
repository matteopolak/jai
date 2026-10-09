# Simp (2D renderer)

## What it is

`stdlib/Simp` is the immediate-mode 2D renderer with the public API of the official Simp module: `set_render_target`, `clear_render_target`, `immediate_*`, `set_shader_for_*`, textures, fonts, `swap_buffers`, pixel readback. A program that creates a window with `Window_Creation` and calls `set_render_target(window)` renders with no further setup; Simp creates the GL context and loads GL itself.

## How it works

- **Context creation.** The first `set_render_target(window)` runs `gl_backend_init` (`backend/gl.jai`; `prepare_window` runs it earlier when a program wants to choose the MSAA count), which makes a core 3.3 context through the `GL` module (`nsgl_create_context` on macOS, `glx_create_context` on Linux, `wgl_create_context` on Windows) and runs `gl_load`. On macOS one shared `NSOpenGLContext` is kept and `setView` re-points it at each window. Window sizes come from `get_render_dimensions` (backing pixels, so Retina is handled).
- **Backends.** `render_api` picks the implementation: `.OPENGL` (default, `backend/gl.jai`), `.SOFTWARE` (CPU rasteriser at the bottom of `immediate.jai`), `.NONE`. `module.jai` has `backend_*` dispatchers so callers never see the difference. Without a window, an OpenGL build falls back to the CPU path for off-screen textures.
- **Targets and projection.** `set_render_target` flushes, forgets the bound shader and records the coordinate system (`end_target_pass` in `module.jai`); windows are tracked in `window_infos` by `track_window`, which measures a window when first seen. `set_shader_for_*` go through `bind_builtin_shader` (`shader.jai`), which only rebinds and re-sends the projection when the program actually changes; `set_projection` reads the size of the current texture target or window. `update_window` re-measures a window and, if it is being drawn, updates the viewport and the bound shader's projection.
- **Immediate mode.** `immediate_*` appends vertices to the state in `context.simp`; `immediate_flush` draws them with the currently selected shader (`shader.jai`: color, images, text, rects, gradient; GLSL sources are in `backend/gl.jai`).
- **Coordinates.** `.RIGHT_HANDED` (y up, default) or `.LEFT_HANDED` (y down) is stored with the target. Render-to-texture flips the projection so a texture's memory is top row first in both modes.
- **Textures.** `Texture` holds its own state (`gl_handle`, `framebuffer`, CPU `Bitmap`). Loading only fills the bitmap; the GL upload happens lazily on first use, so textures can be loaded before a window exists. Images load through stb_image.
- **Fonts.** `get_font_at_size(path, name, pixel_height)` (also from memory), `create_dynamic_font`, `prepare_text`/`draw_text`/`draw_generated_quads`. Glyphs come from FreeType and are packed into RGB8 atlas pages.
- **Readback.** `pixel_read_begin/_end` (PBO plus fence on GL); save the result with `bitmap_save`. `flip=false` gives an upright image.

## How to change it

- What Simp keeps between frames (window records, the per-thread drawing state, fonts, glyphs, atlas pages and their textures, pending screenshots) comes from `SIMP_HEAP` (the default heap, `module.jai`), never the caller's `context.allocator`, which a game may point at temporary storage it resets every frame. Font procedures push it on entry; textures and bitmaps the program asks for still use the caller's allocator. `simp-software-drawing.jai` (`temporary_storage_frames`) checks cached fonts across resets.
- New backend: add a `render_api` value, a `backend/<name>.jai` loaded behind `#if render_api == ...` in `module.jai`, and implement the same `backend_*` procedures.
- New shader: add the global and `set_shader_for_*` in `shader.jai` and the GLSL in `backend/gl.jai`; `shaders_set_defaults` resets parameters.
- Gotcha: on macOS `Window_Creation.init_mac_app` references `NSApplicationMain` on purpose so AppKit is linked and loaded; do not remove it.
- Gotcha: on macOS `jaic run` moves foreign calls to the process main thread (AppKit requires it) once the program first calls an `objc_`/`sel_`/`NS`/`CGL` symbol; see [interpreter](../compiler/interpreter.md#macos-main-thread).
- Tests: `stdlib/Simp/tests/*.jai` (compile-time), `tests/stdlib/simp-compat-api.jai`, `tests/stdlib/simp-left-handed-software.jai`, and `tests/stdlib/simp-window-program.jai`, which `crates/jaic-cli/tests/native.rs` type-checks for linux, windows and macos. A real window needs a display; verify visually by reading the frame back with `pixel_read_begin(null, .RGBA8)` and `bitmap_save`.

## Configuration

`Simp(render_api := .OPENGL)`. `GL(DEFAULT_MSAA = 4)` controls multisampling. Native libraries (FreeType, stb_image) are found via `JAIC_NATIVE_LIBS` (built by `python3 tools/build_native_libs.py`).

## Dependencies

`GL`, `Window_Creation`, `Window_Type`, `Objective_C` (macOS), `X11` (Linux), `Windows`, `Math`, `Hash_Table`, `String`; FreeType and stb_image. See [ui-and-drawing](ui-and-drawing.md) and [native-bindings](native-bindings.md).

## Known gaps

Font effects are approximations of the legacy ones: `SMALLCAPS` draws the capital forms (ASCII and Latin-1) at the normal size, `LINING_FIGURES` gives every figure the widest figure's cell without kerning, and `LEFT_JUSTIFIED` starts the ink at the requested x. `Render_API.METAL` is accepted as a parameter value but there is no Metal backend in `Simp/backend` (only `gl.jai`); on Android `GL` resolves functions through EGL, but nothing creates an EGL context or surface for Simp, so neither is implemented. GetRect's default icon assets (`stdlib/GetRect/data`) are absent; the default font falls back to a system font. The GLX and WGL paths are type-checked but not exercised by tests.
