# Contextual casts

## What it is

`xx value` is an explicit cast whose destination comes from its enclosing
expression. Bare `xx` performs a checked cast; `xx,no_check` selects the same
unchecked policy as an explicit `cast,no_check(Type)`.
`xx,trunc` selects the distinct integer/pointer truncation policy described in
[Cast dialects and modifiers](cast-dialects.md).

## How it works

Assignments, declared initializers, arguments, results, aggregate elements,
and declaration defaults supply their canonical destination `TypeId` before
the operand is cast. Strong binary peers can supply an operand type; weak
literals and an untyped `xx` expression cannot invent one. Conditional arms
receive an enclosing declared type, and only the chosen runtime arm executes.
Conditions of `if`, `while`, and `ifx`, logical operators, and logical negation
provide Boolean context. Index operands provide the canonical signed index
type. Slice destinations also supply an array literal's element type before
resolving nested casts.

```jai
small: u8 = xx,no_check 300;  // 44
Flags :: enum_flags u8 { A :: 1; B :: 2; }
take :: (flags: Flags = xx 3) { /* flags contains both bits */ }
```

The resolver shares one cast dispatcher with explicit casts. Pointer views,
integer widths, float rounding, nominal enum identities, and distinct wrappers
therefore follow the same rules. Checked runtime narrowing retains a runtime
check; checked declaration defaults fail while evaluating the constant.
An unchecked float-to-integer conversion remains unsupported by the existing
cast policy. A context-free `value := xx 3` reports a missing destination type.

Overload selection describes the operand without running it. A contextual cast
must use a candidate's known parameter type or a type inferred from another
argument; it cannot independently bind a generic type variable. Matching a
runtime checked cast does not remove a candidate merely because that cast
would overflow. Baked constant casts must succeed before specialization.
Nominal metadata supplies enum member and flags eligibility during matching;
distinct scalar targets reuse the representation's cast rules while retaining
the declared identity in the result. Other distinct representations use ordinary
coercion, including typed pointer erasure into a wrapped `*void`.

Implicit conversion from `*T` to `*void` erases the pointee view while preserving
the address and VM provenance. Converting back to `*T`, or between unrelated
typed pointers, requires an explicit or contextual cast.

## How to change it

Extend `jai-sema/src/inferred_casts.rs` and its pure cast-feasibility helper
together. `expr_expected` supplies destinations to the common argument,
assignment, result, and literal paths. Declaration constants use the separate
`modules/aggregates/defaults/inferred_casts.rs` adapter, preserving constant
budgets and enum identity. Update pure overload matching when adding a cast
domain; avoid resolving an operand twice during candidate selection.

The native tests share `tests/support/checked_execution.rs` with the pointer
suite. It compiles newly generated LLVM with Clang, executes the fresh program,
and then checks VM agreement or an explicit capability boundary.

## Configuration

The source marker controls checked versus unchecked conversion. The selected
target layout governs pointer widths and integer address conversions; existing
VM resource limits and compile-time effect transactions remain in force.
There are no contextual-cast-specific environment variables.

## Dependencies

Contextual casts depend on the `jai-syntax` typed `InferredCast` node, canonical
`jai-types` identities, explicit cast IR, pure overload descriptors, typed
declaration defaults, VM execution, and LLVM lowering. The supplied lexer and
Reflection/Compiler module sources provide static evidence for the spelling
and modes; no original compiler executable is used as reference evidence.
