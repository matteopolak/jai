# Window/render worker handoff

Narrow follow-up for candidate 2fa2bc2 (from 3ced6c4): bounded retries for transient
pinned-source download failure before Mesa compilation. Four total attempts,
120s per blocking network operation, 2/4/8s backoff; each transfer uses a fresh
temporary sibling, removed on failure. Closed files must match the unchanged
pinned SHA-256 before durable promotion/extraction. Valid existing archives are
rehashed/reused; corrupt caches and TLS/permanent/local filesystem errors fail.
No source pin, WGL target/install/export/dependency/loaded-file check or verified
LLVM receipt policy is relaxed. No live download or Mesa rebuild was needed.

New original regression command: `python3 tests/window-render/test_mesa_download.py`
(nine tests, scripted transport, no server). Re-run source/cache/install and the
prepared-child-Python tests: all 28 helper tests pass locally. Python compilation,
plan-only execution and scoped whitespace checks also pass. No Jai/Rust code
changed, so no new Jai/Rust formatter/linter claim is made. Normal coordinator CI must
still establish real ARM64 driver build/install/load and fresh GL/readback/public
events/render/lifecycle results. Downstream missing-driver failure on 2fa2bc2 is a
consequence of the failed fetch, not native renderer evidence. Release remains held.
See [download failure details](native/window-render-wgl-investigation.md).


Narrow normal-CI fix fora6371ec: distinguish optional configured search paths from
mandatory native SDK/tool inputs. Missing VS2026 auxiliary INCLUDE/LIB entries are
recorded deterministically; real directories still hash completely and later
creation invalidates the key. Required selected ARM64 SDK/runtime/platform files
must exist and be the first reachable matches. Missing compiler/SDK/library sets
still fail. Explicit native VS/VC/UCRT root metadata authorizes real auxiliary
directories; no alternate SDK is guessed. New configuration schema2 preserves
full LLVM completion receipts, with no unsafe old-key migration. All WGL target,
install/hash, export/dependency and loaded-driver checks are unchanged.

Validation: `python3 tests/window-render/test_mesa_source.py` ten pass;
`python3 tests/window-render/test_mesa_install.py` eight pass; prepared venv Python
`tests/window-render/test_mesa_python.py` one pass. SDK-layout fixtures contain
original metadata bytes only, never runnable compilers/drivers. Current filtered
WebGPU headless/windowed positives on both Windows CPUs remain separate from
unverified WGL. Coordinator should run normal native CI using the same selected
vcvars/venv and fresh Mesa output/full-receipt cache commands documented in the
[native build handoff](native/window-render-wgl-investigation.md). Publication held.
Python py_compile and --plan checks pass. Full owned jaifmt --check and the
existing integrated native-host jailint -D warnings scope rerun pass, without
incomplete diagnostics. These checks do not replace normal native Windows CI.

Latest native install work: e223538 useda68544c and reached Mesa install but no
required WGL pair was found. Pinned Mesa source validates those names and proves
our empty platforms option omitted the WGL target subdirectories. Corrected to
platforms=windows, explicit canonical ICD name; no discovery assertion is relaxed.
Added native target/install/filetree evidence and mapped/hash-verified discovery,
SDK architecture/export/dependency validation and actual deployed-file GL-probe
identity checking. Full1f66dc1 LLVM receipt/cache logic is preserved; Mesa-only
configuration changes do not invalidate it. Coordinator-ownedc68d19d workflow is
not edited. See [exact native rerun/evidence handoff](native/window-render-wgl-investigation.md).

Current tool tests: `python3 tests/window-render/test_mesa_install.py` eight pass;
`python3 tests/window-render/test_mesa_source.py` seven pass; prepared venv Python
`tests/window-render/test_mesa_python.py` one pass. No native DLL fixture is executed
or counted as graphics support. Python syntax/plan checks also pass. This tools-only
scope changes no Jai/Rust/Extensions or inherited stdlib tests. Native ARM64 WGL
compile/install/dependency/probe/draw/readback/lifecycle and Windows lint still need
actual CI. Compiler linking/headless WARP and signed-wheel ARM64 positive feedback
are retained as separate evidence, not proof of OpenGL support.

Verification also reran full owned jaifmt --check and the existing integrated
native-host jailint -D warnings scope (eight public roots, Contexts/Lifecycle/
Cocoa/native-fields and macOS event test); both pass without incomplete diagnostics.
The five reviewed native Meson files match the source archive with pinned SHA256
bb6243e7a6f525febfa1e6ab50827ca4d4bfdad73812377b0ca9b6c50998b03e.
These checks do not establish native Windows SDK/driver execution. Source/SDK tests
are independently authored infrastructure regressions; no legacy replaced-stdlib
tests were reintroduced as gates or read to infer compatibility APIs.

Native build infrastructure checkpoint: `a68544c` fixes Mesa child Python selection
with an explicit generated native machine file, prepared venv and pinned Mako/
PyYAML. Authorizeda78721d feedback establishes ARM64 LLVM build completion followed
by global-python Mako setup failure; it establishes no new driver/runtime success.
The follow-up cache uses exact source/toolchain/config keys, complete installed-file
hashes and native identity/relocation checks. Restore/save only the dedicated
target/window-mesa-cache and use a fresh --out for Mesa/driver output. Old LLVM
directories without completed receipts are not adopted. See
[native handoff](native/window-render-wgl-investigation.md) for prerequisites,
configuration, retry/deployment commands and explicit cache/platform limitations.

Actual local commands for this tools-only batch:
`python3 tests/window-render/test_mesa_source.py` (seven pass),
`'target/window mesa python tools/bin/python' tests/window-render/test_mesa_python.py`
(real Meson1.8.3, one pass), and Python py_compile/--plan checks.
The prepared local venv contains pinned Meson/Mako/MarkupSafe/packaging/PyYAML;
global packages were not modified. No Jai/Rust source changed. Full owned jaifmt
--check was rerun and passes; current native-host jailint -D warnings passes on
the eight integrated public roots plus Contexts/Lifecycle/Cocoa/native-fields and
the macOS events regression, without incomplete diagnostics. All54 owned Jai files
match the staged lint inputs. This is not native Windows lint or runtime evidence.
Coordinator must run the native ARM64 build, deploy its real PE-matching DLLs, and
retain actual interpreter/O0/O2 GL identity/draw/readback/lifecycle plus strict lint
gates. SDK hashes/native cache checks themselves have not executed on this macOS host.

Implementation checkpoint `821adb4`; final runner186/zero, including final Windows
lifecycle source checks. Strict host lint also covers standalone Cocoa and portable
native fields; no incomplete roots/warnings. Mesa build on macOS correctly exits2
requiring native Windows ARM64; do not count that guard/plan as a built driver.

Latest WGL batch: filtered run38662728329 establishes actual x64 Mesa4.6 and
passing public probe/events/drawing in interpreter/O0/O2. Lifecycle and native
Windows lint remain failures; ARM64 has actual GDI Generic1.1. No raw logs read.
Official Mesa's pre-procedure WM_DESTROY drawable release explains a concrete
hazard in our close callback. Production now uses real matching-pixel-format
retirement window/DCs, retains a usable share owner, and reports immediate WGL
selection errors. Original lifecycle test adds actual owner rebinding and repeated
MSAA teardown without removing shared-texture/PBO assertions.

Validation: `python3 tools/check_window_render.py --font /System/Library/Fonts/Helvetica.ttc`
passed186 invocations/zero failures on the context change; the extended lifecycle
test additionally passes Windows x64/arm64 `-check`. Full owned jaifmt --check and
integrated native-host jailint -D warnings pass, no incomplete-root notes. Three
`python3 tests/window-render/test_mesa_source.py` safety regressions pass; both
CI helpers and that test py_compile. `window_render_mesa_windows.py --plan` runs;
actual build correctly requires native Windows ARM64. The pinned source build
and deployment commands/evidence boundaries are in
[WGL investigation](native/window-render-wgl-investigation.md). Native rerun must
verify lifecycle and strict Windows lint on both CPUs, deploying real ARM64 Mesa
first. Filtered summaries now provide native error stages and lint headers/locations.
No native Windows success is inferred from local checks. Older creation-only
diagnoses below are historical. Bindings owner still owns canonical WGL cleanup;
no peer edits or staged binding replacements were made.

Fresh tooling/lint scope: current NEW compiler and jailint rebuilt, jaifmt rebuilt with that compiler. Use actual integrated production library roots for lint, not local facade copies whose parent prepends inherited dependencies. Eight staged facades plus private context/lifecycle modules and macOS event test pass -D warnings with no incomplete roots. New Windows tool requires matching source-built jailint and rejects stderr/incomplete compilation as failure. Original all-local-root failure evidence and proper platform/negative-test distinctions are recorded in deviations. Cursor close search/retirement cleanup and retained-cursor native regression pass interpreter/O0/O2; no blanket lint suppression.

Windows WGL investigation: authorized filtered CI candidate0100a1f confirms issue#1 signed wheels pass BOTH CPUs, but real renderer WGL creation fails all modes on both. New production diagnostics, canonical native driver probe, full public color/texture framebuffer regression and explicit real software-driver deployment tool are ready for native CI. Root cause/actual installed driver remain unverified; no API/coverage reduction or peer edits. Bindings-owner immediate native failure-stage/error capture is requested in native/window-render-wgl-investigation.md.

Latest supported-path verification:182 focused invocations passed, zero failed; all owned Jai formatting/check and warnings-denied lint pass. Native Windows/physical hotplug and Linux GUI runtime remain pending. The broader no_dce Unicode producer failure and earlier intermittent macOS text observation remain unresolved and explicitly recorded. Extensions are unchanged; no full corpus/Focus/release acceptance is claimed.

Pointer follow-up: native Windows motion now accumulates per-window signed coordinate deltas; client moves/focus loss reset the baseline and destruction removes records. Packed mouse message flags drive button modifiers/state; keyboard events retain native GetKeyState policy. New public-window injected-pointer test covers two windows, signed16 extremes, frame/focus reset and button transitions. It remains pending native Windows execution. Exact upper-bit packet assertions repair the wheel tests own signed32-before-widen construction error; portable exhaustive decoder coverage remains active.

Current verification:180 focused invocations pass, zero fail; formatting/check and warnings-denied lint pass on all owned Jai. Native notification runtime/physical hotplug remain pending; canonical x64/arm64 parser and native-test source checks pass. Public macOS event posting now queries native NSApplication.sharedApplication, fixing the migration-only null helper state while retaining every assertion. Earlier intermittent text109 failure remains recorded. New all-code dependency reproducer unicode-no-dce.jai passes ordinary Windows arm64 check but fails no_dce in NEW Unicode fixed-array literal initialization; no peer or staged-import workaround.

New device callback path and retained failure: Windows native registration/rollback/unregistration plus bounded UTF-16 arrival/removal decoder are implemented. Exact parser executes for x64/arm64; real public-window SendMessageW regression source-checks both CPUs, with native runtime pending. One expanded run had179 passes/one intermittent macOS-events interpreter assertion (text109 instead of65); diagnostics and all assertions remain. One isolated and30 later interpreter runs passed, but root cause is not established and no automatic retries/ignored failures were introduced. See current progress and native device-notifications notes.

Texture color-space checkpoint:174 focused invocations pass, zero fail. The real-driver regression covers public bitmap load, reallocation and same-size update with repeated linear/sRGB transitions, preserved unrelated flags/native identity, queried GL storage formats and exact raw pixels. Both storage and public state follow incoming Bitmap.IS_SRGB. All owned Jai formatting/check and warnings-denied lint pass. Additional macOS x64 public window, text-renderer and color-space source checks pass. Native Windows execution remains pending.

Latest font regression batch fixes a production GSUB endian-decoding bug; typed widened operands preserve high bytes without disabling checked casts. New original TrueType/GSUB/GDEF assets exercise real FreeType single1/2, alternate, extension, coverage1/2, ordered substitutions, digit effect precedence and glyph advances. Public GL text renders all four effect combinations with distinct actual framebuffer coverage. Generator: python3 tools/window_render_feature_font.py --check. No external font asset was copied. Full verification count follows in progress; Windows native execution and general sequence shaping remain unclaimed.

Resumed dependency/OEM/lifecycle batches:159 focused invocations pass with zero failures using
fresh own compiler sources, latest NEW bindings and platform-io File/Process.
Owned format/check/lint and generated native declarations pass. macOS x64 POSIX
and Windows filename-font checks also pass separately. Native Windows runs for
newer work remain pending. Compiler reflection is now integrated in the producer;
tools/window_render_compiler.py builds it without the historical patch. The incident
was cleared as authorized metadata-only integration feedback; no reimplementation.

Windows WM_DESTROY renderer cleanup now has a real native close-all/reopen test,
including live texture and pending readback preservation. Both Windows CPUs
source-check it; actual native execution remains pending. A root native HGLRC owns
the share group while closed-window DCs are not reused. Native class/private DCs
remain OS-owned and common DCs are released. WGL swap uses canonical loader sentinel
filtering. Teardown intentionally drains the GPU queue with glFinish; ordinary
context switches retain server-side fences. Linux teardown and foreign HWND/thread
notification remain open, documented in the deviations ledger.

Latest durable checkpoints `b9e7115` and `31ded39` implement production public fonts/text/GL rendering,
native window targets/lifecycle and asynchronous readback. Current expanded runner:
147 passes/six Windows dependency failures (File and WGL). Format/check and warnings-denied lint passed on
all owned Jai code/tests; generated declarations verified. Public AppKit swaps,
multiwindow close/reopen, retained GPU resources, depth/stencil readback and Keymap
regressions pass interpreter/native O0/O2. See current status and
deviations for unresolved lifecycle/platform work; historical notes below are
preserved evidence and superseded where the coverage ledger says so.

Read [coverage](window-render-coverage.md), [implementation and commands](window-render.md),
and [precise unresolved contracts](specs/stdlib/window-render-questions.md) together.
The entire assigned API is **not complete**. This worker has kept native failures visible
and has not filled missing exports with stubs or synthetic resources.

## Latest validation

- `python3 tools/window_render_native.py`: built pinned image codec static/shared libraries
  and independent Objective-C clipboard probe from native C/SDK source in local target.
- `python3 tools/check_window_render.py --font /System/Library/Fonts/Helvetica.ttc`:
  **69 invocations passed**. The OS font is a caller-specified runtime test input, never
  copied into the repository. See the runner for exact scope and target matrix.
- Actual host interpreter/native O0/O2: sRGB, SDL mapping/parser, bitmap codec CPU source,
  Cocoa clipboard, FreeType face lifecycle. Native clipboard checks include partial alpha,
  exact encoded RGB samples, and flipped/non-flipped rows through an independent decoder.
- Linux-target interpreter: canonical types, shared input frame reset, callbacks, key
  translation, invalid windows, public bitmap and font APIs, real SDL2 virtual device
  attach/button/hold/release/axis/detach pipeline.
- Linux/Windows x64/arm64 type-checks: common records/key translation plus applicable
  libevdev signatures, X11 queries, native window layouts, Win32 queries and clipboard,
  and OpenGL texture procedure bodies. Native GPU execution remains unverified.
- Real source-built jaifmt formatting then `--check`: all eight owned module trees, five
  owned internal trees, and all tests/window-render Jai files. Repository config unchanged.
- Source-built jailint `-D warnings -I stdlib`: same entire owned Jai scope passes.
- SDL database regeneration followed by real formatting is byte-idempotent. Source and
  normalized payload digests, origin, record count and license are pinned in metadata.
- `python3 -m py_compile` on all five owned Python tools passes.
- `python3 tools/window_render_evdev.py --check` and
  `python3 tools/window_render_gl_formats.py --check`: all 84 native declarations and
  38 texel/block descriptions regenerate byte-identically through the real formatter.
- No modified Rust files: rustfmt/clippy modification checks are inapplicable. The actual
  compiler and linter were built from permitted new compiler worker Rust sources.

## Integration source boundaries

Local staging: `target/window-integration-stdlib` combines the sanitized local stdlib with
permitted new sources from ../stdlib, ../foundations, ../bindings, ../numerics and ../compiler.
Peer Extensions are excluded. Compiler worker sources were copied into
`target/window-compiler-source` and built with:

```sh
cargo build --manifest-path target/window-compiler-source/Cargo.toml --locked \
  -p jaic-cli -p jailint --target-dir target/window-compiler
JAIC_STDLIB=$PWD/target/window-integration-stdlib target/window-compiler/debug/jaic \
  jaifmt/main.jai -O2 -exe target/window-jaifmt
```

The local inherited compiler still searches module.jai; the permitted worker compiler
uses prelude/module.jai. No reference compiler or supplied reference binaries were run.
No other checkout was modified. No agent transcripts, original checkout/history,
credentials, or coordinator data were read. Existing unrelated dirty specs/AGENTS changes
were left unstaged. `git diff -- stdlib/Extensions` is empty.

## Integration gates

1. Native binding owner: canonical Objective_C.NSWindow and NSWindowStyleMask are missing.
   Reproducer: `.../jaic tests/window-render/types.jai -check -os macos -cpu arm64 -I stdlib`.
2. Specification review: resolve default window background color and its inferred type,
   Keymap grammar/dispatch policy, shader stage-source encoding, and font/mipmap details.
   The OpenGL texture layout gate was resolved by the latest reviewed `gl_handle: GLuint`
   field and the source now uses actual GL names. NONE retains its empty shape.
3. Foundation integration: `-no_dce` currently encounters inherited Basic.Buffer pointing
   to a missing internal/basic export. Do not remove the assertion or add a fabricated
   type to this worker's code. Retry full all-code coverage with integrated foundation APIs.
4. File owner: the current File facade asserts OS_IS_UNIX. Simp's filename-font overload
   gives a specific unsupported-target diagnostic on Windows; memory-face loading remains
   a real independent FreeType path.
5. Actual Linux GUI/libevdev devices, a Windows host, and physical gamepads are required
   for remaining hardware/native-platform verification. Source checks alone are not proof.
6. Binding owner: GL context-constructor exports are missing in the new source. Reproduce
   with tests/window-render/repros/gl-context.jai, compile-only on Linux. The texture source
   requires a caller-owned valid current context and uses the actual GL module, not a
   duplicated binding or a fake function table. Framebuffer/window rendering remains open.

Private Win32 clipboard SDK helpers can be absorbed by the bindings owner without public
API changes. Source declarations use official Microsoft documentation, and all observable
memory ownership/format transfer follows native calls. The Cocoa straight-alpha regression
was found by independent decoding and corrected with the SDK bitmap-format flag.

Additional regressions verify caller-allocator retirement while other fonts remain alive,
embedded-NUL Cocoa text, explicit Windows NUL-format rejection, common gamepad states when
event generation is disabled, and preserving an existing caller SDL event queue/policy.
Fresh privately initialized SDL polling disables only its own unused native event stream;
pre-existing SDK event ownership is retained. SDL_SetMainReady is a private SDK bridge for
standalone non-SDL-main programs. Physical controller coverage remains outstanding.

2026-10-14 resumed batch: canonical Objective_C/AppKit imports now unblock public
Simp host bitmap/font interpreter/native O0/O2 tests; obsolete CPU substitute
modules removed. Source-built jaifmt rebuilt using NEW producer dependencies and
unchanged local Extensions. Owner-aware staging is `python3 tools/window_render_stage.py`.
The runner uses staging alone, eliminating inherited Basic precedence.

Issue #1 has exhaustive native-field decoding and an expected-failing original
checked-narrowing regression. MyWindowProc decodes signed wheel words before checked
arithmetic and propagates native modifier/button states and wheel events through
PeekMessageW/DispatchMessageW. tests/window-render/windows-events.jai posts native
messages into a real registered HWND and checks both axes, extrema, zero, modifier
bits, upper WPARAM bits and repeated -120 frames. Windows x64/arm64 source checks
pass, including arm64 no_dce; native Windows execution is still pending.

Real private AppKit construction/lifecycle plus public queries pass host interpreter
and native O0/O2; arm64 no_dce passes. Public create_window still needs the reviewed
background default/type. The test's private native constructor is not public API
completion. macOS x64 currently fails in NEW POSIX itimerval availability, with
an original compile-only reproducer. Native AppKit probes built with clang
-Wall -Wextra -Werror confirmed redundant activation-policy failure and Dock window
position constraints; neither native failure was ignored or replaced by fake values.

Full deviations/progress live in docs/status. Native Windows/X11/GPU/physical
devices/Focus acceptance and combined production corpus remain coordinator gates.

AppKit pump batch: 87 focused invocations pass including real NSApplication
post/dequeue/dispatch with key presses/repeats/releases and synchronous native
window resize/close notifications in interpreter/native O0/O2. The notification
observer is a native NSObject subclass with no custom ivars, retained for process
lifetime. Native text is raw key-event text; NSTextInputClient marked-text/IME
composition remains outstanding. An independent native probe preserves evidence
that posting an inconsistent physical A key plus emoji text is retranslated by
AppKit to A; the production test now asserts that actual native behavior and
separately verifies caller-supplied external Unicode projection.

Actual GPU verification attempt now exposes a compiler dependency blocker. Build
the test native libraries with `python3 tools/window_render_native.py`; the Apple
SDK fixture creates a real OpenGL 4.1 core context. Running texture-driver.jai in
interpreter/native O0 fails in canonical GL.gl_load at indexed extension discovery.
GL symbol lookup succeeds; a minimal generic reflection test proves missing
PROCEDURE_WITH_VOID_POINTER_TYPE_INFO for stored callbacks under the procedure-hiding
struct directive. See questions #26. This driver regression is included in the
runner and is currently failing, not counted as completed GPU behavior.

Private CPU glyph-atlas batch: exact production kernel is loaded in Simp; the
component test aliases the canonical public records, with no substitute Math/font
types. Real FreeType coverage and native advance/bearings feed transparent padded
shelf pages. Blank glyphs, page-full/native errors, signed pitch, monochrome expansion
and all tracked allocations are tested. This is CPU staging evidence; Dynamic_Font
ownership/layout, GPU upload and public text drawing remain incomplete.

Latest focused result: 95 compiler/program invocations passed and 3 actual-driver
executions failed at the reflection dependency. Failure aggregation now completes
independent checks and returns failure; native execution is conditional on a successful
build, preventing stale-binary passes. Full owned source-built jaifmt --check and
jailint -D warnings passed. Generated libevdev/GL mappings remain idempotent. Focus
and full combined production acceptance remain pending, with no release action.
