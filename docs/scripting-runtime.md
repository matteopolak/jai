# Scripting runtime (browser build and staging)

## What it is

The browser runs Jai through `crates/jai-wasm`, which links the `jaic` compiler (interpreter backend, bundled `stdlib/`) and the shared language server into one `jai_wasm.wasm` module with no host imports. `tools/build_scripting_wasm.py` builds it and stages it with `web/scripting-runtime/`. How a program is compiled and run is described in [browser-playground.md](browser-playground.md); the editor UI in [browser-editor.md](browser-editor.md).

This page replaces an earlier description of a separate `jai-runtime` script engine (with `jai_script_*` exports, fuel and argument channels). That engine and its bridge were removed together with the other legacy crates; the playground never used them after it moved to `jaic`.

## How it works

`python3 tools/build_scripting_wasm.py [--release]` runs an offline, locked, single-job, non-incremental `cargo build -p jai-wasm --target wasm32-unknown-unknown`, checks the `\0asm` header, and copies the module plus every file in `web/scripting-runtime/` into the output directory (default `artifacts/scripting-runtime`, ignored by git). It writes `build-metadata.json` with the build command, target directory selection, paths and the module SHA-256. It refuses to start below 2 GiB free on the source, build or staging volumes.

`engine.mjs::createEngine(wasmBytes)` instantiates the module (rejecting any host import) and returns `play(files, main)` and, when the module exports it, `lsp(message)`. Both exchange bounded scalar bytes with the module; no pointers cross the boundary.

```sh
rustup target add wasm32-unknown-unknown --toolchain nightly-2026-08-29
python3 tools/build_scripting_wasm.py --release
node tools/check_scripting_wasm.mjs artifacts/scripting-runtime/jai_wasm.wasm
node tools/check_playground_worker.mjs artifacts/scripting-runtime
python3 -m http.server 8080 --bind 127.0.0.1 --directory artifacts/scripting-runtime
```

Then open `http://127.0.0.1:8080/`. `tools/check_browser_release.mjs <staged-dir>` additionally needs the `release.json` written by `tools/package_browser_release.py`; see [browser-compiler-releases.md](browser-compiler-releases.md).

## How to change it

Export changes live in `crates/jai-wasm/src/play_exports.rs` (`jai_play_*`) and `language_server.rs` (`jai_lsp_*`); Rust classifies symbol-export attributes as unsafe, so only those modules allow them. Keep `engine.mjs` and the Node checks (`check_scripting_wasm.mjs`, `check_playground_worker.mjs`, `check_browser_release.mjs`) in step with the exports. A native test or a host-target run does not establish WebAssembly acceptance; the Node harness executes the real module.

## Configuration

`--release` selects optimized output; `--output <dir>` selects the staging directory; `--target-dir` overrides `CARGO_TARGET_DIR` and Cargo's configured target directory (on this host, see [build storage](build-storage.md)). The pinned wasm target must already be installed. The wasm32 build links with a 256 MiB shadow stack (see `crates/jai-wasm/build.rs`).

## Dependencies

`jaic`, `jai-language-server` (and its `serde`/`serde_json`), Python 3.11 or newer for staging, Node for the checks, and the CodeMirror bundle already in `web/scripting-runtime/editor.bundle.mjs`. Rust's `wasm32-unknown-unknown` target provides no filesystem or process services; the interpreter's `SandboxHost` supplies the few libc shims the standard library needs.
