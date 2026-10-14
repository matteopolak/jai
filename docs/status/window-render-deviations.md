# Window/render deviations and implementation gaps

Scope: owned public facades, private window/input/gamepad/rendering/clipboard,
tests and tools through checkpoint `9254180`, plus the current batch. This is
an incomplete implementation. Existing evidence remains in
[handoff](../window-render-handoff.md) and [questions](../specs/stdlib/window-render-questions.md).
No blanket diagnostic/check suppression or Extensions modification is intended.

| Location | Observable effect and rationale | Evidence and risk | Long-term resolution |
| --- | --- | --- | --- |
| Window_Creation | create_window absent; reviewed background default lacks value/type | Reviewed inventory references DEFAULT_WINDOW_CREATION_COLOR; callers cannot compile | Obtain reviewed contextual default and implement real native construction, never invent an overload |
| Window_Creation macOS | Real private constructor/lifecycle and public queries; public create_window still absent due missing default contract | Host interpreter native window succeeds; private constructor test is not public API completion | Reviewed default/type, public facade and full lifecycle/pump integration |
| Input | Win32 procedure/pump now source-supported; remaining-platform pumps, device-change notification, mouse motion/capture/drop paths absent | Issue #1 exhaustive decoding/native O0/O2 passes; actual Windows injection runtime not yet run | Native Windows x64/arm64 runs and remaining native event paths |
| Input horizontal wheel | Signed delta preserved with UNKNOWN key_code; no invented axis field; vertical only accumulates mouse_delta_z | Reviewed Event has no horizontal axis; consumers cannot infer axis without convention | Reviewed encoding/impulse contract and compatibility regression |
| internal/window/cocoa | Private native void setTitle bridge avoids SDK-mismatched binding return; point coordinates and async fullscreen current dimensions | Canonical AppKit classes retained; host lifecycle passes, high-DPI/multiscreen/fullscreen not runtime tested | Binding review, coordinate contract and native display-target tests |
| Keymap | Public records only; operation and file grammar coverage absent | Canonical types compile; applications still cannot dispatch/load bindings | Implement supported contracts; request reviewed grammar/precedence in questions document |
| Simp fonts/rendering | Face lifetime works; atlas, Dynamic_Font metrics/text/immediate draw/readback/context target operations absent; custom init_fonts atlas sizes assert | Actual FreeType tests cover faces only; Focus rendering blocked | Native rasterization/atlas and actual renderer, explicit ownership and layout contracts |
| Simp GL textures | Ordinary 2D storage/upload/update/delete; cube/array/volume/multisample, supplied mip chains and compressed subimage updates rejected | Signature/headless packing checks only; GPU execution unverified, possible driver errors remain | Implement reviewed shapes/mip layout and verify actual native GL context/rendering |
| tests/window-render/modules (removed) | Prior CPU component substitutes removed after AppKit repair | Actual public Simp host bitmap/font interpreter/native O0/O2 now pass; previous component evidence remains historical only | Resolved; keep production import coverage |
| target staging / tools/check_window_render.py | Reproducible NEW producer source copies plus owned overlays; no older local dependency precedence | 76 focused invocations pass; full no_dce/integrated corpus not yet established | Rebuild current tools, retry unreferenced code checks; coordinator full integration |
| Gamepad SDL2 | Polling first supported controller; process lifetime subsystem; fresh queue disables duplicate raw controller events, existing caller policy retained | Actual virtual/shared queue regressions pass; fast between-poll transitions can be lost; physical devices untested | Review selection/event policy and verify physical devices on target hosts |
| SDL_Input_Map | Independent pinned SDL2 database has 541 records; signed/inverted axis encodings explicitly rejected | Public fields lack representation; database equality not claimed | Reviewed representation/behavior clarification, update parser without invented public fields |
| internal/gamepad/linux-abi.jai | Private SDK enum values and Linux binding type aliases | 84 signatures checked; no Linux libevdev host execution | Native Linux device/runtime coverage |
| internal/window | X11 queries use process lifetime connection, async fullscreen reports current dimensions; invalid nonzero XID may trigger Xlib error handler | Only invalid-zero/query signatures verified; no X server here | Real server lifecycle/event tests and scoped native error handling |
| internal/input/windows-keys.jai | OEM punctuation maps UNKNOWN/0 | No reviewed layout translation policy; keyboard layouts incomplete | Review policy and use official native layout APIs |
| internal/rendering/loaded-fonts.jai | Windows filename load gated by inherited File Unix assertion; memory faces independent | Host FreeType lifetime/allocator tests pass; Windows filename path unverified | Integrate NEW File implementation and native Windows filename test |
| internal/rendering/image-codecs.jai | Only supported 8-bit encode layouts; other formats return false; Windows Unicode filenames unverified | Actual pinned stb native tests pass on macOS | Reviewed conversions and native Windows UTF-8 filename support/verification |
| Clipboard | Cocoa real pasteboard tested; Win32 source checked only; Linux/Android explicitly unavailable | No memory substitute; Windows owner HWND is process/UI-thread lifetime; cross-thread behavior unverified | Native Windows execution and real remaining-platform selection/clipboard backend |
| Srgb fast functions | Independent 65-sample interpolation approximation | Normalized sweep bounds <.002/.003 tested; no reference coefficient/performance identity claimed | Benchmark and refine if reviewed accuracy/performance requirements demand |
| Input.Modifier_Flags | Supported #overlay syntax implements reviewed shared packed storage | Common size/storage tests pass; syntax differs from omitted implementation spelling | Keep general language semantics and canonical layout; no module-specific compiler bypass |
| native build tool | Source-builds only macOS/Linux; Windows explicitly unsupported locally | SDK/native dependencies and GPU/Windows CI not built here | Coordinator source-built Windows native libraries and x64/arm64 runtime jobs |
| NEW POSIX dependency on macOS x64 | kinfo_proc field p_realtimer cannot resolve itimerval | Compile-only minimal reproducer recorded; macOS arm64 no_dce window check passes | Binding owner repairs general declaration availability; no local substitute |

No GPU, native Windows, successful X11-window, physical-controller or Focus
acceptance result is inferred from compilation or staged component execution.
