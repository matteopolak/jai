# Compiler deviations and implementation gaps

Scope: current producer source and handoff documents, plus this task's atomic,
context, and reflection investigation. This is an active ledger, not a claim of
full compatibility or production integration. Existing detailed limits remain in
`docs/specs/stdlib/compiler-questions.md` and the compiler integration handoff.

| Location | Observable effect and rationale | Evidence/risk | Proper fix |
| --- | --- | --- | --- |
| sema/calls.rs intrinsic dispatch | Bootstrap atomic dispatch gap repaired through shared IR, with scalar/signature/alignment validation. | Four original regressions pass. Public accepted scalar set is an independent supported policy where reviewed pages are incomplete. | Review exact type-set/reference ordering; retain general validation. |
| interp/atomics.rs | Real host atomics replace non-atomic sequences. Mapped-access checks cannot retain an allocation another native thread frees. | Original simultaneous-host CAS regression now passes; caller owns allocation lifetime, as for native atomic pointers. | Continue enforcing lifetime/compatible access at calling API boundaries; no fake memory-safety claim. |
| interp/mod.rs cooperative polling | Polls after indivisible atomic operations on cooperative multi-thread hosts. | Preserves progress; can cost additional scheduling overhead versus polling only stalled operations. | Profile scheduler budgets before tuning; never weaken atomicity. |
| jaic-llvm/src/lib.rs | Atomic wasm programs automatically require +atomics; explicit -atomics errors. | Shared-memory linking previously failed and now passes contention. | Keep IR-derived feature requirements; thread-enabled linkage remains embedder configuration. |
| jaic-llvm/tests/cleanroom_atomics.rs | Native contention driver uses pthreads on Unix; WASM tests require node/wasm-ld and fail when tools are missing. Error-reporting imports throw if executed. | Actual native and shared-memory tests pass; no tool skips or successful error stubs. | Coordinator must run Windows native contention with its threading backend; full platform CI remains outstanding. |
| sema/stmt.rs and calls.rs | Macro caller-scope defer-pop context may restore at expansion end. | Portable independent reproducer; lexical lifetime incorrect. | Model caller-owned context restoration with lexical cleanup. |
| sema/typeinfo.rs | Generic source descriptors currently carry a name without complete defaults. | Source inspection; Basic cannot reliably elide default parameters. | General generic parameter metadata with real default values and storage. |
| tools/assemble-cleanroom-test-library.py | Test-only overlay reads new independent producers; no production integration. | Focused prior tests only; missing dependencies can block broader runs. | Coordinator integrates independent producers and runs full gates. |
| jaifmt source build | Prior build blocked by missing reviewed Basic builder print overload. | Prior handoff preserves failure; Jai formatting not claimed passing. | Retry with new foundation dependencies; build formatter from sources. |
| compiler facades | Performance run record shape, visitor macro bindings, static filter expression shape and selected diagnostic semantics remain unspecified; some printing forms return false. Debugger/alternate backend operations diagnose unavailable support. | Questions and facade docs; reduced functionality is explicit. | Reviewed contracts plus real implementations and regressions. |
| browser integration | Prior broad run had ten dependency/API failures; no assertions disabled. | browser-integration-status.md; portable dependency integration incomplete. | New producer integration and full browser rerun. |

Atomic default ordering is not established by the reviewed public pages. This
implementation will use sequential consistency, consistent with its existing
CAS backend, and document that stronger implementation guarantee without
claiming it is the unspecified reference guarantee. No public ordering API is
invented. Existing explicit-order compiler intrinsics must reject invalid orders.
