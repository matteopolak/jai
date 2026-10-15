

## Confirmed overload audit defect queued
The Extensions owner reduced the remaining production Http lint failure to an independent generic overload example. Exact handoff is docs/compiler/rejected-overload-lint-request.md; original clean reductions copied into tests/producer-requests. Normal check/execution select the correct App overload, but strict audit checks a concrete rejected Client candidate and triggers its body. Fix general candidate provenance/audit roots or transactional instantiation, preserving genuine selected/unreferenced checks and instance reuse. No Http/Json/path exceptions or procedure-serialization workaround. Prioritize this after current coherent parser/reflection fixes; it blocks the sole remaining owned Extensions production lint context.


## Reviewed decimal inference 2026-10-15 14:34 UTC

Updated reviewed core-syntax-and-types.md copied into your spec tree. Default literals 12342345234.0, 16777216.0 and 9876543210.125 are float32; 0.123456789 requires float64. Integer-side digits do not count; fractional trailing zeroes ignored. This is compiler literal metadata, independent of runtime lexer mode flags. PI_LONG with more than eight fractional digits cannot implicitly narrow; explicit cast may round. Reconcile the two catalogue oracles with this reviewed contract, retaining narrowing diagnostics.

## Compiler completion handoff 2026-10-15

Decimal correction committed as2a0e6853: both catalogue fixtures pass interpreter
and actual ARM64 O0/O2, with initialization/arithmetic narrowing negative tests.
Generic rejected-instance audit fix is verified; design and exact checks are in
compiler/rejected-overload-audit.md. Producer and staged Http reductions pass
strict lint; production Http client context instead stops on the independent
unknown atomic_compare_exchange dependency. No Extensions code changed.
Public memory protocol helper/native prerequisite remain other owners' work.
No Context/add_context reproducer has arrived in this inbox at this checkpoint;
no speculative Context change is made without the exact reduction/contract.
