# Procedure calls

## What it is

Direct scalar procedure calls support typed parameters, constant defaults, inferred defaults (`n := 3`), and named arguments (`f(b = 2, a = 1)`). Required parameters may follow parameters with defaults.

## How it works

The parsed `ParameterBinding` enum admits only required typed parameters or defaulted parameters with an optional explicit type. Signatures resolve defaults once using declaration-level constants, infer omitted types, and check the default against its parameter type. Binding matches a positional prefix by index and named arguments by symbol, rejects duplicates and unknown names, then fills omitted defaults. Integer arguments use the same checked implicit coercions as other assignments; booleans require boolean values.

The typed call stores expressions in source order with a `ParameterId` destination. LLVM evaluates every explicit expression in that order before rearranging the resulting values into parameter order. This preserves side effects when named arguments reverse their destinations. Defaults are compile-time constants and have no runtime effects.

## How to change it

Extend `jai-syntax` parameter and call parsing, `jai-sema/src/calls.rs` signature validation and binding, and the backend's call emission together. Keep evaluation order distinct from ABI argument order. Runtime defaults, defaults referring to parameters, indirect calls, varargs, aggregate arguments, and multiple results are not implemented. A positional argument after a named argument is rejected.

## Configuration

There are no feature flags or environment variables. Parameters use the existing scalar type and integer width rules.

## Dependencies

The implementation uses `jai-syntax` for syntax, `jai-eval` for pure default evaluation, `jai-types` for scalar coercion, and Inkwell for typed LLVM call construction. Native tests link generated LLVM through independently installed Clang.
