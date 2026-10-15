# Android logger canonical discard integration

The coordinator explicitly supplied the clean private Runtime queue module
from `b2e90f76fcc39ea8ced96c2f93ca1bf442a67686`, with producer-reported discard
origin `ca8570d`, at
`artifacts/android-discard-dependency/stdlib/internal/runtime/android-output/module.jai`.
Its SHA-256 is pinned in
[android-logger-runtime-inputs.json](android-logger-runtime-inputs.json).
No history or peer implementation checkout was accessed.

The owned Android logger now calls the canonical private
`internal/runtime/android-output.discard_pending_output()` through a small
private logging core. The forced public Runtime flush has been removed. Runtime
retains both queues and their synchronization; bindings create no output buffer,
lock substitute, context field, or public export. Tag/payload C-string copies
remain owned until the actual native log sink returns, then are freed. Existing
reviewed priority/tag/data behavior and public signatures remain exact.

The discard operation acquires Runtime's existing lock, clears both counts and
releases the lock without invoking its descriptor sink. No further fine flush
policy review is needed for that operation. The private binding core accepts a
typed C sink so the real Android facade supplies `__android_log_write`, while
independent host controls can observe actual descriptor output without mocking
the Android SDK. This adds one indirect sink call; it introduces no second
pending queue or allocator/context mutation.

The new host test appends stale bytes to both canonical queues through two
import aliases, invokes the production binding core, forces the queues to flush,
and requires no stale bytes to appear. Fresh stdout/stderr bytes must remain
observable. It also tests retained partial lines, section/default tags, priority
precedence and unchanged caller allocator identity. Interpreter, native O0/O2
and native sanitizer executions compare complete stdout and stderr. A forced
flush would produce extra stale bytes and fail these controls.

Current execution evidence is **incomplete**:

- `.work/android-logger-discard-initial.json` preserves actual failures: the
  supplied queue imports `internal/runtime/output-lock`, absent from both the
  artifact and independent local test baseline. Four host source configurations,
  interpreter/native builds and strict context lint fail on that exact missing
  module. No placeholder lock was created and no host pass is claimed.
- Android x64/ARM64 source checks still fail target selection with
  `unknown OS android`. Device logging, full Android type/lint checking and
  native SDK execution remain required and unverified.
- Owned wrapper/core/test formatting passes, Python syntax checks pass and all
  80 existing Python regressions pass. The producer's reported host/native/lint
  passes are dependency provenance, not this worker's execution evidence.
- The Android logger ledger remains partial for the missing transitive test
  dependency; the old forced-flush reason is retired. Telemetry fourteen and the
  other existing partial inventories are unchanged.
- The exact target audit from `9bc40a8` and its six required Android controls
  are unchanged. No shared expected ledger, ABI assertion, privacy rule or
  Extensions source was modified or waived.

Portable owner/integrator handoff: provide the committed
`stdlib/internal/runtime/output-lock/module.jai` and its transitive imports in
the authorized artifact tree. Integrate the same canonical queue module with
the portable owner's current Android write/flush path, rather than retaining
an older separate buffer. The consumer imports the exact unparameterized module
path above and does not need a public Runtime API change. The precise request
is also at the top of the worker progress file; this is source dependency
coordination, not a request to re-review the resolved discard behavior.

Reproduce once the transitive source dependency is supplied:

```sh
python3 tools/native_bindings/verify_android_logger.py \
  --compiler .work/target-producer-refresh/debug/jaic \
  --jailint .work/target-producer-refresh/debug/jailint \
  --existing-stdlib .work/runs/x11-android-reviewed-final-55114/stdlib \
  --report .work/android-logger-discard-current.json
```

The driver reads only the supplied artifact and existing independent stage,
refreshes owned bindings, and retains source hashes and real output. Missing
dependencies and required Android checks return a nonzero result. It does not
convert producer-reported passes or unsupported targets into successful tests.
