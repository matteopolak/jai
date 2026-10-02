# Compilation units

## What it is

`jai-driver` loads an application entrypoint and its recursive `#load` files into one compilation unit. `check`, `emit-llvm`, and `build` use this driver; `lex` examines only the supplied file.

## How it works

Each decoded file receives an opaque `SourceId`; the application has opaque `UnitId` and `ModuleId` values. Their `index()` accessors expose numeric identity without allowing callers to construct IDs. Source and compilation-unit fields are private and exposed through immutable getters, preserving the source-mapping invariant. Driver errors distinguish I/O, source decoding, located diagnostics (source ID, original span, and path), unlocated diagnostics, and load cycles. Literal top-level `#load "relative/path.jai";` paths resolve relative to the containing file. Canonical paths deduplicate repeated loads, and active recursion rejects cycles. Loading creates a shared parser input and symbol table, so declarations can refer across loaded files regardless of declaration order. Source segments map parser and semantic diagnostics back to the original file and byte offset. Whitespace separates segments to prevent token concatenation.

`#import` is explicitly rejected: imports require an independent module scope and an export/visibility graph, and treating them as loads would incorrectly expose application names to imported modules. Namespaced imports, import modifiers, conditional loads, computed paths, escaped path strings, and loads inside procedures are unsupported. Missing dependencies fail compilation; no supplied binary or library is executed.

## How to change it

Extend `CompilationUnit::visit` for supported dependency forms and add rejection tests for any unresolved syntax. Keep `SourceId` mappings intact when changing source assembly. Module imports should introduce an independently interned module AST plus typed import edges and explicit name resolution; do not flatten import declarations into the application symbol table. Currently unit and module IDs describe the single application and source IDs remain in the driver mapping; the downstream AST still uses assembled offsets. A future source-span migration must preserve diagnostic mapping during that transition.

## Configuration

No module search paths or import flags are supported yet. The CLI remains `jai-rs <check|emit-llvm|build> <entrypoint.jai> [output]`. All paths are resolved locally, and canonical identity follows filesystem symlinks.

## Dependencies

The driver uses the standard filesystem API and internal `jai-source`, `jai-lexer`, `jai-syntax`, and `jai-sema` crates. No new external dependencies are required. LLVM emission and trusted Clang linking remain in the CLI.
