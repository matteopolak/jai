# Filesystem and generated source providers

`SourceProvider` supplies source bytes and path identities to the module graph. `Filesystem` preserves normal file loading; `SourceOverlay` adds generated files without writing them to disk or combining independently scoped files.

## How it works

`ModuleGraph::load_with_provider` routes canonicalization, reads, and import-search probes through one provider. The ordinary `load` method selects `Filesystem`. All providers feed the same decoding, parser, dependency scheduling, source identity, visibility, and cycle checks.

An overlay records virtual files under absolute normalized paths. Existing files and parents retain their filesystem canonical identities; wholly virtual paths normalize `.` and `..` lexically. Explicitly inserted virtual files override those selected paths. Missing virtual inputs fall through to the filesystem. Relative loads and file imports continue to resolve from their defining source's parent directory, and search imports use `GraphOptions::import_dirs`.

Generated input remains source data. Providers never execute build scripts or load native objects. Parse errors retain the virtual file path and line instead of being attributed to a concatenated root program.

## How to change it

Implement the three `SourceProvider` methods for another input store. Canonicalization and reads must agree on identity, and `is_file` must recognize inputs that import search can read. Keep decoding and parsing in the graph loader. Do not give two spellings of one file different identities, or dependency deduplication and cycle checks will diverge.

The overlay tests exercise generated imports and loads, virtual search roots, normalized cycles, source-located parse errors, and invalid-byte decoding. Driver workspace scheduling must preserve successfully executed compile-time request identities across input additions; rebuilding a graph must not execute previously committed requests again.

## Configuration

Use `SourceOverlay::insert(path, bytes)` to register an input and `load_with_provider(path, options, &overlay)` to load it. Import directories come from `GraphOptions`; no environment variables or background file writes are introduced here.

## Dependencies

This component uses the Rust standard library and `jai-modules`' existing lexer, parser, and source map. The driver can consume it for committed generated-source requests.

The driver's `load_with_target` uses the same source provider path with explicit `BuildTarget` facts. Semantic `resolve_with_target` receives that selected layout and byte order; cross-target compile-time queries must not use host pointer sizes. The CLI selects this target before graph loading and code generation.
