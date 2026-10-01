# GitHub checks and static analysis

## What it is

The public `matteopolak/jai` repository hosts the independent Rust rewrite and automated checks. A separate manually dispatched workflow inspects supplied reference bytes on a fresh GitHub-hosted ARM64 macOS runner without executing them.

## How it works

Ordinary pushes and pull requests run dependency-age enforcement, formatting, lint, Rust/native fixture tests, Python policy tests and benchmark smoke checks. The public checkout excludes `reference/`; two distribution-dependent tests and the reference benchmark are explicitly filtered in this workflow. Those checks run in the separate reference workflow. Native tests execute only fixtures compiled by our Rust compiler using independently installed Clang.

`tools/runner_inputs.py pack` packages the 702 `.jai` sources and six compiler/linker binaries as inert data. `corpus/reference-inputs.json` records each path, length and SHA-256, plus the archive SHA-256. The archive is an asset on an **unpublished draft release**, `audit-inputs-2026-10-01`, rather than public Git history or a published release. Draft releases require repository write access for ordinary users; the workflow uses its repository-scoped token only in the download step. Do not publish the input draft or put its bytes into public Git history automatically.

The dispatched `static reference analysis` workflow downloads that archive, verifies hashes, rejects unexpected members, links, duplicate names and traversal paths, and extracts files with mode `0400`. Independently installed LLVM tools read headers, symbols and every executable section. The workflow then tests our compiler against the reference text and uploads inspection reports for 14 days. It never invokes a supplied compiler, linker, installer, object or library. Static analysis cannot resolve every runtime call or establish harmlessness.

The hosted runner is a fresh VM with ARM64 hardware for `macos-14`. It has networking and GitHub's workflow infrastructure; this workflow does not claim an air-gapped execution environment. Any proposed original-binary execution still requires the user's approval after the concrete findings, and a separate reviewed isolation configuration.

## How to change it

Change `.github/workflows/ci.yml` for public compiler checks and `.github/workflows/reference-analysis.yml` for static inspection. Pin Actions to reviewed immutable commits. Keep `persist-credentials: false`, repository permissions at `contents: read`, and input analysis out of `pull_request_target` and self-hosted runners. Repackage inputs and update the manifest together when the distribution changes. Do not add original execution to a static inspection step.

Dispatch with `gh workflow run reference-analysis.yml --repo matteopolak/jai`. Inspect the actual run with `gh run view --repo matteopolak/jai RUN_ID`; a checked-in workflow is not evidence that it passed.

## Configuration

Both workflows use the pinned Rust nightly in `rust-toolchain.toml`. The public job has a 30-minute limit; static inspection has a 45-minute limit. The draft release tag and asset name are currently fixed in the inspection workflow. No personal token, project secret or host credential is provisioned to the input analysis steps.

## Dependencies

GitHub Actions standard hosted runners, the official checkout/Python/artifact Actions, Python 3.14, Rustup, independently installed Clang and Homebrew LLVM. See [GitHub's hosted-runner specification](https://docs.github.com/en/actions/reference/runners/github-hosted-runners) and [workflow permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax).
