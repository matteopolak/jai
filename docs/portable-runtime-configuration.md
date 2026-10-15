# Runtime configuration adoption

Runtime_Support now has exactly the three reviewed boolean parameters. Its private
initializer reads the NEW compiler producer's private runtime-config getter once
per context after settlement. That local controls size metadata and malloc extent.
Zero keeps null data; original extent, overflow allocation, failure cleanup and
finalization are retained. The compiler-owned helper is composed read-only.

`python3 -B tools/check_portable_runtime_configuration.py` checks the staged runtime
matches this producer, then executes root sizes 0/65536/131072 in interpreter and
native O0/O2. Independent child workspaces execute native programs with 0/131072.
Tests check actual current/original extents, null data and final-byte access.
This proves producer adoption with staged NEW dependencies, not full distribution,
Windows execution, WASM runtime or corpus integration.

Pool CAPS now precedes instance-data access because Basic's reviewed query passes
null data. It writes a static name through old_memory and returns ownership-query
and fast-bump flags. Runtime's heap also supplies a persistent name and preserves
its flags. Null name pointers support direct flags-only queries. Exact diagnostic
name spelling is independent policy; lifetime and delivery follow the oracle.

The full focused suite passes 92 cases in both modes, 22 faults in both modes,
eight compile rejections and prior SMTP/IPC/parent/startup/Linux+Windows checks.
283 owned Jai files pass source-built jaifmt --check and strict jailint.
An initial cast-assignment formatting/parser failure was fixed with explicit
blocks. The first child harness reused the root options setter and produced no
executable; the parent now configures children whose source only observes storage.
Failure logs remain target/runtime-adoption-*. No assertion was relaxed.

## Ownership handoff

Sound_Player and developer tooling are excluded going forward. Existing committed
audio work remains intact. These provisional files remain durable, uncommitted,
excluded from portable checkpoints and formatting mutation:

- stdlib/Performance_Report/module.jai
- stdlib/internal/profiling/compiler-report.jai
- tests/portable-stdlib/performance-report/main.jai

They received interpreter-only checks with NEW foundation formatting dependencies,
including genuine missing-report diagnostics. Final native/strict-lint checks are
absent; they are not completed functionality. Tooling owns completion and the
coordinator selectively handles these files. No peer checkout was edited.
