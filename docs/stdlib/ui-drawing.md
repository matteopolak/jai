# UI and drawing

## What it is

`Simp` provides independently authored immediate drawing, CPU bitmap rendering, native OpenGL submission, bitmap/texture helpers, and FreeType text layout. `GetRect` implements the maintained OpenJai button, slider, dropdown, theme, and frame APIs. `GetRect_LeftHanded` preserves historical UI layout contracts and implements a core subset of its widgets with downward-positive coordinates.

The maintained GetRect input has empty or fixed-answer UI bodies. This implementation supplies real state and interaction behavior; those original bodies are not copied or used as tests. Simp follows the newer Focus module API. The older GetRect font protocol is retained through explicit additional Simp overloads rather than changing the maintained `Dynamic_Font` layout.

## How it works

### Drawing and resources

Simp stores its immediate vertex buffer in `context.simp`. Shader, texture, render-target, and scissor changes flush queued triangles before changing state. Quads become two triangles; the CPU backend uses half-open edge ownership to avoid blending shared diagonals twice. CPU targets store top-first RGBA8/BGRA8 rows while draw coordinates are bottom-first. Images flip their texture V coordinate; glyph atlas coordinates already include their row orientation.

`Texture_Format` sizing supports byte formats, floating/integer formats, depth formats, and block-compressed formats. Unsupported formats and overflowing dimensions return zero sizes. Bitmap mipmaps use tightly packed levels after level zero, box averaging, and approximate gamma conversion for the sRGB flag. Actual texture upload supports a narrower set: CPU sampling uses 8-bit component formats; OpenGL upload supports R/RG/RGB/RGBA/BGRA8 and R/RG/RGBA16F/32F. A size calculation for a compressed or depth format does not imply upload or rendering support.

The software backend draws colors, sampled images, grayscale glyph coverage, rounded rectangles, and RGB/HSL gradients. Rounded-rectangle `size` is the half extent, matching the maintained calling convention. Gradient `rect` is `(x,y,width,height)`; the low nibble selects R/G/B/H/S/L, with `0x10` vertical and `0x20` horizontal one-dimensional variants.

The OpenGL backend compiles its own GLSL 330 sources, checks compilation/link status, uploads vertices through a VAO/VBO, uploads textures, and checks framebuffer completeness. The application must make a trusted native context current and pass initialized `GL.GL_Procedures` to `initialize_opengl_renderer`. Simp does not invoke the unavailable native context-creation adapters or assume shader compilation succeeded. `opengl_make_window_current` optionally switches a caller-owned context between windows.

`clear_render_target` flushes drawing and clears the selected CPU/native target, honoring the current scissor. `backend_init` selects the host-owned window target. Window presentation uses `window_present_sink(window,vsync)` and reports a missing callback or failed presentation. Asynchronous screenshot types and `pixel_read_*` procedures remain missing; they are explicit API/body gaps.

Bitmap decoding and encoding call the declared stb adapters and return the codec result. A procedure declaration does not establish that the corresponding adapter library exists. No supplied image, font, library, object, compiler, or native executable is copied into this implementation.

### Fonts

FreeType creates a memory-backed face at a requested pixel height. Simp owns a copy of the bytes for the face lifetime. Glyph lookup keys include codepoint, anti-aliasing, hinting, and fallback selection. Stable glyph pointers refer to shelf-packed RGB atlas pages; dirty pages upload before drawing. Layout decodes UTF-8, records byte positions and kerning-adjusted advances, then generates quads from the prepared glyph list.

The maintained font record fields remain unchanged. Private `Font_Record` entries hold prepared positions, source byte offsets, and source bytes. `get_cursor_pos_for_width` returns a UTF-8 byte boundary. `get_prepared_text_width` is an additional accessor for the older GetRect protocol. `Font_Effects` and the memory-only font overload are explicit legacy additions: only zero effects and `NO_KERNING` are implemented; unsupported substitutions assert instead of silently pretending to apply them.

LCD glyphs are rasterized by FreeType, but CPU and OpenGL drawing average RGB coverage into ordinary alpha. This is not the original dual-source subpixel blend. There is no shaping engine or grapheme-aware editing. `draw_code` uses character cells and tabs; full selection tab markers, exact highlight indexing through invisible glyphs, and original dithering are unfinished.

Call `deinit(bitmap)` or `deinit(texture)` to release their resource storage; free heap-created texture descriptors afterward. `deinit(font)` releases a font's face, bytes, glyphs, and prepared storage but leaves descriptor ownership to the caller. `deinit_fonts()` destroys the remaining live font descriptors and shared atlas pages. Flush pending drawing before destroying external render targets or shutting down a native context. `shutdown_opengl_renderer()` destroys shader programs and immediate buffers, so it must run while their context is current. Texture registry records and per-thread immediate state currently persist; complete application teardown is still an API gap.

### Maintained GetRect

`ui_per_frame_update` selects a window, captures input button edges, obtains pointer coordinates, and dispatches authored `Input.Event` records. Buttons capture a press and activate on release inside their rect, with Enter/Space activation for the focused button. Sliders use pointer capture, snap to their step, clamp to their range, and handle left/right arrow steps. Dropdowns preserve their open state and queue choices for `draw_popups`; popup clicks update the caller's value pointer.

Button pointer capture uses the production transition in `GetRect/interaction.jai`. It has no window, renderer, or native imports, which lets the source-only fixture exercise press, hold, inside/outside release, disabled input, and a press/release within one frame. Passing these cases verifies this transition; it does not verify full widget drawing or event integration.

The maintained theme records keep exactly their small public layouts. Additional draw/pointer callbacks and color globals provide integration without adding fields to those records. `ui_font` is supplied by the application; there is no bundled default font. Applications select a Simp render target themselves, or replace `ui_draw_procs` with a renderer that implements fill, text, and flush. `ui_set_pointer` supports event-driven pointer sources. The default Input pointer adapter assumes top-first client coordinates and converts them to bottom-first UI coordinates.

Default widget identity uses call order within the current window and ID scope. Keep call order stable or bracket dynamic regions with `ui_push_id`/`ui_pop_id`. Complete popup drawing every frame. States keep stable pointers until `ui_deinit`; a font supplied through `ui_font` remains caller-owned.

### Historical left-handed GetRect

`legacy-layouts.jai` contains public type/layout/default contracts only, normalized from the read-only supplied API. This includes the complete `Overall_Theme` fields and the theme types it references. Declaration presence is not counted as an implemented widget.

The authored behavior in `ui.jai` covers stable typed state lookup, balanced state/scissor stacks, frame/window input routing, active widgets, tooltips, theme sizing, rounded shapes, labels, buttons, checkboxes/radio buttons, sliders, dropdowns, popup ordering, and bounded UTF-8 text editing. State identity uses caller location plus an explicit identifier; state-table duplicate insertion keeps distinct widget types stable when hashes collide.

Text editing uses the public fixed-size buffer, UTF-8 byte navigation, shift selections, insertion/deletion, select-all, Enter/Escape results, and a drawn cursor. Selection rendering, pointer selection, word navigation, autocomplete, history, clipboard operations, slider text entry/spinboxes, exact cosmetic timing, subwindows, scrollable/slidable regions, number input, color pickers, text flow/display, and animation editors remain unfinished. Their theme contracts are retained where required by `Overall_Theme`; their missing bodies are not replaced by fixed results. Caller-supplied `Draw_Procs` are required for custom `Type_Indicator` renderers. Hardware cursor changes require `pointer_image_sink` or a supplied callback.

## How to change it

Keep public contracts separate from behavior. Change maintained GetRect integration in `GetRect/ui.jai` and its shared pointer transition in `GetRect/interaction.jai`; change historical left-handed behavior in `GetRect_LeftHanded/ui.jai`. Preserve legacy field/default contracts in `legacy-layouts.jai` and record any unsupported additions. Rectangle arithmetic and module entrypoints belong to the separate [math and numeric](math-numeric.md) lane.

Simp resource storage lives in `bitmap.jai` and `texture.jai`, batching/CPU rasterization in `immediate.jai`, draw state in `shader.jai`, font preparation in `font.jai`, and actual native submission in `backend/gl.jai`. Extend both the CPU and OpenGL gradient paths when introducing a mode. Add native formats only after implementing and checking their upload and sampling behavior; arithmetic sizing is a separate contract.

The source fixtures exercise actual production helpers and render/widget flows. They are not acceptance receipts until their `#assert #run` checks finish successfully. Keep the manifest `stdlib/.coverage/ui-drawing.json` current after changes; it separates public declaration coverage, nonempty authored bodies, parser checks, blocked semantic/VM checks, and native behavior.

## Configuration

Import Simp with `render_api=.SOFTWARE` for bitmap targets or `.OPENGL` for a caller-owned GL 3.3 context. `.NONE` and `.METAL` have no backend and fail explicitly if drawing is requested. `window_dimension_query`, `software_window_target`, `window_present_sink`, and `opengl_make_window_current` integrate host-owned windows. A CPU render-target texture needs RGBA8/BGRA8 for framebuffer writes. Color-index text drawing requires `set_color_map`.

`init_fonts(page_width,page_height)` defaults to 2048 by 1024; custom atlas dimensions must be 64..32767. Anti-aliasing defaults to `.lcd`, hinting to true, and selection-tab visibility to true. The selection-tab setting is retained but its full draw-code effect is unfinished. Native codec libraries use the names declared by their authored bindings; consult [codec/native bindings](codec-native-bindings.md) for availability and provenance.

Source-only validation selects the independent tree explicitly:

```sh
JAI_RS_STDLIB="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/stdlib/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
<frozen-jai-rs> check stdlib/Simp/tests/software-render-tests.jai
```

The recorded frozen snapshot is `9508def6f527169083405db10c93d9d377289fecdca749a546eb849ca39d501d`; the manifest records its binary SHA and the unchanged owned source hashes before/after checks. Its build inputs are not verified, so this receipt does not establish a current Rust build. All 16 owned source files lex; 15 parse. The remaining parse failure is the preserved legacy default arguments in procedure-typed record fields.

The actual production pointer-transition and texture-format fixtures pass `check` and their `#assert #run` cases. Texture-format source also passes `check-library`; the public named `stride` result is preserved, while explicit local row-size variables avoid dependence on implicit named-result bindings. The full software fixture stops in the native window dependency graph; the full widget fixture stops on the GL procedure-table modifier syntax. The manifest records the exact diagnostic at each check. These diagnostics precede their assertions. No full rendering/widget fixture, native window, GPU, codec, or FreeType run has passed in this lane. The maintained GetRect comparison matches all 22 lexical public contracts; Simp matches 79 of 85, with the six screenshot contracts missing. Lexical equality does not establish semantic equivalence or behavior acceptance.

## Dependencies

Authored modules: `Basic`, `Math`, `String`, `Hash_Table`, `Input`, and `Window_Type`. Native drawing uses actual `GL.GL_Procedures`; fonts use the declared system FreeType binding; codecs use the declared stb adapter libraries. Compilation still depends on the compiler's module parameters, context additions, generic records/procedures, overlays, procedure-field defaults, and compile-time VM support. No unknown compiler intrinsic is introduced.
