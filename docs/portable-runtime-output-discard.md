# Runtime pending-output discard handoff

The filtered2026-10-15 coordinator request requires discarding pending Basic
write-string bytes before Android SDK logging. Forced flush emits those bytes and
is not equivalent. Runtime now owns one private canonical queue module:
`internal/runtime/android-output`. Binding callers should invoke its
`discard_pending_output()` before the SDK log write. No Runtime_Support public
discard export or invented Basic API is added.

The queue owns fixed4096-byte stdout/stderr buffers and a shared output lock.
Discard resets pending lengths without a write/sink call. Flush emits pending
bytes; ordinary line/capacity flushing and explicit forced partial flushing remain
distinct. Android Runtime write-string paths use that same queue, and the reviewed
Android-only `android_flush_write_string_buffer(force := false) #no_context`
facade is supplied. Existing desktop raw descriptor writes retain their path and
partial-write/error handling. The lock is a general private module shared by
Runtime writes/queue operations, with actual CAS and explicit release failure.
The unsynchronized entry still requires caller synchronization, as its name says.

`pending/android-logger-discard.patch` is an exact patch against the NEW independent
bindings producer's current wrappers.jai. It replaces only the forced flush/import
with the private discard/import. It has not been applied to the peer checkout.
Coordinator/bindings owner must adopt it and rerun Android checks; until then the
bindings logger remains partial. This is not claimed as already integrated.

`python3 -B tools/check_portable_runtime_output.py` passes actual stdout/stderr
suppression, newline/partial/forced/capacity flushing and unchanged desktop writes
in interpreter and native Mac O0/O2. Full scoped jailint -D warnings and owned
jaifmt/--check pass. The private fixture is copied byte-identically into a test-only
library module under target, and an external driver invokes its entry point.
This uses normal library privacy; direct external internal imports remain rejected
(original red preserved). No public facade or compiler privacy rule is weakened.
Generated driver/module are formatted and checked. These are actual host byte-I/O
tests of the Runtime kernel, not Android SDK/device execution or a synthetic SDK
logging result. Evidence: target/runtime-output-discard-red.log and
runtime-output-discard-final.log.

Remaining verification/contract limits: Android target selection is still rejected
by the compiler, so the platform connection/public Android flush branch/device
logging remain unexecuted. The reviewed page does not specify exact buffering
capacity, timing, or force=false finer policy; the independent implementation
flushes complete lines, forces capacity blocks to bound memory, and flushes all
pending bytes when force=true. It retains the ordinary raw descriptor sink rather
than inventing a logcat tag/priority mapping. Dirty review should refine any more
specific Android flush/sink guarantee before this is claimed exact Android
conformance. The requested private discard behavior itself is implemented and
host-verified, with explicit peer-adoption/native gates.
