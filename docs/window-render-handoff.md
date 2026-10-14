# Window/render worker handoff

Read [coverage](window-render-coverage.md), [implementation and commands](window-render.md),
and [precise unresolved contracts](specs/stdlib/window-render-questions.md) together.
The entire assigned API is **not complete**. This worker has kept native failures visible
and has not filled missing exports with stubs or synthetic resources.

## Latest validation

- `python3 tools/window_render_native.py`: built pinned image codec static/shared libraries
  and independent Objective-C clipboard probe from native C/SDK source in local target.
- `python3 tools/check_window_render.py --font /System/Library/Fonts/Helvetica.ttc`:
  **57 invocations passed**. The OS font is a caller-specified runtime test input, never
  copied into the repository. See the runner for exact scope and target matrix.
- Actual host interpreter/native O0/O2: sRGB, SDL mapping/parser, bitmap codec CPU source,
  Cocoa clipboard, FreeType face lifecycle. Native clipboard checks include partial alpha,
  exact encoded RGB samples, and flipped/non-flipped rows through an independent decoder.
- Linux-target interpreter: canonical types, shared input frame reset, callbacks, key
  translation, invalid windows, public bitmap and font APIs, real SDL2 virtual device
  attach/button/hold/release/axis/detach pipeline.
- Linux/Windows x64/arm64 type-checks: common records/key translation plus applicable
  libevdev signatures, X11 queries, native window layouts, Win32 queries and clipboard.
- Real source-built jaifmt formatting then `--check`: all eight owned module trees, five
  owned internal trees, and all tests/window-render Jai files. Repository config unchanged.
- Source-built jailint `-D warnings -I stdlib`: same entire owned Jai scope passes.
- SDL database regeneration followed by real formatting is byte-idempotent. Source and
  normalized payload digests, origin, record count and license are pinned in metadata.
- `python3 -m py_compile` on the three owned Python tools passes.
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
2. Specification review: resolve default window background color, complete OpenGL texture
   platform layout/resource identity, Keymap grammar/dispatch policy, and font/mipmap
   details. A by-value Texture containing no native identity cannot distinguish two
   otherwise identical GPU resources; an address registry would be incorrect.
3. Foundation integration: `-no_dce` currently encounters inherited Basic.Buffer pointing
   to a missing internal/basic export. Do not remove the assertion or add a fabricated
   type to this worker's code. Retry full all-code coverage with integrated foundation APIs.
4. File owner: the current File facade asserts OS_IS_UNIX. Simp's filename-font overload
   gives a specific unsupported-target diagnostic on Windows; memory-face loading remains
   a real independent FreeType path.
5. Actual Linux GUI/libevdev devices, a Windows host, and physical gamepads are required
   for remaining hardware/native-platform verification. Source checks alone are not proof.

Private Win32 clipboard SDK helpers can be absorbed by the bindings owner without public
API changes. Source declarations use official Microsoft documentation, and all observable
memory ownership/format transfer follows native calls. The Cocoa straight-alpha regression
was found by independent decoding and corrected with the SDK bitmap-format flag.
