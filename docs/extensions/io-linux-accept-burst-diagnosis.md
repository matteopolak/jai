# Linux accept-burst failure investigation

Owner: network runtime producer (portable-asn1-socket). This is a diagnostic
handoff, not a runtime fix or a claim that the Linux failure is resolved.

Root supplied failure facts for run 38933357668, job 117082609938: 1,188 Linux
Io/HTTP executions across default/O2/ASan, with 156 failures. One example prints
an io_uring pass, then aborts at the accept-burst assertion in round 8, with
8 of 300 connections not served. Other copies report 7–8. These facts do not
establish that every failure has the same cause. Codec conformance on Mac is
acknowledged separately; it does not establish Linux network correctness.

The existing assertion combines failed connects and failed/short reads. Client
and server writes were unchecked; an acceptor can also exit on its first error.
Consequently, “not served” alone cannot identify a dropped accept or distinguish
kernel resource pressure from readiness, scheduler or compiler behavior.

The additive patch changes only the burst test helpers in
`stdlib/Extensions/Io/tests/lib/suite.jai`. It records cumulative accept/handler
counts and per-stage failure counts, first Io_Error and first native platform
code. It prints these only when the existing failure occurs. A successful
zero-byte read has error NONE and code 0, so the stage/count still matters.
Native codes are captured immediately after the relevant public operation,
before another IO operation can replace the fiber's last code. Deadline
cancellation may carry the backend cancellation code alongside TIMED_OUT.
Handler-finished counts describe handler-body completion, not proof that every
asynchronous close has completed. Counters are private to this test's single
cooperative scheduler; there is no cross-thread shared counter.

Instrumentation adds diagnostic pointers to test spawn payloads and changes
timing slightly. Failure reproduction is useful evidence; nonreproduction is
not proof that the original compiler/runtime path is correct. Preserve the
original failing suite/profile result as the control. This patch is not a
replacement for that required acceptance gate.

The existing COUNT, ROUNDS, 30,000 ms deadline, 20 acceptor yields, original
failed-count rule, assertion, and backend selection remain intact. There is no
retry, raised bound, reduced concurrency, backend disable or assertion bypass.
No production provider/compiler/scheduler body has been changed. Existing
Extensions files/history are preserved. The new public entry point
`tests/extensions/io-accept-burst-diagnostics.jai` calls that same test with the
caller's existing backend environment. It supplements the full suite.

The source inspection found that epoll caches blocked directions and resets
descriptor state on close. The scheduler polls pending IO periodically while
fibers remain runnable. Neither observation proves runtime correctness. The
short-positive-read optimization cannot directly explain a short positive
one-byte transfer in this test. No confirmed production defect has yet been
isolated. The io_uring-then-failure sequence suggests the next forced backend
may be epoll; the new failure output records the actual backend explicitly.

`tools/check_io_burst_diagnostics.py --program PROGRAM --report NEW_DIRECTORY`
is for the root-owned Linux CI gate. It refuses runtime collection on Mac,
executes the supplied already-built program exactly once, preserves its exit
and output, and samples inherited limits, process descriptors/scheduling, CPU
and memory pressure, socket counters and TCP state counts once per second.
Kernel/socket observations cover the network namespace, not just the child;
TIME_WAIT counts must not be attributed to the child's live descriptors.
The current collector samples for at most 180 seconds, then waits for the
original program's result under the existing CI supervisor's timeout policy.
It never kills or restarts the target at the sampling limit. Exhausting that
window is recorded explicitly; an unfinished/interrupted receipt is not a
pass. The earlier collector's target-killing safety limit is superseded: a
whole backend program can legitimately include multiple long connect waits.
The observation budget must not replace the original program's disposition.

Root/integration should wrap ONE existing copy of the unchanged full backend
program under the existing default/O2/ASan 12-copy load profile. Do not add a
thirteenth copy or substitute the focused entry for the original full program.
Use a fresh report directory per process/copy and retain stdout, stderr and
receipt.json. No CI/profile changes are owned by this producer.

Interpretation requires actual Linux evidence:

| Observation | Next reduction |
| --- | --- |
| Connect errors with native resource codes | Correlate inherited limits, descriptor peaks and namespace socket/port pressure; compare a public native SDK connect control under the same pressure. |
| Acceptor exits with an error | Preserve the exact native code and completed/accepted totals; investigate that accept/provider path. |
| Connects succeed, acceptor stays alive, accepts lag at timeout | Inspect listener readiness/queue transitions and kernel listen-drop counters; retain the same load and deadline. |
| All connections accepted, client reads fail | Separate server read/write failure from client readiness/deadline behavior using stage codes and handler totals. |
| High CPU pressure | Correlate per-process scheduling and elapsed time; pressure alone does not excuse a lost wakeup or prove causation. |

The local checks build the current clean compiler/library sources and use
`-check` for backend/tcp/focused entry on Linux x64, Linux arm64 and Mac arm64,
plus strict lint of the production module and those public roots. They execute
no Io program. The root's host native/GUI/fault lease remains held. Actual Linux
execution and cause classification are pending the remote evidence. Source
checks cannot establish interpreter/native/O2/ASan runtime success.

Integration alone owns Git/index, CI wiring and the docs/README.md link.
Release/publication remains held. No original/reference implementation,
quarantine history, raw oracle log or agent transcript was used.

Historical local source receipt `io-burst-source-20261016-c` passes 10/10 checks,
with four complete strict-lint contexts, no incomplete/unvisited files, and
1,006 source hashes unchanged. Fresh compiler SHA
`e2c1a7569844675facca7134327b13f21b02521b58d158ddc93244b30a98b29b`
matches the accepted f1 identity. JaiFmt interpreter checks pass for the two
changed/new Jai files, Python Ruff checks/format pass, and the collector's Mac
runtime refusal was independently checked without creating outputs or
executing a target. No Io interpreter/native execution occurred locally.

Retained initial source receipt `io-burst-source-20261016-a` failed on the new
unsupported `print_error` call, corrected to public
`print(..., to_standard_error = true)`. Its initially broad directory lint also
reported the existing benchmark's unavailable `Atomics.atomic_store`; that
separate benchmark/API premise is unmodified and unverified. Final focused
lint covers the production module, backends, tcp and diagnostic entry roots,
not benchmarks. The first formatter invocation used a relative config path
and failed; the corrected absolute-path check passes. No errors were waived.

## Actual 07bf Linux evidence and the next bounded request

Root supplied run 38945081630/job 117122054637: 151 failures among 1,188 runs.
For epoll O2 copy 6, round 12 took 135,248 ms, with 3,569 accepted and finished
handlers and 31 connect failures, first TIMED_OUT/native 110. Copy 11 round 13
took 135,228 ms, with 3,879 accepted/finished and 21 connect failures. The
supplied io_uring examples took about 68 seconds, with accepted/finished totals
898, 1,199 and 1,499 at rounds 3, 4 and 5. No recorded server accept/read/write
or client read/write failure explains these samples. This does not classify
every failure in the aggregate.

The 30-second deadline in `burst_client` starts **after** `Io.connect` returns.
`start_fiber` initializes its deadline to zero; `run_group` installs no outer
deadline. `await_op` installs a timer only for a nonzero fiber deadline, and
maps native Linux E_TIMEDOUT=110 to TIMED_OUT. Therefore these long connect
rounds are not evidence that a 30-second scheduler timer fired late. The
reported round elapsed time includes the untimed connect, not just its later
bounded write/read. No deadline relocation or change is proposed.

The Linux [TCP policy documentation](https://docs.kernel.org/networking/ip-sysctl.html)
describes SYN retry/backoff controls that can produce long native connect
waits. Actual CI values must be captured; elapsed time alone does not identify
the retry configuration or prove why handshakes failed. Resource pressure,
listener queues, packet drops and runtime scheduling remain hypotheses.

The revised collector requests these exact outputs, without another target
execution or production change:

- Existing failed-copy stderr plus actual binary SHA, inherited backend
  variables, working directory, monotonic and wall timestamps.
- TCP SYN retry/linear-backoff/SYNACK settings, overflow policy, socket limits,
  namespace ListenDrops/ListenOverflows/SYN-retransmission counters, softnet/
  interface drops and conntrack occupancy/limits where available.
- Child-owned listening sockets' raw queues, owned connection state counts,
  and up to 16 pending-SYN examples with inode/endpoints/retransmission timer
  and unrecovered-RTO count. Aggregate counts are not capped. Interpretation
  uses the public [proc TCP format](https://docs.kernel.org/networking/proc_net_tcp.html);
  raw queue/timer units are retained rather than guessed.
- Child descriptor counts/limits, schedstat/status/wchan, host pressure, and
  cgroup-v2 CPU quotas/throttling/pressure and memory events for the child and
  ancestors. [Kernel cgroup documentation](https://docs.kernel.org/admin-guide/cgroup-v2.html)
  explains why ancestor limits matter. Unsupported v1/missing files remain
  explicit unavailable observations, never fabricated zero pressure.

TCP tables come from the child's network namespace; observer/child namespace
identities are recorded before comparing host sysctls/counters. Descriptor
ownership and tables are sampled separately and can race; unavailable link
reads and malformed rows are counted. Namespace totals include sibling load,
while owned rows are matched by the child's socket inodes. Sampling duration
is recorded so observer overhead is visible.

Integration should replace one existing process launch with the collector's
single launch, retaining the other 11 copies, same binary/arguments (the
backend test takes none), environment, cwd, flags, supervisor timeout and
required original assertion. Retain receipt.json, program.stdout and
program.stderr. A nonreproducing diagnostic execution does not clear the
original RED result. No local network/native/GUI/fault or LSP execution is
needed or claimed for this request.

Current followup source receipt `io-burst-07bf-source-b` passes 10/10 checks,
with four complete lint contexts and 1,007 guarded source inputs unchanged.
Its local compiler SHA is
`635492b0326655c5594bd37b6dbf95d505300335c3e001c9072446cbc34b9913`;
the source receipt records HEAD `29fbdef12b71badda14a71ff0b252f1f846368f4`.
This is local source evidence, not equivalence to the deployed 07bf compiler.
`io-burst-07bf-focused-checks` records 11 passing independent metadata tests
plus Ruff check/format. Tests cover process/namespace ownership, malformed and
unavailable tables, bounded examples with complete aggregate counts, cgroup
ancestor/escape/v1 cases, descriptor races, Mac execution refusal, and no
target kill/retry when the observation window expires. An initial unit harness
incorrectly patched `module.sys`; its corrected `sys.argv` patch is test-only.
No Extensions production/test source or application runtime was changed in
this followup. Earlier receipts and the original RED CI outcomes are retained.

## Integration: observe one original loaded copy

HTTP Linux CI fixes the observed workload at its original12 copies and selects only backends:o2:1:0 for observation; all default/O2/ASan variants and three outer rounds remain. The same child binary runs once, in its original scratch cwd with inherited environment and unchanged180-second supervisor timeout. A metadata thread samples that PID; it never adds an execution, retries, changes backend/deadlines or kills a process. The observer180-second cap ends sampling only. The original supervisor retains its kill-on-timeout policy, and timeout remains failure. Child stdout/stderr plus actual exit are retained privately; unexpected observer failures are explicit harness failures.

Seventeen policy/parser checks pass (six stress/two prior+four new, eleven collector), Ruff and workflow actionlint pass. Tests use command mocks and independent proc-table vectors, not Linux/native evidence. Observer hash/thread/receipt I/O changes scheduling; nonreproduction cannot clear151/1188 original failures. ROOT must run the same actual workload; no standalone extra collector execution is wired. See [integration receipt](../status/io-existing-copy-integration.json).
