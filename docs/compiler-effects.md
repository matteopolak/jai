# Compiler effects and workspaces

`CompilerSession` stages compiler requests from the independent compile-time VM. It stores workspace inputs, build settings, and diagnostic messages; adding an input records compilation work rather than reporting a successful compilation.

## How it works

The VM starts a transaction before execution. Requests can create or retire workspaces, add source text or file paths, set build options, and emit messages. A workspace created in that transaction is immediately available to subsequent requests, while readers see only committed workspaces. Successful execution commits the changes in request order. Suspended or failed execution discards them.

Workspace handles are opaque, nonzero identities. Rolled-back identities are never reused, so a stale handle cannot select a different workspace after a retry. Each request checks its handle against the current session. Rejecting a request aborts the whole transaction, including earlier staged messages. Starting another transaction also discards unfinished changes.

`DestroyWorkspace` stages retirement of either the root or a child. Later requests targeting that identity reject; rollback restores an existing workspace, while commit retains a tombstone and removes its inputs, settings, and failure status. The current recipe may continue requests targeting surviving workspaces and session output. Reports remain observable without resurrecting the retired origin. See [workspace lifecycle](workspace-lifecycle.md) for root retirement, scheduling, and artifact behavior.

Reports distinguish `Stop` and `Continue`. A fatal `Stop` error retains its mandatory source location inside the transaction, rejects later requests and prevents a commit even if the caller asks for one. Earlier source additions, workspace creation, options and messages roll back together. A continuable error commits the diagnostic and marks its originating workspace as failed. `Stop` with a non-error severity is an invalid request and aborts the transaction.

`WorkspaceStatus` is `Ok` or `Failed`. Status changes commit in request order: setting a workspace back to `Ok` clears its retained error, while a later error fails it again. Recovery does not clear another workspace's failure. `error()` reports a retained failure while any workspace is failed, even after messages are drained. An explicit `Failed` status supplies a diagnostic when no error report exists. Fatal transaction failure cannot be recovered by a later request in that transaction.

The source scheduler supplies an opaque `SourceOrigin` with the actual workspace. Replay forwards its workspace identity before beginning the host transaction, without copying the origin's source bytes. Reports and messages use that identity; direct internal requests without an origin use the root workspace. Unknown or cross-session origins reject the transaction. The origin is consumed once, so a subsequent internal transaction cannot accidentally inherit it.

`WriteOutput` preserves arbitrary bytes and a typed standard-output/standard-error stream. It buffers output inside the same transaction; rollback discards it. The driver drains committed events with `take_outputs()` and writes them in request order, without interpreting bytes as UTF-8 or printing from the VM itself. Effect replay does not duplicate committed writes.

The driver reads `BuildWorkspace::inputs()` and `settings()` to schedule compilation and consumes committed messages with `take_messages()`. This boundary performs no file reads, linking, or native execution. [Workspace scheduling](workspace-scheduler.md) loads those inputs into actual graphs, and [source compiler bindings](source-compiler-intrinsics.md) validate the supported source declaration subset. These internal requests do not establish compatibility with the complete supplied Compiler API.

## How to change it

Add a typed `CompilerRequest` and its VM intrinsic adapter in `jai-vm`, then handle it in `jai-driver/src/compiler_effects.rs`. Preserve transaction visibility and rollback behavior. Keep external work behind a driver scheduling step: returning `Ready` means a request was staged, not that its resulting program compiled.

The supplied `Workspace` alias uses `s64` and supports a current-workspace sentinel. The VM's internal nonzero handles require an explicit source ABI adapter; do not pass a negative sentinel directly to the internal handle constructor.

## Configuration

`SetBuildOptionAt` retains the actual caller location with an option. After commit, `BuildWorkspace::option_origin(BuildSetting)` returns the latest location for that setting; rollback does not publish it. A later ordinary unlocated update clears its previous origin. The origin map stores at most one entry per setting rather than an unbounded history. Source adapters validate the complete projected record and location before submitting any option requests.

`BuildSettings` preserves every bitcode and machine optimization level in typed enums, an optional output path, and an optional parsed target triple. Output kind, runtime-support selection and crash-backtrace selection are separate enums; defaults follow the source Compiler declarations: executable, automatic runtime support and enabled crash backtraces. Source enum adapters validate the actual member values before submitting typed requests. Preserving a setting does not itself implement its output artifact; the scheduling/backend boundary must honor it or report a precise unsupported operation.

The older Boolean request maps to `O2`/`Default` or `O0`/`None`. Target triple structure is checked by the VM; target availability and ABI support belong to the backend. Paths are typed `PathBuf` values and must be nonempty. File existence and source diagnostics belong to compilation, so adding an input does not read it eagerly. Located input and report requests preserve their source locations. Draining messages does not alter workspace status; recovery requires an explicit status change.

Pending compiler output is capped at 16 MiB per session by default. `CompilerSession::with_output_limit(bytes)` sets an explicit limit; zero disables nonempty output. The cap covers committed, undrained events and the active transaction together. Exceeding it rejects the entire active transaction. Draining output releases its budget; arithmetic overflow in byte accounting also rejects the transaction.

## Dependencies

This component implements `jai-vm::CompilerEffects`. It uses the standard library for workspace storage and paths and does not depend on LLVM or any reference executable.

Workspace identities come from a process-wide monotonic allocator bounded by the signed source handle representation. Separately allocated sessions cannot accept each other's handles, and rollback does not recycle identities. Committed and transaction maps retain `WorkspaceId` keys rather than converting identities to raw integers. Membership and staged tombstones are checked before each targeted request. `CompilerSession` clones preserve the same logical identity for an internal atomic host-commit shadow; cloning does not allocate an independent session or allocator.
