# Implicit Preload bootstrap

## What it is

Preload is the shared source-defined scope above the application and every imported module. `ModuleGraph::load_with_bootstrap` resolves an actual Preload file through the compilation's source provider and loads it as one canonical fallback module.

## How it works

`PreludeSource::Search` requires `Preload.jai` or `Preload/module.jai` in the configured module roots, in that order within each root. `File(path)` selects an explicit file, and `Disabled` explicitly omits bootstrap for isolated frontend consumers. Selection uses the same provider and canonicalization as ordinary sources. Missing or inaccessible required input produces an error; it does not manufacture declarations.

The original `151_file_and_global_scopes` tutorial specifies lookup in file scope, then the containing application/module scope, then Preload. Local bindings may shadow Preload. An imported module never sees application declarations. The graph retains one shared Preload module identity and resolves fallback from its exports without copying those exports into unrelated module namespaces. Ordinary explicit imports of the same canonical Preload file reuse its existing module identity and source syntax. Checking Preload itself designates the root module, avoiding a second copy of its declarations.

Preload records and enums have declaration identity in the compilation's existing type registry. After source records resolve, `reflection/schema/preload.rs` adopts the designated module's `Type_Info` declarations. It validates runtime field names, ordered types, nominal field ownership, header embedding/conversion metadata, and enum representations, flags and ordered values. Nested flag enum identities come from their canonical owning fields and the existing member metadata table. This does not reserve replacement nominal types or create another registry. Equally named application records cannot satisfy missing Preload declarations.

The installer completes builtin `Any` with that same canonical descriptor header. When the caller supplies target layout, it validates the designated source `Any_Struct` using exact source field names, ownership and pointer types, then obtains an `AnyStorageBridge` proof of equal selected layout. `Any` and `Any_Struct` retain distinct type identities; this storage proof adds no implicit conversion between them. Without explicit layout, descriptor identity installation still proceeds, while layout-dependent storage validation waits.

The [authored compiler prelude](compiler-prelude.md) supplies allocator types and `FIRST_ADD_CONTEXT`, a deferred `#code #add_context #as using base: Context_Base`. An explicitly selected source `Preload.jai` can supply the same protocol. `Runtime_Support.jai` supplies the actual `Context_Base` fields, allocator procedure, temporary storage and initialization behavior. Its required module parameters select system entry point generation, initialization and crash backtraces. A complete runtime bootstrap must bind those parameters from explicit compiler build policy and establish the context base before user context extensions. Selecting Preload source alone does not implement that runtime bootstrap.

File-level quotations and their immutable aliases join the typed declaration readiness queue. They use the existing semantic quotation binder to publish a compile-only `Binding::Code` backed by `CodeRegistry`, retaining the original defining file and quotation body. Quoted names such as `Context_Base` remain unresolved until activation or insertion. Code is never coerced into a runtime constant; ordinary deferred `#run` constants keep their existing VM evaluation path.

`load_with_bootstrap_options` can load Runtime_Support into a separate automatic module with `RuntimeSupportOptions`. `RuntimeSupportParameters` requires all three booleans and deliberately has no default. The graph passes those named typed values to the ordinary module parameter binder. Runtime exports are available through the automatic fallback after Preload exports, without becoming application or imported-module exports. Private Runtime_Support bindings remain private. Checking Runtime_Support itself uses the root module without duplicating its source declarations.

Activating Runtime_Support requires `FIRST_ADD_CONTEXT` from the designated Preload exports. An equally named application quotation cannot supply that contract. Missing bootstrap context metadata produces a diagnostic in Preload instead of silently publishing a context without its required base. Preload-only source checks leave quotations unactivated.

When checking Preload itself with runtime bootstrap enabled, the loader publishes that root Preload scope before expanding Runtime_Support. This lets runtime dependency selection read actual Preload constants while retaining one source parse and one declaration instance.

An explicit Runtime_Support import with the identical ordered named argument request reuses the automatic instance. Reordering that request creates a distinct instance, following the supplied `380_module_parameters` tutorial's request-based deduplication contract. Each instance owns its declarations, while immutable source text and parsed syntax remain shared.

## How to change it

Extend `PreludeSource` for source selection, preserving ordered roots and canonical provider paths. `bootstrap-policy` exercises source selection, and `preload-graph` covers shared identities, local shadowing, privacy, namespaces and canonical source deduplication. Module graph changes must keep fallback separate from namespace exports and preserve ordinary parameterized module-instance keys.

The source schema tests prove canonical provenance, reject application lookalikes and exercise the independently authored prelude's declaration protocol. Its complete composed source passes parsing, module graph loading and semantic library resolution with an explicit Linux/X64 target. A separate physical-entry graph checks that all fragments share one module and export the same public names. The semantic fixture binds the actual compiler and intrinsic declarations using the adopted source schema. Code-value tests also check delayed quoted declarations and alias insertion under local shadowing.

These results do not establish full Runtime_Support acceptance or native standard-library execution. Full runtime compilation additionally requires deferred context activation and complete Runtime_Support source syntax, dependencies and initialization. These are compiler prerequisites, not grounds for deleting statements or replacing the standard library with a synthetic one.

## Configuration

`load_with_bootstrap` takes ordinary `GraphOptions`, a `PreludeSource`, the same `SourceProvider`, and optional explicit `BuildTarget` facts. `PreludeSource::default()` requires search. Existing low-level `load`, `load_with_provider` and `load_with_target` remain explicitly bootstrap-free for standalone consumers. The bootstrap API introduces no environment variables; driver/CLI defaults and scheduler replay must preserve configured actual standard-library roots and the selected bootstrap mode.

`CompilationUnit::load_with_bootstrap` accepts `BootstrapOptions` with optional target facts. `WorkspaceScheduler::new_with_bootstrap` preserves that policy while rebuilding all workspaces through the same source overlay and physical-source snapshots. Existing scheduler construction stays explicitly disabled for isolated consumers. Before each graph rebuild, the scheduler derives the runtime parameters from that workspace's committed `BuildSettings`, including settings changed by compiler procedures.

`BuildSettings::runtime_support_parameters` maps `Auto` to initialization plus an entry point only for executable output. Explicit modes select entry point and initialization, initialization alone, or neither. Crash backtraces require both the entry point and `BacktraceOnCrash::On`. The defaults come from the source compiler build options: executable output, automatic runtime support and backtraces on. This mapping changes parameter values for configured Runtime_Support source; it does not enable source loading when bootstrap is disabled.

## Dependencies

Rust's standard library and the existing `jai-modules::SourceProvider` interface. Scope and runtime contracts are grounded in `reference/how_to/151_file_and_global_scopes`, `reference/modules/Preload.jai`, `reference/modules/Runtime_Support.jai` and the compiler module's automatic-module import metadata. Original compiler, linker and native library bytes are not executed or loaded.
