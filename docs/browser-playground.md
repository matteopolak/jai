# Browser playground (jaic backend)

## What it is

The browser Run button compiles and interprets the workspace with the new compiler core `crates/jaic`
(lexer, parser, sema, interpreter) compiled to WebAssembly inside `crates/jai-wasm`. The full `stdlib/`
(and `prelude/`) are embedded in the wasm module, so `#import "Basic"` and friends work offline.
The shared language server (`jai_lsp_*`, `crates/jai-language-server`, built on the same `jaic` lexer and parser) is the only other export.

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
4. `web/scripting-runtime/engine.mjs` exposes `play(files, main)` (and `lsp(message)`); `worker.mjs` answers `run` messages with
   `{type:"run", play}`; `editor.mjs::showPlay` prints stdout, stderr, rendered errors and
   the exit code in the Output panel, and puts positioned diagnostics in the Problems panel and editor
   (kept in `runDiagnostics`, separate from language-server diagnostics, cleared when the file is edited).

## How to change it

- Different target or options: `options()` in `play.rs`.
- More host services (files, time): extend `SharedHost`/`SandboxHost::foreign` in `crates/jaic/src/interp/mod.rs`.
- Result shape: change `PlayResult::to_json` and `showPlay` together.
- Gotchas: under `OS == .WASM`, Runtime_Support writes output through the foreign
  `wasm_write_string(count, data, to_standard_error)`, which `SandboxHost` implements. The jaic interpreter stores
  host pointers in 64-bit slots, which works on wasm32. There is no step limit or argument list: the playground has no run options.
  Infinite loops hang the worker; use Cancel (terminates the worker).
- Panics: wasm32 panics abort, so a compiler bug traps the instance (`RuntimeError: unreachable`). `jai_play_reset`
  installs a panic hook (wasm32 only) that records the message; `engine.mjs::play` catches the trap and throws
  `The compiler crashed: <message>` with `compilerCrashed = true`, and `worker.mjs` drops its engine so the next
  Run instantiates a fresh module. `jai_play_panic_len/byte` read the message.
- No real clock on wasm32 (`std::time::SystemTime::now` panics): `#cycle_counter` counts calls, and `SandboxHost`
  implements `clock_gettime` (virtual, deterministic, +1 microsecond per call), `nanosleep` (no-op) and
  `wasm_debug_break` (runtime error), so `current_time_monotonic`, `random_seed` and friends work.
  Other native `#foreign` symbols fail with `foreign procedure 'x' is not available here` or `unknown library`.
- The worker check (`tools/check_playground_worker.mjs`) smoke-tests Hash_Table, a `#run` workspace message loop, empty views and the virtual clock.
- Regression sweep for the wasm build: run every `tests/stdlib/*.jai` through `engine.play` with a fresh engine each
  (about 93 of 120 pass; the rest need threads, a clipboard, a POSIX-only module, `atof`, or multi-file module trees).

## Configuration

- Build: `cargo build -p jai-wasm --release --target wasm32-unknown-unknown` (or
  `python3 tools/build_scripting_wasm.py --release`, which stages `web/scripting-runtime/` plus `jai_wasm.wasm`).
- Serve the staged directory with any static server and open `index.html`.
- Native test: `cargo test -p jai-wasm play`; `node tools/check_scripting_wasm.mjs <jai_wasm.wasm>` runs fixtures against the built module (hello world, sibling `#load`, positioned diagnostics, scalar ABI).
- The wasm is about 30 MB because the stdlib is embedded.

## Dependencies

`jaic` (no external crates), `jai-language-server`, CodeMirror bundle in
`web/scripting-runtime/editor.bundle.mjs`.
