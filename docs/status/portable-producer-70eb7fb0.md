# Portable producer snapshot70eb7fb0

Independent producer status and deviations, preserved as handoff evidence.
Integration verification is recorded separately.

# Portable stdlib progress

Default build ownership replay fixed: shutdown used by-value array_free, leaving
the public plugin descriptor pointing at freed allocation. New public build-twice
fixture reproduced stale count/data; cleanup now uses Basic.array_reset. Two real
target/plugin lifecycles run in one module, descriptor cleared after each. Focused
workflow/replay passes, format/--check passes; strict lint still explicitly fails
only missing Check.get_plugin. Evidence target/default-build-twice-red.log and
default-metaprogram-workflow.log. No caller/address tracking workaround.

Coordinator14:34 request completed: public compare_alloc_and_free_traces compares
both opaque pointer identities, preserving exact signature/canonical type and
never dereferencing.2401 symmetric pairs inclnull/highbits pass #run/interpreter/
native O0/O2; existing packet layouts, Linux/Windows both-CPU source checks,
format/--check and strict lint pass. Evidence target/memory-protocol-compare-final.log;
original missing-export red retained. See docs/portable-memory-protocol.md. No
workaround/test exclusion. The protocol's historical comparator question is
resolved. Refreshed mixed questions.md remains unstaged for selective handling.

Project_Generator all seven public state/method rows implemented with real owned
collection/reset, compiler workspace/complete handling and four actual scaffold
files. Interpreter/native collection and real target O0/O2, defaults/persistence,
paths/filters/XML escaping, unchanged-file mtimes and actual output failure pass.
Formatting/--check pass. Full strict lint FAILS general SandboxHost SDK executable-
path call; original pending/system-executable-path-run.jai reproduces it. No
default/lint workaround; missing natvis resource and actual native VS execution
are explicit pending dependencies. Evidence target/project-generator-workflow.log,
project-system-executable-lint-gap.log; docs/portable-project-generator.md.
Inventory95 missing rows. Newly refreshed mailbox compare_alloc_and_free_traces
request is next, with current PG snapshot preserved for integration.

Socket native global production fix: six reviewed variable names/ten conditional
declarations now forward entities with filtered using, preserving C storage under
immutable :: semantics. General generator correction emits no snapshot aliases.
SDK C address equality/shared h_errno mutation/restoration passes interpreter and
native O0/O2; scoped fixture/bridge strict lint and formatting pass. Whole Socket
strict lint still red solely on general field-array type query. Interrupted CMSG
regression now passes, resolver passes both native CPUs O0/O2, and old enum gap is
resolved. Candidate addrinfo activation remains separate/pending full gate.
Evidence target/socket-storage-workflow.log, socket-resolver-storage-corrected.log,
socket-resolver-cmsg-corrected.log and socket-field-array-corrected.log.

Separate Socket test correction: resolver used unreviewed AF.INET. Replaced only
both input/output checks with reviewed AF_INET; all resolver assertions retained,
no API invented. Corrected compiler lets real interpreter/ARM64+x64 native O0/O2
resolver and both source targets pass; full strict lint still fails on a general
type-query gap. Production storage fix is a separate checkpoint. Evidence:
target/socket-resolver-storage-corrected.log. No full suite/combined pass claim.

Default parser audit fixed real duplicate warnings: generator now disables parser
reporting/global actions, and actual build performs them once. New release-alias
regression reproduced two warnings before the fix, then both aliases pass once.
Full focused no_check workflow rerun passes; strict lint remains explicitly red
on Check.get_plugin only (dependency request unchanged). Format/--check pass.

APK batch completed7 public entries: canonical whole-file/entry records, loader,
deinit, value/reverse iterator, section reporting and immutable signing marker.
Six interpreter/native Mac O0/O2 real-file runs, nine malformed/missing failures,
POINTER compile rejection, format/--check and strict lint pass. Independent Python
ZIP reads validate fixture contents/CRCs before Jai tests. No marker-to-signature
validity inference. Evidence target/apk-workflow.log; docs/portable-apk.md.
Inventory102 missing rows; root ledger updated for completed modules/workflow and
remaining Check/Compiler dependency. Prior writer enum declaration order restored
to reviewed order (explicit values unchanged), retaining reflected public order.

ZIP writer completed11 public entries: exact canonical30/46/22 records/defaults,
writer layout/lifecycle/temp storage/borrowed names, CRC/dummy CRC, file/memory
stored or real raw-DEFLATE blocks, local4096 padding and central/end emission.
Six interpreter/native Mac O0/O2 runs pass independent zipfile/zlib decompression,
block boundaries through131071, alignment, ownership and eight failure paths;
format/--check and strict lint pass (target/zip-writer-workflow.log). Deflate
currently uses stored blocks, so no size reduction; explicitly documented tradeoff.
Initial16-bit offset-overflow defect fixed after native-zlib rejection. Prior
32/24 layout question resolved by newly reviewed directives, not a compiler hack.
Inventory109 missing rows. Next: APK whole-file owned views and real entry iterator.

Example_Plugin completed: all ten reviewed entries, canonical My_Plugin layout,
option grammar/default/init state, compiler message reporting and allocation-owned
shutdown. Public tests interpreter/native O0/O2 and real Default_Metaprogram
-no_check +Example_Plugin builds/runs pass, as does strict lint and format/--check.
Evidence target/example-plugin-workflow.log. Inventory120 missing rows. Check
factory/config and general target CLI forwarding remain explicit dependencies;
no default-enabled or combined Mac success claim. Returning to reviewed ZIP/APK.

Default_Metaprogram workspace checkpoint: actual Mac target executables, inferred
and explicit outputs, relative import directories, add/run input, options,
parameterized plugin imports, two-plugin callback ordering, help/version and
genuine error paths pass with explicit -no_check. Path predicate interpreter/native
O0/O2 passes. Format/--check passes all new source/tests. Full strict lint FAILS
because delegated NEW Check exports no Mac get_plugin; ordinary default builds
therefore remain incomplete. Immediate coordinator request:
docs/default-metaprogram-dependency-request.md (Check factory/config contract and
general compiler target command-line forwarding). Original general
pending/workspace-target-command-line.jai fails the real target assertion.
Corrected compiler1929d5a built in assigned T7 target; immutable-alias probe now
rejects correctly, superseding adoption warning below. No peer writes or CLI
bypass. Evidence: target/default-metaprogram-workflow.log,
default-metaprogram-format.log, workspace-target-command-line.log,
constant-alias-corrected-compiler.log. New inventory130 missing rows; build remains
listed incomplete. Stable combined baseline822/7 has not been rerun here.

The old socket-resolver AF.INET expectation correction remains a separate dirty
test change; excluded provisional Performance_Report paths are untouched. ZIP
wire source remains durable at d1e6880. Next: dependency follow-through and the
newly reviewed real ZIP writer/APK workflow, rather than optional profile matrices.

Historical compiler adoption audit (corrected above): rebuilt own jaic/jailint from authorized current
Rust sources (target/forward-enum-compiler-build.log). Forward enum repair is now
ready for exact resolver retry. Current compiler also includes784415f live named
storage aliases, conflicting with refreshed :: immutability review. Minimal
tests/portable-stdlib/pending/constant-alias-immutability.jai assignment compiles
successfully (target/constant-alias-contract-conflict.log), expected rejection.
This remains a genuine compiler gate; no stdlib live-:: workaround is introduced
or broader compiler integration claim made. Constant/type query separation must
be corrected by compiler owner while preserving proper filtered reexports.
Mailbox newly prioritizes reviewed Default_Metaprogram/plugin implementation;
switching there instead of optional archive/color work. Native Windows color
SAVE_RESTORE semantics still need finer review; no guessed backend committed.

ZIP wire batch:12 public declarations implemented, including canonical version,
exact constants, CRC32, observable EOCD backing mutation and single-evaluation unit
macros.65536 words/264 native-zlib vectors/5 diagnosed invalid cases pass15
interpreter/native runs, Linux/Windows source checks and strict lint. Shared exact
owned source staging now serves seven focused runners; ADB config/native matrix
rerun passes. Evidence: target/android-zip-wire-staged.log and
android-stage-adb-regression.log. Header32/end24 own-size probe versus wire30/22
is an explicit review question, not a guessed compiler bug or packing workaround.
Writer/APK APIs remain missing; portable-zip-wire.md. Missing147 ->135.

X.509 structural extraction implemented: optional v1/v2/v3 version handling,
20-byte serial skip, correct SubjectPublicKeyInfo views into caller DER. Four
genuine native C-created/signed/verified Ed25519/RSA certs match native SPKI output,
including extensions. Six malformed cases,10 interpreter/native O0/O2 runs,
Linux/Windows both-CPU source checks and strict lint pass:
target/x509-extraction-first.log. No production crypto dependency, credential
read, fabricated fixture or certificate verification claim. Finer input policies
documented portable-x509.md. Missing148 ->147; module remains incomplete.

ASN.1 diagnostics implemented: all three overloads, explicit traversal frames,
all reviewed supported type families, yellow Print_Color banners, UTC calendar,
borrowed content forwarding and explicit invalid/unsupported errors.15 interpreter/
native runs cover300-level nesting and7 failures; Linux/Windows both-CPU source
checks and strict lint pass (target/asn1-printer-final.log). Human text/century/
Windows ANSI finer policies documented in portable-asn1.md. Primitive/Java/flag
focused regressions pass with actual NEW foundation composition. Missing151 ->148.
Active broad regression before printer:116 positives,27 expected faults and16
compile rejections plus actual IPC/runtime config/Linux+Windows targets pass
(target/android-sdk-asn1-corrected-full.log). Resolver candidate remains a genuine
separate failing compiler gate; no all-library green completeness claim.

Test-only OID correction: removed obsolete android-oid-count expected assertion
after refreshed whole-record equality. Positive android-oid now verifies all12
slots and count bytes for -1/13/s64 extrema without count-based indexing. Public
spec establishes the oracle; no production guard restored or assertion disabled.
Focused strict lint/format pass; broad rerun follows. Original expected-fault
failure preserved target/android-sdk-asn1-active-full.log; portable-asn1.md details.

macOS addrinfo review consumed: generated canonical shape/facade candidate retained
in pending/socket-macos-addrinfo.patch. Native SDK C layout+numeric resolver passes
ARM64/x64. Jai full fixture and strict lint fail known general forward-enum
ADDRCONFIG dependency; independent reduction pending/socket-ai-forward-enum.jai
fails LATER. Candidate activation also fails existing cmsg-layout; preserved
target/android-sdk-asn1-socket-full.log. Active source restored; no enum reordering,
assertion removal or missing-API credit. Isolated generation/gate keeps failures
visible and active public API unchanged pending compiler fix. Details:
portable-socket-resolver.md. Active full regression rerun pending.

SDK/startup milestone: real exact directory precedence/warnings and platform-tools
executable discovery, durable allocator-owned cache, explicit per-call start-server
and failure retention. Main/cache:10 interpreter/native runs; verbosity:3; actual
default-assert true/false startup:10 with verification separately enabled. Linux
both-CPU source checks and strict lint pass: target/adb-sdk-final.log. Newly composed
foundation is read-only input/staged only. Conventional-existing-home branch and
native Windows/real SDK/device remain unverified, documented in portable-adb.md.
Missing152 ->151; no declaration-only credit or native Android generation claim.

ADB review correction milestone: temporary version/device views+array, exact
version lines, malformed-device diagnostics, double-quote-only shell wrapping,
compression conflicts, first PID+warning/-1 failure, empty commands and launch0
fixed. Five interpreter/native modes, verbosity/Linux checks/strict lint pass
(target/adb-reviewed-policies-final.log). Harness copy-mode defect found/fixed:
earlier malformed-output coverage was launch failure, now actual parser runs.
Test corrections are separate; docs/portable-adb.md preserves exact evidence.
SDK discovery/cache/server startup remains open, no new inventory row credited.

Refreshed ASN.1 review consumed: full-record OID equality, trailing-period text,
immutable one-element known array and supported nonnegative/single-tag domain
corrected. Actual ASN1_Value + both read overloads and u32LE-prefixed borrowed
block now implemented. Five programs pass interpreter/native ARM64+x64 O0/O2;
four pure programs source-check Linux/Windows both CPUs; strict lint passes.
517 INTEGER/183 OID vectors retained with corrected reviewed-domain expectations.
Test corrections are explicit in portable-asn1.md, separate from production fixes.
Missing156 ->152. ADB refreshed discovery/start-server/quoting/storage/PID policies
are still pending correction; older ADB pass counts do not prove those contracts.

Manifest flags milestone: canonical reviewed s32 enum_flags plus actual16-name
pipe parser, duplicates ORed, invalid components diagnosed without partial result.
All16 single/256 pair cases and7 malformed cases pass interpreter/native both
CPUs O0/O2, Linux/Windows both-CPU source checks and strict lint. Independent
fine-policy questions are explicit in portable-android-values.md. No native
Android/manifest generation or test-oracle correction claim. Missing158 ->156.

Java host milestone: exact JAVA_ENV_NAME/find_java_bin_path_from_environment
implemented, including copied environment value, argv-safe native launcher probe,
real status/failure cleanup and Windows Unicode environment source backend.
Thirty interpreter/native ARM64+x64 O0/O2 configurations plus Linux both-CPU
checks and strict changed-code lint pass: target/android-java-final.log.
No real JVM/SDK/device or native Windows verification claim. Test corrections
(absolute fixture path due CLI cwd, interpreter argument separator) are separate
from production code; see docs/portable-java-discovery.md. Missing rows160 ->158.

Latest app-lifecycle milestone: stop_app/is_app_running/android_is_app_installed
implemented via actual Process/ADB commands; missing row inventory163 ->160.
All five interpreter/native ARM64+x64 O0/O2 modes, verbosity, Linux both-CPU
checking and changed strict lint pass (target/adb-apps-final.log). Memory tracking
returns to zero. PID syntax is now decimal-only and validates every process ID.
No test-oracle corrections, no device/Windows execution claim. Exact supported
failure policies and remaining fine-review questions: docs/portable-adb.md.

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior Jai implementations used. Extensions and corpus preserved.

Current implementation checkpoints: ASN1 fff40be, Registry1f1e568, ADB4fc510a, System049154a; time e81f1a5, SHA1579458, ISA c45ee67, critical Pool/Thread d6db68f. Opaque-pointer handoff:338a4a8. Pool/Unix Thread
critical corrections are committed: field-only Pool guard, no registry,
allocator/options preserved by reset/release, genuine returned leak report fixed.
Every owned essential Thread SDK operation now executes outside optional asserts;
error logging and native ownership retention are explicit. All ten configurations/
fixtures pass interpreter, host ARM64 and translated x64 native O0/O2 (50 runs),
including the unchanged NEW foundations report and audio reproducer. Both default
assertion settings pass focused strict lint and Linux x64/ARM64 source checks.
Evidence: target/lifecycle-all-green.log; original failures retained separately.
The draft invalid locked-mutex oracle and staging corrections are documented
separately from production fixes. Native Linux/Windows/Android execution, forced
join failures and group transactional fault recovery are not claimed. Windows
Thread is untouched. Digest sources preserved through the critical checkpoint are committed separately
as1579458; all three provisional Performance_Report files stay excluded.
Broad regression subsequently passes112 cases (including pending digest fixture),
27 expected faults and16 compile negatives plus IPC/SMTP/Linux+Windows source
checks. Original Basic.exit staging dependency error is retained at
target/lifecycle-full.log; private libc abort now implements the documented
conservative fatal group policy without requiring a foundation export.

Machine ISA continuation: all eight remaining reviewed public macros now emit
real instructions through NEW compiler mechanisms; native O0/O2 and source-built
x64 interpreter pass, both optional RNG capability errors pass, focused strict
target-aware lint and macOS/Linux/Windows x64 body checks pass. Actual SDK CPUID
lacks both RNG features, so capable-hardware execution remains a CI gate. Generic
fence/prefetch original probes now emit real opcodes versus official C intrinsics.
386 owned files pass formatting/check, including preserved pending digests; whole
strict lint remains a separate failed gate. No source compiler edits or fake ISA
results. Full task remains unfinished; missing public surface inventory now names246
rows after the two real digest APIs. Next: opaque-pointer compiler handoff and
remaining portable APIs after the critical/ISA/digest/time checkpoints.

Post-f044252 work: get_machine_options_x86 now implements the reviewed generic
#modify API as a checked in-place projection of actual Compiler.Build_Options
byte storage. Interpreter/native O0/O2 verify storage identity, live feature edits
and untouched trailing bytes; focused strict x64 lint passes. No synthetic
instruction wrappers added. Windows shared-channel backend has
actual native-call source/body checks and Unix
regression evidence; no native Windows pass claimed. Latest rebuilt compiler
still rejects the original general field-array element-type, forward-enum and
workspace-hook reproducers. Continue Windows Socket and remaining public APIs.

Previously verified checkpoint: POSIX native crash diagnostics and runtime startup
flag integration. Native C builds with `-Wall -Wextra -Werror`. Actual protected
memory faults and raised SIGSEGV terminate with preserved signals and a native
stack in interpreter/native execution. Four worker threads independently initialize
and clean up stacks. Build_Options ON/OFF workspace tests pass native execution.
All 175 owned Jai files pass repo jaifmt --check and jailint -D warnings. The
expanded regression passes 58 interpreter/native cases, ten SMTP scenarios,
four parent-lifetime scenarios, four expected faults in both execution modes,
Xar reverse rejection, startup ON/OFF and selected Linux/Windows target checks.

Previously verified checkpoint: classic Zip_File_Directory parsing and ownership,
including malformed second-record cleanup under a counting allocator. The full
focused run now passes 59 interpreter/native cases and six expected faults in
both modes, retaining the SMTP, parent-lifetime, startup and target checks above.
All 181 owned Jai files pass jaifmt --check and jailint -D warnings. The ZIP field
and extension contract gaps are documented, not asserted as established behavior.

Previously verified checkpoint: CAS-based Atomics arithmetic/bitwise operations and
the exact alias declarations. The three alias intrinsics lack source-compiler
lowering; the original pending reproducer and handoff are documented. Full focused
regression passes 61 interpreter/native cases, seven expected faults in both
modes, two compile-time rejections, all prior SMTP/startup/parent checks and selected
Linux/Windows checks. All 188 owned Jai files pass format/lint. Four-worker tests
verify prior-value uniqueness, bit claims and zero-reaching decrement behavior.

Previously verified checkpoint: partial Deep_Copy scalar/string/resizable-array
operations, callback/preallocated/reused-map cases and conditional debug globals.
General graph support is blocked by reflected struct alignment 0 (versus 8),
reproduced in interpreter/native with retained assertions. It is not counted as
completed graph functionality. Full focused regression passes 63 cases in both
modes, nine expected faults in both modes, two compile-time rejections and prior
SMTP/startup/parent/target checks. All 197 owned Jai files pass format/lint.

Previously verified checkpoint: Unix BuildCpp C/C++ compile/link/archive/object and
macOS universal outputs. Native executable and dynamically loaded function return
the expected results; stale archive members disappear on rebuild; missing tool,
invalid C and wrong-target objects report real errors after cleanup. Full focused
regression passes 64 interpreter/native cases, nine runtime faults in both modes,
five compile-time rejections, and prior SMTP/startup/parent/target checks. All
203 owned Jai files pass format/lint. The runner requires zero C-helper intermediate
directories and preserves previous output after failed compilation.

Previously verified checkpoint: Treemap stable nodes, weights/sort, hierarchy,
callback borders, cached squarified geometry and shared-boundary growth fix.
Full regression passes 65 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections and prior integration checks. All 209 owned
Jai files pass format/lint; delegated Math is copied only into the integration
root. Meow is blocked by the canonical register macro compiler reproducer;
no replacement public type/hash routine was invented.

Previously verified checkpoint: Unix Shared_Memory_Channel SPSC transport, ownership,
real wrap/full/corruption/max-packet behavior and captured allocator cleanup.
Full regression passes 66 interpreter/native cases, ten runtime faults in both
modes, five compile-time rejections, four interprocess pairings with 2,048 packets
each, and prior SMTP/startup/parent/target checks. All 215 owned Jai files pass
format/lint; Linux x64/arm64 channel code is separately compile-checked. Wire
details and Windows/Linux-execution gaps remain explicit. Two early failed runs
left unjournaled PID-named objects; no global deletion was attempted. Subsequent
tests journal and check cleanup of only their recorded resources.

Previously verified checkpoint: Unix Autorun helpers and real COMPLETE lifecycle,
including native child argument forwarding, repeated direct execution, NO_OUTPUT
skip and real runtime launch/exit failure logs. Full regression passes 67 cases
in both modes plus prior faults/rejections/SMTP/IPC/startup/parent/target checks.
All 220 owned Jai files pass format/lint. Compiler mixed-spread loss and CLI use
of a non-oracle helper are retained as pending reproducers; no convenience export
or surrogate callback module parameter was added.

Previously verified checkpoint: MPEG canonical buffers, checked
bit/VLC/start-code/file helpers, all reviewed immutable tables, six pixel aliases
and integer IDCT. Full focused regression passes 70 interpreter/native cases,
11 expected runtime faults in both modes, five compile-time rejections, ten SMTP
scenarios, four 2,048-packet process pairings and prior startup/parent checks.
Linux and selected Windows checks pass; Windows MPEG is explicitly excluded after
an observed failure at the existing File Unix guard. All 230 owned Jai files pass
source-built jaifmt --check and jailint -D warnings; table regeneration is byte
idempotent.

Previously verified increment: canonical Video lifecycle/frame storage, transactional
headers/matrices and allocation retry/lifetime checks; motion/vector wrapping and
half-pixel prediction; entropy/dequantization/slice/frame reconstruction. Independent
constant intra stream and all ten red I/P frames in the authorized fixture's
elementary payload decode, including rewind and pixel checks, in both modes.
Full regression passes 73 cases in both modes, 13 runtime faults in both modes,
five compile-time rejections and prior SMTP/IPC/startup/parent/target checks.
Final review then added missing/overlapping coverage and reference validation:
all six MPEG positives and four MPEG faults pass interpreter/native, with Linux
x64 checks. The new missing-region fault retains its completeness assertion.
All 239 owned Jai files pass format/lint. B-picture prediction is directly tested;
full B/AC stream fixtures and dimension/rate transitions remain incomplete.
Continue program-stream demux, audio and Plm before remaining owned modules.

Previously verified increment: MPEG-1 Layer II unprotected audio, canonical Audio/Samples,
headers/quantizers/scalefactors and real interleaved synthesis. Independent silence
and sixteen mono 440 Hz tone frames pass channel/amplitude/frequency/count/rewind
checks in both modes. Direct matrix versus licensed public C bases differs by at
most 9.44472552e-7; this is algorithm verification, not API authority. Whole-table
addressing preserves canonical quantizer pointers; the original direct-index
lifetime and qualified aggregate-write gaps remain pending. CRC and format changes
reject explicitly; stereo stream fixtures remain pending. Compiler rebuilt from
current independent sources with --locked, private target. Full regression passes
74 interpreter/native cases, 16 faults in both modes, six compile-time rejections,
and prior SMTP/IPC/startup/parent/target checks. All 248 owned Jai files pass
jaifmt --check and jailint -D warnings. Continue demux/Plm.

Previously verified increment: MPEG-1 program-stream parsing and canonical Plm/Packet
lifecycle, callbacks, enable/loop flags and real linear seeks. Full clip decodes
ten video/sixteen audio frames without extracted payloads. Bytewise append input,
borrowed buffer/file ownership and 240-frame file refills pass in both modes;
tracking reports zero allocations after program cleanup. Full regression passes
75 interpreter/native cases, 18 faults in both modes, six compile-time rejections
and prior integration/target checks. A final retained buffer assertion then fixed
signaled end bounds after compaction; changed MPEG buffer/video/program cases are
rechecked independently. Existing own MPEG regression passes interpreter/native.
All 252 owned Jai files pass jaifmt --check and jailint -D warnings.
Seeking/count/resume policies and bounded buffering require review; MPEG-2,
unbounded PES, CRC/format changes, macros and compiler constant gaps remain.

Previously verified increment: original intra-coded B-order and nonconstant horizontal
AC fixtures; fixed EOF loss of the pending reference following trailing B output.
The retained test now yields luma 80/120/160 in display order, with correct times
and rewind. No-delay B input rejects; real I/P frames pass no-delay mode. Full
regression passes 76 interpreter/native cases, 19 faults in both modes, six
compile-time rejections and prior integration/target checks. All 254 owned Jai
files pass jaifmt --check and jailint -D warnings. Inter-predicted B, stereo, CRC,
format transitions and unresolved public contracts remain; continue these.

Previously verified increment: nonzero stereo/dual/joint Layer II fixtures with distinct
channel gains. Fixed joint shared-sample reconstruction to retain both scalefactors;
raw quantized values are decoded once and scaled separately. The temporary replay
path is removed. Two frames and rewind pass per mode. Full regression passes
77 interpreter/native cases, 19 faults in both modes, six compile-time rejections
and prior integration/target checks. File backend formatting is now excluded under
platform-io ownership; all 254 files in the narrowed scope pass format/lint.
CRC and remaining codec contracts are next; broader portable scope remains active.

Previously verified increment: source-compiler integration now runs exact atomic
aliases, original caller-scope cleanup, reflected alignment and cyclic/shared
Deep_Copy graphs. Five former pending regressions are promoted, retaining all
assertions. Remap_Context's exact lexical macro passes nested/early-return checks.
Mixed spreads pass and Autorun's extra argv allocation is removed. Full regression
passes 82 interpreter/native cases, 19 faults in both modes, six compile-time
rejections and prior integration/target checks. All 254 owned Jai files pass
format/lint. Constructor/constant-index/qualified-array-write/workspace/widened-bitwise
gaps remain. Scalar register rejection is now a proper category diagnostic, not
evidence against supported SIMD registers; Meow remains unfinished pending a valid
probe and implementation. Continue protected MPEG audio and remaining modules.

Previously verified increment: protected Layer II frames compute/validate actual
header/allocation/scfsi CRC, preserving canonical Audio ABI with private captured
metadata. Two protected joint-stereo frames plus rewind pass; flipping the wire
checksum produces a checked mismatch before synthesis. Tracking verifies metadata
cleanup. Parsed-header identity is required for frame decoding; copied/manual
records and registry cost are explicit deviations awaiting contract review.
Full regression passes 82 interpreter/native cases, 19 faults in both modes,
six compile-time rejections and all prior worker integration/target checks.
All 254 owned Jai files pass source-built jaifmt --check and jailint -D warnings.
Continue valid SIMD register verification, Meow/SIMD and remaining owned modules.

Previously verified increment: all reviewed Meow exports execute real calico hashing,
register mixing/lane extraction, incremental state and diagnostics. Live mutable
array identity/edits are checked. 317 source-built native C cases verify one-shot,
fragmented streaming, both 128-byte outputs, tails/blocks/page offsets and custom
tables/seeds; interpreter/native O0/O2 pass. The original scalar register probe
is preserved as a category rejection; valid operands pass. Ancillary scratch/dump/
store/state-byte contracts and portable performance remain honest limitations.
Full worker regression passes 86 interpreter/native cases, 20 faults in both modes,
eight compile-time rejections and prior SMTP/IPC/startup/parent/target checks.
All 265 owned Jai files pass format/lint. Existing own Meow x64 assertions pass in
both modes with an explicit NEW-foundation target overlay; no peer writes or
production integration claim. Continue SIMD and remaining owned modules.

Known workarounds and incomplete behavior are recorded in
[deviations](stdlib-deviations.md), [gaps](../portable-stdlib-gaps.md) and the
module ledger. Next: finish regression/checkpoint, then continue remaining owned
portable modules using reviewed specifications. Full corpus/release integration
remains the coordinator's responsibility.

Previously verified increment: canonical SIMD value aggregates and supported scalar kernels pass interpreter/native, including all comparison forms, 64-lane masks, wrap, unaligned stores and reflected names. No allocation or ISA dependency; scalar min/max delegates to Basic. Load's missing result header and offsets/looping/interleaving contracts remain unresolved. Full suite passes 87 positive cases in both modes, 20 expected faults in both modes, eight compile rejections and prior SMTP/IPC/startup/parent/target checks. Source-built formatter/linter pass all 269 owned Jai files. Review records distinguish implementation mask/FP/overflow policies from reference facts. Continue executable-format containers and remaining modules.

Previously verified increment: executable_formats supplies canonical archive records, bounded classic/GNU/COFF/BSD parsers, real symbol indexes and universal signature detection. Original wire fixtures and a freshly compiled C/ar archive pass, including malformed index/string/header/padding checks and tracked zero-live cleanup. Universal records await missing Arch_File shape; thin/64-bit indexes reject. Full worker suite passes 88 interpreter/native cases plus all prior 20 faults/eight rejections/integration/target checks. All 272 then-owned Jai files passed formatting/lint after removing one unused test import. Next audio sample/mixing foundations and remaining modules; full task remains unfinished.

Previously verified increment: Sound_Player has nineteen canonical common records/enums, real sample arithmetic and magic reads, exact reviewed mutable arc initializers and shared accumulator/selected-arc/retired-decoder storage. Cross-import mutation, ABI/defaults and two checked safety faults pass. Full suite passes 89 interpreter/native cases, 22 expected faults in both modes, eight compile rejections and prior SMTP/IPC/startup/parent/target checks. All 279 owned Jai files pass format/lint; Sound/SIMD generators reproduce exactly. Playback/backends/panning/resampling/compressed decode remain unfinished, with detailed contracts and no fake success. Continue portable bundle/tool helpers and remaining scope.

Current verified increment: all reviewed MacOS_Bundler procedures now perform real macOS bundle/icon operations and portable scalar XML writing. Interpreter/native tests run copied script executables, both resource modes including hidden files, optional plist omission, actual sips/iconutil ten-size round trips, invalid image/missing executable diagnostics and cleanup. XML independently validates with Python/plutil; NEW foundations execute finite-real output and reject nonfinite values. Newly required basic-context was added to both plist/Meow overlays after actual staging failure; both rerun successfully. Full suite passes 90 positive interpreter/native cases, 22 faults/eight rejections and prior integration/target checks. All 284 owned Jai files pass format/lint. Copy/name/Any/partial-output policies are explicit review limits. Continue real file watching and remaining portable modules.

Next increment in progress: File_Watcher native lifecycle/event queue. Verified NEW FSEventStreamContext ABI regression against official SDK; preserved failed assertion, no peer edit or zero-value workaround. Generic nested callback specialization probe passes interpreter, so it is not a compiler gap. Watcher execution remains unimplemented at this checkpoint.

Verified watcher increment: exact macOS File_Watcher facade executes SDK-native callback queues, real create/modify/remove/rename, typed dispatch, trailing-edge coalescing, recursive filtering and overflow rescan in interpreter/native modes. Captured allocator cleanup returns zero under a changed polling context. Native backend executes under ASan/UBSan plus actual owned-allocation tracking, including failure/overflow. All 289 owned Jai files pass format/lint. No Windows/Linux support or binding-ABI repair claim; reviewed-policy/packaging limits documented. SIMD's newly updated reviewed page resolves prior gaps and requires 1/0 comparison lanes/truth-based masks; correcting those and finishing its remaining operations is next. Existing full suite's 90-case result predates that new oracle update and is not a claim against the revised SIMD contract.

Current verified SIMD oracle increment: all reviewed exports now execute scalar value kernels. Added unaligned contiguous load, byte gather/scatter (negative/repeated offsets and later-lane overwrite), i*STEP indexes and complete interleaved pair sums. Corrected prior all-ones/MSB choices to the updated oracle's 1/0 comparison values and truth masks; source defects remain documented. Interpreter/native focused tests and byte-identical regeneration pass. Full worker regression again passes 90 cases in both modes, 22 faults, eight compile rejections and prior SMTP/IPC/startup/parent/Linux+Windows target checks. All 289 owned Jai files pass format/lint. Watcher focused native/sanitizer checks remain separately verified. Continue compiler performance/report and remaining portable scope.

Runtime/CAPS checkpoint: exact three-boolean Runtime_Support now consumes the private settled compiler configuration. Actual root allocations 0/65536/131072 pass interpreter/native O0/O2; independent child 0/131072 native executions pass. Pool CAPS accepts required null data, delivers persistent name and exact flags; runtime heap name delivered. Full suite passes 92 cases in both modes, 22 faults/eight rejections and prior integration/target checks; 283 narrowed owned files pass format/lint. Audio/tools ownership excluded. Three provisional Performance_Report files remain uncommitted, enumerated in portable-runtime-configuration.md; no completion claim. Continue public time/calendar and containers; Flat_Pool defaults still missing from oracle.

Time/CAPS family checkpoint: to_apollo now scales exact binary significands into signed two-word femtoseconds, including large finite durations. POSIX timespec/realtime/monotonic/UTC-local calendar APIs execute genuine native queries and zero-based calendar conversions. Full suite passes 93 interpreter/native cases, 22 faults/eight rejections and prior integration/Linux+Windows checks; time test also executes native O2. Extended CAPS contract to temporary/C-fallback/overwriting/unmapping allocators before instance access; all four allocation suites pass interpreter/native O0/O2. 285 owned files pass format/check/strict lint. Android CLI target rejected as unsupported, no Android validation claim. Detailed per-public-time API gaps and policy review in portable-time.md. Continue container/platform backlog; unresolved Flat_Pool defaults and startup clock origin recorded, no fabricated exports.

Flat_Pool/container checkpoint: canonical Flat_Pool and real native get/reset/fini/mode core pass interpreter/native O0/O2 with explicit OS reservations, including actual shared-readonly mprotect failure preserving cursor/commit state. Public init/example and unspecified global overwrite remain missing, not counted complete. Hash_Table existing duplicate copies/removal now have 128-duplicate, rehash/copy lifetime, captured-owner cleanup, tombstone/counter and NEW scalar-default regressions. Full suite passes 95 cases both modes, 23 faults both modes, eight compile rejections and existing integration/target checks. Formatter/check/strict lint pass 290 owned files. First new fault expectation omission caused runner KeyError; registered exact diagnostic and rerun passed, original log retained. Continue remaining portable/platform APIs; no audio/tooling changes.

Refreshed Flat_Pool oracle adopted immediately after inbox read: both inferred module parameters, exact inferred init default256MiB, page rounding, lazy get, global OR local stamping and real example added. Normal/capacity tests now call public init; interpreter tests pass configured/default extents, all four stamp combinations, zero-byte reservation, reinit and STARTUP/SHUTDOWN. Full95-case suite and strict lint running; old unresolved-default reports superseded. Windows_Utf8 changes remain durable and uncommitted with both Windows CPU ABI/body checks and host strict lint previously passing, native execution still unavailable.

Flat_Pool initialization rerun complete:95 cases/23 faults both modes plus eight rejections and prior integration/target checks pass; dedicated Flat_Pool native O2 passes;293 owned files pass formatting/check/strict lint. Refreshed reserve/default/overwrite gaps are resolved, not remaining blockers. POSIX-host implementation now exercises all reviewed procedures; Windows/console backend and Android target-validation gaps remain.

Windows_Utf8 checkpoint: both reviewed procedures have real Kernel32 conversion, correct explicit/default termination and failure cleanup. Original Windows fixture covers non-BMP/embedded-NUL/empty/native-invalid/allocation-failure cases, and both CPU bodies/ABI type-check. Actual Windows execution remains unavailable and unclaimed; dedicated runner requires Windows for --native. All293 owned files pass format/check/strict lint. Provisional Performance_Report remains uncommitted/excluded. Continue remaining portable/time/backend work after inbox review.

Virtual-memory backend checkpoint: shared private reservation/commit/release/page-size operations preserve real POSIX execution and add Windows VirtualAlloc/VirtualFree. Full Flat_Pool fixture now type-checks Windows x64/ARM64 including initialization/default/overwrite/lifecycle, rather than record-only checks. Actual Windows execution remains unverified. Full95-case/23-fault interpreter/native suite and prior eight rejections/integration/target checks pass; dedicated native O2 passes; all294 owned files pass format/check/strict lint. Continue portable time gaps and remaining modules after inbox review.

FILETIME checkpoint: exact canonical Windows wrappers call real private two-word arithmetic. Production-source unit executes host interpreter/native O0/O2 across Unix/1601 epochs, unsigned64 boundaries, invalid/pre-epoch/overflow and sub-tick cases. Windows x64/ARM64 wrappers/ABI fixtures type-check; actual Windows runtime still unverified. Full96-case/23-fault both-mode suite plus prior rejection/integration/target checks passes;297 owned files pass formatting/check/strict lint. Continue native Windows clock exports and remaining portable APIs after inbox review.

Windows clocks checkpoint: public realtime uses actual Kernel32 FILETIME, monotonic uses typed QPC with atomic frequency caching and exact private integer scaling. Both Windows CPU fixture bodies type-check. Production-source counter unit executes host interpreter/native O0/O2 including full signed64/fractional/invalid/monotonic vectors. Actual Windows calls/cache race remain unverified. Full97 positive/23 fault both-mode suite plus eight rejections/prior integration/target checks passes;300 owned files pass format/check/strict lint. Remaining time gaps: seconds_since_init origin/hook, calendar text/ConvertToApollo caller scope and native Windows calendars. Continue remaining portable scope with inbox checks.

Machine_X64 blocker confirmed: original leaf0 vendor assertion fails interpreter and native x64. Independently compiled C SDK counterpart executes real CPUID and returns vendor/maxleaf. No Machine module fake0 fallback added; minimal reproducer and generic lowering handoff in portable-machine-gaps.md. All301 owned Jai files still pass format/check/lint, pending case explicitly failing not counted green. New inbox resolves seconds_since_init as first-call baseline; implement next, superseding prior origin questions.

Elapsed checkpoint verified: exact seconds_since_init lazily captures the FIRST CALL origin per refreshed oracle, with private CAS-safe shared publication. Ordinary before/after sleep, eight-thread first-use and actual-macOS compile-time-to-runtime reset all execute interpreter/native O0/O2. Windows ARM64 body checks pass, with actual Windows execution unclaimed. Full98-case/23-fault both-mode suite plus eight rejections/prior integration/target checks passes;305 owned files pass format/check/strict lint. Prior origin questions now resolved. Next review remaining portable contracts/Basic numeric guard updates without duplicating peer work.


Parameterized time integration in progress: NEW foundation integer guards already exist and remain that producer's work. Focused composition exposed/fixed default-vs-configured Apollo_Time nominal return mismatch using primitive private word pairs. It also exposed real native clock queries disappearing inside ENABLE_ASSERT=false discarded assertions; queries now always execute, with independent operational diagnostics and explicit invalid results for continuing handlers. Configured real wall-clock/delayed-elapsed tests pass NEW composition interpreter/native O0/O2 and Windows body checks. Full own suite99 cases/23 faults passes both modes. Rebuilt strict jailint correctly rejects inputs outside configured library root; runner now maps byte-identical owned files into staged root. Shared Hash facade/scalar file is excluded by ownership, current portable MD5/Meow retained over peer snapshot. Final mapped lint pending; old failure logs retained.

Machine CPU-query increment verified: canonical records and200 reviewed feature values, all352 mask positions, real vendor/eleven-register CPUID and unknown-vendor fallback execute. Native O0/O2 matches official-header C oracle; original vendor probe now passes both optimizations and is promoted unchanged. Actual x64 compile-time interpreter assertions and strict lint pass using a newly source-built x64 jailint. macOS/Linux/Windows x64 body checks pass; ARM64 interpreter explicitly diagnoses. All313 owned files format/check; full strict lint still fails (all three configured groups attempted), with genuine general field-array/enum-forward compiler reproducers retained. Runtime settled root0/65536/131072 and child0/131072 allocation rerun also passes actual interpreter/native checks. Details and exact remaining instruction/options exports: portable-machine-gaps.md. Next: remaining portable scope and general compiler/linter integration; no full completion claim.

Pool safety increment: original positive-INT64_MAX request reached backing allocator as negative; checked private/public overhead now rejects unrepresentable extents before forwarding. Real supplied-allocator failure preserves live contents/cursor/bookkeeping and release reaches zero live blocks. Interpreter/native O0/O2 and focused strict lint pass. Full100 positives/23 faults both modes/ten compile negatives plus integration/target checks pass; four new Unicode/ADPCM typed-constant write rejections pass separately and enter required list (now14). All318 owned files format/check; full strict lint remains failed for recorded compiler/configuration/intentional-negative categories, no suppression. Exact Pool API inventory and unmapping specialization question are in portable-pool.md. Next: continue owned backlog and coordinator-facing semantic/dependency gaps.

Windows calendar increment: exact to_calendar/calendar_to_apollo now use real Kernel32 UTC and dynamic-DST Ex APIs; both CPU bodies and configured Basic instances check. Native Windows execution remains unverified, and host lint leaves Windows branches inactive because jailint has no target selector. Production Gregorian validation executes a400-year cycle plus native O2. Full101 positives/23 faults both modes/all14 compile negatives and prior integration/target checks pass;322 owned files format/check. NEW foundation regeneration/interpreter/native O0/O2 and configured strict lint pass; full strict lint still fails with preserved diagnostics and no suppressions. Native ABI/minimum-Windows/ambiguity policies and precise remaining time APIs are documented in portable-time.md/deviations. Next: remaining owned backlog and general target-aware lint/compiler integration; no task-completion claim.

Native TCP accessor increment after41a015a:36 reviewed macOS getters/setters now execute against actual Apple SDK C bitfield layouts. All256 whole-record pairs match interpreter and actual host/x64 native O0/O2; x64 C output independently matches host C output. Active implementation/fixture strict lint passes, generation is stable and334 owned files format/check. Full102-case/23-fault/14-negative suite plus prior integration/target checks passes; whole strict lint remains failed. Fixture source-relative path repair preserves failure evidence and all assertions. Exact completed/missing public families and SDK provenance: portable-socket-fields.md. Continue Windows scope and Linux/Android native field helpers, then remaining portable modules.

Windows scope-ID increment: four exact accessors implement 28/4-bit overlay semantics. Public #run assertions pass Windows x64/ARM64; production word kernels pass host interpreter/native O2 and strict lint. Full103 positives/23 faults/14 negatives and integration/target checks pass (target/socket-scope-full-regression.log);339 owned files pass formatting/check. Native Windows remains pending; whole strict lint remains failed, including target configuration for the Windows-only fixture. Widening-shift compiler reproducer: tests/portable-stdlib/pending/widened-bitwise.jai expected8000; shifted high byte lost. SDK FIONBIO expected0x8004667e, original actual0x8004007e; assertion retained.

Pool/Linux increment:104-case full regression passes after classifying the Windows unmapping fixture failure as an unavailable platform backend. Only this genuinely Unix-only test joins the existing platform scope list; every host assertion and Linux check remains. Original target failure retained at target/pool-policy-full2.log. Native Windows allocator support is not claimed. Whole strict lint fails at target/pool-socket-whole-lint.log; focused Pool passes target/pool-policy-final-strict.log.

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

Android host tooling increment: exact x64/ARM64 JNI directory names pass host interpreter/native, Linux/Windows checks and focused strict lint. Unsupported custom CPU diagnostics pass both modes.109 positives/26 faults/14 negatives and integration checks pass;363 owned files format/check, whole strict lint still fails. Missing API inventory regenerates identically with253 declaration/overload/nested rows; no functionality credited to those rows. Parent Android/native bindings and excluded modules are untouched.

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

Android OID increment: canonical type/counted equality, exact Sun OID and typed
JKS constants tested across all prefix counts/differences/inactive tails/copy
independence; global writes reject. Native O2 and focused strict lint pass.
Full110 positives/27 checked faults/16 compile negatives and prior integration/
Linux+Windows checks pass (target/android-oid-full.log).376 owned Jai files
format/check; full strict lint remains a failed gate. Review numeric JKS values
preserved, incorrect byte-swap rationale questioned without invented correction.
Exact largely-unimplemented public inventory now248 rows; no signing/DER/device
completion credited. Native platform and compiler gaps remain named separately.

Digest continuation: reviewed Android/Toolchain.sha1/sha256 now return real fixed
20/32-byte digests from independent scalar Jai compression/padding code. All270
native hashlib vectors pass interpreter and host ARM64/translated x64 O0/O2,
including padding boundaries, embedded NUL/unaligned input and million-a.
Focused strict lint and both Linux/Windows CPU body checks pass. Invalid signed
length independently logs then asserts in interpreter/native O2 (both exit-6);
registered as a separate safety fault, not a reference invalid-input guarantee.
Signing/key/APK/ASN.1 decoding/device operations remain missing, not credited.
No credentials, auth, device or native crypto implementation bodies accessed.
Final digest/ISA regression:112 positives,28 expected faults and16 compile
rejections pass in the broad runner, with real SMTP/IPC/runtime configuration
and Linux/Windows source checks (target/sha-machine-full-final.log). The critical
50-execution lifecycle matrix is independently rerun after the compiler rebuild
and passes again (target/lifecycle-final-compiler.log).387 owned Jai files pass
format/check; focused new production/test strict lint passes. Full owned lint
and native platform CI remain separately open.

Resolved time continuation: exact ConvertToApollo no-result #expand now uses
caller-scoped return into an Apollo_Time procedure. Signed full-width scaling,
argument single evaluation and caller defer cleanup pass interpreter/ARM64+x64
native O0/O2 in both own and NEW foundations compositions. Focused strict lint
passes; existing six time/calendar fixtures pass interpreter/native O0/O2 and
configured Windows source checks. The stale ordinary macro value-expression
probe is retained and explicitly classified as superseded for this API, not a
required compatibility oracle or an established compiler gap. No public result
annotation, compiler special case, fake value or peer write.

Registry continuation reaches an exact general compiler blocker, not a stale
contract question: positive pointer constants hit the constant freezer heuristic
and diagnose unknown-size memory. Original module-independent reproducer
pending/opaque-pointer-constant.jai fails host and Windows x64/ARM64 checking
with exit1. General opaque address-bit versus owned-memory provenance support
belongs to compiler; no whitelist/sign-extension/mutable workaround used.
Ten reviewed handles remain INCOMPLETE. Six candidate production/generator/test
files remain durable UNCOMMITTED/excluded, enumerated in portable-opaque-pointer-constants.md.
Three provisional Performance_Report files remain independently excluded.
Known committed functionality is preserved in checkpoints; candidate Registry
checking currently fails and is not claimed green.246 largely unimplemented
public rows remain plus partial/platform/compiler gaps, listed per API in linked
module documents.

System counter continuation: reviewed inline read_cpu_counter and x64 public
M64 module alias implemented in owned Unix backend. x64 calls actual RDTSC;
non-x64 Unix returns native CLOCK_MONOTONIC_RAW.tv_nsec, not generic CPU cycles
or accumulated time.64 real bracketed samples and existing System regressions
pass interpreter/ARM64+x64 native O0/O2. Strict target-aware lint passes both
CPUs on macOS/Linux. SDK calls are outside optional assertions and failures log.
The new fixture retains host/Linux checks and is explicitly unavailable under
this Unix-only facade on Windows; peer Windows backend is not edited or claimed.
Evidence and policy: portable-system-counter.md.
Final System/time broad regression passes114 positives/28 expected faults/16
compile rejections plus actual SMTP/IPC/runtime and Linux/Windows source checks
(target/system-time-final-full.log).390 owned files pass format/check. Registry
candidate failure remains independently documented, not counted as passing
module functionality by that broad test total.

Latest inbox ownership split adopted: Ico_File, Icon, Windows_Resources, Subtitles
and Simple_Package now belong to the new independent data worker. No production
code or pending implementation overlapped those five. Public/private/test
formatting scope excludes them, ledger marks delegated, missing-row generator
removes only the assigned modules. Current retained missing inventory is191
rows, reduced from246 solely by transfer of55 rows, not implementation credit.
Regeneration is byte-stable; current390 owned files still pass formatting/check.
Compiler-dependent Registry/toolchain scope and six uncommitted Registry candidate
files remain ours. No data-worker checkout access or mutation occurred.

ADB host subsystem:15 reviewed public declarations implemented, including live
path/serial/verbose storage, three canonical records/enums and nine command/
query/transfer procedures. Source-built native SDK-protocol fixture passes real
process/argv/output/exit/parser/quoting/allocator-cleanup tests in interpreter and
ARM64+x64 native O0/O2. Strict scoped lint and Linux both-CPU checking pass;
unrelated Windows digests retain their source checks after dependency isolation.
Actual SDK is absent from PATH, no daemon/device/auth commands executed, and
Windows ADB depends on peer Process integration.191 retained missing rows become
176; fine ownership/escaping/serial policies are explicitly recorded as review
questions, not assumed reference behavior. README-linked portable-adb.md contains
exact evidence and remaining higher-level/build/install gaps.
Registry original reproducer is committed at tests/portable-stdlib/pending/opaque-pointer-constant.jai;
NEW compiler raw-pointer handoff is now available and will be rebuilt/validated next.

Registry compiler handoff consumed: local --locked source rebuild repairs the
exact committed opaque-pointer and default-generic-pointer probes. Opaque pointer
probe executes interpreter/ARM64+x64 native O0/O2; Registry all33 declarations
source-check/strictly lint Windows x64+ARM64, with immutable write rejection.
Six retained candidates now become verified checkpoint inputs. Native Windows
API calls remain unexecuted; public zero-extension is preserved despite SDK
sign-extension discrepancy. First new lint staging failed private-source access
and was fixed with byte-identical JAIC_STDLIB paths, no capability relaxation.
Evidence: registry-handles-verified-final.log and opaque-pointer-constant-execution.log.

ASN.1 primitive checkpoint-ready batch:13 more reviewed declarations implemented,
including canonical enums/union tag/type alias and real tag/length/s64/OID/dotted
string plus checked binary integer/block cursor operations.517 INTEGER and183
OID vectors plus shape/overlay/alias/eight integer type/both-endian and seven
malformed-cursor tests pass interpreter/ARM64+x64 native O0/O2. Both Linux/Windows
CPUs source-check; scoped strict lint passes.176 retained rows become163.
Unreviewed ASN1_Value content/value_data, printer/depth, prefix-width and accepted
generic type/invalid-input semantics are precise reviewer questions, not guessed
completion. No crypto/key/device/native SDK verification is inferred.
Broad post-compiler/ADB/Registry/ASN.1 regression passes115 positives with
28 expected faults and16 compile rejections plus prior SMTP/IPC/runtime and
Linux/Windows target checks (adb-registry-asn1-full.log).402 owned files pass
format/check. Native Windows Registry/device SDK remain unverified, no fake
platform results. ASN.1 first-combined OID values beyond64 bits are tested, not
rejected merely because a temporary u64 would overflow.

# Portable stdlib worker deviations

Default plugin-array ownership correction removes a dangling public descriptor
after shutdown by using Basic.array_reset. Actual repeated workspace/plugin builds
verify cleanup, retaining callbacks and error behavior. No caller patch, lifecycle
registry, public layout change or skipped assertion; full lint dependency unchanged.

Memory protocol comparator review scope: no workaround, reduced semantics,
allocation/dereference, disabled assertion or lint exclusion remains. Both opaque
pointer identifiers are compared exactly. Compile-time/interpreter/native O0/O2
and required source/lint/layout gates executed. External visualizer integration
and native other-OS execution are not claimed from this focused completion.

Project_Generator verification limits: required compile-time real executable path
default is unavailable in jailint SandboxHost (_NSGetExecutablePath); strict lint
remains failed, original generic reproducer supplied, no default/tool exception.
Real CLI builds and XML/artifact/mtime/ownership behavior pass. Native VS/MSBuild
opening/debugging is not executed on Mac. Conventional reviewed jai.natvis path
is emitted but resource is absent from this snapshot; no visualization support
claim. Deterministic SHA256-derived instance/filter IDs and independent standard
VC++ Makefile scaffold are design choices, not original output reproduction.
Process-lifetime generated configuration defaults persist as required; reset
only frees project_files. Output writes are sequential with explicit failure,
not transactional (no stronger reviewed guarantee). Initial array_free/reset
and substring-count mistakes caught by genuine assertions and corrected through
reviewed Basic.array_reset/String.slice semantics; no test weakened.

Socket reexports corrected: native variables now use filtered using, preserving
canonical storage and visibility. No live mutable :: workaround remains in the
owned generated facade. Actual SDK C address/mutation comparisons pass; scoped
lint covers the new fixture/bridge, while whole generated binding lint remains
red on general field-array-element type query. Mac resolver/CMSG runtime now pass
with forward-enum fix; candidate source remains retained rather than claimed
fully integrated. Runner selects only assigned CARGO_TARGET_DIR or own fallback;
no peer/external build reuse. Initial dynamic test library naming corrected to
documented stem resolution; no compiler or ABI semantics altered.

Default plugin-generation pass now suppresses parser reporting/global actions;
duplicate deprecated-option/context diagnostics removed through a general private
parser phase parameter. No public API change or test exclusion. Full lint remains
blocked on the documented Check dependency rather than marked green.

APK safety scope: loader/iterator explicitly check sizes, leading/trailing signing
block lengths, signatures and bounds rather than reproduce unsafe unchecked reads.
Malformed files assert; no recoverable success or valid-signature claim. Fixtures
include a deliberately unsigned marker-only block, and is_signed remains marker
semantics. Native Windows/Linux/Android, real device and cryptographic signing/
verification are separate pending work. No lint/assertion exclusions in positive
APK scope; POINTER fixture is a required negative compilation gate. Public ZIP
enum order now matches reviewed declaration order, preserving reflected order.

ZIP writer deflate tradeoff: internal/archive/android-zip-writer.jai emits real
raw DEFLATE stored blocks rather than LZ/Huffman matches. Independent zlib reads
empty/single/multiple-block output correctly, but payloads grow by5 bytes/block.
No claimed compression ratio guarantee exists in the reviewed spec. Proper future
optimization is a general compressor with equivalent round-trip/boundary coverage.
Writer directly serializes reviewed target records on supported little-endian
targets; no big-endian guarantee invented. ZIP64/oversized/unsupported alignment
diagnose, and failure after a builder allocation may leave partial output (no
transactional guarantee in reviewed API). Temporary storage/names must survive
finalization; no reset/reuse promise. Public #align/#no_padding review resolves
the old field-only probe gap. Strict lint and format/--check executed on owned
writer/records/facade/tests. Test corrections and initial invalid-block evidence
are recorded in portable-zip-wire.md; no failed assertion was blessed as success.

Example_Plugin scope review: no missing reviewed entry or test exclusion remains.
The public some_state stores33 plus messages observed after init; this gives a real
count while preserving exact layout and allocation ownership. Diagnostic prose is
independently worded. Public direct-callback fixtures supply typed messages only
to test reporting; separate actual compiler-workspace runs verify real messages,
output and shutdown. No public callback is a fabricated completion/artifact path.

Default build partial dependency: Default_Check.get_plugin is required by the
generic plugin workflow but absent from the reviewed Check inventory and NEW
producer. No fake plugin/body/check success is supplied; default builds and full
strict lint fail explicitly, while real -no_check/custom-plugin runs pass. Binding
configuration is not claimed implemented; get_plugin shape/config needs producer
review. Default_Metaprogram build remains inventory-incomplete. Compiler wrapper
stores but does not forward target CLI/context/diagnostic fields; original target
CLI assertion fails. X64 backend/debugger flags project correctly but compiler
rejects unavailable implementations. Proper fix is reviewed Check factory/config
and general compiler workspace forwarding, not facade/CLI exceptions. Details and
evidence: default-metaprogram-dependency-request.md and portable-default-metaprogram.md.
The generated unreachable disabled-Check branch diagnoses accidental invocation;
it is not a check implementation. Plugin grouping uses ordinary generated static
imports with real module parameters; dynamic names are not runtime-loaded.

Current compiler1929d5a corrects the constant-alias problem below: assignment now
rejects with cannot-assign-to-constant. Old acceptance evidence retained. Build
uses only assigned per-worker T7 output; authoritative reports/sources remain local.

Historical source-built compiler audit limitation:784415f implements live named ::
storage aliasing rejected by refreshed public constant contract. Original pending
constant-alias-immutability.jai is wrongly accepted (-check exit0). No program
execution or library workaround used to manufacture a result. Resolver/enum
diagnostics are separate unaffected paths; wider compiler semantic compatibility
not claimed. Compiler owner must restore immutable bindings and fix type-query
initialization separation, retaining legitimate declaration reexports. Evidence:
target/constant-alias-contract-conflict.log; no producer Rust changes or peer writes.

ZIP wire supported policy: version minor0..9 and low byte<=255; complete correctly
signed EOCD input, writable setter backing; invalids log/assert with no mutation.
Finer reference recovery policy unestablished, documented portable-zip-wire.md.
CRC32 uses portable bit loops (deliberate slower tableless strategy); no CRC64/API
substitution. Unit macros preserve language arithmetic/argument semantics.
Header sizes32/24 versus wire30/22 await reviewed distinction; no #pack/ABI guess,
public default-version guess or writer stub. Native other-OS runtime pending.
Shared staging explicitly copies real owned source dependencies plus NEW foundation
read-only inputs, replacing repeated incomplete lists without fixture API shims.

X.509 extractor supports DER structural key-info location, versions0..2; does not
claim signature/trust validation. PEM/concatenation/trailing/error-recovery finer
policy is not established by reviewed declaration; supported first-object policy
documented portable-x509.md. Production is pure checked ASN.1, no C crypto ABI.
Native OpenSSL used only as independent test oracle, pinned explicit installation
prefix and no user config; ephemeral newly generated keys never written/read from
credentials. Public DER/native expected SPKI data regenerated for each run.
Native Linux/Windows/Android not executed; separate source-only fixture never
counted as behavior. Proper follow-up: fine contract review and platform CI.

ASN.1 diagnostic conventions: labeled human lines, spaced lowercase hex, yellow
Print_Color ANSI-backend banners, standard native-C UTCTime1950..2049 year mapping,
newline on empty constructed context and invocation-wide skipped indentation.
Finer reference punctuation/century/leap policy not established; recorded in
spec questions and portable-asn1.md, not presented as observed reference output.
Native Windows console rendering remains unavailable; explicit supported ANSI
backend selected. Iterative frames avoid host recursion; per-indent/field printf
calls have deliberate overhead for diagnostics, future batching can improve it.
All supported types/overloads have real bodies; malformed input logs/asserts,
frame allocations are released on normal/early return by defer. No fabricated
parse defaults treated as successful output or hidden assertion/lint suppression.

macOS addrinfo candidate excluded from active source while general forward-enum
compiler defect persists. Location: pending/socket-macos-addrinfo.patch, generated
staging target/portable-socket-resolver; gate tools/check_portable_socket_resolver.py.
Observable effect: API remains missing, existing Socket code retains prior behavior.
Evidence: both native C CPU probes pass; Jai resolver/strict lint fail ADDRCONFIG,
minimal reduction fails LATER; activating shape regresses existing cmsg-layout.
Risk: native Jai resolver remains unverified. Proper fix: compiler dependency graph
retaining enum reflection order, then regenerate normally and run full gates.
No source enum/member-order workaround or disabled assertions. Generated docs
ledger manually marks the retained candidate; later normal generation removes
that temporary documentation note. C-only evidence never counted as Jai support.

ADB SDK/startup earlier gap is now implemented. Durable default-allocator cache
retains one current executable path until rediscovery/process exit; allocator
identity saved for proper Basic free on replacement. This prevents temporary reset
from dangling the executable. Concurrent public cache/config mutation is not
guaranteed; callers serialize it. Current cache retention is deliberate process
lifetime, not a hidden per-call leak. Tests compose actual NEW foundation sources
under target/ only; coordinator production integration is still pending.
Existing-conventional-home precedence source implemented, not native exercised
because host SDK directory absent and tests do not modify user home. Windows
Process/System integration and real SDK/server/device verification remain pending.
23 host protocol executions plus exact default-assert distinction prove startup
ordering/failure, not an installed SDK. See portable-adb.md for test corrections.

ADB reviewed policies first correction: temporary capture backing preserves
device/version views until temp reset; array is temporary. Safe lifetime choice
is explicit where reviewer says original backing lifetime ambiguous. Generic
quote/compression/PID/error contracts corrected. SDK discovery/cache/server startup
still missing and must be integrated before full ADB conformance claims.
Test staging deviation exposed by new assertions: malformed executable copied
without execute mode, so older tests accidentally covered launch failure only.
copy2 fixes mode; stronger diagnostics prove native parser executes. Original
failure retained in target/adb-reviewed-policies-first.log; no suppressed failures.

Refreshed ASN.1 correction supersedes earlier signed/high-tag/active-only/alias
assumptions below: single supported identifier, nonnegative1..8-byte INTEGER,
full-record OID equality, dotted trailing period and known-array implemented.
Value TLV/content borrowing and consumed expected mismatch now exact. Safe
malformed diagnostics/cursor policy is explicitly independent where review grants
no recovery contract. Generic readers still little-endian-target implementation;
all configured targets currently little-endian. Original provisional tests/logs
preserved as historical evidence, corrected oracles documented separately.
ADB review also resolved many earlier fine policies; current startup/discovery,
quote/cache/temp-storage/PID implementation requires correction. Those gaps are
not completed by earlier host protocol totals; portable-adb.md records follow-up.

Manifest flag parser: exact reviewed16 names/masks and official SDK | grammar
implemented. Empty input gives no flags; unknown/empty components log+assert and
return zero if assertions continue. Whitespace/invalid recovery fine policy is
not established by inventory; review requested in portable-android-values.md.
Risk: public finer policy may differ and require correction, not silent token
dropping. No newer SDK exports, partial-success fallback or native Android claim.

JAVA_HOME discovery: require successful actual java -version execution before
returning copied bin/executable paths. Environment lookup only reads explicitly
authorized JAVA_HOME; no PATH/default SDK/credential scan. Fine success/storage/
fallback policies need reviewer confirmation (portable-java-discovery.md).
Windows Unicode environment source is implemented using official Kernel32 ABI;
Windows Process integration and real JVM execution are not validated here.
Thirty source-built launcher protocol cases are host process evidence, not Java
or Android compatibility certification. Proper follow-up: real SDK/JVM Windows
CI and reviewed fine policy; no fake JVM/native Android output or hidden bypass.

This is the portable worker's current review record, not full release approval.
The complete per-module completion inventory is in
[the module ledger](../portable-stdlib-ledger.md). Unimplemented entries remain
unfinished work and are never counted as supported functionality.

| Location | Effect and rationale | Evidence / risk | Proper resolution |
| --- | --- | --- | --- |
| `internal/runtime/crash-native` | Newly written C callbacks replace a superseded Jai signal/TLS callback path: native callbacks must outlive interpreter shutdown. The library is pinned for process lifetime. | Both execution modes pass real faults and thread cleanup. A Jai TLS callback previously diagnosed invocation after interpreter completion. One library reference intentionally remains until process exit. Native symbolization remains best effort. | Retain native callbacks or implement an explicit compiler/runtime lifetime mechanism; coordinate crash-handler ownership. |
| `tools/build_portable_runtime.py` | Helper is built beside source, with build-tree macOS install name, to use existing source-relative foreign-library resolution. | Local source/native integration passes; copied deployment alone has not been verified. Missing runtime library causes a real load/link failure. | Coordinator packages and relocates the native runtime and verifies a moved installation. |
| Runtime crash initialization | Replaces existing signal handlers/alternate stack. Public API has no teardown; previous stack is not restored. Windows implementation absent. | Real per-thread stack and fatal-signal tests on macOS; Linux Jai checking only. Concurrent/recursive faults use immediate exit rather than another stack trace. | Review ownership/restoration requirements, implement Windows, execute Linux native tests. |
| Test/formatter integration roots | Copy new independently authored POSIX/Curl/Hash and formatter foundations/compiler dependencies into `target`; owned production tree is not a complete integrated distribution. Meow legacy verification separately stages NEW foundations plus basic-interface/native-path after the baseline's missing Basic.exit and initial missing native-path dependency. | Focused passes prove those staged compositions only; the x64-gated old Meow test actually runs its assertions with explicit target selection. No original implementations or binaries are used. | Coordinator integrates peer-owned sources and runs full corpus/release checks. |
| `Default_Allocator` | Only documented C-runtime fallback works; optimized x64/Switch mode explicitly rejects compilation. x64 target sweep excludes its fallback fixture. | Actual fallback allocation/resize/free passes; no optimized-heap claim. | Implement reviewed optimized heap API; run branch-specific verification. |
| Memory, sort/Xar internals | Portable byte-copy backend and in-place heapsort favor correctness over native-vector/tuned quicksort performance. | Overlap/numeric/sort and stable chunk tests pass; no comparative performance claim. Xar callback header uses equivalent `T.Element_Type` after `array.Element_Type` failed module loading. | Add measured optimized backends; reduce generic-header issue to a general compiler reproducer before compiler changes. |
| Wav_File | Uses explicit widened locals when constructing integers because inline widening in combined bitwise expressions fails. | `pending/widened-bitwise.jai` retains failed assertion; WAV bounded vectors pass. Duplicate-chunk policy unsettled. | General compiler width propagation fix and reviewed duplicate policy. |
| Remap_Context / Thread metadata | Caller-owned cleanup is now supported and the exact lexical macro is implemented. Automatic workspace metadata remains withheld; duplicate field and optional stack-trace policies need review. | Original caller-scope assertions and nested/early-exit macro cases pass interpreter/native; pending workspace-hook retains its compile-time failure. | Resolve compile-time workspace retrieval in compiler ownership and review optional mapping policies. |
| Apollo / System / Print_Color / allocators / Soa / Command_Line / Text_File_Handler / Process / Xar / Mail | Reduced platform coverage or unresolved contract choices are enumerated individually in the linked gaps document. No unresolved choice is claimed as reference conformance. | Local tests show selected supported behavior, not an API oracle. Includes femtosecond assumption, Linux logical CPU fallback, ANSI-only Windows, retained read-only frees, deferred Soa writeback, flat CLI fields, text ownership, subprocess quoting, Xar failure/iterator policy, SMTP STARTTLS/proxy/netrc policy. | Review each unresolved contract; implement remaining native/platform branches and test them. |
| Flat_Pool / Protocol_For_Memory_Visualization / Mail.scramble | Missing oracle details block specific exports; no fabricated constants, comparator or transform added. | Named in ledger/gaps and questions; unrelated implemented functionality has independent tests. | Obtain reviewed contracts then implement and test exact behavior. |
| Zip_File_Directory | `position_in_file` currently records the physical central-record offset, distinct from encoded `chunk_offset`; the spec does not define it. Trailing junk/digital-signature extensions are rejected. | Classic fixtures and malformed cleanup tests establish supported local behavior, not unresolved field/extension conformance. File dependency is currently Unix-only. | Review field and extension contracts; add Windows File integration. |
| Target sweep | OS-dependent cases excluded from unsupported Windows checking; pending reproducers are not included among positive passes. | Runner lists exclusions explicitly. Public/legacy fixture assertions and corpus remain unchanged. | Implement each backend and promote its focused cases after real execution. |
| Atomics | Exact load/store/exchange aliases now execute through updated compiler lowering; no surrogate procedures added. CAS retry loops remain for arithmetic/bitwise updates. Scalar-domain/conversion/ordering contracts need review. | Original intrinsic and direct alias cases pass both modes; prior four-worker contention checks remain. Retry-loop performance is unmeasured. | Review domains/order guarantees and benchmark native fetch/update optimization without changing entity identity. |
| Deep_Copy | Updated reflection enables verified cyclic/shared struct graphs; alignment guards remain. Fixed arrays/Any/unions are rejected; ownership, capacity, scalar-pointer, statistics and overlapping-slice policies need review. | Original graph/reflection assertions pass both modes and are promoted. Private statistics lock adds overhead; Windows timer only target-checked. | Resolve remaining policies, platform timer coverage and richer graph cases without weakening validation. |
| BuildCpp | Unix native-host GCC/Clang-style commands only; Windows/cross-OS discovery, static dependency merging and multi-source OBJ_FILE remain unavailable. Output naming/environment parsing/enumeration policies need review; successful tool streams are forwarded. | Real archive/link/dlopen/object/universal tests; missing tool/invalid C/wrong object tests. Early error reporting bypassed cleanup; replaced with ordinary failure collection and public reporting after cleanup. Original failed-run target dirs answer.build-HTLZeE/answer.build-ujcrhU and failing negative-case dirs were recorded then removed. Current runner requires no leftovers. | Implement reviewed toolchain discovery/unsupported cases; execute Linux/Windows native verification and define naming contracts. |
| BuildCpp test repairs | Local lipo rejects the combined two-architecture verification syntax; two separate invocations test both architectures. Native ar lists its symbol-index member, so stale-member test checks required 0.o and removal of prior 1.o rather than assuming no index. | Actual failing command diagnostics observed; neither architecture nor removed-member assertion is skipped. | Retain equivalent property checks across native tool variants; coordinator reruns on integrated supported hosts. |
| Treemap | Squarified float layout uses zero default borders, east/north coordinates and half-open flush ranges; those details need oracle review. Same-count weight changes require display dirty/force. Traversal remains recursive. | Stable buckets, hierarchy/sort/non-overlap/area/callback/cache/growth checks. Initial float drift was fixed using shared boundaries without changing the assertion. | Review border/range/cache/ordering contracts and depth requirements; add required behavior without changing public layouts. |
| Meow calico / ancillary contracts | Canonical SIMD reg aliases, real calico macros/state and mutable arrays are implemented. Raw Source means trailing region, r1/r3 are residual scratch and Store128 writes 128 pre-fold bytes; unused state bytes are preserved. Dump prints actual decimal lane pairs. These ancillary contracts need review. Portable IR lowering omits tuned prefetch and has no hardware-throughput claim. | 317 pinned own-source-built native C cases match interpreter/native O0/O2, including both state outputs and edited arrays. Scalar probe is correctly rejected; vector probe passes. No original Jai implementation or supplied binary used. | Review ancillary/state/window semantics and benchmark/optimize actual backend without changing aliases or global storage. |
| Shared_Memory_Channel | Unix only; wire alignment/absolute offsets/logical capacity/OS magic/name normalization/empty and paused/reconnect policies need review. Real CAS implements private load/store without changing public aliases. False release can represent partial OS cleanup without retry guarantee. | Local wrap/full/corruption/captured-allocator checks; 2,048 packets per four process pairings; Linux x64/arm64 checks only. Native backing extent is queried, not hardcoded. | Review wire details, implement Windows, verify Linux native and define failed-cleanup recovery requirements. |
| Shared-memory early test artifacts | Two early writer-connection assertion failures left PID-named objects before journaling; names were not captured, and no global sweep/deletion was attempted. | fstat reported 16384 while header said 512. Fixed extent handling; subsequent tests journal/unlink only recorded names. This does not establish cleanup of the historical objects. | Coordinator/owner may resolve historical resources with independently established ownership; retain precise journal cleanup and explicit production release contracts. |
| Autorun argv assembly | Temporary explicit argv workaround removed after the compiler mixed-spread fix. Public API stays exact. | Original mixed-prefix/spread assertions and real workspace child forwarding pass interpreter/native. | Keep the promoted regression; CLI orchestration remains separate unfinished scope. |
| Autorun plugin integration | Real COMPLETE lifecycle verified, but +Autorun is blocked by CLI generation expecting non-oracle Metaprogram_Plugins.build_with_plugin_groups. No convenience export added. Callback parameters/options unresolved; Windows absent. | Pending CLI source fails at missing module; reviewed inventory has only parse_plugin_arguments/init_plugins. Real child errors are logged. | Refactor driver to internal orchestration/canonical lifecycle, finish reviewed loading and Windows/callback contracts. |
| pl_mpeg | Buffer allocator/seek/error policies, even dimensions and alpha preservation need oracle review. Underspecified macros remain unfinished; MPEG-1 demux/Plm and video/audio limitations are recorded below. IDCT uses checked widened intermediates. Qualified Basic imports avoid a retained compiler type-resolution failure without renaming the public Buffer. | Original constructor regression retains the failure; bit/VLC/file, pixel and IDCT cases exercise real operations. Licensed C source is algorithm input only; public tables come from reviewed specifications. Raw pixel pointers cannot prove backing extent. Windows target checking actually failed at the existing File Unix guard; MPEG target cases are excluded from Windows only until platform-io File integration, not counted as Windows support. | Review contracts, fix general import resolution in compiler ownership, complete demux/decoders and execute real fixture decoding before claiming codec completion; integrate new platform File and restore Windows target checks. |
| MPEG video increment | Midstream dimension/rate changes and unsupported picture types/invalid regions fail explicitly. Decoder runs IDCT for DC-only blocks, adding work; zero-initialized reference storage adds creation cost. A temporary byte coverage array and linear pass reject missing/overlapping slice regions per picture. Repeated headers preserve pending frames and update matrices. Fixed/append input stays intact. B-picture prediction has direct coverage, but complete B/nonconstant-AC streams still need fixtures. | Independent constant intra blocks and ten real synthetic red I/P frames decode with rewind; matrix truncation/arrival, allocation failure/retry and lifetime tracking exercise real state. An initial new test expected two pixels for a full-pixel vector of one; unit analysis and diagnostic y=1/cb=1 established the test's error, corrected to x=1 without changing the algorithm. Final short-slice parsing was fixed while retaining completeness assertions. | Add independent B/AC fixtures, support reviewed stream transitions, benchmark coverage/zeroing and introduce verified DC fast path if justified. Complete demux/audio/Plm before claiming full codec support. |
| Vendored C whitespace | Unmodified official pl_mpeg and Meow source retains upstream trailing whitespace, so unrestricted git diff --check reports those lines. | Recorded SHA-256 matches the exact official algorithm inputs; owned Jai sources use real repo format/lint. Standard MIT license template is explicitly identified, not an invented copyright notice. | Preserve provenance; scope whitespace validation to owned authored files or adopt an explicit vendor-only repository policy. |
| MPEG Layer II synthesis | Direct precomputed cosine matrix uses delegated Math and f64 accumulation, trading speed and rounding order for an independently verifiable implementation. Canonical public state/parameters remain exact. CRC-protected audio is now validated; bitrate/sample-rate/mode transitions reject explicitly; richer stereo/joint-stereo content remains unverified. | Real silence plus sixteen mono tone frames decode and rewind. Licensed public C 2,048-basis comparison has max difference 9.44472552e-7. Initial full-tail zero-cross frequency test saw 27 crossings in the padded last frame versus 11/12 in steady frames; the frequency assertion now uses a fixed steady interior while all output sample/count/channel/range checks remain. | Review synthesis precision and transition/error contracts, test richer stereo/joint streams and benchmark a verified factorization. |
| MPEG protected audio metadata | Private CRC state preserves canonical Audio layout, adding one captured-allocator node per parsed decoder and linear CAS-protected registry lookup per header/frame. Frame decode requires parsing a header for the exact object; shallow copies/hand-marked headers reject. Manual/copy lifetime policy needs review. | Protected joint frames/rewind pass in both modes; corrupted CRC fails before samples; tracking reports zero live nodes after destruction. Former unsupported-CRC fault is replaced by real checksum corruption coverage. Per-object use/destruction still requires caller synchronization. | Review manual/copy contract, benchmark metadata lookup and optimize registry ownership without changing ABI or bypassing CRC validation. |

Audio development currently exposes a constant-table element pointer lifetime
failure: returned quantizer pointers read overwritten values in both modes.
The original `pending/constant-table-pointer.jai` checks value and storage identity;
no private mutable table copy or canonical public export change is substituted.
The current independent compiler was rebuilt; the direct indexed-address gap
remains. Explicitly taking `*QUANT_TAB` before indexing uses the canonical static
aggregate, preserving pointer identity without a copy or new export; real tone
decoding then passes. Separate pending qualified window/quantizer stores compile
when they should reject modification; unqualified constant-array stores reject
correctly, as does the exported typed scalar. No library-level mutable surrogate
was introduced. Compiler ownership must fix indexed constant lifetime and
qualified aggregate lvalue validation generally. Richer stereo/rate
transitions remain unfinished scope.

Program-stream support is MPEG-1 only, with checked finite PES extents; MPEG-2 and
unbounded packets reject. Counts use system-header bounds rather than sparse stream
probing. Linear seek policies, whole-audio-frame alignment, stream switching and
lead handling need oracle review; no indexed/intra/PTS strategy is claimed. Enabled
but unconsumed streams can grow buffers. End bounds now follow compaction and are
cleared on writes; non-file total_size/resume policy remains unresolved. Bytewise
input, 240-frame refills, borrowed ownership and loop/callback cases pass, with
zero tracked allocations. Remaining richer B/AC/stereo/macro/copy/compiler gaps are explicit.

Original intra-coded B and horizontal AC fixtures now supplement the red I/P clip;
broader inter-predicted B and coefficient cases remain unverified. The B EOF case
fixed a genuine dropped reference without weakening frame-count assertions.
No-delay mode rejects B input explicitly, and the real I/P clip passes that mode.

Nonzero stereo/dual/joint fixtures now verify channel-specific scalefactors.
Shared sample codes are decoded once and scaled per channel; the temporary replay
path used to establish the bug is removed. Initial full-gain fixture produced
1.00748 ringing while preserving quarter gain; fixture scalefactors were reduced
equally to provide headroom, retaining every range/gain assertion. Official FFmpeg
C was consulted only for algorithm coverage/scaling facts, with provenance in
third_party/pl_mpeg/README.md. No code bodies/binaries were incorporated.

Further contract details and risks: [portable gaps](../portable-stdlib-gaps.md),
[Socket ABI ledger](../socket-native-ledger.json),
[SMTP choices](../portable-mail.md), [crash backend](../portable-crash-handler.md).
This record covers the known deviations in the implemented portable scope;
the remaining module ledger is unfinished scope, not a claim of no deviations.

SIMD increment: allocation-free scalar fallback uses Basic scalar min/max (Math exports its own vector overloads). All-ones comparison masks, MSB extraction, integer wrap and scalar FP semantics are explicit pending-review policies; no ISA speed claim. Reviewed load has no return/output contract; load/gather/scatter/looping/horizontal-add exports remain unfinished rather than invented signatures or fake bodies. See [SIMD](../portable-simd.md) for exact scope and tests.

Executable container increment: supported 32-bit archive indexes borrow content/name/data and allocate result arrays; caller must free matching allocator storage. Special members are metadata, second COFF index determines ordering, BSD tries little endian before big; these detailed API policies need review. Thin/64-bit indexes reject, object/debug/text parsers unfinished, missing Arch_File prevents universal records. Basic allocation failure asserts. Current File import prevents Windows checks, so executable-archive is explicitly excluded there without a Windows claim. SDK headers/official native docs only supplied format facts; no implementation copied. Original test harness initially missed empty metadata-array frees; retaining the zero-live assertion identified and fixed both omissions.

Sound_Player increment: only portable records/arithmetic/storage are implemented. Zero inactive channels in returned add, preserved inactive in-place channels, all-eight-lane multiply, checked bounds and little-endian magic reads are explicit policies pending review. Counting public retired_decoders has no new synchronization guarantee. Reviewed arc arrays and accumulator are real shared mutable entities; no device/playback success is claimed. Cached Ogg/platform shapes and remaining lifecycle/mixer/decoder exports remain unfinished, and the Matrix2 helper is delegated numerics coordination rather than duplicate math. See portable-sound-player.md.

MacOS_Bundler increment: XML scalar writer conditionally delegates new Basic formatters; baseline explicitly returns false for float rather than invoking missing formatting support. NEW-foundation stage passes true finite real formatting; basic-context was newly required and added to plist/Meow staging after a genuine missing-module failure. Native macOS tools provide real icon/bundle operations; other host calls diagnose, no backend success is fabricated. Relative option-like bundle names unverified; copy overwrite/symlinks, selected plist fields and Any policies need review. Partial output directories remain on failure; icon staging cleanup is checked, and failed cleanup returns failure even when output exists. All details and actual verification in portable-macos-bundler.md.

File_Watcher integration: NEW macOS bindings have incorrect FSEventStreamContext field order versus the official SDK (version/copyDescription reversed). Retained assertion regression actually fails; peer untouched. Native lifecycle/queue design will use official C SDK aggregates, keeping callbacks in native code and draining on Jai's poll thread. This is a new native implementation dependency and does not fix the public binding defect. Initial macOS staging required Objective_C. See portable-file-watcher.md; no completed watcher execution claim yet.

File_Watcher execution increment: native SDK-owned context/dispatch queue prevents escaped Jai callbacks and avoids the recorded NEW binding aggregate defect without claiming its repair. Actual events pass both modes; ASan/UBSan and owned C/Jai allocation counts pass. Native dylib host architecture/build-tree install name remains packaging work. Canonical paths, trailing-edge merge, per-root byte cap/rescan, combined flag filtering, borrowed callback paths, by-value teardown/reinit policy and rejected callback teardown/reentry need review. Windows/Linux import rejects. Initial original fixture used .. paths and retained an existing file after failure; real canonical MODIFIED/ATTRIBUTES event diagnostics established the test error, fixed setup/expectations without weakening event assertions. Initial library stem syntax corrected; no loader patch. Source default-generic probe passed, so no compiler gap is alleged.

SIMD revised oracle increment: removed earlier unreviewed all-ones/MSB mask policy. Comparisons now convert true/false to lane values and get_mask tests truth, matching the updated reviewed page. Added all previously withheld operations after the oracle supplied load result/byte offsets/index values/pair order. Scalar reductions now use ordinary scalar additions, removing private forced wrapping. Scatter/full-width horizontal add implement reviewed intended semantics while preserving source defects in documentation; no uninitialized results are emulated. Reversed scalar-left noncommutative semantics remain unspecified, with exact symmetric flags retained.

Runtime/CAPS adoption: exact public size workaround removed in favor of the NEW compiler private getter and actual extent tests. Diagnostic allocator-name spelling (Pool and Runtime default allocator) is independent policy pending review; names are static, no copy/lifetime risk. Current NEW dependency staging proves producer behavior, not production distribution. Child fixture initially reused a root setter and suppressed its output; parent-only configuration fixes the harness, retaining all extent assertions and prior failure logs. No peer/compiler special case. Three provisional Performance_Report files are excluded/uncommitted and not completed support; exact paths and interpreter-only evidence in portable-runtime-configuration.md. Audio/tool code and their tests are excluded from formatting mutation by ownership; previously verified tests still run in the full behavioral suite.

Time/calendar increment: uses reviewed FEMTOSECONDS/Unix epoch constants and NEW POSIX ABI, independently truncates binary float fractions, returns invalid for nonfinite/range failures, floors timespec negatives and rejects non-normalized input. Native calendar rejects leap seconds/invalid normalized dates, chooses libc DST ambiguity with tm_isdst=-1 and derives weekday; these fine policies require review. String formats/ConvertToApollo/seconds_since_init and Windows FILETIME remain absent rather than fake. Android implementation branches have no executed target check: CLI rejects -os android. Host timezone state is libc-global. Canonical Basic facade/load overlaps require coordinator merge with foundations. Four additional allocator CAPS names are static independent diagnostic text; required null instance data no longer asserts or locks instance state. Focused family tests pass actual allocation behavior in interpreter/native O0/O2; full 93-case suite verifies preceding time batch before these final CAPS extensions. See portable-time.md and target/allocator-caps-family.log.

Flat_Pool partial core: no guessed reserve default or replacement public initializer. Tests populate canonical fields from real native reservations; this is mechanism verification, not production init support. Global overwrite option unresolved and absent; reset currently honors explicit argument only. Ownership is allocated-prefix (padding included); initialized STARTUP/actual SHUTDOWN and repeat empty teardown are independent policies. Native page-size query per commitment trades overhead for no additional public/private state. Windows/console absent, Android CLI unsupported. Readonly shared source-file mapping produces actual commit failure and is released; initial #filepath directory mapping assertion fixed to #file with assertions retained. Capacity fault initial runner KeyError fixed by explicit exact expectation, no skipped fault. Canonical record ABI/name and actual native O0/O2 verified. Detailed gaps/risks/long-term requirement: reviewed defaults/flag contract, complete initialization and supported backends, in portable-flat-pool.md. Hash_Table duplicate code existed; new coverage corrects stale inventory, no claim of new algorithm completion or Walk_Table support.

Flat_Pool reviewed update: previous missing-default/global-overwrite statements above are historical and superseded. Exact inferred256MiB/module flag, public page-rounded init, lazy get and global OR local reset now implemented. No guessed default/replacement API or missing-init workaround remains. Public behavior fixtures replace manual reservation setup except the supplementary genuine readonly-mapping commit-failure fixture. Independent safety/lifecycle/ownership policies and platform gaps are enumerated in portable-flat-pool.md; full rerun/strict lint pending at this update.

Flat_Pool initialization rerun complete:95 cases/23 faults both modes plus eight rejections and prior integration/target checks pass; dedicated Flat_Pool native O2 passes;293 owned files pass formatting/check/strict lint. Refreshed reserve/default/overwrite gaps are resolved, not remaining blockers. POSIX-host implementation now exercises all reviewed procedures; Windows/console backend and Android target-validation gaps remain.

Windows_Utf8: native code not executed on this macOS worker; x64/ARM64 target checks verify bodies/ABI only, no fake native success. Host fixture explicitly fails if executed outside Windows; --native runner refuses that host. Zero conversion flags delegate malformed replacement to Kernel32, explicit wide length0 fails, oversized input/result lengths reject before narrowing, active allocator owns results; fine policies need review. Actual production dependency is Windows Kernel32 and NEW bindings, not a mocked backend. Proper next gate is actual Windows interpreter/native O0/O2 using the supplied fixture/runner. Initial fixture used invalid block-form push_allocator; corrected to exact expansion-call syntax, no API shortcut. See portable-windows-utf8.md.

Flat_Pool Windows backend increment: private generic virtual-memory operations preserve POSIX calls and add genuine Windows GetSystemInfo/VirtualAlloc/VirtualFree using NEW ABI bindings and official native C documentation. Windows x64/ARM64 full fixture bodies type-check but do not execute on this host. No fake backend or platform pass; actual Windows allocation/failure verification remains coordinator gate. POSIX readonly-mapping failure branch is platform-specific; all ordinary public init/default/overwrite/lifecycle tests now compile for Windows too. Console and Android validation gaps remain, and superseded default questions are edited to resolved status.

FILETIME increment: production private arithmetic is host-executed through exact source loading, while canonical Windows ABI wrappers only type-check both CPUs. This is genuine arithmetic coverage, not a substitute Windows integration pass. Sub100ns fractions truncate, pre1601/invalid/overflow fail; detailed range/rounding policy needs review. Unsigned native DWORD fields are read separately with explicit widened locals (existing compiler narrowing regression remains); no unaligned u64 pointer alias. General Basic unsigned128 division costs128 bit steps per reverse conversion; performance optimization may follow measured correctness. Public Basic facade/load overlap requires coordinator merge with foundations. Proper remaining gate: actual Windows interpreter/native and policy review; no private helper export. See portable-time.md.

Windows clocks: real typed Kernel32 code is type-checked both CPUs, with host-executed exact production counter arithmetic; native Windows calls/frequency-cache concurrency remain unexecuted. No native pass claimed. Cache uses general committed64-bit CAS and boot-fixed frequency; independent arbitrary counter origin and femtosecond truncation need review. GetSystemTimeAsFileTime provides ordinary system resolution; no precision claim. Reverse scaling uses general128-bit division at128 bit steps, a deliberate correctness-first performance cost. Proper long-term gate: actual Windows interpreter/native threaded clock tests and measured optimization; no source/compiler shortcut. seconds_since_init still withheld pending real initialization-origin integration, not replaced with first-query zero. Details/native-doc provenance in portable-time.md.

Machine_X64 remains withheld: source compiler Op::Cpuid hardcodes all outputs0. Both actual interpreter/native reproducer fail; real SDK C query succeeds. This compiler behavior is not counted as CPU detection or wrapped in fake get_cpu_info. Proper generic IR/interpreter/native lowering required across ownership, described in portable-machine-gaps.md. Native focused probe disables crash-handler installation only to isolate CPU assertion; all assertions remain active and existing crash coverage intact. Rdrand/Rdseed opcode conflation and synthetic timestamp-ID docs are additional unverified audit risks, not supported exports.

Elapsed API resolved: the inbox/refreshed Basic page explicitly requires lazy FIRST CALL, so older statements calling that origin a workaround or withholding it are superseded. Exact public seconds_since_init now captures/publishes a real monotonic origin with existing general CAS, subtracts timestamps before float conversion and shares the same private storage across aliases. First return0 is the capture instant; private synchronization strengthens the source's first-use concurrency guarantee. Eight-thread and compile-time/reset fixtures execute genuine behavior, no fake clock/reset hook; the latter uses actual macOS ABI and diagnoses execution on another host rather than claiming portability. Windows clocks/elapsed code type-check but native execution remains a platform gate.


Parameterized Basic fixes: no type-coercion workaround; private Windows arithmetic returns primitive words and wrappers construct their actual module instance's canonical Apollo_Time. NEW foundation composition is staging only, with explicit current facade/load-list merge and normalized regeneration, not production integration. Initial tool substring/stale-kernel failures fixed and retained. Native actions no longer occur only inside discardable assertions. Operational failure callback is unconditional, guarded by context.handling_assertion_failure; if caller continues, invalid timestamps/negative calendar fields/NaN are explicit failure markers. Failed first origin remains unavailable; this error-continuation policy and context guard require review. No native failure-success result invented. Actual Windows calls still unexecuted.

Rebuilt jailint provenance repair: exact owned library bytes must match staged paths under JAIC_STDLIB; tests keep their real app paths. This preserves private-import rejection rather than bypassing it. Old all-input-original-path invocation failed and is retained. Scalar Hash/shared facade belongs to foundations and is excluded from this worker's lint mutation; portable MD5/Meow remain owned and explicitly restored after peer Hash staging (peer MD5 copy differed only by old formatting). No peer write or blanket diagnostic suppression. Final mapped verification pending at this update.

Current mapped verification: full strict lint still fails, not a completed gate.
Exact categories/evidence and proper remedies are in portable-verification.md:
eager Random Context/Socket type checks, enum forward resolution, compile-time
tools, required fixture flags, intentional negative fixtures and workspace hook.
No categories are silently excluded; no allow-incomplete/suppression was added.
Configured time roots pass strict lint separately. Risk: unlinted failed bodies
may hide further findings; proper long-term fix is general compiler/linter and
configured-fixture support plus a reviewed negative-fixture policy. Real Unicode
literal/facade errors were fixed, not reclassified as tool failures. Meow runner
now executes NEW public-contract/vector fixtures rather than the obsolete inherited
test. Full99 host positives/23 faults pass; that does not establish full portable
API completeness or native Windows correctness.

Machine_X64 CPUID blocker is now resolved by the NEW compiler producer. Portable
CPU/feature/options records and three mask operations plus get_cpu_info execute
real CPUID, with independently built C/native O0/O2 comparisons. Missing
instruction macros/get_machine_options_x86 remain explicit per-API gaps; no
synthetic random/timestamp/fence exports are supplied. Raw feature bits and invalid
index assertion are independent policies awaiting fine oracle review. Actual
execution here uses macOS x64 translation, not physical ARM64 CPU information;
Windows/Linux runtime remains unverified. x64 source-built jailint runs pure
CPUID/mask compile-time assertions and strict lint; its initial full file-reading
fixture aborted in SandboxHost. Native C comparisons retain all assertions and
run separately, not counted as linter file-I/O support. Initial Windows body check
failed at existing File's Unix guard; the native-oracle fixture now imports File
only on its supported Unix hosts and explicitly fails runtime elsewhere. Common
CPU/mask bodies still check Windows, without claiming Windows native coverage.
Generator emits explicit independently grouped values, normalizes/checks source
and regenerates identically. Whole strict lint remains failed; architecture-specific
machine checks use an actual source-built x64 linter, never a fabricated target.

Pool checked-extents batch: positive sizes whose private total cannot fit s64
return null before invoking the signed-size allocator; invalid extents no longer
wrap negative. This is independent allocation-safety policy rather than an
asserted reference boundary result. Interpreter/native O0/O2 and focused strict
lint verify genuine failure preservation and cleanup. No mock production allocator
or fabricated success; the test's supplied allocator deliberately returns null
above its budget to exercise failure. USE_UNMAPPING_ALLOCATOR specialization
remains rejected and unfinished pending exact reviewed retention/ownership
contract. Details/risk/evidence and long-term review need: portable-pool.md.

Windows calendar batch: real Kernel32 UTC/local conversions are implemented and
both CPU bodies/configured Basic instances check, but native Windows execution is
unverified. Dynamic-zone Ex APIs require Windows7/Server2012; older support is
unfinished. Private ABI completions take an opaque dynamic-zone pointer that is
always null, never allocated/dereferenced, plus actual NEW SYSTEMTIME pointers
and s32 BOOL result. No peer edit or guessed struct layout. Local ambiguity follows
native selection; gap detection/invalid-date rejection are independent policies
needing review. Pure Gregorian production validation executes a400-year cycle
on host. Focused host strict lint passes but Windows branches are inactive; the
current linter lacks target selection, so active Windows lint is a genuine gap.
Proper long-term gates are target-aware lint support, actual Windows interpreter/
native error/DST testing and reviewed minimum-version/ambiguity policy. No fake
platform constants, native mocks or assertion weakening. Details/native ABI
sources and supported range: portable-time.md.

Machine options projection: resolved using reviewed Compiler.Build_Options
machine_options:[128]u8 and canonical44-byte Machine_Options_X86 shape. Real
#modify struct constraint, byte-array/extent checks and actual reflected alignment
guard precede the in-place pointer cast. No separate storage, snapshot or guessed
field offset. Pointer lifetime is caller-owned; native/interpreter tests verify
two-way edits and trailing bytes. Actual instruction macros remain absent while
compiler fences/random/processor-ID behavior is unsupported. No new workaround
or blanket diagnostic suppression in this batch.

Windows shared-channel backend: actual named mapping/view/extent/status calls
and retryable teardown are implemented; both CPU lifecycle/packet/IPC fixtures
check but native Windows execution and active Windows lint remain pending.
Private failed-construction cleanup retains ownership in a pending retry queue;
future lifecycle calls retry it, while final unrecoverable resources can remain
until process exit. No background retry guarantee. Existing independent framing,
OS-header magic/name/logical-capacity/reconnect policies still need reference
review; no cross-reference wire interoperability claim. Native VirtualQuery
extent replaces guessed page sizes. Registry validation retains existing lock/
linear lookup cost per packet. Windows tests include a genuine protected-handle
close failure with logged status and retry; not executed or mocked on this host.
IPC driver uses cross-platform pipe handshake and real named-object absence
checks on Windows, preserving real POSIX unlink. Full101 host cases/23 faults/14
negatives and four2048-packet process pairings pass, not Windows runtime success.
Proper remaining gate: actual Windows interpreter/native error/lifetime/concurrency
tests and target-aware strict lint. See portable-windows-channel.md.

Windows Socket: real Winsock source paths implemented and both CPU bodies check;
actual Windows/active Windows strict lint remain pending. Pure production ioctl/
descriptor kernels execute host tests, not a simulated Winsock backend. Explicit
u32 locals accommodate the still-failing general widening-cast/shift compiler
semantics; original FIONBIO failure0x8004007e versus SDK0x8004667e and existing
widened-bitwise reproducer remain. Proper long-term fix is general compiler width
propagation, followed by regression rerun; no Native status/instruction is faked.
The generator's wildcard Windows import caused GUI MSG to capture Socket foreign
flags. Explicit qualified reviewed dependencies fix that source namespace defect,
without changing signatures to raw integers. Native keepalive units/ignored
attempt count are reviewed compatibility, not a workaround. Startup refs remain
caller-balanced with WSACleanup. Negative timing inputs diagnose checked casts;
close failure logs then resets the handle, with retry/resource risk awaiting
review. Missing CMSG/bitfield/shape APIs are explicitly inventoried and not counted
complete. See portable-windows-socket.md for locations, evidence and SDK provenance.

Native TCP fields: no new production workaround. Explicit ABI offsets come only from official Apple C declarations and are measured by independent C record output on host/x64. Values truncate to native bitfield width; whole-record comparisons verify neighboring data preservation. Unsupported big-endian/other-platform behavior is not claimed. Source-generated C includes SDK headers, with no header/library body copied. Initial nested fixture used process-relative file path; #file anchoring repairs test staging only, with original failure retained. Active scoped strict lint passes; whole strict lint remains failed. Public CMSG/other field/shape inventory is still incomplete and separately named. Details/evidence/risks: portable-socket-fields.md.

Windows scope-ID: unsigned bitfield truncation is explicit in internal/net/scope-word.jai, not a compiler workaround. Public pure-record #run tests execute on the host interpreter, without native Windows C layout validation. Native Windows and target-aware strict lint remain required; no fake native functions or platform substitution.

Pool lifecycle correction: the previous address-keyed registry was an unnecessary
and incorrect workaround for an overstated first-use policy. The refreshed
review establishes only the allocator-field guard. The registry, C allocation,
CAS lock and address bookkeeping are removed. Reset/release retain the allocator
and options. Genuine returned leak reports now pass without caller changes.
Original failure evidence is retained in target/lifecycle-leak-red.log.

Linux TCP accessors: little-endian current x64/ARM64 only. Cross-target public
#run execution is real interpreter behavior; Linux native and SDK C ABI tests
remain pending, Android APIs are not completed. Initial test-only narrowing/import
errors are retained, corrected without lowering coverage. No target substitution,
native-call emulation, blanket lint exclusion or ABI-layout relaxation.

Pool test platform classification: pool-unmapping depends on currently Unix-only Unmapping_Allocator. Added that fixture to the existing explicit Unix target-check list after the real Windows availability diagnostic (target/pool-policy-full2.log). Host interpreter/native assertions and Linux checking remain required; no Windows pass or completed Windows unmapping backend is claimed.

Calendar policy adoption: removed this producer's stricter POSIX round-trip
validation and Windows local DST round-trip rejection; refreshed specs delegate
to native normalization/rules. Changed POSIX -1 result to zero, output error to
ERROR log plus zero record, Windows input failures to assertion handling. These
are production compatibility fixes, with old policy-test corrections separately
recorded in portable-time.md. Continuing Windows assertion handlers get explicit
invalid sentinel, not a valid fabricated timestamp. Native Windows pending.

Calendar text uses a128-byte private bounded scratch buffer and real temporary
copy. All public fields fit this bound; decimal padding/English month names are
private calendar responsibilities, not duplicate public formatter APIs. An
initial minimum-length test oracle was wrong for May; replaced with exact twelve
reviewed English outputs, failure logs preserved. ConvertToApollo is NOT exported:
the exact reviewed no-result header cannot currently yield a value in the compiler.
Minimal original language reproducer is pending/expand-return-inference.jai;
do not classify its failed check as completed functionality or silently add an
unreviewed return annotation. Remaining native/target-lint gates are unchanged.

Windows Registry:23 real reviewed bindings implemented, ten pseudo-handles omitted
because reviewed positive casts conflict with official signed-LONG64-bit SDK
extension. No guessed ABI constants or extra public convenience exports.
All seven native call bodies/source constants check both Windows CPUs; actual
interpreter/native Windows execution and active target-aware strict lint pending.
Fixture uses private SDK setup only, a PID-specific volatile HKCU Software test
key, checked native statuses and explicit cleanup; abort can leave this test-only
key until cleanup/reboot. It never reads unrelated registry/credential data.
Initial UTF conversion return-shape error belongs to the fixture and is fixed
using reviewed pointer/success/byte-count, without changing production APIs.
Generated declarations are normalized/idempotent; no copied Jai bodies.

Android TCP accessors share actual tested Linux bodies only after official bionic
public C header verification.22 reviewed Android exports, four Linux-only scales
remain conditional, no invented Android APIs. Actual header C layout probes pass
host ARM64/translated x64; these are NOT Android runtime/SDK execution. Compiler
rejects -os android, so Android body/native validation remains blocked. No target
constant overrides or fake backend. Old Linux-only implementation/facade files
are removed. Public-header SHA/provenance and initial manual include-path staging
error are documented in portable-socket-fields.md; no assertions skipped.

Ancillary helpers: four real functions match native SDK vectors, CMSG_SIZE omitted
pending exact relationship to native SPACE/LEN. CMSG_ALIGN uses native macOS4/
Linux-Android64-bit8 boundary, not a universal guessed pointer-size rule. Negative
sizes and unrepresentable alignment/u32 result diagnose; this is an independent
safety policy for unspecified invalid inputs, not claimed reference wrapping.
Live-record/control-storage preconditions remain with caller. Native Linux/
Android still pending despite Linux pure #run execution. Initial signed/unsigned
test mismatch fixed by explicit boundary conversions; no signature/assertion
change. No copied Jai bodies, fake kernel calls or test/lint suppressions.

Android JNI ABI helper: static immutable native directory strings for the only
reviewed real CPU targets X64/ARM64. Other tags diagnose explicitly; fine
invalid-tag behavior remains independent. This is host tooling functionality,
not evidence of an Android backend/device integration. No ADB/auth/credential
action executed. Parent Android bindings untouched; formatting ownership exception
is scoped only to Android/Toolchain, not a lint suppression. All other toolchain
APIs remain missing, now explicitly listed with other untouched portable modules
in portable-missing-surface.md (253 rows, no functionality credited).

Watcher native ownership fix: close_v2 distinguishes actual error code from
released/retained object, prevents ABI mismatch with stale helpers, and retains
Jai state for retry only when real resources remain. Native operations execute
outside optional assertions. Stopping instances reject polling/additions; callers
must retry deinit after a reported retained failure. No background cleanup
guarantee; never retrying can retain resources until process exit. Registration
metadata is reserved first and recycled on failure, avoiding untracked native
objects and unbounded failed-registration arena growth. Existing event behavior
is retained.

Verification limits: actual SDK EBUSY retention/retry and real SDK EDEADLK seeded
into the private native error channel are C mechanism tests under ASan/UBSan,
not fabricated public FSEvents outcomes. Public event/diagnostic programs execute
host ARM64/translated x64 O0/O2; failed native Jai teardown is not directly forced
through the public surface. Source review covers its retained/released state
branches. Native source helper remains a required build/deployment dependency;
universal slices are real and no binary is committed. Binding Context ABI defect,
Linux/Windows backends and full integrated CI remain separate gaps.

Staging corrections: nonexistent one-argument Basic pointer conversion was an
owned source defect, fixed with native string view without API additions.
Default generic pointer inference is a real compiler gap; original Box reproducer
preserved, explicit specialization used only in new fixture. Test's assumed
pre-callback handling flag was an incorrect oracle; removed that unsupported
assumption while preserving six decisive lifetime/error checks and context
restoration. Verification checks restore the fatal handler so captured assertions
cannot yield false passes; draft never counted green. Normal formatter repair
and failure logs retained. Details: portable-file-watcher.md.

Machine pause: real compiler native instruction wrapped with exact #expand header;
native opcode/C intrinsic/baseline checks pass O0/O2. Interpreter is cooperative
hint emulation and may be a no-op in single-thread execution. This models a hint,
not physical CPU delay or memory ordering; no timing/ordering success is fabricated.
No random/timestamp/fence fallbacks exposed. Native prefetch/fence original probes
compile/run but emit0 requested instructions versus C1 each; dedicated dependency
tool FAILS and those public APIs stay absent. Fine compiler semantics remain owner
work, never hidden by module-specific hacks.

Pause baseline lint initially flagged unused import. Both controlled fixtures now
assert the same reviewed canonical record size, preserving import/control parity
without blanket exclusions. Runner diagnostics now retain captured output on
failure. Original logs retained. Target-aware/all-owned lint remains failed.

Android OID identity: canonical inline twelve-arc record, counted-prefix equality,
exact Sun initializer and immutable typed JKS constants implemented. Invalid
counts diagnose rather than indexing outside storage; fine invalid-input policy
is independent. Qualified constant writes reject and local copies are independent.
No ASN.1/JKS decoding/signing success is claimed. Both JKS constants preserve the
reviewed numeric0xfeedfeed, while the review's byte-swap rationale is flagged as
mathematically wrong (actual byte reversal0xedfeedfe). No guessed alternate
constant, key/device/auth access or fake crypto behavior. Remaining API inventory
drops only these five implemented declarations, from253 to248 rows.

Unix Thread critical correction: all owned essential SDK operations are evaluated
outside optional assertions. Failures log independently; failed Mach destruction
retains the handle, failed join retains worker storage, private teardown flags
permit join/semaphore cleanup retry. Public layouts remain exact. Thread object
address stability is already required by its reviewed lifecycle, unlike Pool.
No relocation tracking was added. Native invalid-task Mach failure retention
executes; invalid pthread handles are never used for artificial failure tests.

Explicit conservative error policies: group worker-creation failure and group
clock failure terminate after diagnostics, including when assertions are disabled.
The void APIs cannot provide a usable partial group or an invented clock. Live
worker storage remains until OS teardown. This is a deliberate fatal policy for
unspecified fault paths, not tested transactional recovery; proper long-term
improvement is recoverable staged group initialization/cleanup with retained
progress. Work-list partial-destruction retry remains an existing gap. Join failure
now prevents freeing the whole worker backing array. Native Linux/Android/Windows
execution, forced join failure and full integrated CI are not counted complete.

Verification staging: only target/ default Basic parameter lists are changed to
test Thread default instances; caller-only false configuration does not disable
Thread. Peer implementations and original audio/foundations fixtures are read-only.
New test checks use enabled assertions and restore fatal handler after captured
errors. Draft locked-mutex EBUSY oracle was invalid POSIX misuse and returned
success; removed in favor of genuine Mach failure, with original evidence retained.
Draft assertion callback type and Darwin cross-target CLI spelling were corrected
without production API changes or weakening valid checks. See portable-thread-lifecycles.md.

Group fatal path initially referenced Basic.exit, absent from this producer's
baseline facade despite existing in NEW foundations. Broad regression caught it;
the private native boundary now binds official libc abort directly. No public
foundation export is added and no failure result is invented. The original broad
failure is target/lifecycle-full.log; corrected broad run passes112 cases,
including the preserved uncommitted digest fixture.

Machine ISA handoff supersedes the earlier missing/fake compiler-instruction
entries for the eight reviewed APIs. Real timestamp/AUX, RNG carry/value, fences
and prefetch bodies now use the general compiler assembler; no C production shim,
wall-clock/random substitution or forced success. Actual CPUID on this translated
x64 environment lacks RDRAND/RDSEED. Opcodes and actual interpreter capability
errors pass; native hardware RNG sample/CF execution is pending capable CI.
Timestamp/AUX exact cross-SDK tests are compiler-owner evidence, not independently
repeated public-wrapper evidence. Native Windows/Linux remains unexecuted.
Public prefetch invalid compile-time hints diagnose explicitly. The forty-four-byte
options projection and all prior canonical feature types remain unchanged.

Digest batch: scalar SHA-1/SHA-256 uses no native acceleration and bounded local
word schedules; this is a deliberate portable performance choice, not a reduced
algorithm. Only compression arithmetic uses #no_aoc for required modulo2^32
additions. Standard mathematical constants are private immutable arrays. Valid
readable strings hash completely; invalid length always logs independently of
optional assertions, then asserts. Disabled/explicitly continuing assertions yield
a zero array after the error; no invalid-input digest success is claimed or
reviewed. No streaming API, signing, key management or native crypto exports
are fabricated. Actual native hashlib vectors are independent test oracles only.
Tests execute unaligned/NUL/padding boundaries and million-a, both native CPUs
O0/O2 and interpreter. Native Linux/Windows/Android execution remains pending.

ConvertToApollo: previous compiler-gap report was based on an ordinary macro
value-expression probe, which does not represent the refreshed caller-return
contract. That mistaken oracle is now explicitly superseded; original source
and failure evidence retained. Exact no-result macro header is preserved.
Private signed product corrections use existing full-width multiply and #no_aoc
only for modular high-word corrections; no fake arithmetic, inferred arrow,
compiler hack or public helper export. Both producer compositions execute
interpreter/ARM64+x64 native O0/O2. Further floating rounding/calendar policy and
native platform gates remain separate; no new workaround introduced.

Registry candidate is NOT completed: six owned files are deliberately left
uncommitted/excluded pending general opaque pointer-constant freezing. Exact
paths and failing evidence are in portable-opaque-pointer-constants.md. Public
reviewed zero-extension is preserved; no sign-extension, mutable global, wrapper
function, fake handle, whitelist or ignored test is substituted. Source checks
and target-aware lint are blocked before native execution. Compiler source cause
is the existing small-or-negative integer-handle heuristic; proper solution tracks
opaque address bits versus memory requiring freezing/relocation. The unchanged
committed23-export implementation remains the last verified checkpoint; the
working candidate33-export source is explicitly unverified. No native Windows
handle acceptance is claimed. Formatting/byte-stable generation alone is not
functional completion.

System raw counter adds no synthetic fallback: x64 RDTSC and Unix
CLOCK_MONOTONIC_RAW.tv_nsec follow reviewed CPU-first selection. The Unix member
wraps each second by contract; not represented as monotonic whole time or physical
CPU cycles. Clock failure logs independently, then optional assertion; a disabled
or explicitly continuing handler receives zero after diagnostics, not a counted
valid sample. Native Linux/Android and peer Windows remain verification/ownership
gaps. The new test is explicitly Unix-only for Windows target scope; every host
assertion and Linux source check remains. Existing System test is unchanged.
No blanket suppression or target constant substitution.

Ownership metadata update only: latest resource/data split moves five modules
and55 missing rows to the data worker.191 current retained missing rows do not
mean those55 APIs were implemented. No code overlap/pending source existed in
those modules; mutation/format scopes exclude their public/private/test names.
Coordinator will merge new producer sources and exact private-root ownership
when supplied; no other checkout was read or written for this update.

ADB first batch: native C CLI fixture models official SDK protocol strictly for
unit/process/argv/error/parser/ownership regression, not an Android SDK binary
or device verification substitute. No actual SDK found on PATH; no device/daemon/
auth accessed. Independent finer policies: context-owned return strings/array;
explicit nonempty serial wins; optional generic escaping only spaces; high-level
remote literal quoting; disable compression wins; malformed parse rejects and
pidof returns the first positive signed32 PID. These remain precise questions
where review is silent. No public convenience exports added. Windows Process
remains unintegrated for ADB; the dependency is local to adb so digests/types
retain Windows use. Original dependency/indexing/lint failures are retained.
No test assertions were weakened, invalid SDK/device results manufactured or
errors mapped to success. Registry candidates remain excluded until compiler
rebuild and original-probe validation.

Registry pointer workaround remains NONE: general compiler fix is rebuilt and
original probes pass; public immutable positive values now validate on both
Windows CPU targets. No whitelist, mutable surrogate, function replacement or
sign extension. Native acceptance is still pending actual Windows. The new
linter correctly rejected producer paths outside JAIC_STDLIB; byte-identical
staged paths fix tool setup without changing capabilities or public imports.
Intentional constant-write negative is compiler-rejection coverage, not a
lint-positive claim. Earlier uncommitted/blocker notes are historical; six
candidates now pass source/strict-lint gates and are checkpoint-ready.

ASN.1 primitive supported-domain limits: definite lengths with at most eight
length octets, u8 tag numbers, s64 INTEGER results and twelve u64 OID arcs.
Indefinite/overflow/excess/truncated values log and assert; explicitly continuing
or disabled assertions return non-success defaults and retain input cursor.
Those invalid defaults are never counted as parsed functionality. Signed INTEGER
redundant sign bytes are trimmed; invalid-recovery/noncanonical policy needs
review. Binary integer reading supports reflected integer widths1/2/4/8 on the
current little-endian compiler targets; broader generic kinds remain unsupported.
OID dotted strings are context-owned. Field meaning/printing/prefix/endian finer
questions remain recorded, so their API bodies are not invented. Standard wire/
Python mathematical vectors are independent test inputs, not reference Jai code.
No C/native crypto dependency, caller relocation tracking, mutable alias surrogate,
blanket lint exclusion or fake parsing success. All negative checks restore fatal
handlers before verification.

ADB app lifecycle: no installed SDK/device is available. Source-built process
protocol fixtures validate argv/status/parser/ownership on host native O0/O2 and
interpreter; they are not device integration. Narrow pidof status1+empty capture
means absent, other failures remain errors; package path responses require
package:/ prefixes. These supported choices need public fine-policy review.
Risk: future SDK output/status changes may require parser adjustment; proper
follow-up is SDK/device CI plus reviewed failure-policy clarification, not treating
arbitrary command errors as successful absence. No fake SDK success or test
exclusions added. See docs/portable-adb.md and target/adb-apps-final.log.
