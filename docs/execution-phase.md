# Execution phase predicate

## What it is

`#compile_time` reports the phase executing a procedure: compile-time VM execution observes `true`, while generated native code observes `false`. The source procedure retains one typed body; resolving its syntax does not replace the predicate with a global build-time constant.

## How it works

The authoritative source example is `reference/modules/Runtime_Support.jai:455`, where an ordinary `if #compile_time` calls `compile_time_debug_break` in the compiler and retains a real native debug-break branch. `reference/modules/Bindings_Generator/module.jai:689` similarly selects compiler or runtime argument providers.

The typed boolean leaf is evaluated by the execution engine. A `#run` result can capture `true` as an ordinary constant, while a later native invocation of that same source procedure still observes `false`. Native reachability and lowering must select phase-known branches before attempting to lower compiler-only calls; a later LLVM optimization cannot repair an already rejected call.

The native proof distinguishes an effect-free boolean value from a condition whose result is known but whose executed operands still have effects. For `increment() && #compile_time`, native code must run `increment()` once before choosing the false arm. A skipped short-circuit operand is never emitted merely to prove a result.

Source control-flow proofs cover both execution engines. A phase-selected native return can therefore terminate an LLVM block that the source proof still considers open for VM execution. Native lowering checks the actual LLVM terminator before emitting later statements, joins, loop latches, or procedure epilogues. Reachability applies the same phase-aware block termination rule, including `#through` case chains, so a compiler-only call after a native return does not become a spurious runtime dependency.

Native loop completion uses the same typed control analysis in reachability and emission. A `while` whose condition is proven native-true has no continuation unless a reachable `break` targets that exact checked `LoopId`. Inner-loop breaks are consumed by the inner loop; a break to an ancestor remains visible to that ancestor. Phase-selected `if` branches and earlier returns or continues exclude unreachable breaks, while unknown conditions retain both paths. Integer loop tests and range bounds remain conservative. Cleanup bodies cannot transfer to the surrounding loop: the IR verifies their loop scopes separately.

For `while tick() || !#compile_time`, native code still evaluates `tick()` on every iteration before entering the body. When no break can finish the loop, its unused LLVM end block ends in `unreachable`; later compiler-only calls are neither demanded nor emitted. The VM independently observes the phase predicate as true and executes its own continuation. Tests exercise both engines, reachable and ancestor-target breaks, condition effects, and O0/O2 native noncompletion. Infinite native fixtures are freshly compiled test programs observed for 40 ms and then killed and reaped; no unbounded test execution is used.

## How to change it

Phase-specific boolean proofs live in `jai-codegen/src/execution_phase.rs`; scoped control summaries live in its `loops.rs` module. Keep reachability and emitted branch selection consistent: excluding an edge is safe only when lowering also excludes that call. Update the IR proof/disposal visitors, VM boolean dispatcher, pure guard walker, and native boolean dispatcher together when adding a phase predicate. Body availability metadata lives in `jai-ir/src/procedure_phases.rs` and is checked against defined sparse procedure identities at publication; do not permit a bodyless prototype to acquire source-body metadata.

Scoped immutable `Bind`/`Bound` expressions carry phase facts by the checked `ExpressionBindingId`, alongside native SSA values. Producers execute once in order before their fact is installed; an unknown producer installs an explicit unknown fact. The phase proof can inspect a bound body to choose its arm, but never treats the entire `Bind` as safe to discard. Nested scopes remove their facts on exit. Reachability visits producers before the body and invalidates reused place visitation when the scoped environment changes, so a projection reused under a different binding cannot hide a native dependency.

Expression-local proofs borrow the outer fact map and use one local overlay with undo entries. Entering a nested scope does not copy its inherited facts; lookups check the overlay and then the outer map without walking scope depth. An explicitly unknown local fact suppresses an outer known fact. A regression checks 500 empty scopes over 10,000 outer captures: one lookup, no installations, and no allocated overlay capacity.

A storage cast forwards a known phase result only when its source is a value expression and its checked source and destination type identities are identical. The cast still executes with its guards and producers. Other byte reinterpretations and place reads remain unknown to this boolean proof.

The fixtures under `jai-codegen/tests/fixtures/execution-phase*.jai` cover VM/native differences, a captured `#run` result, condition side effects, and an actual bodyless compiler debug-break intrinsic. Procedure-suffix `#compile_time` marks the retained source body `CompileTimeOnly`. This is separate from the expression predicate. Its checked identity metadata survives globals, local declarations, aliases, callbacks, and specialization; native demand rejects any reached identity, while VM calls execute the ordinary verified body. All-body native library publication omits these bodies, but an explicit publication root or a stored procedure address still counts as native demand. The contract does not alter the callable ABI or synthesize a constant result. Authoritative evidence includes `Basic/module.jai:230`, `Compiler/Compiler.jai:1072`, and the reflection cast explanation in `how_to/170_modify.jai:320`.

## Configuration

The native integration tests use the shared [installed Clang selector](native-test-tools.md), including `JAI_RS_CLANG` and the trusted LLVM 22 prefix. Run them with `cargo test -p jai-codegen --test execution_phase`; parser and metadata contracts have focused `jai-syntax` and `jai-ir` tests.

No environment variable chooses the predicate's value. The executing engine determines it. A source `#if` runs during semantic selection; use an ordinary runtime `if` when the retained procedure needs different VM and native branches.

## Dependencies

`jai-types::ProcedureExecution` supplies canonical body policy. `jai-syntax` supplies the directive expression and procedure attribute. `jai-ir` retains the typed boolean leaf. `jai-vm` determines compiler execution behavior, including real compiler intrinsic effects. Native lowering and reachability share the execution-phase proof; the compiler intrinsic catalog retains actual source fallback bodies.
