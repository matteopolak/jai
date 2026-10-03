# Caller defer exports

## What it is

A backtick `defer` in an expanded macro schedules cleanup in the caller's surrounding block. It retains macro-local captures while extending the cleanup lifetime beyond the expansion's immediate execution.

## How it works

```jai
push_allocator :: (allocator: Allocator) #expand #no_debug {
    previous := context.allocator;
    context.allocator = allocator;
    `defer context.allocator = previous;
}
```

The supplied Basic module uses this form to restore the previous allocator when the caller leaves its block. The profiling example uses the same syntax for an exit callback. Performing the cleanup at the end of the macro would undo the allocator change before the caller could use it.

The source AST remains `CallerExport(Box<Statement>)` with a real inner `Defer` body. Its outer statement span includes the backtick; its inner statement and cleanup statements retain their exact source ranges. Statement and quoted-code dispatch share the dedicated parser helper. Explicit backtick returns use the separate [caller return](caller-returns.md) contract. Ordinary calls and bare assignments are not reclassified as caller exports.

Before entering the macro definition, lowering records the caller's active cleanup scope and context. The defer body resolves against the macro's actual local storage, then its checked cleanup ID is moved into that caller scope. It therefore observes later writes to the captured storage and runs in reverse registration order on block exit, return, break, or continue. Return values are evaluated before the cleanup executes.

Nested expanded bodies do not shorten that lifetime: a macro invoked directly in another macro's top-level body inherits the original caller cleanup scope. A real nested block creates its own cleanup scope. The caller's active pushed context is retained separately from the macro's lexical name bindings.

## How to change it

`jai-syntax/src/caller_exports.rs` owns the declaration, defer, and explicit caller-return export grammar. `statements.rs` dispatches the backtick after local import detection. Semantic scheduling lives in `jai-sema/src/metaprogram/exports.rs`; `expansion_scope.rs` captures the caller before switching to the definition environment. It reuses `cleanup.rs` for checked bodies and exit paths. Macro lowering must preserve the defining environment without cloning source text or leaking ordinary macro locals into caller names.

The supplied changelog restricts exported defers to a macro's top-level statement list. The semantic adapter checks the live expansion frame and rejects nested macro blocks and use outside an expansion. `jai-sema/tests/caller_defer_exports.rs` covers block exit, early return, multiple exports, nested macros, hygienic storage, loop exits, and actual pushed contexts. Three shared fixtures also run through native lowering in `jai-codegen/tests/reflection.rs`.

## Configuration

There is no syntax flag. The selected macro's expansion and debug policies remain independent of cleanup scheduling. Caller block structure determines when cleanup executes.

## Dependencies

The feature uses source statements and spans, macro definition/invocation frames, checked storage captures, and existing defer lowering. It adds no external library and executes no supplied native compiler artifact.
