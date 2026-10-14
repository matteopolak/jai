# Platform I/O implementation plan

The reviewed `docs/specs/stdlib/modules` contracts are the API oracle. Work is
inline in this checkout, without delegation or manual approval, as requested.

## File (first checkpoint)

- Add original public behavior fixtures for binary read/write, all seek origins,
  EOF, preserved/truncated content, links, Unicode paths, empty files, mapping
  ownership and Windows canonical paths. Establish the Windows source-check
  failure before implementation.
- Separate shared convenience operations from native Unix and Windows operations.
  Keep the existing Unix stdio implementation. Windows uses non-inherited Win32
  handles, strict UTF-8/UTF-16 conversions, synchronous bounded read/write loops,
  64-bit positions, native hard links and directory operations.
- Preserve conditional public records and defaults. Implement read-only native
  mappings and explicit cleanup, including partial failures and borrowed strings.
- Run source checks with `-no_dce` for Windows x64/arm64 and Unix; run original
  fixtures in host interpreter and native O0/O2. Supply a Windows runner hook;
  host cross-checks do not establish Windows runtime correctness.
- Build the repository formatter/linter from source using new producer
  dependencies; format/check idempotence and lint only the owned paths.
- Document supported semantics, unresolved contract questions, deviations and
  verification evidence, then commit only this worker's changes.

## Subsequent checkpoints

Read current independent Process, System, Thread and Runtime_Support sources and
their reviewed specs. Add dedicated Windows implementations while retaining
working Unix mechanisms. Validate each subsystem with original behavior fixtures,
both Windows architectures' source checks, host preservation tests, and Windows
native runner hooks. Record compiler integration blockers with original minimal
reproducers. Commit each coherent verified batch and continue.
