# Rejected generic overloads and lint audit roots

The independent producer reduction selected the App overload in normal checking
and execution, but strict lint failed the Client generic body's assertion. The
new library-free Rust/CLI regression reproduced this before the fix: one of three
tests failed with `selected instance must fail` from the rejected candidate.

Matching deliberately caches concrete generic instances before all conversions
are known. A cached signature is useful to later calls and must retain canonical
instance identity. However, it is not a new source declaration. The IDE/linter
audit previously treated every non-polymorphic NotNeeded procedure as an
unreferenced concrete declaration, inadvertently checking rejected and viable
but less-preferred instantiated bodies.

The audit now excludes NotNeeded procedures with an instantiation binding scope
from its declaration-root loop. Actual selected uses still queue bodies through
the existing proc_func path; draining the queue and reporting its errors is
unchanged. Declared concrete procedures remain audit roots even when unreferenced.
Instance caches, overload ranking, header validation, defaults, #modify checks,
and normal compile-time generators are unchanged. There is no file/module/type
exception and no speculative-instance deletion that could break later reuse.

Four focused jailint regressions verify rejected and less-preferred instances,
later selection of the same cached failing instance, and an invalid unreferenced
concrete declaration. The producer's generic reduction passes strict lint,
interpreter and actual Mac ARM64 O0/O2 execution. Its staged Http reduction passes
strict lint after removal of a genuinely unused Basic import. The full Http
client context stops at a separate unknown atomic_compare_exchange dependency;
that context is not reported as passing.

Verification:165 core library,11 layout,8 reflection,2 catalogue CLI,4 overload
audit and11 target-aware jailint integration tests pass. The combined command
also ran11 jailint library tests. All-target clippy for jaic/jaic-cli/jailint,
explicit Rust formatting/item spacing and scoped Jai formatting/strict lint pass.
No Windows or browser execution claim is made by this audit repair. The audit
still cannot validate every possible uninstantiated generic body; concrete uses
and genuine concrete declarations continue to receive diagnostics.
