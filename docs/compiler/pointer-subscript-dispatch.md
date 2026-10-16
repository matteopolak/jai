# Pointer-subscript receiver dispatch

The reviewed Bucket_Array contract declares a by-value generic receiver:

    operator *[] :: (using array: Bucket_Array, index: int) -> *array.type

This establishes an operator call, not an exception for a particular container.
The independently authored Storage tests use different names and storage.

## Independently reproduced defects

On the approved frozen603 compiler baseline, a local pointer to a generic record
was addressed a second time before pointer-subscript dispatch. The resulting
double pointer failed the struct receiver gate, so reads and writes instead
indexed raw record memory. A by-value temporary record was excluded from pointer
dispatch completely. The direct address form maintained another normalization
path, accepted nonpointer results, and could evaluate builtin fallback operands
twice when an unrelated pointer operator was in scope.

Ordinary generic record locals, extra integer/bool generic parameters, promoted
members and public module imports already worked in the initial controls. These
passing controls invalidate the initial hypothesis that every by-value generic
receiver failed; normal procedure calls can dereference a struct pointer.

## Implementation

The expression checker shares pointer-getter normalization between ordinary
indexing and explicit address-taking. Pointer-valued operands are loaded as
pointers; addressable records retain their address for normal pointer/by-value
parameter conversion; computed records retain their value. A selected pointer
getter must actually return a pointer, whose pointee forms the element place.

Address-taking gives the pointer getter priority over an ordinary value getter.
If builtin indexing applies instead, it uses the already checked operands.
Normal argument binding continues to validate the index and result.

Receiver filtering in try_index_operator_overload reuses the existing
first_param_accepts predicate, now shared with indexed setters. The predicate
recognizes implicit generic record patterns and normal fixed-type conversions.
Polymorphism elsewhere in a header does not turn its fixed receiver into a
wildcard. An unrelated lexical overload does not hide builtin pointer indexing;
a matching receiver with an invalid index still fails normal binding. No errors
are suppressed to choose a fallback, and no overload ranking or generic call
binder is replaced.

Operator visibility stays lexical. Importing a canonical type alone does not
import the defining module's operators. The original filtered facade regression
exports Storage and operator*[] together, while a type-only facade must reject
indexing. No operand home-scope lookup or private export leakage is restored.

## Verification and scope

Fifteen original core regressions cover generic receiver values/pointers,
temporaries, using-promoted paths, read/write/compound write/address identity,
type queries, ordinary getter priority, exact-once fallback, filtered reexports,
builtin pointer indexing, implicit generic setters and invalid arguments/results.
The core library, module and generic-pointer suites also pass (169 + 52 + 7
tests). Backend/LSP/lint library suites pass (56 tests).

Three original CLI fixtures execute successfully in the interpreter, emitted
native ARM64 O0/O2 executables and wasm64-unknown-wasi modules through Node
v24.12.0's real WASI provider. Strict host/WASI lint, formatting and warnings-denied
Clippy pass. An initial wasm32 target request correctly rejected the unsupported
pointer width; that receipt is retained and does not count as a WASM pass.

All execution uses the owned source build and exact frozen603 stdlib/native
prerequisite receipt. This is not a current60d integration result or a full corpus
pass. The requested exact current60d safe snapshot/source receipt was not supplied
during this checkpoint; integration must compare and replay the narrow source
patch on its current baseline before treating that candidate as verified.

## Separate public-export dependency

The approved frozen603 NEW Bucket_Array public facade has no operator*[] export.
A tiny source importing that facade therefore still rejects indexing. This is
separate from the independently proven receiver defects, and it was reported to
the stdlib owner without modifying producer code. The current60d facade and the
actual reflector failure need replay once its approved source/export handoff is
available. Type-home-scope lookup is not an acceptable workaround.

## Handoff

Only production functions in sema/expr.rs, sema/calls.rs::
try_index_operator_overload and sema/stmt.rs::first_param_accepts change. The
ownership requests were recorded in the worker inbox before editing; the LSP-owned
check_call, procedure ranking, struct overrides and runtime files are untouched.
All captures/builds remain in the compiler T7 namespace. The memory-boundary
investigation stays suspended.


## Current shared integration

The [current integration receipt](../status/shared-pointer-subscript-checkpoint.json) applies only the exact fb7 source hunks to60d while retaining569public-symbol filters. Independent current regressions show8pass/7fail before,14pass/1fail with the exact patch, and82pass after changing the stale producer filter string operator*[] to the reviewed public symbol *[]. Positive and type-only privacy assertions remain intact; no lookup fallback or compilerfilter change is introduced. Seven standalone fixtures received formatter whitespace only. Current execution scope is Rust/Core focused tests; native/interpreterCLI/WASIproducer passes remain qualified until root runs the new pin. Current Bucket_Array also lacks the internal body, so an export alias alone cannot repair its reviewed functionality. Owner handoff must supply both real occupied-slot indexing and canonical filtered reexport.
