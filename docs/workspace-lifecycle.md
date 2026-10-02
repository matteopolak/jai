# Workspace lifecycle

`compiler_destroy_workspace` retires a workspace through the compiler session’s atomic effect transaction. The scheduler publishes checked plans only for surviving workspaces, and the native caller emits no artifact for a retired workspace.

## How it works

The source catalog requires an explicitly marked Jai declaration with one signed workspace argument and no result. The adapter maps `-1` to the current workspace and sends a typed `DestroyWorkspace` request. The host checks session ownership and records retirement in request order. A staged retirement is visible to later requests in that transaction: input changes, option reads/writes, status changes, and a second destruction reject the retired handle. Rejection rolls back the complete transaction. Public workspace inspection changes only after successful commit.

Committed retirement removes source inputs, build settings, option origins, and retained failure status from the live workspace map. A separate tombstone preserves the invalid identity. The process-wide monotonic allocator never reuses identities, including IDs allocated by rolled-back creation. Creation and destruction may share a transaction without exposing a transient compiled workspace.

Root retirement is supported. `CompilerSession::root()` remains the logical session identity, while `workspace(root)` becomes absent. Surviving children retain their own inputs and graphs. Retiring all workspaces is a successful empty build plan and creates no artifact; an existing output file is preserved.

Retirement stops future jobs, rather than aborting the running recipe. That recipe may still create workspaces, write session console output, and send requests targeting surviving children. Reports remain in the session message queue even after their originating workspace retires, but its failure no longer participates in the final status check. Fatal reports still stop and roll back the transaction. A later transaction must originate from a surviving workspace; the default root origin cannot start a new transaction after root retirement.

The unchanged Compiler source declares `compiler_destroy_workspace(w: Workspace)` without a documented root exception or further lifecycle behavior. The rules above are this implementation’s explicit supported policy, not a claim that undocumented behavior was verified by running the supplied compiler.

The scheduler checks live membership before starting each workspace job, and rebuilds the output map on every round. Retirement therefore cancels a later queued job and cannot leave a stale checked plan from a previous round. A workspace retired while its source is being resolved is omitted after the next committed snapshot; its unpublished diagnostics do not fail surviving workspaces. Historical source-origin replay preserves already committed create/destroy responses without reallocating or mutating workspaces again. A new request using the retired handle still rejects.

## How to change it

The typed request and source adapter live in `jai-vm/src/effects.rs` and `effects/source.rs`; the catalog signature lives in `jai-sema/src/modules/compiler_intrinsics.rs`. `jai-driver/src/compiler_effects.rs` owns staged and committed tombstones, and `workspace_scheduler.rs` filters live jobs and checked results. Extend these together when adding more lifecycle requests. Keep all target checks transaction-visible, and recompute final status from surviving workspaces after commit.

Lifecycle regressions cover atomic rollback, stale reads/writes, root retirement, independent children, failure removal, replay, and queued-job cancellation. CLI tests additionally verify that retired workspaces cannot create or replace output files.

## Configuration

No environment variable enables destruction. It requires a checked source `#compiler` binding and the normal compiler effect service. VM fuel and scheduler bounds still apply to recipes that create and retire workspaces. `CompilerSession::is_destroyed` reports committed tombstones; `workspaces` iterates surviving workspaces only.

## Dependencies

This feature uses `jai-vm` typed effects, `jai-sema` source binding, the driver compiler session, replay cache, workspace scheduler, and the CLI artifact planner. It adds no dependency and does not load or execute supplied native tools or objects.
