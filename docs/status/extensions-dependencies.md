# Extensions dependency integration status, 2026-10-15

Only Io, Args, their focused regression tests and documentation are changed.
Compiler crates, replacement stdlib modules, other Extensions and peer checkouts
are unchanged. The compiler and linter used here were source-built in this
worktree with `cargo build --locked -p jaic-cli -p jailint` and the configured
LLVM23 prefix. No reference binaries or reference library inputs were used.

## Actual results

| Check | Result |
| --- | --- |
| `python3 tests/extensions/run-dependencies.py` | 118/122 pass; four genuine Linux dependency failures retained |
| Existing context, 10,000-fiber stress, channel and timer/cancellation tests | Interpreter/native O0/O2 pass with original assertions retained |
| New allocation-owner contract, scratch64/pool1 and scratch0/pool0 | Interpreter/native O0/O2 pass, no tracked allocation leaks or owner mismatches |
| Actual file-pool I/O and delayed `io_run_threads` workers | Interpreter/native O0/O2 pass with forced pool threshold0 |
| Existing Args parse/help/completion suites | Interpreter/native O0/O2 pass |
| Real Args argv/env/help/version/error processes | All45 cases pass across interpreter, native O0/O2 and actual WASI O0/O2; help/version terminate before main continues |
| Original compiler fiber tests | 3/3 pass: switches, stack-overflow diagnostics, WASM rejection; zero skipped |
| Original compiler WASI formatter tests | 2/2 pass, including build metaprogram; `JAIC_REQUIRE_WASM_TESTS=1` |
| WASI formatter O0 compared to source-built native formatter | 24/24 goldens identical; actual414-line input passes |
| Changed Jai files, actual jaifmt `--check` | 20/20 pass |
| Scoped jailint `-D warnings` in real enclosing contexts and focused tests | Exit0, no warnings/errors, no suppression |
| Windows/macOS x64 and arm64 focused source checks | 12/12 pass; no claim of native execution on those cross targets |

The matrix writes commands, exit codes, stdout, stderr and failures to its output
directory. Final retained evidence is in ignored
`artifacts/extensions-dependencies/final-process-verified/results.json`.
The original compiler tests are rerunnable with:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_REQUIRE_WASM_TESTS=1 JAIC_STDLIB="$PWD/stdlib" cargo test --locked -p jaic-cli --test native fiber -- --nocapture
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_REQUIRE_WASM_TESTS=1 JAIC_STDLIB="$PWD/stdlib" cargo test --locked -p jaic-cli --test native jaifmt_wasm -- --nocapture
```

Use jailint's supported `--context tests/extensions/io-allocator-ownership.jai`
when checking the changed Io module/loaded source paths. It supplies the actual
context extension before layout, rather than importing Io after a synthetic
program has already laid out Context. Args module/loaded paths and the focused
test roots pass directly. `io-uring-dependency-repro.jai` is a deliberately
retained failing dependency reduction, not counted as completed functionality.

## Remaining integration work

Four Linux source checks (two Io roots on x64/arm64) fail at
`Extensions/Io_Uring/ring.jai:241`: that separately owned dependency passes an
obsolete ordering argument to canonical one-argument `atomic_load`. The original
minimal reproducer is `tests/extensions/io-uring-dependency-repro.jai`; its
classified handoff is in [the inbox](../worker-inbox.md). Io's own ordering
arguments have been migrated to the compiler's sequentially consistent defaults.
No dependency guard, assertion or compiler rule was changed to hide this failure.

Broader existing Io engine suites independently expose old qualified
`Atomics.atomic_store` test dependencies and remain integrator migration work.
This scoped evidence does not replace those suites, native Linux/Windows runs,
all-workspace testing, public corpus or final release verification. Those are
coordinator work. There are no fake-success paths or fallback stubs in these
changes; allocation failure, thread preparation failure, wait failure and
platform errors retain their real failure behavior.
