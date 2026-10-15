# Private native check reporting

The compiler emits runtime checks from its own IR reason codes, independent of
the public Jai compatibility inventory. Previously it looked for the unreviewed
public runtime_support_check_failed export and silently omitted native null
guards when that optional lookup failed. The actual combined runtime has no such
public API. Full-workspace failure evidence is preserved in
artifacts/integration-clean/workspace-refresh14.log.

The independently designed __jaic_check_failed alias is file-private in the
canonical Runtime_Support facade. Only compiler transport setup reads its own
runtime module's declaration scopes; application lookup/export rules are
unchanged. It resolves a real internal/runtime/checks.jai implementation with
an exact checked six-scalar/no-context/void signature. Ambiguous,
malformed or failed bodies produce normal compiler diagnostics. Resolution
failures propagate through check emission instead of silently disabling checks.
The compiler marks the hook's real use for semantic lint; no naming suppression
is needed.

Native reporting uses real low-level runtime output without allocation, formats
the current file/line and the IR reason's actual operands, and exits1 on fatal
checks. Nonfatal casts report warnings and return to the generated continuation.
The independent arithmetic hook now honors the compiler's fatal bit and formats
actual operand/operator/width/signedness; NONFATAL continues with the real
computed result. The public signatures and three Runtime_Support parameters
remain unchanged. Reason/flag encoding is this compiler's private ABI, derived
from our supplied IR/emitter sources; it is not a new public compatibility claim.

With runtime support disabled, the backend retains null guards and an explicit
llvm.trap failure path; diagnostics are unavailable in that mode. The separate
O0/O2 regression verifies IR guards, successful non-null access and actual
failure on null. Public import of the private hook is rejected. Existing native
tests verify six failure categories plus assembly division, nonfatal casts,
pointer invalidation after stores and arithmetic OFF/NONFATAL/FATAL.

Executed focused checks: native failed_checks_say_what_and_where,
null_checks_skipped_after_a_check_still_catch_changes, arithmetic_overflow_checks
and cleanroom_runtime_disabled_checks pass. Actual source-built jailint
-D warnings on the facade/internal module/fault/check units passes; workspace
clippy all-targets -D warnings passes. Full compiler/LSP regressions are running.
No Windows execution is claimed from this host; native CI remains required.

Diagnostics write bounded numeric buffers and source strings in several existing
low-level output operations. Concurrent failures can interleave fragments; there
is no new atomic whole-diagnostic guarantee. A future shared nonallocating output
transaction can reduce that cost/interleaving without changing the private ABI.

The transport is optional for custom/minimal runtimes: absence uses the same
explicit trap fallback. It adds no mandatory declaration to the reviewed public
Runtime_Support contract. The first full regression exposed that mistake by
masking existing configuration and lint-scope diagnostics; original tests are
retained. All50 module, four runtime-configuration, five library-root tests and
two new private-hook validation cases pass after correction. Invalid hook types,
signatures and bodies still fail normally. Minimal virtual runtimes in these
unit tests only verify transport admission; production behavior comes from the
actual combined library and native execution tests.
