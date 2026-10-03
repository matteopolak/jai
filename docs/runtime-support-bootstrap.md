# Runtime support bootstrap

## What it is

The runtime bootstrap selects the actual `Runtime_Support` source module, supplies build policy as typed module parameters, and binds its compiler procedures to compiler effects. This lets the independently authored runtime use the same output and storage contracts in native and virtual-file-system embeddings.

## How it works

A bootstrap selection is resolved through the configured `SourceProvider`; the resulting module identity is retained as `ModuleGraph.runtime_support`. Compiler binding retains the selected entry’s original declaration spans and source identity, then authorizes the corresponding concrete `DeclarationId` in each parameterized instance of that exact source image. It validates every checked signature. A similarly named file, a copied source, or a declaration inserted from another source does not acquire runtime authority by basename or spelling. The `write_string` compiler intrinsic appends output to the active compiler-effect transaction, so failures roll it back before publication. Native embeddings publish through their host interface; the browser adapter can publish through its VFS console service.

`BuildSettings.temporary_storage_size` is retained per workspace and defaults to `32768` bytes. `set_build_options` accepts the optional `Build_Options.temporary_storage_size` field as a nonnegative source `s32`; `get_build_options` returns the retained value. Runtime bootstrap passes it into `Runtime_Support` as `TEMPORARY_STORAGE_SIZE`, which sizes the first thread's temporary storage. The source module retains a default of `32768` for ordinary imports.

Target conditionals use the caller's explicit `BuildTarget` and the source-owned `Operating_System_Tag` in Preload. The source graph resolves conditions such as `OS == .WINDOWS` against that nominal enum, preserving the actual selected target and source schema. Targets without a source tag fail with a located diagnostic rather than using the host operating system.

## How to change it

Change `Runtime_Support.jai` for runtime behavior and keep its compiler declarations matched to the source intrinsic signature checks. Extend `BuildSettings`, `BuildOption`, the `Build_Options` projection, compiler snapshots, and runtime bootstrap arguments together when adding another build-controlled runtime parameter. Preserve the public fields already declared in `stdlib/Compiler/module.jai`; keep newly supported fields optional so existing source callers remain valid.

When changing target condition behavior, update the source enums in `prelude/platform.jai` and the `OperatingSystem::source_tag` mapping together. Conditions must use a caller-supplied target and source-defined enum values.

## Configuration

`JAI_RS_RUNTIME_SUPPORT=search` selects `Runtime_Support.jai` or `Runtime_Support/module.jai` from the ordered module roots. A file selection uses `JAI_RS_RUNTIME_SUPPORT=<path>`. Runtime support also requires a selected Preload source. `JAI_RS_PRELOAD` selects it; the source graph receives a `BuildTarget` from the embedding. `JAI_RS_RUNTIME_ENTRY`, `JAI_RS_RUNTIME_INITIALIZATION`, and `JAI_RS_RUNTIME_BACKTRACE` control the three existing bootstrap flags.

## Dependencies

The implementation uses `jai-modules` source-provider graph identities, `jai-driver` workspace build settings, `jai-sema` checked compiler-procedure binding, `jai-vm` transactional compiler effects, and `jai-platform` native/VFS host services. Preload's platform enum and `jai-types::BuildTarget` define the target mapping.
