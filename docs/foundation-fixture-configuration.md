# Foundation fixture configuration migration

The four stale foundation fixtures are migrated without changing Basic,
Thread or compiler production. Reviewed Basic program-wide parameters are
selected once by a main program using the second import argument list.
Different settings are exercised by separate programs, rather than competing
module configurations inside one program. Imported modules do not establish a
reference API from previous local behavior.

| Positive entry point | Retained behavior |
| --- | --- |
| basic-configuration.jai | Default/enabled builder layout, canonical reimport identity, ensured-space accounting, full-capacity growth and canaries |
| basic-configuration-disabled.jai | Disabled builder layout/capacity, omitted ensured_count, assertion arguments/message/location not evaluated, capacity growth and canaries |
| basic-configuration-isolated-combined.jai | Debugger enabled with assertions disabled, builder growth/free, overflow-page reclamation and temporary-storage reset stamping |
| memory-debugger-interface.jai | Canonical replacement type, private constraint visibility, allocation/free/realloc hook counts, failed resize ownership, arrays/builders and explicit custom heap lifecycle |
| memory-debugger-interface-disabled.jai | Replacement hooks have no effect when the debugger is disabled |
| format-aggregates.jai | Aggregate/enum/array formatting, truncation, formatter wrappers, error logger/style/callback behavior, empty and valid borrowed Any |
| format-grammar.jai | Placeholder grammar, error counts, nested style overrides/restoration and numeric parsing |

All seven main programs print exactly ok newline with exit zero. Disabled
assertion programs validate results through an unconditional test-only context
failure check, so the tests do not disable their own verification. The memory
debugger heap test still uses its explicit supported custom allocator; it does
not assume heap creation from every platform's default allocator.

The formatting fixtures use the canonical builtin context.print_style field.
Only the duplicate #add_context declarations are removed. The obsolete
partially-null Any diagnostic-success expectation is retired under root's
sanitized official native verdict. Named valid borrowed storage is tested
before and after mutation; required malformed-payload/type failures remain in
the existing format-any-missing-value/type controls. Formatter wrapper
null-value behavior remains independently tested and unchanged.

Final proof uses freshly source-built locked compiler/lint tools and the actual
shared stdlib. Seven positives pass 42 source checks and 42 strict-lint contexts
across Windows/Linux/Mac x64/ARM64. Competing main settings are rejected in six
target configurations with the expected ENABLE_ASSERT diagnostic. Seven
programs pass interpreter plus actual Mac ARM64 native O0/O2: 21 runtime modes,
with exact stdout, empty stderr and zero exit status. Full guarded compiler,
stdlib and owned fixture inputs remain unchanged throughout final verification.
Linux/Windows runtime acceptance still belongs to normal CI.

The additional called-helper non-main configuration control is unexpectedly
accepted in all six targets. Under the reviewed main-only program-parameter
rule this is a required compiler-boundary RED, separately recorded, never a
passing negative or a new positive. No compiler relaxation/fix is made here.
See [the focused question](specs/stdlib/portable-foundation-fixture-questions.md)
and [exact ready manifest](status/foundation-fixtures-ready.json).

Initial source receipts retain a wrong helper search path and a concurrent
fixture-write conflict. Both workers stopped overlapping writes; self-contained
authoritative roots were restored and verified again. Provisional alternate
wrappers were preserved by their owner before removal. A reused combined
filename was caught, excluded from this handoff and replaced by the unique
isolated-combined name. No historical failure receipt is rewritten as success.

Foundations owns runner/context-list adoption. Add the three new positive roots
listed above alongside the four existing entries, each as a separate program.
The negative controls must remain classified by their exact dispositions.
Integration alone stages/commits and adds this document's global README link.
Native slot is released; all children are finished/reaped. No GUI, network,
deliberate fault, benchmark, reference implementation or release operation ran.
