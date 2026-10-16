# Clipboard Linux CI toolchain provisioning

Normal CI run `38933357784`, job `117082611052`, failed during **Install source
build and ephemeral display dependencies**, before the Clipboard helper/runtime
checks. The coordinator supplied this filtered failure:

> failed to install component rustfmt-preview-x86_64-unknown-linux-gnu … detected conflict bin/cargo-fmt

This establishes a Rust toolchain component-installation failure, not a
Clipboard API or X11 failure. The filtered context does not establish the origin
of the conflicting file or whether the error came from the explicit install or
a later proxy-triggered component installation. No remote logs or credentials
were accessed by this worker.

`rust-toolchain.toml` requires `nightly-2026-08-29`, profile `minimal`, and both
`rustfmt` and `clippy`. The previous Clipboard setup explicitly requested only
the minimal profile. The revised workflow requests both components at initial
installation, matching the main CI setup and the canonical toolchain file.
The repository's canonical pin and required components remain unchanged.

Before installation, a separate step publishes disjoint `RUSTUP_HOME` and
`CARGO_HOME` paths under `RUNNER_TEMP`, qualified by run ID and attempt, through
`GITHUB_ENV`. Later steps inherit those paths. This isolates downloaded
toolchains, component ownership metadata and Cargo state from pre-existing
runner installations. Setup requires the paths to be absent; it does not delete
or repair global runner files. Job-wide `RUSTUP_TOOLCHAIN` selects the same dated
pin for all subsequent Cargo subprocesses, and `RUSTUP_AUTO_INSTALL=0` prevents
implicit installation of a missing active toolchain. Explicit rustfmt and clippy
version checks fail setup if their installation did not succeed.

These settings follow the official Rustup documentation for
[environment variables](https://rust-lang.github.io/rustup/environment-variables.html),
[components](https://rust-lang.github.io/rustup/concepts/components.html) and
[toolchain-file overrides](https://rust-lang.github.io/rustup/overrides.html).
They remove reliance on inherited component state without asserting an
unobserved cause for the original conflict. A malformed distribution or other
installer failure would still fail normally; there is no fallback toolchain,
fake formatter, ignored installation error or formatter waiver.

`tools/test_clipboard_linux_toolchain.py` uses only the Python standard library.
It checks canonical pin/profile/components, persistent isolated state,
per-attempt paths, component verification before locked fetch, and workflow
triggers. It also preserves the existing real runtime/helper/Xvfb/relocated
package steps byte-for-byte. The workflow runs this regression before installing
Rust. The original configuration produced six failures out of eight tests; the
corrected configuration passes all nine, including actual shell execution of
the environment-publication step with a spaced temporary path. This executes
only the two configuration writes, not an installer or simulated toolchain.
Actionlint, Ruff check/format and
whitespace checks also pass. An intermediate Actionlint rejection of
`runner.temp` in job-level `env` was corrected by using the supported separate
`GITHUB_ENV` publication step; it is recorded with the failed local receipts.

Verification is source/configuration only. No Rust toolchain was installed
locally, no Cargo build or native/SDK/GUI/fault program was run, and no workflow
was pushed or dispatched by this worker. Root owns the normal CI rerun, logs
and remote operations. Its full-workspace native lease and human-skipped
benchmarks remain untouched. Actual Linux provisioning/runtime/package success
requires a subsequent normal CI run. All earlier failed receipts and the final
source marker remain preserved; Clipboard production and runtime tests are
unchanged.
