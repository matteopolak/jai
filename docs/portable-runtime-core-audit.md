# Runtime core API audit

Reviewed oracle: `specs/stdlib/modules/runtime-support.md`. Current tests exercise
mutable synchronization storage through two imports, canonical record names and
defaults, real element duplication with surrounding guards, borrowed C-string
views, radix clamping, stdout/stderr routing, default logger routing, repeated
initialization through the public Code macro, and one actual publication winner
among four real threads. Default runtime initialization/finalization is exercised
with an independently allocated context and temporary storage.

Run `CARGO_TARGET_DIR=<own T7 target> python3
tools/check_portable_runtime_core_shared.py`. Receipt
`runtime-core-shared-f5ts2dxf/results.json` records **99 passed, zero failed**:
12 actual interpreter/native Mac ARM64 executions, eight builds, 48 desktop
source/lint checks, 24 explicit active-context coverage checks, and seven format
checks. All requested owned sources are visited in complete contexts. Unix
manifests explicitly list the conditional Windows-only I/O unit as unvisited;
that inactive backend is not counted as exercised. Both Windows contexts visit
it. The earlier 75-command receipt passed its commands but did not yet check this
coverage distinction. Existing hook/order/no-entry verification remains separately recorded
in `portable-runtime-instrumentation.md`. No production fix was needed here.

Test draft correction: Thread has no reviewed thread_get_result export. The new
concurrency test instead observes publication directly, records failures through
the real Atomics API, and waits for every worker before checking shared state.
No Thread convenience function or production workaround was added.

Per-API limits are explicit in the owned JSON inventory. The four public fault
entry points have real diagnostic/termination implementations, but exact public
flag encoding/return policy and native fault execution are not certified by this
ordinary-path suite. This compiler's separately tested private reporting ABI is
distinct. The assertion callback's boolean/termination contract and Unix/debugger
break policy need precise review; see
`specs/stdlib/portable-runtime-core-questions.md`. A correct unsigned-magnitude
minimum-integer implementation does not establish parity with the documented
reference overflow edge. Android log buffering is bindings-owned and requires
its own platform verification. No callback-registration or bootstrap override
feature was introduced.
