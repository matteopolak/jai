# Dynamic import factory registration investigation

Independent compiler/evaluation worker, 2026-10-15. Starting checkout:
`53ecb3d3196919dbdc96f690e37536f7495edf5e`. The only additional Git content
read was the approved `4b5b60b3` stdlib dependency handoff. Reviewed contract:
`docs/specs/stdlib/modules/metaprogram-plugins.md`. No reference executable,
reference output, private implementation, quarantined integration, vendor
implementation or application source was used.

## Current result

Ordinary generated imports can register typed factories through an already
declared callback in their owning workspace. The requesting `#run` returns;
generated `#run` declarations then register the factories and invoke already
declared setup code. This is demonstrated with a computed module name, two
parameterized module instances, reverse callback arrival, ordered factory use,
real initializer/options assertions and distinct plugin object addresses.

This staged primitive does **not** implement the synchronous public
`Metaprogram_Plugins.init_plugins` contract. That facade/parser remains owned by
the clean portable worker. No replacement facade, fake factory, command-line
dispatch, new compiler primitive or language-semantic change was installed.

The separate bounded event-pump candidate fails on this compiler: no factory is
registered before its caller returns. Its reference validity is unknown. A
filtered coordinator confirmation was requested; it must not be treated as an
accepted compiler regression until that confirmation arrives. The earlier
undeclared-continuation architecture remains rejected; an independent negative
test verifies that source addition does not make such a call legal.

## Executable primitive and ownership

`tests/producer-requests/plugin-registration/registration.jai` is a private,
test-owned registrar that can be adapted by the library owner. It stores typed
factory procedure values in ordinary language storage. Generated source carries
only an integer request epoch and ordinal, never an encoded pointer. The
registration callback is declared before source generation and selected using a
real `Code` scope.

`begin_registration(count)` creates zero-initialized ordinal slots and starts a
new epoch. `register_factory(epoch, index, factory)` rejects inactive/stale
requests, negative/out-of-range ordinals, null factories and duplicate slots.
Readiness requires every expected slot, independent of arrival order. Empty
requests are immediately ready. `end_registration()` requires readiness,
releases and resets the array header, and closes the request. The runtime
protocol fixture exercises these checks across multiple epochs.

The primitive supports one active request in one lexical owning module. It is
not a concurrent/reentrant request manager, a public API, a cancellation
protocol or a general source service. Epoch arithmetic is ordinary signed
integer arithmetic; exhaustion is not handled by this small test primitive.
Production integration must define these policies before broadening its scope.

The staged test frees the computed name and generated source on return from
the producer, before registration executes. The compiler therefore must own the
queued source text. Factory values and returned plugin objects remain in the
same workspace/interpreter that owns the imported modules. The target child
workspace is assigned to each plugin only when initialization runs.

## Observed compiler boundary

The relevant independent source paths are:

- `sema/driver.rs`: `pull_workspace_sources` takes this workspace's pending
  source strings, loads them in their specified scopes and expands declarations.
- `sema/consteval.rs`: `run_top_level` calls that drain after the active run
  completes. `call_thunk` executes a fully checked thunk; its limited retry path
  handles typed-code exports or queued bodies, not source-service suspension.
- `build.rs`: `AddStringToCode` validates the current workspace and queues an
  owned `CodeString`. `NextEvent` advances an intercepted child; it does not
  service an active owning compiler. The active compiler is taken out of its
  workspace slot during `step`.
- `stdlib/internal/compiler-api/messages.jai`: without intercepted workspaces,
  `compiler_wait_for_message` has no event source to advance. It does not request
  an owning-workspace source drain.

These observations explain this checkout's results. They do not establish what
the reference promises for the candidate's event-pump setup.

## Portable-owner handoff

Keep parsing and the final public facade in the portable owner's branch. A
factory-registration design can avoid undeclared calls entirely:

1. Own a snapshot of the ordered names, including exact module-parameter suffixes,
   on the first call. Generate ordinary qualified imports with those parameters.
2. Emit calls to a predeclared typed registrar with a stable request id and
   ordinal. Keep request records, options and result destinations alive until
   all callbacks have arrived or the request has failed.
3. At a **confirmed public servicing boundary**, incorporate that source and
   register all factories in the owning workspace. The staged primitive only
   proves this works after the producer returns.
4. Invoke factories in request order, append real plugin objects, assign the
   requested workspace, then run initializers with their associated options.
   Aggregate initializer success. No-init plugins reject nonempty options.
   Import/type errors remain compiler diagnostics.
5. Later calls with a different ordered name list, including parameter text,
   return failure. Option changes are separate from name consistency. Repeated
   successful initialization is not promised. The no-plugin path succeeds with
   no result entries; the public first-call consistency rule still applies.

The missing step is synchronous servicing in step 3, not finding the factory's
name or making its call type-check. A two-phase asynchronous return cannot be
substituted for the reviewed success-before-return guarantee.

If the coordinator confirms a compiler scheduling requirement, implement it as
a general suspension/service/resumption path, with these invariants:

- Retain the caller's actual frames, context and interpreter memory. Do not
  replay a run that has already produced observable effects.
- Service source in its validated owning workspace and lexical `Code` scope.
  Do not instantiate a second compiler for an active workspace whose compiler
  has been temporarily taken from the registry.
- Drain owned requests deterministically, lower generated callback bodies, and
  execute callbacks in the same interpreter that owns their procedure values.
  Preserve pending top-level ordering and avoid executing the active run twice.
- Release registry borrows before compilation or callbacks. Restore current
  workspace/controller stacks, budgets and suspended state on success and error.
- Route unrelated intercepted messages to their controller. Nested controllers
  must retain their own queues; waiting for one request must not consume another
  controller's messages or fabricate COMPLETE.
- Keep request state alive through callback completion, propagate import/type/
  initializer failures, reject stale callbacks and define cancellation on
  workspace destruction. Never resume a destroyed or completed workspace.

Do not implement these speculative scheduling changes before the positive is
confirmed. No source-printer/exporter or native `link_always` files were changed.

## Reference request and coordination gap

Candidate: `tests/producer-requests/plugin-registration/pump-candidate.jai`,
with adjacent `registration.jai` and `modules/Registration_Probe/module.jai`.
It declares all callees before execution, computes a module name, generates a
parameterized import and registrar call, tries eight public message-pump calls,
and requires a real initialized plugin before returning. It does not change
build options after workspace start and does not intercept its own workspace.
It is deliberately bounded, so rejection of this servicing setup cannot hang
the coordinator. This worker requests only a filtered validity/pass/fail result
and, if invalid, the reviewed required public setup.

`docs/worker-inbox.md` is absent in both this checkout and approved stdlib ref
`4b5b60b3`. There is no worker-message tool in this session. The reference request
was sent through the user-facing asynchronous clarification channel. This
document is the durable clean handoff; no private logs are requested.

## Verification

All tools are built from this checkout into
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/compiler-plugin-evaluation/target`;
Cargo uses two jobs. The regression command is:

```sh
cargo test --locked -j 2 -p jaic-cli --test cleanroom_plugin_registration
```

Four tests pass: staged compile-time registration in the interpreter, runtime
registrar protocol in the interpreter, undeclared-continuation rejection, and
actual native O0/O2 compilation/execution of both positive fixtures. Native
staged setup runs during compilation; its executable has an empty `main`.
Native protocol assertions run in the produced executables.

The candidate remains outside the positive suite. Running it explicitly with
`jaic .../pump-candidate.jai -check` exits 1 at
`registration_ready() && registration_count == 1`. There are no expected-failure
passes, disabled tests or hidden fallback factories.

Actual source-built `jaifmt --check` passes all six new Jai files. Strict
`jailint -D warnings` passes the staged context, registrar, producer module and
runtime protocol. The negative and pending candidate intentionally cannot pass
semantic lint and are not reported as lint-clean. `cargo fmt --all -- --check`,
Rust item-spacing checks on the new test, and warnings-denied clippy for that
test pass. `cargo test --locked -j 2 -p jaic --lib` passes all 165 core tests.

The first protocol execution failed because the initial primitive freed the
array by value but retained its header before reuse. Inspection of the
independent Basic implementation identified that lifetime mistake; using the
existing `array_reset(*factory_slots)` operation fixes it. Interpreter and
native protocol tests now cover reuse. No Basic or compiler change was needed.
