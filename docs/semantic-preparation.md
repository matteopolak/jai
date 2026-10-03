# Retained semantic preparation

## What it is

`PreparedLibrarySession` owns the mutable semantic arenas and source worklist for one immutable source graph. It separates header preparation, body readiness, and final library publication so a suspended source job can keep its actual registry and declaration identities.

## How it works

`modules/prepared_session.rs` first reserves nominal and source procedure identities, then retains the alias, annotation, and scalar cursor until its actual prerequisites complete. It prepares context and type-only procedure signatures in the same arenas. The phase keeps the resulting `TypeRegistry`, `PlaceRegistry`, declaration maps and generic context, reflection metadata, alignment jobs, and program prototypes together.

Preparation reserves the authentic concrete file-procedure identities in checked header dependency order before resolving aliases. Templates, expansion macros, and callable aliases reserve no file ID. The shared auxiliary allocator starts above this prefix once; later header completion uses the original declaration-to-procedure map rather than the number of signatures already published. This lets an early prerequisite reserve an auxiliary identity without colliding with a source header whose types are still unavailable. Reserving an ID publishes no callable signature, body, or execution capability.

If record fields need checked default execution, the phase retains their exact pending `FieldId` set and the original constant evaluator before initializing globals or completing procedure defaults. `BindingMode::Headers` follows typed field, procedure, and constant dependencies, checking only prerequisite bodies. It retains unrelated bodies, file runs, guards, discovery choices, and alignment jobs for the full phase. `HeadersReady` preserves the same checked bodies and VM cache. The phase queues original global initializer jobs with actual declaration, file, global, expected-type, and execution-owner identities. Only a checked initializer publishes its storage binding. `InitializersReady` completes parameter defaults and refreshes the same worklist before full binding. A pending default is never published as a zero value or a placeholder global.

For example, `Record::struct { seed::()->int { return 42; } value:int=#run seed(); }` can supply both `global:Record;` and an ordinary `read::(value:Record=Record.{})` parameter default. The authored source tests exercise both consumers and the synchronous resolver. Defaults that themselves depend on unpublished global storage still require an explicit global-readiness job; the header workset does not invent that storage.

Typed sequence constants can also supply a prerequisite body. Preparation marks an unbound sequence or annotated constant by its actual declaration ID; the header worklist evaluates it only when a checked field recipe reports that dependency. The full phase skips constants already published by this worklist or the ordinary sequence-binding tail. The seven `prepared_headers` tests verify this path, suspended field resumption, cancellation before global publication, parameter defaults, and ordering of unrelated body and root effects.

Insertion discovery retains the original declaration request and reserves its execution owner through the same auxiliary allocator. A produced Code value must obtain admission against the immutable graph frontier before its VM effects commit. The session returns the first admitted decision and retires its semantic arenas before the graph owner publishes the sealed payload and starts another phase.

The phase borrows its caller's retained `ModuleGraph`. Source and declaration IDs refer to that exact snapshot, and nominal source fields continue to borrow its parser-owned AST. A binding attempt creates a temporary `BindSession` view over the owned arenas; it does not reconstruct a registry from another graph or clone the original source AST.

Finalization consumes the phase only after body binding completes. It freezes types and places, validates program construction, and publishes source warnings and debug metadata from the authentic retained sources. Both the initial debug-source seed and the final full declaration extents are preserved.

An explicitly requested [source-run prefix](source-run-prefix.md) stops after each completed original root run before unrelated bodies are checked. The workspace owner inspects its actual source/configuration delta at that checkpoint, retires the old arena before rebuilding, and otherwise continues the same queue. Prefix completion does not publish a library.

`drive` borrows an effects handler temporarily and returns `LibraryReadiness::Complete`, `Pending`, or `Failed`. Pending keeps the phase and its actual `Worklist`; complete consumes the phase and yields the library once. A terminal session cannot publish another library. `cancel` retires retained VM tokens through their exact source origins without starting another run.

`LibraryPending` carries explicit VM dependencies, their defining diagnostic, and a separate optional `SourcePreparationPending`. A source marker wait can have no VM dependencies; its original demand and reservation identity remain in the source cause. It describes a live continuation, distinct from a terminal semantic error. The source VM policy must produce an actual continuation before a run can use this boundary; a retry diagnostic alone is not a retained VM job.

Compile-time cache reuse also retains a bounded proof of the actual procedure bodies queried by that execution. Generic and local callback revisions can invalidate a same-ID body after stronger source contracts are discovered. A cached recipe that never called that body remains independent; a recipe that did call it must wait for the checked replacement or report the original defining-source failure. Terminal queried-body failures are checked before the unchanged-revision fast path and before publishing execution results, so they cannot become an artificial dependency cycle. The integrated source tests cover both independent cached work and a genuinely queried failed body with one begin, request, and commit each.

The [callback integration checkpoint](../artifacts/integration-callback-checkpoint.json) records the final workspace compile, 32 source-run/readiness tests, local body invariants, per-call policy checks, explicit O0/O2 native parity, and IR ownership/identity proofs. It is scoped to the recorded compiler snapshot before the subsequent polymorphism repair; it does not certify held initial-type or source-schema features.

The driver `PreparedWorkspaceJob` owns an `Arc<CompilationUnit>` and private compiler/replay journals. An owned async future keeps the session's graph borrow alive across `poll_fn` suspension. Rust pins the future and manages its internal borrows; the controller uses no unsafe lifetime conversion or asynchronous runtime. It polls only when the scheduler supplies readiness. Dropping or cancelling a pending job first cancels its source session, then releases its private journals and source snapshot.

## How to change it

Change `prepared_session.rs` when adding header-owned state or a final library property. Keep the ordinary library resolver and semantic discovery consumers on this shared preparation path, including parameter requests that finish before body binding. Extend the source worklist in `modules/compile_time.rs` when adding readiness jobs.

Keep the compilation unit alive until its phase finishes or is explicitly cancelled. Resume against the same immutable graph and mutable registry; rebuilding a graph while retaining pointers or type IDs from the old phase is invalid. Direct callers of `PreparedLibrarySession` must call `cancel` while their effects owner is still available. The owned driver controller provides that cancellation guard automatically.

Extend `workspace_job.rs` when adding owned journal capabilities or readiness service. Successful job completion returns the actual checked library with its retained unit and private journals; the enclosing workspace transaction decides when to publish them. `graph_job.rs` supplies the preceding owned discovery boundary, keeping the provider and graph in its pinned future until canonical source decisions are ready. The root scheduler transfers the private journals directly from discovery to body preparation.

Extend the retained phase stage and `drive_bindings` together when introducing another pre-global readiness stage. Keep the original recipes and canonical IDs, and refresh queued concrete signatures after their real parameter defaults finish. Header prerequisites must come from typed dependency channels: binding all ordinary bodies early can execute unrelated nested runs before globals exist.

## Configuration

The phase owns a snapshot of `ResolveOptions`, including the selected target, compile-time limits, and explicit compiler/file binding policy. A different target or source snapshot requires a new phase.

## Dependencies

`jai-modules` provides the immutable source graph, `jai-types` and `jai-ir` provide semantic arenas, and `jai-vm` provides typed readiness dependencies and owned VM continuations. The source compiler session supplies transactional effects; preparation executes no supplied native compiler or library.
