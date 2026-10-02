# Procedures, control flow, data structures and memory

This page covers callable values, argument and return behavior, control flow, iteration, allocators, and lifetime patterns demonstrated by the supplied source corpus.

## Source evidence

The tutorial corpus covers procedure declarations and calls, arguments and returns, context, temporary storage, formatted output, iteration, conditions, member exposure, operator overloads, memory management, logging, stack traces, allocators, and inline assembly. Larger programs exercise these features in data structures, visualization, and game code.

## Procedure declarations and calls

A procedure type is written from its parameter list and optional result, for example `(count: s64) -> bool`. A definition adds a body. The examples commonly bind procedures with `::`. Arguments may be passed positionally or by name; default arguments can be omitted, and varargs forms are shown. Multiple results are returned as a comma-separated tuple-like sequence and can be assigned to multiple destinations. A call with multiple return values is not the same as returning a struct.

Parameter defaults distinguish a typed default (`amount: s64 = 4`) from an inferred default (`amount := 4`) in the lessons. The latter may participate in polymorphic behavior. Named arguments permit skipping earlier optional parameters. The examples show default results and named result assignment, but do not fully specify evaluation order for side-effecting argument expressions; avoid depending on an unproven order.

The corpus describes ordinary procedure arguments as value passing with ABI-dependent transport; large aggregates may be passed indirectly as an implementation detail. Do not make source semantics depend on whether the backend uses registers or a hidden pointer. Procedures are not closures: a nested procedure cannot capture mutable local variables from its enclosing runtime procedure. Function values and callbacks are demonstrated, including a C-call-convention annotation. The larger corpus also uses `#foreign` declarations bound to named `#library` handles or external symbol names, plus unbound imports supplied by a host (for example, a wasm runtime). `#c_call` selects the C calling convention on a procedure type/declaration. Foreign declarations describe ABI boundaries; they do not provide a Jai body, and a named library must be available to the selected target/build. The examples use C-compatible fixed-width fields and pointers for these interfaces, so do not infer that Jai's default integer aliases or aggregate layout automatically match an arbitrary C declaration.

Lambdas include a concise expression form such as `triple :: x => x * 3`. The lessons demonstrate function values and callbacks but do not establish closure capture; treat lambda capture like nested procedures unless stronger direct evidence says otherwise.

## Conditions and branches

Runtime `if` accepts a condition and a statement/block; `else` is optional. The `then` spelling is shown for compact single statements. `ifx` is an expression form that yields a value, including a block form and optional else behavior. `if` can bind a value in the condition in the demonstrated pattern, allowing a non-null-like value to be tested and named in the body.

`case` and `switch` examples branch on enum/discriminant values and support grouped cases. `#if` is compile-time selection and must use a constant condition; unlike runtime `if`, discarded branches are not compiled/typechecked as ordinary program branches, though their syntax still must parse. This permits target-specific declarations. `#if` branches do not introduce an ordinary nested scope.

## Loops, defer, and operators

`while` loops support `break` and `continue`; labeled loops permit targeting an enclosing loop. `defer statement;` schedules that statement for the end of the current scope, including exits through `continue` or `break`. Its placement matters: a defer reached only after a guard is not run on a break that occurs before it.

In enum `case` arms, `#through;` explicitly falls through to the next arm; it is an opt-in branch transition, not the default behavior to assume for every case. `#char "x"` converts a one-character literal to a character value and is used where byte/character values are expected. The examples also use `#no_context` on procedures that must not receive the implicit context; treat this as a signature/call contract rather than a runtime override.

`for` has range and iterable forms. The iterable form exposes `it`, optional `it_index`, and optional named loop variables. Reverse iteration uses the `<` prefix in the examples. Pointer iteration is also demonstrated. Custom `for_expansion` hooks can alter iterator behavior; see the metaprogramming page. The samples show ranges with inclusive-looking `a..b` behavior in the basic lessons, and some contexts use upper-bound arithmetic such as `0..count-1`. Because empty and reversed range behavior is not uniformly explained, verify exact boundary semantics before encoding them as a parser-wide assumption.

An additional comma-comma argument-list form (`callee(args,, field=value)`) applies temporary context overrides for that call. It is shown as shorthand for temporarily changing allocator or logger context values; the override lifetime ends with the call. Logging uses a context-selected callback, opaque callback data, and message metadata. This is a callback convention built on context, not special control-flow syntax.

Operators include arithmetic, comparisons, bitwise operations, logical `&&`/`||`, unary `!`, and compound assignment. Operator overloading is demonstrated for user types, including array operations. Precedence follows the examples, but obscure combinations should be checked against direct corpus cases or compiler behavior.

## Struct composition and tagged data

Structs, arrays, unions, and enums are described on the core types page. Here the important procedure interaction is that `using` can promote members of a contained field into a containing scope, and struct members can be addressed by name. A `this`-style parameter is shown as explicit shorthand for code that operates on an object; it is syntax/parameter behavior, not evidence of implicit methods or dynamic dispatch.

## Context and allocation

The implicit `context` is a dynamically supplied environment carrying allocator and other execution state. The lesson demonstrates replacing context values in a lexical region and using custom allocator procedures. A context override affects operations performed while it is active, including library code that consults the implicit context; it is not a global mutable singleton.

Memory is explicit. The lessons show default allocation, temporary storage, resizable arrays, pools, and manual `free`. Temporary allocations survive for the relevant temporary-storage lifetime and are useful for short-lived strings or scratch work; values returned from temporary storage can outlive the storage only if the caller ensures its lifetime. Heap allocations require a clear owner and cleanup. `defer free(...)` is the recurring structured-cleanup pattern.

An allocator is represented in the lesson as a procedure plus data pointer, with a mode indicating operations such as allocate, resize, free, lifecycle, and heap creation/destruction. Allocation may return null when storage cannot be provided; misuse may be treated as a hard allocator error. This protocol is a runtime API contract rather than syntax.

The `#no_reset` lesson demonstrates globals whose initialized contents are preserved across runtime resets/initialization cycles. That is a specialized lifetime behavior, not a substitute for ordinary initialization. Its exact interaction with multiple workspaces, target startup, and repeated compiler runs is not settled by the lesson alone.

The stack-trace lesson describes optional per-procedure linked stack nodes controlled by build options, useful for instrumentation. Inline assembly uses `#asm` blocks with typed operands/register names and instruction-selection rules; the lesson is specifically x86-64 oriented and warns that registers declared inside a block are visible in its surrounding scope. Assembly syntax is target-specific and belongs in the compiler asm documentation as well as this language-level inventory.

## Implementation checklist and uncertainty

- Preserve multiple return values as a calling convention/language construct; do not silently wrap them in an aggregate.
- Maintain distinct compile-time and runtime branches, with declaration visibility from the selected `#if` arm.
- Model `defer` as scope-exit behavior, not a textual statement after the body.
- Keep context propagation explicit in call/runtime design even when the source omits a context argument.
- Track view and pointer lifetimes conservatively; resizing/deallocation may invalidate aliases.
- Exact order of argument evaluation, corner cases for range iteration, and complete `this` syntax are not exhaustively specified by the listed lessons.
