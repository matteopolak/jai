# Foundations progress

Current implementation checkpoints: 44cca8b (portable conversion/configuration)
and a11c0c8 (five-parameter debugger interface/direct binary32 rounding), followed
by 1b1cb39 (native-path safety, private helpers, canaries and strict argument gates).
All 26 positive cases pass interpreter/native O0/O2; five runtime rejection
cases assert as required; all 21 supported production WASI cases pass O0/O2
with non-WASI imports rejected. Real unchanged jaifmt builds at O2, its CLI
and owned --check pass, and scoped source-built jailint -D warnings passes.
Latest default/custom debugger tests include real heap allocation/destruction,
failed resize preservation, mixed-configuration address reuse and frame counts.

Unused-module-interface rejection is now fixed in NEW producer sources and
passes the required gate; valid default/custom interfaces still pass.
Unknown parameters are now rejected for system/stdlib and headerless modules
through general NEW producer validation. Both required rejection tests return
the expected exact-argument diagnostics. Current library declares exactly the
reviewed constraints/parameters; no Basic-specific substitute check is added.
Six targets pass unused-code checks including every newly affected case.
macOS x64 retains the peer POSIX itimerval blocker. No target was disabled.
NEW producer interface validation has now landed; own source rebuild/retest is
in progress. A related forbidden compatibility bypass remains in modules.rs:
unknown parameter rejection is exempted for system/stdlib modules. Original
negative/basic-unknown-parameter supplies an undeclared flag to real Basic.
Required general fix: validate exact declared named/positional arguments for
every module, with no system-module/name/path exemptions; reject arguments for
modules that declare no parameters too. Keep first/program parameter semantics.
No Basic-specific workaround or invented parameter will be added here.
Producer now contains general exact-argument validation after module
declarations, without the system-module exemption. Rebuilding read-only copies
and retesting unknown stdlib/headerless parameters before claiming resolved.
Additional owned filesystem regression found POSIX embedded-NUL paths acted
on their valid prefix; shared native-path validation now rejects them before
query/copy/rename/traversal/cwd calls. Sentinel content/cwd preservation test
passes initially; full host and cross checks follow.

Final run: all 27 host cases and all 21 supported production WASI cases pass,
including required interface/unknown-argument rejection gates. Real unchanged
jaifmt O2 build/CLI/check and source-built jailint -D warnings pass. Affected
unused-code cases pass Linux x64/arm64, macOS arm64, Windows x64/arm64 and wasm64;
macOS x64 still fails peer POSIX itimerval. No peer writes, reference input,
stdlib/Extensions changes or publication occurred.

Next: coordinator can integrate reviewed checkpoints and rerun full corpus/native
CI; binding owner must resolve macOS x64 itimerval, with Windows runtime still
pending. New helper visibility is now
module-private, and original canary tests fill/grow inline storage in both
assert layouts, including combined debug/stamping/discard configuration. Remaining
formatter/style/visualizer contract questions stay in the focused questions;
Windows runtime and final corpus/release verification remain coordinator-owned.

## Prior milestones and failure evidence

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
Exact five parameters now propagate through the public/private modules and a
single canonical four-hook interface declaration. Custom replacement alias
identity and real allocation/reallocation/free/heap notifications pass initial
tests. Default debugger has real allocator ownership/live allocation records,
synchronized updates, and visualization-on/off frame counters/logger snapshots;
default production WASI runs with no env imports. No unsupported-interface guard
remains. Memory debugger/heap support is now being expanded in the owned runner.

New general compiler request: $I/interface constraints on module parameters
are accepted without structural validation when the parameter is unused. Own
pending/module-interface-constraint.jai with -I tests/portable-stdlib/pending
currently succeeds for Broken with no run method. Required: validate all
declared interface members/signatures during parameter binding, preserving
normal lazy body checking; no Basic-specific assertions or API weakening.
All 26 host cases now pass interpreter/native O0/O2 and all 21 supported
production WASI cases pass O0/O2, including real heap state/block allocation
and default/custom debug notification, ownership diagnostics and visualization
flag effects. Real unchanged jaifmt build/CLI/check and warnings-denied scoped
jailint pass. The general unused-interface rejection is now a required runner
gate: current compiler wrongly accepts it, so no overall full-pass claim.
Compiler declaration site: sema/modules.rs declare_module_parameter strips
poly type syntax; retain/evaluate its interface constraint against each provided
or default value, including type-valued struct interfaces, before body use.
