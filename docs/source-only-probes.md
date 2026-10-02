# Source-only compatibility probes

## What it is

The `jai-syntax` `source-check` example reads a supplied source file and runs the existing lexer/parser independently of semantic or backend build readiness. It neither executes source procedures nor invokes an original compiler, linker or native library.

## How it works

```sh
cargo run -p jai-syntax --example source-check --locked -- path/to/module.jai
```

The probe decodes original file bytes, inserts one immutable source record, and calls the same public `parse_file` API as the compiler. Success reports the original path and top-level item count with an explicit `syntax only` label. Failure renders the original file, line, character and parser diagnostic. No source statements are stripped or rewritten to make a file pass.

The `jai-modules` `bootstrap-check` example exercises actual automatic module loading with an explicit target and three supplied runtime parameters:

```sh
cargo run -p jai-modules --example bootstrap-check --locked -- \
  path/to/main.jai linux-x64-lp64 false true false path/to/modules
```

This uses `ModuleGraph::load_with_bootstrap_options` and its normal filesystem provider. It requires real Preload and Runtime_Support sources, selects dependencies through ordinary compile-time graph evaluation, and reports module/source/declaration counts with a `source graph only` label. A graph check can expose a missing dependency or unsupported source construct while the semantic compiler is being extended; it does not run procedures or validate procedure bodies.

The complete permitted vendored `Preload.jai` passes syntax, module graph and semantic library integration tests. The semantic fixture checks that same unchanged source with an explicitly selected target, canonical source reflection schemas and typed compiler/intrinsic bindings. A successful parser or module graph probe by itself is not evidence of semantic checking, runtime execution or full standard-library compatibility. Full Runtime_Support and native execution remain separate gates.

## How to change it

Change the parser or lexer to support source syntax; keep the probe a thin caller of their existing APIs. Do not add another AST or parser implementation. Retain original immutable text and located errors. Use exact source fixtures for acceptance and clearly identify excerpts when a test establishes only one prerequisite.

## Configuration

Syntax tests read optional supplied and pinned upstream fixtures at runtime. Missing optional inputs produce an explicit skip message; other read errors still fail. Authored grammar and malformed-input fixtures remain mandatory, so a clean checkout can compile and exercise syntax without redistributing original sources.

`source-check` requires one source file argument. Source parsing has no target or runtime options. `bootstrap-check` requires an entry source, an explicit `linux-x64-lp64` or `macos-arm64-lp64` target profile, three `true`/`false` arguments (entry point, initialization, backtrace), and one or more ordered module roots. Both supplied profiles explicitly select little-endian LP64 layout. Additional target profiles should preserve explicit source-visible OS/architecture/layout facts. Layout-dependent semantic checks likewise must supply explicit `BuildTarget` or layout policy.

## Dependencies

`jai-syntax`, `jai-lexer`, `jai-source`, `jai-modules`, `jai-types` and Rust's standard library. The probes are independent of LLVM, semantic scheduling and native hosts. Optional local original source corpora are read as data and are not bundled into the example executables.
