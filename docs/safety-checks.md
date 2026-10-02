# Scoped safety checks

## What it is

`#no_aoc` disables source arithmetic overflow checks, and `#no_abc` disables source array bounds checks. Each directive applies to the marked procedure or lexical body; the default source policy enables both checks.

## How it works

The parser retains separate `CheckPolicy` fields for procedure bodies and `CheckScope` statements. Semantic resolution combines each override with the enclosing `ActiveChecks`, constructs typed operation nodes with the resolved decision, and restores the previous policy on leaving the body, including failed resolution. A procedure call uses the callee's own body policy. Nested declarations retain their defining policy rather than whichever policy happens to be active when a forward reference resolves.

```jai
wrap :: (value: u8) -> u8 #no_aoc { return value + 3; }

main :: () -> int {
    value: u8 = 255;
    #no_aoc { value += 1; } // wraps to 0
    value = 255;
    value += 1;            // checked overflow
    return cast(int) value;
}
```

`IntExpr::overflow_check()` controls typed addition, subtraction, multiplication, negation, and signed division overflow. Checked operations validate the exact result against the signed or unsigned operand width before truncation. Disabled operations wrap to that width. LLVM uses widened arithmetic followed by a truncate/reextend comparison and a trap on mismatch. VM arithmetic and pure constant evaluation enforce the same width decisions, including products that exceed the evaluator's `i128` intermediate range. Untyped literals still must fit their eventual type; disabling runtime overflow checks does not reinterpret an out-of-range literal or explicit checked cast.

Deferred contextual floating-point constants can contain integer arithmetic in their conditions or conversions. Their exact constant keys retain the integer overflow decision so checked and wrapping expressions cannot reuse each other's cached result.

Array loads and stores carry `CheckMode` on `ValueExpr::Index` or the `IndexProjection`. When a fixed-array length and index are both compile-time constants, enabled checks reject an out-of-range index during semantic resolution, before code generation. Other enabled checks validate the signed index against the sequence count at execution. Disabled checks omit that source count test, permitting an access beyond a view's declared count when its backing storage actually contains the element. Both backends retain null-pointer checks. The VM additionally retains allocation, lifetime, memory ownership, resource limits, and backing-storage bounds because virtual execution cannot access arbitrary host memory.

Signed minimum divided by minus one fails when overflow checking is enabled. With `#no_aoc`, division wraps to the signed minimum and the corresponding remainder is zero. LLVM selects a safe divisor before executing division or remainder, then selects the wrapped result, so the unchecked case does not create poison. Division by zero, invalid shift counts, and explicit checked casts remain independently guarded. Bitwise operators and shifts do not use the arithmetic overflow check.

Anonymous `#run` bodies inherit their lexical policy. Expanded procedure arguments resolve in the caller, while explicit body flags govern the expansion's body. Captured code retains its defining policy when inserted with captured scope; caller-scope insertion uses the caller's policy. Deferred bodies are lowered with the policy active where their source is registered.

## How to change it

Update `jai-syntax/src/safety_checks.rs` for syntax, `jai-sema/src/safety_checks.rs` for inheritance, and `jai-types/src/safety_checks.rs` for the shared closed checking mode. Preserve metadata on newly introduced arithmetic or index constructors. Raw `IntExpr::new` deliberately keeps the existing wrapping IR construction behavior; source arithmetic must explicitly use `with_overflow_check`, and raw IR callers requesting checks must do the same. `PlaceRegistry::index` defaults to enabled checks; `index_with_check` accepts the resolved policy.

VM arithmetic lives in `jai-vm/src/scalar.rs`; sequence evaluation and place evaluation separately enforce view counts and virtual backing constraints. Native arithmetic lives in `jai-codegen/src/arithmetic.rs`, and native indexing lives in `jai-codegen/src/pointers.rs`. Keep source count permission separate from the VM's isolation checks and from null, cast, divisor, and shift validity.

`jai-eval` has explicit `evaluate_paths_with_overflow_check` and `evaluate_float_paths_with_overflow_check` entry points for lexical constants. Ordinary source constant entry points enable overflow checks. Add fixtures to `jai-eval/src/safety_checks_tests.rs` and `jai-codegen/tests/safety_checks.rs` when changing the behavior. Native fixtures must access real backing storage; out-of-allocation accesses are tested only in the VM, which guarantees their rejection.

The source suite resolves self-written files through `ModuleGraph`, executes their checked IR in the VM, and builds new native objects through the LLVM library. Its ten test groups cover exact results at all integer widths, scope restoration, callable type identity, captured code and expansions, constants and `#run`, static and runtime bounds, null guards, and VM fuel limits. The evaluator suite separately checks deferred floating-point constant identity and integer products larger than its signed intermediate range.

## Configuration

The two source directives independently override the enclosing enabled defaults. A body without an override inherits its enclosing lexical policy. Procedure policies do not alter canonical callable type identity. Global build-option support for diagnostic severity or disabling these checks is separate from these lexical directives.

## Dependencies

The implementation uses the shared type registry and typed IR, the bounded VM, the pure scalar evaluator, and the LLVM library backend. Source evidence includes local `reference/how_to/004_arrays.jai` (static and runtime bounds checks), `reference/how_to/085_default_types_for_literals.jai` (checked typed overflow in debug builds), `reference/modules/Program_Print/module.jai` (separate block flags), and both local and pinned Focus `Runtime_Support.jai` (procedure modifiers). Pinned Vk-Engine sources also use marked lexical and loop bodies. No supplied compiler, native object, or library is executed to establish this contract.
