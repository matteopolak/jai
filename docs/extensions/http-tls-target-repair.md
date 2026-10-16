# HTTP/TLS target API repair

Windows TLS's reviewed allocator mismatch is repaired. HTTP's WASM clock
availability remains held for narrow public-contract review; no production HTTP,
Basic, runtime, provider, compiler, or target manifest change is included.

## Supported Windows TLS repair

`trust_windows.jai` passed `temp` as a second argument to `alloc`, whose reviewed
public signature is `(size: s64) -> *void`. `temp` is an allocator, not alignment.
The reviewed public `talloc(size)` performs the intended temporary allocation
without changing the active context allocator. The existing Basic scratch
implementation aligns starts to at least 16 bytes, sufficient for the `u16`
buffer; its no-scratch fallback uses the context/default allocator, whose ordinary
typed allocations already require suitable alignment. No alignment argument was
discarded. The buffer remains temporary and is borrowed synchronously by the
Windows certificate policy call.

Size arithmetic is checked before allocation and null allocation returns a
verification error before any write. Existing certificate chain/store/context
defers still run on those error paths. No trust, hostname, revocation or
certificate policy was relaxed. The native caller remains responsible for the
temporary-storage lifetime, as the former `temp` allocation intended.

## HTTP proposal held, production restored

The original WASM failure is a real unresolved name, not a missing Basic import:
Http already imports Basic, whose current facade exposes `current_time_consensus`
only on Mac/Linux/Android/Windows. The reviewed inventory lists the name without
an explicit WASM condition, and the newly transported filtered disposition calls
this a public API mismatch. That does not establish a WASM clock mechanism or
permission to reduce public availability.

A tested proposal moved `http_date_now` into the existing native client/server
adapter block while retaining explicit-seconds formatting/parsing on WASM.
That proposal made the WASM source checks pass, but would settle an unresolved
public scope question. It was therefore reversed in production when the filtered
review arrived. Its own T7 `http-date-native-proposal.patch` and earlier 16/2
matrix are retained as proposal evidence only, not accepted functionality.
[Narrow review request](../specs/stdlib/http-tls-target-questions.md): confirm
native-only helper scope, or provide the reviewed WASM host clock boundary.
No speculative alias, clock, timestamp, additional OS guard or API was added.

## Verification and limitations

`tools/check_http_tls_targets.py` checks actual production bodies with `-no_dce`
and runs `jailint -D warnings` in explicit target contexts. Every command and
diagnostic is captured. Any failure returns nonzero; none is excused. It performs
no program execution. Build/check outputs use assigned T7 platform-io storage.

The production matrix has 14 commands, with 10 passes and 4 failures:

- Windows x64/ARM64 public TLS: body checks and strict lint pass.
- Linux x64 and Mac ARM64 public HTTP date imports: body checks and strict lint
  pass.
- Windows x64/ARM64 public HTTP: strict contextual lint passes; full body checks
  now reach a later compile-time JSON failure loading Windows `bcrypt` on Mac.
  The original arity failure is resolved, but these remain failed target gates.
- WASM public HTTP date: body check and strict lint still fail on the unchanged
  clock name. They remain genuine failures pending review.

The compiler/linter were built offline from current own Rust source with LLVM
disabled. Real source jaifmt runs through that compiler's interpreter and its
idempotence check passes on the owned Jai files. Python Ruff and scoped whitespace
checks also pass; exact captures/hashes are in the ready receipt. No HTTP/TLS
application, CryptoAPI operation, native output cohort, GUI or fault test was
executed. No Windows runtime success is claimed. Existing native platform-I/O
positives and earlier failed matrix evidence remain separate. Root now reports
candidate309 HTTP CI failed and is independently triaging its filtered setup
diagnostics; this target/API repair does not claim to fix that failure.

`json-windows-host-provider-repro.jai` independently reduces the newly reached
`bcrypt` failure to TLS/JSON imports and freeing a one-string record. Required
native library declarations were retained. [Provider phase review](../specs/stdlib/http-tls-target-questions.md)
is needed before changing compiler or initialization semantics. New TLS overflow
and allocation-failure returns have source/lint coverage, but allocator-failure
injection and real trust/hostname checks still require native Windows CI on both
CPUs. No new Windows OS minimum or capability is claimed.

## Operational deviations

The requested disposition files were initially absent in shared `docs/status`.
Their newly transported, explicitly permitted copies under
`../producer-handoffs/current-repair-batch/stdlib-target-dispositions.{md,json}`
were then read; production HTTP was restored because the exact scope remained
unsettled. No broad manifest refresh was performed.

Access to declared frozen source-built tools was denied by the OS sandbox;
no alternate access was sought. Fresh own source tools were built in assigned
T7 storage. An initial Cargo command accidentally omitted `CARGO_TARGET_DIR`
and started writing to the shared target symlink; it was interrupted with
exit130 and restarted with explicit own target/TMPDIR. Integration was notified
to rebuild shared debug artifacts before use. No source/index change resulted
from that mistaken build command. Initial relative formatter paths were rejected
because interpreter cwd differs; absolute paths fixed the invocation.

The first TLS-only fixture incorrectly treated its integer error code as an
enum. Its corrected version reproduced the production arity failure on both
CPUs; both initial and corrected captures remain in own T7 storage. The final
fixture checks the actual initialization error code and calls cleanup outside
assertions, although it has only been source/lint checked here. Integration
alone stages/commits the shared handoff. No push/publication was performed.
