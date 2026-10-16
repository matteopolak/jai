# Declaration-bound callable metadata

Approved baseline: integrated 8fa08957. The previous worktree remains preserved; its unreviewed live overload-alias refresh is excluded.

Three original reductions fail before implementation: same-shaped field headers overwrite defaults/names, another header's private label is accepted, and named arguments without defaults are passed in the wrong order. Procedure TypeId is structural and must remain so.

The repair separates the structural signature from its lexical declaration. Parameter metadata belongs to source entities, concrete procedure signatures and resolved field identities. Lowering preserves that metadata on callable places/values and inferred local aliases. Explicitly declared callback types select their own header, regardless of the assigned procedure. Defaults retain their declaration's evaluation scope. Shared member resolution must carry the selected field identity through filtered/promoted paths; offsets alone are insufficient for overlays. No runtime loads or re-execution of initializer expressions are used to discover metadata.

Validation covers equal structural types, independent defaults, named arguments without defaults, inferred aliases, procedure parameters/macros, filtered using paths, context fields, declaration privacy, duplicate arguments, invalid names, C ellipses and compile-time/native/WASI execution. The C ellipsis regression is a source check of an unavailable foreign declaration; it is not claimed as native execution.

Checked callable operands now carry their own header annotation. Multi-value calls retain individual operands rather than reducing them to type/register pairs; declared factory result headers therefore survive direct and indirect calls, tuple declarations, macro results and constant thunks. This information never enters runtime storage or the procedure ABI. Canonical structural TypeIds, function addresses and overlay storage identity remain unchanged.

The compiler API for the LSP owner is `Compiler::callable_entity_parameters(EntityId)` for a selected declaration/local and `Compiler::callable_member_parameters(TypeId, Sym, Span)` for a selected field. Both return `Option<Rc<ProcTypeParams>>`, with parameter names, default expressions, lexical scope and result headers. Member lookup uses the ordinary filtered/promoted resolver and its terminal struct/field index, including member aliases. These accessors do not consult any TypeId-to-header fallback. The LSP must perform its normal visible declaration/member selection first. This batch does not change LSP completion behavior or claim indirect completion is implemented there.

When provenance is absent, named arguments produce a diagnostic rather than borrowing names from another equal type; positional arity/type validation remains in force. Fully computed procedure-type values and generic type bindings that retain only a structural TypeId do not yet retain arbitrary lexical header provenance. Calls through pointer/array element types without a selected declaration header also require further work; no arbitrary header is synthesized. The precise public contract for defaults/names after such erasure remains recorded in the compiler questions.

No stdlib API, library spelling or module-specific behavior changes are included. The unreviewed alias-refresh checkpoint is preserved only in the prior worktree and is not an ancestor of this batch.

Verification: 16 focused core regressions, 769 core/backend/LSP/jailint checks,
20 CLI regressions with actual interpreter/native ARM64 O0/O2/WASI execution,
host/WASM strict lint, rustfmt and all-target warnings-denied clippy passed.
The pre-existing ignored corpus sweep is excluded; the broad 400-case replay
remains deferred until owner handoffs combine. The full-suite count excludes
nested subprocess unit-test output. A resolved procedure alias is forced inside
the explicit string-returning insertion generator before adding another
overload; both its retained-header positive and bool-to-s64 rejection pass.
No ordering assumption about unrelated final `#assert` items is used.

A fresh unchanged Focus source check against this baseline still stops at its
reported jaic 0.17.0 versus 0.2.29 version guard, rather than the old working
directory lookup diagnostic. No version spoof or application modification is
included. TOML canonical table-member ordering remains foundations-owned.
