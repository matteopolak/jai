# Foundations progress

Current committed checkpoints: 9d2c6bd, 2db13bf (formatter and original tests).

Active work: reviewed Basic configuration propagation, enabled/disabled builder
layout and assert discard, temporary-storage stamping, generic type-name default
elision, and production portable float formatting/parsing for WASM.

New tests: basic-configuration and wasm-basic-minimal. First verify the current
failures, then implement. NEW integration-clean request confirms unavailable
localeconv/snprintf/strtod imports; no quarantined integration source is used.

Plan: exact binary/decimal conversion with private arbitrary-precision integers,
shared by formatting and parsing on all targets, avoiding native env imports.
Retain existing public format semantics and compare original boundary vectors
in interpreter/native O0/O2/WASM. Refresh only NEW producer compiler sources in
durable own staging. Keep unchanged real jaifmt and warnings-denied scoped lint.

Milestones: Basic default/on/off propagation and discard pass; portable float
formatting runs in production WASI without env imports; exact parser boundary
vectors pass. Refreshed NEW compiler now supplies generic parameter defaults;
real default-elision/type-name regressions pass, including dependent defaults.
Temporary stamping on/off and pre-free overflow payload checks pass.

New compiler blocker: refreshed compiler panics building unchanged real jaifmt
at lower.rs:236 `context storage`. Stack goes through check_expr_no_emit,
arg_cost, emit_call_inner. Minimal original reproducer:
tests/portable-stdlib/pending/context-overload-probe.jai. Scratch FnCtx creation
sets `context` directly without initializing the new context slot; proper
general fix must initialize all scratch/lambda/struct contexts through the
context-state API, not special-case Basic/jaifmt. Compiler ownership requested.
No producer Rust or peer checkout is modified. Previous real jaifmt remains
available for scoped formatting, but no successful latest build is claimed.
Producer now contains the general context-slot initialization repair in all
three identified sites. Copying NEW Rust sources read-only and rebuilding in
own durable staging; next step is rerun the minimal reproducer, actual real
jaifmt build, lint and full host/WASI suite before claiming this resolved.
Retest: minimal reproducer passes; unchanged real jaifmt/main.jai builds at O2;
its CLI checks and scoped --check pass; source-built jailint -D warnings passes
the exact owned inventory including new numeric/configuration sources and tests.
The compiler context regression is resolved through NEW producer sources.
Host interpreter/native O0/O2 has passed the enabled/disabled Basic configuration
and temporary stamping cases; full numeric/property/WASI run continues.
Completed: all 24 positive host cases passed interpreter/native O0/O2; five
invalid formatter/ensured-range cases asserted in all three modes. All 19
supported production WASI cases passed O0/O2 with only real WASI imports.
Includes numeric boundary/property tests, generic defaults, both assert layouts
and discard behavior, and temporary overwrite on/off/overflow freeing.
Real jaifmt build/CLI/check and scoped warnings-denied jailint pass. Cross-target
unused-code verification and reviewed checkpoint commit are next.
Unused-code results: Linux x64/arm64, macOS arm64, Windows x64/arm64 and wasm64
pass with all new cases. Refreshed bindings resolved the previous ipc_perm
error, but macOS x64 now fails POSIX p_realtimer: unknown itimerval (line3422).
Runner retains overall failure and continues independent targets. This matches
the NEW integration-clean request; no binding layout is guessed or edited.

Memory_Debugger_Interface defining shape still absent; no invented replacement
interface will be added. Enabled debugger configuration must diagnose this
remaining unsupported contract rather than silently ignore it.
Latest spec synchronization now supplies the four inline interface hooks and
default sentinel selection. This resolves the interface-shape question. Next
batch implements the exact fifth parameter and real debugger notification
routing; the current explicit unsupported guard will be removed, not retained
as a stale contract gap.
