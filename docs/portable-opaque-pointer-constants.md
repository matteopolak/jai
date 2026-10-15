# Opaque pointer constants: compiler handoff

The refreshed reviewed Windows_Registry contract resolves all ten HKEY values:
direct positive integer-to-HKEY casts, zero-extended on64-bit targets. Native SDK
sign extension is a documented discrepancy, not an unresolved API question.

The independent candidate implementation emits those exact immutable constants
without changing the seven foreign procedure identities, parameter names, ABI or
status handling. It is NOT counted completed: own compiler checking rejects a
positive nonzero pointer constant before native execution or target-aware lint.

Minimal original reproducer:
`tests/portable-stdlib/pending/opaque-pointer-constant.jai`. It has no Registry,
Windows or native dependency: `handle :: cast(*void) 0x80000001`, an address-bits
assertion, and an ordinary runtime check. Source-built compiler `-check` fails
on host ARM64 and Windows x64/ARM64 with exit1 and the exact diagnostic:
“a compile-time value holds a pointer to memory of unknown size”. Evidence:
target/opaque-pointer-constant-check.log, target/opaque-pointer-constant-windows.log,
target/registry-handles-verified.log. Earlier missing-export evidence is retained
in target/registry-handles-red.log.

Own Rust cause: sema/consteval.rs freeze_pointer zeros pointer storage, resolves
known globals, then recognizes only `p < 0x10000 || (p as i64) < 0` as integer
handles. A positive0x80000001 void pointer misses that heuristic and reaches the
unknown-memory-size error. Proper compiler resolution should preserve opaque
integer-to-pointer address bits separately from pointers to owned compile-time
memory that need freezing/relocation. Do not add Registry/module/symbol cases,
expand a pseudo-handle whitelist or silently sign-extend the public value. No
compiler changes are made here; this crosses compiler ownership.

Six candidate files remain durable UNCOMMITTED and excluded from the handoff
checkpoint until that general compiler fix is available:

- stdlib/Windows_Registry/module.jai
- stdlib/internal/windows-registry/abi.jai
- tools/generate_windows_registry.py
- tools/check_portable_windows_registry.py
- tests/portable-stdlib/windows-registry/constants.jai
- tests/portable-stdlib/windows-registry/main.jai

Candidate generation is formatting-normalized and byte-stable. The candidate
checker now attempts actual target-aware strict lint for both Windows CPUs,
but source checking stops first at the pointer-constant defect. No lint success,
33-export completion or native Registry success is claimed. The native fixture
now passes the public zero-extended HKEY_CURRENT_USER through real ANSI/wide
open and typed-get calls against its own volatile test key. Actual Windows
execution remains mandatory; source acceptance alone cannot prove Advapi32
accepts that reviewed value. No fake success, public ABI wrapper, mutable
substitute or caller address patch is introduced.

The three previously documented provisional Performance_Report files remain
excluded independently. No peer checkout, Extensions or corpus is modified.
