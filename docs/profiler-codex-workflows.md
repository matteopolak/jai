# Iprof/Codex workflow progress

This supersedes the records-only audit at 4fe1e621. The synchronized module
contracts are now the oracle; the earlier broad synchronization requests are
resolved. Implementation remains active.

## Implemented workflows

Iprof now records native monotonic zone ticks, propagates self ticks through
distinct zones on each stack chain, calibrates counter rates, updates node
trackers and per-zone rings, and produces real flat/call-graph reports from
temporary_allocator. History stores second moments, seeds the first three
observations, and retains ring cells on clear. Public node/hash helpers follow
the reviewed declared-hash-plus-parent formula, insertion/reset behavior and
persistent-node lifetime. Automatic zones defer their exit and honor a shared
private per-context runtime guard. Report-mode, cursor, frame and selection
operations operate on measured rows. Reports and their highlevel pointers
expire when temporary storage is reset.

The refined report contract places Report_Row times in milliseconds.
Writers now consume those values directly; original owned writer fixtures were
updated to use milliseconds rather than the superseded seconds assumption.
Threshold units are interpreted in the same units as their compared row fields.
A precise threshold-unit confirmation remains requested.

Codex now has all listed public function names and overloads: typed metrics,
scalar/string helpers, checked v2 reader, dump_file, plugin creation/options,
message collection, communication, final serialization and shutdown. The real
CLI +Codex workflow exports actual compiler file/import/body messages in
received order, replaces duplicate body identities, serializes the canonical
record layouts, patches canonical s16 relative strings in the finished buffer,
and writes the file. Generation timestamps come from the real host clock.
Unknown revision/reserved fields are initialized; the optimization tag remains
non-authoritative because Build_Options supplies no Optimization_Type value.

The reader validates counts, inline string targets/terminators, record indices
and bounds before exposing borrowed views. This is intentional safe behavior
in malformed-input areas where the reviewed implementation establishes no
compatibility guarantee. Generic string get returns a valid count rather than
reproducing the documented missing-count bug. get_short_string honors allocate:
true copies, false borrows. Its source naming mismatch leaves that behavior
unspecified; this independent policy remains explicit.

The new Basic facade forwards its public allocators to internal/basic.
Original real compiler-message evidence showed alloc/realloc/free/copy_string
headers owned by that canonical producer module. Metrics recognize the exact
reviewed public name set in Basic and that independently authored owner,
rather than returning zero for these real public Basic calls.

## Verification and limits

The focused runner has executed the real +Codex child at native Mac O0/O2,
then checked its actual v2 output in interpreter/native O0/O2. It verifies
conditional score/depth, allocation/free counts, source spans and every
truncated prefix of the resulting 10 KiB file. Existing profiler/metrics tests
and new frame/automatic-zone tests passed interpreter/native O0/O2.

Unchanged repository jaifmt builds from source and checks owned formatting.
Strict lint passes the new program fixtures. Full scoped module-root lint is
currently blocked by the general jailint context-import issue below; it is
NOT reported as full strict-lint success. The runner retains its failing
module checks without exclusions or warning suppression.

Use only the assigned Cargo target:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target`.
All source and authoritative test output stay in this local worktree.
No peer implementation, bootstrap, shared dependency manifest or Extensions
source was changed.

## General compiler/linter request

Original reproducer:
tests/developer-tools/compiler-requests/profiler-context/main.jai and
modules/Context_Probe/module.jai. jaic -interp with the explicit absolute
modules import directory prints ok. jailint -D warnings on the module root
fails: #add_context after the Context type was laid out. Its module-root driver
compiles main :: () {} and bootstrap dependencies before importing the requested
module. Program-root strict lint of the real Iprof consumers passes.

Request: preserve configured bootstrap/module parameters while allowing
module-owned #add_context declarations before Context layout in module-root
lint. No module-specific compiler bypass or alternative fake context is needed.

## Remaining Iprof functionality

The metaprogram plugin callbacks, source/hook insertion and real automatic
procedure instrumentation remain active work. USE_GRAPHICS rendering/config
and graph selection/scaling remain active work. Native Windows/Linux runtime
verification remains later work; no additional platform matrix is being
expanded before these public workflows are complete.
