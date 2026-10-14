# Independent integration plan

Goal: integrate the eight manifest producer snapshots and verify the combined production tree without forbidden library inputs or staging repairs.

Architecture: one canonical `stdlib/prelude/module.jai`, public module facades over private internals, strict application imports and separate IDE recovery. Preserve reviewed working-tree specs and existing Extensions. Work inline; no subagents or publication.

- [x] Preserve authoritative startup guidance, manifest and edited specs under ignored `artifacts/integration-clean/authoritative`.
- [x] Read producer ownership, handoff, status and deviation reports; merge each manifest snapshot in a logical merge commit.
- [x] Resolve foundations overlap using designated ownership, retaining portable command-line initialization; retain compiler bootstrap constants and LSP recovery options together.
- [ ] Build combined compiler/LSP/jailint and unchanged jaifmt against production stdlib; repair general integration defects with focused regressions.
- [ ] Run workspace compiler/LSP/browser tests, original stdlib fixtures, worker suites and unused-code target checks; retain all failure evidence.
- [ ] Audit canonical identities/privacy, scalar Hash, real window/font/clipboard dependencies, SDL ABI marshalling, runtime module parameters and fault-safe pointer reads.
- [ ] Format/check/lint new stdlib/tests and verify regeneration; run Rust formatting/clippy with warnings denied.
- [ ] Run partial-edit checks over permitted independent source. Public applications require vendor-free staging and coordinator-filtered full-corpus results; do not run unrestricted fetchers.
- [ ] Review temporary-branch workflow safety and native macOS x64/Windows coverage; leave execution/publication to coordinator.
- [ ] Record exact results, present/missing modules, unresolved contracts and every detected deviation; commit durable checkpoints and refresh only stable permitted producer snapshots.

Evidence lives under ignored `artifacts/integration-clean/`. Product docs contain commands, results and gaps, never copied logs or worker scratch directories.
