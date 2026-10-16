# Shared-memory channel audit

The 34 reviewed declaration rows have real implementations. The circular packet
protocol uses atomic cursor publication and contiguous packets, with explicit tail
skipping when a packet cannot fit. Public record layout and module-local registration
storage remain unchanged by this audit. No production repair was needed for the
supported sequential reserve/commit and poll/done workflow tested here.

`tools/check_portable_channel_shared.py` tests current shared sources with assertions
enabled and with only the existing default Basic parameter disabled in a fresh
source-only copy. An explicit side-effect control verifies each configuration.
Every packet operation is outside optional assertions. Local and separate-process
tests send 256 packets with lengths from zero through 96, repeatedly wrap the ring,
verify payload bytes and release the mappings. Separate-process reader/writer pairs
use real named shared memory. All generated names/files are unique worker-local
inputs; no shared test journal or immutable binary fixture is changed.

Final receipt `stdlib/shared-target/channel-lifecycle-qg348z45` has 18 passing actual
Mac interpreter/native O0/O2 executions, four native builds, six source target checks,
six full requested-body strict lint contexts, fixture lint and formatting. The
interpreter also passes actual communication between separate compiler processes;
native behavior is separately verified. Windows and Linux source checks are not
native platform verification.

Per-API classification separates 22 supported common declarations, seven Windows
backend declarations awaiting native verification, and five common/POSIX creation
or teardown declarations with a cleanup-failure resilience gap. The POSIX backend
reports cleanup errors but discards its private registration after failed unmap,
close or unlink; safe retry/retention requires further work and clarified policy.
Ordinary successful lifetime behavior is verified. No whole-module completion or
arbitrary duplicate/reconnect policy is claimed.

Test corrections are separate from production behavior. The first fixture draft
redeclared a local result variable and was corrected before execution. An initial
runner waited only for file existence, allowing an empty newly created readiness
file to suppress writer launch. The recorded reader timeout had no writer-process
row. The final runner waits for the complete marker; no channel algorithm or
assertion was weakened. Failed test cleanup unlinks only the runner's exact owned
name, after collecting the real process result.
