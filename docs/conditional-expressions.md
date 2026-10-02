# Conditional expressions

## What it is

`ifx` produces an integer or Boolean value from a condition. The current implementation supports expression arms, an optional `then` keyword and a default false arm when `else` is omitted.

```jai
factorial :: (n: int) -> int {
    return ifx n <= 1 then 1 else n * factorial(n - 1);
}

main :: () -> int {
    return factorial(5); // 120
}
```

## How it works

The parser records the condition, true expression and optional false expression. Resolution converts the condition to a Boolean using scalar truthiness and constructs either an integer conditional or a Boolean conditional. Both arms must supply the same non-void type, even when a constant condition would skip one arm. An omitted false arm becomes `0` or `false` according to the result type.

The pure constant evaluator binds both arms before executing only the selected one. Constant dependencies from all arms participate in name resolution and cycle detection. LLVM lowering evaluates the condition once, emits separate branch blocks and joins their values with a correctly typed PHI. Nested conditional and short-circuit expressions contribute their actual final blocks to the PHI.

The recent Jails corpus uses this syntax for scalar expressions, for example its UTF-16 unit calculation in [memory-files handling](https://github.com/SogoCZE/Jails/blob/42fa76c816ad34c9f24a4bde586d145c992dc860/server/memory_files.jai). The local `025_ifx.jai` tutorial additionally describes block arms and implicit true values. Those forms, conditional cases and `#ifx` are still unsupported and produce diagnostics; this checkpoint does not compile the full tutorial or Jails project.

## How to change it

Extend `ConditionalExpression` in `jai-syntax` for additional source forms, then update constant dependency traversal, `jai-eval` binding, `jai-sema` resolution and `jai-codegen` lowering. Preserve typed result branches and avoid duplicating evaluation when implementing implicit true values. Block arms will need expression-result scopes and cleanup handling before they can be accepted.

Add rejection tests for incompatible or void arms and behavior tests for side effects, recursion, nested PHIs and omitted false arms. Keep allocation benchmarks separate from the existing baseline workloads.

## Configuration

There are no feature flags. The current result types are the compiler's `int`/`s64` and `bool` subset. `then` may be omitted when the two expressions parse unambiguously; parentheses can separate nested values. An `else` belongs to the nearest unmatched `ifx`.

## Dependencies

`jai-syntax`, `jai-eval`, `jai-sema`, `jai-codegen`, Inkwell/LLVM 22 and Divan. Native behavior tests use independently installed Clang; supplied reference binaries are not executed locally.
