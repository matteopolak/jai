# Unstarted generator dependencies and workspace phases

The NEW coordinator placeholder-defined-by-metaprogram fixture waits for Kinds
in a top-level insertion generator; the parent supplies Kinds at
TYPECHECKED_ALL_WE_CAN. Before this repair, the compiler counted entering an
interpreter wrapper as execution, requested the unlowered anonymous body, and
reported dependency deadlock before the parent could receive the phase.

A guaranteed initial direct callee is now semantically lowered before starting
the wrapper. This preflight recognizes only entry-block register/address setup
and accesses to the wrapper's own direct stack slots. It stops at other memory
accesses, calls, intrinsics and control flow. It executes no instructions, creates
no interpreter continuation, and increments no execution counter. An unresolved
placeholder therefore leaves genuine unfinished semantic work parkable by the
existing pending-item mechanism. Later source binding retries semantic lowering
in the original lexical/module scope. Finished bodies are never relowered by
this preflight.

Actual executed callers continue to use the existing retained interpreter frames,
owned stack/context and exact-once resumption. There is no effect-counter rollback,
prefix cancellation/restart, replay suppression, fixture exception or substituted
successful result. Generators that execute and fail remain terminal.

An additional original reduction found final #assert checks running inside the
dependency controller before a pending generator resumed. Producer-only service
is now separate from final assertion evaluation: the controller services sibling
top-level runs and source queues, while the normal top-level driver evaluates
final assertions after producer service. Existing active/completed run tracking
continues to prevent duplicate execution.

Tests preserve invalid-body/cycle/deadlock/duplicate/scope failures and exact
printed-prefix counts. The original supplied parent-phase fixture passes actual
interpreter/native O0/O2. Core tests establish zero recorded compile-time runs
while waiting, then successful binding both in the main scope and an imported
module's canonical scope. Existing deferred native callback/readiness and
continuation tests remain enabled. The exact compiler-module-placeholder-insert
catalogue wrapper is present but its supplied Generated_Kinds module is still
missing from this checkout; that full case is unverified pending the clean input.

Limits: the preflight does not speculate across effects/branches or provide a new
external-workspace phase suspension protocol for already executed generators.
Those paths retain their current continuation/terminal-diagnostic boundaries;
no compatibility beyond the reviewed and tested forms is claimed. Root owns the
complete opaque corpus and integration baseline. The service-rejected memory
investigation remains suspended and unrelated.

Evidence lives in artifacts/compiler-mac-repairs/placeholder-*,
using-scheduling-*, and crates/jaic-cli/tests/cleanroom_deferred_calls.rs. The full
owned library suites pass222tests; focused regression totals and final source
identity are recorded in the inbox after the checkpoint is committed.
