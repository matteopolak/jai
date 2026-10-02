# Flags operators

## What it is

`enum_flags` bitwise operations preserve their nominal enum type. Equality and inequality also accept a weak integer zero, allowing `flags & .MASK != 0` without an explicit integer cast.

## How it works

```jai
Flags :: enum_flags u16 { READ :: 1; WRITE :: 2; }
flags: Flags = .READ;
if flags & .READ != 0 && flags & .WRITE == 0 { /* ... */ }
flags &= ~.READ;
```

Bitwise operators bind before comparisons. From tighter to looser, the relevant precedence levels are arithmetic, shifts, `&`, `^`, `|`, relational comparisons, equality comparisons, `&&`, and `||`. Parentheses can override this order. Both normal execution and pure constant evaluation consume the same parsed expression tree.

A flags value can compare with weak zero on either side of `==` or `!=`. Folded weak constants such as `ZERO :: 1 - 1` retain this behavior. A strong typed integer, a nonzero weak integer, an ordinary enum, or an unrelated flags enum does not gain an implicit conversion. Explicit casts remain available for numerical operations outside the flags domain.

Declaration-site flags defaults also accept weak zero, including a folded weak constant, even when the enum declares no zero member. Defaults keep the declared enum identity and representation; this does not permit a typed integer zero or a nonzero integer to initialize an enum implicitly. The supplied Compiler source uses `flags: Intercept_Flags = 0` and documents flags zero as the empty set. `modules/aggregates/defaults.rs` checks flags metadata before constructing that nominal constant; procedure, global, and record-field tests cover this path.

Complement uses the declared representation width, so complementing bit one in `enum_flags u8` produces `254`, while the result retains its original nominal type. A leading-dot member can receive context from its immediate binary partner, a typed local initializer, an assignment, or a compound assignment. Context propagates through unary complements such as `~.READ`; it does not search through arbitrary arithmetic expressions such as `.READ + 1`. Every referenced member is checked before lazy execution selects an operand or branch. Module-argument evaluation follows the same flags rules using declaration identity before semantic `TypeId` values exist.

The pinned modern Vk sources use unparenthesized `flags & .POINTER != 0` and similar masks. The supplied `014_enum_unary_dot.jai` tutorial explicitly supports `f &= ~.HUNGRY` and rejects arbitrary-depth member inference. The implementation restricts weak integer comparison to zero and to flags; it does not infer broader integer compatibility from those examples.

## How to change it

`jai-syntax::BinaryOp::parse` owns the shared precedence table. Keep its parser grouping tests and the `jai-eval` integration tests aligned when changing operator precedence.

`jai-sema/src/enum_operators.rs` owns nominal enum binary lowering, weak-zero flags comparisons, complement, and bounded contextual member resolution. Expression dispatch and compound assignments supply the existing canonical `TypeId`; the helper lowers into the shared integer representation nodes and wraps flags results back into the nominal enum. Source VM and native tests cover the same checked program.

## Configuration

There are no new CLI flags or environment variables. Contextual unary member resolution supports at most 128 expression nodes and returns a source diagnostic for unsupported inference.

## Dependencies

The feature uses `jai-syntax` operators and enum syntax, `jai-types` nominal IDs and integer representations, `jai-sema` enum metadata, and `jai-ir` integer comparison and enum wrapping nodes. `jai-eval`, `jai-vm`, and `jai-codegen` share the parsed or checked operations used by constant and runtime evaluation.
