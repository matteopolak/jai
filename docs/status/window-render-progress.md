# Window/render progress

Texture color-space batch after9b5877d: public bitmap upload, storage reallocation and same-size update now copy incoming IS_SRGB in both directions while preserving unrelated texture flags. Same-size color-space changes reallocate actual GL storage and preserve the native name. Removed redundant public file/memory-loader flag mutation. New real-driver regression failed before the fix and now checks all three paths, public flags, GL internal format and unchanged raw pixels. Full runner:174 invocations passed, zero failed. Owned formatter check/warnings-denied lint pass; public window/render/color-space macOS x64 source checks also pass. Native Windows runtime remains pending.

Font-effects batch: corrected GSUB big-endian16/32-bit decoding by widening byte operands before shifts. Original native fonts now require real smallcaps/lining-figure discovery, ordered single/alternate/extension substitution, coverage1/2, native advance metrics and all four effect combinations. Real GL atlas text yields distinct nonzero framebuffer ink for those effects. A second original GDEF/flagged font checks that lookup flags do not suppress the current single glyph; an uncommitted sequence-filter experiment was removed after checking official native documentation. Source-built formatter check and warnings-denied lint pass across all owned Jai files. Full expanded runner:169 focused invocations passed, zero failed, including interpreter/native O0/O2 public text rendering. Original asset regeneration and Python compilation pass. Native Windows execution remains pending.

Windows teardown batch after `dfeeb20`: WM_DESTROY now notifies renderer lifecycle
owners. Window VAO/VBO/FBO records and Window_Info/context entries are retired;
non-root WGL contexts are deleted, common DCs are released, and native class/private
DCs stay OS-owned. One unbound native share-owner HGLRC retains live public GPU
resources across closing all windows and reopening. Pending readback FBOs are
released in their owner context; buffers/fences survive in the native share group.
Real-window close/reopen/texture/readback/swap assertions source-check x64/arm64.
Native Windows execution remains pending. WGL swap now uses canonical GL.gl_load
procedure resolution, avoiding direct calls to WGL non-null failure sentinels.

Expanded runner: **159 invocations passed, zero failed**, including the added
Windows lifecycle and filename-font checks; host interpreter/native O0/O2 all pass.
The later swap-loader change also source-checks both Windows CPUs. Mac teardown
now drains queued GPU work before context retirement; normal context switches
still use server-side fences. The general interpreter native-thread-affinity
reproducer still fails on fresh compiler sources, independently of passing public
AppKit initialization/driver paths. Its original failure remains documented.

Resumed dependency/OEM verification: **155 focused invocations passed, zero failed**
with the fresh source-built compiler and NEW bindings/platform-io File/Process.
Host cases pass interpreter/native O0/O2, including public native windows, text,
textures, depth/stencil, readback, Keymap and signed decoding. Windows renderer,
Keymap and OEM/keypad x64/arm64 checks now pass; native Windows execution remains
pending. The macOS x64 POSIX reproducer and Windows filename-font source check also
pass separately. Owned formatting/check, warnings-denied lint and both native
declaration generators pass. The integrated compiler's original general reflection
fix passes its reproducer; the historical patch is no longer applied by tooling.

Next batch in progress: Windows renderer WM_DESTROY lifecycle cleanup and actual
GPU resource/readback lifetime across closing all windows and reopening. Its new
native regression is source-checkable here; no native Windows pass is claimed.

**RESUMED — reviewed 2026-10-14:** coordinator/user cleared the metadata-only
incident as authorized sanitized integration feedback; no quarantine/reimplementation
is required. Pending OEM/keypad translation resumes alongside NEW WGL/File/Process
dependencies. Native Windows runtime for newer work remains pending.

Historical stop: a provenance read of the NEW
platform-io producer's AGENTS.md unexpectedly exposed an appended paragraph of
coordinator CI metadata. No feedback document/logs/history/transcripts/reference
implementation was opened, and no such result is used as this worker's evidence.
Implementation stopped immediately; see the
[exact incident scope](window-render-cleanroom-incident-2026-10-14.md).
Last durable implementation checkpoint: `b005a2d`; the later OEM keyboard batch
remains durable and uncommitted. The last full own run was147 passes/six dependency
failures. No implementation/test work continued between recognition and clearance.

Windows keyboard follow-up after `b005a2d`: OEM punctuation and keypad character
keys now use actual current-layout MapVirtualKeyW translation; get_vk uses the
bare virtual-key byte from VkKeyScanW. New real-window press/release/state tests
source-check on Windows x64/arm64; runtime needs Windows hosts. No keyboard layout
is activated or user preference changed. The canonical compact key enum reserves
non-ASCII values for special/gamepad keys, so native non-ASCII characters remain
committed text rather than fabricated keyboard codes. This matches the existing
ASCII key projection on the other desktop backends. Official Win32 SDK docs supply
only native ABI/translation semantics; no Jai implementation source was consulted.

After `31ded39`, depth/stencil textures use proper native framebuffer attachments,
read/draw buffer selection, depth/stencil blit masks and nearest depth filtering.
Actual D16/D24S8/D32F/D32FS8 clear/resize/packed readback passes interpreter/O0/O2.
Text coordinate parity and left/right scissor assertions pass on the real driver.
Pending PBO reads now survive their creating AppKit window closing: per-context
FBOs are released and shared buffer/fence resources remain consumable in the live
share group. The original strict-context failure was reproduced before this fix.

Latest full runner: **147 passes, six visible dependency failures** (four canonical
Windows File assertions, two missing canonical WGL constructors). All host cases
pass interpreter/native O0/O2. Full owned jaifmt --check and jailint -D warnings
pass. Canonical AppKit setTitle now replaces the superseded private title bridge.
BC4 compressed upload/update byte readback passes all three host modes. The extra
negative test verifies an explicit diagnostic for programmatic Meta persistence,
whose spelling is absent from the reviewed grammar; it is not claimed as completed
Meta serialization support.

Follow-up after `b9e7115`: public AppKit swap_view_buffers selects a real associated
context. Native close notifications remove Window_Info/context and per-window GPU
records; a detached root share context preserves live GPU resources across close/
reopen. Multiwindow switching and retained-texture close/reopen pass interpreter/
native O0/O2. Shared-context GPU fences now order commands across switches.
Keymap has new real save/load, duplicate/N-policy/UTF-8/error-continuation coverage.
Shader tests now check actual compile/link failures return0 with native diagnostics.

Expanded issue #1 production-renderer injection checks expose missing canonical
GL.wgl_create_context on x64/arm64. Latest full suite: 139 passes/six dependency
failures (four File, two WGL). Original wheel-pump source checks still pass.
Win32 class reuse across module parameters is implemented, with a new source-check
regression; native Windows execution remains pending. Current coverage ledger and
handoff now supersede historical absent-font/render/API entries.

2026-10-14 current font/render batch (after `7fc1d6a`): real public Dynamic_Font
loading, metrics, UTF-8 preparation, glyph quads, retained face caches, RGBA atlas
uploads, immediate GL geometry/text, native window targets, texture framebuffers,
and fenced PBO readback are implemented. Canonical numerics types are used.
The expanded production-import runner recorded **139 passing invocations and four
Windows File dependency failures**, including interpreter/native O0/O2 for real
public window rendering, font layout, atlas text, GPU textures and pixel readback.
This is scoped host evidence, not combined corpus/Focus or Windows runtime evidence.

Follow-up changes add cached per-context VAO/VBOs, resize projection refresh,
framebuffer deletion on texture replacement/destruction, source-channel bitmap
decoding and RGB/RGBA-only encoding (JPEG quality 80). Final verification and
scoped commit follow verification. Pixel read flip/resize and fence polling pass
real-driver assertions. Full owned formatting check and warnings-denied lint pass.
Mip-chain and compressed subimage updates now use actual per-level native calls;
updated mip readback passes interpreter/native O0/O2. The full runner rerun retains
139 passes/four File failures. Native thread-local affinity reproducer fails as
documented, independently of the passing production GUI tests. No Extensions
changes or publication actions.

Synchronized-contract batch: public create_window uses the reviewed private
[3]float default/MSAA4. macOS host creation passes. Windows native class/title/
work-area/fullscreen and Linux GLX visual/MSAA/background/event-pump source passes
target checks. Win32 wheel injection now creates its 800x600 window through the
production public API; native Windows execution still requires Windows hosts.

Keymap has the complete reviewed procedure inventory: borrowed registration names,
owned command copies, shared versioned reader, chord/section/modifier grammar,
press/hold dispatch, reset/copy and normalized persistence. Behavioral tests pass
host interpreter/O0/O2. Windows dependency checks fail at NEW File's unconditional
OS_IS_UNIX assertion, reached via the canonical Text_File_Handler; reproducer added.

The independent producer's general procedure metadata patch is durable in
docs/native and built by tools/window_render_compiler.py only in worker target
staging. Real GL texture interpreter/O0/O2 now passes. Rust formatting and clippy
pass. This patched source-built candidate is not coordinator production integration.

Runner recorded 119 passes and 4 Windows File-dependency failures before mip tests;
the expanded run recorded 123 passes, the same four File failures and one private
packing-test alias failure after adding the real mip builder. The alias now points
to the actual public Simp builder and its focused interpreter check passes. No
substitute implementation was added. Full rerun continues with the next batch.

Owned mip storage uses pinned native stb resampling with alpha/sRGB, four-byte
strides and explicit ownership. Actual GL driver checks upload supplied chains
and verify terminal-level dimensions. Shader driver tests link reviewed macro-stage
sources. Full owned formatting/check/lint passed before the packing alias fix;
that scoped test is being rechecked.

Additional
shader/committed-text cases. macOS keyboard/text counts/filtering and Windows raw
WM_CHAR values now follow the reviewed committed-text contract; extra IME APIs
are outside compatibility scope. Shared-source shader preambles compile/link on
an actual Apple GL context. Next: owned mip storage and public font/render paths.

2026-10-14: resumed code checkpoints `a41ae76`, `0e5a7f2`, `375294d`, `982bc8c`. Prior focused runner
recorded 69 invocations; these include CPU component tests and foreign-target
interpreter checks, not combined production GUI integration. No release or
Focus acceptance is claimed.

Current batch: canonical AppKit dependency repaired; real native AppKit window
construction/close/release and public dimension/pointer/fullscreen-query source.
Host interpreter lifecycle test passes. Public create_window remains blocked by
the absent reviewed background default/type; the lifecycle test exercises the
real private constructor, not a fabricated public compatibility overload.

Issue #1: exhaustive signed-word decoding passes interpreter/native O0/O2;
Win32 MyWindowProc and PeekMessage/dispatch pump now handle signed wheel events,
native modifiers/states, keys/text/focus, resize/move, buttons and close requests.
Deterministic real-window PostMessage injection test type-checks x64/arm64;
native Windows execution remains pending coordinator hosts. Horizontal axis
encoding in Event needs reviewed clarification.

Focused runner: 87 invocations passed after replacing CPU substitute-module
tests with actual public Simp host bitmap/font imports. The obsolete substitute
modules have been removed. Owner-aware NEW producer staging removes obsolete
local Basic precedence. Current lint caught two existing owned manual assignment
forms; they were corrected without suppressions. Source-built jaifmt --check and
jailint -D warnings passed on every owned public/private/test Jai scope. Native
AppKit lifecycle passes interpreter/O0/O2; Windows arm64 and macOS arm64 no_dce
checks pass. macOS x64 POSIX dependency failure recorded with minimal reproducer.

Second batch: real AppKit queue/dispatch, native NSWindow notifications for
resize/move/focus/close/minimize, keyboard/repeat/release/modifiers, mouse buttons,
motion/scroll accumulation and external-event projection now pass host
interpreter/native O0/O2. Native Objective-C probe confirms AppKit re-translates
posted physical-key text; the strict test checks the actual translated character.
IME composition, drops/touch and immediate application of custom cursors to newly
created windows remain gaps. Source-built formatter and warnings-denied lint pass.
Next: actual native OpenGL texture driver verification, then remaining renderer/font
contracts; public create_window and Keymap grammar still require reviewed details.

New blocker: actual Apple OpenGL 4.1 context fixture source-builds successfully,
but canonical GL loader fails because general procedure-field reflection omits
PROCEDURE_WITH_VOID_POINTER_TYPE_INFO when exposing procedure fields as *void.
Minimal original reproducer and native-symbol control are in tests/window-render/repros.
Actual driver test fails in interpreter/native O0 before upload. It is added to
the focused runner without skipping/suppressing the failure; 87 successful
invocations above describe the preceding batch, not a passing GPU integration.
Compiler owner must fix the reflection flag; no table patches or peer Rust edits.

Latest batch: real private CPU glyph-atlas kernel loaded in Simp, using canonical
Font_Page/Font_Line/Glyph_Data and native FreeType metrics/coverage. Real caller-font
tests pass interpreter/native O0/O2, including exact bytes, padding/shelf placement,
empty glyph advance, native error propagation/page-full rejection, negative pitch,
mono expansion and allocation cleanup. It is not yet public Dynamic_Font/text rendering.
Existing-window cursor rect policy now applies immediately and native state is tested.

Final runner: **95 invocations passed, 3 failed**. Failures are the real texture
driver interpreter/O0/O2 at the same general reflection blocker. The runner reports
all independent failures and returns nonzero; it never executes stale binaries after
a build failure. Full owned jaifmt --check and jailint -D warnings pass; generated
84-declaration evdev and 38-format GL checks pass. Linux x64 / Windows arm64 /
macOS arm64 focused no_dce checks pass. Extensions diff remains empty.

Remaining: native window creation/pumps, Keymap operations, glyph atlas/text and
renderer/context integration. See the [deviations report](window-render-deviations.md)
and [coverage ledger](../window-render-coverage.md). No peer checkout edits.
