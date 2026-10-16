# AppKit receiver correction

The approved receiver contract is implemented in the generator and regenerated
facade. `NSView.convertPoint` sends to its supplied view instance. The three
legacy self-taking NSEvent property wrappers send to the NSEvent class and
ignore their compatibility `self` parameter, including null. The four public
signatures, selectors, arguments, return types, calling conventions and all
other generated bodies remain unchanged. No root Objective_C exports were
added. No compiler, Window or GL changes are needed.

The previous [causal review](appkit-receiver-causality.md) is historical: its
receiver-policy question has been answered by the updated reviewed
[AppKit contract](../specs/stdlib/modules/appkit.md). Its SDK wrong-receiver
negatives remain useful boundary controls, not current-wrapper expectations.
The old pending legacy metadata test is also a wrong-receiver negative;
the current-wrapper acceptance test is `appkit-receiver-forwarding.jai`.

## Required behavior and regression evidence

The independently authored SDK helper allocates two offscreen NSViews and a
real application-defined NSEvent, without creating NSApplication or a window.
The Jai fixture checks exact public procedure types, NSPoint/NSTimeInterval/
NSUInteger sizes, native method result encodings and argument counts. It
checks coordinate conversion against direct SDK dispatch and known offsets,
then reverses the conversion through a different supplied receiver. Both null
and the real event are passed to each legacy event wrapper, and results are
compared with the actual SDK class property. Native objects are released;
NSApp remains null before and after the tests.

The generator regression first failed on all four old receiver choices and
passes after the correction. The unchanged original runtime audit now passes;
an additional independent assertion in its generated harness verifies that
all **874** audited uses remain. The original argument-count, alias/parser and
source-discovery tests also run without changing their bodies or the
expected-missing file. The repair does not reclassify the old four failures.

Mac ARM64 and x64 public source checks, strict lint, root export-privacy
negatives, SDK helper compilation, production formatting and exact spec
regeneration pass. The SDK declaration control suite additionally passes ten
checks: correct receiver/type positives and four separate wrong-receiver
rejections on each CPU. Those rejection cases are not hidden audit misses.

Actual Mac ARM64 O0, O2 and corrected ASan/UBSan wrapper executions pass.
The separate corrected sanitizer receipt guards its source snapshot, executable,
SDK helper and preloaded runtime hashes before/after; it exits zero with empty
stdout/stderr. All bounded slots are released. Final receipt paths are recorded
in the ready status manifest. Mac x64
has source/SDK compilation evidence only; there is no x64 runtime claim.
AppKit is not applicable to Windows/Linux/Android. These focused controls
do not establish a new full application/corpus baseline.

## Sanitizer setup failure retained

The first instrumented SDK helper was built with Apple's default `cc`, while
the own Jai compiler executable links the installed LLVM23 ASan runtime.
Inspection confirmed a helper `@rpath` ASan dependency and the executable's
explicit LLVM23 dependency. Its execution failed before the test body with
the runtime's `Interceptors are not working` / `loaded too late` diagnostic.
This is preserved as a failed test-setup receipt, not counted as runtime
coverage and not attributed to the repaired wrappers.

The verifier now requires an explicit C compiler, records its hash, obtains
and hashes that compiler's ASan runtime, and preloads that runtime for the
instrumented process only. The SDK helper and executable must use the matching
compiler/runtime cohort. No production fallback, disabled sanitizer or changed
assertion was introduced. The initial O0/O2 and original audit receipts remain
separate from the corrected sanitizer receipt.

## Integration

`verify_appkit_receiver_forwarding.py` captures actual shared sources into own
T7 scratch, checks snapshot hashes before every command and after the batch,
and releases its native claim in `finally`. `--native` runs three SDK wrapper
programs plus the original audit. `--native-sanitizer-only` runs one separately
claimed corrected sanitizer program, retaining source/lint/privacy/regeneration
checks. Without either switch it builds/checks without executing SDK programs.
Native claims are bounded and serial; GUI/clipboard/fault tests are excluded.

Integration alone stages/commits. Please selectively append a README link to
this document and adopt the exact paths/hashes from
`docs/status/bindings-appkit-receiver-repair-ready.json`. The reviewer-owned
spec change and shared append-only questions/inbox updates are not bundled as
worker production changes.
