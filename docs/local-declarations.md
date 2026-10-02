# Local declarations

## What it is

Procedure and block scopes can declare records, enums, type aliases, constants, and nested procedures. These declarations retain nominal identity independently of the module graph's declarations, including when a generic body or compile-time dependency is retried.

## How it works

`jai-sema/src/local_declarations.rs` collects the current block's declarations before resolving annotations and declarative values. Each declaration has a `LocalDeclarationId` containing a concrete procedure or record owner, a `LexicalScopeId`, and its original source span. Records reserve their `TypeId` before their fields resolve, allowing recursive pointers and forward type references. Anonymous records and enums use that same source identity and retain lexical constants.

Pending declarations resolve in their defining block. Resolution temporarily removes inner frames so a later inner shadow cannot change an outer declaration's type, constant, or default. Scalar constants resolve on demand through the same lexical lookup. Semantic constants, including captured code and type queries, retain their declaration-site environment and can be requested by a forward dependency.

A `using` declaration wrapper registers its original child at the existing source ordinal, retaining the child's span and nominal identity. Promotion becomes part of the lexical prefix only after that child registers; a runtime child initializer executes once before promoted places are bound.

The shared `MetaContext` caches owned local record fields, enum members, field defaults, signatures, and completed procedure bodies. Aggregate construction, member projection, default initialization, and reflection consult this metadata before file-level metadata. Inferred field types use checked source type facts before initializer evaluation, allowing a field's `#run` call to wait for its own record's seed method body. Pure call and namespace previews read registered signatures and typed members without binding a procedure body to discover its result type. Explicit field defaults publish only after evaluation succeeds; a cyclic initializer query produces a diagnostic. Container and procedure type annotations recursively use the lexical overlay.

Record bodies can also declare constants, type aliases, nested records, enums, procedures, and foreign or intrinsic prototypes. Their names resolve through an owned record namespace such as `Outer.Inner`, `Outer.LIMIT`, or `Outer.read`. Method headers progress through `TypesOnly`, `CompleteHeaders`, and `Bodies`. Type reservation describes inferred types without executing defaults; completion materializes the original defaults with the same procedure identity and checks that the canonical procedure type is unchanged. Calls use completed metadata, including through procedure aliases. Empty `#Context` literals obtain fields from the registered schema initializer. The complete field shape is installed before method bodies. A local worklist advances explicit field defaults and method headers/bodies only when real defaults, complete headers, or source bodies become ready, allowing a method default to construct its own record and a field initializer to call a seed method. A method's explicit receiver parameter is passed as a normal argument. Local record `#insert` remains unsupported. Full record descriptors diagnose named namespace member categories until reflection can represent them faithfully.

Completed parameter defaults may retain a checked read of a defining global or the active implicit context. They read current storage only when omitted at a call, and a caller's equal-spelled declaration cannot replace their canonical root. Local runtime storage requires a separate capture policy and is rejected; lexical constants remain constant defaults. All seven local integration groups passed source checking and real VM execution. See [runtime parameter defaults](runtime-parameter-defaults.md) for the recipe and separate broader acceptance checks.

Record `#if` selects original members in the same definition scope before field types and layout resolve. Unconditional and selected declarations support forward dependencies; inactive branches contribute no declarations, fields, defaults, or diagnostics. Fields shadow outer constants when checking guards and cannot be used as compile-time values. Active `#assert` expressions run after the shape, method bodies, and defaults are ready, allowing assertions about the record's own size. Control directives alone do not make field reflection incomplete.

Fields and defaults resolve while the record's definition namespace is active; later caller shadows cannot change their meaning. Static and specialized record methods receive an isolated child resolver with their defining file and substitution. Namespace declarations retain typed local identities and do not occupy the module declaration arena. Marked `#as` fields use the shared directional conversion rules; unions require an active-alternative policy and reject marked conversion fields.

Static and specialized fields that require typed execution retain their original initializer in a job keyed by canonical `FieldId`. The job runs with the record's captured definition environment and the real compile-time provider; retries retain the same field identity and shared execution cache. Header completion and record construction wait for those values, including defaults reached through an exported alias of a private record method.

Header field evaluation can restrict record method work to the actual procedure dependencies of those jobs. All source method types remain registered, while only requested methods complete defaults and bodies. The restriction covers recursive namespace lookups and records any newly needed procedure identity for a later sweep. Partial work does not mark an entire record as checked. Local records declared inside a requested method retain their deferred method sources for the full body sweep, which still checks unused methods.

Record construction assignments such as `base.kind = .READY` apply after explicit field defaults, in selected source order, before a method default can read the record initializer. They resolve canonical field paths, including promoted fields, and update only the owning record's root field default. The embedded base type keeps its own initializer. Default reads wait for the complete construction batch, so a completed method signature cannot retain an earlier field value. A failed dependency publishes no partial override; self-referential initializer queries diagnose cycles. Array, pointer, and union target paths need a separate construction policy and currently produce source diagnostics. See [record conditionals and assertions](record-conditionals.md).

A field initializer of `---` retains its original no-write recipe and does not publish a constant default. The record's shape remains usable, including an explicit whole-record `value: Record = ---` declaration. Selected construction overrides over a no-write field remain ordered source recipes. Requesting an initializer for such a record currently diagnoses unsupported sparse construction at the original `---` span; it neither waits for a value nor supplies a zero.

Explicit arguments to file-defined record templates can use local types, constants, code quotations, and checked queries. The caller overlay is captured only for those arguments. Template annotations, defaults, and body members continue to resolve in the template's definition environment. A lexical declaration that shadows the template name prevents fallback to the same-spelled file template.

Local reflection metadata preserves source note bytes and the record's local/union/layout flags. Compile-time replay origins encode the source path, declaration span, lexical scope, concrete owner's substitution, and each defining module's bound parameter environment rather than process-local type or procedure arena numbers. Registration retains typed file references; the replay encoder validates and serializes their canonical source environments and reports unavailable metadata.

Nested procedures receive a real procedure identity from the allocator shared with specialization. They publish an actual typed body and keep declaration names and defaults for direct calls. Compile-time constants and types remain available through the defining lexical frames. Access to an enclosing procedure's runtime locals produces a capture diagnostic; the compiler does not manufacture an environment or an empty body.

Local generic callback contracts can strengthen without changing the selected procedure's ABI or specialization key. The callback body ledger invalidates only that procedure's checked IR and retains its original identity, signature, defaults, and definition environment. Body lowering takes a token for that procedure's current contract revision; publication rejects a body if the same contract changed during binding. Changes to another procedure do not reject the token. Failed and stale rechecks retain their outstanding procedure identities, and stale debug and storage alignment metadata is cleared with the discarded body. A terminal failed bind also exposes its original diagnostic and defining source by the actual procedure identity, so a cached run can report that failure instead of waiting indefinitely.

The ledger exposes a separate readiness revision for compile-time receipt validation and a sorted list of pending body proofs. A cache-wide revision does not serve as a body publication token or authorize repeated effects. The live integration gate passes all six ledger tests and 25 source-run integration tests, including an independent committed recipe inside a rechecked local body and the located failure of an actually queried body. The 67 procedure-value codegen tests also pass through the rewritten VM and freshly generated native programs; the per-call local callback fixture runs with explicit LLVM O0 and O2. These focused checks do not establish full original-library acceptance.

Header registration separately retains a procedure's original name, defining file, source span, and canonical procedure type. These facts survive `#no_debug` and body retries; an alias refers to its target's identity. An anonymous procedure has no source name, and an inferred lambda publishes its type only after its actual results are known. Reflection can read this immutable metadata before a body or debug sidecar exists.

```jai
main :: () -> int {
    Count :: Later + 1;
    Later :: 2;
    Node :: struct { next: *Node; values: [Count] int; }
    BASE :: 7;
    add :: (value: int = 5) -> int { return value + BASE; }
    node: Node;
    return add();
}
```

## How to change it

Add declaration collection and stable identity handling in `local_declarations.rs`. Put type-expression recursion in `local_declarations/types.rs`, record definitions in `records.rs`, enum definitions in `enums.rs`, record namespace handling in `namespaces.rs`, value materialization in `constants.rs`, aggregate lookup in `metadata.rs`, and nested procedure publication in `procedures.rs`. `record_conditions.rs` selects original record members and checks active assertions; retain their source identities rather than projecting them into synthetic statements. `signatures.rs` separates type reservation from actual default readiness; `methods.rs` checks record-owned procedures. `sources.rs` retains definition environments for contextual lambdas, callback aliases, and source field jobs. Field job readiness and dependency scheduling live in `modules/field_default_jobs.rs`; evaluate original initializers through the retained record environment rather than a caller frame. `default_overrides.rs` applies construction writes through the shared canonical constant projection helper; `applications.rs` captures explicit template arguments. Replay identities live in `origins.rs`; preserve its source identity and recursively encode the owner's substitution.

`procedure_sources.rs` owns immutable callable definition facts; keep it independent of debug emission and never relabel a target when binding an alias. Definition queries must respect the annotation context that forbids enclosing identities in callable headers. Wrap prerequisite field evaluation in `with_record_method_prerequisites` so the typed demand also applies to nested namespace lookup. Preserve deferred local method environments and run their final body sweep before publishing the complete program. Sparse construction must consume the retained no-write field and override recipes together; never treat a skipped default as an implicit zero.

`callback_body_checks.rs` keeps per-procedure publication revisions distinct from the global readiness revision. Merge checked source contracts before an active or ready specialization can be reused, invalidate only the actual selected body, and lower its original source in the retained environment. Keep a failed recheck pending until a successful publication for the current revision. Compile-time receipt guards must check the actual called-body proof set; an independent cached run cannot wait for the enclosing body merely because another contract changed.

Use the existing checked IR nodes and the common procedure allocator. Never create a module `DeclarationId` for a local declaration, and never allocate a new nominal identity merely because a body is retried. Preserve original AST spans and clone lexical metadata when captured code or an anonymous compile-time body retains a defining scope.

Add source fixtures to `local_declarations/tests.rs`. Tests should inspect nominal identities where identity matters and execute the resulting program through the Rust VM for observable behavior. `jai-codegen/tests/local_declarations.rs` checks the same independently authored source through newly emitted LLVM objects and bounded native execution. Runtime capture, declaration cycles, and currently unsupported local template/modifier forms should produce source diagnostics.

## Configuration

No environment variables enable local declarations. Compile-time evaluation and initializer construction use the existing compile-time limits and constant depth/cell budgets. A method namespace sweep visits at most 65,536 distinct record owners. Type layouts and reflection sizes use the resolver's target layout policy.

Local foreign library declarations retain typed dependency metadata and source-relative paths. Their linker policy is described in the foreign library documentation; resolving a declaration does not open library bytes.

## Dependencies

The subsystem depends on `jai-syntax`'s owned declaration AST, `jai-types`' nominal registry, the semantic constant pool, the module scope adapter, and the specialization allocator. Completed nested bodies use the shared checked IR and the existing Rust VM and LLVM paths. It does not require the original compiler or its native libraries.
