# Workspace source scheduling

## What it is

`WorkspaceScheduler` loads committed compiler inputs into real `ModuleGraph` instances and checks a separate library for each workspace. Its results describe checked source programs; this component emits no native artifact and invokes no external executable.

## How it works

Construct the scheduler with the physical root path, configured module search directories, and an explicit `BuildTarget` plus the corresponding backend `TargetTriple`. Pass one `CompilerSession` to `resolve`. Each round snapshots its committed workspaces, inputs, and settings. The root graph retains the original program, with generated `#load` directives appended through `SourceOverlay`. Child workspaces start with their own virtual root and inputs. Generated strings become stable virtual files; physical file inputs use the ordinary loader's parsing, scopes, imports, canonical deduplication, and diagnostics.

Source recipes execute through the checked Rust VM. If a recipe commits new inputs or settings, the driver rebuilds graphs before publishing results. A recipe may provide a declaration needed by a runtime body; its first incomplete graph can produce a diagnostic, but the driver retries against the newly committed sources. An unchanged graph must fully pass semantic validation. Empty child workspaces return `AwaitingInputs`; they are not described as compiled programs.

`resolve_resumable` returns typed `SchedulerReadiness::Pending` when an actual stallable source continuation has no readiness yet. The scheduler retains its owned compilation unit, semantic arenas, worklist, VM continuation, private compiler/replay journals, round position, and earlier checked workspace results. Another call drives that exact job. It never reloads the pending graph or starts the source body again. `resolve` remains a convenience wrapper: pending becomes the typed `SchedulerError::Pending`, and the job stays retained until another drive, `cancel_pending`, or scheduler destruction.

Compiler dependencies advance subscribed child work in a private preview. Actual parsed and typechecked phases wake the waiting source. An explicit `NO_OUTPUT` child finishes at its clean source and compile-time fixed point; a native-output child requires its backend completion receipt. Child effects and replay traces publish together with the waiting run's validated result. The scheduler cannot invent readiness for an empty child or an unfinished backend job.

The retained controller currently covers root discovery and body preparation. Child preview checking still uses its synchronous resolver: a child that cannot service its own external dependency needs an additional retained child stage. Native backend completion receipts are also not wired into interception yet, so a parent waiting for a native child's successful `COMPLETE` remains pending. A stable child semantic error currently aborts preview checking; converting that actual terminal failure into a completion event is a separate scheduler step.

A committed compiler-session revision change while a source job is pending rejects resumption and cancels its private checkpoint. This prevents a retained preview from overwriting newer inputs, settings, output, or diagnostics. `cancel_pending` discards the live source continuation synchronously and retains the previously committed session state.

Graph loading also uses [semantic source discovery](semantic-source-discovery.md). Deferred source conditions run against genuine checked declarations, and their boolean decisions resume the same graph discovery process. Discovery and final library resolution share the compiler session and replay cache; a condition cannot duplicate committed recipe effects when the graph is rebuilt.

Each rebuild creates a fresh type registry. `ReplayEffects` therefore caches typed request/response data rather than semantic values or arena identifiers. A source origin contains the workspace, canonical source path, directive span, exact directive bytes, a digest, and canonical specialization bytes. Exact bytes participate in equality, so a digest collision cannot identify edited source as the same recipe. Source binding supplies that identity immediately before VM execution.

A repeated recipe must produce the same ordered request stream. Responses preserve the original chronology, including transaction-visible settings snapshots and workspace identities. Missing, changed, or extra requests reject the whole replay before VM memory is published. Committed compiler mutations are not applied twice. Failed or suspended transactions never enter the cache. Pure runs remain free to reevaluate in each graph's new registry.

Physical root and dependency bytes are frozen for the scheduler's session. Changing a source between rounds or subsequent `resolve` calls produces `PhysicalSourceChanged`; create a fresh scheduler and `CompilerSession` for edited source. Reusing this scheduler with another session is rejected. Generated paths cannot shadow existing physical files.

Relative file inputs resolve against the root program's directory. Located file requests resolve against their supplied filename's directory. Generated source files live virtually beside the root, so relative imports and loads retain a stable project base. Their graph diagnostics identify the virtual file; the original request location remains available in `BuildInput::SourceAt`.

## How to change it

Graph rebuilding and round retention live in `jai-driver/src/workspace_scheduler.rs`, the pinned owned job controller in `workspace_job.rs`, and transaction replay in `effect_replay.rs`. Extend typed request models in `jai-vm` and the handler in `compiler_effects.rs` together; include dynamic payloads in replay memory accounting. Keep cache publication after successful host commit, and validate stream completion before committing VM memory. Never cache `TypeId` or `ProcedureId` across graph rebuilds. A pending job keeps its original registry alive instead of rebuilding it.

Supporting another target triple requires selecting its actual layout, byte order, source platform facts, and backend before constructing the scheduler. A source override that differs from the configured triple currently produces `UnsupportedTarget`; it does not compile against the wrong target. Optimization and output-path settings are preserved in each checked result for the artifact-producing caller.

The retained root source job includes discovery before library preparation. An owned `PreparedGraphJob` keeps its source provider, graph, semantic guard, and private journals across a pending source condition, case, or using request. Completion transfers the same journals into the body-binding stage. Both stages use the same base revision check and synchronous cancellation boundary; neither advances a graph that still owns a VM checkpoint.

## Configuration

`SchedulerOptions` supplies target facts, module-independent VM limits, `SchedulerLimits`, and `ReplayLimits`. Default scheduling bounds are 128 rounds, 256 workspaces, 10,000 inputs, and 64 MiB of generated source. Default replay bounds are 10,000 committed recipes, 10,000 requests per recipe, and 64 MiB of recorded payloads. Reaching a replay limit aborts the transaction before its compiler changes commit. These bounds complement per-VM fuel and allocation limits.

`new_with_bootstrap` accepts `BootstrapOptions` for automatic Preload and Runtime_Support source modules; `new` keeps bootstrap disabled. Each graph reload preserves the configured source selections and derives Runtime_Support parameters from that workspace’s committed output kind, runtime support mode, and backtrace policy. A changed setting therefore affects the next graph pass before its checked library is published.

## Dependencies

The scheduler uses `jai-modules::SourceOverlay`, `jai-lexer` source decoding, `jai-sema::ResolveOptions`, `jai-vm::CompilerEffects`, and the driver `CompilerSession`. It uses only standard-library filesystem reads and in-memory generated files. The supplied compiler, linkers, libraries, and objects remain static reference material.

## Workspace status

Compiler reports and `compiler_set_workspace_status` update the addressed workspace’s committed status. The scheduler checks failed workspaces at the final stable snapshot, after all workspace recipes have had an opportunity to run. This lets a newly created child recover with `.OK` even when the parent marked it `.FAILED`. Fatal reports and VM failures still roll back their transaction immediately, and semantic errors prevent publication of the checked library.

Committed [workspace destruction](workspace-lifecycle.md) removes the workspace from subsequent rounds. A recipe retiring another workspace prevents that workspace’s queued job from starting later in the current round. Results are rebuilt each round, so a retired workspace cannot leave a stale checked artifact plan. The root identity remains the session identifier even after root retirement; surviving children resolve independently. Retiring every workspace produces an empty successful plan.
