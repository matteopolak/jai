# Incremental source discovery

`jai_modules::GraphDiscovery` retains the source graph while semantic execution decides source-dependent `#if` conditions. It preserves canonical paths, parsed source, module instance requests, file scopes, declaration identities, and the original procedure bodies across every advancement.

## How it works

Create a session with `new`, `with_target`, or `with_bootstrap`, then call `advance`. The source worklist resolves scalar conditions and unconditional dependencies to a fixed point. A condition requiring semantic resolution produces a `DeferredCondition` with a stable `ConditionRequestId`, defining file/module, `SourceSpan`, original expression, and defining context. Lexical context includes the owning `DeclarationId` and original outer-to-inner scope inputs, including procedure parameters and runtime name shadows.

`graph()` borrows the current graph for semantic inspection. It does not reconstruct syntax or identities. Partially discovered modules expose `discovered_entry()`; `entry()` remains appropriate for a complete graph. `DiscoveryStatus::Awaiting` separates condition request identities from other unresolved source dependencies using source identity, without interpreting diagnostic text.

The semantic phase evaluates a request in its actual defining context and calls `select_condition(id, bool)`. A later `advance` discovers the selected branch. The inactive branch is never resolved or read. Selecting the same value twice is harmless; replacing an existing decision is rejected. Newly exposed nested conditions receive their own request identities. `into_graph` succeeds after discovery completes and otherwise returns the retained session. The complete `ModuleGraph` retains every selected source condition by defining file and original `SourceSpan`; semantic body resolution can use `selected_condition(file, span)` without replaying completed source `#run` conditions.

```rust,ignore
let mut session = GraphDiscovery::new(entry, options, provider)?;
loop {
    match session.advance()? {
        DiscoveryStatus::Complete => break,
        DiscoveryStatus::Awaiting { conditions, .. } => {
            for id in conditions {
                let request = session.condition(id).unwrap();
                let selected = evaluate_pure_condition(session.graph(), request)?;
                session.select_condition(id, selected)?;
            }
        }
    }
}
let graph = session.into_graph().ok().unwrap();
```

The source layer performs no semantic `#run` execution and invokes no compiler effects. A caller must distinguish unresolved value dependencies from ready condition requests and detect semantic progress. Source-phase effects belong to the driver's transaction/replay pipeline; evaluating a discovery condition must not speculatively commit them.

Repeated lexical imports use the same canonical module identity and preserve export privacy. They publish `ScopedImportEdge` records and never insert their aliases into file or module bindings. Module parameter initialization also resumes in place: already published parameters retain their original `ParameterId` while unresolved defaults retry after selected declarations or loads become available.

A hard discovery error ends advancement. The session retains its source snapshot for diagnostics, and later advancement returns `FailedDiscovery`; it cannot publish an incomplete graph through `into_graph`. Pending semantic conditions remain resumable.

The convenience `ModuleGraph::load*` APIs use the same worklist once and return `GraphError::Pending` when semantic condition selection is required. Use `GraphDiscovery` when the calling compilation phase can provide those selections.

Top-level declaration insertions also retain typed pending requests in the same session. Their staging, cancellation, atomic publication, and captured source environments are described in [Declaration insertion](declaration-insertion.md). Publishing a response appends genuine declaration and expansion scope identities while preserving all earlier graph identities and original parsed sources.

## Actual generic specializations

A generic procedure containing source dependencies is a dormant `SourceDependencyTemplate`. Structural discovery publishes its original declaration and procedure location without inspecting either conditional import branch. After ordinary semantic overload matching creates a real specialization, the scheduler submits `SourceSpecializationKey::new(declaration, procedure_location, ordered_named_arguments)` through `discover_specialization`.

Arguments use canonical `ModuleBoundArgument` values and source `ModuleType` identities; they never contain registry-local type or procedure IDs. `advance` scans the original procedure with that key, retaining lexical frames. Every deferred condition, scoped import, and semantic parameter request distinguishes its optional specialization. `selected_condition_for`, `selected_semantic_condition_for`, and `scoped_import_for` select that exact key; the ordinary accessors select only the un-specialized context. Two instantiations can choose opposite branches or import different parameterized module instances without sharing a source-span decision.

`specialization_discovered` reports a completed source scan, while a pending scan remains queued. `has_dependency_templates` allows a driver to probe actual semantic calls even after structural discovery reports `Complete`. Repeated submission of the same key is harmless. Dormant bodies that no call specializes never resolve or read their inactive dependencies.

The parser's procedure identity span can cover only its header. `SourceDependencyTemplate::extent` retains the bounds of the original AST's header and body separately. That lets a nested specialization preserve ordinary imports outside its original procedure while keeping its own dependency requests distinct. It does not infer declaration identities from body order or rewrite source.

## Using publication

`FileUsingRequest` retains an original using directive, source span, visibility, defining lexical context, and optional specialization. Semantic selection returns canonical graph bindings, exported operator declaration IDs, and mapped destination spellings. `resolve_using` validates source identities and namespace export privacy before interning mapped names and publishing bindings. Lexical place aliases publish names only; semantic body resolution retains their actual mutable places.

Enum and record namespace aliases use `Binding::SourceMember`, anchored to the original owner declaration and member symbol. They create no synthetic declaration AST or registry-local type identity. A failed multi-name publication rolls back file/module bindings and overload memberships. Equal committed decisions are idempotent; changing a committed decision is rejected. `using_publication(file, span, specialization)` exposes canonical names for later body resolution.

## How to change it

Session API and condition identities live in `jai-modules/src/discovery.rs`. Bootstrap planning and advancement live in `loader/session.rs`; parsing and dependency expansion live in `loader.rs`; lexical traversal lives in `scoped_imports.rs`. Lexical record scopes retain their original `record_members` topology alongside statement scopes and parameter inputs. Extend condition context with source-backed scope inputs when adding lexical forms. Keep original source syntax immutable and preserve canonical instance request keys; do not rewrite bodies, infer identities from declaration order, or reparse the graph to resume work.

Add regressions in `jai-modules/tests/discovery.rs` for source identity, repeated advancement, inactive imports, lexical shadows, and parameter initialization. Condition execution needs semantic/VM integration tests in the semantic or driver layer.

## Configuration

`GraphOptions::import_dirs`, `BootstrapOptions`, and an optional `BuildTarget` have the same behavior as complete graph loading. The `SourceProvider` is borrowed for the lifetime of the session and remains the authoritative source of canonical identities and input bytes.

## Dependencies

This layer uses `jai-source` identities/provenance, `jai-syntax` original ASTs, `jai-lexer` decoding, and `jai-eval` for scalar source selection. It does not depend on semantic resolution or the VM; those phases consume typed requests through the driver.
