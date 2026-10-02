# Compiler transaction continuations

## What it is

`SuspendedCompilerTransaction` owns the uncommitted compiler effects of one suspended VM job. It preserves staged workspace identities, inputs, settings, diagnostics, and console output while genuine child work advances in an isolated preview.

The driver also retains typed compiler interception queues and source effect replay state under the same job. Source `#run,stallable` consumers must keep the actual VM continuation and restore its full `SourceOrigin` before resuming.

## How it works

`CompilerSession::suspend_transaction` removes the active transaction from the session and returns an opaque, non-clonable checkpoint. Its `CompilerJobId` stays unchanged across repeated suspension and resumption. The committed session still exposes only its original workspaces and output.

`preview_transaction` applies the checkpoint to a private logical-session clone. A scheduler can inspect the child's actual source and resolve it there. The preview is bound to both the session and the suspended job; an unrelated clone cannot replace it.

`resume_transaction` restores the original staged transaction. `resume_transaction_with_preview` instead incorporates the actual child preview as private prepared state. Later parent requests see that prepared state, including child-created workspaces and settings. Only `finish(true)` publishes it. Rollback, a rejected request, or dropping a parked checkpoint discards the speculative child state and output.

A committed session mutation while a job is parked invalidates its preview and checkpoint. Resumption fails explicitly rather than overwriting newer state. Preview completion requires no unfinished compiler transaction, and the same console byte budget includes parent and child output.

Semantic child readiness is distinct from native completion. A checked library can support a real typechecking phase event; native output requires its actual backend and artifact work before successful `COMPLETE`. An explicit `NO_OUTPUT` recipe has no backend or artifact job. It can complete successfully after its actual source and compile-time work reach a stable fixed point with a clean workspace status, without emitting target-code or write phases.

`BeginIntercept` accepts phase-only `SKIP_ALL` subscriptions. AST and performance requests reject explicitly until their real producers exist. `WaitForMessage` returns a stable pending ticket when its job has no queued event. `poll_request` resolves that exact slot without advancing the request cursor. Events hold typed owned fields; source adapters allocate fresh VM message records.

`ReplayEffects::suspend` parks both the request stream and compiler checkpoint by full source origin, including specialization bytes. `resume` restores the same stream cursor; `begin` cannot restart a parked recipe. Child previews use a sealed replay branch. Its newly committed child traces remain private with the child effects and enter the build's completed replay cache only when the parent commits. Cancelling the parent drops both, preventing duplicate child effects after a graph rebuild.

The workspace scheduler's retained handler can service compiler dependencies after the VM parks. It resolves subscribed children in the private preview, excludes the waiting parent's own body, and supplies genuine parsed and typechecked phase events after the child inputs reach a fixed point. Repeated service without new inputs does not enqueue duplicate readiness. Retiring a child supplies terminal shutdown; a finished recipe with an explicit failed status supplies terminal compilation failure. The semantic scheduler supplies successful completion only for the explicit `NO_OUTPUT` boundary described above.

`PreparedWorkspaceJob` retains an owned compilation unit and private journals around a pinned semantic-session future. A suspended poll returns typed dependencies while preserving that future. The controller services the issued compiler tickets and polls the same job again. Its cancellation guard drops retained VM tokens before the journals and authentic source snapshot are released. See [Retained semantic preparation](semantic-preparation.md) for the preparation lifecycle.

## How to change it

The compiler checkpoint lives in `jai-driver/src/compiler_effects/parked_transactions.rs`, event subscriptions in `compiler_effects/interception.rs`, replay parking and branch adoption in `effect_replay.rs`, and child servicing in `workspace_scheduler.rs`. Extend ordinary and prepared-state request handling together when adding effects. Keep checkpoint fields private and job identities unforgeable.

VM consumers must park and restore their request recording alongside this checkpoint. They must resume the retained instruction and operand state, validate source value publication before committing, and cancel both VM and host state on terminal failure. Re-executing the recipe from its beginning is not a continuation.

## Configuration

The existing compiler session output limit applies to combined staged parent and child bytes. Replay limits count completed traces, suspended jobs, and private child traces together. Interception queues are bounded to 4,096 unread events, and source pending counts must fit the pinned `s32` field. Session identity and mutation revisions are internal invariants; callers cannot override them. Workspace scheduler input, generated-byte, workspace, and pass limits also apply while advancing a preview.

## Dependencies

The driver compiler session, typed `jai-vm` requests and responses, and Rust standard-library owned collections. Previewing compiler data executes no supplied native tools, objects, or libraries.
