# Profiler/Codex compiler-owner requests

## Compiler disposition 2026-10-15

The staged Context_Probe now passes strict module-root lint and program-root
execution. Module roots prepare sources and discover configured imports before
settling top-level code/finalizing Context. No duplicate context, parameter
fallback or private-import exception is introduced. Design and exact verification:
[module-root-context-ordering.md](module-root-context-ordering.md).
The remaining sections preserve the independent producer's original request;
their developer-tools paths refer to its source tree. Compiler-owned staged
copies are tests/producer-requests/profiler-context/{main.jai,modules/Context_Probe/module.jai}.

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
