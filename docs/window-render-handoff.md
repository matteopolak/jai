# Window/render worker handoff

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
