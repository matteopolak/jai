# Reviewed stdlib test replacement implementation plan

> Execute inline in the integration worktree. The user prohibits delegation and
> authorizes autonomous execution; no approval checkpoint is required.

**Goal:** Replace inherited stdlib compatibility expectations with independently
reviewed public-contract tests while retaining compiler, ABI, Extensions, corpus,
LSP and issue regressions.

**Architecture:** One per-file migration manifest records every retained/moved
or retired legacy fixture and its reason. Reviewed public contracts and new
producer/module behavior suites supply stdlib acceptance; independent regression
families have their own directories and discovery. No legacy skip or procedure
coverage baseline decides whether the replacement library is complete.

**Tech stack:** Existing Rust compiler/LSP tests, Python test orchestration,
Node/WASI/browser execution, Jai fixtures, native C/SDK probes and GitHub Actions.

## Task 1: Preserve authoritative inputs and classify every legacy fixture

- [x] Back up current spec/test/guidance edits under ignored durable artifacts.
- [x] Commit independently spec-authored Basic/Hash/audio/codec fixtures and current
  constant-array/CXIndexOptions/Sound_Player clarifications separately.
- [x] Inventory all433 top-level fixtures and their imports/declared test intent.
- [ ] Create docs/status/stdlib-test-migration.json with original path, SHA256,
  disposition, destination or retirement reason, test family and provenance.
- [ ] Review compiler semantics/safety, Extensions, native ABI/algorithms,
  graphics/issue1/issue2 and helpers individually; preserve uncertain cases until
  classified. Do not derive language/API behavior from old implementations.

Validate: every file under tests/stdlib appears exactly once; retained SHA256
matches the original before path-only adaptations; every retirement has a reason.

## Task 2: Move independent regression families and preserve dependencies

- [ ] Move retained language/compiler fixtures to tests/compiler-regressions.
- [ ] Move supported Extensions fixtures to tests/extensions.
- [ ] Move native SDK/ABI/algorithm fixtures to tests/native-regressions.
- [ ] Move graphics/event/issue fixtures to tests/graphics-regressions.
- [ ] Keep the required helper modules adjacent to their importing compiler tests;
  update relative loads to actual new locations. Preserve every valid assertion.
- [ ] Record obsolete private/extra-API cases as retired compatibility tests;
  delete them only after retained dependencies and replacement coverage are clear.

Validate: explicit path map covers all Rust/Python/JS/workflow/release/PGO reads;
all selected fixture paths and helper import directories exist.

## Task 3: Replace stdlib discovery and obsolete baselines

- [ ] Refactor tools/stdlib_runtime.py to discover independently reviewed contract
  fixtures and new public module tests, plus explicit producer-owned suites.
- [ ] Keep compiler/Extensions/SDK/GPU regressions in required separate discovery;
  they do not become stdlib compatibility exports.
- [ ] Remove tests/stdlib-runtime-skips.txt and tests/stdlib-coverage.txt as legacy
  gates; preserve useful source-profiler functionality without an old API ratchet.
- [ ] Update tools/stdlib_coverage.py and tools/test_stdlib_runtime.py for the new
  catalogue and explicit supported/unavailable target reporting.
- [ ] Add explicit native O0/O2 execution to tests/stdlib-contract/run.py.

Validate: catalogue tests reject missing/duplicate sources, unknown selections,
stale moved paths and invented success; a deliberately failing new fixture makes
the aggregate runner fail. Required negative tests retain exact diagnostics.

## Task 4: Update all operational consumers coherently

- [ ] Update crates/jaic-cli/tests/native.rs, cli.rs, wasm_target.rs and relevant
  ABI helpers using the migration manifest; retain genuine compiler safety tests.
- [ ] Update tools/jaic-diff.py, tools/jaic-sweep.py, browser/playground/release
  runners, tools/http_conformance.py, tools/windows_cross.py and PGO fixture reads.
- [ ] Update .github/workflows/ci.yml, windows-native.yml, http-conformance.yml
  and release.yml paths/discovery without adding a publication trigger.
- [ ] Keep unchanged public application source, corpus and Extensions histories.

Validate: operational code has no tests/stdlib fixture reads; new native/browser
discovery executes the required replacement families; missing native dependencies
fail explicitly instead of becoming green skips.

## Task 5: Integrate and verify reviewed replacement scope

- [ ] Audit/merge remaining stable portable, bindings, audio and tooling snapshots;
  preserve current authoritative specs, private runtime hook and renderer fixes.
- [ ] Run independent contract interpreter/native O0/O2 cases, producer behavior
  suites, all required compiler/LSP/Extensions/SDK/issue regressions and supported
  unused-code target checks against the combined production library.
- [ ] Run unchanged source-built jaifmt/jailint, generation/idempotence, Rustfmt
  and warnings-denied clippy. Record all failures and unsupported native execution.
- [ ] Update docs/tools/stdlib-runtime-tests.md, docs/tools/cleanroom-integration.md,
  docs/README.md, progress/deviations, module inventory and migration manifest.
- [ ] Commit scoped reviewable checkpoints and give coordinator exact heads and
  gaps. Coordinator alone runs opaque full application corpus, native CI and Focus.

Acceptance: no legacy compatibility gate or restored unreviewed export; no lost
independent regression; exact provenance/removal records; new coverage gaps and
actual platform execution limits remain explicit. Publication remains held.
