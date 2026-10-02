# Constants and globals

## What it is

Constants and mutable global variables are resolved by lexical declaration identity. Scalar values use the independent evaluator; recursive typed constants use the semantic context pool and compile-time execution uses the checked VM.

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

A dependency worklist resolves constants before runtime statements, supports forward references, caches completed values and diagnoses cycles. Enum-dependent constants have a separate typed worklist: expressions bind to common checked IR and execute in the independent VM before globals and defaults are initialized. This preserves enum identity through flags operations and aliases and rejects comparisons between unrelated enums. Both file and block constants resolve within their lexical scopes. Block constants may appear after a return because they introduce no runtime statement. Names in a deferred body still capture their resolved binding IDs.

Procedure header reservation resolves explicitly annotated parameter types without inferring their default expressions. Default materialization happens in the complete-header phase; unannotated defaults still require inference. This keeps forward callable signatures available without prematurely consuming a default's compile-time dependencies.

Complete headers distinguish immutable defaults from [runtime storage-read defaults](runtime-parameter-defaults.md). Mutable global and context paths retain typed recipes; their values are read at omitted-argument call sites rather than by the constant evaluator.

`jai-eval` binds the complete constant expression into separate integer and Boolean nodes before evaluating it. Even a short-circuited operand must have valid names and operand types. Evaluation short-circuits execution, so `true || (1 / 0)` is valid, while evaluating `1 / 0` is a diagnostic. Fixed-width source integer arithmetic checks its declared width; lexical `#no_aoc` selects wrapping behavior. Untyped literal arithmetic retains checked intermediates until a type constraint materializes it. Signed division overflow follows that policy, while zero divisors and shift counts outside the selected width are always rejected. See [integer types](integer-types.md) for coercion and casts, and [scoped safety checks](safety-checks.md) for constant/runtime parity.

Untyped decimal constants retain an immutable bound expression tree in a shared `Arc`. A use constrained to `f32` or `f64` rounds that exact tree directly to its target type; caching or aliasing the constant does not first round it to another width. Constant bindings are cloned handles rather than copied scalar-only cache entries.

Global initializers may reference constants. Ordinary runtime procedure calls cannot supply a global initializer; explicit `#run` goes through the checked compile-time execution scheduler. Resolution creates common global IDs and registry-typed places with checked integer/Boolean views. Checked place enums distinguish global storage from procedure-local storage. LLVM emits initialized global values and direct typed loads/stores; constants become literal values and cannot be assigned or updated.

## How to change it

Extend `jai-syntax` declaration/expression variants, the shared domain operators in `jai-eval`, semantic declaration resolution and LLVM places together. Preserve lexical shadowing, cycle detection, whole-expression binding and immutable constants. `modules/enum_constants.rs` owns the typed enum dependency phase; it must retain defining-file lookup and seed default evaluators with the resulting nominal values. The constant dependency test uses 20,000 forward references without recursive dependency resolution. Native tests cover actual shared storage and mutation, rather than emitted-text patterns.

The evaluation crate handles pure scalar expressions. Composite and type-valued constants, `#run`, and compiler interactions use the semantic context and checked VM; unsupported operations return diagnostics. The graph adapter resolves module/file names and qualified constant dependencies by declaration identity; see [scoped semantics](scoped-semantics.md).

## Configuration

No new flags or external packages. The existing `check`, `emit-llvm` and `build` commands accept these declarations. The graph resolver also handles floats and recursive aggregate constants. Global runtime procedure-call initializers remain explicit errors.

## Dependencies

Internal `jai-types`, `jai-eval`, `jai-syntax`, `jai-source`, `jai-sema`, `jai-ir`, `jai-vm` and `jai-codegen` crates. `jai-eval` has no LLVM, filesystem, process or networking dependencies. Runtime lowering and constant evaluation share integer/comparison operator enums. Existing Inkwell/LLVM and Divan dependencies are unchanged.
