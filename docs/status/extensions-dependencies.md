# Extensions dependency integration status, 2026-10-15

Only Io, Args, the explicitly authorized Io_Uring dependency migration, their
focused regression tests and documentation are changed.
Compiler crates, replacement stdlib modules, other Extensions and peer checkouts
are unchanged. The compiler and linter used here were source-built in this
worktree with `cargo build --locked -p jaic-cli -p jailint` and the configured
LLVM23 prefix. No reference binaries or reference library inputs were used.

## Actual results

| Check | Result |
| --- | --- |
| `python3 tests/extensions/run-dependencies.py` | 122/122 pass; the four Linux dependency failures are repaired |
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
| Linux x64/arm64 focused source checks | 6/6 pass |
| Original Io_Uring dependency reproducer and raw kernel test source | Both source-check on Linux x64/arm64 (4/4); neither executed as a Linux program here |
| Caller-memory protocol regression | Interpreter/native O0/O2 pass, including 1000 handshakes with a real second host thread |
| Io_Uring strict lint | Both Linux CPUs pass in the real raw-test context; portable protocol test passes host lint |
| Io_Uring changed sources and regressions formatting | All4 files pass actual jaifmt `--check` |
| `python3 tests/extensions/run-uring-protocol.py` | 13/13 pass; explicitly no Linux kernel execution |

The matrix writes commands, exit codes, stdout, stderr and failures to its output
directory. Final retained evidence is in ignored
`artifacts/extensions-dependencies/uring-final/results.json`.
The original compiler tests are rerunnable with:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_REQUIRE_WASM_TESTS=1 JAIC_STDLIB="$PWD/stdlib" cargo test --locked -p jaic-cli --test native fiber -- --nocapture
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= JAIC_REQUIRE_WASM_TESTS=1 JAIC_STDLIB="$PWD/stdlib" cargo test --locked -p jaic-cli --test native jaifmt_wasm -- --nocapture
```

Use jailint's supported `--context tests/extensions/io-allocator-ownership.jai`
when checking the changed Io module/loaded source paths. It supplies the actual
context extension before layout, rather than importing Io after a synthetic
program has already laid out Context. Args module/loaded paths and the focused
test roots pass directly. `io-uring-dependency-repro.jai` retains the original
source-only reduction and now compiles on both Linux CPUs. Its uninitialized
ring must never be submitted at runtime.

## Remaining integration work

The coordinator extended ownership to Io_Uring; all eight obsolete atomic calls
now use the canonical signatures. The supplied compiler selects sequential
consistency, at least as strong as the earlier acquire/release/relaxed uses.
No kernel record, mapping lifecycle, syscall, ring-index owner, public signature,
guard, assertion or compiler rule was changed. Ring memory still comes from real
`mmap` and is released by `munmap`; it is not Basic-allocator storage.

The real host is Darwin arm64. No Linux native kernel execution is available
in this worktree. The Linux raw NOP/batch/file/probe/timeout/mapping suite was
source-checked, not executed or reported as skipped success. The host protocol
test directly loads production queue source, uses caller-owned memory, and
executes real host atomics and a second host thread. It never calls or replaces
a kernel syscall, so it establishes userspace queue behavior and host publication
visibility, not Linux syscall ABI, SQPOLL wakeup, mmap cleanup or kernel acceptance.
Stronger ordering may incur target-dependent barriers/locked stores and inhibit
reordering; no Linux performance measurement is available. See
[Io_Uring's protocol verification](../extensions/io-uring.md#canonical-atomics-and-protocol-verification)
for commands and boundaries.

Broader existing Io engine suites independently expose old qualified
`Atomics.atomic_store` test dependencies and remain integrator migration work.
This scoped evidence does not replace those suites, native Linux/Windows runs,
all-workspace testing, public corpus or final release verification. Those are
coordinator work. There are no fake-success paths or fallback stubs in these
changes; allocation failure, thread preparation failure, wait failure and
platform errors retain their real failure behavior.
