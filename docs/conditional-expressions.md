# Conditional expressions

## What it is

`ifx` selects a value without evaluating the unused runtime branch. It accepts explicit expression arms, an optional `then` keyword, an implicit true arm, and the result type's default value when `else` is omitted.

```jai
fallback :: (value: int) -> int {
    return ifx value else 42;
}
clamp :: (value: int) -> int {
    return ifx value > 5 else 5;
}
```

## How it works

An explicit arm stores its written expression. An implicit arm stores `ConditionalThenValue::ImplicitSubject` and borrows its subject from the original condition; it never synthesizes or clones a second source expression. Source dependency, expansion, quoted-source and metadata visitors traverse only the written children.

For `ifx value`, the subject is `value`. One Boolean operator can expose its operand: `ifx value > 5 else 0` returns `value` when the comparison succeeds, and `ifx !value else 0` returns `value` when it is false. Direct calls expose their first written argument recursively. For `ifx accepts(add(value, other)) else 0`, the implicit true value is `value`. Only one Boolean operator is unwrapped, so `(value > 0) && enabled` exposes the left comparison's Boolean value.

Resolution captures that actual subject once using a checked, procedure-owned `ExpressionBindingId` and existing `ValueExpr::Bind`/`Bound` IR. The condition and selected true arm reuse the checked value. A scoped exact source-node match is retired before returning either a checked condition or a diagnostic. Captured callable contracts stay attached to the original checked producer. No new VM or native instruction is needed.

Integer, Boolean, floating-point and pointer conditions retain their usual truth rules. Strings and sequence descriptors use their actual count, including fixed arrays. Missing false arms use the result's default: zero, false, null or the checked type's default descriptor. Both result arms still need compatible types and valid bindings. Scalar domain inference checks inactive bindings without reading their values and retains the implicit subject only once.

First-argument extraction from an indirect callback is diagnosed because capturing it before the callback read would change evaluation order. `is_constant` extraction is diagnosed because its argument is an observation rather than a runtime producer. Write an explicit true arm for these cases. Existing `#expand` value-result limits remain in force. Branch blocks need statement-valued expression scopes and cleanup support; conditional cases and `#ifx` remain unsupported. Parsing a larger file does not imply those other features are implemented.

## How to change it

Extend subject selection in `jai-syntax/src/conditional_expressions.rs` together with the ordered-subject checks in `jai-sema/src/implicit_conditionals.rs`. Preserve actual source allocation and written spans. Update source visitors through `expressions()`/`expressions_mut()` rather than visiting `then_source()` as another child: the latter borrows an existing condition child for implicit arms.

Pair any new producer form with its real evaluation order and callback contract before accepting it. Do not lower an implicit arm by inserting a second copy of its source. Keep `jai-eval` binding and domain inference aligned with the semantic resolver. The syntax, scalar and graph/VM fixtures in the corresponding `implicit-conditionals` tests cover capture counts, lazy fallback, nested calls, source delimiters and explicit unsupported forms. These authored tests require a compiler gate before execution behavior is claimed.

## Configuration

There are no feature flags. `then` can be omitted before a written true expression when the expressions are unambiguous. An implicit true arm ends at `else` or a normal expression delimiter; a written `then` still requires an expression. An `else` belongs to the nearest unmatched `ifx`. Existing parser depth, constant-depth, type and VM limits continue to apply; the semantic capture stack checks `MAX_CONSTANT_DEPTH`.

## Dependencies

The source path uses `jai-syntax`, `jai-source`, `jai-modules`, `jai-eval`, `jai-types`, `jai-ir` and `jai-sema`. Execution reuses the LLVM-free `jai-vm`; native compilation can use the existing `jai-codegen` LLVM 22 backend. No external package or original reference binary is required.
