# Compiler integration requests, refresh21

Only independent sources/specs and filtered coordination are inputs. The full
production-tree workspace command is:
`LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_STDLIB="$PWD/stdlib" cargo test --locked --workspace --all-targets --no-fail-fast`.
Refresh20:792 aggregate passes,16 failures,one inherited ignored test,91 result
summaries across four failed targets. Full failure evidence remains in ignored
artifacts/integration-clean/workspace-refresh20.log.

## General compiler defect ready for implementation

`tests/compiler-semantics/forward-enum-dependencies.jai` is a minimal original
reduction: enum MASK refers to the later explicitly valued LAST and rejects
unknown identifier. Reviewed Socket AI.MASK on macOS/Android requires the same
mechanism. Collect declarations and resolve dependencies while preserving implicit
numbering/reflection order, inserts/conditionals, duplicate/cycle/range errors.
Do not reorder declarations or substitute public constants as a workaround.
Command: `JAIC_STDLIB=stdlib target/debug/jaic -check tests/compiler-semantics/forward-enum-dependencies.jai`.
Red log: artifacts/integration-clean/forward-enum-red.log.

## General compiler defect repaired here

Canonical preloaded `get_current_workspace :: () -> Workspace #compiler` was
declared by the reviewed Preload API but omitted from MetaOp dispatch, which
recognized only its private transport name. Both now use the same CurrentWorkspace
operation; no module/path exception or public API added. Original empty-workspace
native test and a new identity fixture (global/procedure-local #run, unique empty
children, no invented numbering contract) pass interpreter/native. Preserve this
when merging the queued raw-pointer/default-binding checkpoints.

## Remaining classified failures

- jai-wasm lib1 and CLI sandbox-thread1: old tests import native-only Thread on
  WASM. Preserve cooperative compiler scheduler assertions through independent
  compiler protocol tests; do not invent a WASM Thread facade or relax its guard.
- CLI default-metaprogram1: reviewed Default_Metaprogram module is missing,
  portable ownership. No replacement stub.
- CLI ignored-build-options1: alternate X64 backend now correctly rejects rather
  than emits an ignored-option warning. Separate the strict unsupported-backend
  oracle from valid intercept/ERROR_CONTINUABLE coverage. Natvis/raw LLVM option
  forwarding/diagnostics must still be audited, not dropped to make it pass.
- Native interpreted-threads1: retained legacy fixtures assume bool thread_start,
  bool synchronization init, thread_destroy/Native_Thread_Proc and extra record
  fields absent from reviewed Thread. Migrate valid contention/context/wake
  behavior to reviewed APIs; retire only unsupported misuse contracts with
  per-assertion reasons. New production lifecycle50-case matrix is independently
  passing, not a substitute for missing remaining contention coverage.
- Native fiber-stack1 and WASI formatter2: unchanged Extensions Io/Args depend
  on unreviewed Basic.free(ptr,allocator)/WASI exit. Preserve Extensions and public
  Basic APIs. A proper permitted dependency architecture/review is needed;
  extra exports or module-specific compiler rewrites are forbidden.
- Native C ABI1: legacy macOS addrinfo expectation is outside Socket's reviewed
  public platform availability. Retain genuine SDK ABI comparisons; use legitimate
  private native-boundary tests where appropriate, not surrogate public records.
- Native WASI tour1: native-only Thread dependency in our example. Public corpus
  remains unchanged/opaque. Separate supported example/platform behavior from
  compiler scheduler tests without inventing standard-library exports.
- Target-ledger1: many source-check outcomes differ. Do not wholesale bless the
  current baseline; classify missing APIs/compiler errors/platform diagnostics.

Five native failures are repaired and individually reverified: allocation/ABI
batch, Windows runtime fixture, piped stdin, empty workspaces, stack traces.
Thus11 original failures remain by classification; a new full run must measure
that count rather than treating subtraction as final execution evidence.

## Safe input synchronization

The filtered mailbox approves compiler f92f10e9 and bindings78d73e86, but these
objects are not yet available here and current refs still point to compiler093712a
and bindings2a18c3c. Please refresh sanitized refs. SDL3b4d6859 and WGL3ced6c4 are
now integrated through reviewed CI2fa2bc2. No fetch, peer checkout access, raw CI
vendor log access, push or publication is performed by this worker.
