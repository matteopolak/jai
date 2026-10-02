# Compiler API coverage and extension boundaries

This inventory separates working source Compiler contracts from the remaining source signatures and scheduler capabilities. A checked internal descriptor or effect request does not, by itself, make the corresponding Jai source API available.

## Current contracts

The [source compiler catalog](source-compiler-intrinsics.md) supports workspace creation, destruction, status recovery, current workspace identity and workspace names; [implementation version](compiler-version.md); source/file additions; located reports; the supported build-options projection; Runtime_Support console output and compile-time trapping; and [phase/completion message adapters](compiler-message-interception.md). Each contract requires a checked declaration, selected module origin, and a typed VM adapter. Reduced independently authored fixtures exercise these contracts; they do not establish acceptance of the entire unchanged Compiler module.

The static source ABI is in `reference/modules/Compiler/Compiler.jai`, principally lines 1485–1653 and 1880–1886. Preload defines `get_current_workspace`, while Runtime_Support defines the output and debug-break bindings. Corpus requirements and pinned source identities are recorded in [project requirements](project-requirements.md).

## Remaining contract groups

| Group | Source APIs or fields | Required implementation boundary |
| --- | --- | --- |
| Captured source scopes | Non-null Code in `add_build_string`; `add_build_string_scoped_by_message` | Checked scope identity tied to its owning workspace, stable file/module/procedure provenance, and insertion into that actual scope before declaration/type scheduling. |
| Interception exports | AST and performance events requested by `compiler_begin_intercept` | Phase/completion source schemas and VM snapshots are implemented; AST/performance payloads still need checked exports and real producers. See [message interception](compiler-message-interception.md). |
| Semantic AST export | `compiler_get_nodes`, `compiler_get_code`, `get_root_type` | Immutable checked AST views, genuine Code capture/inference status, and source-only argument/result descriptors that never enter runtime storage. |
| Procedure edits and liveness | `compiler_modify_procedure`, `compiler_make_procedure_live` | Checked node ownership, transactional replacement/revalidation, and native reachability updates. |
| Import decisions | `remap_import`, `provide_import` | Workspace-specific graph-discovery remapping and typed failed-import event identity, including file/directory/text replacement modes. |
| Diagnostic requests | Unresolved-identifier and untyped-declaration-note reports | Actual retained pending declaration diagnostics with the requested file/note selection. |
| Runtime reflection | `get_type`, `get_runtime_info`, `compiler_get_struct_location`, `compiler_set_type_info_flags` | Selected source schemas, workspace-owned descriptors and source locations, plus actual runtime table emission/policy. |
| Compiler identity and invocation | `compiler_get_base_path`, `get_toplevel_command_line` | Configured module installation base and preserved invocation arguments; no invented reference compiler values. |
| Native data/link configuration | Data-segment APIs, library search directories, custom-link completion | Typed segment ownership and actual backend/link job state. Completion cannot be reported before the corresponding job finishes. |
| Developer instrumentation | Memory-breakpoint and developer-debug hooks | A real supported instrumentation service or an explicit failure; successful empty responses are insufficient. |

### Code and scope bridge

The implemented four-argument `add_build_string` retains its source signature separately from its three-argument runtime ABI. Null Code is consumed semantically and denotes root scope. A non-null capture currently fails before source staging.

Extending this requires carrying the checked scope as call metadata and validating the target workspace at execution, rather than turning Code into a pointer or ordinary integer. File/module insertion must preserve the selected module instance and privacy; procedure insertion must preserve lexical bindings and recheck the affected body. Arena `TypeId`, `ProcedureId`, and file-instance indices cannot identify scopes across graph rebuilds. The source’s message-scoped overload additionally requires genuine FILE/IMPORT message provenance; an arbitrary pointer cannot authorize insertion.

Compiler procedures that consume or return Code also need a source callable descriptor. `TypeRegistry::procedure` and checked runtime prototypes intentionally reject Code storage. Generalizing the existing Code-slot bridge must preserve that invariant, including overload selection and source-only results.

The [runtime-info boundary](compiler-runtime-info.md) now includes the exact source
schema/catalog adapter and a VM reader for opaque, workspace-owned certified
snapshots. Its tests read actual immutable descriptor storage and retain genuine
pending/unavailable states. Source-visible catalog construction and provider
snapshot publication are still required for source `#run` execution; native
`#elsewhere` data binding and table/segment emission remain separate work.

### Interception and transaction readiness

Interception events must come from actual file/import discovery, semantic readiness, and completed jobs. Diagnostic `CompilerMessage` entries are not the source `Message` AST/event schema. A typed event queue needs stable ownership and must reconstruct source records against the receiving VM’s actual type registry and layout; cached raw pointers cannot cross graph rebuilds.

An empty message queue is a Pending effect, with the issued request's exact identity. Source adapters now reconstruct owned phase/completion events as fresh immutable source records. A metaprogram that creates a child and then waits still depends on the host continuation and staged-job preview protocol preserving that transaction while advancing genuine child work. Verify this host progress separately from source-schema and VM-memory tests. No implementation should fabricate COMPLETE events to bypass the dependency or report native completion from typechecking alone.

### Complete Build_Options

The current projection preserves output kind/path, runtime support mode, backtrace policy, target triple, and every LLVM optimization level, including nested `Commonly_Propagated` fields. Other fields reject rather than becoming silently applied defaults.

The remaining source schema spans several consumers:

- Graph/input behavior: import paths, platform/backend selection, added-string output, and source/runtime command-line data.
- Output and linking: executable name and extension policy, intermediate path, entry point, linker arguments, custom-link mode, and data segments.
- VM and semantic policy: temporary/context sizes, bounds/cast/null/overflow policies, recursion limits, bytecode inlining/debugging, and runtime storageless reflection.
- Native generation: redzone/frame-pointer policy, debug information, machine options, LLVM CPU/features, pass toggles, and auxiliary IR/bitcode output.
- Messages and user metadata: formatting/info/text flags, user data fields, and platform-specific debugger settings.

`Build_Options_During_Compile` is a separate source schema with ordered update semantics, including append-only linker arguments and `do_output=false`. It cannot be treated as an alias of the existing projection. To expose the full records, get/set round trips must retain actual settings and source nominal identities for every supported field, and each consumer must apply its setting or reject it explicitly.

## How to change it

Add one complete contract at a time across the semantic catalog, VM adapter, typed request/response, host transaction, replay accounting, scheduler/backend consumer, and independently authored source tests. Prefer real readiness and ownership proofs over string-dispatched callbacks or accepted-but-unused fields. Update this inventory and the corresponding feature document when a boundary becomes usable.

## Configuration

Configured module roots and bootstrap selections establish source module identities. Explicit target layout and byte order govern source record materialization. VM fuel/allocation bounds and scheduler/replay bounds apply to all new contracts. No configuration authorizes execution of supplied native tools, libraries, or objects.

## Dependencies

The contracts span `jai-syntax`, `jai-modules`, semantic source/call binding, Code/reflection metadata, verified IR, VM execution and memory, compiler sessions, replay, workspace scheduling, and native artifact planning. The inventory relies on static source evidence only and adds no external dependency.
