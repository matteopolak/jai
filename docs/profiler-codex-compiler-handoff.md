# Profiler/Codex compiler-owner requests

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
