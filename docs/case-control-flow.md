# Case control flow

## What it is

Scalar statement cases support `if value == { case constant; ... case; ... }` with independent arm scopes and explicit `#through`. Integer and bool subjects are supported; this does not make the enum, string, or type-valued cases in the reference and upstream applications compile.

## How it works

The parser retains a typed case operator, subject, constant labels, arm bodies, optional default plus its original source position, and fallthrough flags. Semantic resolution evaluates labels at compile time, coerces them to the subject's scalar type, rejects duplicates, and resolves each body as an independent scope. A hidden local caches the subject once, including calls with side effects.

LLVM emits ordered comparisons and separate body blocks. The first matching label executes; a normal arm exits the case statement, while `#through` jumps directly into the next body without testing its label. Deferred cleanup runs when leaving each arm, including fallthrough, return, and named loop transfers. A default arm may appear before, between, or after labels. It is selected only after all label tests fail, regardless of its position. It can `#through` into the next physical body, and a labeled arm can fall through into a middle default. The physically last body cannot `#through`. Without a default, an unmatched subject continues after the statement.

`!=` cases use ordered first-match comparisons. `#complete` currently validates bool `==` cases containing both `true` and `false`; integer completeness and enum completeness are rejected. Exhaustive bool cases can prove that a procedure returns without a default when every arm terminates, including `#through` chains that end in a terminating arm. LLVM marks the impossible unmatched path unreachable; falling-through arms retain a normal join. Expression cases (`ifx value == { ... }`) are explicitly rejected; the provided tutorial says they are unavailable, and the inspected recent Focus and Jails examples use statement cases.

```jai
main :: () -> int {
    result := 0;
    if 2 == {
        case 1; result = 10;
        case 2; result = 20; #through;
        case 3; result += 3;
        case; result = 99;
    }
    return result; // 23
}
```

## How to change it

Change `CaseStatement` and `Parser::case_statement` in `jai-syntax` for grammar changes, `jai-sema/src/cases.rs` for label/type/completeness rules, and `jai-codegen/src/cases.rs` for dispatch. Preserve exactly-once subject evaluation and full arm scopes when optimizing comparisons into a switch. Extend completeness only after the relevant finite type domains exist. Keep expression cases separate from statement cases because expressions require result typing and value joins.

`jai-types::CaseOrder` supplies checked body successors independently of label-dispatch priority. `default_position` counts preceding labeled arms. A legacy IR default with no explicit ordinal remains last; source parsing always records its ordinal. Resolution and IR verification reject invalid ordinals, missing-default metadata, last-body fallthrough, and unreachable `#through`. Ordinary execution, retained continuation tasks, LLVM branch construction, and native return-flow analysis consume the same order. The source-only packet's authored runtime fixtures are unrun until the coordinated build slot is granted.

## Configuration

There are no environment variables or flags specific to cases. Native tests use the normal LLVM setup documented in [LLVM backend](llvm-backend.md).

## Dependencies

The implementation uses the existing scalar types, constant evaluator, lexical bindings, deferred cleanup, loop transfer resolution, and Inkwell LLVM backend. No new external dependency is required. Native tests compile our generated LLVM IR with independently installed Clang and execute the resulting test programs.
