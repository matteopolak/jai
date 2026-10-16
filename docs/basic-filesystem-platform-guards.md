# Basic filesystem platform guards

Basic selects get_working_directory, set_working_directory, sleep_milliseconds
and exit directly for Windows, Linux, Android and macOS. Its internal POSIX
filesystem implementation loads directly for Linux, Android and macOS; the
Windows implementation retains its existing independent guard.

The old gates depended on the replaceable Runtime_Support.OS_IS_UNIX classifier.
A compatible provider can legitimately use Basic public constants while
computing that classifier, making these gates add a circular dependency.
Direct OS selection removes that library dependency and matches reviewed
availability. No compiler cycle semantics, lookup, classifier, public signature,
application or version guard changes.

Review confirms all four APIs on Windows/Linux/Android/macOS. iOS has no
corresponding Basic branch. PS5 and Nintendo Switch declaration surfaces remain
unresolved; the broader runtime classifier does not establish filesystem APIs.

## Independent evidence

Root's corrected independent main calls the four APIs with no explicit runtime
import. Official offline builds pass with the original official provider and
with only its public OS_IS_UNIX expression changed to depend on
Basic.STRING_BUILDER_BUFFER_SIZE > 0 and the unchanged OS formula. The provider
bodies remain root-private and are never supplied here. No generated binary ran.
Three earlier forwarding builds timed out, and an earlier parameterless explicit
runtime import was rejected. Those receipts are preserved and are not positives.

`tests/portable-stdlib/basic-filesystem-platform/main.jai` checks public calls;
`static.jai` checks all four procedure values without explicit runtime import.
The template forwards all three required parameters and canonical runtime hooks
except its own classifier. Substitute only the canonical public entry path and
stage it as the local runtime module. This own forwarder is not the official
provider body or evidence that the timed-out forwarding builds passed officially.

The reusable `check.py` takes explicit `--compiler`, `--stdlib` and fresh
`--scratch` paths. It stages the dependent provider, checks calls and procedure
values, checks actual requested OS targets and Wasm absence, and retains the
true-cycle negative. It only invokes `-check`. Its default positive targets are
macOS/Linux/Windows; requesting an unsupported Android target fails rather than
counting as successful coverage. Negative tests require the relevant diagnostic,
not merely any nonzero exit.

Own source-built checks compare unchanged shared guard bytes with the two fixed
shared files in an otherwise independent accepted603 library snapshot. The static
control fails with a cycle before and passes after; public calls pass both.
The prior official-rejected true-cycle fixture remains a negative. Exact tools,
inputs, hashes and commands are in the [ready receipt](status/basic-filesystem-platform-guards.json).

Only the public alias gate and internal POSIX load gate change in production.
Compiler, runtime, filters, unrelated functions and Extensions are untouched.
Integration owns staging/pinning; root owns protected probes and original Focus.
Root subsequently replayed exact309 with only these two guards: protected and
shipped static/build/classification/constant probes all pass, and both guarded
probes reach the truthful 0.17 version assertion. Unchanged original Focus now
reaches line 228's minimum-version requirement (0.2.29) instead of the classifier
cycle. This resolves the filesystem API lookup class; it does not establish full
Focus acceptance or permit a version spoof. No protected runtime body was shared.

## Platform proof boundary

Own Windows/Linux/macOS checks use actual target options. This compiler supports
only Windows/Linux/macOS/Wasm; Android execution needs supported target CI and
is backed here only by reviewed static contract. Wasm rejects all four APIs.
iOS/PS5 execution is unavailable; no OS values or fallback are used to fake it.
Source checks do not establish cross-platform native execution. Any actual Mac
native check is listed separately in the receipt. No GUI, native fault process,
broad corpus or full-workspace run belongs to this handoff.
