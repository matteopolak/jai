# WASM workspace failure triage

Retain required WASM tests and public Thread target guards. Reproduce tour rejection and formatter failure separately, pin source/provider identity, and avoid production scheduling scopes owned by other workers.

The browser/WASI tour will consume existing private scheduler hooks, with three real barrier-synchronized prime workers and a bounded condition-variable producer/consumer queue. Check every foreign status and joined result; retain the existing output oracle. The ordinary target selector preserves the original native consumer verbatim in native.jai and selects cooperative.jai for WASM only. Public File imports remain supported on the verified603 target and are not rewritten. No stdlib or core source changes are needed for this consumer migration.

Verify the isolated tour stop under SandboxHost and emitted WASI at O0/O2, then compile the full tour without skips. Verify public Thread rejection separately. The current60d formatter exception still requires an exact immutable source/native receipt and Node exception handoff; safe603 formatting is not current60d proof.
