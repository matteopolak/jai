# Workspace-options matrix failure disposition

The coordinator's sanitized 833 inventory records both assigned tests failing in
all four compiler jobs (117201497107, 117201497119, 117201497228, 117201497237).
Those jobs were cancelled after actual failures; none is a passing matrix result.
The inventory contains names, not per-test diagnostics. Original per-host causal
attribution therefore remains pending the requested sanitized stderr excerpts.

## Source-matched local result

An isolated snapshot of accepted source
`a41b53e3e28c26f8e8b88d83b846c05e410fd917` was freshly built offline into the
assigned T7 numerics namespace. Both original tests were run unchanged, serially:

- `build_file_paths_preserve_caller_location_and_explicit_absolute_controls`
- `selected_workspace_options_survive_child_and_grandchild_compilation`

With no native provider assets installed, both failed at child emission because
`crash-native/portable_crash` was missing. The first reported the same missing
provider for direct, explicit-location and absolute-path children; the second
reported it for child and grandchild. Neither failed an option snapshot or path
semantics assertion. These actual failures remain in the baseline receipt.

Only `python3 tools/build_portable_runtime.py` was then run in that same source
checkout. It built the real independent canonical C implementation into matching
static/shared Mac ARM64 providers, verified the object target and recorded source
and artifact hashes. No Debug provider, substitute C library or supplied binary
was added. The exact same compiler binary, test sources and assertions then
passed both tests. The tests exercised interpreter/O0/O2 parent compilation and
actual native child/grandchild outputs. Their unchanged helper-default rejection,
helper-local selection, explicit location, absolute path, ownership, temporary
storage boundary writes and workspace isolation assertions all remained active.

The other four tests in `cleanroom_workspace_options` also passed in focused
serial invocations: invalid workspace reads, dynamic updates/optimization reset,
isolated cross-target host registry, and the unchanged independently authored
portable projection/relative-path controls. Thus all six tests in this file were
executed; no assertion, expected diagnostic or test selection was changed.

## Required integration dependency closure

There is no evidence here warranting another compiler options/path repair. Do not
revive the retired cwd path premise, change public defaults, disable backtraces,
introduce global options fallback or weaken the tests to avoid linking.

The pinned compiler matrix job in `.github/workflows/ci.yml` reaches Cargo native
tests without running the canonical crash provider builder. The stdlib runtime
job separately prepares that provider; its assets are not another job's assets.
An external `JAIC_NATIVE_LIBS` search directory does not replace installing this
source-relative `crash-native/portable_crash` provider for the tested checkout.

Integration must run the source-matched host provider bootstrap after installing
and verifying the actual host LLVM/C SDK, before the compiler matrix's Cargo
native tests. For these two tests, the sufficient missing prerequisite is:

```sh
python3 tools/build_portable_runtime.py
```

Keep real target verification and static/shared source identity. Integration also
owns the separately reported Debug/clang provider closure for other suites. Local
success after building only crash does not establish that other suites need no
Debug dependencies. Current shared workflow WIP adds developer helpers in other
jobs; its difference from the pinned workflow is captured separately, and still
does not add this compiler-job prerequisite. This worker did not alter workflows.

## Evidence and limits

Receipts are under `numerics/compiler-workspace-matrix-a41b53e3/capture` on T7:
source build, baseline two failures, canonical provider build/hash receipt, five
focused passing tests and the final independent-control pass. Eleven original
compiler/test/provider inputs and four additional public/private Compiler sources
remain byte-identical to shared production. The pinned and current-WIP workflow
hashes are distinguished rather than treated as one source pin.

This is actual local Mac ARM64 native proof, not Linux/Mac Intel execution or a
green replay of the cancelled 833 jobs. The source/provider hashes and raw local
commands/status/output are listed in the new ready manifest. No reference compiler
or body, old alias patch, moving HEAD rebuild, native provider copy, GUI/fault,
network, benchmark or full-corpus execution was used. All bounded own children
returned/reaped and the serialized native slot is released.

The new patch is documentation only. Integration alone changes shared Git and
the provider workflow; no compiler production edit is proposed without a genuine
remaining source-matched semantic regression.
