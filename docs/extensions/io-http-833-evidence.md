# Retained 833 HTTP and Linux connect evidence

The admitted inputs are the central `http-observer-833/sanitized-observer.json`
and `ci-833-runtime-records/sanitized-failure-records.json`. No raw log,
environment, endpoint, application source body or reference implementation was
needed. This review adds no network/native/fault execution and changes no
original fixture, deadline, concurrency, allocator policy or backend selection.

## Termination result accounting

The catalogue records identify both HTTP termination cases on three jobs,
each in interp/native/WASM-interp/WASM-native. Their diagnostic arrays are
empty. The Thread_Basic_No_Assert/parent ERROR diagnostic is attached to
`io-configured-production`, not either HTTP case. This corrects the earlier
cross-case helper attribution. Exact original argv and exit/output fields are
absent; no historical execution status is invented from an empty diagnostic.

Both HTTP source hashes match the named clean producer commit
`833e8f22d7418f2823665dbf0b5241cdcef85fab` exactly. The status fixture requires
exit 37 and exactly `before exit 37\n`. The failure fixture requires exit 1 and
exactly its failed-check message and `1 failure(s)\n`, with no continuation.
The public test support counter/finish behavior and original source remain
unchanged.

The named 833 `contract_result` and current implementation default to exit
zero. Current catalogue entries supply neither case's expected status/output.
Consequently they reject correct fixture outcomes and can accept an incorrect
exit-zero outcome. The new five-method regression reproduces that metadata/
accounting defect against shared source. It is independent of the child-MAIN
configuration repair, which remains sealed separately.

The proposed correction attaches exact `exit_code`, `stdout` and empty `stderr`
metadata to these two IDs, and makes the general exact-stdout branch compare
against `case.get("exit_code", 0)`. Ordinary positives retain their zero-exit
default; check-fail and existing error-contains branches are unchanged. No
fixture-specific exception is added to the runtime result function. Unexpected
status, missing output, continuation output or extra diagnostics still fail.
App native-only selection, declared WASM codec/termination coverage and Io's
native fiber requirement remain required.

Foundation owns the catalogue attachment and integration owns the runtime
accounting function. Their two shared files were not edited by this owner.
An isolated current-source candidate contains only the two proposed hunks;
the accompanying regression passes all five methods. Four real executions
through that candidate's canonical `run_mode` pass: both unchanged HTTP
fixtures in host and WASM interpreter modes, using a fresh source-built
compiler and frozen producer stdlib. Native/WASI execution was not performed.
The historical CI cases still require replay and root's bounded original
exit/phase/output-match metadata before a per-record causal disposition.

## Linux handshake evidence and limits

Observed run 38968708647, copy `backends:o2:1:0`, exited zero in about 94.8
seconds. The overall Linux suite failed. All 87 admitted samples identify the
same observer/child network namespace. Across that sampled interval the
namespace counter deltas include 46,744 SYN retransmissions, 46,753 TCP
timeouts and 113,277 active opens; ListenOverflows and ListenDrops deltas are
zero. These namespace totals include other copies/processes, and cannot be
assigned to the observed copy or to a failed request.

Process-owned observations have at most one SYN_SENT row at a sampled instant,
with maximum summed unrecovered-RTO count nine. SYN_SENT appears in 81 samples.
Stable per-connection identities and fixture phase are absent, so this does
not establish that all observations describe one connection or the burst
phase. The kernel's [public proc TCP format](https://docs.kernel.org/networking/proc_net_tcp.html)
defines the RTO field as unrecovered retransmission timeouts. This provides
evidence of pending kernel handshakes in a passed copy, not a diagnosis of
failed-copy requests. The maximum raw owned listener receive-queue field is
768, and the maximum descriptor snapshot count is 263. These are separate,
racing samples, not atomic backlog/connection counts or proof of a limit.

Available cgroup ancestors show unlimited CPU quota and zero throttling
counters; the two available memory-event records show zero events. The root
memory-event record is unavailable. This does not exclude scheduler contention
or establish an allocator cause. Up to three threads were observed; the
`/proc/<pid>/schedstat` sample is for the selected task, not a complete
all-thread scheduling history. Its main-task counters cannot explain the
entire process's elapsed time.

Current producer source submits CONNECT to the kernel in both backends:
epoll first uses `sys_connect`, then the socket's SO_ERROR; io_uring submits
CONNECT and consumes its completion result. `await_op` preserves a negative
platform result as the fiber's platform code; Linux code 110 maps to
TIMED_OUT. The original burst client connects before installing its 30-second
read/write deadline, and a spawned fiber starts with deadline zero. Therefore
the reported long connect rounds are not evidence that that deadline fired
late. Source paths alone do not prove correct execution of every failed copy.

The evidence narrows the observed symptom to handshake waiting, while the
failed-copy root cause remains open. No specific provider/compiler/scheduler
defect is proven, and no network production fix is proposed. The independent
ready router-lifetime patch does not explain an unaccepted connect merely by
being another HTTP change.

## Bounded remaining evidence request

Root should extract these fields from the already retained report, without
another workload execution or changing the original 12 copies:

- Existing numeric SYN/SYNACK/linear retry settings, overflow policy,
  somaxconn/SYN backlog, local port range/TIME_WAIT reuse settings, conntrack
  occupancy/limit/drop counters, interface/softnet drop totals and pressure
  values. Missing/unavailable values must remain explicit. Kernel
  [TCP policy documentation](https://docs.kernel.org/networking/ip-sysctl.html)
  explains these controls; elapsed duration alone does not identify settings.
- Existing sample durations and process stat user/system ticks, with tick
  frequency if available; main-task schedstat must retain its scope. No
  credential, command-line or environment fields are requested.
- If retained, failed-copy stage counters/native code plus matching binary
  identity and relative sample/failure times. Without matching ownership,
  namespace counts cannot classify that failure. Stable report-local opaque
  connection IDs and an owned-listener-match boolean can preserve correlation
  without admitting endpoints; they are requested only if derivable from
  existing captures, not fabricated for the sanitized summary.
- For the original HTTP catalogue records, phase, numeric actual exit,
  exact-reviewed-stdout-match and stderr-empty booleans. Payload/raw logs are
  unnecessary. The helper error belongs to the independent Io configuration
  rows already repaired by the sealed child-MAIN packet.

The owner T7 receipt directory is `http-833-accounting-xa1r3ho3`. It retains
the shared RED, isolated candidate verification, four canonical interpreter
outcomes, named-833 source hashes and frozen compiler/stdlib guards. Initial
test-loader and omitted numerics-metadata staging failures are retained as
setup failures, not counted as passing checks. A concurrent peer catalogue
CLI improvement was preserved when refreshing the isolated candidate; the
export contains only the new proposed insertion and result comparison.

Integration alone adopts the proposed shared hunks, stages/commits, and adds
this note to docs/README.md. No native lease was claimed or used. Linux
correctness, original CI replays and Hyperserve's unresolved runtime gate stay
required; no rejected fault execution was retried and no capability waiver is
introduced.
