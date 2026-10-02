# Resumable VM execution

## What it is

The continuation machine executes checked IR with an owned stack of expression, call, control-flow, cleanup, and context tasks. A pending dependency retains the exact next task and evaluated operands; it does not restart a source procedure or directive.

The continuation API is available alongside the synchronous entry points in `jai-vm`. The semantic scheduler and driver adopt it for jobs that support transaction parking. The virtual process ledger is separate: this foundation does not yet implement source `fork` or `exec` continuations.

## How it works

Only checked expression, call, and procedure proofs can become owned plans. Plans contain private typed node/block identities and immutable code. Runtime tasks capture destinations, sequence descriptors, ordered arguments, return values, loop state, SIMD registers, and lexical cleanup contexts before scheduling later operations. Lazy conditions schedule one selected branch. A pending indirect callee is checked before evaluating its arguments, matching the synchronous engine.

`start_resumable_expression`, `start_resumable_call`, and `start_resumable_procedure` return `Suspended`, `AwaitingPublication`, or `Failed`. Their `_at` forms pin a trusted `SourceOrigin`. The pinned origin is restored before resuming, cancelling, or finishing a transaction, even when a scheduler has serviced a sibling job. A suspension parks compiler/host effects without calling `finish` or repeating `begin`.

`resume_resumable` polls the retained operation after readiness changes. A pure compiler/host adapter may reconstruct its typed request prefix: the journal supplies earlier exact ready responses, and only polls its last pending request. Source expressions and previously issued requests do not run again. A changed request stream fails the transaction.

Results at `AwaitingPublication` remain uncommitted. `finish_resumable_validated` invokes the caller's result converter while the VM and its virtual storage are still available. This is where semantic conversion rejects nonportable address integers or unsupported stored values and verifies runtime `Type` identities. Validation failure, commit rejection, and explicit cancellation restore the original memory, globals, heap/file ledgers, literal/static caches, and context.

`into_continuation` transfers a suspended execution into a non-cloneable `ContinuationState`; `with_continuation` restores it against a compatible ready-provider borrow. Registry identity, global definitions, materialized alignment, context, limits, and the existing procedure-signature ledger must agree. New declarations may be appended. Ready code already admitted by the job remains owned by its plans. A detached token must be restored or explicitly cancelled with its effect handler; dropping a Rust token alone cannot call a borrowed external handler.

Ordinary `into_state` cancels an active continuation and transfers only the restored persistent state. `try_into_state` reports a cancellation-handler failure. Host-fed allocation, limit reconfiguration, and synchronous execution reject an active continuation; callers must finish, cancel, or transfer it first.

## How to change it

`execute/resumable/plan` lowers checked IR. `machine.rs` schedules tasks and owns transfers; `apply.rs` performs one operation on already-evaluated typed operands. Add a new operation to all three boundaries together. Any operation that can suspend must retain its operands and task before returning pending. Keep effectful source evaluation out of adapter reconstruction.

The public transaction boundary is in `execute/resumable.rs`; compiler/host request retention is in `effects/continuation.rs`. Drivers implement `CompilerEffects::suspend`, `resume`, and exact pending-response polling. The default hooks reject suspension, so an unsupported handler cannot silently lose staged work. Scheduler publication must use the validated finish method.

Independent checked-IR tests cover actual suspension within nested calls, argument evaluation, loops, cases, cleanup, strings, context, transfer, cancellation, and publication rollback. Process continuation branching needs a separate reviewed ownership and scheduling adapter before source POSIX capabilities can use this machine.

`machine/readiness.rs` prepares demanded storage before an action consumes its captured operands. A pending cold layout keeps the exact action on the task stack. Successful layout facts remain bounded VM state; failed traversals consume fuel without installing incomplete cache entries.

Range tasks keep their variable pointer and integer metadata in boxed loop state. Retrying readiness restores the already admitted task charge exactly; it does not charge the retained payload a second time on each poll.

The synchronous API also resolves place projection chains iteratively. It resolves the storage root first, then applies fields and indices in source order, capturing each descriptor before its index expression. The bounded scratch chain consumes traversal fuel and avoids one Rust stack frame per field.

## Configuration

The existing `Limits` govern fuel, value cells, allocations, call depth, and expression depth. Owned plans, tasks, evaluated operands, signature metadata, source-origin bytes, and retained request/response payloads are admitted before copying. Suspension does not replenish fuel. Runtime compiler/host responses charge actual payloads rather than a configured maximum response size.

## Dependencies

The engine uses `jai-ir`, `jai-types`, virtual Memory, and `CompilerEffects`. It needs no LLVM, native executable loader, or original compiler artifact. The semantic scheduler and driver own dependency jobs, trusted source origins, host policy, and final constant publication.
