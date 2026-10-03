# Source declaration phases

## What it is

Module resolution separates callable type registration from default-value materialization. Record fields and immutable aggregate defaults can refer to real procedure identities before their bodies are lowered.

## How it works

`modules/procedure_headers.rs` registers concrete parameter and result types in its `TypesOnly` phase before record definition. The source inventory reserves one `ProcedureId` per concrete declaration before alias preparation. A selected header publishes the corresponding procedure type and constant identity in `Nominals` only after its annotation prerequisites are ready. A callable alias contributes a value only when it identifies one concrete procedure; overload sets require contextual selection.

Headers with inferred defaults depend on the procedure declarations supplying those defaults. An AST dependency scan resolves imported names and callable aliases to their canonical declarations, then orders header registration so those signature facts are available first. This supports `apply :: (callback := Callbacks.answer)` even when the imported procedure appears later in the graph. Cyclic inferred signatures produce a source-located diagnostic rather than a placeholder type. Explicit default annotations supply their own type and defer value evaluation to the complete phase.

`modules/record_method_headers.rs` binds actual record-member signatures from reserved definition environments before record shapes consume method defaults. Record-qualified aliases are deferred from scalar evaluation and then published with their checked procedure signatures. This phase uses the shared procedure allocator, seeded once after module header reservation; subsequent method, lambda and specialization identities must never be overwritten by resetting that allocator.

Record definition and default construction consume these source facts. The later `Complete` phase reuses the reserved IDs and evaluates defaults after retained global initializer jobs publish actual storage, using the resulting field metadata. Compile-only Code defaults retain their separate semantic representation; they do not acquire runtime storage. Caller-location defaults retain their deferred marker and receive layout validation after nominal definitions exist.

The actual context schema is constructed before ordinary record default materialization and global initializers. Context construction can resolve ordinary record defaults from their established source schemas. Context defaults use canonical record metadata, source field origins and actual field values; reserving a context type without its schema is insufficient to initialize `#Context` storage. Cyclic value defaults require a located failure rather than an invented zero value.

The optional source-run prefix follows genuine typed prerequisites and stops at each completed original run. This lets the graph owner rebuild after actual source-generation effects before a later run or unrelated body needs those declarations. An independently complete empty source Context may be published before an unrelated type wait; source context additions are never omitted.

These facts establish signature identity, not body readiness. Checked IR publication still verifies procedure references against the final environment, and the VM cannot execute an unavailable body. Quoted Code and contextual short-lambda bodies retain their deferred capture and do not add header dependencies from names inside the body.

An unannotated module short lambda, and a chain of pure constant aliases to it, retain their defining source declaration until a caller provides parameter types or an expected callback signature. The scalar constant pass defers these declarations; the readiness evaluator excludes only these contextual sources from eager evaluation. Calls, typed casts, aggregate initializers, and `#run` recipes that depend on them remain readiness jobs and materialize through the checked lambda producer in the original file scope.

A retained no-progress failure includes its actual binding phase and typed source demand, selected constant and field readiness, queued record modifiers, selected layout and isolated VM wait status. When the partial type phase has no escaping VM/body error, the failure keeps the original demand's `SourceSpan` instead of using an unrelated retained procedure as its location. This diagnostic does not publish any missing fact or reinterpret a hard error as pending.

An actual selected constant prerequisite enters the retained checked worklist even when its original expression has no explicit `#run`. The worklist reserves one real shared owner and keeps the same cache while its required bodies become ready. A reached `size_of` can complete an independently declared nested record through its original reserved parent/member path, source scope and conditional selection. It does not require the outer field layout first. For example, `N :: 4096 - size_of(Builder.Buffer)` can size an independent `Buffer` before defining the outer `bytes: [N]u8` field. If the nested record instead reads `N` in its own array count, or contains its unfinished outer record by value, that genuine cycle still fails.

The nested-layout change passed the registered workspace build and 23 source regressions: four nested-layout cases, one dependency cycle, and eighteen existing type, prefix, default and namespace cases. The same frozen authored Basic inputs advance past the previous dependency stall but still fail imported nested namespace lookup in `String_Builder`; this is not yet a complete Basic compatibility result.

## How to change it

Keep header registration in `modules/procedure_headers.rs` and phase ordering in `modules/prepared_session.rs`. Extend `procedure_signatures.rs` for default type inference and aggregate `Defaults` for actual value construction. Reuse existing procedure IDs when completing headers; allocating new IDs would invalidate callback constants and compiler metadata.

Extend selected constant admission in `modules/compile_time/worklist.rs` and source layout completion in `modules/aggregates/parameterized/source_layouts.rs`. Reuse the existing nested materializer and canonical reservations; do not derive a layout from a printed namespace or complete an unrelated outer record to satisfy a child query. `size_of` still requires the selected target/layout in `ResolveOptions`.

Extend `procedure_headers/dependencies.rs` when adding an inferred expression form. Record dependencies through syntax and canonical graph bindings; do not retry registration by matching diagnostic text. Only expressions needed to infer a type belong in this ordering. A declared literal or cast type already provides a type, so procedure values within it wait until default materialization.

Default presence comes from parameter syntax during early variadic validation. An absent materialized value in `TypesOnly` must not be mistaken for an absent source default. Publish callable constants with their exact ABI type rather than inferring identity from names.

Keep contextual-source classification in `modules/deferred_constants.rs` synchronized with the source lookup in `modules/short_lambdas.rs`. Follow graph declaration identities for aliases and retain the original defining file. Do not exclude arbitrary dependent recipes from the readiness queue: they may supply the context needed to check and publish a lambda body.

## Configuration

There is no user-facing switch. Resolution uses the selected target and layout from `ResolveOptions`; compiler source-signature metadata and nominal specialization share the same semantic context.

## Dependencies

`jai-modules` supplies canonical source declarations. `jai-types` owns procedure and nominal type identities; `jai-ir` owns typed procedure constants. Semantic default evaluation, Code capture, caller locations, specialization, and final checked-IR verification consume these facts.
