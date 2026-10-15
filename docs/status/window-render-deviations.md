# Window/render deviations and implementation gaps

Resolved cache-preflight overconstraint: a6371ec's optional missing VS2026 INCLUDE
entry is now recorded as missing, distinct from selected mandatory SDK/tool input.
Real search directories retain full content fingerprints and order; later creation
changes the key. Native-root authority now includes explicit VSINSTALLDIR/
VCINSTALLDIR/UniversalCRTSdkDir metadata for genuine auxiliary/UCRT inputs, without
guessing SDK paths. Required ARM64 headers, static CRT/platform library sets and
tools must exist and be reachable without shadowing. The minimum-file check uses
documented Microsoft names/layouts; it does not claim complete ABI/build success.
Native compiler, linked output/PE, dependency and GL execution gates remain required.

Cache configuration schema2 adds required-file and absent-search-entry identities;
old receipt keys are not automatically migrated. This can require a cold LLVM
build when only an older policy key exists, but avoids accepting inputs the old
policy never represented. a6371ec failed before producing a key/build. Subsequent
schema2 hits keep full installed-file integrity verification. No optional entry is
blanket ignored or substituted with a hardcoded SDK. Metadata-layout tests are not
native SDK execution; all native Windows evidence for this change is pending.
Rechecking inputs before sealing a new LLVM receipt adds SDK/tool hashing I/O,
but rejects mid-build input changes instead of mislabelling cached artifacts.

Resolved helper defect: -Dplatforms=[] in window_render_mesa_windows.py disabled
the real Windows WGL targets despite an OpenGL-enabled build. Candidatee223538
compiled/installed other Mesa output, then correctly failed the required pair
assertion. Pinned native source validates that expectation; the fix enables
platforms=windows and the canonical ICD output option rather than weakening
discovery. Historical optional-platform descriptions below must not be read as
successful WGL coverage. Original failed evidence is retained in this handoff.

New native validation dependency: official MSVC dumpbin metadata is parsed using
its dependency/export columns for the pinned native DLLs. Unexpected/missing
metadata/required exports fails explicitly; native SDK execution is still pending.
Installed driver images require ARM64, while system ABI compatibility/API-set
resolution is delegated to the actual Windows loader. Only actual mapped,
hash-matching WGL targets and reachable dependencies can be deployed; metadata
fixtures count solely as infrastructure tests. New source/SDK introspection,
dependency and loaded-file checks do not replace fresh native GL draw/readback.
No native renderer success, legacy test expectation restoration, peer change,
GL override, renamed substitute DLL or LLVM cache weakening is claimed.

Verified build-cache tradeoff (`tools/window_render_mesa_windows.py`): persistent
installed LLVM reuse hashes selected public native SDK headers/libs, toolchain
binaries and every installed LLVM file. This adds disk I/O but avoids repeating
the lengthy compiler build after later Mesa setup failures. Cache identity and
relocation checks run on native Windows; local integrity fixtures do not count as
native LLVM/driver success. Only completed receipts from this helper are reusable;
old completion counts cannot establish artifact/config integrity. Drivers always
come from fresh Mesa build/install/output directories. Corrupt entries fail instead
of falling back silently. Abandoned writer locks require coordinator cleanup after
confirming the writer stopped; no unsafe automatic lock theft is implemented.
SDK fingerprinting requires the actual native vcvars-selected public SDK roots;
arbitrary extra include/lib directories and external CMake toolchain overrides are
outside this explicit configuration. Hash manifests provide integrity, not an
authenticated provenance service. Native CI must verify the new route and all
existing real graphics gates; none is weakened or skipped by caching.

CIa78721d establishes ARM64 LLVM source-build completion, followed by infrastructure
failure when Mesa's child Python discovery selected unprepared global python3.EXE.
`tools/window_render_mesa_windows.py` now binds Python/python3 using Meson's native
machine configuration, requires the prepared venv, isolates child imports and pins
the additional Mesa-required PyYAML6.0.3. A real Meson control/positive regression
verifies interpreter and dependency identity; no global installation, source patch,
PATH-only workaround or driver success is claimed. Native rerun remains required.

Latest WGL lifetime correction supersedes the historical unbound-root description
below. `internal/rendering/window-contexts.jai` now allocates one actual native
hidden STATIC window/common DC per context, copying the visible surface's exact
pixel format. Official Mesa25.2.5 releases visible drawables in a WM_DESTROY hook
before our callback; selecting them there is unsafe. Cleanup uses the retirement
DC and destroys non-root context/DC/window resources. One root context plus its
native surface/DC remains process-lived to preserve public texture/PBO resources
across close-all/reopen. Observable cost: an extra real native window/DC per live
renderer, plus one process-lived owner. This is a deliberate lifetime design, not
simulated windows or a tool-only replacement. Possible performance/resource risk:
many contexts increase native handle use. A reviewed offscreen pbuffer design may
reduce window overhead, but must preserve driver/profile/pixel-format support and
all live-resource assertions. No pbuffer fallback is silently claimed. Cross-thread
context destruction and foreign HWND lifecycle notification remain unsupported
integration gaps. New native Windows validation remains pending.

`tools/window_render_mesa_windows.py` pins upstream Mesa25.2.5, LLVM20.1.8 and
WinFlexBison2.5.25 sources and build-tool versions; source hashes, commands and
native DLL architecture are checked. Native Windows ARM64 execution is required.
Only plan/source-integrity tests run here; no driver build or GPU test is fabricated.
LLVM build time/memory and CI desktop/session availability remain platform risks.
Optional non-WGL native library features are excluded from this driver build;
required production OpenGL drawing/readback/lifecycle tests are retained, and no
upstream Mesa CTS pass is claimed. Proper completion requires native build and
actual llvmpipe runtime evidence with source-build.json plus filtered CI summary.

Run38662728329 gives a real Windows strict-lint failure but no diagnostic rule or
location. Native-host strict lint passes; it does not substitute for Windows lint.
The CI helper now exports diagnostic headers/locations only, without source bodies
or raw logs. No lint rule suppression/exclusion or invented fix is counted.
Bindings-owner private-DC failure cleanup remains requested in the WGL handoff.

Fresh linter evidence: the all-local-path host command initially failed with a cursor remove-in-for finding and incomplete roots (wrong platform, intentional negative programs, and local inherited dependency precedence). Those failures are not claimed as successful body lint. Proper lint of byte-identical integrated production roots removes dependency precedence/private-import problems; eight facade roots, private context/lifecycle modules and native macOS event test pass warnings-denied lint without incomplete diagnostics. All54 owned staged Jai files match originals. Windows native strict lint is mandatory in window_render_wgl_ci.py; cross-platform/negative-program semantic lint is not silently counted as native-host completion. No suppressions, rule/config changes or import patches are used. Cursor retirement was refactored into search then mutation outside traversal; original ordering still removes the registry entry before native release, with a real close-while-disabled test.

Current WGL release blocker supersedes earlier source-only Windows context evidence: filtered candidate0100a1f WindowsCI links graphics but creation fails in interpreter/O0/O2 on both CPUs; signed-wheel issue#1 actually passes both. Source review of NEW bindings found no proved root cause. System GL capability is an unverified hypothesis until actual driver identity/stage/error is returned. Production diagnostics cannot recover the original native error after binding cleanup, so label post_cleanup_error and request owner-side immediate capture. Target PFD descriptors are logged only when native DescribePixelFormat succeeds. A successful constructor now checks prior context/DC restoration. No requested-version/profile downgrade or fabricated driver capability.

Real-driver CI configuration: new scoped tool optionally deploys caller-provided source-built Mesa DLLs under target only, validates native PE architecture and records SHA256 identities, selects llvmpipe and requires reported llvmpipe plus actual context/render/readback success. Driver source build/installation and native runtime are not executed on this macOS host. No opaque driver download, registry/system replacement, GL version override or coverage reduction. The tool creates a filtered SDK summary for coordinator feedback; this worker does not read remote raw logs. Native ARM64 Mesa/LLVM/CRT compatibility remains unverified. See native/window-render-wgl-investigation.md for owner request, exact test/deployment commands and official SDK sources.

Win32 pointer implementation now replaces the always-zero motion gap: one record per actual HWND tracks native signed client coordinates; first motion after a native move/focus loss establishes a baseline, subsequent motion accumulates wide deltas. State is removed at WM_NCDESTROY. Native wParam modifier/button bits now drive mouse button events as well as wheel/motion state, with native GetKeyState still supplying Alt/Meta. Mouse capture/drag outside the client and native Windows execution remain gaps; no raw-input precision/acceleration identity is claimed. The new genuine public-window PostMessageW regression is source-only here.

Test construction correction: windows-events/windows-render-events previously shifted signed32 encoded words inside a cast, producing sign-extended upper32 bits for negative deltas. Lower native16-bit delta decoding was correct, but intended unrelated upper packet bits were overwritten. Typed u64 locals now precede shifts, and exact upper-bit assertions plus exhaustive portable signed32 construction prevent recurrence. Original packed-narrow-shift-negative.jai reproduces the prior exact-packet assertion failure and is retained failure evidence, not passing functionality. No compiler arithmetic/check policy was weakened.

Additional retained failure evidence: migrating macos-events to public creation initially caused177 passes/three failures because its posting helper still used the separately loaded private Cocoa application global (null). This test setup defect is corrected by querying native NSApplication.sharedApplication; interpreter/O0/O2 then pass, and the full runner is180/zero. All original assertions and unexpected-event diagnostics remain. The earlier intermittent text109 observation is still unexplained, not declared repaired.

Broader all-code dependency failure: -check -no_dce -os windows -cpu arm64 on windows-render-events and the minimal original repro unicode-no-dce.jai fails in NEW internal/unicode/module.jai at utf8_inital_byte_mask: expected [6]u8, found s64. Ordinary focused imports/checks and180-run suite pass. This is outside owned source; no peer modification, tool-only import rewrite or compiler symbol special case is applied. Foundation/compiler owners must review the typed array declaration/general semantics and then rerun all-code checks.

Windows notifications: canonical HID and XBOX_GUID classes now have real RegisterDeviceNotificationW/UnregisterDeviceNotification lifetime and public callback dispatch. is_xbox currently follows the registered class; whether XInput-associated HID paths also require true is a new precise contract question34. No path/vendor heuristic was invented. Decoder trusts Win32 advertised readable payload size, checks bounded UTF-16 termination before callbacks and borrows the path only synchronously. Pure interpreter parser evidence is component coverage, not native Windows execution; actual SendMessageW and physical hotplug remain pending. Native registration rollback failures/unregistration errors assert rather than disappear.

Native test failure retained: first expanded notification run yielded179 passes/one macOS-events interpreter failure at the expected-A text assertion. Added diagnostics reproduced a target-window text value109 (m), count0, on diagnostic run11; no raw external logs were read. Immediate isolated rerun and later30 diagnostic interpreter runs passed. The cause is not established, so this is not declared fixed or suppressed. The test now uses public init_mac_app/create_window and retains every assertion plus detailed unexpected-frame diagnostics. Desktop interference/native queue state and the known interpreter native-thread-affinity defect need further native diagnosis if it recurs; no retry-to-success was added to the runner.

Texture color-space correction: prior upload/reallocation retained an old sRGB flag when the next bitmap was linear; same-size updates could leave incompatible native storage unchanged. The original real GL test failed on the public flag assertion before the fix. Bitmap state now determines sRGB for upload/reallocation; a same-size color-space change selects actual glTexImage2D storage reallocation while keeping the texture name. File/memory loaders no longer mutate flags before attempting upload. Driver format, flags and unchanged raw pixels pass interpreter/native O0/O2 for both transition directions. No fallback or fabricated resource was introduced.

Current font-effects correction: old narrow cast operands truncated GSUB high bytes (feature tags appeared as109/112), preventing smallcaps/lining lookup discovery. Typed u16/u32 operands before shifts fix real native table decoding with checked arithmetic retained. Mandatory original font tests failed before the fix and now pass native FreeType and GL effect paths. No guessed metrics or fixture substitutes are used. Single/alternate/extension lookups remain supported; general contextual/multiple/ligature shaping remains an explicit diagnostic, consistent with the reviewed unshaped text path. Native lookup flags affect other sequence inputs, so they do not filter the current glyph here; the briefly authored uncommitted GDEF-filter extension was removed, with a real flagged-font regression retained. The fonts are independently authored binary assets with deterministic source generators, not copied font/reference assets. Native format source: https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2 .

The coordinator/user cleared the metadata-only incident and authorized resumption.
No forbidden implementation body was exposed or incorporated; no quarantine or
reimplementation is required. Exact scope and reviewed disposition remain in the
[incident report](window-render-cleanroom-incident-2026-10-14.md). Newer native
Windows evidence must still come from actual runs, not the older aggregate results.

Resumed verification supersedes the historical File/WGL/metadata patch blockers:
155 focused invocations now pass with zero failures. Staging copies only the NEW
platform-io File/Process facades, their assigned internals and encoding helpers,
preserving other producers' foundations/numerics/bindings. Filename font loading
now uses canonical File on Windows as well as Unix. Fresh own compiler sources
already preserve erased-procedure metadata; no compiler patch is applied in the
current build. Historical failures and patch evidence remain below/in docs/native.
The subsequent Windows lifecycle batch expands the runner to159 passing invocations
with zero failures. These include x64/arm64 source checks, not native Windows runs.

Windows WM_DESTROY lifecycle is now implemented for windows using Input.MyWindowProc.
It retires per-window GL objects, deletes non-root HGLRCs and releases common GetDC
results; CS_OWNDC/CS_CLASSDC resources remain OS-owned. One unbound root HGLRC is
retained for native share-group lifetime, without retaining an invalid closed-window
DC as a usable surface. Pending reader FBOs are deleted and their fields zeroed at
close; shared PBO/fence resources can later be consumed in a newly opened window.
No fake surface or window is introduced. Foreign HWNDs that do not use the input
procedure need separate native destruction notification/subclass integration;
cross-thread rendering/destruction and varying MSAA pixel-format sharing remain
native-host verification gaps. Native WGL swap uses the canonical loader's sentinel
filter instead of the former unchecked raw wglGetProcAddress cast. When swap-control
is unavailable, buffer swapping still occurs with the platform's existing interval;
no vsync-control success is claimed for that unavailable capability.

Window retirement now uses glFinish before native context/resource teardown, on
macOS and Windows, to complete pending writes/readbacks before restoring another
context. This deliberately blocks the CPU on close, rather than on normal context
switches (which retain GPU fences). It may delay closing a window with a long GPU
queue; a future deferred-retirement fence queue could reduce that latency while
preserving shared-resource and readback lifetime. Native sources for DC/context
ownership and the private DWORD GetClassLongW query are the official Microsoft
ReleaseDC, wglDeleteContext and GetClassLongW winuser/wingdi documentation. No class
pointer is truncated; only GCL_STYLE's32-bit flag value is queried. Native Windows
runtime remains pending; actual macOS close/reopen passes in all three host modes.

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

`internal/input/windows-keys.jai` now privately declares MapVirtualKeyW and
VkKeyScanW from official winuser.h docs, since the canonical binding inventory
lacks them. OEM/keypad printable ASCII normalization follows the current native
layout; unsupported virtual keys return UNKNOWN. Non-ASCII native character values
cannot safely occupy the compact canonical special-key ranges, so they remain
TEXT_INPUT only, consistently with existing desktop keyboard projections. No
Unicode-key completion claim. get_vk returns the native key byte, with shift state
remaining outside that API's scalar result. `windows-layout-keys.jai` verifies the
real event/state path against the current native layout and handles unmapped keys
explicitly; x64/arm64 source checks pass, native runtime remains unverified.
Native sources: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapvirtualkeyw
and https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-vkkeyscanw.
Native keyboard layout behavior/ABI on Windows hosts is the remaining risk; no
alternate Jai implementation, keyboard-layout replacement or fake key backend is
used. Binding ownership can absorb these two private SDK declarations later.

Keymap programmatic Meta-modified bindings dispatch correctly, but the reviewed
file grammar has no Meta prefix. Persistence now asserts explicitly for such a
mapping instead of silently dropping the modifier. This is a deliberate supported-
domain restriction pending reviewed serialization policy (question32), with risk
that callers expecting arbitrary modifier persistence cannot save those bindings.
Literal #/newline command escaping is also unspecified; no invented escape syntax
is claimed. The proper fix needs the reviewed grammar, not a new convenience export.

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
* `gl-textures.jai`, `gl-pixel-read.jai`: color and depth/stencil 2D targets are verified;
  cube/array/volume/multisample paths remain incomplete. Per-level mip and compressed
  subimage native calls are now implemented; mip readback passes all three host
  modes; actual BC4 compressed upload/update byte readback now passes all three
  modes as well. Other compressed formats still need their native driver cases.
  Pixel readers can be polled/consumed in their creating context or a registered
  context in the same native share group, retaining real buffer/fence resources
  across AppKit window close. Context-local reader FBOs are deleted in their owner
  context; closed-window readers transfer ownership to the detached share root.
  The earlier creating-context assertion is preserved as regression evidence in
  progress notes. Native GLsync is canonical u64; native
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

Native depth/stencil coverage now includes D16, D24S8, D32F and D32FS8, actual clear
values, resizing blits and packed PBO reads on Apple GL in all three execution
modes. Depth blits require identical source/destination storage formats, matching
the native GL rule; no fabricated cross-format conversion. Text baseline conversion
and both scissor coordinate systems have real framebuffer comparisons. Latest full
suite:147 passes/six canonical Windows dependency failures. The newer canonical
AppKit setTitle wrapper handles native void correctly, so the private title ABI
bridge is superseded; its unspecified id return remains unused.

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
