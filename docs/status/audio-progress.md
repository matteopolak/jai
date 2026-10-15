# Audio worker progress

2026-10-14: Read AGENTS.md, ownership and reviewed Sound_Player/review-status.
The initial snapshot had no Sound_Player facade or implementation, only wav.jai.
A coordinator follow-up authorized NEW peer sources; none have been read/staged.
This implementation is independently authored in this worktree. Compiler, jailint
and actual jaifmt were built locally from NEW repository source.

Checkpoints: a59dae4 records the plan/questions; 7d641f8 implements public shapes,
sample/mixer/panning units and the initial three controlled-buffer tests. Those
three passed interpreter, native O0/O2 and six OS/CPU checks with strict tools.

The later dirty-reviewed behavioral refinement is now an input. It resolves
private sound_mutex, gain curve, borrowed loading storage, entity marking,
repeat reset, Ogg page size and synchronous ADPCM. Earlier provisional choices
were replaced with genuine regressions. Private-name rejection tests pass.

Current source includes stream lifecycle and reentrant stops, release callbacks
outside the mixer lock, synchronized decode/completion queues, drain-before-free
retirement, cached ADPCM/Vorbis, borrowed WAV/Ogg loading, native output and
Windows public ABI declarations. A full expanded verification is in progress;
no final full-matrix claim is made before its successful result.

Actual native device evidence: the host opened its real output device, accepted
silent PCM, started playback and disposed it. The stream fixture passed both
synchronous and asynchronous lifetime paths and measured cursor progress in a
release callback after worker join. Interpreter and native O0/O2 versions of the
initial device/lifetime fixtures passed. No physical-speaker verification, Linux
native, Windows native, Android or physical multichannel evidence exists.

Inventory: [audio-api-inventory.md](audio-api-inventory.md). No agent_message tool
is exposed; commentary and these durable status files carry notifications.

Checkpoint 2 verified: 14 genuine tests pass interpreter and native host O0/O2;
84 common OS/CPU checks plus 2 Windows static ABI checks pass. Two private-API
negative tests reject the names as expected. Actual source-built jaifmt --check
and jailint -D warnings pass (host plus explicit Windows x64/ARM64 lint roots).
Real-device markers are observed in both native optimization levels, always with
silent submitted audio. This is local source integration, not a packaged release.

Checkpoint 3 verification (2026-10-14): the refreshed independent-phase contract
is implemented. The rejected pending bracket assumption and its invalid pause
expectation are classified in deviations. The replacement regression first
failed against the bracketed lock, then passed after removal. A stronger version
also confirms asynchronous streamed-frame progress between phase calls using
only a release-time observation, and passes strict tools, interpreter, native
O0/O2 and six OS/CPU checks.

The expanded suite has 21 positive fixtures: 20 run interpreter and native O0/O2
plus 120 common target checks; the Windows-only fixture has two static ABI checks.
One fixture contains 106 signature/link probes, not behavioral assertions. The
history fixture covers callable/reset advancement without an exported state
accessor; private extrema remain source-reviewed evidence. Two intentional
private-API rejection tests pass. Full source-built jaifmt --check and host plus
Windows x64/ARM64 warnings-denied jailint pass. Extra native logical 6/8-channel
controlled-buffer paths pass all three execution modes. Submitted device data
is silent. Owned C host and Windows x64 cross-builds pass warnings denied; the
opaque official decoder emits one upstream warning without suppression.

All 213 reviewed inventory rows now have a source declaration. This is declaration
coverage, not full behavior completion: exact spatial helper/orientation rules,
seven-channel mapping and interpolation boundary contracts still need review;
Android and focus/background recovery remain unfinished. Linux native and Windows
native execution, Windows ARM64 SDK builds, physical routing and relocated release
packaging remain unverified. No peer dependency was staged or modified. Existing
unmodified stdlib device regression also passed interpreter and native O0/O2;
the OFFLINE/render_offline fixture is explicitly classified as unreviewed.

Checkpoint 4 verification (2026-10-14): entity-lifecycle adds reviewed natural
completion ordering, waiting for a silent mixer frame, DO_NOT_KILL, explicit-stop
override, entity stop across managers, exact Sound_Data pointer identity and
manager filtering. Final expanded version passes actual jaifmt --check,
warnings-denied lint, interpreter, native O0/O2 and six target checks. Its nonzero
sample goes only to a controlled caller buffer; native submissions remain silent.

The full runner also passes with the unchanged tests/stdlib/sound-player-device
regression included. Current runner totals: 23 positive fixtures, 22 interpreter
and native O0/O2 paths, 132 common target checks and 2 Windows-only static ABI
checks; additional logical 6/8-channel paths and both private-name negatives pass.
One fixture is signature/link probes and history is public-call smoke coverage,
not private-extrema conformance. The final strengthened lifecycle fixture was
reverified separately after the full matrix; no implementation change followed.
Remaining provisional implementation paths are now enumerated explicitly in
[deviations](audio-deviations.md), with exact review requests in questions.

Platform checkpoint after 534dc99: native adapter uses bare native-library search
and static linkage. Owned builder writes checked per-target metadata and static/
interpreter-shared artifacts; object headers must match OS/CPU. Host macOS ARM64
real silent SDK pause/resume, fresh discovery and controlled reopen pass. macOS
x64 and Windows x64 owned C/ObjC/decoder/harness builds link, without execution.
Six OS/CPU Jai source-check groups pass separately. Relocated host O0/O2 entity
phase and compressed-stream tests run with real device markers after removing
shared audio/decoder files and clearing loader overrides; imports/rpaths contain
no source dependency. Full audio suite, actual formatter and warnings-denied
lint pass after the platform changes. A subsequent backend shutdown correction
also clears retry state when no native handle remains and receives targeted
lifecycle verification before commit.

Focus policy uses public process/window SDKs on macOS/Windows, preserving CLI
playback. Initial activation-policy-only probing incorrectly paused CLI hosts;
the genuine entity-phase progress regression exposed it and passes after owned
window detection was added. Native errors trigger logged bounded retry/reopen;
macOS default-device/stopped-queue and Linux PCM suspend/disconnect states are
polled. Device enumeration refreshes without invalidating old snapshots.
Physical GUI focus/hotplug/sleep events remain untested; Linux/Windows runtime,
Windows ARM64 SDK build and Android compiler/backend remain dependencies. See
[the self-contained integration plan](../features/audio-native-integration.md).
The refreshed spatial/cursor review is now available and is the next scope.

Reviewed-contract checkpoint after 92c24a9: implemented refreshed spatial routing,
locked/music coefficients, planar closeness, greatest-minimum VBAP selection with
positive outside-coverage contribution, footstep rear exclusions and listener/
SPATIALIZED gating. Buffer success flags now true/true with repeat truncation;
accumulate_stream always returns false, supports signed/zero rates, holds initial
decoder waits and otherwise advances through missing-page silence. Circular
rear-to-front distance and Linux false async-hook semantics are corrected; main
updates now follow the platform hook even with an audio thread. Filename metadata
is intentionally unread. Seven-channel loading preserves directions without an
invented center-rear layout. Android hooks are private; only its compiler/backend
remain dependencies, not facade declaration gaps.

The new reviewed-edges regression first failed against previous bounds behavior
and passes after the source changes. Earlier provisional PCM/silence completion
booleans, hard-panning/mono mapping and locked-gain expectations were explicitly
reclassified. Clipping coverage is preserved with three streams at the reviewed
0.5 stereo split. Full expanded suite passes strict tools, interpreter/native
O0/O2, 138 common target checks plus 2 Windows ABI checks; extra controlled 6/8
paths include music and near-footstep assertions. Final filename-only and seven-
channel refinements also receive targeted strict/native/target verification.
Numeric choices absent from the prose are stated narrowly in questions and are
not treated as a requirement to seek original private behavior.

2026-10-15 performance/lifetime checkpoint after 2df2134: stream rendering now
locks only 256 output frames at a time, with no stream pointer crossing unlock.
Native poll/reservation/copy/commit use a separate producer mutex; exported lock
helpers remain private. Decoder windows reuse three forward pages plus reverse
look-behind/repeat-start coverage instead of marking/evicting every chunk. Missing
pages silence the remainder of an accumulation call without repeated queue-lock
polling. Synchronous ADPCM work and unlimited stream count still prevent any
real-time or worst-case latency claim.

Independent safety fixes: concurrent elapsed-time state is locked; decoder
resources drain outside private locks while their object remains alive/published,
then the retired pointer is removed before object free. Borrowed fill regions
block producer refills via ownership state, with no lock spanning caller work.
The region-lifetime regression first failed on the producer's buffer assertion and
passes after repair. Real queued-byte counts and zero rate for absent/lost devices
replace private-state sentinels. Loss during a borrowed region defers SDK closure
until release, never pretending its data was committed. Native error/restoration
notices are retained and emitted outside both locks. ALSA retry loops are bounded,
prepared recovery restarts explicitly, and negotiated rate is queried from SDK
parameters; these Linux branches remain source-only until coordinator CI.

Final verification after native builds completed: actual source-built jaifmt
--check, warnings-denied host/Windows lint, 24 interpreter/native O0/O2 fixture
paths, 144 common desktop source checks, 2 Windows ABI checks and 3 private-name
negative fixtures pass. The 25 positive fixtures include 106 signature/link probes
and public-only history smoke coverage, not exhaustive behavior. Strict device
and multichannel flags require actual opens; logical 6/8 streams opened in all
three modes. Coordinated render/stop, retired-resource callback and borrowed-region
safety assertions pass. Fresh moved-package O0/O2 entity-phase/Vorbis tests pass
without audio/decoder shared files or loader overrides; six separate release
source-check groups pass. Owned C/ObjC host and Windows x64 cross builds/harness
links pass warnings denied, with actual silent SDK runtime on host only. Owned
object headers validate macOS ARM64/x64 and Windows x64 architectures.

The arbitrary 4 MiB concurrency test exceeded the interpreter's 60-second command
budget; 256 KiB retains page-transition coordination and all lifetime/full-buffer
assertions. Earlier overlapping rebuild verification is not final evidence.
The latest coordinator instruction removes legacy stdlib gates: audio now uses
only NEW tests with tests/audio/manifest.json provenance and migration.json.
Independent dirty review is requested, not claimed complete. See audio-testing.md.
Coordinator native packaging/CI, physical events, Windows ARM64 SDK and Android
compiler/backend remain pending. No peer/manifest changes or Extensions edits.

Cross-platform checkpoint after 11bc663: tools/audio_cross_link.py now emits
self-contained packages for five NEW fixtures (phase, compressed decode, borrowed
regions, controlled routing and signatures) in O0/O2. macOS x64 and Windows x64
executables link successfully and their Mach-O/PE OS/CPU headers are checked.
Windows remains unexecuted. macOS x64 executes through installed Rosetta on this
ARM64 host: all ten fixture binaries plus four logical 6/8 O0/O2 variants pass.
This is translated runtime evidence, not physical x64 hardware. A standalone
package runner also exercises the matching ARM64 package without compiler/stdlib
source or loader overrides. Package hashes, assets, licenses and run.py are staged
inside this worktree for normal coordinator native CI.

Windows ARM64 adapter, SDK harness and opaque decoder objects compile with Clang's
real ARM64 target and common public MinGW headers, with OS/CPU checked. No ARM64
CRT/library link or runtime is claimed. Clang exposed a genuine DLL-export
attribute mismatch between declarations and definitions; producer exports are
now consistently declared, with static consumers unmarked and no warnings
suppressed. Host and Windows x64 native rebuilds pass, and the host silent SDK
harness and full strict Jai suite pass after this correction. Native init cleanup
failure is fatal rather than abandoning callback state; Android/other unsupported
C targets are rejected explicitly instead of entering ALSA. Failure-path physical
injection is not claimed.

Invocation corrections are separate from production fixes: macOS cross-CPU
builds require an explicit target triple; MinGW target archives use the documented
JAIC_CROSS_LIBS rather than host native search variables. These failed attempts
were corrected without changing compiler source or introducing a linker shim.
Linux SDK/native execution, Windows native execution/ARM64 CRT, Android target
and independent test review remain pending; the whole audio scope is not complete.
# Integrated assertion/error-path audit — active follow-up

Validated coordinator feedback against current NEW source and the refreshed
reviewed spec. Nonsequential Vorbis comparisons failed with optional assertions
disabled before the owned fix. Moved essential open/seek/wait/join operations
outside assertions, made decode nonprogress fatal, and retained failed output
ownership through shutdown/recovery retries. Logger dispatch now respects nested
producer calls and runs outside the outer private lock.

Host real-device silent SDK harness and controlled SDK-close error/retry (NDEBUG)
passed after rebuilding owned C. Audio-only assertion-disabled interpreter/native
O0/O2 passed, and real-device injected close failure passed those three modes,
including a second-thread logger probe. Full suite and cross-target checks are
being refreshed. Thread-wide disabled assertions are a separate genuine NEW
dependency defect; peer sources were not changed. These checks do not establish
OS-generated failure, physical focus/hotplug, or whole-scope completion.

Refreshed verification finished: 25 common NEW fixtures passed interpreter/native
O0/O2 and 150 desktop source checks, with two additional Windows ABI source checks
and three private-name rejections. Host formatter/lint and logical 6/8-channel
real SDK streams passed. Both disabled-audio-assert runners passed their three
execution modes and six source targets. ARM64 relocation plus all six source
groups passed; macOS x64/Windows x64 SDK libraries and the NDEBUG fault-injection
C harness linked without claiming Windows runtime. Minimal Thread handoff now
reproduces SUCCESS enabled versus ERROR disabled at semaphore init/signal/wait,
exit 1, with original global-configuration failure preserved in dependency docs.

Continued platform audit after 0502633: added actual ALSA map discovery, rejection
of unknown multichannel maps, validated byte permutation and a self-contained
real-null-sink configuration with explicit 2/6/8 maps. Corrected macOS 8-channel
rear/extension SDK descriptions to match explicit public role names and Windows
mask ordering. Controlled nonzero byte routing is local-memory only; no loud
device output. Linux-specific addition remains source-only pending real SDK CI.
Fresh checks: host SDK silent lifecycle/NDEBUG cleanup and controlled routing
passed; all 25 common Jai fixtures and logical 6/8 SDK opens passed again in
interpreter/native O0/O2. macOS x64 and Windows x64 SDK artifacts/harnesses linked;
Windows ARM64 output/routing/cleanup/decoder objects compiled with real target
headers. Linux remains uncompiled here; no Linux/Windows runtime is claimed.

Continued reviewed behavior after f37f97d: a NEW small diagonal-matrix regression
failed at the previous singular threshold, then passed after widening determinant
arithmetic and removing the absolute cutoff. Shared Ogg metadata writes now use
the mixer lock, while codec setup remains outside it; stream setup snapshots
shared metadata and uses decoder-owned dimensions. A concurrent-factory smoke
test validates 32 independent creations during silent playback, plus cleanup.
The smoke baseline passed before the change; source audit identified the race,
and no sanitizer evidence is claimed. Full verification is being refreshed.

The f37f97d SDK libraries also passed fresh actual O0/O2 cross links for macOS
x64 and Windows x64; macOS x64 then passed all 14 translated runtime cases through
installed Rosetta. These records are translation on ARM64, not physical x64 native
hardware. Windows binaries were linked/target-verified only, never executed here.

Fresh full owned verification passed after the spatial/factory changes and the
ADPCM page-cost refinement: 26 common fixtures, interpreter/native O0/O2, 156
desktop source checks, two Windows ABI checks, three private-name rejections,
formatter --check and warnings-denied lint. ADPCM now validates once at factory
creation and checks local page bounds/progress thereafter; strengthened tests
detect block offsets and eight-channel interleaving. Whole-file header scans are
removed from each page, but no realtime or benchmark improvement is claimed.
Disabled-audio-assert execution and injected close ownership were refreshed;
ARM64 relocated packages passed. Native package cross-linking is being expanded
to all current common fixtures, with per-binary execution records kept separate.

Self-contained full native packages now verified: all 26 common fixtures linked
at O0/O2 for macOS ARM64, macOS x64 and Windows x64 (52 binaries per platform).
The ARM64 standalone package executed all 52 plus four logical multichannel cases
with loader overrides removed and no compiler/stdlib runtime dependency. The
x64 Mac package passed the same 56 executions under installed Rosetta, explicitly
translated rather than physical x64 evidence. Windows x64 remains link-only;
Linux and Windows ARM64 full SDK/runtime remain coordinator dependencies. The
source-only Windows ABI fixture and assertion/fault-injection variants retain
their distinct evidence labels. No whole-audio completion is claimed.

Continued after 4bba9c1: added odd-aligned WAV identity/interpolation coverage and
explicit byte sampling. Baseline alignment smoke passed; hardening removes a
pointer-alignment assumption. The first draft failed valid clipping/mixing tests
because its shift occurred at byte width. Separate widened operands fixed that
genuine implementation regression; no oracle was weakened or compiler defect
invented. Extended real-device fault injection reproduced backend_init incorrectly
reporting initialized for a known-lost retained handle after start/close errors;
the status now reports unavailable while ownership is retained. Fault-injection
interpreter/native O0/O2 and six source checks pass; full verification is active.
Fresh final-source verification passed: all 26 common fixtures in interpreter/
native O0/O2 and six source targets, strict owned formatting/lint, private export
rejections, actual logical 6/8 SDK streams, disabled-audio-assert modes, extended
injected-failure modes and relocated ARM64 packages. Full 52-binary packages were
rebuilt for both Mac CPUs and Windows x64; 56 exact-host ARM64 and 56 translated
x64 Mac executions passed again. Windows remains link-only, not native runtime.

Windows ABI follow-up: actual public SDK C headers passed format/buffer size and
offset assertions plus COM-prefix method slots on x64 and ARM64. The Windows Jai
ABI case now cross-links O0/O2 in the self-contained package (54 Windows binaries
instead of 52). The reviewed eleven-slot IDirectSound8 prefix is preserved;
the test does not fabricate full SDK-interface equivalence. ARM64 is still SDK
object-only; Windows x64 is link-only. No Windows runtime is claimed.

