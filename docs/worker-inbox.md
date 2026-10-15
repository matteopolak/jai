# Mac Extensions worker inbox

Current exclusive scope is Json/Http production and tests, Byte_Search test time
dependency, and Io tests only. No Io production or compiler/stdlib changes.

The named stable baseline JSON and assigned T7 path were absent in the fresh
checkout. Missing-input question submitted; direct original-class reproducers
and this worktree's isolated artifacts/T7 build are used while waiting.

Json empty-path cleanup reproduced and repaired; unchanged interpreted leak
sweep passes. Http/Io atomic dependency migrations compile. Numerical work and
full affected-test verification continue; no full-completion claim is made yet.

Numeric dependencies are now migrated to reviewed width-specific public parsing
and public shortest formatting, with private Json spelling normalization. No
lossy conversion/private Basic export was added. Existing numbers now compare
parsing bits against native strtod/strtof, retain shortest-digit comparisons and
fixed spelling/round-trip assertions. A new numeric allocator test passes all
three modes. All27 original affected catalogue tests pass Mac native O0/O2.

The exact contextual lint command in docs/extensions/mac-dependency-repairs.md
still fails on a procedure-valued Json generic sketch in the original Http
client fixture; normal compile/execution passes. Compiler/linter worker owns
that reduction. Changed-source strict lint passes in the real positive consumer
context, without suppression. No Http/Io production lifecycle workaround is
introduced to mask compiler behavior.

Final corrective regression also found/repaired empty-key ownership leaks in
Json_Value and typed table decoding. Key/value presence and zero outstanding
allocations are asserted in interpreter/native O0/O2. Json10 tests pass both
native modes; Http11 tests pass native O2 again, including real TLS. Configured
HTTPS passes interpreted too; direct invocation without native-library paths
was a setup failure and is not counted as success. Http's current-date codec
assertion now agrees with canonical Unix-time conversion in all three modes.

The stable baseline report/T7 external-path questions remain unanswered; no
alternate checkout or raw vendor log was sought. Source-built compiler/linter
outputs stay in local artifacts/T7; test reports are durable under artifacts.
The exact large-client-context lint error above remains a compiler-owner handoff,
not a production workaround or suppressed result. No Io production was edited.

## Compiler/linter owner: blocking request from resumed client-context audit

The exact production client context is freshly reproduced red. Two original
reductions now exist: `tests/extensions/http-client-overload-lint-repro.jai`
uses only real Http App POST registration, and
`tests/extensions/rejected-overload-lint-repro.jai` removes Http/Json entirely.
Both compile normally; the pure reduction executes its selected handler and
asserts the result. Warnings-denied audit erroneously checks the Client generic
candidate rejected by the App pointer type. This is a general compiler defect,
not invalid test setup. The precise request, safe fresh logs and required
non-suppression constraints are in docs/compiler/rejected-overload-lint-request.md.

Please route that request to the compiler/linter owner and return an approved
sanitized repair checkpoint. No compiler/peer checkout is edited here. The
production client context remains a required green gate, not counted as passed.
The absent original baseline is explicitly not a blocker for this resumed work.


## User reinforced root-cause policy

Do not patch isolated cases merely to turn tests green. Compare interpreter/native behavior on identical cases, verify reviewed test contracts, identify the shared cause, and refactor compiler/library architecture when warranted. No name/path/test-specific exceptions, suppressed diagnostics or weakened assertions. Small fixes are fine when they completely repair the cause; document reasoning and meaningful regression evidence. Call out any workaround explicitly. Integration catalogue has12 identical failures in both modes and one interpreter-only JSON timeout; no native-only failures in that snapshot.


## Corpus public API review 2026-10-15 17:24 UTC

Reviewed basic, math refreshed. Context.print_style is genuinely public. S128/Apollo_Time +/- operator interface required. Basic alloc/New do NOT accept allocator argument (use context.allocator); free pointer/string real; swap lowercase; Basic get_time/bubble_sort/Swap not current exports, get_time belongs Thread_Group. Math Vector2 scalar multiply/divide actual, scalar add/sub absent. Metaprogram_Plugins supports dynamic names formed during compile-time execution, not just CLI names. Its current generated-source boundary needs proper general compiler/library architecture, no CLI-only dispatch limitation. No arbitrary backwards aliases or weakened tests.

## Latest user assignment: focused Basic/Math ownership

This supersedes the earlier Extensions-only scope for the assigned core work.
This worker owns the shared print-style context architecture, public integer
operators, supported free/hash regressions and reviewed Vector2 arithmetic.
Portable time owner: clock/calendar/Apollo conversion bodies remain untouched;
only integer128 operator declarations provide the reviewed inherited interface.
Compiler owner: no compiler source is edited. Authorized candidate8b134bdb source
is staged locally and source-built in T7. No peer checkout is written.

The design and explicit ABI-bridge cost are in docs/features/basic-public-context.md.
Dirty-room contract precision questions are in docs/specs/questions/basic-core-public.md.


## User-required reference oracle

Some public corpus targets use old Jai versions. Dirty coordinator is running suspect cases with reference Jai0.2.030 in a no-network/restricted-write sandbox. Do not add old aliases or modify current APIs solely to satisfy corpus before reference behavior is confirmed. Continue independently established current-contract bugs. Clean implementers never read reference source, vendor bodies or raw reference logs; only sanitized reviewed contracts and independent reductions will be supplied.
