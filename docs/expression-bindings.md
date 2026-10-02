# Expression bindings

## What it is

Expression bindings retain immutable typed values inside one expression. They support source forms that reuse a value or assemble nested fields while evaluating their explicit producers once in written order.

## How it works

`ValueExpr::Bind` contains an ordered vector of `(ExpressionBindingId, ValueExpr)` producers and a body. A producer can read earlier captures. `ValueExpr::Bound` reads an installed capture with its exact canonical type; the scope ends when the body finishes. This creates neither a source name nor mutable storage.

The identity includes the actual owning `ProcedureId` and a capture ordinal. Semantic allocation shares ordinals through `MetaContext` so child resolvers and retries do not collide. `Resolver::expression_owner` retains explicit source ownership; a genuine compile-time context supplies its own reserved owner. `None` denies allocation even if a preview retains a compile-time context for lookup. Scratch enum and header resolvers cannot authorize captures from a guessed procedure ordinal. An anonymous procedure body uses its own source context and owner; the enclosing context owns only the eventual outer call.

The IR verifier checks each producer before installing it, rejects active duplicate identities, forward reads, escaped reads, wrong owners, and wrong types, and restores its capture environment on success or error. Procedure verification uses the actual procedure identity. Owned root expression and call APIs take the real semantic compile-time owner explicitly; ordinary root APIs remain ownerless. A root owner need not have an executable body or signature: constant and file jobs have real reserved semantic owners.

Scalar wrappers reuse the same typed value nodes, preserving integer widths, float bits, pointer provenance, and nominal aggregate identities. Consumers evaluate producers before the body and keep conditional arms lazy. Compiler-phase facts must remain scoped to the captures that establish them; revisiting an indexed place under different captures requires a new demand analysis.

Native lowering keeps actual LLVM values in a procedure-local SSA map and removes only the current scope on success or a lowering error. Pointer values, aggregate snapshots, and raw float bits keep their existing representations. The phase consumer uses a borrowed outer environment plus a mutable overlay with undo entries; entering a scope does not clone all existing facts, and an explicit unknown fact shadows an outer known value. Captures inherit the enclosing statement debug location.

The VM's private `execute/bindings.rs` ledger moves complete `Value` carriers into ordered lexical scopes and caches their full value-cell charges. Projected pointer paths, address-integer provenance, raw float bits, and stored aggregate images remain intact. Nested procedure invocations can shadow the same binding identity, and closing the exact scope restores the enclosing value. Tokens retain environment identity, monotonic generation, and depth; out-of-order, stale, and foreign closes fail without removing captures. Cancellation clears the ledger.

Global initializers remain checked `ConstantValue` trees. `is_static_value` alone cannot justify moving a producer: an integer expression classified as static may still trap. Source construction captures explicit runtime initializers conservatively and omits only already checked immutable constant values.

The static-backing classifier keeps active capture identities in a hash set and a separate scope undo stack. Each producer becomes visible only after its classification succeeds, and closing a scope removes only identities installed by that scope. This keeps a full 65,536-capture vector from repeatedly scanning every earlier capture. Classification remains conservative admission for constant backing; it does not replace the verifier's owner and exact-type proof.

## How to change it

`jai-ir/src/expression_bindings.rs` owns capture identities; `verify/expression_bindings.rs` owns lexical proof and restoration. Node payloads live in `expressions.rs`. Extend all expression walkers together, including disposal, native reachability, compiler-phase facts, procedure contracts, pure-expression admission, and both VM execution engines.

`jai-sema/src/expression_bindings.rs` allocates identities. Retain explicit ownership in every new resolver or captured source environment. Never infer a root owner from the first binding or from an arbitrary matching procedure signature.

`jai-vm/src/execute/bindings.rs` owns capture storage and scope restoration independently of source evaluation. Its focused tests cover ordered earlier reads, recursion shadowing, duplicate and capacity failures, token lifetime, and metadata preservation. The execution owner must admit a scope header before `begin`, admit the complete value plus entry charge before `insert`, and charge `clone_charge` before copying a `lookup` result. Any private branch snapshot that clones the ledger must admit its complete `cells()` charge first.

`jai-codegen/tests/expression_bindings_ir.rs` exercises the actual checked builder, VM, LLVM verifier, and trusted native O0/O2 pipeline. It covers earlier-capture reads, nested and lazy scopes, indirect callee/argument order, effectful captured phase predicates, and a projected place reused under different capture facts. `promoted_literals_native.rs` adds source fixtures for interleaved field effects, defaults, pointers, callbacks, and floating-point payloads.

The two passing CLI regressions in `jai-cli/tests/expression_bindings.rs` exercise ordinary execution and `#run`, then fresh native output at O0 and O2. Interleaved promoted-field producers run once in written order, producing state `123`; producers in an unselected conditional arm leave state at zero. Both programs return `42` through every tested path.

The IR regression suite covers sequential and nested captures, disjoint scope reuse, forward/escaped reads, type and owner mismatches, error restoration, width limits, owned call roots, and indexed-place rechecking. VM and native fixtures must additionally prove producer order, lazy branches, suspension, and the same behavior before and after optimization.

## Configuration

No source flag enables the primitive. A verified expression can have at most 65,536 simultaneously active captures; ordinary expression-depth and VM resource limits also apply. Each VM scope header and capture entry costs one cell, in addition to each complete captured value. Captures share `Limits::value_cells` with memory and continuation storage; insertion traversal and cached-copy work share `Limits::fuel`. Native tests use the shared Clang selection described in [native test tools](native-test-tools.md).

## Dependencies

The feature depends on canonical Jai types, checked IR expressions and places, semantic source ownership, procedure value contracts, typed VM values and continuations, and LLVM SSA lowering. It adds no external runtime service.
