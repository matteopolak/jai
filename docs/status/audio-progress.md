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
