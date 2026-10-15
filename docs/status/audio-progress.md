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
