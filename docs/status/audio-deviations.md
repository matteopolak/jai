# Audio deviations, remaining work and evidence limits

Current implementation is NEW independent source in this worktree. Initial
assignment-described Sound_Player code was absent; only the separate wav.jai
dependency existed. No peer code was staged, modified or sought through alternate
access. No references, original/history bodies, transcripts, corpus vendor Jai,
credentials or quarantined logs were read. No agent_message capability is exposed;
concise commentary and these durable docs carry coordination. Extensions remain
untouched. Native SDK/public C inputs are linked in the integration documentation.

## Current limits and dependencies

- Android compiler OS support and a public Android NDK/AAudio toolchain remain
  genuine dependencies. No Android backend is implemented or executed, and Linux
  is never counted as Android. Reviewed AAudio hooks are private, not missing
  facade exports. PS5/Switch bodies are unavailable; nothing is inferred.
- Host macOS ARM64 has actual silent SDK and Jai interpreter/native O0/O2 evidence.
  macOS x64 also executes through Rosetta (not physical x64); Windows x64 adapter/
  decoder/harness and Jai fixtures cross-link without execution. Windows ARM64
  has SDK-header object compilation without CRT/library link. Linux x64/ARM64
  remain recipe/source-check only; ALSA code has not compiled or run here.
- Six desktop build/CI recipes and relocated host tests are self-contained.
  Shared manifest adoption and normal coordinator native CI remain pending.
  No shared manifest or peer source was edited. Static native executables embed
  audio/decoder archives; interpreter distributions still require shared files.
- Physical speaker routing, GUI focus changes, physical hotplug and sleep/wake
  remain unverified. The native harness proves real SDK pause/resume and controlled
  close/reopen using silence, not physical events. All native output submissions
  in tests are zero PCM; nonzero samples stay in controlled buffers.
- macOS/Windows focus uses process/window SDK state. CLI/headless processes are
  ungated. macOS active-state changes require normal AppKit event processing.
  ALSA has no portable window-focus interface; Linux focus gating is unsupported.
  Lifecycle queries/retries run at 250 ms intervals, not a real-time deadline.
- Recovery discards queued audio, retains logical format, logs failures/restoration
  outside private locks and retries actual opens. Incompatible devices can stay
  unavailable. A lost handle is not closed while a fill region is borrowed;
  release disposes it without pretending those samples were submitted. Public
  byte counts are real queued bytes (zero when unavailable), never producer-state
  sentinels; sampling rate is zero when the device is absent/known lost. Failed
  SDK disposal is fatal to avoid freeing possibly live callback state.
- Windows/macOS native byte counts retain entire SDK-owned queued buffers until
  completion, overestimating remaining playback bytes within the active buffer.
  ALSA nonblocking partial-write failure discards the affected submission through
  logged reopen recovery; no cursor rewind or exact replay is implemented.
- Fresh device enumeration retains interned names and changed snapshots for process
  lifetime, so previously returned slices remain valid. Memory grows with unique
  observed names/topologies. Enumeration is serialized outside the stream lock.
- One worker serializes decoder work and seeks each Vorbis page. No throughput,
  worst-case latency, lock fairness or real-time guarantee is claimed. Stream
  rendering locks at most 256 output frames per chunk, but unlimited streams,
  allocation and synchronous ADPCM decode can still extend the time held. Native
  polling/copy/commit use a separate producer lock. No stream pointer crosses a
  render-chunk unlock. Init/shutdown and low-level queue mutation remain caller-
  serialized; unsupported reinitialization from callbacks is not promised.
- Private prefetch keeps three forward pages, one additional reverse look-behind
  and a repeat-start page; page-size windows are reused until they change.
  This is independently selected, not exact original prefetch timing. Pending
  eviction waits until a later refresh; teardown drains synchronously outside
  locks. Private window metadata costs one record per live compressed stream.
- Spatial numeric choices absent from reviewed prose remain independently selected:
  shared stereo base 0.5, positive-component unit-power normalization, documented
  default vectors and linear near-fill blending. Exact numeric equivalence beyond
  the stated rules is not claimed. See precise questions. Seven-channel data
  preserves configured directions without an invented center-rear layout.
- Native static transitive OS libraries/frameworks are passed with link_always;
  a target linker may drop unused imports. Startup/link cost is not benchmarked.
  Borrowed PCM alignment outside the tested native arrays/WAV storage remains an
  explicit untested case; no special compiler-alignment claim is made.
- NEW producer tests have explicit spec provenance and coordinator independent
  review requested, not completed. Signature probes and history smoke calls are
  not exhaustive behavioral proof. Missing direct API references stay visible.
  Legacy stdlib-specific gates are retired per latest coordinator instruction;
  integration owns their coherent deletion/migration. Extensions tests remain valid.

## Deliberate implementation choices and resolved corrections

- The reviewed original threaded Ogg path was a no-op. The assignment explicitly
  requires genuine queues/playback and forbids stubs; this implementation actually
  decodes and publishes pages. The behavioral improvement remains deliberate.
- Windows nested #overlay(unknown.vtable) is rejected by this NEW compiler.
  #overlay(unknown) preserves the identical first-field IUnknown prefix and public
  fields/types. Static Windows x64/ARM64 sizes pass; Windows ABI execution is pending.
- An early private malloc heap mismatched Runtime_Support allocation headers and
  aborted on caller free. Long-lived allocations now use context.default_allocator;
  load_audio_data borrows caller bytes, and load_audio_file keeps File's allocation.
- Earlier provisional gain-squared, copied-loading, public-mutex, duplicate-start
  rejection and fixed-frame fade assumptions were replaced with reviewed rules.
  The loader alias test originally changed an already-zero byte; it now changes
  a nonzero high byte and proves aliasing. Later phase-bracket locking was rejected
  by refreshed review, removed, and its invalid paused-mixer test replaced by
  independent phases, mixer progress and callback reentrancy assertions.
- Refreshed review corrected completion booleans, mono mapping, hard panning,
  locked mono gain, circular-distance direction and Linux async-hook meaning.
  PCM/silence/panning assertions were explicitly reclassified. Three streams keep
  real clipping coverage at the reviewed 0.5 stereo split. Filename metadata is
  intentionally unread and stereo positional override is not active behavior.
- Activation-policy-only probing paused CLI hosts. The actual entity-progress
  regression caught it; owned-window detection corrected it. Borrowed-region
  concurrency then exposed a producer assertion: region ownership now prevents
  producer overwrite/commit without retaining any lock across caller work.
- Retirement is two-phase: resources drain outside locks while the decoder object
  stays alive/published, then its retired-list pointer is removed before object
  free. Entity elapsed-time state is synchronized separately from pre/post work.
- The concurrency fixture's arbitrary 4 MiB size exceeded the interpreter's
  60-second budget. A 256 KiB fixture preserves its coordinated page transition,
  stop/disposal and full-buffer assertions. This is a test resource correction,
  not a production performance pass. OS process inspection was denied during
  diagnosis; no alternate access was sought.
- Shell here-doc temporary creation is denied; edits use apply_patch/Python with
  durable source files. Initial empty/misplaced files were detected and corrected
  before checkpoint claims. The shared-root native builder was not invoked because
  it locates shared caches; the owned builder stays in this worktree.
- Opaque pinned official C stb_vorbis emits one upstream warning, reported without
  suppression. Owned C/ObjC builds use -Werror and Jai uses warnings-denied lint.
  A native rebuild briefly overlapped verification; final verification is repeated
  against completed immutable artifacts, excluding mixed-phase evidence.

## Cross-platform refinement after 11bc663

- macOS x64 now has real translated Rosetta execution on this ARM64 host, clearly
  separated from physical x64 hardware. Ten O0/O2 fixture binaries and four
  logical 6/8 variants run successfully. Windows x64 has ten cross-linked PE
  fixture binaries with checked machine headers; none is executed here.
- Windows ARM64 now has actual adapter/SDK-harness/opaque-decoder object compilation
  using a real ARM64 compiler target and common public MinGW headers. ARM64 CRT
  libraries, a linked package and native execution remain unavailable. This is
  object evidence, not substitution of an x64 binary or a full ARM64 SDK claim.
- Clang's warnings-denied object check found inconsistent dllexport declarations.
  Header and producer definitions now match; consumers remain plain static
  declarations. No compiler warning suppression or ABI/type change was used.
- Cross command configuration initially used unsupported macOS -os/-cpu native
  flags and host archive variables for MinGW. Explicit -target and JAIC_CROSS_LIBS
  are the source compiler's documented mechanisms; no shared compiler fix was
  needed. Durable cross/package/translated runners record each evidence kind.
- Native initialization cleanup failure now emits its real SDK status and aborts
  instead of losing ownership of possibly retained callback state. Unsupported
  Android C targets fail explicitly; no ALSA substitute is built. These exceptional
  cleanup paths are source-checked, not physically fault-injected.
