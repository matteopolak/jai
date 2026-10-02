# Compiler prelude

## What it is

`prelude/` is the compiler's independently authored Jai bootstrap protocol. It exposes the source names and storage contracts required by Jai libraries while the Rust compiler implements reflection, intrinsic binding, VM execution, and context activation.

## How it works

`prelude/Preload.jai` loads seven source files into one ordinary module. Each file owns a protocol: target tags, reflection descriptors, allocation, diagnostics, runtime storage adapters, intrinsic declarations, or delayed context registration. Static nested enums sit beside their owning descriptor contract; runtime fields retain the ordering required by the ABI.

`jai_modules::compiler_prelude_source()` composes those same authored files for source overlays. A physical graph keeps each fragment's source locations; an overlay keeps one immutable source snapshot. Both use the existing graph's designated Preload identity, nominal declaration registry, and semantic schema adoption. The helper does not fabricate a second type registry or inject application-name lookalikes.

The public protocol retains 50 top-level declarations. Names, enum representations and values, nested enum ownership, stored fields, `#as` header conversion, allocator procedure parameters, intrinsic result obligations, and the deferred `FIRST_ADD_CONTEXT` quotation are compatibility requirements. This source is a declaration interface rather than an implementation of the supplied compiler. Intrinsic calls bind to checked Rust operations; only the workspace query has a runtime fallback, returning workspace zero. Runtime_Support still supplies `Context_Base` and initialization.

The implementation deliberately keeps source-defined nominal types instead of replacing them with hardcoded semantic types. Libraries can therefore obtain the canonical source identity and reflection metadata through the ordinary compiler path. Public declaration syntax necessarily resembles the specified Jai interface; protocol-specific files, explicit composition, and compiler-owned behavior provide the independent architecture.

The former vendor bootstrap is no longer a build dependency. The historical hosted developer-help probe is retired because its workflow staged that original file. [Reference probe history](reference-probes.md) retains the observed result and its original input hashes without claiming that the authored prelude reproduces it.

## How to change it

Change the relevant protocol file and update both the `Preload.jai` load list and the composition in `compiler_prelude.rs` when adding a fragment. Keep fragments declarative: imports, native libraries, `#run`, allocation and side effects do not belong in this bootstrap interface. New intrinsic behavior belongs in the Rust source binder, typed IR/VM operation, and native backend.

Do not change runtime field order or enum values casually. Reflection schema adoption, allocator validation, caller locations, native descriptor publication, and actual library callers depend on those contracts. Record fields marked `using #as` must preserve both lookup and conversion metadata. Resolve `Context_Base` only when Runtime_Support activates the context quotation.

`jai-modules`' `preload-source` tests check the complete composed source and the physical fragment graph, including one shared module and equal exports. Semantic `preload`, source-schema, caller-location, and compile-time-condition tests check canonical types and target tags. The CLI workspace test builds and executes an authored program after generated-source replay using the mandatory composed prelude. Genuine pinned library/example checks remain separate acceptance evidence; bootstrap success alone does not establish a complete standard-library build.

## Configuration

The existing bootstrap API is unchanged. `PreludeSource::File(path)` can select the physical entry, `Search` selects an actual `Preload.jai` in ordered module roots, and `Disabled` keeps isolated consumers bootstrap-free. `COMPILER_PRELUDE_ENTRY` names the repository-relative physical entry for Rust callers.

For an explicit CLI source-library check from the repository root:

```sh
JAI_RS_STDLIB="$PWD/reference/modules" \
JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
target/debug/jai-rs check-library reference/modules/Atomics.jai
```

`JAI_RS_STDLIB` still chooses the requested library sources. Selecting this prelude does not replace those sources or enable runtime support. Runtime source selection and its three explicit policy flags retain the behavior documented in [Preload bootstrap](preload-bootstrap.md).

## Dependencies

The prelude has no native library or external service dependency. Its Rust composition uses compile-time includes of repository-authored sources, and source loading uses `jai-modules`. Its public declarations rely on `jai-syntax`, `jai-types`, `jai-sema`, `jai-vm`, and the native backend to validate and implement their contracts. Original distribution and pinned upstream sources are read-only compatibility inputs, never host-native dependencies.
