# Scripting runtime

## What it is

`jai-runtime` checks and executes Jai source using the same checked IR interpreter as compile-time `#run`, without an LLVM dependency. `jai-wasm` exposes that frontend and engine to WebAssembly; it does not compile Jai programs into native instructions or a compact bytecode format.

## How it works

`Script::prepare` loads a source graph through an explicit `SourceProvider`, resolves a checked library, and selects a single `main` in the root module. The entry accepts no parameters or one `[]string` parameter and returns `int` or `void`. This script contract is separate from the native executable ABI. Imported `main` declarations and unsupported signatures are rejected.

Each `Script::run` creates a fresh VM with `ExecutionPhase::Runtime`, virtual global storage, and the checked context schema's defaults. Normal calls share context mutations. `#compile_time` evaluates to false during script execution; semantic preparation still runs its `#run` requests in the default compile-time phase. Runtime dispatch rejects a `#compile_time` procedure through direct, indirect and resumable calls.

Arguments retain their exact boundaries, including empty strings and spaces. The host feeds a managed virtual `[]string`; it never inserts an implicit `argv[0]`. A script with no parameter rejects extra arguments. Integer results retain their signed 64-bit value in the embedding API. The CLI exposes its low eight bits as the OS process status; a void result is zero. Errors and pending dependencies remain failures rather than successful fallback results.

```jai
main :: (args: []string) -> int {
    if args.count != 2 return 1;
    if args[0] != "two words" return 2;
    if args[1] != "" return 3;
    return 42;
}
```

```sh
cargo run --offline --locked -j 1 -p jai-runtime --bin jai-script -- run script.jai -- "two words" ""
```

`SourceBundle` is a closed virtual source filesystem. Its relative source names map under `/jai-script`; normal `#load` and explicitly configured import roots resolve only supplied files. Missing files never fall back to the host filesystem. The native CLI instead opts into `jai_modules::Filesystem` to read source inputs. Reading source does not grant runtime file access.

The portable runtime advertises no file, process, graphics or foreign-function capabilities. A reached foreign procedure or external global returns a typed `HostBindingRequired` with its checked identity. There is no arbitrary native FFI, supplied library loading, process launch or graphics emulation. Existing compiler host adapters are not automatically granted to script execution.

The WebAssembly bridge uses bounded scalar byte channels for source text, relative source names and arguments. Exported functions never dereference JavaScript-provided pointers. Each run returns a real interpreter result or owned diagnostic bytes. The browser wrapper keeps the signed `i64` result as a JavaScript `BigInt`; the UI formats it as text. The interpreter runs in a worker so cancellation can terminate the whole worker. `engine.mjs` rejects modules that unexpectedly request host imports.

```sh
rustup target add wasm32-unknown-unknown --toolchain nightly-2026-08-29
python3 tools/build_scripting_wasm.py
node tools/check_scripting_wasm.mjs artifacts/scripting-runtime/jai_wasm.wasm
python3 -m http.server 8080 --bind 127.0.0.1 --directory artifacts/scripting-runtime
```

Then open `http://127.0.0.1:8080/`. The build script stages the browser files with the actual Rust-generated `.wasm` module under the ignored `artifacts/` directory. Native bridge tests verify the boundary on the host; the Node harness separately instantiates and executes the real WebAssembly module. Neither a host-target test nor a native run establishes WebAssembly acceptance.

## How to change it

Extend source and entry behavior in `crates/jai-runtime/src/sources.rs` and `entry.rs`, preserving root declaration identity and the exact checked signature. Add another entry contract explicitly; do not relax the native `Program` entry verifier to support scripts. Runtime construction and outcome conversion live in `lib.rs`.

`jai-vm/src/execute/execution_phase.rs` owns the immutable phase and procedure checks. Constructor and retained-state hooks must preserve it; resumable boolean operations read it at execution time rather than freezing a true literal into the plan. Compile-time remains the default for existing callers.

Host string slices are admitted in `execute/host_arguments.rs` using existing managed string backing and sequence byte images. Preserve allocation, work, metadata and value bounds before copying or installing storage. This is ordinary virtual storage, distinct from escaping sequence-pack temporaries.

Implement host services through authenticated checked procedure capabilities and typed request/response handlers, following the existing file/process adapters. A matching function or library name alone must not authorize an adapter. Browser file access, graphics callbacks, process semantics and native FFI require separate implementations and tests; adding a `HostCapability` enum value does not implement a service.

The pointer-free ABI lives in `jai-wasm/src/exports.rs`; its state and budgets live in `bridge.rs`. Rust classifies symbol-export attributes as unsafe syntax, so only this export module permits those attributes. The interpreter and bridge contain no unsafe blocks. Keep `engine.mjs` and the wasm harness synchronized when changing exports. Run native runtime tests, native bridge tests, the actual wasm harness, and browser interaction checks separately.

## Configuration

`Options` selects the source `BuildTarget`, graph import roots and VM limits. Native defaults derive host OS/architecture without LLVM. `browser_target()` selects WebAssembly32, little endian and four-byte virtual pointers; Jai `int` remains signed 64-bit. VM fuel, stack depth, evaluation depth, allocations and value-cell limits apply to execution and compile-time source preparation.

The CLI accepts `--fuel <steps>` before `--`; everything following `--` is an exact UTF-8 argument. The browser API accepts an unsigned 32-bit fuel count. `SourceBundle` defaults to a 4 MiB aggregate source limit. The wasm bridge limits argument text to 1 MiB, argument count to 16,384, and source names to 4,096 bytes. Browser fuel defaults to 1,000,000 steps.

`build_scripting_wasm.py --release` selects optimized Rust output; `--output <directory>` selects the staged runner directory and preserves relative output paths against the current working directory. `--target-dir` overrides a nonempty `CARGO_TARGET_DIR`, then pinned Cargo's configured target directory. Build commands and wasm artifact lookup use that same absolute path. On this host use `--target-dir /Volumes/CodexBuilds/targets/jai`; [build storage](build-storage.md) describes the verified APFS setup. The staged `build-metadata.json` records target selection, query/build commands, compiled/staged paths and the module hash. Builds remain offline, locked, single-job and non-incremental, and refuse to start below 2 GiB free on source, build or staging storage. The pinned wasm Rust target must already be installed.

## Dependencies

Both packages are explicit members of the root Cargo workspace. The authored-package scope guard in `tools/check_rust_format.py` requires this registration, so workspace formatting, Clippy and test commands include their committed sources and tests. Keep the two local package records in `Cargo.lock` aligned with their manifests; this registration adds no registry dependency. It retains the existing one-shot `Script::prepare` API. Retained compiler controllers, platform host bindings and reflection receipt carriers require their own producer and consumer changes. A formatting check does not establish native, WebAssembly or browser execution acceptance.

`jai-runtime` uses only internal frontend/type/IR/interpreter crates. `jai-wasm` depends only on `jai-runtime`. These dependency paths contain no `jai-codegen`, `jai-llvm`, `inkwell`, `llvm-sys`, browser package manager or third-party wasm binding dependency.

The native CLI uses Rust's filesystem source provider. The browser runner uses standard WebAssembly, workers and text encoding APIs. Python stages the runner and Node verifies the generated module. Rust's `wasm32-unknown-unknown` target provides no native filesystem/process services; host functions must be supplied explicitly when a future capability requires them. See the [official Rust target documentation](https://doc.rust-lang.org/rustc/platform-support/wasm32-unknown-unknown.html).
