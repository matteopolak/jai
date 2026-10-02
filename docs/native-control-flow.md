# Native branch and loop emission

## What it is

LLVM emission follows the actual native control flow after constant and execution-phase branch selection. It preserves evaluated condition effects and emits one terminator for each basic block.

## How it works

Native selection can prove a branch result even when its executed operands have effects. For example, `bump() || true` selects the first arm but still calls `bump()`, whereas `true || bump()` skips that call.

The generator stops emitting a source block once its current LLVM block has a terminator. Unknown `if` arms create a join only when an emitted arm actually falls through. Loop latches and implicit void returns also check the emitted terminator; source `Flow` alone cannot describe branches pruned for native execution. A provably false loop evaluates its condition once and omits its body.

## How to change it

Keep selection proofs in `jai-codegen/src/execution_phase.rs` and actual LLVM block handling in the generator. Extend reachability and emission together when adding a phase-dependent statement. Conditions must retain their source evaluation order, including bound loop values and short-circuit effects.

Test selected returns inside unknown branches, side-effecting conditions, loop returns and void fallthrough. The native fixture suite includes the fingerprinted corpus short-circuit regression and executes fresh generated programs.

## Configuration

The native phase treats `#compile_time` as false; the VM evaluates it as true. LLVM optimization can further simplify generated branches, but control-flow validity must hold before optimization.

## Dependencies

Checked `jai-ir` control flow, execution-phase selection, LLVM's builder and module verifier, native reachability, and independently installed Clang for execution tests.
