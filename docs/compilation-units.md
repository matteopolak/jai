# Compilation units

## What it is

`jai-driver` coordinates independently scoped application and library sources. `check`, `check-library`, `emit-llvm`, and `build` use its module graph; `lex` and `parse` inspect only the supplied file.

## How it works

The driver loads a `jai-modules::ModuleGraph`, retaining immutable source records, file-relative AST spans and one shared spelling interner. `SourceId`, `UnitId` and `ModuleId` come from `jai-source`; the driver no longer allocates competing identities or concatenates source. Recursive `#load` creates independent file scopes inside the owning module. Canonical paths deduplicate loads within a module, and active recursion rejects cycles.

Anonymous and named imports instantiate isolated modules. Declarations resolve through their defining file and module, so imported procedures cannot acquire application globals. Reexports preserve declaration and storage identity. See [module scopes](module-scopes.md) and [scoped semantics](scoped-semantics.md).

`CompilationUnit::resolve` returns a checked executable program and requires an application-owned `main`. `resolve_library` checks the same declarations and bodies without inventing an entrypoint. Library checking proves semantic acceptance; it does not establish native linking or a complete project build. Structured errors preserve original source identities, spans and paths.

Parameterized/string imports, conditional dependencies, computed or escaped paths, and nested procedure imports remain unsupported. Aggregate syntax can be inspected independently, but aggregate source semantics still fail explicitly. No supplied binary, native library or source build script is executed.

## How to change it

Dependency loading and visibility belong in `jai-modules`; declaration/type checking belongs in `jai-sema`. Keep the driver as coordination and diagnostic rendering. Extend graph and semantic tests before routing a new form through CLI compilation. Preserve definition scopes and source identity rather than introducing source concatenation or name rewriting.

## Configuration

`CompilationUnit::load_with_options` accepts `GraphOptions::import_dirs`. The CLI uses the platform-separated `JAI_RS_MODULE_PATH` when supplied, otherwise the process-relative `modules` directory. File/directory imports remain relative to their importing source.

```sh
JAI_RS_MODULE_PATH=reference/modules cargo run -p jai-cli -- check application.jai
cargo run -p jai-cli -- check-library module.jai
```

These commands still fail on unimplemented language features; selecting the standard-library search path does not make the library supported. All dependency paths are canonicalized locally.

## Dependencies

The driver uses `jai-modules`, `jai-source` and `jai-sema`; source decoding/parsing are performed by the graph's lexer and syntax dependencies. LLVM emission and trusted Clang linking remain downstream in codegen and CLI. No external dependencies were added.
