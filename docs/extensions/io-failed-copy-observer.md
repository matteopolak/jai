# Observe an original failing Linux copy

Supplemental retained metrics from run 38968708647 describe the same passed
copy as the earlier observer. Conntrack occupancy rose from 176,845 to 258,544
against a recorded maximum 262,144; softnet recorded 357 drops and six
time-squeeze events. SYN retry/SYNACK/linear settings were 6/5/4, SYN backlog
1,024 and somaxconn 4,096. These namespace observations strengthen a resource
pressure hypothesis but do not attribute packet loss to a failed connect.
Failed-copy connect counters and all-thread aggregates were not retained.
They cannot be recovered, and no further request for those old records is
pending. The original Linux failures remain unresolved.

Source review of the current combined producer still finds direct kernel
CONNECT submission/completion in epoll and io_uring, with native code 110
mapped to TIMED_OUT. The burst read/write deadline begins after connect.
Neither long round duration nor namespace pressure proves scheduler timer
lateness or establishes a specific implementation defect. No network
production body, allocator, deadline, backlog or original fixture was changed.
The independent router-lifetime repair and integrated exit37/exit1 catalogue
repair are separate from this investigation.

The proposed Linux CI flag is `--observe-failures-report DIR`. It instruments
all twelve original children in each backends/tcp group. It adds no target
launch or retry. The original test list, three variants, three rounds, twelve
copies, per-copy cwd and 180-second supervisor timeout are retained. Other
workload groups run through the existing path. The old explicit single-copy
observer options remain available and cannot be combined with the new mode.
Unsupported-host requests reject before native setup or child launch.

One Python sampler serves the group, reads each namespace TCP table once per
sample and matches socket inodes privately to child descriptors. It waits five
seconds between samples; collection cost is additional and is recorded. It
keeps at most 36 samples per child. After the original children return, the
report retains the first actual failed copy by index and one passed control
if available. All failed indices remain listed. A passed copy is never used
as evidence that a different failed copy succeeded.

The numeric report contains program/compiler/source/test hashes, variant,
round, copy count, runtime exit or supervisor-timeout phase, actual exit status,
elapsed time and the original burst's numeric stage counts/native codes.
Launch failures preserve their numeric errno and original exception behavior.
The runner still fails on any original nonzero result or timeout. Only the
original supervisor kills on its existing timeout; observation never terminates
or restarts a child. A changed source/compiler digest is a separate capture
failure and cannot turn an original failure into success.

Samples separate namespace counters from owned socket state/queue/RTO summaries.
They include descriptor availability/races, bounded non-atomic all-thread
schedstat sums, available cgroup CPU/memory counters, pressure, retry settings,
conntrack occupancy and drop counters, and host/system softnet drops. Unavailable, malformed
and truncated observations remain explicit. There are no socket endpoints,
descriptor paths, cgroup paths, environment/auth fields, raw stdout/stderr or
source bodies in the report. Namespace counters still include sibling load.
Thread creation/exit and independently sampled descriptors/tables prevent
treating snapshots as atomic per-connection or process-lifetime accounting.

Limits are 262,144 TCP rows per table, 4,096 descriptors per child, 32 tasks
per child, 36 samples per child and 32 retained failed groups. This CI cohort
has only 18 monitored groups, so the group cap does not truncate it. Additional
failed groups are counted explicitly if other invocations exceed the cap.
An early failure can precede the first sample; its status/hash/phase is retained
with an empty history, never fabricated metrics. Sampling exceptions are
counted. Instrumentation overhead is measurable, not claimed to be zero.

Integration's proposed shared changes are limited to `io_stress.py`'s new
explicit option, `run_copy` dispatch and group lifecycle; the Linux workflow
arguments/upload allowlist; and the corresponding artifact policy expectation.
Source digests exclude macOS `._` metadata sidecars; the independent digest
test exposed and preserved this initial T7 discovery failure before correction.
Its existing build, single-copy observer, output shortening and burst-report
functions have unchanged ASTs. Shared files were not overwritten by this owner;
the patch contains exact proposed hunks for integration adoption.

The always-run Linux artifact step retains only
`RUNNER_TEMP/io-observed-copy/receipt.json`. The new mode produces no raw output
files. Upload retention and the required failure gate remain unchanged. New
observer/wiring tests are included in the workflow, with trigger paths.

Focused verification is numeric-vector/mocked-supervisor evidence: 11 new
observer tests and 11 candidate runner/artifact/legacy tests pass. The new
runner test checks exactly twelve original calls, one build, the unchanged
timeout, copy cwd, and both zero/nonzero overall results. Timeout tests verify
one launch, one supervisor kill and reaping without retries. Ruff and
actionlint pass. No compiler, native program, server, network, fault program
or benchmark was executed; no native lease was claimed. Actual Linux collection
and original required CI acceptance remain pending root's normal CI push.

Owner T7 receipt directory: `io-failed-copy-wiring-lyuq2dy0`. Integration alone
adopts/stages/commits and adds this note to docs/README.md. Root pushes/runs CI
outside this worker. Original fixtures, the sealed child-MAIN packet, accepted
HTTP App/WASM boundaries and Hyperserve's unresolved runtime gate are preserved.
