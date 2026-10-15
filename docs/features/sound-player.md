# Sound_Player

The public facade loads audio-owned units under internal/audio. Reviewed records
retain exact field order, defaults and enum values; mutable topology and the
accumulator each have one storage location. There is no OFFLINE module parameter.

Current genuine tests exercise sample arithmetic, interpolation/bounds, repeat
overshoot, silence, matrix inversion, stereo constant-power gains, listener turns,
source channel routing and live mutable topology. The runner is
`python3 tools/audio_verify.py`, using only local source-built tools.

Independent numerical policy pending review: PCM is signed 16-bit normalized by
32768; final-page interpolation clamps to its last sample; repeat intervals are
half-open, retain fractional overshoot and use source-frame cursors. Perceptual
volume currently squares nonnegative input; gain changes linearly over 480 output
frames. Stereo uses +X forward/+Y left/+Z up and inverse listener quaternion.
Speaker gains are power normalized and recomputed from current public vectors
and arc pairs. These policies are not established reference compatibility.

Playback/lifetime/cache/decoder/native backend work remains in progress. Controlled
buffer results do not establish audible playback or physical device correctness.
