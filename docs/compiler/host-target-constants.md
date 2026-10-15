# Compiler host and output target constants

`BUILD_OS` and `BUILD_CPU` describe the platform of the running compiler binary.
`OS` and `CPU` describe the selected output target, including child workspaces.
They resolve through the same canonical bootstrap enum declarations; no separate
host enum, library parameter, or module-specific comparison is introduced.
A native macOS/ARM64 compiler emitting WASI therefore has MACOS/ARM64 build tags
and WASM/CUSTOM target tags. A compiler built for wasm32 has WASM/CUSTOM build
tags, even when checking a Linux/X64 child workspace. Running that wasm compiler
under Node on macOS does not make Node’s platform the compiler platform.

The implementation shares one private `compiler_host()` platform mapping with
`Options::host()`. Target selection never changes this mapping. Unsupported
compiler host OS/architectures now fail the Rust build explicitly instead of
falling through to Linux/X64. Supported hosts remain Windows/macOS/Linux on
x86_64 or aarch64, and wasm32. This does not add output targets or backends.
`TEMPORARY_STORAGE_SIZE` and private finalized runtime data are unchanged.

The reviewed Basic Preamble contract requires a cross-target early return.
The independent foundations request and its original predicate/Preamble tests
were read from NEW producer sources and copied to our own
`target/producer-fixtures/host-target` before execution. No peer artifacts were
written. The original Rust regression failed before the repair with
`BUILD_OS == .MACOS` false for a Windows output selection. It now checks all
12 representable OS/CPU option combinations, including same-OS/different-CPU,
canonical enum identity, and both true/false cross predicates. These combinations
exercise semantic constants, not a claim that every combination is an executable
target. Original LLVM tests actually execute native and WASM64 output at O0/O2.

Executed verification (logs `target/host-target-*.log`):

- Source-built native compiler: `LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jaic-cli --bin jaic`.
- Core/backend library and focused atomic/context/reflection/variadic/interface/
  register/module/literal/layout/namespace/Windows-thread/runtime-config suites
  pass, including both new host-target tests.
- Staged predicate passes `-check -target wasm64-unknown-wasi`; native host must
  reject its cross-only assertion. Preamble prints `ok` in interpreter and
  actual native O0/O2 and WASI O0/O2 execution. WASI execution uses
  `node --no-warnings tools/wasi_run.mjs <own staged artifact>` with no unknown
  import replacements.
- `JAIC_STDLIB=$PWD/target/runtime-configuration-candidate/stdlib CARGO_TARGET_DIR=target RUSTC_WRAPPER= cargo build --locked -p jai-wasm --target wasm32-unknown-unknown`,
  then `node tools/check_host_target_wasm.mjs target/wasm32-unknown-unknown/debug/jai_wasm.wasm`
  pass. This runs the actual wasm32 compiler, repeated executions, a Linux/X64
  NO_OUTPUT child, and invalid root/child assertions.
- CLI plugin/older-runtime rejection tests pass with the unadapted independent
  overlay. Runtime allocation tests pass separately with the adopted candidate,
  retaining real native/interpreter allocation and late cross-workspace updates.
  The initial run incorrectly selected the adopted consumer for the older-runtime
  rejection test; its failure remains in `host-target-cli-regressions.log`.
- Scoped rustfmt/item-spacing and all-target core/backend/CLI clippy pass with
  warnings denied; wasm32 and Windows x64/ARM64 core clippy pass. Staged producer
  fixtures pass jaifmt check; Preamble passes strict verbose jailint. The
  cross-only predicate deliberately rejects on the native lint target, and this
  jailint has no target option. Its incomplete-check failure is retained rather
  than counted as a lint pass. No new Jai implementation files were changed.

Runtime runs use the existing documented private-protocol candidate, assembled
from independent NEW producers and modified only under this checkout’s target.
Portable producer adoption remains pending; see [runtime configuration](runtime-configuration.md).
This is local candidate evidence, not full corpus or production integration.

The extra negative control exposed a browser-driver failure: child compilation
errors were printed to stderr but the parent still executed successfully.
The driver now propagates finish errors, rejects recorded child failures before
main or compile-only success, and preserves the original stderr diagnostic.
The structured failure identifies a failed metaprogram workspace; precise child
source diagnostics remain in stderr because child source maps are separate.
An original Rust test and the real wasm32 negative control verify this behavior.

Broader `cargo test --locked -p jai-wasm --lib` with the independent candidate
reports 21 passes and 8 failures, retained in `host-target-wasm-lib.log`:
POSIX native guard (two input cases), File native guard (two File/thread cases),
legacy negative allocation returning null, legacy log newline, legacy implicit
exit visibility, and a bridge source-text assertion. These are not suppressed,
retired, or claimed fixed here; reviewed API/dependency classification and producer
integration are needed. Actual Windows runtime and cross-native execution remain
platform gates. Existing AST/debugger/alternate-backend limits remain unchanged.
