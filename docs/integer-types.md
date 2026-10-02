# Integer types and conversions

## What it is

The compiler supports `s8`, `s16`, `s32`, `s64`, `u8`, `u16`, `u32` and `u64`. `int` is an alias for `s64`; Boolean values retain their separate type.

```jai
main :: () -> int {
    wide: u16 = 298;
    small := cast,no_check(u8) wide;
    return small; // 42
}
```

## How it works

`jai-types` defines a closed integer type enum and normalized, private integer bit patterns. Checked construction proves a value fits; wrapping construction explicitly permits loss. Semantic integer expressions store their resolved type, and integer storage IDs retain that type through globals, locals, arguments, returns, range iteration and conditional values.

Numeric literals and untyped numeric constants retain their mathematical value until a storage or call constraint chooses a type. Inferred integer storage defaults to `s64`; explicit `u64` storage accepts values through `18446744073709551615`. Unary negation supports the direct `-9223372036854775808` spelling. The parser reads digits and separators directly without allocating a cleaned numeric string.

Implicit conversions preserve the entire range of a typed operand: `u8` can become `u16` or `s32`, while `s8` cannot become `u64`. Arithmetic and comparisons select an operand type that contains the other operand's range; incompatible ranges require explicit casts. Literal operands may fit the selected type without inheriting a stored variable's restrictions. Literal-only conditional arms also retain contextual integer constraints.

Explicit `cast` checks range. A cast that loses information branches to LLVM's trap intrinsic when executed, including explicitly checked literal casts. Out-of-range implicit literal conversions produce compilation diagnostics. `cast,no_check` performs intentional truncation or reinterpretation without that check. Widening uses sign extension for signed sources and zero extension for unsigned sources. LLVM operations use the resolved width and signedness for division, remainder, shifts, comparisons and range endpoints.

Fixed-width addition, subtraction, multiplication and negation wrap to their declared width in the evaluator and backend. Untyped constant arithmetic uses checked `i128` intermediates and retains range checking at materialization. Constant division by zero, signed minimum divided by `-1`, and invalid shift counts produce diagnostics when evaluated. Runtime division/shift checks and friendly runtime cast diagnostics remain future work; invalid runtime arithmetic currently has LLVM's undefined-operation semantics. This does not establish complete numeric parity with every Jai compiler version.

## How to change it

Add scalar domains in `jai-types`, then update syntax, pure evaluation, coercion, storage/signatures, typed expression lowering and native code generation. Keep width information on integer expressions rather than deriving it by repeatedly walking expression trees. Ensure skipped operands are bound without prematurely executing invalid arithmetic.

Test boundaries for every width, range-preserving and rejected conversions, signed and unsigned operations, cast traps, intentional loss, global initializers, parameter defaults, and typed range termination. New numeric domains also need cases, cleanup capture, calls and conditional joins checked together.

## Configuration

Cast checks are currently always enabled unless source explicitly uses `no_check`; there is no global optimization switch for them yet. Native execution uses independently installed LLVM/Clang. Floating point and aggregate types remain unsupported.

## Dependencies

`jai-types`, `jai-syntax`, `jai-eval`, `jai-sema`, `jai-codegen`, Inkwell/LLVM 22 and the native test harness. The type crate uses only the Rust standard library.
