# Window/render worker handoff

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
