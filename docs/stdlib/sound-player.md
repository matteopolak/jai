# Sound_Player

## What it is

`stdlib/Sound_Player` plays sounds: it loads 16-bit PCM WAV, IMA ADPCM WAV and Ogg Vorbis data, mixes any number of playing streams with per-category levels and listener-relative panning, and feeds the result to the platform's default output (ALSA on Linux, Core Audio on macOS, DirectSound on Windows, AAudio on Android). With `OFFLINE = true` there is no device; the program pulls the mix itself.

The public API matches the official module: `sound_player_init`/`sound_player_shutdown`, `load_audio_file`/`load_audio_data`, `make_stream`, `start_playing`, `set_repeating`, `stop_*`, `find`, `pre_entity_update`/`post_entity_update`, `update`, `update_listener`, `set_master_volume`, `get_devices`, plus the `Sound_Stream`, `Sound_Data` and `Sound_Player_Config` structs.

## How it works

| File | Role |
| --- | --- |
| `module.jai` | Public types and procedures, the `player` state, stream lifetime (`release_voice`, `give_back`). |
| `load.jai` | `Sound_Data`; parses WAV through `Wav_File` and probes Ogg through `stb_vorbis`; default channel directions per layout. |
| `spatial.jai` | Listener frame, distance falloff, `aim_gains` (target gain from every source channel to every output channel). |
| `block_cache.jai` | Per-stream cache of decoded blocks for compressed sounds, and the decode queue. |
| `mixer.jai` | `mix_into` (renders the live streams into interleaved `s16`), `top_up_output`, the worker thread. |
| `os/*.jai` | Device layer: `output_open/start/close`, `output_frames_queued`, `output_write`, `output_devices`. |

- **Device layer.** Pull-style: `top_up_output` asks how many frames the device has queued and calls `output_write(missing)`; the backend gets memory to fill (a DirectSound lock, a staging buffer for ALSA/AAudio, ring-buffer spans on Core Audio) and calls `mix_into` on it. Core Audio consumes from its own real-time thread, so it reads a lock-free single-producer/single-consumer ring (`produced`/`consumed` counters).
- **Threading.** With `update_from_a_thread` (default) one worker thread loops: top up the device, decode one queued block, otherwise nap 2 ms on a semaphore. Without it, `update()` tops up the device and blocks are decoded on the spot when requested. `player.lock` guards the live stream list, stream fields while mixing, block lists and the decode queue; `mix_into` takes it per 512-frame chunk.
- **Compressed sounds.** `make_stream` opens a `Block_Cache` (Vorbis: 8192-frame blocks; ADPCM: 4 packets). Each update marks blocks covering 0.4 s past the cursor (and past the loop start when a repeat is near), requests missing ones and frees the rest. A block's `pcm` is written only before `ready` is set and read only after, so decoding runs unlocked. A stream stopped while its blocks are still queued is parked on its cache and freed by the worker once the last block lands (`count_retired_decoders` reports how many are waiting).
- **Mixing.** Linear interpolation between source frames at `current_rate`, which glides toward `desired_rate` (`data rate * rate_scale / output rate`). Gains glide toward their targets over 10 ms; a new stream starts at its target. A stream whose next frame is not decoded yet stays silent without advancing. Repeats wrap between `repeat_start_position` and `repeat_end_position` with optional `silence_before_repeat` (the cursor is negative during that pause).
- **Panning.** Perceived loudness is `master * user * universe * data.volume_scale * category`, times a linear falloff between `inner_radius` and `outer_radius` for `SPATIALIZED` streams, mapped to amplitude by `perceptual_to_linear`. Non-positional (and `MUSIC`) streams route each channel to its speaker, or pan by the channel's nominal direction when the output lacks that speaker. Positional streams pan by azimuth around the listener: constant-power balance on stereo (narrowing within 4 units of the listener), constant-power crossfade between neighbouring speakers on surround outputs.

```jai
#import "Sound_Player";
data := load_audio_file("click.wav");
sound_player_init(.{});
stream := make_stream(*data);
start_playing(stream);
// each frame: update();
```

## How to change it

- New platform: add `os/<name>.jai` with the six `output_*` procedures and load it in `module.jai`. Never block in `output_write`; write only what the device can take.
- Mixer-side per-stream state belongs in `Voice` (`module.jai`), not in `Sound_Stream`'s public fields.
- New codec: add a `Block_Codec` value, an `open_*_cache` constructor and a decode routine in `block_cache.jai`, and a branch in `make_stream`.
- Gotcha: code in the Core Audio render callback has no context; only `compare_and_swap`/`atomic_read` and plain loops are allowed there.
- `jaic run` plays to the real device too: Core Audio's render thread calling `pull_samples` runs as an adopted thread of the interpreter's scheduler (see [threads under `jaic run`](../compiler/interpreter-threads.md#callbacks-on-threads-c-started)); it gets the interpreter at once while the program is in a C call or asleep, and otherwise within a preemption slice, so a program that busy-waits in Jai code can underrun the device there. `OFFLINE` works in both.
- Tests: `stdlib/Sound_Player/tests/offline-mix.jai` (levels, panning, looping, lifetime, ADPCM inline and on the worker). Compile-check the device paths with `jaic check <program> -os linux|windows|macos`.

## Configuration

- Module parameters: `MAX_SOUND_CATEGORIES` (64), `VERBOSE` (logs unsupported files), `OFFLINE` (no device; `render_offline(out: [] s16)` mixes the next frames), `OFFLINE_CHANNELS` (2).
- `Sound_Player_Config`: `update_from_a_thread`, `seconds_to_fill_ahead` (device lead, default 40 ms), `keep_sounds_alive_by_default`, `audible_when_window_is_not_in_focus` (DirectSound), `set_async_thread_priority`, `release_asset`.
- Output formats are fixed per backend: ALSA 48 kHz, Core Audio and DirectSound 44.1 kHz, AAudio 48 kHz requested; always 2 channels of `s16`.

## Dependencies

`Basic`, `Math`, `Thread`, `Atomics`, `File`, `Wav_File`, `Adpcm`, `stb_vorbis` (built by `tools/build_native_libs.py`), and per platform `libasound`, `AudioToolbox`/`CoreAudio` plus `macos`, `dsound` plus `Windows`, or `Android/AAudio` plus `Android/Jni`.
