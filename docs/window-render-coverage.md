# Window/render public API coverage ledger

This is a partial implementation, not completion of the assigned reviewed inventory.
The companion [questions](specs/stdlib/window-render-questions.md) identify contract and
dependency gates. Missing exports remain missing rather than returning fabricated success.

| Module | Supported source and verification | Outstanding API or verification |
| --- | --- | --- |
| Window_Type | Reviewed native aliases/sentinels; canonical Objective_C/AppKit NSWindow; Linux/Windows x64/arm64 checks and macOS host public imports | Other native targets not verified |
| Window_Creation | Reviewed defaults and real public native creation for macOS, Windows and Linux; Win32 shared class/title/work-area/fullscreen, GLX visual/MSAA; AppKit queries/fullscreen requests/swap; host interpreter/O0/O2 public window/render tests | Android; successful X11/Windows host execution; fullscreen/high-DPI/multiscreen verification; native context close/reuse cleanup |
| Input | Common records/state/reset; Win32 signed-wheel dispatch/pump, actual public-window injected-message tests source-check x64/arm64; real AppKit and Xlib event pumps; macOS native host interpreter/O0/O2 | Windows injection runtime, Android pump, device changes/drop/touch; horizontal wheel convention and Windows OEM keys. IME is outside the reviewed committed-text contract |
| Keymap | Complete reviewed procedure inventory, registration/press/hold dispatch, N modifier policy, enable/reset/deep copy, strict UTF-8 chord parsing, error continuation, normalized save/load persistence; host interpreter/O0/O2 | Windows canonical File dependency; exhaustive recognized-name/native application integration |
| Gamepad | Canonical records/global, SDL2 init/update/discovery/state/transitions/events; actual SDL virtual-device, event-disabled state and shared SDK queue tests | Physical controller and Windows/macOS native-host tests; axis/event policy review |
| Gamepad native libevdev surface | All 84 reviewed declarations, opaque types, private native enum context; Linux SDK input type aliases; every procedure signature resolved for x64/arm64 | libevdev runtime on a Linux host; fd/device/HID permission coverage |
| Gamepad/SDL_Input_Map | Entire reviewed export set including pinned replacement database, parsing, GUID formatting and deinit; interpreter/native O0/O2, regeneration idempotence | Signed/inverted axis encodings cannot be represented by reviewed fields; historical DB equality intentionally not claimed |
| Simp nominal surface | Reviewed common records/enums, OPENGL texture gl_handle and NONE empty layout, module parameters, shader/pixel-read variants; Linux/Windows checks and public macOS facade imports | Confirm remaining backend variants; macOS x64 POSIX dependency blocker |
| Simp images | Format sizes, bitmap alloc/deinit, native source-channel decoder, RGB/RGBA encoder/JPEG80, owned alpha-aware/sRGB mip generation; public host interpreter/O0/O2 | Native channel/codec combinations beyond current regression assets |
| Simp font faces and layout | Borrowed-memory/filename retained native faces, caches, custom atlas sizes, real Dynamic_Font metrics, UTF-8 preparation/byte offsets/quads/fallback, native GSUB single/alternate/extension effects; host interpreter/O0/O2 | Remaining layout-field semantics, other GSUB substitution kinds, supplied feature-font assets; Windows filename load gated by File |
| Simp font atlas/text | Actual FreeType RGBA alpha atlas, reviewed row packing, native dirty-page GPU uploads and public draw_text; real framebuffer ink tests interpreter/O0/O2 | Large/multifont/effect application coverage; retained pools are reviewed lifetime behavior |
| Simp GL textures | Real 2D native storage/reallocation/deletion, supplied mip chains and per-level updates, preserved unpack state, FBO release on replacement; actual Apple GL readback interpreter/O0/O2 | Shapes/multisample, compressed-update driver coverage and depth targets; general reflection patch still staged pending compiler integration |
| Simp rendering | Public native window/context targets and swaps, shared programs, per-context VAO/VBOs, immediate geometry, shader-stage macros, scissor, fenced PBO readback/flip/resize, actual production window and texture framebuffer tests | Lifecycle cleanup/handle reuse, broader scissor/coordinates, Windows WGL dependency, Linux native GUI runtime; full application integration |
| Srgb (sRGB transfer functions) | Entire reviewed scalar/Vector3/Vector4 overload set, unchanged alpha, exact transfer and independent fast approximations; host interpreter/native O0/O2 and normalized sweep | No claim of reference approximation coefficients or out-of-domain clamping |
| Clipboard | Native Cocoa UTF-8 and RGB/RGBA PNG, clearing, native failures; independent decoded pixel/alpha/flip checks in interpreter/native O0/O2. Win32 native UTF-16/DIBV5 implementation and x64/arm64 checks | Windows host execution; Linux/Android/other native clipboard backends explicitly unavailable |

No GUI or physical-device coverage is inferred from type-checking, invalid-handle tests,
or the SDL native virtual controller. No generated library binary is committed. Extensions
remain unchanged. Full integrated corpus, all-code target sweeps and release verification
are coordinator work.
