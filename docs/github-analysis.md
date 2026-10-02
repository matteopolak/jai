# GitHub compiler checks and reference inspection

## What it is

The public `matteopolak/jai` repository hosts the independent Rust rewrite and compiler checks. A manually dispatched workflow statically inspects the supplied macOS compiler in a fresh native ARM64 hosted VM.

## How it works

Pushes and pull requests run dependency-age enforcement, Rustfmt, Clippy, Rust/native fixture tests, Python policy tests and benchmark smoke checks. Public Git history excludes `reference/`; two distribution-dependent tests and the reference benchmark are explicitly filtered. Local checks with the reference run them without filters. Native tests execute only fixtures compiled by our Rust compiler through trusted Clang.

The user initially declined reference transfer, then explicitly authorized the Jai binary as a release asset for CI. The compiler binary `reference/bin/jai-macos` is uploaded to release `reference-0.2.009`; the six-binary/source archive was never uploaded. This public asset is a supplied input fixture, not a release of our Rust compiler. The user subsequently authorized the single inspected bootstrap `Preload.jai`, which is tracked under `vendor/jai-0.2.009/modules/` for bounded probes. The rest of the reference source distribution remains local. No supplied binary enters Git history.

The inspection workflow downloads that asset using its repository token only in the download step, removes executable permissions, verifies SHA-256, and uses independently installed LLVM to read headers, symbols and executable sections. It retains disassembly/capability reports for 14 days. This static workflow never invokes the supplied executable or loads its libraries.

`macos-15` is a fresh ARM64 GitHub-hosted VM. Networking and workflow infrastructure remain present; this is not air-gapped isolation. The standard public runner is free under [GitHub's runner specification](https://docs.github.com/en/actions/reference/runners/github-hosted-runners). Static inspection cannot prove harmlessness. The user also authorized original execution in CI. The separate [bounded probe workflow](reference-probes.md) limits that experiment to sandboxed developer help after hosted static inspection.

## How to change it

Change `.github/workflows/ci.yml` for compiler checks and `reference-analysis.yml` for static inspection. Pin Actions to reviewed commits, retain `persist-credentials: false` and `contents: read`, and keep reference work out of `pull_request_target` and self-hosted runners. Update the release asset, SHA-256 and documentation together when changing the reference.

Dispatch with `gh workflow run reference-analysis.yml --repo matteopolak/jai`. Inspect real runs with `gh run view --repo matteopolak/jai RUN_ID`; checked-in workflows do not establish that checks passed.

## Configuration

Compiler CI uses the pinned Rust nightly, Python 3.14 and independently installed LLVM 22. Both jobs have 30-minute limits. The inspection release tag and expected digest are fixed in its workflow. No project secrets or personal tokens are provisioned to inspected code.

## Dependencies

GitHub standard hosted runners, official checkout/Python/artifact Actions, Python, Rustup, Homebrew LLVM and Clang. See [workflow permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax).
