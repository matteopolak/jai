# Linux HTTP connect and completion evidence

Owner: portable-asn1-socket / network diagnosis. Source-only follow-up to job
117243021190; this does not close the required Linux correctness gate.

The admitted `artifacts/admitted-http-ae6-categories/http-bounded-error-categories.json`
supersedes the old labels-only request. It reports 13 failures among 1188 runs:
two backend copies and 11 of 12 HTTPS O2 round-three copies. Eight printed detail
copies are a console limit, not the total failure count. HTTPS connect timeouts
precede trust decisions, including the verify=false failure. No certificate,
TLS provider, or memory defect is established by these categories.

## Exact current source paths

* `Extensions/Http/client.jai:700` (`send_on_fiber`) encloses the exchange in the
  request deadline. `checkout`, at 1659, resolves and connects at 1696 before
  `secure_link` at 1706. The connect error returns immediately; the TLS handshake
  at 1840 is not reached on that exchange. This distinguishes connect-stage
  failure from certificate validation failure.
* `Extensions/Http/tests/https.jai:191` requests an untrusted-CA verdict with a
  5000ms request deadline. Failure to connect prevents that verdict. The checks
  at 193 and 207 remain required; their failure does not prove broken trust.
* `https.jai:426` performs five requests per crowd client. `finished` increments
  only after all five; `failures` increments only after an exchange/read returns
  an error or unexpected text. `many_clients`, at 454, spawns 30 clients and
  observes completion for at most 2000 sleeps of 10ms. Default request timeout
  is 30000ms (`client.jai:179`). Thus 26 finished/zero failures leaves four
  clients' outcomes and blocking stages unknown. The sleep counter is not a
  measured wall-clock deadline or evidence of late scheduler timers.
* `Extensions/Io/tests/lib/suite.jai:1167` connects before its 30000ms write/read
  deadline. Epoll connect completion reads socket SO_ERROR
  (`engine_poll.jai:158`); io_uring submits CONNECT (`engine_uring.jai:180`) and
  records a negative completion's native code at 385. Native 110 in the admitted
  backend records identifies a kernel error path, not proof that the post-connect
  deadline expired. Accepted/completed totals match (2076 and 2507); neither
  equality attributes the failed connections or proves absence of queue pressure.

## Separate fixture lifetime concern

On incomplete crowd completion, `many_clients` returns without joining its
spawned clients and frees its TLS config by defer. Each client has a pointer to
the stack-local crowd. `run_server` (`tests/lib/server_support.jai:42`) then
stops/waits for the server; it does not join these client fibers. Io cancels
remaining fibers only after its root returns (`Io/scheduler.jai:149,621`). The
TLS config contract requires streams to close before freeing it
(`Tls/config.jai:106`). This is a source-visible failure-path lifetime concern,
not an explanation for earlier certificate probe connect timeouts: those probes
run before `many_clients` (`https.jai:794-797`). No fault execution or fixture
change was made. Any cleanup repair requires a separately reviewed change that
preserves the original observation assertion and all clients' ownership.

## Narrow observer handoff

The current `io_stress.py:332` observes only backends/tcp. The NEW delta adds
HTTPS to that existing option's group selection and expands its mocked original
supervisor control to all three test names. It changes no program, workload,
deadline, retry policy, upload path, sampler, or error assertion. The same 12
original copies retain distinct working directories and the 180s supervisor
timeout. Normal CI now has 27 eligible groups, below the existing 32 retained
failed-group cap. Only the first failed copy and an available passed control per
failed group retain bounded samples; all failed indices remain recorded.

Integration owns applying `tools/io_stress.py::main` and the accompanying
`tools/test_io_failure_wiring.py` hunk. No shared runner/workflow file was edited.
Please add this document's link to `docs/README.md` on adoption.

The precise evidence dependency is a sanitized `receipt.json` failed-group
record from the current Linux job, if retained: identity/source/program hashes,
failed indices, selected failed copy's exit phase/status, bounded process/thread
and owned TCP samples, namespace and sampler availability/truncation fields.
HTTPS is excluded from current collection, so its missing history cannot be
recovered from this run; use the NEW wiring on the next unchanged workload.
Categories are already supplied and need no repeat request. Burst native-error
fields are not collected for HTTPS; sampling gives no per-request stage timing.
Namespace counters remain shared load, never attribution to the selected copy.
If current backend receipts were not retained, record that explicitly rather
than waiting for recovery. No causal runtime fix is justified yet.

## Focused verification

Against the expanded mocked control, current wiring fails only the two HTTPS
subcases before any real launch; candidate wiring passes six pass/failure
subcases plus the non-Linux rejection test. Eleven existing observer tests pass.
These are Python metadata/mock controls, not Linux/native tests. Ruff checks and
format checks pass on both candidate files. Integration's catalogue lease stays
held; no compiler, native, network, server or fault program was executed.
