# Required procedure results

`#must` marks a procedure result that callers must consume. The annotation is retained on source result bindings, including foreign and intrinsic prototypes, generic specializations, nested declarations, and callback annotations. An unused declaration remains valid.

```jai
required :: () -> int #must { return 42; }
pair :: () -> (int, int #must) { return 0, 42; }
Callback :: #type () -> int #must;

main :: () -> int {
    _, answer := pair(); // The optional first result may be discarded.
    callback: Callback = required;
    return callback();
}
```

## How it works

Semantic `ResultSignature` and generic `ResultPattern` retain the closed syntax `ResultUsage` enum. A callback binding retains its own ordered result metadata alongside its canonical procedure type. Inferred callback variables and inferred callback parameter defaults copy source metadata. A conditional callback inherits a required result when either branch requires it; equal checked parameter policies retain names and defaults, while incompatible policies need an explicit annotation. Explicit callback variables, parameters, aliases, globals and fields use their declared callback contract. Result names, defaults and usage annotations do not change ABI type identity. Thus an explicitly declared optional callback contract can expose a required source procedure through that optional contract.

External callback storage uses its declared source annotation in the original defining environment. It has no initializer result to discard; a call through that storage follows its checked result contract.

Returned callback contracts form a typed metadata tree: a procedure result can contain a callable, a pointer to one, or an array/slice whose elements contain callables. The registry keys producer results by their actual `ProcedureId`, storage by `Place`, and record fields by `FieldId`. Direct and indirect factories, multiple-result capture, context override helpers and call hints preserve those trees. Array indexing, slice views, pointer dereferencing and source casts propagate an established contract only when its canonical value type agrees. A source cast uses the target annotation, so an explicit optional cast follows that optional contract.

Alias expansion retains a tree of original callback annotation nodes and their typed producer environments. Each node keeps its defining file, source, lexical procedure owner and checked specialization substitution before nested aliases are cloned. Imported private aliases and local aliases therefore describe the contract even if the caller defines a same-named optional alias. Generic factories use the actual specialized procedure identity and source origin. Canonical procedure type equality alone never invents an obligation. Inferred callback defaults use checked constant values; collecting contract metadata does not execute defaults again.

Generic source variables forward contracts from checked arguments, including callback containers and baked `Type` arguments. Returned contracts remain specific to the call even when required and optional aliases share one canonical specialization. An inferred generic callback parameter retains a contract keyed by the actual procedure and source parameter identity. If another call strengthens that contract, the existing specialized body must be checked again before it can execute. Contracts combine required results across call sites. Equal checked parameter policies preserve names and defaults across different source procedures; differing labels or defaults are removed, so an explicit callback annotation is needed when the body depends on that information.

An omitted ordinary generic callback default can retain an authoritative cast such as `callback:$F=cast(Required)answer`. The runtime constant has erased that source annotation, so the contract adapter expands the original cast target in the defining file and actual specialization before capturing `F`. It reads the already checked default value and does not evaluate the default again. A caller's same-named optional alias cannot replace that retained definition contract.

The specialization worklist keeps the same `ProcedureId` when rechecking. A contract change during body binding also schedules another proof, and a failed recheck cannot validate an earlier ready body. Source `#run` receipts wait for pending callback proofs and reuse their committed values after successful validation; collecting or checking these contracts does not replay completed effects.

Graph and local specializations use the shared source binding merge. Local generic operators register selected argument contracts before consulting an earlier checked body; a stronger contract invalidates only that actual body's proof, preserving its `ProcedureId`, signature and specialization key. Body publication checks a readiness token so recursive strengthening cannot publish a stale proof. The paired local ledger, receipt/provider and selected-call hooks are registered. Their bounded acceptance includes six ledger tests, 54 operator source tests, two independent result-contract source tests, and 32 source-run tests. The independent per-call callback fixture returns 42 in the VM and freshly generated native code with explicit LLVM O0 and O2 targets. Cached results validate only the actual procedure bodies read by their committed VM transaction, so an independent completed `#run` inside a rechecked body can be reused without waiting on that enclosing body. A failed queried body retains the original located diagnostic without replaying committed effects.

Local operator calls derive returned contracts from that call's original operands and checked destination IDs. This preserves source casts and symmetric operand binding independently of the cached body's combined proof. A nested operator expression passed directly into another specialization currently needs an available checked source result contract; otherwise it reports a located preview diagnostic before body reservation or argument effects. Assigning the operator result to inferred storage first retains its checked per-call contract.

Graph operators retain their selected original source arguments through ordinary binding and derive the returned callback contract from the actual call and substitution. A private selected-call producer validates the checked call's single result type and stores that per-call proof under a genuine expression binding ID. Its `Bind`/`Bound` capture executes the actual call once. This preserves required and optional casts for ordinary callback operands, fully baked callbacks without runtime slots, and symmetric operand destinations. Operator expression statements and `_` destinations follow transparent captures to check the operator call's own required result usage.

Fully baked callback formals need source policy even though they have no runtime parameter slot. Their registered metadata adapter correlates the original formal with the actual specialization's checked constant, retains the argument's source annotation, and binds the original callee annotation in its defining environment. Inferred baked formals retain their checked supplied-argument contract separately from generic type-variable bindings. A baked procedure identity does not establish result usage. The paired invocation/constant-fact repair and its new source/native fixtures are awaiting acceptance. Inferred omitted defaults without a checked source contract report a located diagnostic; their contract cannot be reconstructed from the procedure target or evaluated in the caller.

Per-use generic-record contracts retain their obligations independently of the canonical record type. A field declared only as `callback: T` cannot obtain its obligation from the record specialization key: that key retains the canonical `TypeId`, which cannot distinguish required and optional source aliases with the same ABI.

The record sidecar retains source type-argument contracts and the defining file on each binding. A field projection uses its actual `FieldId` and original field syntax to derive that use's contract. Field contracts are resolved lazily, so recursive callback pointers do not require an infinite metadata tree. A visited traversal of the canonical type graph skips records that contain no callable fields; that traversal determines shape only and never infers result usage. The 24-test source obligation suite and 63-test procedure-value VM/native suite pass after these producer-provenance changes. The execution fixtures include equal nominal required/optional record applications, recursive callback pointers, imported private aliases, factories, casts, erased source arguments, and promoted captured callback factories that run once. These are bounded acceptance fixtures, not full original-corpus parity.

Expression statements bind direct, indirect and context calls before generating their discard destinations. Any required result produces a diagnostic at the call expression. Multi-result declarations and assignments flatten calls in source order and check each result against its actual destination; `_` cannot consume a required result. Temporary storage introduced to preserve evaluation order does not count as user consumption. Optional multi-result calls may be discarded, and their effects still execute.

Passing a result as an argument, returning it, assigning it to named storage, or using it in an expression consumes it. This contract does not require subsequent reads of an assigned variable.

Captured expression producers retain their contract under a genuine `ExpressionBindingId` with a procedure owner and allocation ordinal. `Bind` introduces producers in order; `Bound` refers to the captured value. Contract traversal restores temporary lexical bindings after success or failure. Aggregate grouping retains contracts along actual physical `FieldId` paths, including promoted anonymous fields, while checked field annotations remain authoritative. These private maps do not add annotations to canonical types.

Discarded baked arguments still participate in specialization identity. Their source names are shadowed by unreadable bindings in the body, including type annotations, aliases and nested declarations. Contract propagation can use their checked argument metadata without making the discarded argument body-readable.

Checked address and dereference transports can retain an existing value contract directly under a new actual expression-binding identity. They use the same producer owner, canonical type and duplicate-identity checks as source captures. Captures with original callee syntax still use that syntax to preserve authoritative binding annotations.

## How to change it

Keep source contracts in semantic binding metadata, rather than adding usage annotations to `jai-types::ProcedureType`. [Callback source policies](callback-source-policies.md) documents the checked annotation proof and executable policy identities. Propagate result usage when adding new declaration or specialization paths. `crates/jai-sema/src/result_obligations.rs` checks result consumption and expression-statement calls; `results.rs` maps flattened results to destinations. Callback propagation lives in `procedure_values/bindings.rs` and `procedure_values/contracts.rs`, with canonical result types checked by `procedure_values.rs`. Definition-file lookup lives in `modules/callback_bindings.rs`; local procedure/field headers register contracts while their definition aliases are available.

`procedure_values/contracts/generics.rs` correlates original source argument syntax with already checked runtime arguments. Preserve that pairing when changing baked or named argument binding. `polymorphism/worklist.rs` tracks readiness revisions and pending recheck identities; the source scheduler and compile-time providers must honor those revisions before advertising an older body or receipt as ready.

Keep omitted default cast expansion in that original header's file and substitution. Other checked defaults continue to use their established runtime value metadata; do not guess a source policy from canonical callback type equality or resolve the default's annotation in the caller.

The selected operator result producer is a private child of `contracts/expression_bindings.rs`; its owner, signature, and canonical result type checks share the existing expression capture publication path. Extend source argument transport before permitting discarded operator operands. The existing operator boundary rejects those formals rather than pretending that source and runtime positions coincide.

`procedure_values/contracts/syntax.rs` carries original annotation provenance through alias expansion, callback results and container elements. Preserve this tree when introducing source syntax transformations; discarded callback formal types require the original checked annotation proof and cannot be recovered from the ABI or looked up in the caller scope.

`procedure_values/contracts/records.rs` retains per-use record arguments and resolves field projections through immutable checked record descriptors. Keep this metadata separate from `RecordSpecializationKey` and canonical `TypeId`; required and optional callback aliases may intentionally produce the same nominal specialization.

When adding a new call syntax, route discard statements and result binding through the same helpers. Keep the source call span for diagnostics. The semantic integration tests cover unused declarations, direct/generic/local calls, callback contracts, imported procedure aliases and defaults, `_` destinations, and canonical signature equality. Codegen procedure-value tests verify required results and optional multi-result discard effects through the VM and freshly generated native programs.

## Configuration

There are no flags or environment variables. Add `#must` after the result type, including individual results in a result list or callback type. Parameter annotations and repeated `#must` annotations are rejected by the parser.

## Dependencies

The feature uses the syntax AST, semantic source signatures and callback registry, and ordinary IR call-result destinations. It introduces no external service or library dependency and no VM or native ABI change.
