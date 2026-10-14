# Clean-room integration verification

This is the replacement independent integration workspace. Only the sanitized baseline, manifest producer refs, reviewed specs and independently authored sources are implementation inputs. Quarantined integration code/history/transcripts and vendored corpus modules are not inputs. No reference binary, subagent, publishing or credential access is authorized.

## Integrated snapshots

Exact source OIDs are recorded in [the manifest](../integration-inputs.json). Merge order: compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP, SDL3. Each has a separate merge commit. Foundation builder/formatter/scalar/File_Utilities implementations supersede overlapping portable versions; portable argument initialization remains loaded and exported. LSP IDE recovery retains the compiler's canonical bootstrap entry constant. SDL3 merge references issue #2.

At startup `docs/implementation-ownership.md` was absent. The permitted compiler snapshot supplies it; it was read before integration. Latest reviewed startup guidance and 26 edited spec pages were preserved in ignored artifacts and restored after merges. Existing Extensions are unchanged except the new SDL3 directory. Upstream SDL license whitespace is preserved verbatim.

## Verification commands and results

Pending combined-tree verification; producer staging passes are not production proof.

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm TMPDIR="$PWD/artifacts/integration-clean/tmp" RUSTC_WRAPPER= cargo build --locked -p jaic-cli -p jailint -p jai-language-server
```

Build exited zero (11.22s). Output: `artifacts/integration-clean/build.log`.

`JAIC_STDLIB="$PWD/stdlib" target/debug/jaic jaifmt/main.jai -O2 -exe "$PWD/target/jaifmt"` exited zero, using unchanged repository tool sources and production dependencies. No numerics tool-bootstrap helpers or fixture library overlay was used.

## Required external verification

Coordinator must run full original public corpus with opaque vendored sources and return filtered results/minimal independent reproducers. Local checks must use unchanged permitted application entry sources with vendor-free staging and explicit provenance. No unrestricted corpus/application fetcher is permitted here. Native Windows/macOS x64 and other unavailable targets require actual CI execution; source checks do not establish runtime support. Focus must be built/launched by coordinator after full tests and accepted by user, including issue #1 signed mouse-wheel propagation, before v0.17.1 publication. No release or historical rebuild is authorized here.

See [integration audit](../status/integration-deviations.md), [plan](../plans/cleanroom-integration.md) and [requests](../integration-requests.md).

## Compiler corrections verified

`cargo test --locked -p jaic --lib --test cleanroom_modules --test cleanroom_literals --test cleanroom_layout` passed: 150 core unit, 39 module, five literal and three layout tests. `cargo clippy --locked -p jaic --lib --tests -- -D warnings` exited zero. Scoped rustfmt ran over the five modified Rust files. Red/green logs are retained for protection-change SIGBUS, bundled parameter checking and IDE entry admission. Runtime_Support retains its exact reviewed three parameters.

Initial `cargo test --locked --workspace --no-fail-fast` reports 21 failed targets (one raced the newly added runtime regression before its fix). All failures remain in `workspace-all.log`, including native ABI, missing reviewed modules, LSP facade metadata and Wasm runtime dependencies. Doctests also fail under this repository custom-build artifact arrangement; this is not waived. Full rerun follows corrections.
