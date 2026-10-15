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
