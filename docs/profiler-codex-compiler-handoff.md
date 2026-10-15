# Profiler/Codex compiler-owner requests

## Final owned Mac replay9b3d4932: all required checks pass

Approved9b3d4932 fixes the growable-array flag reduction. All original retained
member/enum/Basic.alloc/INDEX/array-local reductions and the interpreted modules
workflow pass unchanged. No outstanding compiler reconstruction request remains
for the assigned Iprof/Codex scope.

The newly executable native workflow exposed two owned initialization defects.
profile_zone_begin now enables the existing runtime guard before any init or
validation, preventing recursively instrumented assertion failure handling.
Generated instrumentation additionally preserves that guard and disables
collection outside the initialized entry-point window through a private
per-context lifecycle field. This prevents native runtime startup from accessing
an uninitialized zone table. Public direct/manual zone operations retain their
behavior. No module/name exclusion, compiler edit, library reparser or manually
instrumented replacement is added. Generated LLVM verifies crash-handler init
still contains its instrumentation and main retains its byte store, alloc/free,
zone entry and exit. The collection-window policy remains an explicit precise
compatibility-review question, without an invented public API.

Final target/profiler-codex-checks.json:198 commands, complete=true,
zero required failures, six required option/scalar rejection exits. All four
real profiler CLI module-toggle O0/O2 builds and executions pass, with positive
allocator/helper/imported-child calls and actual timing checks. All22 runtime
cases pass interpreter/native Mac O0/O2, as do hooks, exact expression boundaries,
all16 generated configurations, actual Codex exports/native C consumers,
unchanged source-built formatter and full scoped warnings-denied module lint.
The fixture explicitly invokes assert_helper under a recoverable context handler
and checks its effect; successful assert is not presumed to invoke it.

The nine-command target/profiler-codex-dependency-replay.json is also complete:
seven retained reductions/workflows and emitted-IR native build/run all exit0.
Compiler and API source intake is the established unchanged own snapshot plus
exact approved compiler-owned public/private modules. The focused runner checks
owned implementations are byte-identical. Canonical peer/compiler/other-owner
sources and shared manifests remain untouched.

Integrate the owned library checkpoint together with approved9b3d4932 compiler
and API dependencies. The shared tooling runner still has two obsolete Codex
expected-rejection cases at lines380-381; its owner must replace them with the
positive reviewed metric/lifecycle tests. Native Windows/Linux execution remains
later work; only source-check evidence is claimed here. Iprof.message partial
is closed. Earlier failure-specific sections below are historical and superseded.

## Current approved replay69e971b1: growable-array flags

Exact approved69e971b1 Rust and compiler-owned API sources were source-built
unchanged using the established isolated snapshot workflow. The retained member,
inferred enum, unchanged Basic.alloc and INDEX reductions now pass. Their
assertions are unchanged; previous ownership/enum dependencies are resolved.

Both required actual -modules builds still fail at O0/O2, now while editing
Basic's nat_decimal body. Its `chunks: [..] u32` is reconstructed as a distinct
array view, so the following real array_add call fails overload resolution.
The actual interpreted-module workflow fails identically; its completion
assertion is retained. Iprof.message remains partial for this one general
producer reconstruction issue.

Original minimal reduction:

- profiler-array-local-input.jai: collect declares `values: [..] u32`, appends42,
  asserts count/content, and frees its allocation. The unchanged program prints
  ok in interpreter/native Mac O0/O2.
- profiler-array-local-modify.jai: a canonical child workspace intercepts collect
  and passes its unchanged public body back to compiler_modify_procedure.
  Program_Print reports success but emits `values: #type,distinct [] u32`.
  Recompilation fails on `array_add(*values, cast(u32)42)` with "expected an
  array, found distinct". The required successful-completion assertion fails
  (exit134). No library internals or special profiler procedure names are
  needed to reproduce the general fault.

Root cause observed in the authorized NEW source snapshot:
`crates/jaic/src/sema/code_export.rs`, type_inst, ArraySize::Resizable, emits
inst_flags0x10. The reviewed canonical Code_Type_Instantiation.inst_flags defines
RESIZABLE0x2 and TYPE_DIRECTIVE_DISTINCT0x10. The printer correctly interprets
these public bits and therefore emits the wrong type for the wrong metadata.
Request correction of the general exporter flag mapping and regression coverage
for growable/view/fixed local arrays. This worker has not changed the compiler,
rewritten type metadata, excluded procedures, or supplied a library reparser.

Exact commands (STDLIB is the absolute owned69e971b1 dependency-snapshot path):

```sh
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-array-local-input.jai -interp
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-array-local-modify.jai -check
python3 tools/check_profiler_codex.py --jaic /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic --jailint /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jailint --stdlib "$STDLIB"
```

Authoritative local reports remain target/profiler-codex-checks.json and
 target/profiler-codex-dependency-replay.json. Earlier replay evidence follows;
its ownership/enum failure claims are superseded by69e971b1 success.

## Current approved replay: b0430110 +59a69c03

The exact approved59a69c03 source (including b0430110 reconstruction) was built
unchanged in the owned local snapshot target/profiler-compiler-source-59a69c03.
Own independent stdlib sources were copied intact, then only the approved
compiler-owned Compiler, Program_Print, Code_Visit and corresponding private
sources were overlaid from that exact checkpoint. Canonical worktree modules
and peers were not modified. Cargo rebuilt jaic/jaic-llvm/jaic-cli/jailint in the
assigned T7 target. The focused runner's --stdlib option selects this actual
production dependency snapshot and checks every owned implementation file is
byte-identical to the worktree; it permits no tool-specific library replacement.

Resolved: original INDEX modification now prints `values[0] = 42`, parses and
completes. Actual real CLI builds with modules disabled pass at native Mac O0
and O2, preserving the indexed byte store, allocation/free and imported call.
The emitted O0 LLVM main contains initialization, profile_zone_begin, the
original `store i8 42`, real alloc/free/child_call, zone_end and final report.
Native execution returns ok and records one main call with positive timing.
Ordinary Basic-body interception and full module-root lint stay resolved.

Remaining required failures (Iprof.message stays partial):

- Exported unnamed inline member bodies cannot be modified: original
  profiler-member-modify.jai exits134 on body ownership/completion. Both actual
  native -modules CLI builds still fail on that same error at O0/O2. An
  original interpreter-workspace workflow profiler-interpreted-modules.jai
  also fails on that ownership error; its required successful completion
  assertion is retained.
- Inferred enum member reconstruction still fails. New wholly original
  profiler-enum-input.jai contains `return take(.ONE)`; its modifier prints
  `return take(`, returns false and exits1 from canonical modification.
  The unchanged Basic.alloc reduction still fails identically at .ALLOCATE.
  Exporter supplies the documented BINARY_OPERATOR dot with null left and
  identifier right; request general inferred-member printing in the canonical
  compiler-owned source printer. No fabricated node or public field is needed.

Interpreter CLI plugins are explicitly unsupported by jaic. The positive
iprof-intercept-interpreter.jai fixture instead uses the real public plugin
lifecycle in a child workspace, waits until injected zone setup is materialized,
and adds `#run main();`. This runs the actual edited body in the compiler's
interpreter. It returns ok and writes one positively timed main CSV row. It is
also exercised while building its host natively at O0/O2, with all completion
and generated-setup assertions preserved. It supplies no substitute profiler.

Exact replay (STDLIB is the absolute owned dependency-snapshot stdlib path):

```sh
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-enum-modify.jai -check
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-member-modify.jai -check
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-index-modify.jai -check
JAIC_STDLIB="$STDLIB" /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-interpreted-modules.jai -interp
python3 tools/check_profiler_codex.py --jaic /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic --jailint /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jailint --stdlib "$STDLIB"
```

Authoritative local results: target/profiler-codex-checks.json and
 target/profiler-codex-dependency-replay.json. The main runner retains the two
required native CLI failures and exits nonzero. The separate replay records
all original reductions, the interpreted module failure and emitted-IR native
build/run. Integrator must integrate the approved compiler-owned API sources
with Rust together, then repair general member ownership and inferred-member
printing; no shared manifest, peer or compiler implementation is edited here.
Earlier checkpoint-specific evidence follows for comparison.

## Historical reduced module-root context/lint reproduction (resolved e9affab7)

Independent sources (no library dependency beyond bootstrap):

- tests/developer-tools/compiler-requests/profiler-context/modules/Context_Probe/module.jai
- tests/developer-tools/compiler-requests/profiler-context/main.jai

From this worktree, with JAIC_STDLIB=$PWD/stdlib and source-built binaries in
the assigned T7 target:

```sh
/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-context/main.jai -interp -I "$PWD/tests/developer-tools/compiler-requests/profiler-context/modules"
/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jailint -D warnings tests/developer-tools/compiler-requests/profiler-context/modules/Context_Probe/module.jai
```

First command exits0 and prints ok. Second exits1 with:

```text
#add_context after the Context type was laid out (by compile-time code that ran earlier)
```

The module only declares one bool context field and a procedure assigning true.
The program imports it, checks false, calls the procedure and checks true.
There is no profiler-specific dependency or source workaround in the probe.

The current linter Root::Module path in crates/jailint/src/driver.rs prepares
bootstrap with main :: () {} before importing the module. This lays out
Context before a legitimate module-owned #add_context can run.
Request a general ordering fix that preserves configured bootstrap parameters
and private import rules. Do not invent duplicate bootstrap bindings, suppress
diagnostics, or bypass context registration for Iprof.

Strict program-root lint of the real profiler and Codex fixtures passes. Full
owned module-root lint remains visibly failing in tools/check_profiler_codex.py;
it has no exclusions or allow rules hiding this issue. Compiler/linter sources
have not been edited by this worker.

## Entry-point selection observation

Native CLI instrumentation found that the original input's main header did not
carry ENTRY_POINT in its intercepted flags. The generated C entry wrapper is a
separate procedure. Iprof now obtains the actual configured entry_point_name
from get_build_options (defaulting to the compiler's ordinary main when empty)
and applies the documented entry-point policy to that source procedure as well
as any explicit ENTRY_POINT flag. This uses canonical configuration and real
procedure metadata; it is not a compiler bypass. An owner clarification of
which header should carry ENTRY_POINT would help other independent plugins.

## Historical ordinary standard-library body interception (resolved114dda87)

Original reproducer:
tests/developer-tools/compiler-requests/profiler-stdlib-bodies.jai, with its
profiler-stdlib-bodies-input.jai sibling. Run the source-built jaic with
JAIC_STDLIB=$PWD/stdlib and -check. It creates a NO_OUTPUT child workspace,
begins interception with flags0, compiles a main that calls real Basic.alloc
and free, observes main's TYPECHECKED body, then asserts that Basic.alloc's
ordinary body was also received. Current producer exits134 on that assertion.

Request: expose called ordinary standard-library procedure bodies and their
canonical headers through general TYPECHECKED interception before completion.
Iprof's reviewed -modules behavior includes Basic except temporary_allocator_proc
and IsScalar. This is impossible from absent body records; no fabricated AST,
stdlib-source reparser or module-specific compiler bypass is supplied.

The current Rust exporter explicitly skips modules under stdlib_root in
export_typechecked. resolved_header provides called ordinary signatures but
does not enqueue ordinary unbound procedures' bodies. This is a general
producer limitation, not a missing Iprof option parser. Imported user-module
instrumentation is verified natively at O0/O2.

## Historical safe reconciled source intake (resolved)

The inbox reports the compiler owner's e9affab7 fix and an overlapping model
fix. This worker has not merged or edited either compiler implementation.
Please synchronize the single canonical compiler-owned fix into this snapshot,
or provide the exact approved NEW source path for a read-only build using the
assigned T7 target. No old integration tree or alternate source was inspected.

## Shared tooling test classification

tools/check_developer_tools.py lines380–381 still expect the old explicit
Codex conditional/Basic metric rejection messages. Those contracts are resolved
and implemented. Integration must replace those two obsolete rejection
expectations with the positive codex-conditional, codex-lifecycle and real CLI
export fixtures. This worker does not silently skip either failure or edit the
other tooling owner's shared runner.

## Approved producer replay:114dda87 (2026-10-15)

The exact authorized NEW Rust source was archived into the owned local snapshot
`target/profiler-compiler-source-114dda87`, with own stdlib linked read-only as
build input, then built into the assigned T7 target. Archive timestamps initially
allowed Cargo to reuse stale artifacts; refreshing source mtimes forced an actual
recompilation of jaic, jaic-llvm, jaic-cli and jailint. No compiler source was edited.

The original ordinary Basic body interception probe now passes. Context-root lint
also passes with the earlier e9affab7 general ordering fix included. These two
old dependency claims are resolved.

Real Iprof `-modules` replay exposes two further general editing failures:

1. `tests/developer-tools/compiler-requests/profiler-member-modify.jai` creates
   a child workspace with an original struct containing one inline `touch`
   procedure, calls it, and modifies the returned member body without changing
   its statements. The exported member header has empty name and flags16777216.
   `compiler_modify_procedure` reports "body record does not belong to this
   workspace procedure"; the expected successful completion assertion then
   fails (exit134). The identical empty-name inline member records appear for
   the canonical Basic memory-debugger interface during real Iprof compilation.
   Request canonical member procedure identity/body ownership and modification
   support, or accurate reviewed eligibility flags if a body cannot be edited.
   Do not use module-name exclusions or skip all anonymous bodies to hide this.
2. `tests/developer-tools/compiler-requests/profiler-stdlib-modify.jai` observes
   actual called Basic.alloc, prints each unchanged statement with canonical
   Program_Print, then calls compiler_modify_procedure. Its assert call prints;
   its RETURN fails after `return allocator_call(context.allocator, ` at the
   `.ALLOCATE` enum argument. The canonical wrapper rejects the body with
   "cannot print an edited statement kind" (exit1). Request general enum-member
   expression round-trip support in exporter/printer, retaining exact source
   semantics and canonical metadata. No library-side printer/reparser is supplied.

Commands (set JAIC_STDLIB to this worktree's stdlib):

```sh
/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-member-modify.jai -check
/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic tests/developer-tools/compiler-requests/profiler-stdlib-modify.jai -check
python3 tools/check_profiler_codex.py --jaic /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jaic --jailint /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/foundations/target/debug/jailint
```

The full runner remains failing at command15, the real O0 imported-module
Iprof child build with `-modules -min_size 0`, on the body-ownership error.
No failure is reclassified as an expected success. The earlier full193-command
run on e9affab7 passed strict module-root lint and owned runtime/formatter checks,
but that producer omitted called library bodies and therefore did not exercise
the newly exposed editing failures. Current report records the actual failure.

3. `tests/developer-tools/compiler-requests/profiler-index-modify.jai` edits an
   original `indexed(values: *s64)` procedure whose only statement is
   `values[0] = 42`. Program_Print returns true but emits `(values [] 0) = 42`.
   The modification parser rejects the `]` with "expected expression"; completion
   assertion fails (exit134). This also blocks the strengthened real Iprof main
   with modules disabled, at both O0 and O2. Request correct canonical INDEX
   printing/exporting; no library-side replacement of indexed statements.

Current production guard accessors are macro expansions: actual context reads
and writes, with prior value returned/restored. This prevents recursively
instrumenting the guard itself without any ad-hoc instrumentation filter.
The current runner collects independent module-case failures while retaining
nonzero final status. No failed child build is followed by stale executable
execution. The initial command15 failure described above was the first replay;
the strengthened fixture now records all four O0/O2 module-toggle failures.
