# Android logger canonical discard integration

The public Android logger uses the canonical private
`internal/runtime/android-output.discard_pending_output()` through the owned
typed C-sink core. Runtime owns both pending queues and their output lock.
Bindings adds no buffer, lock, context field or public API. Tag and payload
C-string copies live until the native sink returns, then are freed.

In the shared tree, ordinary Android Runtime writes call this same module's
`append_unsynchronized`; flush calls its `flush`. Discard acquires the same
output lock, clears both counts and emits nothing. The previous missing
transitive-lock/input handoff is resolved by current shared source. The old
artifact pin documents historical provenance; it is not a build overlay.

The Android facade supplies the actual `__android_log_write` sink. Independent
host controls use real descriptor writes, testing the production logging core
and canonical Runtime queues without claiming Android SDK execution. This
test seam adds one indirect sink call, with no second queue.

The canonical static fixture is
`stdlib/Android/tests/logger-output.jai`; the ordinary test entry in
`tests/native-bindings/android-logger-output.jai` loads it. Keeping private
imports in the library fixture satisfies the normal per-source privacy rule.
The runner never copies source into stdlib during testing.

Fresh shared-tree evidence on Mac ARM64:

- Interpreter, native O0/O2 and address/undefined sanitizer executions match
  complete stdout and stderr. Stale bytes from both queues disappear; fresh
  output, partial-line clearing, tags, priority precedence and caller allocator
  identity remain checked.
- Mac/Linux x64/ARM64 source checks pass. Linux and Mac x64 source checks are
  not native runtime evidence.
- Strict context lint, source-built production formatter checking and shared
  source immutability pass.
- Eight required Android checks remain unverified: logger helpers plus the
  six AAudio/EGL/POSIX x64/ARM64 checks. The compiler rejects `-os android`.
  Android type/lint/device execution remains a required platform gate.
- Enabled telemetry's fourteen missing declarations require the genuinely
  unavailable matching commercial ABI; no enabled implementation is invented.

The latest receipt is
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/bindings/target/shared-bindings-66813/android-logger-shared-final.json`.
Earlier unsuccessful privacy/context attempts remain in that scratch directory.
They are harness-setup failures, not Runtime behavioral failures or passes.
Historical missing-lock results are superseded, not relabeled as successful.

Reproduce against actual shared source with independently source-built tools:

```sh
python3 tools/native_bindings/verify_android_logger.py \
  --compiler /path/to/worker-target/debug/jaic \
  --jailint /path/to/worker-target/debug/jailint \
  --formatter /path/to/worker-target/jaifmt-shared \
  --output-root /path/to/worker-private-scratch \
  --report /path/to/worker-private-scratch/logger-report.json \
  --native
```

Omit `--native` during a native-slot hold; the report records native work still
required. Coordinate scoped native execution with the integration owner.
The driver returns nonzero for any failed or unverified required gate, including
unavailable Android targets. It records tool/source hashes and fails if shared
source changes during the run. It never uses old clone staging or Runtime
overlays, and does not mutate expected ledgers or immutable native fixtures.
