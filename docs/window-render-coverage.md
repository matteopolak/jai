# Window/render public API coverage ledger

This is a partial implementation, not completion of the assigned reviewed inventory.
The companion [questions](specs/stdlib/window-render-questions.md) identify contract and
dependency gates. Missing exports remain missing rather than returning fabricated success.

| Module | Supported source and verification | Outstanding API or verification |
| --- | --- | --- |
| Window_Type | Reviewed native aliases/sentinels; canonical Objective_C/AppKit NSWindow; Linux/Windows x64/arm64 checks and macOS host public imports | Other native targets not verified |
| Window_Creation | Native Saved_Window_Info shapes, Win32 style/query source, Linux queries/EWMH fullscreen; canonical AppKit initialization/queries/fullscreen request and real private native lifecycle tested interpreter/O0/O2 | Public create_window default/type unreviewed; Windows fullscreen, Android; successful X11/Windows host tests; fullscreen/high-DPI/multiscreen verification |
| Input | Common records/state/reset; Win32 signed-wheel dispatch source; actual AppKit pump/notifications, keys/repeats/releases/raw text, buttons, motion/scroll and external-event projection; host interpreter/O0/O2 | Windows injection runtime, Linux/Android pumps, device changes/drop/touch; macOS IME composition; horizontal wheel convention and Windows OEM keys |
| Keymap | Canonical set/map/mapping/error/callback types; pointer assignment and record defaults checked | Registration, dispatch, enable/reset/copy, parsing, persistence and builder procedures; reviewed grammar and callback precedence needed |
| Gamepad | Canonical records/global, SDL2 init/update/discovery/state/transitions/events; actual SDL virtual-device, event-disabled state and shared SDK queue tests | Physical controller and Windows/macOS native-host tests; axis/event policy review |
| Gamepad native libevdev surface | All 84 reviewed declarations, opaque types, private native enum context; Linux SDK input type aliases; every procedure signature resolved for x64/arm64 | libevdev runtime on a Linux host; fd/device/HID permission coverage |
| Gamepad/SDL_Input_Map | Entire reviewed export set including pinned replacement database, parsing, GUID formatting and deinit; interpreter/native O0/O2, regeneration idempotence | Signed/inverted axis encodings cannot be represented by reviewed fields; historical DB equality intentionally not claimed |
| Simp nominal surface | Reviewed common records/enums, OPENGL texture gl_handle and NONE empty layout, module parameters, shader/pixel-read variants; Linux/Windows checks and public macOS facade imports | Confirm remaining backend variants; macOS x64 POSIX dependency blocker |
| Simp images | Format sizes, bitmap alloc/deinit and native codecs; production public Simp host interpreter/native O0/O2 | Mipmap layout/filter policy and construction |
| Simp font faces | Real FreeType library/face loading, owned copied memory, name lookup, filename cache, face/data destruction, captured allocator; host interpreter/native O0/O2 and public Linux facade | init_fonts custom atlas sizes explicitly rejected; Dynamic_Font metrics, glyph atlas, shaping/features, text preparation/quads/drawing; filename load on Windows gated by File |
| Simp private CPU atlas kernel | Real FreeType coverage/metrics, canonical Font_Page/Font_Line/Glyph_Data; padded shelves, grayscale/mono expansion, signed pitch, page-full/native errors and tracked cleanup; interpreter/O0/O2 with caller font | Private kernel/component evidence only; Dynamic_Font integration, GPU page upload, shaping/text/quads/draw remain incomplete |
| Simp GL texture source | Native 2D resource source, signatures, headless packing/privacy; actual Apple OpenGL context fixture and driver regression | **Driver test fails before upload: compiler procedure-reflection flag missing.** Shapes/mip-chain/compressed subimage updates remain unsupported; no GPU success claimed |
| Simp rendering | Canonical public types; texture storage source as above | Window preparation, missing binding context constructors, swap/framebuffer targets/scissor/readback, shader-source grammar, immediate renderer and remaining backend procedures |
| Srgb (sRGB transfer functions) | Entire reviewed scalar/Vector3/Vector4 overload set, unchanged alpha, exact transfer and independent fast approximations; host interpreter/native O0/O2 and normalized sweep | No claim of reference approximation coefficients or out-of-domain clamping |
| Clipboard | Native Cocoa UTF-8 and RGB/RGBA PNG, clearing, native failures; independent decoded pixel/alpha/flip checks in interpreter/native O0/O2. Win32 native UTF-16/DIBV5 implementation and x64/arm64 checks | Windows host execution; Linux/Android/other native clipboard backends explicitly unavailable |

No GUI or physical-device coverage is inferred from type-checking, invalid-handle tests,
or the SDL native virtual controller. No generated library binary is committed. Extensions
remain unchanged. Full integrated corpus, all-code target sweeps and release verification
are coordinator work.
