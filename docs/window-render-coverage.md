# Window/render public API coverage ledger

This is a partial implementation, not completion of the assigned reviewed inventory.
The companion [questions](specs/stdlib/window-render-questions.md) identify contract and
dependency gates. Missing exports remain missing rather than returning fabricated success.

| Module | Supported source and verification | Outstanding API or verification |
| --- | --- | --- |
| Window_Type | Reviewed native aliases/sentinels; Linux/Windows x64/arm64 checks | macOS binding lacks NSWindow; other native targets not verified |
| Window_Creation | Reviewed native Saved_Window_Info shapes, Win32 style constants and dimension/pointer overloads; Linux dimension/pointer and EWMH fullscreen request; ABI and invalid-handle checks | create_window background default unreviewed; Windows fullscreen, macOS/Android operations; real successful-window/X-server and Windows host tests |
| Input | Common nominal types, enums, globals, frame reset, resize/move views, resize append, Linux/Windows key translation, Windows gamepad callback/import declarations | Native event pumps, cursor policy, MyWindowProc, Android declarations/behavior, macOS window binding; Windows OEM keys |
| Keymap | Canonical set/map/mapping/error/callback types; pointer assignment and record defaults checked | Registration, dispatch, enable/reset/copy, parsing, persistence and builder procedures; reviewed grammar and callback precedence needed |
| Gamepad | Canonical records/global, SDL2 init/update/discovery/state/transitions/events; actual SDL virtual-device, event-disabled state and shared SDK queue tests | Physical controller and Windows/macOS native-host tests; axis/event policy review |
| Gamepad native libevdev surface | All 84 reviewed declarations, opaque types, private native enum context; Linux SDK input type aliases; every procedure signature resolved for x64/arm64 | libevdev runtime on a Linux host; fd/device/HID permission coverage |
| Gamepad/SDL_Input_Map | Entire reviewed export set including pinned replacement database, parsing, GUID formatting and deinit; interpreter/native O0/O2, regeneration idempotence | Signed/inverted axis encodings cannot be represented by reviewed fields; historical DB equality intentionally not claimed |
| Simp nominal surface | Reviewed common records/enums, OPENGL texture gl_handle and NONE empty layout, module parameters, shader/pixel-read variants; Linux/Windows checks | Confirm remaining backend variants; no macOS native window binding |
| Simp images | Format byte/block sizes, image size/stride, bitmap alloc/deinit, native file/memory decode and encode; exact CPU source interpreter/native O0/O2 and public Linux facade test | Mipmap layout/filter policy and construction; GPU texture APIs and resource identity layout |
| Simp font faces | Real FreeType library/face loading, owned copied memory, name lookup, filename cache, face/data destruction, captured allocator; host interpreter/native O0/O2 and public Linux facade | init_fonts custom atlas sizes explicitly rejected; Dynamic_Font metrics, glyph atlas, shaping/features, text preparation/quads/drawing; filename load on Windows gated by File |
| Simp GL texture source | Actual native-name 2D upload/update/delete, storage for render targets, driver format queries, compressed upload and GPU mip generation; all new public texture procedure bodies checked on Linux/Windows, headless staging/layout/visibility tests | **GPU execution unverified**; caller must retain a current GL context. Array/cube/volume/multisample shapes, supplied mip chains and compressed subimage updates explicitly unsupported |
| Simp rendering | Canonical public types; texture storage source as above | Window preparation, missing binding context constructors, swap/framebuffer targets/scissor/readback, shader-source grammar, immediate renderer and remaining backend procedures |
| Srgb (sRGB transfer functions) | Entire reviewed scalar/Vector3/Vector4 overload set, unchanged alpha, exact transfer and independent fast approximations; host interpreter/native O0/O2 and normalized sweep | No claim of reference approximation coefficients or out-of-domain clamping |
| Clipboard | Native Cocoa UTF-8 and RGB/RGBA PNG, clearing, native failures; independent decoded pixel/alpha/flip checks in interpreter/native O0/O2. Win32 native UTF-16/DIBV5 implementation and x64/arm64 checks | Windows host execution; Linux/Android/other native clipboard backends explicitly unavailable |

No GUI or physical-device coverage is inferred from type-checking, invalid-handle tests,
or the SDL native virtual controller. No generated library binary is committed. Extensions
remain unchanged. Full integrated corpus, all-code target sweeps and release verification
are coordinator work.
