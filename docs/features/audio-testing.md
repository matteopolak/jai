# Sound_Player testing and provenance

For provider diagnostics, run
`PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests/audio -p test_provider_receipts.py`.
These NEW unit tests validate receipt preservation and strict failure/unavailable
classification; they are not native SDK evidence. The actual SDK helper preserves
each process's stdout/stderr in audio-runtime.json, audio-routing-runtime.json and
audio-close-runtime.json. CI must surface those receipts even on failure. The
real harness emits acquisition events before checks so an opened device followed
by a failed proof cannot be confused with either unavailability or a native pass.
See [Linux provider setup and pending rerun](../status/audio-ci-provider-request.md).

All required audio fixtures live under tests/audio and are independently authored
from the reviewed Sound_Player spec and official C/OS SDK contracts. The
[manifest](../../tests/audio/manifest.json) records each fixture's provenance,
execution modes and hardware preconditions. The verifier requires the manifest
to match discovered positive and negative Jai files. Signature probes are labeled
separately from behavioral assertions; history exposes no private state accessor
and receives public-call smoke coverage only.

Independent review is requested through the coordinator. Producer-authored passing
tests are not claimed to be independently reviewed or exhaustive. The dirty
reviewer can audit the manifest and public behavior assertions without reading
clean implementation bodies. Missing per-public-name direct references remain
visible in [the API inventory](../status/audio-api-inventory.md).

Build own jaic/jailint and actual jaifmt from NEW repository source. Then:

```sh
python3 tools/audio_build_native.py --test-runtime --require-device
python3 tools/audio_verify.py --require-device --require-multichannel
python3 tools/audio_verify_release.py --require-device --check-targets
```

The native build must finish before verification starts. The first command builds
owned C/ObjC with warnings denied and compiles the existing pinned opaque official
C decoder (its upstream warning is reported). The second runs actual jaifmt
--check, warnings-denied jailint, interpreter/native host O0/O2, six desktop source
targets and intentional private-name rejections. The third proves host relocation
without shared audio/decoder libraries, and separately checks all six desktop
Jai targets. Per-target SDK commands and dependencies are in
[native integration](audio-native-integration.md).

Normal headless Linux CI should install its public ALSA development/runtime
packages. Self-contained O0/O2 cross packages can instead be staged on matching
CI hosts using audio_cross_link.py and their run.py, without compiler/stdlib
source at runtime. Rosetta execution is recorded separately by
audio_run_translated.py; it is not physical x64 evidence. Windows ARM64 object
checks use audio_compile_objects.py and do not imply a CRT/library link.

Normal headless Linux CI should install its public ALSA development/runtime
packages and set JAI_AUDIO_ALSA_DEVICE=null. Native tests use the real ALSA null
PCM. Windows requires a real/virtual endpoint for device evidence. SDK format
availability can differ by device: omit --require-multichannel when 6/8-channel
logical streams are unavailable, retaining the explicit opened/unavailable counts.
Omitting --require-device permits explicit unavailable-device outcomes; those are
never playback evidence. Fixture assertions are unchanged when a native device
opens. All actual device submissions are zero PCM. Nonzero panning/clipping and
channel samples stay in controlled buffers. Physical speakers, hotplug, GUI focus
and sleep/wake are separately unverified.

The latest coordinator instruction retires legacy replaced-stdlib gates.
tests/stdlib/sound-player-device.jai and sound-player-offline-api.jai are no longer
audio gates or inventory evidence. The former had valid observed public behavior,
now covered independently by NEW device/loading/streams fixtures. The latter
requires unreviewed OFFLINE/render_offline extensions. Neither is restored as a
compatibility gate, and their physical retirement is left to the integration
owner's coherent migration. Extensions tests are not classified as obsolete.

To add a fixture, derive its assertions from a named spec section or official SDK
contract, add its provenance/modes/hardware condition to manifest.json, format
with actual jaifmt, then run the appropriate verifier. For a failure, first record
the exact expected value and compare it to the current reviewed contract. Classify
production defects, incorrect/obsolete oracles, unavailable SDK/hardware and
unspecified behavior separately. Preserve valid regression assertions. The
4 MiB concurrency fixture exceeded the interpreter's 60-second harness budget;
its 256 KiB replacement retains the coordinated page-transition/stop barrier and
full-buffer silence/lifetime assertions without claiming a timing deadline.

Coordinator review request: independently audit all current manifest cases and
source-only Windows ABI coverage, particularly signed/zero rates, page-end holds,
missing-data silence, outside-coverage VBAP selection, locked/music coefficients,
borrowed regions and callbacks outside both private locks. Review numeric spatial
choices only against the prose actually supplied; unavailable original private
behavior is not a prerequisite. Record missing coverage as missing.

`python3 tools/audio_verify_no_assert.py` stages a copy of the NEW owned audio
facade with `Basic(ENABLE_ASSERT=false)` and loads the actual production units.
It checks nonsequential Vorbis requests against an independently opened decoder,
drains queued work before shutdown, and runs interpreter/native O0/O2 plus six
desktop source checks. Its checks use explicit branches/exit, never assertions.
The staged facade is inside the owned Sound_Player subtree because internal
imports require stdlib origin; it is removed on exit. No peer files are edited.
Thread keeps assertions enabled: disabling them globally currently exposes a
separate NEW Thread dependency defect recorded in dependency requests.
The minimal `audio_reproduce_thread_dependency.py` command reproduces that defect
as a failure, with an enabled-assertions baseline first; it is not a passing gate.

`python3 tools/audio_verify_failures.py` requires an actual host SDK device,
submits only zero PCM and injects one close error at the owned adapter boundary.
With audio assertions disabled, it checks retained ownership, unsuccessful
reinit, retrying shutdown and exactly-once disposal in interpreter/native O0/O2.
Its error logger starts a second thread to prove private locks are released.
A separate C harness injects an SDK cleanup error and verifies wrapper retry,
compiled with NDEBUG and always-active checks. ALSA consumes its PCM even on a
close error; only the wrapper is retained for retry, avoiding a second PCM close.
These are controlled failures around real resources, not OS-generated failures,
physical hotplug, or physical-speaker verification. The SDK build tool links
this C harness on each configured platform; runtime metadata remains separate.

Current cache-page tests use distinct ADPCM predictors to detect block-offset
mistakes and verify all eight interleaved source channels with independently
constructed constant-predictor blocks. The concurrent-factory case runs 32 Ogg
factories while a real muted output worker mixes; its baseline also passed, so it
is smoke coverage rather than evidence that a sanitizer detected a race.

Self-contained cross packages now include every common manifest fixture at O0/O2,
not a handpicked subset. Their standalone runner uses always-required expected
stdout and separate unavailable-device markers, checks executable hashes/target,
then exercises logical 6/8 output separately. Current packages contain 52 binaries
and four extra multichannel executions. Windows additionally packages its ABI
fixture at O0/O2 (54 binaries total), retaining the two source checks too;
injected-failure and disabled-audio-assert configurations
remain separately labeled runners rather than being claimed by this package.

The loading case verifies an odd-aligned borrowed WAV buffer retains storage
identity and produces correct interpolation/final-frame hold through public
sampling. The cleanup runner also injects start plus close failure and requires
backend_init to reject the known-lost retained state. These additions preserve
existing clipping assertions; an initial narrow-shift implementation regression
was classified and corrected rather than relaxing the oracle.

The C `native-windows-abi.c` case compiles against real Windows SDK headers for
both release CPUs. It checks WAVEFORMATEX/extensible and DSBUFFERDESC sizes/offsets
and COM method slots used by the reviewed facade. The reviewed IDirectSound8
vtable is an eleven-slot prefix; this test deliberately compares its method
offsets rather than claiming it models every SDK method. The buffer vtable's
twenty-four slots are checked in full. No DirectSound interface is instantiated,
and no Windows runtime is claimed by successful header or native package links.
