# Module scope syntax foundation

## What it is

`jai-source` provides opaque compilation identities and immutable source records. `jai-syntax::parse_file` parses one file independently, and `jai-modules::ModuleGraph` resolves its source dependencies, module namespaces, exports, and file privacy. Executable lowering is a separate semantic/backend responsibility.

## How it works

Create a `SourceMap`, insert decoded UTF-8 source with its display path, and pass its `SourceRecord` plus a session `Symbols` table to `parse_file`. `ParsedFile::source()` identifies the file and `items()` preserves its top-level order. Each top-level item carries a `SourceSpan`. Nested expressions and statements retain file-relative `Span` values, converted through `ParsedFile::location(span)`; they never refer to concatenated source. Parse errors are `LocatedDiagnostic` values with source identity and original offsets.

`SourceId` is allocated by `SourceMap`. `Identities` allocates `UnitId`, `ModuleId`, `ScopeId`, and `DeclarationId`; constructors are private and each ID has `index()`. These IDs are registry-local: use one registry of each kind per compilation session. A `Symbol` identifies an interned spelling, not a declaration. All independently parsed files share one `Symbols` table, which is restored even after parser errors.

The parser starts each file in `Visibility::Export`. `#scope_export`, `#scope_module`, and `#scope_file` update subsequent declaration/import visibility, with optional semicolons. `FileItem::Load` preserves a dependency rather than expanding it; it does not inherit a caller's visibility into the loaded file.

`FileItem::Import` records an optional namespace, `using`, active visibility, `ImportMode::{Search, File, Directory, String}`, a literal target, and separate instance/program argument lists. Absent lists differ from explicit empty lists. Argument names use `Symbol`; values use `ModuleArgumentValue::{Expression, String}`. `#module_parameters` records inferred, scalar, or string parameter types and optional defaults, with a separate optional program-parameter list. Duplicate parameter directives in one file fail parsing; argument duplication, binding, evaluation, module-entrypoint placement, and program-parameter ordering belong to semantic graph construction.

Qualified references have `ExpressionKind::QualifiedName(NamePath)` or `QualifiedCall(NamePath, arguments)`, where `NamePath` contains a root `Symbol` and ordered member symbols. This is module qualification syntax; arbitrary struct/member access and indirect calls remain unsupported.

The existing `parse(&str)` API is an explicit compatibility entrypoint for the executable subset. It rejects scope/import/load/module-parameter directives and qualified references. The driver uses `parse_file` through the module graph; the scalar `parse` API remains useful for isolated frontend tests. Module syntax acceptance through `parse_file` is not evidence of resolved imports or executable support.

### Scoped module graph

`ModuleGraph::load(entrypoint, GraphOptions { import_dirs })` creates an application module and recursively loads its dependencies. File and directory imports resolve relative to the importing file. Named search checks each configured directory in order, preferring `Name.jai` over `Name/module.jai` within a directory. Filesystem paths are canonicalized; each canonical module entrypoint identifies one unparameterized imported instance.

A `FileInstanceId` identifies a file's participation in one module. Canonical `#load` paths deduplicate within that module, and every loaded file gets its own file scope starting in export mode. The same source can also appear in another module: immutable source text and parsed syntax are shared, but its file scope and declaration identities are distinct.

`Binding::{Declaration(DeclarationId), Module(ModuleId)}` separates name resolution from spelling. Every declaration stores its defining file, syntax, and original location. A file-private binding shadows the containing module binding. Module-private declarations are visible to all files of that module, while namespace lookup consults only exports. Imported procedures retain their defining file for later semantic resolution and cannot acquire application globals through an import.

Anonymous imports link exported bindings into the active file/module/export scope. Namespace imports bind a module reference. `using Alias :: #import` binds that namespace and also links its exports. Reexports preserve declaration and module identity; they do not duplicate storage. Repeated imports of the same binding are idempotent, while unrelated bindings with the same destination name produce located collision errors. Export linking order is deterministic.

Graph accessors expose immutable modules, files, declarations, source records, spellings, and typed import/load edges. `lookup(file, NamePath)` returns a typed binding or `LookupError`; `locate(file, span)` attaches the original source identity to nested syntax offsets. Import/load cycles are explicitly rejected with the originating dependency location. Source parse failures and binding conflicts render their original file and line.

Module parameter declarations and either supplied import argument list (including explicit empty lists) are rejected in this first graph slice. String imports and compile-time conditional dependencies remain unsupported. The graph itself does not validate procedure bodies or require `main`; that belongs to semantic resolution, with `main` restricted to the application by the executable entrypoint policy.

## How to change it

Edit `jai-source/src/locations.rs` for source records and compilation identities, `jai-syntax/src/modules.rs` for module AST/parser behavior, and `jai-modules/src/loader.rs` for source loading and export linking. Public graph types and lookup live in `jai-modules/src/lib.rs`. Add AST variants for new dependency forms before teaching the graph resolver their semantics. Keep syntax and visibility resolution separate: import aliases must eventually refer to declaration identities, and module instances must own distinct globals. Do not concatenate module text or ignore scope directives to produce successful builds.

Parameter declaration blocks, conditional imports/loads, nested procedure imports, escaped module strings, here-string imports, and computed dependency targets explicitly fail in this foundation. Supporting them requires additional AST and semantic phases. In particular, recent Simp and Vk-Engine parameter blocks introduce declarations visible to parameter defaults; accepting only the parameter header would lose meaning.

Reference rules come from `reference/how_to/040_import_and_load`, `151_file_and_global_scopes`, and `380_module_parameters`. Recent corpus examples in jaison, Linux_Display, Simp, and Vk-Engine confirm file/module scope switches and both parameter lists. The historical tutorial documents order-sensitive explicit-argument deduplication; the parser preserves argument ordering without deciding module-instance identity.

## Configuration

The CLI selects module search directories with platform-separated `JAI_RS_MODULE_PATH`, defaulting to `modules`. Graph callers supply `GraphOptions::import_dirs`; its default is the process-relative `modules` directory. Per-file parser callers supply decoded sources and one interner. `SourceMap` performs no filesystem reads, path canonicalization, or source decoding; those remain driver responsibilities.

## Dependencies

This foundation uses standard Rust, `jai-source`, `jai-lexer`, and the existing `jai-types` scalar types. It adds no external dependencies. `jai-modules` depends only on source, syntax, and lexer, allowing sema to consume it without depending on the driver. The driver reexports it as `jai_driver::modules` and resolves checked programs through the graph-aware semantic APIs.
