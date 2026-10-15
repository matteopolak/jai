# Deferred compile-time procedure dependencies

The public boundary is a declared `#placeholder`, a procedure whose signature
and typed value exist before its body, and an indirect compile-time call.
Scoped `Compiler.add_build_string(source, -1, code)` supplies a definition;
`#insert` consumes the generated body string. The caller returns after its real
generated body executes. No message interception or event pump is needed.

The coordinator confirmed `plugin-registration/deferred-body.jai` unchanged on
official Jai 0.2.030: result 42, prefix executed exactly once, exit zero, no
timeout. This worker received only that filtered confirmation in its own inbox,
never ran the reference or read raw logs/private implementations. Work starts at
independent `53ecb3d3`, with approved stdlib handoff `4b5b60b3` and the reviewed
`docs/specs/stdlib/modules/metaprogram-plugins.md`.

## Compiler mechanism

`sema/dependencies.rs` owns placeholder reads, bindings, active body controllers,
source scopes and active/completed top-level runs for one compiler. A procedure
value needs its signature, rather than eager compilation of all callee bodies.
Generated declarations bind a placeholder in the captured lexical scope of the
same workspace/module instance. Overloads retain all definitions; duplicate
declarations and unknown identifiers keep their normal errors. Quoted Code
escapes synthetic compiler thunk scopes to capture the actual lexical scope.

`interp/compile_calls.rs` retains suspended frames on the owning interpreter
stack. Nested service thunks execute above that boundary. Resumption restores
the call/context/trace boundary and continues the interrupted instruction;
cancellation unwinds retained frames. Locals, pointers and prior return values
remain valid. Executed caller prefixes never restart.

For a missing body, the compiler first tries lowering, then drains owned sources
and retries, then services eligible sibling top-level runs. Active runs are
skipped; completed runs execute once. Multiple waiters for a body are valid.
A body already being lowered is a cycle. No producer progress produces a
deadlock diagnostic naming the procedure and required placeholders. Executed
generator failures are terminal. Unresolved-body diagnostics are provisional
until body compilation succeeds or final failure is established.

Source draining includes an active child's initial StageOpen run. It never
creates another compiler for an active workspace. The queue owns source text;
Code must belong to the running workspace. Active-workspace destruction is
rejected, and completed workspaces reject source additions.

Native callback/thread entry exposure requires reachable bodies ready before
foreign execution, where compiler suspension is unavailable. Direct callback
arguments receive mandatory checks. All materialized thunks possibly shared
through opaque records/arrays/globals receive nonblocking readiness inspections:
ordinary bodies compile, but retaining an unresolved deferred value does not
block an unrelated native call. Source addition invalidates inspections. Skipped
bodies are never marked ready; readiness survives exposure bookkeeping resets.

## Portable library handoff

`deferred-factory.jai` computes a module name and parameter suffix, generates an
ordinary import/factory body, calls an already typed procedure value, and returns
populated plugin results with real initialization and caller-local options
verified. This synchronous primitive is available to the portable owner, who
retains the final Metaprogram_Plugins facade and parser.

The facade must snapshot ordered names, including parameter text, on first call.
Later calls with different names fail; option changes are distinct from name
consistency. Preserve request order, real plugin objects, target workspace
assignment and initializer success. No-init plugins reject nonempty options.
Empty names succeed with empty results while obeying first-call consistency.
No pointers need serialization into source.

The older typed registrar remains a staged example. Generated registration and
completion execute in one `#run` block; separate top-level ordering is not a
promise. The invalid pump candidate was deleted. Undeclared continuations remain
errors. No final facade, printer, AST editing/exporter or native link_always
implementation is changed here.

## Exact limits

- Compiler suspension is for owned compile-time interpreter calls. Native
  callbacks and live managed-thread boundaries cannot suspend into the compiler;
  they receive an explicit diagnostic. Deferred callbacks hidden in opaque
  memory must be made ready before foreign invocation.
- A body with a successfully executed generator followed by another unresolved
  placeholder fails terminally. Lowering has no generator checkpoint cache;
  retrying would repeat effects. An execution counter enforces this restriction.
- Active workspace destruction/cancellation is unsupported and rejected.
- SandboxHost/strict lint cannot execute arbitrary native abs, qsort or the
  independent C callback provider. Native tests use actual native execution.
- The final helper and full Focus build require portable-owner integration;
  this change alone does not establish that build passes.
- The native record test supplies Unix evidence, not Windows provider execution.

## Verification

Tools are source-built with two Cargo jobs into
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/compiler-plugin-evaluation/target`.
Focused suites: core `cleanroom_placeholder_dependencies`; CLI
`cleanroom_deferred_calls`, `cleanroom_plugin_registration`, `cleanroom_plugins`.
They cover exact-once resumption, sequential waits, sibling waiters, cross-file
and module-instance isolation, child queues, real initialized factories, native
record/direct callbacks, and actual native O0/O2 binaries. Negatives cover
cycles, deadlocks, executed failures, duplicate declarations, invalid bodies
and workspace misuse.

Core/context/interception/module/reflection/typed-node regressions, Rust format,
warnings-denied clippy, source-built Jai format and strict lint of non-native
positive fixtures also run. No corpus/reference implementations are accessed.
Recorded checks: 247 core and selected compiler regressions; 13 focused CLI
tests, including real O0/O2 executables; strict lint on ten non-native positive
programs; all-target warnings-denied clippy for jaic, jaic-cli and jailint;
Rust format, Jai format and diff whitespace checks. The record-callback test was
also run with readiness inspection removed and failed at the native callback
boundary, then passed with the mechanism restored. The successful-generator
limitation has its own exact-once negative in deferred-after-generator.jai.
