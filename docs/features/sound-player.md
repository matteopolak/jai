# Sound_Player

The facade loads independently organized units in internal/audio. Public records
retain reviewed names, layouts, defaults and enum values. Repeated imports share
mutable topology, accumulator and queue storage. Private player state and helpers
are rejected by import tests; sound_mutex is private as clarified by review.

Implemented behavior includes PCM interpolation/accumulation, signed 16-bit output,
repeat wrapping, silence outside source bounds, menu pause/resume, listener
transforms, stereo and editable VBAP gain helpers, perceptual gain, rate slew,
stream/entity lifecycle, callbacks outside the mixer lock and decoder retirement.
Each entity phase synchronizes only its own work. No lock spans caller code.
Configure public stream fields before start; direct active-field edits can race
mixing. Exported synchronized setters/stops remain usable between phase calls.
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
Physical speaker routing, Android and focus/background recovery remain unfinished.
Source-relative native packaging remains a coordinator dependency.

Build the local dependencies with `python3 tools/audio_build_native.py`. It builds
only inside this worktree and does not run the shared-root native builder. Build
jaic/jailint from this repository, then build jaifmt with that jaic. Run
`python3 tools/audio_verify.py` for formatter --check, warnings-denied lint,
interpreter, native O0/O2, target and private-visibility checks. The generated
stereo Vorbis fixture is retained under tests/audio/fixtures and its generation
provenance is documented there.

Device tests explicitly print whether a real native device opened; unavailable
hardware is never counted as playback success. All submitted device audio is
silent. Native API/device evidence is separate from physical-speaker verification.
See [progress](../status/audio-progress.md), [deviations](../status/audio-deviations.md)
and the [per-export inventory](../status/audio-api-inventory.md) for remaining work.

Official native API inputs: [Apple AudioQueueNewOutput](https://developer.apple.com/documentation/audiotoolbox/audioqueuenewoutput(_:_:_:_:_:_:_:)),
[Microsoft waveOutWrite](https://learn.microsoft.com/en-us/windows/win32/api/mmeapi/nf-mmeapi-waveoutwrite),
and [ALSA PCM documentation](https://www.alsa-project.org/alsa-doc/alsa-lib/group___p_c_m.html).
