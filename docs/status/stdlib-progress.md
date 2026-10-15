# Portable stdlib progress

Role: independent portable/high-level stdlib worker. No subagents, publication,
reference binaries or prior Jai implementations used. Extensions and corpus preserved.

Latest committed checkpoint: `846781b`, protected MPEG audio checksums. Earlier
checkpoints cover foundations, Unix process/thread/files/system, codecs,
allocators, Soa, Xar, command/text parsing and reviewed protocol schemas; consult
[module ledger](../portable-stdlib-ledger.md) for exact partial/remaining scope.

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
