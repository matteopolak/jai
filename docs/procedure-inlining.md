# Procedure inlining

`inline` and `no_inline` before a source procedure signature preserve an explicit inlining policy through parsing, semantic binding, checked IR and native LLVM lowering. Unmarked source definitions leave the decision to the backend.

```jai
ordinary :: (value: int) -> int { return value; }
forced :: inline (value: int) -> int { return value; }
separate :: no_inline (value: int) -> int { return value; }
answer := inline ordinary(20) + no_inline ordinary(22);
```

## How it works

`jai_types::InlineHint` distinguishes `Automatic`, `Always` and `Never`. The syntax procedure owns this metadata; it is not part of the canonical procedure type or ABI. Semantic binding records it against the actual `ProcedureId`, including nested definitions and selected polymorphic specializations. A record method retains the source procedure and uses the same nested body binder.

`ProgramBuilder::procedure_hints` publishes an optional sidecar. Finalization rejects entries that do not name a defined source body; bodyless foreign/compiler/intrinsic prototypes cannot carry a body policy. `Library::inline_hint` returns `Automatic` for an absent entry. LLVM declarations receive `alwaysinline` or `noinline` function attributes from this checked identity map. Names and debug metadata do not affect the decision.

The supplied source describes Jai `inline` as guaranteed inlining (`reference/how_to/115_auto_bakes.jai`, around lines 279–286). It therefore maps to LLVM `alwaysinline`, rather than the weaker `inlinehint`. The VM executes the same checked call semantics; it does not currently rewrite bytecode calls to inline their bodies. LLVM attributes express the policy, while actual substitution requires the native optimizer's inlining pass and a body it can inline.

Call prefixes use a typed `ExpressionKind::CallHint` wrapper. The outer span includes the modifier; the inner call retains its original range, arguments, callee and caller-location binding. `Call::new` defaults to automatic policy and `with_inline_hint` attaches policy to that selected direct call. Indirect IR expressions and statements carry the same typed policy. LLVM receives call-site attributes without altering the target declaration. Multiple-result capture and discarded-call binding enforce their existing `#must` contracts before emitting a hinted call.

`no_inline` supports dynamic procedure values. Forced `inline` requires a known constant procedure target; the supplied changelog explicitly references this restriction. Foreign declarations have no source body and cannot satisfy a forced inline call. Context overrides retain argument/override evaluation order, and a generated helper applies the policy to the actual target call inside the pushed context, leaving its own invocation automatic.

An explicit `no_inline` call overrides an `inline` declaration. The pinned `withlang-dev/open-jai` source at revision `264ba53218bf0e55bbc328197b312fe704496224`, `examples/17/17.7_inlining.jai`, demonstrates this at line 9, describing the call as not inlined. The definition keeps its `alwaysinline` function attribute; this particular call receives `noinline`. Focused native checks inspect retained calls at O0 and O2, with an exported caller taking an unknown input so constant folding cannot conceal inlining behavior.

The reverse combination, `inline` calling a `no_inline` declaration, remains an explicit unsupported capability until source evidence establishes its precedence. This is a remaining parity gap, not a claim that Jai forbids the combination. Semantic checks use the defining source identity before body readiness, and native lowering validates the immutable library policy again instead of trusting an unverified LLVM priority rule.

## How to change it

Change prefix parsing in `jai-syntax/src/procedures.rs`, semantic registration in the legacy resolver, graph body work queue or nested procedure binder, and attribute emission in `jai-codegen/src/inline_hints.rs`. Keep policy keyed by the generated definition identity when adding new specialization paths. Do not attach it to the callable type: two procedures with identical signatures may have different policies.

Call-prefix parsing is in `jai-syntax/src/expressions.rs`; source binding is centralized in `jai-sema/src/call_hints.rs`. Preserve the wrapper when cloning quoted syntax and recurse through its inner call in dependency or lexical-binding walkers. The result capture/discard adapters and context-call helper binder are separate consumers that must preserve policy. Direct IR construction should use `Call::new`; manually constructed indirect nodes must explicitly choose `InlineHint::Automatic` unless they carry source policy.

Duplicate or conflicting prefixes have a located parser diagnostic. Explicit declaration policy on a bodyless prototype is rejected with `procedure inlining modifiers require a source body`. Forced inlining through a mutable callback produces `inline requires a constant procedure target`; a forced foreign call reports its unavailable source body. Inlining reflection remains unsupported. The supplied `Preload.jai` `Type_Info_Procedure.Flags` catalog has no inlining flags. The `Compiler` module instead has distinct call flags and syntactic procedure-header flags; these are not evidence for inventing flags on runtime type descriptors.

## Configuration

There are no new flags or environment variables. Native bitcode optimization selection controls which LLVM pipeline runs; procedure attributes exist even before optimization. This feature does not implement the original compiler's metaprogram `-no_inline` override.

## Dependencies

The policy crosses `jai-types`, `jai-syntax`, `jai-sema` and `jai-ir`. Native emission uses Inkwell's LLVM enum-attribute API. Tests inspect real function and call-site attributes, verify the O0 always-inliner substitutes forced calls while preserving prohibited calls, execute the checked VM program and link/run objects emitted by this compiler from independently authored source.
