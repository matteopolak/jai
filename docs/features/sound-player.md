# Sound_Player

The facade loads independently organized units in internal/audio. Public records
retain reviewed names, layouts, defaults and enum values. Repeated imports share
mutable topology, accumulator and queue storage. Private player state and helpers
are rejected by import tests; sound_mutex is private as clarified by review.

Implemented behavior includes PCM interpolation/accumulation, signed 16-bit output,
repeat wrapping, silence outside source bounds, menu pause/resume, listener
transforms, stereo and editable VBAP gain helpers, perceptual gain, rate slew,
stream/entity lifecycle, callbacks outside the mixer lock and decoder retirement.
Reviewed refinements include signed/zero playback rates, always-false accumulation
status, held interpolation at page ends, planar closeness, outside-coverage VBAP
selection, locked/music coefficients and footstep rear exclusions. Filename
metadata is unread; seven channels have no inferred center-rear layout.
Each entity phase synchronizes only its own work. No lock spans caller code.
Rendering releases the stream lock every 256 frames and retains no stream pointer
across that unlock. Native submissions use a separate producer lock. Prefetch
windows are reused; retired decoder objects stay alive until drained and removed
from the published list. Borrowed fill regions block producer overwrite without
holding a lock across caller writes. These are lifetime/ownership improvements,
not a real-time guarantee; synchronous ADPCM and unlimited streams remain costs.
Configure public stream fields before start; direct active-field edits can race
mixing. Exported synchronized setters/stops remain usable between phase calls.
Natural completion remains live until entity retirement observes a silent mixer
frame. DO_NOT_KILL prevents that retirement; explicit stops still release it.
Private output-history intervals record extrema; advance_history_cursor resets
its next interval and partial progress, requiring caller serialization with mixing.
Loading borrows the supplied complete byte string; PCM samples point into it.
load_audio_file retains File's allocation. Callers own asset storage and must keep
it alive until every referring stream is released. release_asset runs per stream.

ADPCM pages use the NEW Adpcm module synchronously. Vorbis pages use the existing
stb_vorbis facade and an opaque pinned official C library built locally. Queued work
is processed by one worker; page publication is synchronized, in-flight memory
survives disposal, and deinit drains issued work. This intentionally completes the
threaded path requested by the assignment: the refined spec documents an original
no-op in that path, which this implementation does not reproduce.

Native macOS output uses an owned C adapter against AudioQueue/CoreAudio. Native
callbacks only publish buffer availability; no Jai callback crosses into an OS
audio thread. The adapter also contains Windows waveOut and Linux ALSA paths;
Windows C cross-compiles for x64 against the official SDK, without execution;
Linux remains source-only. Device negotiation supports logical stereo, 5.1 and
7.1, each accepted by the host AudioQueue API and tested with controlled buffers.
Physical speaker routing and Android remain unverified or dependency-blocked.
Desktop focus/recovery and fresh device discovery are implemented through public
SDKs. Native executables use relocatable static linkage; shared manifest adoption
remains coordinator-owned. See [native integration](audio-native-integration.md)
for six target recipes, actual evidence and physical-event limitations.

Build the local dependencies with `python3 tools/audio_build_native.py`. It builds
only inside this worktree and does not run the shared-root native builder. Build
jaic/jailint from this repository, then build jaifmt with that jaic. Run
`python3 tools/audio_verify.py` for formatter --check, warnings-denied lint,
interpreter, native O0/O2, target and private-visibility checks. The generated
stereo Vorbis fixture is retained under tests/audio/fixtures and its generation
provenance is documented there.
NEW fixture provenance and coordinator review status are in
[audio testing](audio-testing.md); legacy stdlib-specific gates are retired.

Device tests explicitly print whether a real native device opened; unavailable
hardware is never counted as playback success. All submitted device audio is
silent. Native API/device evidence is separate from physical-speaker verification.
See [progress](../status/audio-progress.md), [deviations](../status/audio-deviations.md)
and the [per-export inventory](../status/audio-api-inventory.md) for remaining work.

Official native API inputs: [Apple AudioQueueNewOutput](https://developer.apple.com/documentation/audiotoolbox/audioqueuenewoutput(_:_:_:_:_:_:_:)),
[Microsoft waveOutWrite](https://learn.microsoft.com/en-us/windows/win32/api/mmeapi/nf-mmeapi-waveoutwrite),
and [ALSA PCM documentation](https://www.alsa-project.org/alsa-doc/alsa-lib/group___p_c_m.html).
Factory creation publishes Ogg channel/rate/length metadata together under the
same private lock used by mixing; codec setup runs outside that lock on its own
handle. Independently created streams take dimensions from their own decoder.
The concurrent-factory test is smoke coverage, not a race-detector guarantee.
Panning inversion uses a wider determinant calculation so a small uniform scale
does not incorrectly classify a well-conditioned basis as singular.

