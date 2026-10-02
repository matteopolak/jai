# Implicit context

## What it is

Jai procedures share a typed context record through a hidden procedure argument. Context extensions declared with `#add_context` from the application and its modules form one schema for the compilation.

## How it works

The module graph keeps context declarations separately from ordinary namespace declarations. Semantic resolution evaluates each field's type and default in its defining file, checks member name conflicts across the workspace, and builds one nominal record with a canonical pointer type. Field declarations retain `using`, `#as`, alignment and note metadata. Promoted members use the original nested field identities for reads, writes and call-local overrides; they do not duplicate embedded storage. `#Context` denotes this same record, including in procedure parameter annotations.

```jai
#add_context number: int = 33;
change :: () { context.number += 9; }
main :: () -> int {
    change();
    return context.number; // 42
}
```

Global `#Context` records, including RuntimeSupport's first-thread context, use the same canonical schema and declaration defaults. Schema construction follows ordinary record defaults and callable type headers, and precedes global initialization. The default evaluator reads each field's already-checked value in its original source scope, so imported nonzero defaults and callback identities survive initialization. Partial record literals override selected fields and retain the schema defaults for the others. Each reused constant still counts toward the compiler's constant expansion budget.

Ordinary context member assignments mutate the caller's shared record. Reading `context` as a value snapshots the record. `copy := context; push_context copy { ... }` uses a scoped copy; the previous context resumes when the block leaves. Bare `push_context { ... }` starts from the schema's defaults.

Call-local overrides use `read(,, number = 42)`. Each named override selects a mutable context field; an unnamed override selects `allocator`. The call receives a modified copy of the current record, and the original record remains active afterward. Duplicate fields and constant-member overrides produce diagnostics.

A `#c_call` or `#no_context` procedure starts without an implicit context. It must establish one with `push_context` before using `context` or calling a procedure whose signature requires it. Procedure values preserve the same context requirement as direct calls.

The native backend derives the hidden pointer ABI from the checked context definition. The VM shares a managed context allocation between implicit callees. Both restore the caller's context on normal completion and control-flow transfers. Return values are captured before cleanup execution.

Deferred bodies retain their lexical context with `CleanupContext::Procedure` or a branded `PushContextId`. This lets an early return inside a nested push run inner defers with the pushed context and outer defers with their original context.

Expression calls with overrides lower to generated, checked procedures. Their ordinary arguments, context snapshot, and override values are captured once in source order. The helper applies field writes to the snapshot, pushes it, performs the target call once, and returns its ordered results. A call-site optimization hint stays on the target call inside the helper; a known target retains direct-call identity. Dynamic targets can carry `no_inline`, while forced inline requires a known procedure. This keeps lexical context restoration in the existing IR contract and supports overrides in nested expressions and multiple-result bindings.

## How to change it

`jai-sema/src/context.rs` handles current context expressions, availability checks, field lookup, and lexical pushes. `jai-sema/src/modules/context.rs` builds defaults and resolves context extensions in their source scopes. The module graph owns the context declaration inventory. `modules/context_registration.rs` collects the designated Preload `FIRST_ADD_CONTEXT` quotation before defining the schema when Runtime_Support is present. Its fields precede application extensions, and their names resolve in the quotation's defining file. Ordinary runtime `#add_context` statements cannot resize the established schema.

`jai-sema/src/procedure_values/context_calls.rs` constructs the generated call helpers. Publish their signatures and bodies through the same registry as local procedures so compile-time providers and native reachability see them. Preserve the source binding's parameter indices while capturing values in their original evaluation order.

The schema exposes the same record metadata overlay used by ordinary records. Extend that overlay when changing promotion or directional `#as` conversions, and keep callback alias lookup in the original field's file. Alignment constraints go through the canonical record layout, while notes feed reflection metadata.

Keep the schema's record, pointer, and default types consistent. `jai-ir` verifies this relationship, the availability of implicit context, and ownership and ancestry of push identities used by cleanup bodies. Context constants are distinct from mutable record fields; callable constants retain a checked procedure identity. Constant members also resolve on explicit `#Context` records and the context type namespace. An explicit record parameter can expose a constant member in a `#no_context` procedure without reading an active context.

Native and VM context helpers must agree on record snapshots, shared member writes, default initialization, and cleanup restoration. The source, VM, and native context tests exercise these contracts without loading a reference compiler or reference library.

## Configuration

`#add_context` adds a mutable field or constant member. `#Context` denotes the resulting record type. `#c_call` and `#no_context` disable implicit passing. `push_context` establishes a lexical context, with either an explicit record or schema defaults. `,,` inside a call overrides named fields of a copied current context; its unnamed form is allocator shorthand.

There are no context-specific environment variables. The schema is per compilation and uses the compilation's type arena; it is not a host-global variable.

## Dependencies

Context parsing uses `jai-lexer` and `jai-syntax`; source scope lookup and extension inventory use `jai-modules`. Canonical record, pointer, and field identities come from `jai-types`. `jai-ir` supplies the checked context and cleanup contracts. The LLVM backend and compile-time VM implement the same passing and restoration behavior.
