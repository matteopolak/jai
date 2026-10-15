# Unix Thread assertion configuration and ownership

The reviewed Thread API requires real native synchronization independently of
Basic's optional assertion checks. Unix operations now evaluate SDK calls before
checking results: mutex attributes/init/destroy/lock/unlock, native critical-section
macros, condition init/destroy/signal/broadcast/wait, semaphore creation/signaling/
destruction, pthread join, group worker creation and group clock queries.
Windows Thread remains platform-io ownership and is untouched.

Void operations log errors even with assertions disabled, then invoke the optional
assertion diagnostic. Failed initialization returns without marking success.
Mach semaphore creation commits owner/event only on success; failed destruction
retains them. Thread creation checks both semaphores. Failed join retains the
thread, registry entry, temporary storage and native ownership. Private flags
allow teardown retry after successful join or one successful semaphore cleanup.
Thread start marks success only after signaling succeeds. Failed group join
retains the whole worker storage. No public record layout or signature changes.

Run `python3 -B tools/check_portable_lifecycles.py`. It composes NEW foundations
and this worker's actual Pool/Thread only under target/, leaving peers read-only.
It sets ENABLE_ASSERT defaults in both staged Basic module parameter lists.
The original audio fixture's caller-only false specialization otherwise leaves
Thread's default Basic enabled; that distinction is preserved and tested. New
verification explicitly imports enabled assertions, and restores the fatal
handler before checking deliberately captured SDK errors.

The genuine foundations leak-report fixture and Pool ownership/selection tests
run interpreter/host ARM64 and translated x64 native O0/O2. For each default assertion setting, the unchanged
audio semaphore fixture plus new mutex/condition/semaphore/thread/group lifecycle
and actual Mach invalid-task destruction tests run interpreter/host ARM64 and translated x64 native O0/O2.
Pool and Thread defects reproduced first in target/lifecycle-pool-red.log,
target/lifecycle-leak-red.log and target/lifecycle-thread-red.log. Final evidence:
target/lifecycle-all-green.log and target/lifecycle-strict.log.

Test corrections are separate: Pool's old post-release setter expectation is
replaced by the reviewed persistent field guard. A draft locked-mutex destruction
test assumed mandatory EBUSY, an invalid POSIX oracle (destroying a locked mutex
has undefined behavior). It returned success here; its failure remains in
target/thread-error-count.log. No valid lifecycle assertion was removed; real
Mach failure retention replaces that invalid failure injection. A draft callback
signature was corrected to the actual Context assertion-handler type.

Remaining limits: native Linux/Android execution and Windows execution are not
claimed. Join/semaphore cleanup failure retry is source-reviewed, not forced via
invalid pthread handles or fabricated SDK results. Native Mach retention is
actually executed. Group worker-creation failure and unavailable group clock
are explicit fatal errors even with assertions disabled: the void APIs cannot
return a usable partial group or a fabricated clock. Recoverable transactional
group initialization/cleanup for resource-exhaustion paths remains future work;
these fault paths are not counted as tested recoverable functionality. Process
termination leaves live worker storage intact until OS teardown. Public SDK
mutex/condition destroy failures retain their records; group work-list destruction
does not yet provide transactional partial-cleanup retry. Full integrated CI and
all-owned lint remain separate coordinator gates.
