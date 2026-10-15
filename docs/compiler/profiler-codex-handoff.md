# Profiler/Codex compiler-owner requests

## Compiler disposition: ordinary library interception

The staged profiler-stdlib-bodies reduction now receives Basic.alloc before
successful COMPLETE. General library declaration/callee scheduling uses the
canonical exporter, without a Basic/Iprof exception.
[Design and verification](canonical-library-interception.md) cover filters,
aliases, generic/baked metadata and private scope. Full Iprof integration remains
a producer replay. Context ordering is fixed in canonical checkpoint e9affab7;
no overlapping model implementation was imported. Remaining text records the
independent producer request rather than current compiler results.

## Reduced module-root context/lint reproduction

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

## Ordinary standard-library body interception

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

## Safe reconciled source intake

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
