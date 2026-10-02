# Deferred cleanup

## What it is

`defer` runs a scalar statement or block when control leaves its enclosing lexical block. Cleanup covers normal completion, procedure returns and named or unnamed loop exits.

## How it works

Resolution registers each deferred body when its declaration is reached in source order. The body resolves names immediately into local/procedure IDs, but expressions execute when cleanup runs. Later changes to those locals are visible; later shadowing does not change which binding is captured.

Local declaration discovery also reserves future runtime names for static capture checks. Cleanup temporarily removes only inherited runtime names without an activated binding while resolving its body, then restores them even when resolution fails. Existing locals, hoisted source declarations, and scope identities remain available. This prevents a later `x := ...` from blocking the outer `x` used by an earlier defer.

```jai
main :: () -> int {
    n := 0;
    while true {
        defer n += 1;
        if n < 3 continue;
        break;
    }
    return n; // 4: cleanup also runs on the final break.
}
```

Each lexical block tracks its activated `CleanupId` values. Normal completion executes them in reverse declaration order. An explicit typed exit holds the exact cleanup IDs for the scopes it crosses, from the innermost scope outward. Breaking an inner loop preserves cleanups in surrounding scopes; continuing a named outer loop cleans every crossed loop body before reaching that loop's next test or step.

LLVM lowering evaluates and saves a return value before executing cleanup. Consequently, `n := 7; defer n = 99; return n;` returns 7. Cleanup can itself use internal loops, branches, short-circuit expressions and nested defers. Its own scope cleans up normally. Deferred bodies cannot return from the enclosing procedure or jump to a loop outside the deferred body in this implementation.

The typed program stores each deferred body once. LLVM emits its instructions at the applicable exit paths, so no runtime heap-backed cleanup stack is introduced. This can increase generated code for many exits; instruction sharing is future optimization work. All local storage remains in procedure entry blocks.

## How to change it

`jai-syntax` parses the statement. `jai-sema/src/cleanup.rs` registers bodies and constructs return exits; `loops.rs` constructs loop exits. `jai-codegen` snapshots return values, emits the listed cleanup bodies and then performs the transfer. Preserve lexical activation, captured binding IDs, LIFO ordering and the distinction between returning from a procedure and leaving a loop.

Native tests exercise actual cleanup effects on fallthrough, break/continue, outer exits, nested defers, shadowing, and returned values. Checked-IR aggregate fixtures verify that returned snapshots precede deferred mutation. Rejection tests cover unsupported cleanup escapes, references to undeclared names and unreachable declarations. Future exception or destructor behavior needs equivalent exit handling.

## Configuration

No flags or external configuration. Cleanup order follows lexical nesting and reverse declaration order within each block. `defer` may precede a single statement or a braced block.

## Dependencies

The syntax, semantic and LLVM crates, with no new external dependencies. Divan benchmarks have separate `cleanup_lower_llvm` and `cleanup_pipeline` workloads at 4, 64 and 1,024 procedures, including nested deferred loop exits. LLVM-native allocations remain outside the Rust allocator measurements.
