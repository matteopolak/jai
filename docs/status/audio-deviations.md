# Audio worker deviations and dependencies

- Baseline implementation described in assignment was absent. No alternate
  checkout/reference access was sought. Authorized NEW peer sources were not used.
- The initial provisional squared loudness, copied loading buffers, public mutex,
  duplicate-start rejection and 480-frame gain ramp were superseded by reviewed
  refinement. Tests were explicitly revised to the newer source contract.
- Borrowed input/storage identity and the specified perceptual curve now have
  genuine regressions. The initial loader mutation test accidentally wrote an
  already-zero low byte; it now changes the high byte and proves aliasing.
- A private malloc heap mismatched Runtime_Support's allocation headers and
  aborted both execution modes when freed through the caller allocator. Diagnostic
  isolation confirmed the free boundary. Private long-lived allocations now use
  context.default_allocator; loading retains caller-owned storage per refinement.
- Threaded page processing is functional, intentionally diverging from the
  refined spec's documented original no-op. The explicit assignment requires
  proper queues/playback and prohibits stubs. No pretend completed work is used.
- Windows public COM overlay spelling uses #overlay(unknown), since this NEW
  compiler rejects nested #overlay(unknown.vtable). IUnknown's first/only field is
  vtable, so storage offsets and exported fields/types are retained. Windows
  x64/ARM64 static size checks pass; native Windows ABI execution is unavailable.
- Native output negotiates logical 2/6/8-channel streams. Host AudioQueue accepts
  all three, with explicit channel layouts; controlled-buffer tests exercise all
  channels. Physical speaker routing is unverified. Windows WinMM C cross-builds
  warnings-denied for x64, but is not executed; Linux ALSA remains source-only.
  Android and focus/background recovery remain unfinished.
- Own native output adapter is source-relative, built beside its own source.
  Release relocation/packaging remains a coordinator dependency. No shared
  tools/native-libs.json edits, publications or release actions were performed.
- stb_vorbis uses the existing pinned native-libs manifest. Its official C source
  was downloaded, hash checked and compiled opaquely inside target/audio-native;
  no C implementation was inspected as Jai compatibility input. One upstream C
  compiler warning is reported, never suppressed. Owned C builds use -Werror.
- The shared-root native builder was not run because it locates shared caches
  even with --out. The audio-local builder stays inside this worktree.
- Decoding allocates full pages and seeks to each Vorbis page. One worker serializes
  decoder work; no decoder throughput/latency benchmark is claimed. Deinit drains
  work synchronously outside the player lock. Pending page eviction is deferred
  instead of waiting on the mixer. Native byte counts are whole queued buffers,
  which overestimate remaining bytes within the currently playing buffer.
- Module init/shutdown and raw queue-global mutation require caller serialization;
  supported player setters/stops synchronize internally. Configure fields before
  start: unsynchronized active-field writes can race mixing, as reviewed. There
  is no exported general synchronization handle.
- A pending bracketed entity lock was based on an incorrect synchronization
  assumption. Refreshed review explicitly rejects it. Removed phase-spanning
  ownership, balancing assertions and deferred stop callbacks. The previous test
  expecting a paused mixer was invalid and replaced, explicitly, by independent
  phase/worker progress, standalone phase and callback reentrancy checks. Each
  pre/post call now locks only its own work; callbacks remain outside locks.
- Existing tests/stdlib/sound-player-offline-api.jai uses unreviewed OFFLINE and
  render_offline. Preserved, classified as an unreviewed extension test and not
  silently included among reviewed passes. The existing device test was initially
  conservatively classified as legacy; actual execution establishes it as a valid
  reviewed-contract regression. It passes interpreter and native O0/O2 unchanged.
- Refreshed review resolves advance_history_cursor. Private history records
  per-channel extrema over 1024-frame intervals in a 64-slot ring; advancement
  resets the next interval and partial progress, including direct calls before
  init. These independently chosen capacities are private. Recording adds two
  extrema comparisons per scalar sample; no throughput benchmark is claimed.
  Public tests can verify callable/signature behavior but cannot inspect private
  extrema because the contract exports no accessor. Direct calls require caller
  serialization with mixing, as reviewed.
- Shell here-documents fail due to denied temporary-file creation; edits use
  apply_patch/Python. Initial empty files were detected/replaced before claims.
- No agent_message capability exists; commentary/status docs carry updates.

- Remaining spatial behavior is provisional where exact contracts are missing:
  multichannel spatial sources currently use one source-position plane direction
  for every input, without applying stream.orientation; many-channel music uses
  the locked-output routing helper. Closeness/stereo-dot rules and default vector
  angles are independently selected. Degenerate VBAP arcs are skipped. These
  paths have controlled math tests, not exact compatibility evidence, and need
  the precise reviewed contracts requested in questions.
- Cached Vorbis opens borrowed memory only; filename_to_stream_from is retained
  as a public field but is not a separate file-streaming path. Opus is not
  supported. Seven-channel routing remains provisional. Native device names are
  cached for the process lifetime and do not reflect later hotplug changes.
- get_bytes_between currently measures rear minus front modulo buffer length;
  backend_needs_async_update_from_main_thread currently returns true because this
  adapter requires ongoing producer calls. Their exact platform semantics remain
  requested, not established by declaration/signature probes.
- Mixing and page preparation hold the player lock while processing each caller
  buffer, in accumulator chunks of up to 48000 frames. Page allocation and scalar
  multichannel loops can extend that critical section; no real-time deadline or
  worst-case setter latency is established by the functional tests.

- Platform work supersedes the earlier source-relative packaging limitation:
  native executables statically embed audio and decoder archives, and actual host
  moved-package O0/O2 tests pass without shared audio/decoder files or loader
  overrides. Shared manifest integration is still coordinator-owned, with a
  minimal local-unit fragment and all six SDK recipes documented.
- Device names/topologies now refresh on every enumeration call. Interned names
  and changed returned snapshots remain valid for process lifetime, trading
  memory proportional to unique observed changes for borrowed-slice safety.
- Focus/background recovery uses public macOS/Windows process/window state and
  real SDK pause/resume. No GUI window means no window-focus gating. ALSA has no
  portable focus interface; Linux focus is unsupported, while PCM recovery is
  implemented. Android remains compiler-dependent. Native polling is every
  250 ms; CoreGraphics window dictionaries can be expensive and no latency/CPU
  benchmark is claimed. An activation-policy-only probe paused CLI playback;
  the real progress regression caught it, and owned-window detection corrected it.
- Runtime recovery discards already queued audio, preserves logical format and
  retries every 250 ms. No audio cursor rewind or automatic channel-format
  conversion is attempted. An incompatible endpoint can remain unavailable;
  errors/restoration are logged outside the player lock. SDK disposal failure
  remains fatal to avoid freeing state still reachable by callbacks. Physical
  hotplug/GUI focus/sleep-wake are source-only recovery evidence; the real harness
  exercises SDK pause/resume and controlled reopen with zero PCM.

- Refreshed contracts supersede earlier provisional PCM completion booleans,
  circular-distance direction, Linux async semantics, MONO mapping and constant-
  power locked mono split. Reclassified those test expectations explicitly;
  three-stream clipping keeps genuine saturation coverage with the reviewed
  0.5-per-side split. Added signed/zero-rate, page-edge, missing-page, listener,
  outside-coverage VBAP, music and footstep regressions.
- Spatial channel routing now uses each configured source direction, locked/music
  rules and planar closeness. Invalid edited arcs assert rather than being silently
  skipped. The spec does not numerically define shared stereo base/default angles/
  blend equation; independent current choices are documented in questions rather
  than falsely presented as exact numeric compatibility. Stereo position override
  and filename-driven decoding are absent from reviewed active behavior and are
  not unfinished requirements. Seven channels preserve configured directions;
  no dedicated center-rear mapping is invented. Android private hooks require
  compiler support; PS5/Switch unavailable bodies imply no implementation work.
