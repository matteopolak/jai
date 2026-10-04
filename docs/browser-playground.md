# Browser playground (jaic backend)

## What it is

The browser Run button compiles and interprets the workspace with the new compiler core `crates/jaic`
(lexer, parser, sema, interpreter) compiled to WebAssembly inside `crates/jai-wasm`. The full `stdlib/`
(and `prelude/`) are embedded in the wasm module, so `#import "Basic"` and friends work offline.
The old `jai-runtime` bridge (`jai_script_*`) and the language server (`jai_lsp_*`) are still exported.

## How it works

1. `crates/jai-wasm/build.rs` walks `stdlib/` and `prelude/` and generates `$OUT_DIR/stdlib_files.rs`
   (`BUNDLED: &[(&str, &[u8])]` of `include_bytes!`). `stdlib/Preload.jai` does `#load "../prelude/Preload.jai"`,
   hence both trees. On wasm32 the script also links with a 256 MiB shadow stack (`-zstack-size`), because
   the compiler recurses deeply.
2. `src/play.rs::run(files, main)` builds a `jaic::sema::VirtualFs` with the bundled files at `/stdlib/...`
   and `/prelude/...` and the user files at `/workspace/<path>`. Options: import path `/stdlib`, preload
   `/stdlib/Preload.jai`, target **WASM / Wasm** (`OS == .WASM`). It installs a `SharedHost` (wraps
   `jaic::interp::SandboxHost`, which provides libc shims and captures stdout/stderr) as the interpreter host,
   calls `compile_program` then `run_program`, and returns a `PlayResult`
   `{exitCode|null, stdout, stderr, rendered, diagnostics[{severity,file,line,column,message}]}` as JSON.
   Diagnostics with a `path:line:col:` message prefix (runtime traps) are split apart; others use the span.
3. `src/play_exports.rs` is the pointer-free scalar ABI (same style as the other exports):
   `jai_play_reset`, `jai_play_push(channel, byte)` (0 = path, 1 = contents, 2 = main path),
   `jai_play_finish_file`, `jai_play_run`, then `jai_play_output_len/byte` (JSON) and `jai_play_error_len/byte`.
4. `web/scripting-runtime/engine.mjs` exposes `play(files, main)`; `worker.mjs` answers `run` messages with
   `{type:"run", play}` when available; `editor.mjs::showPlay` prints stdout, stderr, rendered errors and
   the exit code in the Output panel, and puts positioned diagnostics in the Problems panel and editor
   (kept in `runDiagnostics`, separate from language-server diagnostics, cleared when the file is edited).

## How to change it

- Different target or options: `options()` in `play.rs`.
- More host services (files, time): extend `SharedHost`/`SandboxHost::foreign` in `crates/jaic/src/interp/mod.rs`.
- Result shape: change `PlayResult::to_json` and `showPlay` together.
- Gotchas: under `OS == .WASM`, Runtime_Support writes output through the foreign
  `wasm_write_string(count, data, to_standard_error)`, which `SandboxHost` implements. The jaic interpreter stores
  host pointers in 64-bit slots, which works on wasm32. The "Step limit" option is currently ignored by this path.
  Infinite loops hang the worker; use Cancel (terminates the worker).
- `tools/check_playground_worker.mjs` and `tools/check_browser_release.mjs` still assert the old run result shape.

## Configuration

- Build: `cargo build -p jai-wasm --release --target wasm32-unknown-unknown` (or
  `python3 tools/build_scripting_wasm.py --release`, which stages `web/scripting-runtime/` plus `jai_wasm.wasm`).
- Serve the staged directory with any static server and open `index.html`.
- Native test: `cargo test -p jai-wasm play` (hello world, sibling `#load`, positioned diagnostics, scalar ABI).
- The wasm is about 30 MB because the stdlib is embedded.

## Dependencies

`jaic` (no external crates), `jai-runtime` and `jai-language-server` (legacy exports), CodeMirror bundle in
`web/scripting-runtime/editor.bundle.mjs`.
