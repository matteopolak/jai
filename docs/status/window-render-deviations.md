# Window/render deviations and implementation gaps

Scope: owned public facades, private window/input/gamepad/rendering/clipboard,
tests and tools through checkpoint `9254180`, plus the current batch. This is
an incomplete implementation. Existing evidence remains in
[handoff](../window-render-handoff.md) and [questions](../specs/stdlib/window-render-questions.md).
No blanket diagnostic/check suppression or Extensions modification is intended.

Current font/render review supersedes the historical absent-public-font and R8
atlas rows below. Public fonts now use native FreeType metrics/coverage, retained
borrowed-memory faces and reviewed process-lifetime registries. Real GL atlas text
and PBO readback pass host interpreter/native O0/O2, alongside production public
window rendering. Reviewed release_font is intentionally non-destructive;
destroy_loaded_font frees the copied display name only. These are contract
semantics, not resource-release substitutes.

Current remaining gaps and risks:

Current lifecycle follow-up: AppKit window-close notifications now release each
window's VAO/VBO/framebuffer records and remove Window_Info/context entries. One
detached root share context is deliberately retained to preserve live public GPU
textures/programs across window close/reopen; there is no reviewed global renderer
shutdown API. This replaces retaining every closed window context. Actual native
window association uses Objective-C retained associations with a stable private
key address, not fabricated object storage. Other target cleanup is still pending.

During close/reopen testing, removing an array element before the final use of its
foreach binding produced an objc_msgSend access violation. The own compiler's
documented iteration binding aliases the array element; a minimal experiment
confirmed aliasing in interpreter/native O0. Cleanup now finishes native uses
before removing the record. This is an implementation lifetime fix, not a compiler
snapshot workaround. Earlier retained-texture readback also exposed missing native
command submission when switching contexts; make_current now flushes the previous
  context on an actual context change. Shared production contexts now use a native
  fence/server wait across switches so texture/program visibility does not depend
  on driver-specific implicit completion. The close/reopen GPU assertion remains active.

* `window-contexts.jai`, `gl-renderer.jai`: Windows/Linux window-close cleanup is
  still pending. AppKit cleanup and multiwindow close/reopen now have actual host
  regressions. One detached root share context deliberately owns the share group
  for live public GPU resources; fonts/programs/textures must outlive windows.
  Texture-associated FBOs are deleted in their creating contexts on replacement.
  GPU fences avoid CPU-wide completion waits at context switches. Future global
  renderer shutdown needs a reviewed API/lifetime contract.
* `font-features.jai`: actual SFNT GSUB single/alternate/extension substitutions
  are implemented; unsupported requested substitution kinds assert explicitly.
  No fabricated feature coverage. Add native-font cases for other reviewed effects
  when supplied assets exercise them. Native format sources are Microsoft OpenType
  GSUB and common table documentation; no Jai implementation source was used.
* `dynamic-fonts.jai`: Latin routing/offset and reversed layout fields need final
  behavioral review/tests; the overly broad always-route condition was corrected
  to restrict secondary-font selection to Latin characters. No current
  claim of all layout-field behavior. Native kerning and general ligatures are
  intentionally absent per reviewed current behavior; NO_KERNING/LEFT_JUSTIFIED
  are declared but unapplied per that same contract.
* `gl-textures.jai`, `gl-pixel-read.jai`: color 2D targets are verified; depth,
  cube/array/volume/multisample paths remain incomplete. Per-level mip and compressed
  subimage native calls are now implemented; mip readback passes all three host
  modes, compressed updates still need native compressed-format driver coverage.
  Pixel readers require their creating context for polling/consumption and retain
  the actual native fence until consumed. Native GLsync is canonical u64; native
  x64/arm64 ABI verification beyond the host remains coordinator work.
* `tests/window-render/gl-context.m`: main-thread assertion now enforces AppKit's
  real precondition. Driver tests call public init_mac_app before native fixture
  creation. Production public-window rendering also passes without that fixture.
  Interpreter lazily moves foreign calls to main thread after Objective-C symbols;
  a new original thread-local marker reproducer records the general affinity
  problem. Native C fixture uses the official GL_SILENCE_DEPRECATION opt-in only;
  its other compiler warnings are denied. No driver results are fabricated.
* Windows native renderer depends on the bindings producer's WGL context wrapper;
  Windows File remains blocked at its unconditional OS_IS_UNIX assertion. Do not
  replace canonical imports or signatures. Windows injected wheel execution,
  Linux GUI runtime and Android native app integration remain unverified.

`windows-render-events.jai` now exercises public create_window/set_render_target
before injecting vertical/horizontal wheel signed extrema, zero, positive/negative
deltas and modifiers/upper64 bits. It fails source checks on both Windows CPUs at
missing GL.wgl_create_context, preserving the full-production dependency rather
than substituting a context. The original event-only injected test continues to
source-check independently. Current full suite records 139 passes/six failures
(four File, two WGL); the newer class-specialization regression has scoped x64
source evidence, with native Windows pending. Shared Win32 class registration now
validates/reuses an existing compatible native class across module parameters;
GetClassInfoExW is a private SDK ABI declaration and error1410 is the documented
ERROR_CLASS_ALREADY_EXISTS value. AppKit retained association policy1 is verified
from the installed public objc/runtime.h SDK header.

Bitmap codec follow-up removes the earlier forced-RGBA decoding, extra save
formats and JPEG quality 90. New source-channel and save-alpha regressions enforce
the reviewed behavior; prior legacy conveniences are not compatibility evidence.

Synchronized-contract update supersedes historical unresolved-default/grammar/
shader/font/mip entries below: public native window creation and complete Keymap
operations are now implemented. General compiler reflection is fixed only in local
compiler staging using the durable producer patch; no GL-specific table patch.
Actual texture-driver interpreter/O0/O2 passes. Production integration is pending.

Current Windows Keymap dependency failure: File unconditionally asserts OS_IS_UNIX.
The original import/reset reproducer is recorded; no substitute handler type,
altered public signature or tool-only import repair was introduced.

Linux source uses actual GLX framebuffer configs/visuals and Xlib colors/events,
sharing canonical X11.x_global_display. Private CWBackPixel (1<<1), absent from
the binding inventory, is an SDK window-attribute ABI constant. Native X server
execution remains unverified; legacy XLookupString text is supported, UTF-8 input
contexts are not yet integrated. Default asynchronous Xlib error handling remains.
UI-thread/process native resource lifetimes, Windows shared-class specialization
collisions and Linux cleanup need native host regressions. The superseded copied
font backing/destruction and R8 atlas paths still need the reviewed retained-face
and RGBA alpha-atlas implementation before public font support is claimed.

IME composition is not a missing compatibility requirement: the updated Input
contract exposes committed text only. Prior IME gap entries are historical.

| Location | Observable effect and rationale | Evidence and risk | Long-term resolution |
| --- | --- | --- | --- |
| Window_Creation | create_window absent; reviewed background default lacks value/type | Reviewed inventory references DEFAULT_WINDOW_CREATION_COLOR; callers cannot compile | Obtain reviewed contextual default and implement real native construction, never invent an overload |
| Window_Creation macOS | Real private constructor/lifecycle and public queries; public create_window still absent due missing default contract | Host interpreter native window succeeds; private constructor test is not public API completion | Reviewed default/type, public facade and full lifecycle/pump integration |
| Input | Win32 procedure/pump now source-supported; remaining-platform pumps, device-change notification, mouse motion/capture/drop paths absent | Issue #1 exhaustive decoding/native O0/O2 passes; actual Windows injection runtime not yet run | Native Windows x64/arm64 runs and remaining native event paths |
| Input horizontal wheel | Signed delta preserved with UNKNOWN key_code; no invented axis field; vertical only accumulates mouse_delta_z | Reviewed Event has no horizontal axis; consumers cannot infer axis without convention | Reviewed encoding/impulse contract and compatibility regression |
| Input macOS native pump | Native queue/dispatch and window notification observer; raw NSEvent characters decoded, external events projected, fractional pointer/scroll amounts retained until integer units | Posted keys/repeat/releases, cursor rect toggles and synchronous resize/close notifications pass interpreter/O0/O2. Marked-text/IME composition, drag/drop and touch remain missing | NSTextInputClient/native composition integration, reviewed scale/axis policy, native IME and trackpad tests |
| Input macOS observer/cursor | Native NSObject observer has no custom ivars and is retained for process lifetime; cursor-disabled windows retained until reenable/close; existing windows update immediately | Public API has no teardown; future newly created windows apply cursor policy on first observed input | Integrate lifecycle initialization/teardown and immediate cursor policy during public window creation |
| internal/window/cocoa | Private native void setTitle bridge avoids SDK-mismatched binding return; point coordinates and async fullscreen current dimensions | Canonical AppKit classes retained; host lifecycle passes, high-DPI/multiscreen/fullscreen not runtime tested | Binding review, coordinate contract and native display-target tests |
| Keymap | Public records only; operation and file grammar coverage absent | Canonical types compile; applications still cannot dispatch/load bindings | Implement supported contracts; request reviewed grammar/precedence in questions document |
| Simp fonts/rendering | Face lifetime and private CPU atlas kernel work; public Dynamic_Font metrics/text/immediate draw/readback/context target operations absent; custom init_fonts atlas sizes assert | Real face/coverage/packing tests pass; production text rendering and Focus blocked | Integrate native atlas with public font/layout/renderer ownership and reviewed contracts |
| internal/rendering/glyph-atlas.jai | Real private CPU rasterization/packing kernel; page/glyph allocations belong to the current font allocator, GPU destruction is a separate caller operation | Actual FreeType byte/metric comparison, blank glyph, full page, native errors, signed pitch/mono and tracked allocation tests pass; no public Dynamic_Font integration or GPU upload yet | Integrate font-owned allocator/lifetime registry, reviewed bearing/advance units, shaping/layout and native page uploads; do not count component tests as production text rendering |
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
| Compiler procedure reflection | #type_info_procedures_are_void_pointers omits member procedure flag, so canonical GL loader cannot populate pointers | Real Apple OpenGL 4.1 context created; native symbol resolves; actual texture driver test fails in interpreter and native O0 before texture upload | Compiler owner sets general procedure-member flag when hiding procedure type; minimal original reproducer provided |
| tests/window-render/gl-context.m | Test-only actual native context constructor; production Simp window/context integration remains missing | Apple SDK creates/makes-current/releases real NSOpenGLContext, never fake GL functions; GL_SILENCE_DEPRECATION is Apple's documented opt-in for the reviewed OpenGL backend | Integrate canonical GL native context constructors; retain real driver resource regressions |

No GPU, native Windows, successful X11-window, physical-controller or Focus
acceptance result is inferred from compilation or staged component execution.
