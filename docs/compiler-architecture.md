# Compiler architecture

## What it is

An independent Rust implementation targeting Jai source compatibility. Recent upstream applications and libraries refine the older beta 0.2.009 local distribution. It is **not a complete Jai implementation**; `HANDOFF.md` tracks the current status and open work.

The workspace has five crates:

| Crate | Role |
| --- | --- |
| `crates/jaic` | The compiler core: lexer, parser, semantic analysis, IR and interpreter. No external dependencies. |
| `crates/jaic-cli` | The `jaic` binary (`run`, `check`, `build`). |
| `crates/jaic-llvm` | Native backend over the shared IR (Inkwell, LLVM 22). |
| `crates/jai-language-server` | Bounded JSON-RPC language server built on the `jaic` lexer and parser. See [language-server.md](language-server.md). |
| `crates/jai-wasm` | Browser build: `jaic` plus the language server compiled to WebAssembly with the bundled `stdlib/`. See [browser-playground.md](browser-playground.md). |

## How it works

`jaic` is a pipeline: `lexer` -> `parser` (-> `ast`) -> `sema` (demand-driven typing into the checked tree, then lowering) -> `ir` -> `interp` (compile-time execution, `jaic run`, the browser) or `jaic-llvm`.

- `source.rs`, `intern.rs`: files, spans, diagnostics and the global symbol interner.
- `lexer.rs`: tokens. Keywords are ordinary identifiers; the parser gives them meaning by position. Directives (`#run`) and notes (`@x`) are separate token kinds.
- `parser/`: recursive descent to `ast.rs`. Types are ordinary expressions. Parsing stops at the first error (no recovery).
- `sema/`: resolves names on demand, so declarations are checked when something needs them. Files: `scope.rs`/`modules.rs` (imports, `#load`, scopes), `decls.rs`/`procs.rs`/`structs.rs` (declarations), `expr.rs`/`stmt.rs`/`calls.rs` (checking), `consteval.rs` (constants), `typeinfo.rs`/`runtime_info.rs` (reflection), `bake.rs`/`modify.rs` (polymorphism), `lower.rs` (to IR), `driver.rs` (entry points and `Options`).
- `build.rs`: build workspaces and compiler messages for metaprograms (`#run` programs that call the `Compiler` module).
- `interp/`: IR interpreter used for `#run`, metaprograms and `jaic run`. Its host abstraction (`Host`, `SandboxHost`) decides which `#foreign` calls exist; the browser uses the sandboxed one. Raw memory access is confined to `interp::memory`.
- `stdlib/` (independently written standard library) and `prelude/` (runtime type definitions) are plain Jai loaded through the virtual or real filesystem (`sema::FileSystem`).

## How to change it

Add syntax in `lexer.rs`/`parser/` and `ast.rs` first, with parser tests in `parser/tests.rs`. Then teach `sema/` to check and lower it, and add a program under `tests/stdlib/` or `tests/corpus/` that exits 0 (or a negative case). Run `python3 tools/jaic-sweep.py corpus stdlib upstream --timeout 900`; only `getrect-rh-negative-control` is expected to fail. Unsupported constructs should produce a diagnostic, never a silent success.

## Configuration

```sh
cargo run -p jaic-cli -- check file.jai [-I dir] [-os linux|windows|macos]
cargo run -p jaic-cli -- run file.jai [- metaprogram args]
```

Native builds need an independently installed LLVM 22 (see [llvm-backend.md](llvm-backend.md)).

## Dependencies

`jaic` uses only Rust's standard library. `jaic-llvm` uses Inkwell/LLVM 22. The language server uses `serde`/`serde_json`. No supplied binary is part of the implementation.

## History

An earlier multi-crate architecture (`jai-source`, `jai-types`, `jai-lexer`, `jai-syntax`, `jai-modules`, `jai-eval`, `jai-sema`, `jai-ir`, `jai-vm`, `jai-codegen`, `jai-driver`, `jai-cli`, `jai-runtime`, `jai-bench`) was retired once `jaic` superseded it, and so were its fuzz targets and benchmark harness. Many documents in this folder were written against it. Their descriptions of language behavior and design intent remain useful, but crate names, file paths and test counts in them are historical; look in `crates/jaic/src/sema` and `crates/jaic/src/interp` for the corresponding current code.
