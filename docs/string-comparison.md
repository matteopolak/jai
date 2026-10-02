# String comparison

## What it is

String `==` and `!=` compare byte content and length. They work in ordinary source expressions, pure compile-time `#if` guards, and `#run` procedures, including strings containing embedded NUL bytes.

## How it works

The semantic resolver requires the canonical string type on both operands and emits `BoolExpr::CompareStrings`. The IR verifier checks each operand and rejects non-string types. Reference tutorial `reference/how_to/010_calling_procedures.jai` uses `name == "Fred"` and `catch_phrase == "Hot Damn!"`, establishing ordinary content comparison rather than pointer identity.

The module graph's scalar evaluator can defer a file-level guard it cannot represent. The driver retains discovery state and asks `resolve_discovery_conditions` to resolve that guard through the same typed string expression and pure VM execution used for statement guards, then resumes graph discovery with the selected branch.

Both descriptors are evaluated once, left to right, before backing bytes are inspected. Different counts immediately compare unequal. Equal zero counts compare equal without accessing pointers. Otherwise the VM validates each view and reads bytes under its fuel budget, charging the shared memory load cost before accessing view backing as well as a comparison step per byte; native code calls an internal LLVM helper that checks bytes until a mismatch or the count is reached. No C string terminator or external `strcmp`/`memcmp` function is involved. Two separate backing arrays can compare equal, and `"A\0B"` differs from both `"A"` and `"A\0C"`.

String descriptor counts are signed. Different counts need no byte access; equal negative counts fail at actual comparison use instead of wrapping to a huge memory range. The VM rejects address-derived byte provenance as comparison input because virtual address data cannot safely determine a native compiler result.

The VM prepares demanded pointer layouts under the remaining fuel budget before validating a nonempty view or computing a byte address. Cold layout traversal and pending-layout readiness consume their actual bounded work. Unequal lengths and equal empty descriptors do not demand backing layouts, so comparison preserves the same no-access behavior for unresolved or null backing pointers.

## How to change it

Source operator dispatch lives in `jai-sema/src/string_comparison.rs`. Extend the typed IR and verifier together when adding an operation. VM behavior is isolated in `jai-vm/src/execute/string_comparison.rs`; native behavior is in `jai-codegen/src/string_comparison.rs`.

Keep tests for separate backing storage, empty null descriptors, unequal lengths, bytes after a NUL, and right-hand calls mutating left-hand backing. Preserve evaluation order and fuel accounting when changing the comparison loop. String ordering and implicit conversion from byte arrays are separate features and are not inferred by this operator.

## Configuration

No flag changes string equality semantics. The VM uses its normal fuel and memory limits. Native tests use the shared [native test tool selector](native-test-tools.md) and newly emitted test programs only.

## Dependencies

`jai-syntax` provides decoded byte literals. `jai-types` supplies canonical string identity and equality operators. `jai-ir` supplies typed operands and verification. The VM uses virtual memory and descriptor validation; code generation uses Inkwell and the checked `jai-llvm::gep` boundary.
