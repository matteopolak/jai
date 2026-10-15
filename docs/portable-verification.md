# Portable producer verification

This worker's new tests live in `tests/portable-stdlib`. They test reviewed public
declarations and independently constructed behavior, native ABI, or general
compiler regressions. They do not derive requirements from inherited stdlib
tests. The separate `tests/stdlib-contract` fixtures used by the runner are new
reviewed-spec tests. Full corpus and production integration remain coordinator
gates. Audio and developer tooling are excluded from new implementation work.

Prepare the NEW dependency composition and execute host interpreter/native tests:

```
python3 -B tools/check_portable_stdlib.py --posix-root ../bindings/stdlib/POSIX --hash-root ../foundations/stdlib/Hash --native --check-target linux/x64 --check-target windows/x64
python3 -B tools/check_portable_time_foundation.py
python3 -B tools/check_portable_meow_integration.py
python3 -B tools/check_portable_windows_utf8.py
python3 -B tools/format_portable_stdlib.py --check
python3 -B tools/format_portable_stdlib.py --lint
```

All compositions write only this checkout's `target/`. Current portable MD5/Meow
sources replace the shared Hash snapshot copies in that composition. Lint maps
owned stdlib paths to byte-identical files inside the configured library root;
private-import restrictions remain enabled. The parameterized Basic fixture
requires the NEW foundations composition and is checked separately there.
Generated facade/load-list changes normalize with jaifmt and regenerate twice.

The latest host suite passes 99 positives in interpreter/native, 23 expected
runtime faults in both modes, eight original compile-negative checks, SMTP,
interprocess channels, parent cleanup, native startup options and selected target
checks (`target/time-checkpoint-suite.log`). Two additional MPEG constant-write
probes now reject with the current compiler (`target/mpeg-promoted-negative.log`)
and are promoted unchanged into the required negative list, bringing it to ten.
The full runner result predates that promotion; it is not a ten-negative rerun.
NEW-foundation time tests pass interpreter/native O0/O2 and Windows CPU body
checks; the configured facade/private root/fixture pass strict lint separately.
Both NEW Meow tests pass interpreter/native x64, including the 317 C-produced
vectors. Windows_Utf8 checks both CPU bodies; Windows runtime remains unexecuted.

All 306 owned Jai files pass formatting/check. Full **strict lint fails** with
the rebuilt current source compiler/linter. Evidence is retained in
`target/time-checkpoint-strict.log`; no incomplete-compilation allowance or rule
suppression was added. These are distinct unresolved categories:

- Random module/private standalone roots: eager checking reports Context layout
  before `#add_context`; actual public behavior tests execute successfully.
- Socket module/private roots and loopback: eager checking rejects array-field
  element type reflection; actual loopback execution passes. Standalone native
  declarations also report an enum forward member `ADDRCONFIG` unresolved.
  These need general compiler/linter investigation, not facade special cases.
  Original field-array-element-type and enum-forward-member probes now reproduce
  both errors in ordinary -check and interpreter setup too; these semantic gaps
  are not confined to eager checking.
- Autorun/BuildCpp compile-time tool fixtures: linter compilation aborts, while
  the configured execution runner succeeds; exact linter phase/configuration
  support needs investigation.
- IPC reader/writer and startup build fixtures require runner-provided
  `CHANNEL_NAME`/`OUTPUT_PATH`; standalone lint does not supply those settings.
- Compile-negative fixtures intentionally fail semantic checking. Their checked
  rejection tests remain mandatory, and they remain formatted. The lint runner
  currently includes them and reports incomplete compilation rather than calling
  them lint-clean. A principled negative-fixture policy still needs integration.
- The pending workspace-hook reproducer still fails compile-time execution and
  remains evidence of unsupported compiler behavior.

This investigation found and fixed real source defects separately: a Unicode
mask literal had the wrong array element type, and Basic/Adpcm facades exposed
aggregate fields as nonexistent module globals. Reviewed nested fields remain
available; no compatibility export was invented. New public assertions preserve
mask shape/value and absence of the five invalid Adpcm exports. Unused locals
were renamed narrowly; no operational errors were discarded to satisfy lint.

`check_portable_meow_integration.py` now uses only NEW `meow.jai` and
`meow-vectors.jai`; its obsolete inherited-test invocation was retired. The
integration owner handles the repository-wide legacy test migration.

Machine_X64 is checked separately with a source-built x64 jailint host because
the reviewed module is x64-only. Its compile-time fixture actually executes
CPUID/masks in that interpreter; native C comparisons execute O0/O2 under the
focused machine runner. The lint driver attempts the ordinary, configured-time
and x64 groups even when one fails, and still fails the total gate. There is no
architecture fallback or suppression. On this ARM64 macOS host build the x64
linter with --locked -p jailint --target x86_64-apple-darwin into target/compiler.

Post-machine/Pool rerun passes100 positives,23 expected faults in both modes and
ten compile rejections plus prior integration/target checks
(target/pool-full-suite.log). Four additional reviewed typed-constant write
rejections for Unicode offsets/firstByteMark and Adpcm step/index tables pass
separately (target/immutable-tables-negative.log), and are now required by the
runner, bringing its negative list to fourteen. That100-case rerun predates those
four additions; there is no claimed fourteen-negative full rerun. All318 owned
Jai files pass formatting/check. Pool's focused strict lint and interpreter/native
O0/O2 pass. Whole-scope strict lint remains failed, including intentional negatives,
with no new exclusion or suppression.

Windows calendar batch rerun passes101 positives/23 faults in both modes and all
fourteen required compile rejections, retaining SMTP/IPC/startup/parent and target
checks (target/calendar-full-suite.log). Its pure production Gregorian validator
also executes native O2, and NEW foundation/default/nondefault time composition
regenerates stably and passes interpreter/native O0/O2. Both Windows CPU calendar
bodies check; actual Windows execution remains unavailable. All322 owned Jai
files pass formatting/check. Focused host and configured-time roots pass strict
lint; whole-scope strict lint still fails (target/calendar-owned-strict.log).
Windows-only bodies are inactive under host jailint, which currently exposes no
OS/CPU selector. Active Windows lint needs general tool support or an actual
Windows linter host; cross-compilation body checks do not satisfy that lint gate.

Post-f044252 native mapping/projection batch: refreshed own compiler build passes
the101-case/23-fault/14-negative full suite. Four2048-packet IPC pairings rerun
after the cross-platform handshake/fixture changes. Both Windows CPU lifecycle,
variable-packet and IPC bodies check under tools/check_portable_windows_channel.py;
native Windows and active Windows lint remain unverified. Actual Machine options
projection passes interpreter/native O0/O2 and rebuilt source x64 strict lint.
General field-array/forward-enum/workspace-hook probes still fail on the freshly
built compiler; target/*-refreshed.log preserves evidence. Whole strict lint remains
a separate failed gate, never replaced by these focused passes.

Socket batch:102 positives/23 faults/14 compile negatives and prior integration/
target checks pass (target/socket-full-regression.log). Pure production Winsock
control kernels execute65536 ioctl combinations and descriptor boundary cases in
interpreter/native O2, with active host strict lint. Windows loopback/error/wrapper
bodies and ABI assertions check both CPUs (target/socket-final-bodies.log), but
native Windows and active Windows lint remain unverified. Generation repeats with
identical ABI/facade/ledger bytes.331 owned Jai files pass formatter/check; whole
strict lint still fails with all configured groups attempted.

Native TCP fields add36 public macOS accessors verified with256 complete native SDK C record pairs on host/x64 and Jai interpreter/native O0/O2. Active private implementation/public fixture strict lint passes;334 owned files format/check. Full102 positives/23 faults/14 negatives and integration checks rerun successfully; whole strict lint remains failed. Commands/provenance and initial staging failure: portable-socket-fields.md.

Windows scope-ID increment: four exact accessors implement 28/4-bit overlay semantics. Public #run assertions pass Windows x64/ARM64; production word kernels pass host interpreter/native O2 and strict lint. Full103 positives/23 faults/14 negatives and integration/target checks pass (target/socket-scope-full-regression.log);339 owned files pass formatting/check. Native Windows remains pending; whole strict lint remains failed, including target configuration for the Windows-only fixture. Widening-shift compiler reproducer: tests/portable-stdlib/pending/widened-bitwise.jai expected8000; shifted high byte lost. SDK FIONBIO expected0x8004667e, original actual0x8004007e; assertion retained.

Pool/Linux increment: full104 positives/23 faults/14 negatives plus integration checks pass (target/pool-policy-full3.log). Pool unmapping executes host interpreter/native O2 and active strict lint; its Unix dependency excludes Windows target checking explicitly, without skipping host assertions. Initial Windows unsupported-module failure remains target/pool-policy-full2.log. Linux public field #run tests execute x64/ARM64; native Linux runner rejects this macOS host, with SDK C probe prepared but unexecuted.343 owned files pass format/check; full strict lint still fails.

Calendar increment: two exact public text APIs now use real temporary storage;
POSIX normalization/-1 collision/output error and Windows input/DST policies
follow refreshed review. Full106 positives/23 checked faults in both modes/14
compile negatives plus prior integration and target checks pass
(target/calendar-complete-suite.log). NEW foundation stable regeneration and five
time roots pass interpreter/native O0/O2 (target/calendar-foundation-final.log).
Both Windows CPU body checks pass (target/calendar-windows-final.log); native
Windows remains unverified. Active calendar implementation/test strict lint
passes (target/calendar-active-strict.log);347 owned Jai files format/check.
Whole strict lint remains failed at target/calendar-whole-strict.log.
ConvertToApollo alone remains the named time API gap: exact no-result #expand
header conflicts with value contract/current compiler. Original general
reproducer and precise reviewer/compiler question recorded; no fake export.

Windows Registry increment: seven native procedures/two scalar aliases/fourteen
access constants source-check both CPUs and regenerate byte-identically.
Non-Windows public import/privacy test passes actual interpreter/native.
Full107 positives/23 faults/14 negatives plus prior integration/target checks pass
(target/registry-full.log).352 owned Jai files pass format/check. Native Registry
execution and active Windows strict lint remain unexecuted/blocked; private ABI
lint fails honest Windows requirement, CLI has no target selector. Ten predefined
pseudo-handles remain absent pending reviewed64-bit extension conflict with SDK.
Exact API list, test-only setup/cleanup and failures: portable-windows-registry.md.

Shared TCP increment:22 Android accessors now share actual Linux implementation,
with per-platform export validation and four Linux-only scale helpers. Official
bionic header65536-word C probes pass host ARM64/translated x64; Android CLI still
rejects target selection, so no Android Jai/native pass. Linux x64/ARM64 public
#run bodies pass; macOS36 native SDK record pairs rerun host+x64 O0/O2 successfully.
Full107 positives/23 faults/14 negatives and integration/target checks pass
(target/socket-tcp-unix-full.log).352 owned files format/check; whole strict lint
still fails (target/socket-tcp-unix-whole-lint.log). Superseded Linux-only files
removed. All reviewed bitfield variants now have real source bodies; remaining
Socket CMSG algorithms/native shapes/reflection and native platform gates remain.

Ancillary increment: four exact CMSG procedures match4097 actual host native SDK
vectors in interpreter/native O0/O2 (host ARM64/translated x64). Linux/macOS both
CPU public #run assertions pass. Root layout/extreme-size/privacy regression plus
two checked size faults added. Full108 positives/25 checked faults in both modes/
14 compile negatives plus prior integration/target checks pass
(target/socket-cmsg-full.log).359 owned files format/check; active CMSG roots and
positive fixtures strict lint pass. Whole strict lint still fails at
target/socket-cmsg-whole-lint.log. Only CMSG_SIZE remains the missing ancillary
helper, with fine invalid-extent semantics still questioned; native Linux/
Android and target-aware lint remain pending. Exact inventory: portable-socket-cmsg.md.

Android host ABI helper: full109 positives/26 checked faults/14 negatives plus integration/target checks pass (target/android-abi-name-full.log). Focused source-built strict lint passes (target/android-abi-name-strict.log);363 owned files format/check. Full strict lint fails (target/android-abi-name-whole-lint.log). No Android/device/auth execution. Missing-public-surface doc regenerates byte-identically; producer tests still require coordinator independent review/integrated native CI before release.

Watcher safety increment: source-built private close_v2 reports actual error plus
released state; retained objects remain retryable, released objects cannot be
double-closed. Failed registration reuses metadata;4097 real file-as-directory
failures have bounded retained allocation counts and zero captured allocations
after teardown. Native C tests execute SDK EBUSY retention/retry and real SDK
EDEADLK error-channel injection under ASan/UBSan. Public event and six-error
continuing-handler fixtures pass interpreter and actual host ARM64/translated
x64 native O0/O2 (target/watcher-close-reuse-matrix.log). Universal library and
translated executable architecture checked. Focused strict lint passes;365 owned
Jai files format/check. Whole strict lint still fails; original generic-pointer
default constraint reproducer preserved, no API changed to hide it. Last broad
109-positive/26-fault/14-negative suite passed at target/watcher-close-full.log;
later watcher-only changes reran the dedicated full native matrix. Linux/Windows
watcher backends and full integrated CI remain unfinished. Detailed test triage/
private-protocol limits and source deployment prerequisite: portable-file-watcher.md.

Machine spin-hint increment: exact pause macro now emits real native instructions
and passes C-intrinsic/no-call baseline comparison O0/O2 (0 baseline,1/2 public,
8 C static instruction counts). Actual x64 compile-time interpreter/strict lint
and three OS x64 body checks pass; interpreter hint models no fixed delay/order.
Existing CPU/projection suite and full109 positives/26 faults/14 negatives plus
integration/target checks pass (target/machine-pause-full.log).371 owned Jai files
format/check; whole strict lint still fails. New original prefetch/fence native
probes emit0 instructions against C1 each, and their dependency checker fails
explicitly (target/machine-instruction-dependencies.log). Those APIs remain absent,
not fabricated completion. Eight instruction APIs/native platforms remain gaps.
