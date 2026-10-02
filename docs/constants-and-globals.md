# Constants and globals

## What it is

Scalar constants and mutable global variables extend the integer/Boolean compiler subset. Constants can occur at file or block scope; globals currently require constant initializers.

## How it works

```jai
ANSWER :: LIMIT * 6;
LIMIT :: 7;
count : int;

increment :: () {
    count += 1;
}

main :: () -> int {
    increment();
    return ANSWER + count; // 43
}
```

The parser distinguishes procedure definitions from parenthesized constant expressions and records declaration kinds explicitly. `name :: expression` infers a constant's type; `name : type : expression` provides its scalar type. `name := expression` and `name : type = expression` create mutable storage. An omitted mutable initializer produces zero or false.

A dependency worklist resolves constants before runtime statements, supports forward references, caches completed values and diagnoses cycles. Both file and block constants resolve within their lexical scopes. Block constants may appear after a return because they introduce no runtime statement. Names in a deferred body still capture their resolved binding IDs.

`jai-eval` binds the complete constant expression into separate integer and Boolean nodes before evaluating it. Even a short-circuited operand must have valid names and operand types. Evaluation short-circuits execution, so `true || (1 / 0)` is valid, while evaluating `1 / 0` is a diagnostic. The current `s64` arithmetic wraps for addition, subtraction, multiplication and negation, matching the implemented LLVM integer operations. Division overflow and shift counts outside 0–63 are rejected during constant execution; full Jai numeric compatibility remains unverified.

Global initializers may reference constants, but mutable storage and procedure calls cannot yet supply compile-time values. Resolution creates distinct integer/Boolean global IDs. Checked place enums distinguish global storage from procedure-local storage. LLVM emits initialized global values and direct typed loads/stores; constants become literal values and cannot be assigned or updated.

## How to change it

Extend `jai-syntax` declaration/expression variants, the shared domain operators in `jai-eval`, semantic declaration resolution and LLVM places together. Preserve lexical shadowing, cycle detection, whole-expression binding and immutable constants. The constant dependency test uses 20,000 forward references without recursive dependency resolution. Native tests cover actual shared storage and mutation, rather than emitted-text patterns.

The evaluation crate currently handles scalar expressions only. Procedure execution, composite values, type-valued constants, `#run`, host interactions and compiler workspaces require a larger compile-time engine; do not replace them with successful no-ops. Module/file namespaces and linkage are future work.

## Configuration

No new flags or external packages. The existing `check`, `emit-llvm` and `build` commands accept these declarations. `int`/`s64` and `bool` are the implemented value types. Global procedure-call initializers remain explicit errors.

## Dependencies

New internal `jai-eval` crate, `jai-syntax`, `jai-source`, `jai-sema` and `jai-codegen`. `jai-eval` has no LLVM, filesystem, process or networking dependencies. Runtime lowering and constant evaluation share integer/comparison operator enums. Existing Inkwell/LLVM and Divan dependencies are unchanged.
