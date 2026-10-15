# Retained body ownership and contextual members

The reviewed [Code graph contract](../specs/jai/compiler-code-records.md) requires
modification of exported member and unnamed bodies through their actual canonical
header/body relationship. A display name is not an ownership key. Arbitrary
copied-body ownership remains unspecified.

## General repairs

The source exporter formerly presented nested syntax-only procedure literals as
TYPECHECKED bodies without associating them with a semantic workspace procedure.
The public modifier correctly rejected these unowned records. Conversely, a
concrete procedure reached through a member or procedure value could finish
lowering without the syntax exporter's call lookup scheduling its canonical body.

Body scheduling now includes completed concrete semantic procedures regardless
of the spelling of their call site. Existing ProcId-based scheduling and reporting
sets keep one canonical header and one body event per procedure. Syntax-only
literals remain in syntax graphs but do not masquerade as separately typechecked
editable bodies. Real anonymous callbacks and members receive owned canonical
events. No module, path or name filters were introduced. Modification still uses
the original private record association; unknown records, field copies and
another workspace's bodies are rejected rather than guessed from names/serials.

Contextual enum-member syntax already exports as a dot binary expression with a
null left operand and an identifier right operand. The source printer now accepts
that null operand specifically for dot syntax. Qualified members retain their
explicit left operand; ordinary binary operators still require one. No public
enum-member record or library-side parser is introduced. Public identifier edits
remain authoritative, demonstrated by changing `.FIRST` to `.SECOND` before
reconstruction and observing the new enum value.

## Verification and disposition

Independent regressions reproduce both failures before the fixes. The ownership
core test covers retained member and anonymous bodies, canonical header/body
links, single events, relowering and negative unknown/copied/cross-workspace
ownership. The public workflow modifies an unchanged member body and then runs a
new compile-time assertion against that same procedure. The enum workflow covers
inferred and qualified arguments, assignment/comparison and public identifier
edits. The copied producer drivers also modify a member and the real called
Basic.alloc body, including `.ALLOCATE`.

The producer drivers were copied without their sibling inputs. The two added
sibling fixtures are explicitly labeled independently authored minimal local
inputs; this is not a claim of replaying unavailable peer input files. Foundations
retains ownership of the full profiler/module replay.

Native ARM64 O0/O2 child executables execute the modified retained member body;
native O0/O2 enum executables execute reconstructed expressions and edits. The
member child uses the documented crash-backtrace OFF option because the separately
owned portable_crash archive is unavailable here. Runtime assertions stay enabled.
The first attempted default-crash child builds failed honestly; no failed build
was followed by stale executable execution. Optimized WASI enum build and execution
also pass. These WASI checks use the native compiler host, not a WASM-host compiler.

Scoped core, layout, modules, reflection, interception, CLI and target-aware
library-root/overload lint regressions pass, with formatting, strict lint and clippy.
One module-test oracle still expected every library declaration to be excluded;
it is migrated to the established resolved-library interception contract and now
includes an invalid unused declaration to retain the no-forced-resolution check.
This test contains no procedures; its stale expectation predates this scheduling
repair. Evidence is durable under `artifacts/compiler-mac-repairs/member-*` and
`enum-producer.log`. Full production crash-hook and profiler integration remain
with their assigned owners.
