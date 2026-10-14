# Ordered variadic packs and binding-time interfaces

Variadic slots retain scalar and spread segments in source order. One spread
keeps its ordinary view; mixed segments are converted to the element/view type
and packed in caller storage. Length arithmetic is checked before allocation.
Baked packs read current compile-time memory, preserve relocations and share
the existing content-keyed constant storage. Runtime C variadic spreads diagnose
an unknown ABI arity. A spread followed by fixed positional parameters retains
that parameter boundary; named variadic segments remain available explicitly.

Dynamic IR stack allocations last until the procedure returns. Interpreter
allocations use its checked frame stack; LLVM uses array alloca. WASI continuation
rewriting instead allocates on the persistent thread frame stack, checks its
limit and records the dynamic top for rewind. This retains packs while suspended.

`$T/interface Contract` validates a concrete structure at binding time, including
unused module parameters. Required fields and static declarations must exist;
each required procedure overload needs a compatible implementation with the
same procedure type and macro category. Extra members/overloads are accepted.
Procedure, struct and module type-value bindings pass the represented type to
validation. No particular library or member name is special-cased.

Original tests: `cleanroom_variadics` in core and LLVM, and
`cleanroom_interfaces` in core. Backend tests execute native and WASM64 code at
O0/O2, including a simulated continuation unwind/rewind with real frame memory.
The focused WASM harness provides real memcpy; production runtime integration
and the unchanged public corpus remain coordinator gates. Interface parameter
names/defaults are not structurally compared because the reviewed interface
contract has not specified them; full procedure type/ABI is compared.
