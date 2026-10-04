# Jai compiler handoff

## Current checkpoint

The repository is on `main` at commit `13ae2fa` (`Stabilize compiler integration checkpoint`), pushed to `origin/main`. The working tree was clean after the push. This is a substantial integration checkpoint, not a finished compiler: Rust crates compile, but the full test suite is not green and standard-library/upstream project acceptance remains incomplete.

Do not run any supplied reference binaries. The user explicitly asked that they remain unexecuted unless they first review static-analysis findings and approve execution. Reference source files may be inspected as compatibility inputs.

## What is in the repository

The workspace separates the lexer/parser, source and type identities, modules, semantic analysis, typed IR, VM, LLVM code generation, compiler driver, native CLI, runtime, platform services, LSP, Wasm bridge, and benchmarks into crates under `crates/`. Start with [README.md](README.md), [docs/README.md](docs/README.md), [compiler architecture](docs/compiler-architecture.md), and [completion plan](docs/completion-plan.md).

The repository also includes an independently authored standard library in `stdlib/`, examples, local reference inputs in `reference/`, pinned upstream project inputs, fuzz targets, and several benchmark suites. The reference standard library was not copied as the implementation; however, the included authored standard library and requested upstream projects have not all passed compilation or runtime acceptance.

The root `docs/` folder contains subsystem design and change guides. Update the relevant feature document and `docs/README.md` when making meaningful changes. Rust formatting uses the pinned nightly toolchain; run `rustup run nightly-2026-08-29 cargo fmt --all -- --check`.

## Verification at this checkpoint

Formatting and `git diff --check` passed before commit. The full workspace test command compiled the crates and ran all test targets without fail-fast:

```sh
env RUSTC_WRAPPER= CARGO_INCREMENTAL=0 \
  CARGO_TARGET_DIR=/Volumes/CodexBuilds/targets/jai \
  LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm \
  rustup run nightly-2026-08-29 cargo test --workspace --no-fail-fast --locked -j 1
```

It exited with 39 failing test targets. Many other targets passed, including the native CLI, large sections of codegen and VM behavior, and the LSP protocol/source/stdio tests. The Wasm crate's two tests passed, but a separate browser acceptance run was not performed. Do not treat those passes as proof that all requested features work.

The failing targets reported at the end of that run were:

```text
jai-codegen: loop_control_replacements, native_global_reachability,
  native_pointer_constants, operator_overloads, parameterized_records,
  procedure_values, source_run, standalone_using, storage_alignment,
  storage_bitcasts_ir, typed_record_constants
jai-driver: lib, file_abi, heap_abi, module-parameter-discovery, process_fcntl
jai-modules: lib
jai-sema: lib, any_values, context-bootstrap, context-default-readiness,
  emitted-debug-sources, local-record-conditions, operator-overloads,
  ordered-record-source-metadata, parameterized-records,
  promoted-record-literals, reflection, source-external-data, source-run,
  stallable_runs, storage_bitcasts, type-restriction-facts,
  using-prefix-environments
jai-syntax: lib, external-data, inline-storage-boundaries, project_source_forms
jai-vm: lib
```

That test run also printed a high number of unused/dead-code warnings in `jai-sema` and several neighboring crates. The tree contains new or partially connected modules, so check whether an item is deliberately awaiting integration before adding more suppression or duplicate APIs.

## Highest-value next steps

1. Re-run the full test command on the committed tree and save its complete output to a temporary log so all diagnostics can be triaged together. Use the T7 target directory if it is mounted; otherwise select a writable target and avoid the shared target used by other projects.
2. Group failures by root cause before editing. Several failures share clear themes: fixture/bootstrap code expects `TEMPORARY_STORAGE_SIZE`; record placement and promoted-literal behavior disagree across sema, IR, VM and codegen; and source `#run`/workspace effect scheduling still has unresolved suspension and publication cases. Other failures concern type/member lookup, aliases, alignment dependencies, and pointer provenance. Fix one cross-crate contract at a time and run its focused tests, then repeat the complete no-fail-fast suite.
3. Keep the CLI and host-services boundary honest. A prior working-tree attempt wired `--host-file-*` options to a nonexistent `WorkspaceScheduler::with_host_services` method; that CLI wiring was removed before commit. `jai-driver/src/platform_session.rs` and related pending tests exist, but do not claim they are integrated into the native CLI or browser virtual filesystem until the scheduler, source provider, suspension lifecycle, and both callers are connected and tested.
4. Check the public CI workflow on this pushed commit. It runs format, clippy, no-fail-fast tests, policy checks, benchmark smoke checks, and a separate LLVM-free Wasm build/execution job. The workflow deliberately reports all gate outcomes; local test success alone does not establish hosted status.
5. Resume acceptance in compiler stages: tokenize recent upstream projects, parse them, typecheck them, then execute/compile real programs. Keep the project's compatibility matrix and standard-library coverage docs tied to measured results. The README and [completion plan](docs/completion-plan.md) already state that full library and project acceptance is pending.
6. Do not spend time on isolated micro-optimizations until correctness reaches the relevant stage. Benchmarks are present; use them after focused correctness fixes to detect regressions.

## Notes for future integrations

- The user's design preference is typed boundaries and enums over stringly typed protocols, with “parse, don't validate” as a guiding principle. Keep compiler-independent core logic free of operating-system assumptions; platform access should pass through explicit host/source-provider interfaces that native and browser implementations can provide.
- The browser playground should have a file tree on the left, a capable Jai editor, and the Run button at the editor's upper-right. The user specifically asked to move Run out of the terminal. The portfolio integration is a separate repository/task; the Jai repository's Wasm and LSP outputs must be verified before updating its asset pointers.
- User preference for delegation: reuse existing agents where possible and prefer Luna agents for routine work; use Sol for harder tasks. The previous team had many long-lived or failed agents. Check agent status and ownership before starting more work, and treat frozen packets under `artifacts/agent-packets/` as uncompiled proposals unless a manifest proves they apply to the current source hashes and their integration tests pass.
- The user asked for regular commits and pushes. Commit coherent, reviewable progress to `main` and verify `git status -sb` and the remote ref afterward.


## Status 2026-10-04

- focus-editor `first.jai` passes `jaic check` (case `focus-build` in `tools/upstream-cases.json`); sweep 143/144 (only the expected negative control fails).
- The_Way_to_Jai: 42 of 315 example files fail `jaic check`. Some are expected: Windows-only code, missing raylib/glfw native libraries, intentional `#assert` failures, `.build/` artifacts. Real gaps found:
  - void values: `print` of a `void` variable, `<< ptr` on `*void`
  - `make_leak_report` should return `Leak_Report` only; the `-> string` overloads in `stdlib/Basic` are non-standard
  - `#procedure_of_call` with runtime locals
  - `Program_Print.print_expression`, `compiler_get_code`, `add_global_data`
  - `#modify` require (26.32), a parse error in 26.5, `#insert,scope` (26.22/26.39)
  - GetRect `ui_per_frame_update` on macOS (NSWindow)
  - `Sound_Player`
  - Mail `min` without a context
  - a backtick name outside a macro (31.2)
- Known open bug: forwarding a `for_expansion` body Code to another macro (`for_expansion(*a, body, flags)`) inserts nothing.
