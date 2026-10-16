# Independent integration deviations audit

## Current verification and package closure: 06e8ea96 / a4d28b63

Committed candidate06e8ea96 has an exact compiler SHA, stdlib tree and235 native
asset hashes in shared-candidate-06e8ea96.json. Native caches with duplicate
basenames retain their original search-order layers; an initial flat copy failed
at differing libapple_abi_probe.a bytes and its partial directory is unused.
The canonical generator-platform helper was source-built from the committed C
body after a development asset omission was identified. Correct current rpmalloc
domains were rebuilt;21 selected asset profiles are not21 runtime passes.

The new a4d28b63 packaging tool retains installed LLVM/Zstandard/Z3 dynamic
dependency notices with hashes and rejects missing/conflicting notice files.
Actual source-built consumers work after moving the package, with loader-relative
dependencies and verified signatures. Earlier statements below about no notice
copying are historical; pinned06 keeps its original tool source/limits. Compiler
resources, sysroots, other static notices and native Windows/Linux packaging
remain open. No self-contained distribution or publication claim follows.

Fresh06 catalogue420 cases finished with781 positive runtime passes and25 failed
mode records. Two failures are a new Cocoa unit's missing assertion-mode argument;
the exact unchanged frozen library passes interpreter/native when given enabled.
The catalogue metadata is corrected in656ed202, with13 runner tests passing.
Original totals remain unchanged; no source repair or clipboard substitute was
used. Json numbers timed out at180.00631441699807s only in the interpreter and
later cases continued. Other failures retain compiler/legacy-API classifications.

The current complete workspace command uses permitted hash-pinned own fixtures
and excludes corpus/vendor bodies and the suspended invalid-memory fixture.
Missing corpus-backed setup failures remain failures; inherited fixture-gated
early returns are recorded as unexecuted input, not functionality. Initial
fixture extraction refused an already-pinned read-only ABI input; it was verified
unchanged and skipped rather than unprotected/overwritten. The first Clippy
invocation raced incomplete fixture staging and failed at a missing include;
the complete-input rerun and Rustfmt pass. Root must perform full-fixture corpus
and Focus acceptance externally. No assertions or CI coverage were weakened.

## Current shared source reconciliation: fad75f23

The active tree is `stdlib-shared`, branch `codex/stdlib-shared`, production
snapshot `fad75f237cd2f9691b3cba9f287c7d71a0b32705`. Earlier entries below are
historical evidence, not proof that their fixes exist in this snapshot. In
particular the older filtered-parameter serializer repair has not been adopted
into current compiler-owned Program_Print; the independent roundtrip still
fails and is requested in integration-requests.md. Current whole workspace and
catalogue results remain the failed exact6295584c measurements.

`tools/native_bindings/rpmalloc_profiles.py` generates cache and diagnostic
domains; the current integration run executed only four diagnostic combinations
with both caches enabled. Generation is not runtime coverage. The new
`build_flags` ABI intentionally requires rebuilding native libraries using the
binding builder, rather than reusing legacy artifacts. All25 scoped checks pass
with real C SDK instrumentation; Windows/Linux have only source checks. The
first independent generation check used a capture omitting generated test
files, failed at the absent probe and was rerun read-only on actual unchanged
shared outputs. No fixture or declaration repair was used. Remaining numerical,
adaptive-cache/page/unmap options retain explicit restrictions; proper closure
requires real corresponding C configurations and ownership/ABI/runtime tests.

`internal/collections/hash-table.jai` has an uncommitted real Walk_Table body;
exported named-while condition values are not visible in inserted caller code.
The ordinary named-while and macro label-only controls pass. No helper export,
shadow variable or symbol-specific compiler exception was introduced. General
compiler hygiene repair and the unchanged table-slot assertions are required.

## Shared portable transition, 2026-10-15

- Optional-assert fixes in `internal/input/keymap-text.jai`,
  `internal/numerics/ui_text.jai`, `internal/clipboard/cocoa.jai` and
  `internal/rendering/{dynamic-fonts,font-features}.jai` execute necessary native
  operations before diagnostics. Font metrics/glyphs/GSUB bytes come from real
  FreeType calls; failed size selection returns null from pointer loaders, failed
  glyph work clears partial prepared output and is not cached. No fake metrics
  or textures were added. Cocoa controls use a real unique native pasteboard,
  not a memory replacement; general system clipboard/bitmap and GPU integration
  remain separate gates. Private font registries retain their reviewed lifetime.
- `tools/portable_assertion_test_config.py` creates the root-authorized default
  Basic-disabled test configuration by changing exactly one existing default in
  fresh source copies. Actual default-instance checks and before/after hashes
  distinguish it from a separate caller-only import. One earlier font debugging
  copy was transiently modified, then restored/hash-verified; that intermediate
  experiment is disclosed and is not final proof. Final receipts use fresh copies.

- `tools/developer_native_runtime.py::stage_macos_sdk` relocates and signs the
  real configured libclang/LLVM/zstd/z3 images and records source/output hashes.
  Its stage contains no license-copy step. Loader closure is verified locally;
  redistribution-license closure is a separate unresolved packaging requirement.
  `compiler-path.txt` still names a configured SDK compiler/resource environment;
  Linux retains configured symlink/rpath dependence. These development helpers
  do not establish a self-contained release distribution. Proper fix: package
  required compiler resources and notices with pinned receipts, then remove
  disposable SDK prefixes and verify actual installed consumers on each host.
- Fresh shared workspace `6295584c` initially omitted generated
  `stdlib/internal/runtime/crash-native/libportable_crash.dylib`. Three native
  tests failed; `tools/build_portable_runtime.py` rebuilt the actual owned C
  source. Their original failures remain recorded until frozen-source follow-up.
  Proper fix: a single documented native build preparation step in the combined
  baseline/package pipeline, rather than relying on old worktree artifacts.
- `crates/jaic-cli/tests/debug_info.rs::lldb_breakpoints_backtraces_and_variables`
  stalled at LLDB `run`. The external-debugger case was terminated after
  210.059 observed seconds against a180-second timeout policy, then independent
  tests continued. This is a failed timeout, not debugger verification. The
  process-age query was sandbox-denied; no alternate query was attempted.
  Proper fix: bounded external-tool test execution and actual native debugger
  verification on an authorized host; retain all breakpoint/variable assertions.

- Producer preservation checkpoints `ba964cb5` (model), `98b1581c` (tools) and
  `0d57d885` (bindings) contain partial work. Adoption is not verification:
  aggregate emission's unchanged negative-cycle assertion, unrepresented native
  virtual conversions, macro validation, Android target support and native fixture
  corruption remain open. Public expression emitters remain in the canonical
  facade; the incoming aggregate branch is reconciled there, without duplicate
  exports from private files. Typed context.generator uses the single canonical
  default Generator; cross-configured nominal type identity remains unestablished.

- `tools/check_asn1_socket_closure.py`, `tools/check_portable_jks_crypto.py` and
  `tools/check_portable_apk_signing.py` retain producer source/facade staging.
  Their old passes are historical diagnostic evidence, not current production
  proof. `tools/check_shared_portable.py` executes nine unchanged public fixtures
  against the combined tree with input hash checks. Private APK framing/EVP
  assertions still need owner integration; that unexecuted coverage is open.
- `stdlib/internal/android-toolchain/crypto-provider.jai` uses OpenSSL3 native
  ABI under reviewed compatibility names. Package construction is Mac-only;
  three actual construction/rejection tests pass. Windows/Linux/device, x64 and
  minimum-deployment native verification remain open. No new runtime fallback
  or public native handles were introduced.
- `stdlib/internal/android-toolchain/apk-signing-orchestration.jai` preserves
  reviewed log-and-true cryptographic mismatch behavior. Callers cannot use this
  as a general signature-validity predicate; changing it requires spec review.
- Reported all-zero PDB/CIE corruption is unresolved. Seventeen inputs in the
  integrator's retained target are nonzero; this does not disprove the reported
  failure. Preserve corrupt bytes, identify the generating/consuming command,
  serialize native suites and check input hashes throughout verification.

## Mac native loader constructor affinity

The strengthened original C constructor's pthread_main_np assertion reproduced
a second initialization defect: Library::open called dlopen on the compiler
worker. The Mac loader now uses the existing generic synchronous root-thread
job, retaining calling-out callback attribution and direct/fork boundaries.
No library/symbol-name exception or loader environment override is used. Two
Rust boundary tests cover four named/unnamed runtime/compile-time constructor
cases, actual linked O0 executions and missing-library/isolation checks. They
pass. Root-thread handoff adds first-load latency; other-platform native loader
behavior and general TLS/errno parity remain separately required verification.

## Value-emission load reconciliation

Preserving the newer canonical model/facade during tooling merge dropped the
producer's independent value-emission load line. Ten focused commands correctly
failed on missing jai_literal_fragment/printing exports. The final production
facade loads seven reviewed public functions in
`stdlib/Bindings_Generator/value-emission.jai`, with the existing algorithms
remaining under internal/developer-tools. Original signatures/defaults/bodies
and canonical types are preserved; no duplicate models or source overlays were
introduced. All21 affected commands pass, including generated native/interpreted
Jai consumers and whole-module strict lint. Prior failed147-command report is
retained, not retroactively recounted as green.

Debug_Info SDK preparation generates real original C objects, relocated ELF
debug sections, MSF/PDB streams and CodeView data. Its existing msf-wire private
unit copies the unchanged private helper into target; this is isolated private
unit evidence, not public API or repaired-library proof. Twenty parser/regression
fixtures execute interpreter/native ARM64 O0; the separate public facade is also
strict-linted. Actual Windows/Linux execution remains unverified.

Reviewed SDL contract explicitly restricts RWops to SDL-owned native pointers:
the48-byte public record omits the native hidden union, and its ordinary Jai
callback fields do not establish an installable native callback-table contract.
Current factory paths preserve SDK pointer identity and the BMP scalar adapter
normalizes nonzero64-bit close flags. No48-byte caller record is constructed and
forwarded by these implementations/tests. UserEvent exposes only8 bytes, while
the enclosing Event union has its declared56-byte padding; direct event APIs use
that enclosing union. Neither record is certified layout-compatible with its
native C counterpart, and no callback/native payload convenience is invented.

## General required-library initialization repair

`interp/mod.rs` now honors link_always before runtime entry/native foreign lookup,
and `sema/modules.rs` resolves named literal required-library metadata during
expansion. Native handles retain existing cache/process lifetime. Each lookup
scans library metadata; O(library count) work is an explicit performance cost,
not benchmarked. Proper optimization is an incremental append-aware cursor with
dynamic source/failed-load regressions. Pure compile-time constants and
SandboxHost do not load native output requirements; no unavailable native SDK is
counted as successful. Actual original C constructor and Objective-C runtime
checks pass. Linux/Windows native loader verification remains required.

Existing `foreign_addr` still permits process-global symbol lookup when a
non-required explicit library cannot open. Its exact compatibility policy is
not established by these tests. Risk: a global symbol may satisfy a declaration
whose named library failed. Proper follow-up is a reviewed explicit-library
lookup policy and original failure/interposition tests, not an invented alias
or blanket successful fallback. This repair does not certify that separate path.

## Combined scope refresh through7b6e8de9 and privacy follow-up

Stable workspace at7b6e8de9:848 passed/four failed/one inherited ignore in100
Cargo binaries. Two failures were old interception-count oracles: canonical
resolved library declarations now participate. `cleanroom_modules.rs` now checks
exactly the application plus referenced library declaration, retaining an invalid
cold declaration that must stay lazy. `cli.rs` checks every skipped category,
per-message all/header/struct consistency and exactly one actual application main
and S, independently of additional canonical runtime/library records. Both tests
pass; no compiler/library filter exception or reduced check is introduced.

Debug's named filtered reexport leaked unreviewed `Debug.Shared`. The new privacy
regression first rejected that export; anonymous filtered reexport removes it
while preserving canonical types and both mutable storage addresses across
USE_GRAPHICS configurations. The actual allocator-retention test moves into
`stdlib/Debug/tests/ignore-ownership.jai`, where its private import is legitimate.
All its assertions remain. Neither CLI private-entry nor application-import rules
were weakened. Both fixtures execute interpreter/native ARM64 O0 and strict lint.

The Debug merge67712edf inadvertently tracked the allowed control inbox. Cleanup
1cc5c277 removed it from the product tree without history rewriting. Coordinator
must exclude docs/worker-inbox.md during final history insertion. Subsequent
merges assert that this path, AGENTS and ownership guidance are absent from the
staged product change. The producer's raw local gate log was moved into ignored
artifacts; no gate success is inferred from that historical log.

Bindings958af0a2 retains real Android logging's forced Runtime flush in place of
literal discard; it remains partial pending the Runtime-owned discard operation.
Objective-C encoding supports only its documented native-compatible reflected
categories. Member-stub loading tries the reviewed framework spelling, then the
installed `.framework` spelling; byte-copy/snapshot and global-cache reservation
costs remain producer-documented. Default stats/no-stats allocator SDK/callback
libraries rebuilt from actual combined source;77 Python tests, two real public
heap fixtures in both modes and three actual host C sanitizer safety programs
pass. Other cache profiles/CPUs/native OS execution were not rerun.

Android45/52 names have integrated host paths, seven signing-dependent source
drafts remain unloaded. `tools/verify_android_project.py` creates structural NDK
path sentinels and controlled failing command scripts; these are discovery/argv/
failure-propagation fixtures, not real compiler/libclang/ADB/signing/device proof.
Real SDK/NDK/Java/Gradle builds, installation and device execution remain required.
Object formats report467/508 scope rows implemented; declared record/constant
coverage is separate from parsing behavior. Unsupported formats and relocations
fail explicitly; no fabricated parse/output success is accepted.

The tooling-owned typed canonical generator/options snapshot document is a
proposal, not current implementation. Current configured facades still use
nominal module-instance types and opaque borrowed options pointers. Cross-instance
activation/type/default identity needs owner review and proper canonical typed
normalization; merely sharing Context storage does not prove that contract. The
model-owned generator-session is the only actual slot/ledger; no parallel shim
from the names/modifier/platform producers remains. See the integration request.

## Canonical generator merge db2962e7

Compiler e9affab7 supplies the single general module-context ordering fix. The
model worker's overlapping driver implementation was excluded during merge;
both independent regression sets remain. Its test constructors were adapted
to current Rust Options fields, retaining all assertions (12 tests pass).

Model b00aa052 supplies one unparameterized private generator-session owner,
borrowed options pointer and optional allocator ledger. Names83ba1961 originally
added a separate typed Context options value; that value/load was removed.
`naming-helpers.jai` reads `gm_active_options`, using canonical options field
defaults when no caller options are installed. Fixtures install/restore the
one borrowed pointer. Caller options must outlive callbacks; ledger records do
not dispose canonical libclang handles or tables. Shared generator state is
not copied. Public init/run/deinit lifecycle integration remains tooling work.

Construction retains explicit unsupported native-type diagnostics, limited
function equivalence, borrowed TU location/token data and map-value pointers
invalidated by structural mutation; it does not certify every C++/vtable case.
`generator-special-construction.jai` independently filters macro suffixes `_H`,
`_H_`, `_INCLUDED` as header-guard heuristics; exact reference equivalence is not
established, and valid constants with those suffixes may be omitted. Proper fix
is reviewed filtering rules plus actual preprocessor guard information. Existing
type comparison/traversal caps documented below remain performance/correctness
limitations, not a completed arbitrary-depth domain.

Actual production verification:52 commands pass, covering twelve interpreter
and twelve native ARM64 O0 fixtures, twelve strict fixture lints, whole-generator
module lint, Http client lint and an actual C record-layout oracle. These are
focused follow-ups; the frozen ad575d16 full-run counts remain unchanged. No
second CPU/optimization sweep or staged repaired library was used.

## Combined ad575d16 measurement limits

The stable workspace command completes with 840 passed/two failed/one inherited
ignore across 98 Cargo binaries. Four nested fault-safety summaries are printed
separately; all 102 summaries total 844, not 844 distinct suite tests. Machine
counts explicitly exclude those repeats. `tests/stdlib-targets.txt` has 186
differences, including genuine unsupported platform backends: no blanket
acceptance is used. Exact 80 new failures are in `mac-target-failures.json`;
72 mechanically contain guards, six API/body errors and two unavailable
compile-time native calls. Intentional guards require reviewed target evidence.

`tools/jaic-sweep.py::make_workdir` copies whole upstream trees and symlinks
siblings, potentially exposing vendored implementations. It is not an allowed
local public-corpus stager under this session's isolation rules and was not run.
Full original application corpus is coordinator-owned; its denominator remains
separate from the 414 local catalogue cases. A safe local stager must omit vendor
module/stdlib/prelude directories before access, preserve unchanged application
entries, and select the NEW library. No alternate vendor access was attempted.

Unchanged `jaifmt/main.jai` rebuilt against production ad575d16; all 845 production
Jai sources pass format checking. This proves format/build, not complete lint:
actual Http client strict lint still fails Context registration ordering. The
approved general compiler repair is queued until the frozen catalogue completes;
no module-specific bypass is used.

## Refresh-ten rejected SDL adapter

Bindings `fddae00` was inspected directly. Its RWFromFile proxy changes SDL-owned
native object identity and installs ordinary Jai callback pointers into an object
that native C clients would interpret as SDL_RWops. It is not safe native
interoperability; its BMP wrapper additionally fabricates a default callback
context with no reviewed capture policy. Integration rejects those two adapter
entries and retains direct foreign factory/BMP calls on actual SDL-owned native
pointers. No C receives a 48-byte Jai-created object from our supported helpers.
Custom/copy callback records remain outside the supported native ABI contract.
The safe WM-info adapter and other new binding work are retained. Generator
metadata is regenerated from this actual composition; proxy-only test successes
are not counted as production evidence. Exact reproducer/required owner action
are in integration-requests.md. Public RWops/UserEvent layout gaps remain visible.

## Native linking and test-oracle audit

- Production native dependency `xxhash070` was missing from
  `tools/native-libs.json`, despite the reviewed xxHash facade needing its 0.7.0
  state ABI. The default source-build manifest now includes the same hash-pinned
  official C inputs and license as the binding verifier. Host static/shared and
  Windows x64 MinGW static builds pass; the original allocation-memory interpreter
  fixture now passes. This does not establish native Windows execution or complete
  packaging of every other binding dependency.
- `tools/format_platform_io.py` invokes actual jailint with warnings denied on
  all positive owned files across four supported profiles and requires manifest
  coverage. Its one deliberately invalid input,
  `tests/platform-io/negative/windows-runtime-configuration-conflict.jai`, is
  separately required to exit 1 with the exact compiler rejection and no ordinary
  lint findings on both Windows CPUs. Its body cannot compile; no semantic-body
  coverage is claimed. All 42 positive owned files are covered. This narrow test
  classification preserves both the strict compiler diagnostic and positive lint
  gate; no rule or application privacy policy is disabled.
- The 2300-row `float-power-sweep.jai` is an auxiliary numerical oracle program,
  not an `ok`-output fixture. The portable runner now routes it to the mandatory
  exact-rational validator with a 300-second bound, retaining interpreter execution
  and native/WASI O0/O2 when selected. All five modes actually pass. Its former
  45-second generic-output failure is retained; no numeric assertion was weakened.

- `tools/native_bindings/config.py` incorrectly mapped the Windows private `gl`
  and `gdi` library tokens to nonexistent DLL/import-library names. The generator
  now selects opengl32/gdi32, retaining public foreign signatures and token names.
  Generated Windows sources pass regeneration/idempotence; public signed-wheel
  renderer fixtures now actually cross-link x64 O0/O2. These are PE builds, not
  Windows execution or ARM64 link/runtime evidence.
- `stdlib/Adpcm/module.jai` exported five aggregate field names as nonexistent
  module globals. Reviewed Adpcm lists these only as record members. Removing
  the invalid aliases retains every real public declaration and record field;
  both Windows no-DCE profiles pass and a negative public-scope regression is
  retained. This corrects the facade rather than inventing fake global storage.
- `tests/portable-stdlib/unmapping-allocator.jai` now uses a precise native C
  memset/signal oracle in each isolated fork child. Guarded intrinsics and foreign
  fault containment correctly turn invalid writes into interpreter errors, so
  they cannot serve as the native-signal oracle. Restoring default SIGBUS/SIGSEGV
  disposition only in the child preserves all original mandatory signal, lifetime,
  allocation-failure and concurrent cleanup assertions. Interpreter and native
  O0/O2 pass; separate compiler tests require guarded intrinsic errors.
- The native signal setup revealed macOS `POSIX.signal`'s reviewed three-argument
  declaration does not match the native two-argument C ABI. The fixture declares
  the official C ABI privately; it does not claim the public facade safe or fixed.
  Binding ownership/review must resolve a safe public adapter/diagnostic without
  guessing meanings for unknown parameters. This ABI gap remains visible.
- A local empty-C-argv runtime proposal was tested and saved under ignored own
  artifacts, then removed from the source tree because the active platform owner
  is implementing the interpreter hook fix. It is not production proof; zero-arg
  Windows startup remains a coordinator-reported failure pending that checkpoint.

## Production strict-lint field type correction

The merged producer IDE layout ordering fix was insufficient for
`tests/platform-io/layout-contract.jai`: actual jailint and a new production-library
Rust regression retained a circular INFO_SIZE dependency. Bare/type-qualified
`type_of(field)` was requesting the whole containing record layout. General field
type resolution now evaluates the declaration's annotation or inferred initializer
without requesting later field offsets, sharing the same type inference routine
with actual layout. Selected static branches and modified-struct declarations keep
their original scope. Inherited/generated members retain the existing resolver.
Genuine recursive sizes still reject. The original source/assertions remain intact;
155 units, 50 module, three layout and four IDE regressions pass. Temporary general
cycle tracing was removed before commit. Actual strict lint of the original layout
fixture now passes. No diagnostic, visibility or rule was suppressed.

Role: replacement integration worker. This report is open; merged snapshots do not imply completed stdlib support. Producer reports were read for compiler, portable stdlib, foundations, bindings, numerics, window/render, LSP and SDL3. Direct code inspection and combined-tree verification are in progress.

## Sixth approved refresh audit

Compiler 5d0bf33, portable 803f84a, foundations 49c937b, bindings b8e492b,
numerics 441385d, window 31ded39 and platform-io 658498a are merged separately.
Every changed producer handoff/status/deviation report was read; unchanged LSP/
SDL3 reports were already reviewed. The safe CI editor fix 767130b is merged.
New coordinator-reviewed Process/System/runtime contracts are preserved. Prior
fifth-refresh evidence below is historical, not proof of this combined snapshot.

- New interface validation resolved patterns in module scope, losing private
  contextual contracts. The actual unchanged formatter failed. An original
  non-Basic test fails before and passes afterward with default/valid/invalid
  bindings and preserved privacy. Pattern evaluation now uses declaring file
  scope; all 41 module and interface/variadic core cases pass. No API helper is
  exposed or library name checked.
- New mixed variadic lowering makes the original Process/Autorun prefix reproducer
  pass. Autorun's temporary argv assembly is removed; direct mixed packs pass
  real workspace child execution interpreter/native O2. The original assertions
  are promoted into the ordinary portable runner. Dynamic native packs still
  use caller storage/continuation retention as reported by the compiler producer;
  its standalone memcpy harness is not production runtime evidence.
- Private Windows Process verification formerly wrote a temporary public module
  into a staged stdlib. It now compiles the real engine through a permanent
  library-owned Process test entry; the superseded facade fixture is removed.
  Both Windows CPUs pass all-code checking without source mutation or relaxed
  application privacy. Public Windows Process adapters remain unimplemented;
  their newly reviewed shapes are now available to the active platform owner.
- The old Windows startup positive fixture conflicted with the configured runtime.
  Its complete source remains a required negative check on both CPUs. A proper
  library-owned backend entry checks actual startup independently. Latest review
  makes native crash backtraces x64-only and meaningful for system entry; ARM64
  now diagnoses that limitation and embedding does not enable a handler. Two
  production-library compiler tests pass, including explicit initializer use.
  Private SDK marshalling does not establish completed public crash-handler ABI.
- Native Windows command-line pointer storage now uses size_of(*u8), removing
  an unnecessary hardcoded eight-byte allocation multiplier. Wider System/
  Thread/native SEH behavior needs actual new CI; previous File/wheel CI results
  are scoped to its older candidate. CRT suspended-thread interpretation and
  event/OVERLAPPED interoperation remain genuine compiler requests.
- File's Wasm check remains an explicit File contract CI gate. The expanded
  platform runner supports selecting contract cases; omitted selection still
  runs all contracts. Unsupported System/Thread Wasm imports are not silently
  filtered from an all-case run. This preserves the original File gate while
  Windows native CI continues to request all platform contracts.
- MPEG currently supports real buffer/bit/VLC/pixel/IDCT operations only; demux/
  decode is unfinished. Its official MIT C algorithm input has a pinned SHA256,
  not a Jai implementation or API oracle. The upstream header remains byte-
  identical including whitespace; only that third-party header is excluded from
  owned-source whitespace checks. A qualified Basic constructor workaround,
  widened checked IDCT arithmetic and native contract questions remain reported.
  Its Windows test exclusion predates File completion and must be removed here.
- Native GL/AppKit source pins and context policies, widened IEEE norm arithmetic,
  font process-lifetime registries/borrowed data, retained root share context,
  incomplete Windows/Linux close cleanup and unsupported GL texture/debug routes
  remain as specified in producer reports. No fake metrics, texture or clipboard
  backend was introduced. Actual new host driver execution is required before
  accepting their staged results.
- The first removal of the private-process staging wrapper left a malformed
  Python finally indentation. py_compile and the runner failed explicitly; the
  failure is retained. The repaired runner passes host contracts/private source
  checking. No failed native/interpreter case is counted from the syntax-failing
  invocation. Lint still rejects incomplete compilation rather than accepting
  its quiet exit-zero behavior.

The inherited target matrix discovered only top-level modules, omitting four
nested public facades: Objective_C/AppKit, Android/AAudio, Android/EGL and
Gamepad/SDL_Input_Map. An original synthetic-directory regression failed before
the general recursive discovery fix and passes afterward. The actual seven-
profile unused-code matrix is rerun with these modules. Its old expected-error
inventory remains unchanged and failing rather than being expanded to bless
real failures. Only the canonical private implementation root is excluded from
application imports; its code remains checked through importing facades. This
is stronger coverage, not a production pass from the synthetic directory test.
The first standalone matrix overlapped a workspace invocation using the inherited
fixed scratch directory. No target source-read failure was observed, but those
matrix outputs are superseded by an isolated rerun. Scratch directories now
include the invoking process ID, preventing concurrent verification from deleting
another run's generated entries; assertions/expectations and coverage are intact.

The whole-tree lint finding in `internal/net/socket.jai:check_fd_set` exposed an
unused destination pointer and acceptance of null sets. A new original fixture
fails before the fix. Validation now requires a nonnull destination as well as
the descriptor range; FD_ISSET returns zero for null instead of reading it, and
mutators retain their assertion. Descriptor-edge/null/bit operations pass
interpreter/native O0/O2 and scoped warnings-denied lint. Names/signatures are
unchanged; no warning suppression or dummy parameter read was added. This is
independently chosen defensive validation where the reviewed inventory leaves
invalid-pointer behavior unspecified, not evidence of any reference body.

Browser fixture corrections are documented with exact API reasons in
tools/legacy-contract-audit.md. No logger/Thread/IDE assertion was disabled.
Initial corrections used invalid foreign-variable syntax; those failing runs
are retained, and the compiler's supported #elsewhere syntax is used. C bridge
coverage does not claim POSIX or Basic.exit support on Wasm. Whole-tree quality
606-source run is stable and retains 34/152 failed checks; the earlier run that
raced a source edit is explicitly not stable. Subsequent Socket scope lint
supersedes its one ordinary warning, not the incomplete-compilation failures.

## Production boundary correction and fifth refresh

The final numeric failure review caught an incomplete Windows font integration:
`loaded-fonts.jai` allowed Windows filename loading, but Simp's File import was
still Unix-only. Both guards now agree, with real File operations preserved.
The original editor all-code failure is retained; x64/arm64 editor and public
font all-code regressions now pass. The window runner adds these checks, rather
than relying on its earlier reachable-code-only source checks. One first runner
attempt selected the loaded font test fragment directly and failed its missing
imports; it is corrected to the existing complete font-public wrapper, with the
failure retained. Complete scoped lint and formatting pass; actual native
Windows FreeType/font execution is still required. No fixture module replaced
File/Simp/Input or native metrics/texture storage.

Filtered coordinator CI feedback for candidate 159ca65 records real Windows
x64/arm64 File interpreter/native O0/O2 and signed-wheel interpreter/native
passes. The overall Windows workflow failed; Process/Thread/System/crash and
other module gaps remain. The reviewed CI candidate is merged with each File
step placed before the broad test commands. No run was dispatched here, and
these results do not establish native rendering/font/Focus compatibility.

The formatter fuzz replay exposed File selecting POSIX on Wasm. The POSIX guard
remains strict. `internal/files/wasi-libc/module.jai` declares the existing
preserved WASI extension's opaque C stream/directory ABI. Shared stream code
selects that private boundary on Wasm; it uses actual directory open/close to
verify an already-existing directory without assuming a host stat layout.
Effect/tradeoff: existence checks require readable directory capabilities and
one extra open/close, returning false if verification/cleanup fails. This is a
documented supported capability limit; a direct stat adapter could avoid those
extra operations if profiling or clarified contracts require it. The unchanged
File fixture passes Wasm interpreter and actual WASI O0/O2; formatter saved
regressions pass. New sources pass actual repository format/check and complete
jailint warnings denied. Normal CI now runs this File Wasm gate; no fake host
imports, Extensions edits or missing-import traps were used.

The crash/startup Python runner still implicitly copied `Compiler` and
`internal/compiler-api` from a sibling NEW compiler worker when given a production
stdlib. The isolated sanitized worktree exposed that read/copy assumption. Earlier
aggregate startup passes are not accepted as proof of a run without overlays.
The three previously noticed changed files matched approved compiler 890329b when
audited, but the tool did not pin or hash the sibling snapshot. No quarantined/
reference source was accessed; this was unapproved NEW-source staging. Both copies
and the default sibling-path option are removed. A nonmutation regression passes,
and actual ON/OFF native crash checks pass with the integrated facades alone.
The complete portable runner then passes 95/95 plus real fault/rejection/SMTP/
channel/startup checks without overlays. The mocked unit test proves only input
nonmutation; it is not native/runtime support evidence.

Approved portable c8d1f5d, foundations a11c0c8 and platform-io eb5d83d are merged
in a second sanitized worktree while the previous 558-file sweep remained frozen.
The sweep completed 14,835 edits/2,600,590 assertions with the same startup failure.

- Autorun uses real COMPLETE/workspace execution and errors. A transient argv
  array works around the compiler's lost mixed scalar/spread variadic prefix;
  original repro remains failing. CLI plugin orchestration calls an unreviewed
  helper and remains incomplete. Proper fix: general variadic segment binding and
  separately designed internal plugin orchestration, not invented public exports.
- Basic has all five parameters, real live allocation/heap ownership and exact
  replacement hooks. Metadata lookup is linear; raw default allocations avoid
  recursive instrumentation; temporary bump objects are not individually tracked.
  Unknown frees from other Basic configurations are allowed. Visualization is a
  real logger snapshot/counter transport, not a native GUI/remote protocol. Wider
  leak scanning, raw/runtime allocation coverage and reviewed transport remain open.
- Module-parameter defaults incorrectly resolved in the module namespace, losing
  file-private helpers. A new original non-Basic regression fails before and all
  40 module cases pass after binding expression homes to the declaring file.
  Basic's contextual constraint alias is now file-private as reviewed. Its old
  positive fixture incorrectly accessed that private name; privacy assertions and
  a rejection fixture replace that access while selected public Hooks identity
  and every allocation/callback assertion remain. Unused structural interface
  validation is still a real failing mandatory gate; no library-name check added.
- File has actual Win32 UTF-16 handles, 64-bit seek/read/write, mappings and checked
  cleanup retry, with shared convenience code over native backends. Host interpreter/
  O0/O2 and Windows x64/arm64 all-code checks pass. No Windows runtime claim. Native
  path namespace/length, known-folder identity and borrowed-wrapper policies remain
  independently chosen as recorded in platform-io questions/deviations.
- Windows font filename loading now delegates to the real File backend; its stale
  unsupported guard is removed for Windows. x64/arm64 all-code tests pass; native
  Windows FreeType/font execution remains required. Window runner now passes all
  128 source/program invocations; this includes target checks, not 128 native runs.
- One numerics run used the host's Python 3.9 and could not generate its cbrt oracle.
  Failure evidence is retained. Rerunning with installed Python 3.15 gives 107/123;
  no oracle approximation or assertion change was introduced.

Latest checkpoints: compiler 890329b, portable 8a0d40c, foundations 44cca8b,
bindings a565ab0, numerics 4acc846 and window 7fc1d6a are merged. Generic
metadata now unblocks all 24 host/19 WASI foundation cases at O0/O2; portable
production passes 92/92 ordinary cases plus faults/rejections and real SMTP/
shared-channel/process/startup integration. Real AppKit, window/event/clipboard
and GL texture/shader host tests pass. Safe caller-owned SDL2 RWops marshalling,
full lint/platform support, genuine compiler/IDE failures and opaque external
corpus remain open. Earlier rows below describe initial historical findings;
explicit refresh sections supersede resolved entries.

Correction: Basic.log is explicitly reviewed and missing. Its failing legacy
tests are genuine coverage; it is not an unreviewed convenience. Only stale
implementation-location assertions have been migrated, preserving both overload
and re-export navigation assertions. The latter reveals a separate real recovery
failure, retained in requests.

| Location | Observable effect / rationale | Evidence and risk | Proper fix |
| --- | --- | --- | --- |
| Producer test overlays and numerics tool bootstrap helpers | Reported passes use independently staged peer sources; numerics includes fixture Input/Window/Hash and host tool helpers. These are not integrated production proof. | Producer handoffs/status documents. Snapshot drift and ABI/identity errors can escape those passes. | Run unchanged tools and canonical-dependency suites against this production tree; retain staging evidence separately. |
| `stdlib/SDL/declarations.jai` | Reviewed public RWops/UserEvent shapes differ from native SDK storage. | Bindings report records 48/8-byte public versus 72/32-byte native records; active layout test remains failing. Undersized foreign calls risk memory corruption. | Complete private native storage and safe marshalling/diagnostics while preserving public contracts. Audit every affected foreign call. |
| Native binding aggregate layouts and open wrappers | D3D/ImGui/Darwin/rpmalloc ABI gaps and incomplete GL/X11/Objective-C/mobile/telemetry helpers remain. | `status/bindings-deviations.md` and declaration ledger. Emitted declarations do not prove ABI safety or runtime support. | Resolve reviewed shapes, implement complete forwarding/adapters and run pinned native probes on each target. |
| Basic formatting/configuration | Style-storage choice, missing generic-default reflection, unresolved rendering details, libc shortest-float search and ENABLE_ASSERT propagation remain. | `status/foundations-deviations.md`; latest Basic reviewed parameters need independent integration. Layout mismatch, locale/race/performance and incomplete compatibility risks. | Propagate reviewed parameters generally, emit real reflection defaults, resolve questions and improve measured conversion. |
| Portable runtime/platform modules | Native crash helper is pinned for process lifetime, build-tree deployment unverified, signal/alternate-stack ownership not restored; optimized allocator/platform/contract gaps remain. | `status/stdlib-deviations.md`, portable ledger/gaps. Existing staging tests do not verify packaging or all platforms. | Package relocatable native helper, review lifetime/ownership, implement missing branches and execute native targets. |
| `stdlib/internal/numerics` and UI facades | Missing concrete font/texture integration is diagnosed; current contextual types and editor sampling copies require audit. Rank-deficient math/UI/text/cursor/clipboard limitations remain. | `status/numerics.md`, corrective plan; fixture tests do not prove canonical integration. | Use combined Input/Window/Hash/Simp canonical types, real font metrics/texture ownership; retain explicit unsupported diagnostics pending contracts. |
| Window/render backends | GL constructors/framebuffer rendering and native Linux GUI/device/Windows tests remain incomplete. | `window-render-handoff.md`, coverage ledger. Physical hardware behavior cannot be established by typechecks. | Implement reviewed missing contracts and execute real native/device tests. |
| IDE recovery and verification | Fresh unterminated opaque regions are conservative; malformed statements are omitted only in IDE mode. Producer corpus has baseline errors despite passing edit probes. | `tools/lsp-validation-0171.md`. Recovery success is not application typecheck success. | Preserve strict compiler diagnostics and separate IDE selected-source admission; rerun against combined code. |
| SDL3 target coverage | Real native arm64 macOS evidence only; five native platforms/device APIs and integrated formatting pending. | `plans/sdl3-work-log.md`. Cross-layout checks are not runtime verification. | Build pinned native dependencies and execute all CI targets; run real integrated tools and normalized regeneration. |
| Full original public corpus | Local vendor implementations are opaque/forbidden inputs; original full-corpus verification cannot run here. | Explicit isolation instruction. Omitting vendor-free staging or claiming full pass would hide compatibility gaps. | Coordinator runs original corpus externally, returns filtered failures/minimal independent reproducers; local permitted staging records provenance. |
| Native verification / release | Windows, macOS x64 and hardware runtime unavailable locally; coordinator Focus checks outstanding, human review optional. | No CI dispatched or releases modified here; publication is on hold. | Coordinator reviews temporary branch CI, executes real targets and Focus checks before any publication decision. |

Avoidable integration workarounds will be removed and recorded with original reproducer and fresh results. This audit does not claim that no other deviations remain.

## Refreshed production checkpoints

The compiler, portable, numerics and window/render checkpoints in
`docs/integration-refresh.json` are merged. Earlier findings below remain historical
evidence and are superseded only where stated here.

- Binary32 intrinsic interpretation was decoding operands as binary64. A direct
  `sqrt(float32(9))` reproducer failed before the fix. Interpreter operations now
  use the IR result width; semantic checking rejects inconsistent unary signatures.
  Five Math promotion wrappers were removed in favor of real float32 intrinsics.
  The direct test passes interpreter/native O0/O2. This removes the precision and
  performance workaround without inventing an additional public intrinsic name.
- Reflected struct alignment was zero although layout knew the correct value.
  `sema/typeinfo.rs` now exports completed layout alignment; ordinary, packed,
  aligned and generic regression cases pass. Original Deep_Copy graph assertions
  pass interpreter/native O0/O2 and are promoted into the ordinary portable suite.
  Deep_Copy policy gaps in `docs/portable-deep-copy.md` still apply.
- Numerics now uses canonical Simp font/texture/effect identities, real font fields
  and texture storage, and implements Type_Indicator alternatives. Canonical
  production checks improve from 8/60 to 40/83; the expanded suite still fails for
  absent AppKit, unsupported target backends and Wasm libc formatting imports.
  Its native NSCursor identity and platform paths require further binding audit.
- Real compiler atomics replace the prior integration gap. Five focused core and
  four LLVM tests pass, including native O0/O2 and Wasm shared-memory contention.
  Sequentially consistent implementations may exceed requested weaker ordering;
  this is a documented performance policy, not a lock-free guarantee on every ABI.
- Public Windows wheel propagation now passes Windows x64 all-code typechecking.
  Native execution on x64/arm64 remains required. New private helper fixtures
  outside library-owned test directories fail strict privacy; move those tests or
  exercise public APIs rather than weakening imports.
- Reviewed POSIX.itimerval macOS x64/Android x64 shapes were regenerated with the
  actual formatter. macOS x64 then fails unknown timeval: its inventory says x64
  but the supplied shape section is ARM64-only. No cross-architecture layout is
  guessed. AppKit remains absent from the committed bindings snapshot.
- Four new portable modules increase declaration presence; Atomics, BuildCpp,
  Deep_Copy and Zip_File_Directory are not counted complete merely by presence.
- The original full-corpus and unavailable native/device verification remain
  coordinator work. Latest guidance makes human Focus acceptance optional;
  coordinator Focus build/launch and signed-wheel testing are still required.
  Release workflow execution/publication remains on hold.
- Direct inspection found Unix probe descriptors leaked at probing-thread exit,
  and failed fcntl setup was ignored. The per-thread channel now closes through
  ownership cleanup; failed nonblocking/close-on-exec setup closes both ends and
  rejects the transfer. Linux source compilation and native macOS protection tests
  are checked separately; Linux execution remains external verification.
- IDE facade aliases were classified as constants even after resolving to an
  overload set. Completion now classifies resolved procedure values/sets correctly
  and resolves simple exported aliases with normal compiler visibility checks.
  An independent alias regression fails before/passes after; the semantic suite
  improves from three failures to one. Querying facade metadata may resolve more
  aliases than before; partial-edit timing is checked without changing coverage.

## Direct audit findings and corrections

### Second refresh and source audit

- Compiler ec7e23e, foundations 44cca8b, portable 04205ed and window e7e719a
  are integrated. Context cleanup's runtime slots and stable deferred boundaries
  replace the earlier compile-time pointer selection. The merge retains IDE-only
  independent-statement recovery and strict compilation failures; no invalid
  recovered body becomes executable. Nine core context and one native/Wasm O0/O2
  backend regressions pass after scratch initialization correction (8cfb5a7).
- Reflection hiding procedure member types lost the required 0x8 marker. The
  source/member type is now retained and only the descriptor type is hidden;
  metadata keeps the marker and real storage offset. Focused red/green regression
  and the original procedure fixture pass. Canonical GL driver execution is still
  blocked by AppKit; it is not counted as verified by the marker test.
- Foundations now implements default ENABLE_ASSERT=true, conditional nested Buffer
  layout, assert discard and temporary overwrite stamping. Exact original integer
  arithmetic replaces libc numeric formatting/parsing on all targets. Deliberate
  shortest-float precision searching and limb allocations cost performance;
  stamping a retained page's unused tail may add bandwidth. These costs and
  remaining style-storage/punctuation/scan contracts are preserved in the producer
  deviations report. REPLACEMENT_INTERFACE/enabled debugging remain unfinished,
  although the latest contract is specified; the old missing-shape diagnostic is
  stale and must be replaced by real implementation, not treated as an oracle gap.
- The foundation checkpoint depends on generic parameter-default metadata absent
  from the committed compiler checkpoint. Production assertions fail in two
  positive tests, including native/Wasm. No empty/default metadata is fabricated.
  WASI executes 34/38 O0/O2 checks with real WASI imports only; the four failures
  are those two metadata cases. Producer 19/19 staged claims are not production
  proof for this snapshot.
- Nonverbose jailint can return zero after incomplete compilation. The foundation
  runner now requires verbose complete compilation and exposes three Windows-only
  files compiled as macOS roots. Full integrated lint retains these failures.
  No tool-only library patch, rule suppression or positive-suite deletion is used.
- Mail unnecessarily requested a second executable startup configuration just to
  use one_time_init. It now imports the configured runtime normally. Real loopback
  SMTP/MIME plain/HTML/auth/reject/TLS cases pass interpreter/native (ten cases).
  Explicit application runtime-flag conflicts remain diagnosed and questioned.
- Treemap has real stable buckets, weight traversal and squarified geometry.
  Zero default borders/east-north/half-open flush policy were chosen before review;
  latest specs now settle these and require an owner conformance update. Same-count
  weight changes still require display dirty/force; deep traversal is recursive.
- Cocoa native event pumping/notification observers are real; observers and
  cursor-policy registries retain process lifetime without public teardown. Raw
  committed text is supported policy; IME composition is outside the reviewed API,
  not a missing compatibility promise. Drag/drop/touch and other platform paths
  remain unfinished. Glyph-atlas kernel uses actual FreeType coverage/metrics,
  but public Dynamic_Font ownership/layout and GPU text rendering remain absent.
- Two additional private-helper fixtures were moved into library-owned test
  directories. Actual driver tests remain enabled. The production window runner
  aggregates failures and never executes a stale binary after failed compilation.
- New scope contains 100 of 135 module/bootstrap facades, 35 absent plus one
  supporting constant-table page. Presence is only a declaration inventory;
  it does not count complete modules or imply runtime/ABI conformance.

### Third refresh

- Approved compiler 890329b supplies canonical shared source generic descriptors
  and evaluated instance defaults. Required/unbound shared defaults retain explicit
  null type/-1 offset; instance defaults evaluate real prior bindings. This is an
  independent encoding using existing fields, awaiting compatibility review.
  It adds read-only metadata storage; failures propagate rather than dropping
  arguments. All foundation metadata/default-elision assertions now pass.
- Performance reports carry actual host timings, run/polymorph records and IR
  counts. This compiler has no bytecode inlining/dedup pass, so those transformation
  counts are zero. Anonymous run thunks may have null headers; actual wasm32 compiler
  hosts reject unavailable timing rather than manufacture durations. Browser clock
  support and anonymous-callee contract remain open.
- Unix shared-memory channels use real POSIX objects/native atomic storage, checked
  native mapping extent and captured creator allocator. All four interpreter/native
  process pairings pass 2,048 byte-checked packets each. Windows is unsupported;
  Linux execution, wire-format compatibility, pause/reconnect and failed-cleanup
  retry policies remain unverified. Absolute cursors, eight-byte framing/alignment,
  256-byte header and logical-size/name policies are independently selected and
  documented in portable-shared-memory.md. No original-wire interoperability claim.
- Shared-channel early failed producer tests left two unjournaled PID-named OS
  objects. Later tests journal/unlink only proven owned names and check cleanup;
  no global namespace sweep was attempted. Historical objects are not claimed gone.
- The runtime storage fixture is split into a positive configured-instance test
  and the complete original conflicting-import source as a required negative case.
  All original storage assertions remain. This corrects startup configuration
  alignment without silently accepting conflicting flags or claiming alternate
  runtime-instance behavior is specified.
- The new exchange-contention unit test was updated for the integrated intrinsic
  dispatch signature's floating-result metadata argument. Its full prior-value
  sum assertion and all 80,000 exchanges remain unchanged; no test overlay repair.
- Current presence is 101/135 facades, 34 absent, plus one constant-table supplement.
  Integration-certified complete modules: zero; this worker has not certified all
  reviewed behaviors/targets of any module. Supported subsets are measured by the
  actual suites, never by export counts or staged passes.

### Fourth refresh: native integration

- Bindings a565ab0, numerics 4acc846 and window 7fc1d6a are merged. AppKit, GLX
  constructors, public native windows, Keymap, shaders and mipmaps are real code.
  Numerics fixture Input/Window/Hash modules, duplicate Windows clipboard and
  formatter repair helpers are deleted. Canonical numerics passes 107/123.
- All 14 exercised macOS window cases pass interpreter/native O0/O2, including
  windows/events, clipboard, glyph coverage, texture upload/readback and shaders.
  Linux-target interpreter cases pass; Linux X server/GLX/device execution remains
  unavailable. Windows failures remain at the genuine File backend dependency.
- The staged compiler/patch path is removed. window_render_compiler.py builds this
  integrated checkout directly; staged repairs are not production evidence.
- SDL WM-info marshals complete private native storage into the exact public
  prefix, rejecting unrepresentable subsystems with real SDL errors and leaving
  failed output untouched. Adapter address differs from native-symbol address:
  an explicit safety tradeoff. Real canary/error/hidden-window tests pass. The new
  native SDK probe was omitted from the build selector; integration registers its
  pinned source closure, builds it and moves the private test under SDL/tests.
  Original ABI assertions are unchanged. Native test dependencies now use explicit
  library directories rather than worker-specific .work paths.
- SDL2 layout still fails RWops 48/72 and UserEvent 8/32. Caller-owned RWops and
  callback marshalling remain unsafe/unfinished; WM-info does not resolve them.
  Objective-C/AppKit host native tests pass. SetTitle's id/native-void result is
  unspecified as reviewed; no stable value is claimed. Provisional D3D/Darwin/
  ImGui/rpmalloc layouts and other native branches remain risks in the binding ledger.
- Direct audit: x11-events.jai uses a 64-byte XLookupString buffer and publishes
  non-control bytes as code points, a limited legacy-byte input path. Its
  set_custom_cursor_handling body performs no operation; the flag has no effect
  on Linux. Proper fixes are real native committed-text/context and cursor policy
  integration, followed by Linux runtime tests.
- Direct audit: gl-shaders.jai always prepends desktop GLSL 330; reviewed GLES
  300 es remains absent. Windows File/font support and reviewed retained-memory
  font/cache/atlas lifetimes are unfinished. Real glyph-kernel/GPU-driver passes
  do not establish public Dynamic_Font text rendering.
- Broad bindings retain 65 failed/unimplemented desktop and 58 alternative/mobile
  checks. Thirty-five Python tests pass. Symbols/cross-layout/GPU-export checks
  are not native/device execution.

- Removed the bundled-module unknown-parameter exemption in `crates/jaic/src/sema/modules.rs` and added general named/positional validation, including parameterless modules. Removed the fourth public Runtime_Support parameter; the build option remains a compiler target constant. Explicit runtime arguments no longer disappear. Original regressions failed before correction; all 39 module regressions pass afterward.
- `interp/probe.rs` cached mapping checks previously preceded raw copies/slice reads. Strengthening the original mmap/mprotect test to omit manual invalidation reproduced SIGBUS. Actual transfers now use Mach APIs, kernel pipe copying, Windows process-memory APIs or bounds-checked Wasm memory. All five probe tests pass. Comparison now snapshots both ranges, with allocation/copy overhead rather than unchecked in-place slices; this is a deliberate safety tradeoff. Windows/Linux native execution remains CI-required; mapping/protection changes may produce partial failed transfers, never a claimed atomic snapshot. Proper optimization: measured fault-safe chunked transfer without losing invalid-range ordering.
- IDE admission is now restricted to the exact explicitly selected source entry. Application internal imports and strict CLI entry rejection remain tested; no blanket source-policy weakening.
- Direct source audit confirms unresolved GetRect contextual empty records in `internal/numerics/render_types/module.jai`, absent Type_Indicator parameter, and metric/require_texture traps. Latest reviewed specs now provide Simp contextual identities; these are avoidable gaps, requested from numerics owner, not accepted functionality.
- Combined canonical numerics suite: 8/60 checks pass. Precision diagnostics, missing AppKit/unsupported Wasm Window_Type, and native C formatting imports are retained as failures. Foundations host runtime/format/lint passes, macOS x64 unused-code fails missing POSIX.itimerval. No platform skip list was changed.

- Original stdlib runner contained stale skip-list entries and aborted before available fixtures. It now retains each as a fatal inventory error and executes all 473 available tests first. Result: interpreter 258 pass/215 fail; native 250 pass/215 fail/eight compile-time-only. No skip entry/assertion/coverage was removed.
- Source-built quality check formatted and checked all 493 integrated new Jai files successfully. Verbose warnings-denied lint has 37/136 failed directory checks, mostly unsupported host targets, incomplete source inclusion and real API gaps; failures are retained in quality.json. No exit-zero partial compilation is counted as clean. Direct thread lint findings were corrected: unused CAS-success outputs for atomic reads are explicit discarded bindings, shutdown is documented idempotent, and duplicate thread-completion recording now asserts. Real thread lifetime/group/condition/shutdown tests pass interpreter/native.
- Bindings production runner now supports --stdlib with no peer staging, and records source/tool hashes. Full desktop/source/API sweep has 57 failed/unimplemented checks; alternatives/mobile configuration sweep has 58 failures. Unsupported-target results remain separate and are not runtime passes.
- SDL3 real integrated host tests pass ABI/headless/callback/entry, all 1,329 runtime exports and artifact hashes; GPU audit checks 95 exports, not GPU execution. Eighteen Python tests pass after creating their documented scratch parent. Regeneration currently detects stale contracts-macos-x64.jsonl; this remains open rather than accepting drift.
- Canonical Bootstrap Preload alias maps to prelude/module.jai. Inventory: 135 module spec pages plus one supporting table page; 95 module/bootstrap entries present, 40 missing. Presence never implies completed functionality.
# Refresh-nine safety finding: interpreter memory intrinsics

`crates/jaic/src/interp/mod.rs` still used unchecked host `ptr::copy` and
`write_bytes` for interpreted memcpy/memset after only a null-address check.
`interp/probe.rs::compare` ordered unreadable ranges as ordinary byte values.
An original child-isolated mmap/mprotect regression against combined production
sources reproduced signal 10 for both writes/copies and a fabricated -1 comparison
(`artifacts/integration-clean/memory-intrinsics-red.log`). This can crash the
compiler and misrepresent invalid program memory. The required general fix is
bounded fault-safe copying/filling/comparison through the existing kernel backend,
with explicit interpreter errors and overlap-preserving copy semantics. Implemented
using 4 KiB scratch buffers and the existing kernel transfer backend. All 155 core
unit tests now pass, including child-isolated protected transfers, unchanged
mmap/mprotect regressions, overlapping multi-chunk copies and zero-length calls.
The Windows VirtualProtect branch is present but awaits actual Windows CI.
Kernel transfers add system-call overhead per chunk; benchmark/optimize batching
without reinstating unchecked copies. Prior guarded-probe tests alone did not
establish intrinsic safety. `read_vec` also uses fallible capacity reservation;
this is not a guarantee against physical-memory exhaustion.

The merged strict module-argument check initially reported a missing required
argument before an unknown supplied name. General validation now declares the
complete header, validates supplied names/duplicates, then rejects omitted ordinary
parameters; late program parameters remain supported. All 50 module regressions
and both production runtime configuration regressions pass without test changes.

## Combined refresh eleven audit

- Runtime initializer previously forwarded the prelude constant instead of consuming finalized workspace size. Production allocation.jai rejected nondefault configuration before the fix (artifacts/runtime-config-production-red.log). The canonical internal/runtime now uses the private getter once for size/allocation, retaining cleanup/null/overflow behavior and exactly three public Runtime_Support parameters. Actual production interpreter/native O0/O2 and independently configured zero/131072 child allocations pass the CLI regression; staged overlays are not this evidence.
- Portable plist/Meow/bundle runners implicitly depended on repaired library overlays and peer directories. Removed those dependencies: explicit --jaic/--stdlib selects the combined production tree; their actual native execution is mandatory in the portable native suite on supported hosts. Earlier staging passes remain historical.
- SDL native-pointer proxy identified in refresh ten is removed by bindings 40e37e9. Actual native factory/BMP symbol identity and C observer lifetime assertions replace unsupported proxy callback assumptions. Public RWops 48/native72 and UserEvent8/native32 mismatches remain active unresolved ABI failures. Native regression rerun pending.
- SIMD internal/simd/lanes.jai still writes all-one comparison masks and extracts sign bits; latest reviewed SIMD contract requires scalar bool conversion and truthy-lane masks. Missing load/gather/scatter/looping/horizontal-add contracts are now specified. Owner request recorded; present facade does not establish complete compatibility.
- Compiler managed Windows thread creation ignores nonzero stack/security arguments and unknown flags. Default ordinary thread cases are not evidence for these inputs. Proper fix is actual native option handling or explicit unsupported diagnostics, preserving public signatures. Native CI thread output remains a separate real failure.
- Private ARM64 crash backend is now native-CI verified in twelve OFF/ON/default O0/O2 cases at e8c312d, not inferred from cross-compilation. x64 ON/default fault reports still fail, WGL shared lifecycle still fails, ARM64 real driver is OpenGL1.1 and cannot satisfy3.3; no driver substitution or skip-as-pass is acceptable.
- Linux ARM64 stat wrappers now explicitly marshal pinned128-byte kernel records into the reviewed144-byte public record. Raw x64 syscall constants remain unusable on ARM64. No local Linux execution; record-copy cost and untouched-output native-error behavior need actual Linux CI. Android target support, ImGui remaining layouts, X11 runtime and mobile native SDK execution remain incomplete as detailed by producer reports.

## Refresh twelve producer audit

- File_Watcher31e453e uses real native FSEvents callback queues and SDK-owned contexts, retaining the active public FSEventStreamContext ABI failure. Queue caps, overflow-rescan behavior, trailing-edge debounce, borrowed callback paths, by-value teardown and no recursive teardown/polling are independently chosen policies pending review. macOS only; Linux/Windows imports reject. Native helper relocation/cross-architecture packaging remains unfinished. Its runner's implicit peer/staged overlays must be removed before integrated proof.
- Window37d3839 replaces retiring Mesa drawables with actual native retirement windows/DCs of the exact pixel format. One share-owner surface/context is process-lived; each live renderer adds native handles. Cross-thread destruction and foreign HWND lifecycle remain gaps. ARM64 Mesa source builder is only plan/source-integrity verified here; native driver build/execution remains required. No3.3 fallback or fake GL claim.
- Platform2cdbd9b adds unique x64 DbgHelp sessions and checked private cleanup, original native lifecycle/first-step/named-symbol tests and exact own-output diagnostics. External DbgHelp/filter/error-mode changes require application serialization. x64 trace failure and real interpreter kernel-thread-handle interoperability remain unresolved; new cross-links are not native proof.
- Bindings4137f3c X11 dialog uses fixed geometry/core-font rendering and independently chosen Escape/WM-close policies; long text/accessibility/Unicode shaping and Linux actual execution remain gaps. DXC reflection has a real COM body but D3D12 forward-overlay failures prevent validating it; source declarations/C++ buffer probes are not completed Jai functionality.
- Developer-toolsa553de2: Generate_C_Header supports a documented C11 subset and rejects unsupported reflection shapes. Some emitted layout errors are deferred to mandatory C static assertions; transactional writes, String/Any projections and C++ output remain unfinished. Performance_Report uses actual compiler reports, independent rendering and quadratic stable sorting; actual-Wasm-host timing unsupported. Remaining eight owned modules are absent, not completed.
- Audio7d641f8 originally duplicated portable records/topology/accumulator and exported an unreviewed VBAP helper. Integration retains canonical generated records and one storage instance, adds the reviewed Cached_Ogg_Decoder shape, preserves sample null/bounds diagnostics and magic helper, and hides the new private VBAP helper. Panning tests use the public equivalent with all gain/identity assertions retained. Removed duplicate types unit.
- Audio's provisional squared/clamped gain curve contradicts latest reviewed sound-player.md. Original new0.5 regression failed; proper power-law formula now passes. set_master_volume no longer invents a nonnegative/finite restriction. The480-frame gain ramp is replaced with the reviewed1/30-per-second bound using actual private backend sample rate; uninitialized backend diagnoses rather than fabricating a sample rate. Device initialization has not been implemented, so update_panning backend integration is unfinished and is not counted supported playback. Controlled PCM mixing/panning remain a subset. Final-page clamp, no_overflow behavior, quaternion normalization, channel/mix-level integration and compressed/device lifecycles still need review/implementation. No audible output or all-target runtime proof exists.
## Refresh eleven executed follow-up

- The first full workspace run stopped compiling a new jailint regression because its Options initializer omitted the integrated target/source fields. Added explicit unset/empty options without changing assertions. The restarted suite executes all targets: aggregate697 passed/57 failed/one inherited ignored (includes child-process test output; see raw own log, not a unique-case count),12 failing targets. One failure was a stale expectation that canonical runtime sizes still reject; corrected it to require successful metadata/configured checks, retaining actual allocation and old-consumer rejection suites. Focused plugin/private-lint regressions now pass.
- Strict foundation lint now checks the native-unix #load fragment through its actual File parent, requiring checked-files coverage; this preserves Seek_Type and module identity without changing source imports. The cross-only predicate is checked on cross profiles. One deliberately binding-invalid scalar fixture must separately fail strict lint with its exact diagnostic; its body is not claimed checked. Current source still fails an unused basic-context side-effect import, corrected by the newest pending foundation snapshot. Behavior-only suite passes42 host cases in interpreter/nativeO0/O2,33 WASI casesO0/O2, misuse faults and seven target profiles; this does not replace the lint gate.
- Windows device decoding fixture loaded private internals from application scope. Moved it to stdlib/Input/tests and kept all original packet/callback/bounds assertions. Cross-host Windows interpreter execution then correctly failed unavailable CommandLineToArgvW. Pure packet assertions now execute via #run under each actual target layout, with real Windows program checks retained. This is compile-time decoding evidence, not Windows startup/device execution. Native notifications and issue1 tests remain separate real-Windows gates.
- A renderer attempt used target/window-render-native instead of the builder's actual target/window-native directory. Corrected invocation restores real host codec/clipboard/GL checks. Failed invocation retained; it is not attributed to production implementation.

## Refresh twelve verification refinements

- Actual unchanged jaifmt rebuilt against the combined production library.835 new/changed Jai sources passed format check before relocating the SDL fixture; that fixture separately passes format and strict lint. Workspace clippy/all-targets and actual wasm32 clippy pass; rustfmt exposed one integration runtime test, now formatted.
- SDL3 anonymous aggregate locations used Clang slash paths against Python native Windows paths. A new cross-separator original unit test failed before general normalization; all20 SDL3 Python tests and six-profile generation/idempotence checks now pass, retaining all1486/1488 layout assertions. Native Windows CI rerun remains required.
- SDL RWops regression also needed library-owned placement for private native ABI helpers. Removed its repaired .work library path and select the actual source-built native probe through JAIC_NATIVE_LIBS. Replaced opaque abort checks with the same diagnostic assertions. An initial interpreted run exposed a relative fixture path dependent on program working directory; the test now requires an explicit absolute argument and owns its C string. Actual interpreter/native/default and O2 factory identity, BMP, close observer, error and freesrc checks pass. Full SDK aggregate remains red for original public RWops48/native72 and UserEvent8/native32 assertions; no layout gate was removed.
- Source-built production WASI runtime allocation now executes and passes O0/O2: workspace65536-byte storage, original extent/data identity and last-byte write. This supersedes earlier statements that only a staged backend getter ran under WASM.
- The full portable sweep reports133/134 ordinary cases passing, all10 SMTP/TLS cases and four2048-packet process pairings pass. The plist fixture now prints supported real values; corrected its expected parsed dictionary instead of ignoring extra entries. Its independent plist/native bundle tests already pass. The2300-case interpreter oracle exceeded300 seconds under simultaneous debug suites; retain that failure and rerun with a source-built optimized compiler without dropping interpreter coverage or numerical predicates.
- Windows Shared_Memory_Channel and Socket public backends remain missing and fail the target matrix. File-visitation's symlink oracle uses POSIX.syslink and is Unix-only; Windows filesystem behavior remains required through windows-foundations and native platform CI. That single fixture is not counted as Windows behavior. Full module/target tests retain real missing-backend failures.
- Six skip-list rows named nonexistent files: GetRect_LeftHanded/tests/{geometry-tests,legacy-compatibility-tests,text-interaction-tests}, Simp/tests/{readback-tests,software-render-tests}, Sound_Player/tests/offline-mix. They are absent from the permitted independent baseline and current tree, and the runner reported each invalid ID. Removed these phantom inventory entries only; no actual test, assertion or skip was deleted. All480 original behavior cases remain required; earlier error evidence retained.
- The first refresh12 broad quality invocation enumerated an old moved SDL fixture from HEAD and failed its missing path; it is not a source-format pass. Freeze/commit current paths before retrying. Broad host-only lint still cannot establish target-specific/private fragment coverage; strict target-aware positive subsets and every real failure remain separate.
- An accidental all-lines LSP sweep was stopped after its first four completed files, retaining its partial log; it is not a full pass. The complete639-file sweep uses the established8 sampled nonempty lines per file with full IDE assertions, matching prior broad coverage. New moved fixtures require a follow-up path check. No public application corpus has been inspected or modified.

## Scoped unused-result cleanup

Detected45 unused-binding findings in private UI/archive sources. Removed unused
trailing results, retained underscore discards only when a later result is used,
and preserved every call (all-unused calls remain statements). A follow-up found
one now-unneeded released binding and removed it. No rule suppression, public
signature/default/type/storage or assertion changed. Archive strict lint and
original archive interpreter behavior pass. Nine existing UI suites are running
in interpreter/nativeO0/O2. UI strict lint has no remaining ordinary findings but
still fails its pre-existing default_overall_theme dependency; this is not a
strict lint pass. A minimal original self-address initialization reproducer and
proper lifecycle requirements are in integration-requests.md. The provisional
callback-only candidate passed; it is not falsely cited as a failure.
## Reviewed SDL oracle correction and final refresh12 results

Coordinator's latest explicit policy distinguishes required public prefixes from
complete native values. Corrected the impossible size-equality expectations,
retaining all five full-native records, exact public48/8 sizes/alignments, every
native RWops/User_Event offset/alignment/size, prefix offsets and actual C writes
with canaries. Added a private complete User_Event; no public fields/signatures
changed. Historical failures remain in sdl-sdk-refresh12*.json and earlier logs.
Production SDL verifier now reports zero failures; actual prefix test passes
interpreter/nativeO0/O2 and strict lint. This is host native and six source-target
evidence, not all-platform runtime or safe standalone public-native-value use.
See native/sdl-native-abi.md for extension/dependency rules and the representation
limit. Public callback fields still must not be treated as native C callbacks.

Optimized own-source compiler makes all2300 float oracle rows pass in all five
modes within the existing bound. Full portable134/134 ordinary cases pass; only
six Windows target failures remain (two visualization fixtures and Socket fd-set
on eachCPU). Socket check_fd_set itself is Unix-only per reviewed inventory;
Windows Socket backend is still independently absent and requires its own
reviewed fd_set/loopback fixture. Original target failures retained, no backend
success is claimed. Native fonts/glyph atlas/dynamic font/real GPU text rendering
pass21 additional source/program invocations with the caller's system Arial font,
without copying it into the repository.

Full partial-edit sweep finishes639files/17073edits/2762443assertions/zero failures.
This samples8 nonempty lines per file and exercises all IDE assertions; it is
not full application compilation/runtime. Changed SDL fixtures/private ABI need
the separately scheduled follow-up. Broad quality finishes833files with52/171
failed checks and source_stable=true: ordinary target/body failures remain,
including actual unused results in UI/archive. Those source cleanups are being
verified in the own secondary worktree. No blanket lint suppression was added.

## Refresh13 reviewed merge

Compiler995685c adds general Windows asynchronous unwind attributes and LLVM
synthesis defaults before/after optimization for all definitions. Two linear
sweeps add unbenchmarked compile overhead; no fake frame or optimization disabling.
Real Windows unwind/stack execution is pending. The platform named-fault fixture's
unconditional lookup assertion for a genuine O2 leaf needs ABI-aware correction;
do not manufacture a nonleaf to satisfy it.

Portable2355943 now matches settled SIMD truth-based comparison/mask, byte-offset
load/gather/scatter, looping indices and full horizontal pairs. It preserves
reviewed source defects in docs rather than emulating uninitialized results.
Scalar-left noncommutative symmetric policy remains unresolved. Pool CAPS and
runtime heap static names follow the reviewed null-data query contract. Adopted
private runtime transport matches the integration protocol; kept our canonical
initializer and deleted startup wrapper rather than reintroducing superseded
paths. New standalone runtime test runner now selects production --stdlib and
source-built --jaic, without repaired overlays or byte-equality staging demands.

Nine existing UI suites pass45 interpreter/nativeO0/O2 invocations after unused
result cleanup; archive original behavior and strict lint pass. UI has no remaining
ordinary lint finding but its pre-existing circular global diagnostic remains.
LSP parse-refactor test referenced three absent legacy flat library paths.
It now scans actual independent autorun/plugin/bundle implementation units with
the same every-line/range edit parsing assertions and >10 offered actions.
All21 refactor tests pass; no missing Example_Plugin export was invented.

Authorized candidatea78721d only changes native ARM64 Mesa developer-shell/isolated
pinned Python setup and documentation. Integrated those workflow changes without
push/dispatch or superseding coordinator's long-running native build.

## LSP project-settings notification timing

The resilience fixture discarded didOpen responses, then required the sole
malformed-project notification specifically at completion. Current semantic
project discovery correctly emits it earlier while opening the main document.
The test now collects config-open/main-open/completion messages, still requires
exactly one jai.toml unknown-setting diagnostic and requires no repeat on a
second completion. All four resilience tests pass. No server diagnostic is
suppressed, no malformed configuration is accepted, and no assertion is skipped.
## Refresh14 code audit before merge

- Compiler3084377 transfers a real std::thread kernel handle into GThread and
  exposes it as the scheduler key; native naming/HRESULT/LocalFree are genuine.
  Duplicate suspension/resumption explicitly rejects unsupported alias scheduling.
  Ordinary duplicate waits/exit queries remain native, while managed queries use
  scheduler completion/result. Source thread_main returns Rust unit after recording
  the Jai result, so native duplicate exit-code/completion equivalence is not yet
  established; full native entry/alias lifecycle needs a proper compiler fix.
  Existing unfinished-worker parking retains OS workers after VM teardown, though
  owned handle references close. This is a resource/lifetime gap, not complete
  Windows thread interoperability. Native runtime regression is still required.
- Portable Flat_Pool uses real generic mmap/mprotect or VirtualAlloc operations,
  public256MiB defaults, page rounding and OR reset flags. Commit failure returns
  null with no cursor advance. Page-size queries per commitment and allocation
  prefix ownership are independent policies; Android/console validation missing.
  Windows_Utf8 uses real Kernel32 two-pass conversion, active allocator, explicit
  failure cleanup and flags0 native replacement policy. Host source checks do not
  establish Windows execution.
- New clock-calendar.jai places clock_gettime inside assert. Basic's reviewed
  disabled assert discards its argument, which would silently return epoch/zero
  under ENABLE_ASSERT=false. Flat-pool.fini similarly puts essential unmap inside
  assert. These avoidable side effects must move outside assertion evaluation;
  retain diagnostics and native failure handling. Production red regression and
  correction are required before the time increment is counted supported.

Refresh14 correction: clock queries and Flat_Pool release now execute outside
optional assertion arguments. Native query failure returns APOLLO_TIME_INVALID
after the diagnostic, rather than fabricating a zero clock if assertions return
or are disabled. Failed unmap retains pool ownership fields for diagnosis/retry.
The original time-assert-disabled regression failed against the actual combined
production library at its realtime lower-bound assertion; the same interpreter
case passes after correction. Native O0/O2 and strict tool reruns remain pending.
Flat_Pool imports the default Basic instance, so no claim is made that its old
release defect was reached through a public disabled-assert configuration.
- Foundationad84008 resolves path-fragment matching and report-owned lifetimes;
  scalar FNV and unsigned-division exercise remain actual positive API failures.
  Do not reclassify those as accepted negatives. Revised fields/guards still
  require latest reviewed contracts and producer implementation.
- Bindings204f6f6's BMP close adapter preserves the SDL-owned stream pointer and
  C convention while converting full64-bit nonzero freesrc to native1. Its
  function address necessarily differs from the SDK symbol; only the actual file
  factory retains symbol identity. This is a documented ABI boundary, not a
  reintroduced stream proxy/context registry. Update the earlier invalid BMP
  address-identity expectation while keeping all stream/lifetime assertions and
  adding high-bit close flags. DXC source/ownership/COM checks remain blocked at
  public D3D forward overlays and need real Windows execution, not private-unit
  passes counted as public support.

## Refresh14 editor recovery and verification corrections

Source scope lookup used strict import admission even while collecting IDE facts.
An unrelated missing anonymous import hid an otherwise valid overload reexport.
lookup_import now retains/deduplicates the real diagnostic and continues
independent lookup only with editor facts enabled. Direct admission and ordinary
CLI lookup remain strict. Existing links regression retains the missing-module
error, canonical aliases, nested reexport and all other links. It distinguishes
one selected call overload from both overloads at an uncalled alias; resolving
calls exposed the old two-target expectation as incorrect.

Member completion uses the existing compiled_before cache when all source
before the receiver and every other open file match, retaining current symbol
offset adjustment. Changed declarations still trigger compilation. All three
links and all24 semantic tests pass; full recovery/privacy suites remain next.

Browser jai/source test formerly required a #load token in the public Basic
facade, which now uses canonical imported aliases. It decodes JSON and requires
byte-exact complete current facade content, using existing pinned serde_json
solely as a test dependency. No runtime dependency or library overlay is added.
The focused browser source test passes; complete browser suite still has a
genuine WASM Thread backend gap.

Foundation lint stopped before behavior tests on required positive API
failures (scalar FNV and division diagnostic). The runner correction retains
each failed target and missing coverage as final failures while continuing other
targets and behavior checks. An independently executed behavior/cross run of
unchanged production code also preserves both positive failures. Neither run is
called a full strict-lint pass.

## Native check safety and private runtime transport

Avoidable guard suppression is removed: LLVM no longer gates function null
checks on the presence of an optional public export. A checked file-private
compiler/runtime hook supplies genuine reason/operand/location diagnostics;
ordinary exports and private imports remain strict. Runtime-disabled guards
explicitly trap. Missing/malformed hook failures now propagate; no silently
ignored lookup/body error is accepted. Full rationale/evidence and concurrent
output-fragment tradeoff: ../compiler/private-native-checks.md.
Existing native diagnostic/pointer-invalidation/arithmetic suites and new
runtime-disabled O0/O2 regression pass; strict scoped Jai lint and workspace
clippy pass. Broad full suite is still running, no production-wide green claim.

Private transport audit correction: the first full safety run completed with
706 aggregate passes/53 failures/one inherited ignored test, including six new
failures caused by requiring the extension in minimal custom runtimes. That
requirement exceeded the reviewed public contract. Absence now uses an explicit
native trap fallback; malformed/present hooks still diagnose. Original50module,
four runtime-config and five library-root cases plus two new strict transport
cases pass. No tests were weakened. Production's real private reporter remains
present; native guard/diagnostic tests retain their assertions. The full run's
failure evidence is preserved at secondary artifacts/workspace-native-checks.log.


## Reviewed-test migration checkpoint (2026-10-15, integration role)

Explicit user-authorized replacement retires143 inherited stdlib compatibility
fixtures plus one tracked object artifact, preserves328 source/assets (296
compiler including37 helper modules,14 native including one MPEG asset,9
Extensions,9 graphics). Per-file hashes/reasons and consumer changes are recorded
in stdlib-test-migration.json. No stdlib/Extensions implementation was changed.

Operational Rust/Python/Node/workflow/release-fixture/PGO reads use new paths.
Legacy skip and numeric coverage baselines are removed by authorization;
reachability is informational and cannot establish functionality completion.
Standard CI runs reviewed contracts, compiler/Extensions/ABI/graphics/module
catalogue and separate NEW producer suites against actual production. Windows
ARM64 graphics execution follows actual Mesa build; pinned PyYAML6.0.3 added to
its isolated environment. These workflow edits are prepared, not CI-executed.

Executed evidence:6 catalogue/negative-runner unit tests PASS; precise Hash
privacy rejection and positive baseline PASS through contract and aggregate
runners; sweep negative PASS; native C++ hidden-result-pointer original fixture
PASS O0/O2; C structs-by-value real C test PASS with explicit overlay assertions.
Source-built unchanged jaifmt rewrite/check PASS59 contract/adapted ABI files.
Strict positive-contract jailint originally FAIL49files: two legitimate fixture
lint findings corrected (assert actual first locator, remove redundant alias);
storage-time missing seconds_since_init requires pending portable checkpoint,
not a tool repair. Original failure evidence retained.

Audit/risk/long-term work: retired generator wrappers are no longer compatibility
gates; full reviewed tooling coverage remains incomplete. C++ regression disables
only Clang's return-type-c-linkage warning because an intentionally C-named
C++ non-POD return tests ABI; native result/value assertions remain strict.
Ordered-atomics compiler regression now declares own intrinsic protocol directly,
retaining LLVM order checks plus exact result; no unreviewed Atomics API added.
Long-double presentation casts narrow only formatter arguments, retaining every
wide C ABI/precision comparison; generator-only tail is retired. Struct overlay
formatting no longer assumes an omitted reflected field, while all scalar/array
overlay values are asserted.

Remaining verification: full replacement catalogue and producer/native/browser/
Rust workspace checks still required after pending stable merges. Generic
module fixtures requiring font/SDK helper arguments need actual preparation;
their failures remain visible, no fabricated inputs/pass substitution. Some
producer drivers/builders remain macOS/POSIX-specific; source matrices do not
establish native Windows/Linux execution. Browser reports explicit unavailable
foreign/native SDK cases separately, never passed. Root contract coverage is
bounded, not equivalent to deleted suite or complete reviewed API coverage.
Coordinator alone runs opaque original public corpus, Focus and ordinary native
CI. Release/publication remains held. No push/dispatch performed.


Portable0c09ce4 audited/merged as5eb5149: primitive private clock kernels preserve
configured Basic canonical Apollo_Time; real first-call CAS elapsed storage,
native CPUID/mask queries and actual Windows mapping/extent/cleanup bodies.
Preserved prior Windows thread completion/readback/assertions and production-only
test drivers over incoming staging overlays. Retained old native Meow regression
plus both NEW producer vectors against production (no peer copies). Public Basic
Buffer remains removed; nested builder type retained. Calendar normalization/
sentinel/assertion and Pool unmapping-option gaps have precise public reproducers
in integration-requests.md. Windows native runtime remains unverified.

New independently spec-authored storage-time and scalar-Hash nativeO0 cases PASS.
Formatter case initially FAIL only because its manifest still expected ok after
reviewer added print_bytes: actual4 ab newline agrees exactly with basic.md line521.
Manifest now includes those bytes, retaining all formatter assertions. This is a
test harness oracle correction, no production change. Original failure log is
artifacts/integration-clean/reviewed-foundations-O0.log. Complete rerun pending.


Audio11bc663 source audit/integration: real SDK-owned C output/byte accounting,
queue/seek decode, phase-independent locks and bounded256frame mixing are
present. Existing canonical records/topology/accumulator retained over duplicate
producer types/storage; retired decoder list now lives only with synchronized
cache. Private VBAP helper remains file-local, using reviewed greatest-minimum
selection; superseded first-containing-arc path removed. Gain step reads actual
initialized backend sampling rate and asserts positive, with no invented1Hz
fallback. Producer verifier accepts explicit production compiler/linter/library/
native paths and performs actual Windows target lint.

Panning test setup correction: producer test called a nonpublic helper; earlier
integration adapted it to a public helper before a backend existed. With real
backend, that helper correctly routes an uninitialized output as stereo, so the
old isolated6channel expectation is invalid setup. Exact unit-direction VBAP
assertion is moved (and strengthens other-channel-zero assertions) into the
existing controlled-output fixture only after actual6/8channel native init.
No private export invented; stereo panning/topology identity tests remain. Actual
multichannel execution is still required, never counted from this source edit.

Detected operational-assertion risk: player.jai shutdown join, decode-queue.jai
join/wait, vorbis.jai open/seek actions occur inside assertion arguments. Sound
currently imports default asserted Basic, but this pattern risks disappearing
actions under future/default check changes and unsafe continuation on join/seek
failure. Exact owner follow-through requested in integration-requests.md; not
called completed error-path support. Native close failure retains C callback
storage but Jai can drop its handle if caller assertion handling continues:
potential resource leak; proper retryable ownership or unconditional fatal
diagnostic needed. Audio's source-present213rows are not integration-certified
complete. OS hardware/focus/hotplug, Linux/Windows execution, spatial numeric
choices, one-worker throughput, per-device snapshot retention and package
adoption limits remain as enumerated in producer audio-deviations.md. No fake
audio/clipboard/font/native success substituted.


Bindingsa476d25 audit/merge: FSEvents public context order is marshalled to a
complete SDK Context (s64version theninfo andCcallbacks); SDK copies synchronously,
native retain/release manage info. Public signatures/types unchanged. D3D canonical
dependency imports replace wrong d3d_compiler direction; no compiler symbol/path
bypass. rpmalloc has separate generated pinned native SDK records and reviewed
private contextual Heap/Span records; default-profile wrappers call actual native
alloc/realloc/free and copy full native statistics field-by-field into public
layouts.14 procedures are partial across configurations, not80 complete APIs.
Unsupported raw/heaps/callback/config/profiles still diagnose rather than silently
using the default archive. Native global state across module instances remains a
lifecycle/isolation gap; only default profile MacCPU execution reported by producer,
not Windows/Linux. Pending callback crash repair is not in this stable checkpoint.

Incoming native-bindings/sdl-layout fixture duplicates our relocated canonical
stdlib/SDL/tests/sdl-layout.jai. Keep the canonical fixture: every new public/native
field offset/size assertion is already covered there, with additional native
alignment and guarded payload writes. Remove duplicate stale relative .work probe
path; actualSDK event push/poll payload canaries from producer sdl.jai retained.
Public48/8byte prefixes and complete private native sizes are distinct reviewed
contracts. Scalar64bitclose normalization/factory identity remains. Historical
invalid full-size oracle evidence stays; no undersized Ccall or public ABI change
substituted. Actual combined native SDK rerun remains required.

Producer status tail still lists older116unresolved/80rpmalloc, while new coverage
ledger marks partial default wrappers; source inventory is not functionality
certification. Strict target lint/configuration/native execution gaps remain.
Private test placement must remain byte-identical inputs and not library repair;
production-source stability/cleanup and bindings generator idempotence need rerun.


Tooling9b6c482 audited/merged scope: source-built official libclang C/Jai ABI,
CXIndexOptions u16bitfield/size24/pointer8,16, cursor/types/strings/callback models,
finite numeric macro probes and enum groups, CodeView/DWARF subsets, kernel-
mediated Debug readability. No reference compiler/std bodies used. Public native
model ordering comes from independent responsibility groups; aggregate/enum/ABI
order preserved. Public version21 remains reviewed compatibility constant while
actual official SDK23 supplies the supported native backend; exact header/native
source hashes are recorded, not full21SDK conformance.

Removed avoidable host-specific test/build setup: official SDK prefix now uses
explicit DEVELOPER_TOOLS_LLVM_PREFIX, compiler LLVM_SYS_231_PREFIX or actual
llvm-config; missing SDK diagnoses. Shared native fixtures use real macOS dylib/
Linux PICso flags/names, retaining identical C ABI/behavior assertions. No hardcoded
Homebrew path or Linux-as-macOS command remains. Native Windows tooling is still
unsupported, explicit builder diagnostic; source target checks are separate.

Unfinished/reduced behavior remains producer-reported: Bindings_Generator supports
one C header/library, rejects unsupported C++bridges/bitfields/variadic callback
mutations/string/function/nonfinite macros and options; macro probes reparse per
macro (callbacks can double cost), include snapshots not atomic; no fabricated
constants. Header generation rejects unsupported overlays/multiple returns/etc,
layout mismatch may surface at Ccompile rather than pregeneration. Its runtime
support-descriptor fixtures still use reviewed test-only records and are not
production bootstrap identity proof. Rewrite uses byte coordinates/quadratic
sorting, skips unwritable string inputs and has non-atomic write TOCTOU risk.
Print_Vars byte widths/eager temporary storage and Performance_Report quadratic
sorting are deliberate. Debug has bounded little-endian DWARF32 subset, real
readability kernel syscalls, unsupported architectures/backends remain explicit.
Iprof has caller-supplied reports only, no fabricated instrumentation/samples;
Codex metadata and Check semantics remain subsets. Full1630declaration inventory
is not full behavior support. Producer tests independently authored but separate
root review remains pending. All current production/Jai/native/ABI/regeneration/
lint verification remains required; no staged producer pass counts integrated.


Window1f66dc1 integrated as8e920639. Real Meson child-discovery and LLVMcache
receipt/configuration/corruption/partial-install tests:8PASS in prepared local
venv with Meson1.8.3/Mako1.3.10/MarkupSafe3.0.3/packaging25.0/PyYAML6.0.3.
First invocation with bare systemPython failed because Meson was absent;
dependency setup corrected and original failure retained, no assertion weakened.
This is host build-tool regression evidence, not ARM64Windows driver execution.
Cache hashes selected public SDK/compiler/tool binaries and installed LLVM tree,
rejects symlinks/stale/partial changes, persists completedLLVM before Mesa; no
driver cache reused. Hashing full SDK/tool trees costs startupI/O deliberately.

Filtered coordinatorCI9d87e76 reports fuzzPASS and SDL3Linux/macOSfourCPUsPASS.
WindowsSDL3 stops beforeCcompile at hardcodedVSdiscovery (SDLowner fixing).
Windowscompilerlink stops at kernelbase.lib SDKattribute (compilerowner fixing),
so follow-onruntime steps are not independent behavior failures. ARM64Mesa source
download timed out beforebuild; no native driver evidence from that attempt.
No rawvendorCIlogs read and no release/push/dispatch performed.


Portable41a015a source audit/integration: actual Winsock startup/error/option/
keepalive/close calls, correct native millisecond policy, direct foreignFD_ISSET
identity and descriptor-array semantics. Preserved existing POSIX nullcheck safety
in moved backend; no lost FD_CLR/word-width assertions. Windows helper drivers
now accept explicit actualcompiler/productionstdlib and do not copy partial
producer overlays. Native Windows execution remains required; no runtime success
from body checks. Signed ioctl output uses realu32encoding thenuncheckedbitcast
tos32; typed wordlocals avoid producer-reported cast/shift-width observation,
whose exact language precedence needs oracle review before calling it a compiler
defect. No special symbol/path lowering. Missing CMSG/bitfield/native shape families
remain explicit. Native close failure is logged then invalidates caller handle,
with documented resource risk per wrapperpolicy; not silently counted success.


Refresh17 production verification completed against7aec510: fullworkspace85
result summaries742aggregatepass/32fail/one inheritedignored, ninefailedtargets;
counts include child-process summaries, not unique tests.1052ownedJai format/
check PASS; strictlint58/187checksFAIL, source_stable=true. Full root contract
batch52/54PASS initially: duplicateBase64local(valid) is a fixture syntax error,
and Sound.skip_this_output_channel was accidentally moved into file-private scope
during integrationhelper relocation. Both corrected without changing assertions
or addingexports; original failures retained. DuplicatecompleteSDL.User_Event from
two independent ABI patches caused SDLsource checks to fail; one identical layout
now retained. Root implementation regression, not an invalid ABI oracle.

Default assertion CLI reproducer exitsSIGABRT under-interp because NEW runtime
calls realC.abort while the old compiler hook expected an obsolete private name.
Proper correction: optional file-private runtime assertion transport selects the
actual callback procedure by identity and validates exact canonical location/
string/bool/Jai-context signature plus ordinary native body. Interpreter installs
its existing structured fault operation for that procedure; native code retains
the real Jai body. Custom callbacks execute unchanged; no public export/module
parameter or filename/symbol-specific library bypass. Native reporter discovery
shares the general private-extension resolver; obsolete name-based assertion
hook removed. Private runtime_entry is #no_debug, suppressing only bootstrap
frames through existing semantic metadata, not display-name filtering. Source
CLI regression (default/compile-time assertions and custom continuation) PASS;
three protocolprivacy/validation cases plus51module/two nativehook/fourruntime
configuration cases PASS. Full diagnostic/native regression rerun pending.

NativeSDK fulldependencysetup FAIL at stale GitHub X11mirror tag404. Manifest
already pins officialX.org1.8.12 release+header hashes; builder now verifies/
extracts release beforeusing per-file bytes, preserving both hashes and all-input
validation. Three transport/cache/corruption units PASS. Full retry hit official
server connectionreset: stillFAILED, not called a productiondependency pass.
Scoped actualSDLprobe builds PASS; scoped actualrpmallocSDK/statlayout/FSEvents
probe builds PASS. One ownedFSEventsprobe warning uses deprecated but public
ScheduleWithRunLoop API; no warning suppression applied, not a-Werror pass.
FutureSDK removal risk remains; retain ABIcoverage and add modern dispatch-path
coverage with an explicit narrow deprecation policy. Source archive cache also
needs complete transitive-header tree integrity validation beyond current pinned
primary files; no source-wide SDKconformance inferred from scoped builds.

Refresh17 final focused results: four private interpreter protocol tests now
include proof that the native callback body still typechecks; four CLI scenarios
cover default/compile-time faults, explicit #no_debug unwinding and custom
continuation. Existing module/native-hook/runtime-config60 tests passed before
the fourth protocol case was added. Workspace clippy warnings-denied PASS.
All54 public contracts PASS interpreter/nativeO0/nativeO2, including precise
negative checks (not54 distinct native runtime effects). Scoped formatter/check
PASS after rebuilding actual unchanged jaifmt. A fragment-only audio lint attempt
failed missing its loaded-module constants; failure retained and context-complete
run required. No incomplete lint is called success.

Native verifier found stale relocated SDLfixture paths before execution.
General canonical module-owned test resolution replaces filename-specific routing;
three input-placement tests prove fixture ownership and exception-safe restoration
of existing sources/removal of temporary dependency directories. Runtime checks
now restore private placement on failure/success; no private exports promoted,
fixture bytes unchanged. RealSDLverify PASS30target/24privacy/299symbol/nine
native-interpreter phases using actualproductionstdlib/source-builtSDK. Full
all-dependency validation remains blocked by officialX.org connectionreset.

Root Audio contract setup was corrected to provide actual loaded in-memory PCM
when testing successful buffer bounds, as required by reviewed Sound_Player:
default UNINITIALIZED/no-storage data cannot establish successful buffer bounds.
Default-value assertions remain before the mutation; bounds checks now assert
actual backing-storage identity. Original failure evidence retained.

Follow-up to refresh17 SDK/cache and audio lint entries: avoidable transitive
archive cache gap removed by extracting the entire hash-verified archive afresh
on each preparation, then replacing the cache tree. Modified transitive headers
and injected extras are covered by a regression. Deliberate extractionI/O
tradeoff; future optimization can compare complete verified manifests, never
only primary headers. Seven transport/placement regressionsPASS. OfficialX.org
network failure remains; no full-pin build success.

Context-complete audio lint exposed duplicate get_magic4 implementations from
integration, with identical signature/bounds/encoding; retained samples.jai
version with stronger diagnostic and removed loading.jai duplicate. Actual
scoped loaded-fragment/runtime/SDL/contract lint nowPASS with warnings denied.
Whole-tree58failedlintgates remain historical/currentuntilrerun, not declared
resolved. Default Audio publicskip helper visibility andSDLUser_Event duplicate
are included in the integration correction checkpoint, not producer blame.

## Refresh18 producer and independent integration audit

Consumed source snapshots: portable eab3383, bindings fc6c681, audio498046b,
developer-tools af8b5f4, SDL3 0b2dc3c, coordinator CI e223538. Compiler native
repairs6904b4a/049e997 and cast observations were integrated through approved CI
cherry-picks, retaining our private assertion transport29ec8f9. Every producer
progress/deviation/handoff report was read; implementation inspection additionally
found the following integration defects or limits. Later ready checkpoints are
queued, not credited here. Extensions outside SDL3 remain byte-identical.

- internal/audio/panning.jai: integration had also privatized reviewed public
  add_vbap_gain_for_direction while moving its body. Restored the existing
  signature/body to public scope; no new API. Source/signature fixtures now
  execute. Audio manifest now explicitly includes our perceptual power-law
  regression, rather than bypassing strict discovery. Actual27cases PASS
  interpreter/nativeO0/O2, six-target bodies, owned format/lint and three privacy
  checks. Real silent SDK2/6/8streams opened in all required modes; no physical
  channel placement/latency or Linux/Windows runtime claim.
- audio lifecycle/native adapters: essential waits/seeks/joins are unconditional,
  failed close ownership retained/retried and unavailable state no longer
  reports initialized. Injected failures surround genuine SDK resources, distinct
  from OS-generated failure/hotplug proof. Owned-audio assertion-disabled copy
  staging does not establish a globally configured production library; real
  Thread assertion dependency remains open with active owners.
- rpmalloc callback-context/rpmalloc-callbacks: per-call TLS context frames,
  copied native names and synchronized signed-offset mapping metadata are real
  adapters; no public record cast into C. Process-global SDK, spin-lock/linear
  registry/malloc per mapping and two C frame calls per operation are deliberate
  lifetime/performance costs. Error-location policy/profile isolation remain
  limited. Full canonical public heap/span operations remain missing; native
  field-layout probes are not API completion. Production scoped SDK build PASS;
  verifier36source/96privacy/tennative phases PASS plus six missing-public-name
  failures retained. Nondefault/raw configurations remain required gaps.
- developer-tools clang/model/MSF/debug: actual39fixtures/C/C++ consumers PASS
  on host, real MSF stream tools and Windows cross-built Debug ABI separate.
  Hardcoded producer LLVM prefix replaced with existing general configured LLVM
  discovery; new shared C fixtures use platform shared-library flags. Windows
  Debug cross helper remains macOS-hosted MinGWx64 only; Linux/Windows fullhost
  orchestration not certified. Scalar aliases/locations/null-C++ diagnostics do
  not establish full1630-declaration support. MSF wire subset supports only
  validated sizes/streams; staged byte-copy wire tests are private-unit evidence.
- SDL3 generated files: narrow LF attributes and UTF8byte writes remove actual
  CRLFhash failure, not a platform hash exemption. 31generator/nativehelper
  unitsPASS locally; prior real sixprofile/SDK producer evidence distinct.
  Native Windows compile/runtime and all95GPU operations remain CI gates.
- portable Pool registry: active source keys first-use by Pool address; returning
  Leak_Report by value leaves a stale record and later allocator-null fault.
  Original foundations assertions retained; exact active-owner request supplied.
  No caller-address patch/layout change/value-return prohibition accepted.
  Calendar native normalization/text and Socket CMSG/TCP/Windows scope bodies
  integrated, but selected Unix test classification is not Windows runtime proof.
  Registry constants/ConvertToApollo remain missing despite settled review.
  Android ABI naming is tooling only; compiler Android target unavailable.
  Full source/native/strictlint coverage for253 missing public rows is absent.
- jaic-llvm/partition.rs: address escape prevented counting single-caller bodies
  in inline-growth estimates, exposed by unchanged optimized_split regression
  after runtime procedure metadata gained address references. Conservatively
  account for sole direct callers regardless of additional address references;
  noinline cuts now bound that expansion. Existing two optimizer result/IR
  regressionsPASS. Possible extra conservative noinline cuts are a performance
  tradeoff; benchmark after correctness, do not infer native speedup.
- Objective_C forwarding: general scanner now follows explicit native #foreign
  aliases and checks every discovered literal, replacing obsolete old-layout
  count thresholds. This exposed genuine NSThread native selector typo.
  Generator uses official Foundation header spelling, retaining public API;
  three alias/arity/runtime tests PASS with805 distinct native method pairs.
  No baseline exception added. Dynamic selectors/local receiver class inference
  remain explicit test limitations, not full Objective_C completion.
- corrected compiler test oracles: LSP accepts both direct Math namespace import
  and reviewed Codex.Math reexport, applies both edits and checks no errors.
  Null Any boxing now tests compiler address/type representation directly rather
  than obsolete printer abort behavior; explicit null read still diagnoses.
  CLI color tests remove inherited NO_COLOR before forcing color; actual NO_COLOR
  precedence test retained. New private allocation path and actual cycle/assertion
  diagnostics replace old path/wording expectations. Full diagnostics25PASS,
  LSP namespace PASS, IDElayout4PASS and browser assertion transport PASS.
  No compiler error relaxed or production fake default introduced.

Actual broad evidence retained: workspace755aggregatePASS/27FAIL/one inherited
ignored, sevenfailedtargets. Production quality1107formatted/checkPASS,
strictlint56/190failed, source_stable=true. Catalogue394cases: interpreter306/
83pass-fail, native300/82 plus7compile-only, WASMinterp237/130, WASInative230/130
plus7compile-only; eachmode five precise negatives separate. WASM native-only22
unavailable each, not passes. Catalogue dependencies were incomplete; specialized
SDK/font runners are required and many compiler/stdlib gaps remain real. Window
first158/18failed because real test probes not built; after source-building own
window-native, production188invocationsPASS with real hostGL/clipboard/fonts.
No failed initial run hidden. New fullpartial-edit sweep1086ownfiles running,
excluding all public corpus/vendor directories. Opaque applicationcorpus/Focus/
crosshardware remain coordinator gates; no publication/push/dispatch occurred.

Refresh18 retained regression migration follow-up:
- tests/extensions/extensions-long-double.jai explicitly casts only presentation
  arguments to float64 and checks type identity directly. All wide arithmetic,
  mantissa/rounding/range/reflection/C-varargs assertions remain; four wide target
  interpreter scenarios PASS. Basic's current formatter supports IEEE32/64
  rather than arbitrary extension floats; this is an explicit capability gap,
  not a production narrowing implementation or full wide-formatting claim.
- c-callback-threads fixtures follow reviewed thread_deinit completion precondition
  for positive lifecycle calls. The compiler deadlock fixture now uses direct
  documented SDK thread create/join signatures and condition-variable waits:
  public thread_is_done is timed polling and macOS public Semaphore uses opaque
  libdispatch waits, so those do not prove scheduler-blocked-state diagnostics.
  Two attempted polling/dispatch variants stalled and were terminated explicitly;
  original logs retained. Neither is a passed test. Actual kernel-wait variant
  PASS preserves both immediate Jai join deadlock and C-callback grace timing,
  exact positive outputs and native callback execution. A60-second watchdog
  now kills/states a hard failure on reporting stalls, never accepting timeout.
  Missing C compilers fail both touched Ccallback tests instead of optional skip.
  Native Windows/Linux execution of the new SDK fixture remains CI-required;
  current supported hosts/targets are64bit, pthread_t/uintptr ABI accordingly.
  No fake handle, unreviewed Thread export or native callback adapter added.
- backtrace caller regression removes unreviewed Debug.USE_GRAPHICS parameter;
  exact same frame-depth/deallocation assertions PASS nativeO0/O2.
- unsupported Compiler requests use current precise scope/user-segment/type-table/
  custom-link precondition diagnostics and reviewed one-argument link completion
  signature, still require every case to fail. Six-case CLI test PASS.
- broad source compile/lint/matrix failures remain. The25diagnostics,4IDElayout,
  namespace edit resolution, browser negative assertion, two optimizer tests,
  three selector tests and focused native callbacks/backtrace are actual focused
  results only. No new all-workspace total inferred from them.

All private source/header/probe substitutions remain labeled. Source pins,
C ABI guards, native foreign errors, public visibility and old failure evidence
are retained. No global lint suppression, test disable or release action.

Native custom-link/crash gate follow-up: retained two actual custom-link cases
now set the reviewed Message_Phase.linker_exit_code then call the one-argument
completion API. All original object-count/path/IR/frame-pointer/native execution/
missing-completion/failure assertions remain; failure runs a real child exit3
rather than inventing a native linker result. Both tests PASS. Variadic array
append/spread is retained unchanged; an attempted ordinary slice append was
correctly rejected because the reviewed overload is variadic, not a slice API.
No compiler workaround or unreviewed overload was introduced.

Crash-option/minimum-OS fixture now raises actual POSIX SIGSEGV through the SDK,
rather than assuming a guarded constant null store reaches the OS signal handler.
It checks native stack presence exactly when enabled, actual frame addresses and
crash message, plus unchanged Mach-O minimum12.0. Native host gatePASS.
Original explicit-null guard tests/protected mmap/mprotect regressions remain.
The old expected 'fatal runtime signal' wording belonged to replaced private
reporting; current native stack assertions test observable behavior, not a fake
signal/no_abc bypass. Cross-native Windows/Linux gate remains required.

## Refresh19 audit and exact remaining gates

At7dc08ed reviewed fullworkspace:767aggregatePASS16FAIL/oneinheritedignored,
fourfailedtargets. Partial-edit1086ownfiles finished28772edits3285512assertions,
two reproducible recovery failures (SDLwrappers tailtyping and valid changed
#add_context scope); full ownreport retained and precise requests supplied.
No public corpus/vendor directories were read. Actual source-built RustWASM
modulebuildPASS; realNode scripting gateFAIL at tour's native-only Thread import.
ReferenceThread targetguard remains strict. Basic.exit is reviewed POSIX/Windows,
so unchanged Extensions.Args/Io have a WASI integration dependency; do not invent
prelude/global exports or weaken POSIXguards to hide it. Proper own-WASI extension/
backend or supported tool integration requires an explicit reviewed design.

Independent compiler ISA audit confirms severe preexisting substitutes in
crates/jaic/src/sema/asm.rs: RDRAND andRDSEED share scrambled CycleCounter output
and fabricate CF=1; RDTSCP AUX is hardcoded0. These are not real instructions/
entropy/serialization and cannot count as support. Risk: false entropy/status,
wrong CPU-ID/timing and ordering. Proper fix: separate actual ISA IR/backend/
interpreter operations with CPUfeature checks/carry failure/realTSC_AUX and honest
unsupported diagnostics. Compiler owner is actively implementing this general
fix; CPUID's separate real implementation remains tested. No new workaround
accepted or synthetic instruction credited. Await stable committed replacement.

Target/context compiler4de36d6 integrated with one shared Options clone/target
selector; obsolete parallel target fields removed. Existing --os/--cpu aliases,
WasmCPU spelling, additional programsource injection and checked-files output
remain supported. --manifest records complete/incomplete contexts and actual
visited/unvisitedfiles. All jailint unit/CLI/rule/newtarget cases PASS aftermerge;
38 producer cases plus preserved root features, no incomplete-check success.
Root runtime-configuration regression still selects production library when
available, preserving isolatedfallback only for producer-only dependencies.
Strictprivate imports/configuredmodule bindings and childworkspaces remain.
Full lint runner must adopt these contexts; old56/190failure report remains,
no green whole-tree claim from scoped tests.

FSEvents verifier source-placement fix preserved private imports, then actual
native build caught producer .work-relative testlibrary dependency. Fixture now
uses system-library lookup via explicitrealSDK directory. Original failure
retained; corrected native rerun pending. This is private ABI test input placement,
not a repaired productionlibrary overlay or completed public watcher proof.

Pool reviewed refinement now rejects set_allocators based solely on non-null
block_allocator.proc and preserves descriptor/options across reset/release.
Earlier first-use-history interpretation/addressregistry is superseded and
avoidable; portableowner must remove it at the representation layer, preserving
by-value returns and publiclayout. Original leakreport fault retained. No fresh
caller-address registry or extra public marker accepted.

### Integration worker: partial-edit harness probe isolation

Location: `crates/jai-language-server/examples/support/edit_coverage.rs`. Previously the synthetic tail declaration directly followed edited input; valid truncated directives could consume it and invalidate the claim that it was independent. Observable effect: two refresh18 failures, reproduced by the new generic test. Fix: an empty statement separates the probe from the original source, outside all edit ranges; all source cuts and typed/symbol/definition/completion/token/hint checks remain. Risk: probe construction is synthetic and cannot certify every recovery situation; original source scope-change checks remain independent, and the full sweep must rerun. No missing assertions are accepted. This is a corrected test construction, not production compiler support or a corpus pass.

### Integration worker refresh20 production-source and producer audit

Pool: removed the entire address-keyed use registry at `internal/allocation/pool.jai`; exact reviewed non-null allocator-field guard now survives reset/release and ordinary by-value returns. Original leak-report and new ownership tests actually pass on the production tree. Thread: essential Unix SDK calls are unconditional; successful join/semaphore cleanup flags retain ownership on failure. Windows checks/handle ownership remain preserved through the merge. Partial group initialization/clock failure remains explicitly fatal because these void APIs cannot return usable partial state; group work-list destruction is not transactional. This is documented producer behavior, not a tested recoverable failure guarantee. Proper follow-up is transactional lifecycle cleanup and real native platform failure testing.

`tools/check_integrated_lifecycles.py` replaces staged Basic-default rewriting for integration proof with reviewed Compiler.remap_import and a test module reexporting canonical public Basic(false). All50 actual interpreter/ARM64/x64 O0/O2 executions pass, including real Mach destruction failure, exactly0 versus1 optional assertion-handler calls and retained cleanup state. All production Jai source hashes remain unchanged. Initial harness mistakes (anonymous imports do not reexport; CLI CPU selection needed a triple; -check forbids child executable output) are retained in separate failure logs; corrected use of named using imports and -interp implements the actual public mechanisms. No production body was copied/repaired.

Compiler ISA audit: implemented batch now emits/executes real timestamp/AUX/random/CF/fences/prefetch/PAUSE; all15 focused integrated tests plus9 floating-literal/intrinsic regressions pass. This ARM64 host cannot execute x64 ISA directly; capable RNG hardware and native Windows/Linux execution remain unverified. Interpreter CPUID probes add serialization/overhead; raw native callers remain responsible for CPU/OS capability. Existing unrelated synthetic rdpid/xgetbv/MXCSR and unsupported cache operations remain explicit gaps. General forward enum dependencies remain a real Socket blocker, with a new original reproducer and owner request.

Developer producer audit:56 real fixtures pass on the combined library, actualC/C++ round trips/scoped lint included;1176 SDK layout/enum comparisons and360 symbol resolutions are distinct from invocation coverage. C++ bridge accepts only supported external global declarators; configured SDK compiler paths need destination regeneration. MSF7/4096-page copying and finite binding equivalence retain explicit subsets, malformed-input safety policies and allocation/quadratic traversal costs. Iprof history storage/stack inspection are implemented; actual timing/instrumentation remains absent. Source SDK23 execution does not certify SDK21/platform runtime.

WGL helper387efe2 enables actual Windows targets and validates mapped driver images/dependencies;16 infrastructure unit tests pass here, no native Windows renderer pass inferred. Optional SDK-search-path repair and SDL3 Windows CMake layout repair are approved but missing from available refs, requested precisely. Fuzz separate lock metadata is integrated;12 locked/offline harness/replay tests pass. Release workflow remains tag/manual only; ordinary integration branch push triggers read-only tests/artifact workflows, with no publication authorized. Historical release rebuild wording in release.yml is incompatible with the current hold and is not authority to execute it.

### Integration worker: target-aware lint coverage limits

Location: tools/check_cleanroom_quality.py and tools/cleanroom-lint-contexts.json. The first runner incorrectly unioned clean source visits across targets for its aggregate uncovered-file list; now target_coverage_gaps explicitly retains inactive/unvisited files per required profile. Six protocol tests pass; no cross-target inference is accepted.368 actual existing sources supply2576 jobs, with shared path factoring only. All-seven-profile requirements are conservative until reviewed conditional applicability/negative-test classification/configured callers are fully recorded; these missing requirements are not all production defects. Expanded checks run concurrently with subsequent legitimate integration edits and tool rebuilds, so they are diagnostic only and must rerun at a stable checkpoint. Deliberately invalid test roots cannot be credited as clean body lint; their precise diagnostic/positive-baseline coverage remains separately required. No rule suppression, test exclusion or artificial library context is introduced.

### Integration worker refresh21 native regression/API migration

Location: tests/compiler-regressions/over-aligned-allocation.jai. Removed only the unsupported assumption that every arbitrary raw byte count>=64 guarantees64-byte alignment. Typed New/NewArray/dynamic-array/local/page alignment assertions stay; raw storage/prefix preservation is checked on every resize. NewArray's separate allocation-base result is now released instead of freeing a potentially adjusted view. All eight original native compiler/ABI fixtures pass. POSIX sentinel test now explicitly casts reviewed macOS raw-pointer SIG_IGN/SIG_DFL into the real handler type, preserving pointer-bit/constant-storage comparisons. No public ABI change.

Location: tests/native/windows/runtime.jai and tests/native/stdin-lines/main.jai. File existence comes from reviewed File_Utilities; thread_start is a void operation whose effects remain checked by completion/counter4000. Stdin uses actual File.file_read over public SDK handles (fdopen/GetStdHandle); fixture-owned line splitting replaces an absent read_stdin_line export. Every read status/count is checked, including EOF, CRLF, empty and final unterminated lines. Both native tests pass; native Windows execution remains coordinator CI rather than host proof.

Location: crates/jaic/src/build.rs. Canonical reviewed preloaded get_current_workspace #compiler dispatch was absent, causing a runtime-primitive trap inside #run. It now shares the real private CurrentWorkspace transport. New identity fixture covers global/procedure-local compile-time calls and unique empty children without hardcoded public numbering; original native empty-workspace regression passes. No language/module/path bypass.

Location: internal/basic/scalar.jai and internal/runtime/module.jai. Native assertion output formerly printed frame names without locations, and the formatting helper lacked an explicit #no_debug marker despite the macro's caller-facing contract. Locations now use real metadata/node line numbers; all available nodes are walked, without guessed elision by name or unconditional head removal. The private helper explicitly hides its own metadata. Exact old textual prefix/relative-path formatting was not reviewed and is no longer an API oracle; native frame depths, real caller line, helper hiding and failed termination remain asserted and pass. No public signature/default/type/storage change.

Resolved SDK deployment tradeoff: the SDL3 package preserves the official installed SDK layout and materializes symlink aliases as byte-identical files alongside compiler-facing aliases, intentionally duplicating library bytes for portable extraction. Four relocated native consumers pass locally; source/archive/layout hashes remain enforced. WGL optional missing search directories are fingerprinted as missing, while selected ARM64 SDK headers/libs/tool binaries remain required and checked for search shadowing;19 helper tests pass. Actual broader Windows WGL is still not green, per filtered coordinator report.

### Integration worker: refresh21 runner correctness and remaining verification

Location: tools/stdlib_runtime.py. Combined stdout/stderr falsely failed the successful malformed-lexer test; streams now remain separate and exact expected diagnostics are declared in the contract manifest. Positive contracts require both expected channels, and missing-main/no-executable classifications require a separate successful strict source check. A timeout cannot become compile-only. Cleanup failures now propagate. Two original loose-classification regressions fail before the correction; stdout/stderr regression and all9 runner tests pass. This is stronger verification, not a library/tool-body staging repair. The complete54-case contract subset rerun passes49 positives plus5 precise negatives in each interpreter/nativeO0 mode. Earlier394-case broad run (313interp/308native positives,76/74 failures,7 compile-only,5 negatives each) is retained diagnostic evidence, including the false lexer failure; it ran during edits and is not stable final proof.

Location: tests/compiler-regressions/int128-arithmetic.jai. Old private-file load and unreviewed wide-struct arithmetic/equality/shift operators are not the reviewed Basic API. Named multiply/divide/overflow/logical-shift/conversion checks remain, using fixture-local limb equality. Original private operator cases1,2,3,5,14,15,16,20 are explicitly retired in the migration ledger, not claimed supported. Signed-byte to_u128 is now a separate precise compile-time rejection with a successful public-helper baseline. Interpreter/nativeO0/O2 helper executions pass. Protocol reflection fixture now uses actual public imports; its missing comparator still fails, with behavior precision requested rather than guessed from the legacy test.

Location: Socket reviewed macOS addrinfo. Earlier integration handoff incorrectly called the public declaration unavailable; current reviewed inventory includes it. Classification is corrected in place; ABI test remains required. Exact Jai reflected field types are missing from the shape section, even though official SDK C layout is available. No other-platform surrogate, unreviewed field mapping or test retirement is used.

Location: native/channel-create.c and Basic visualization verification. Canonical fixed-name shm_open exclusive creation fails with SDK errno17; unique own channel succeeds. Existing ownership is unknown and no existing object data was opened/read/reclaimed. Actual canonical test remains failed; no public-name rewrite, memory-only channel or exclusion substitutes. The diagnostic only removes objects it acquired exclusively, and separately checks both close/unlink calls. This is an environment/resource gate requiring coordinator isolation, not an implementation pass.

Location: six portable MPEG fixtures. Migration left relative paths pointing at the retired tests/stdlib asset directory. They now resolve the unchanged6144-byte authored MPEG input in tests/native-regressions; size/payload/PTS/malformed assertions remain. The previously blocked PTS fault now reaches and reports invalid MPEG timestamp marker. Full portable rerun is required; no fixture bytes or decoder checks changed.

### Integration worker refresh22 audit

Allocator builder (`tools/native_bindings/build_rpmalloc.py`): static-only output
left stale shared libraries and interpreter calls failed on new facade symbols.
Both native entry points now use one builder for matching static/shared domains;
shared callbacks link their matching SDK, preserving allocator ownership. macOS
uses @rpath/@loader_path; Linux uses SONAME/$ORIGIN. Actual host public heap
interpreter, native link/run and relocated interpreter execution pass, including
a directory containing spaces. The first relocation omitted the real
callback-context dependency and failed; the complete dependency set passes
without loader overrides. Linux execution and Windows packaging/runtime remain
required platform gates, not inferred successes.

Allocator producer78d73e86/9106bfb6 code/report audit: separate canonical public
Heap/Span images copy real native counters/atomics/list membership and retire on
SDK unmap with operation leases. Full graph copies, linear association lookup
and per-domain serialization are deliberate performance costs. Metadata OOM
still aborts; transactional handling/finer publication need proper follow-up.
The pinned public C SDK page-rounding patch is hash-recorded, preserves SDK
assertions and needs native reserve/unmap tests plus eventual upstream repin.
Callback leases/deferred frees do not establish arbitrary reentrant mutation or
generation safety for released/reused pointers. Private FIRST_CLASS_HEAPS=false
is authorized independent packaging, not a reviewed public default. Other public
option profiles and generic/dump operations remain gaps. Staging is not proof.

Heap verifier: stale native counter-probe archive caused a genuine link failure
and then a missing-executable crash. Fresh source-built probes fix the link;
failed launches now remain failed report rows and checking continues. Missing
declared temporary directory and stale cleanup-API test caller are corrected.
Public module lint inventory is captured before temporarily placing standalone
ABI programs; every program retains its own strict --context check. No body
coverage is removed. All70 bindings Python tests pass after cleanup correction;
the complete heap sweep must rerun. Original failed reports are retained.

Module-default identity is resolved by the reviewed written-argument-list rule:
implicit/explicit equal defaults are distinct instances. The independent test
now verifies distinct type/storage and repeated-list canonical identity, and
source checking passes. Effective-default normalization would be incorrect.

Quality runner (`tools/check_cleanroom_quality.py`): added-files-only selection
missed modified existing fixtures. Modified/renamed/untracked owned tests now
participate. Before/after snapshots recompute scope and capture HEAD, tools,
configs, runner and context manifest; any drift fails. Regression tests cover
edited fixtures, added scope and replaced tool bytes. This repairs verification,
not library behavior; full target/context lint remains incomplete.

Latest producer audits: compiler457dc048 tests real browser host providers while
retaining Thread's reviewed target guard. Portablecc63d8d6 implements real
ASN.1/ADB/Java/app/manifest work; SDK/device execution, captured-output lifetime
questions and bounded definite-length/tag parsing remain explicit. Developer
3b3ff6e5 preserves SDK return discrepancies, MSF4096-page subset, bounded alias
traversal and quadratic line-range validation; Iprof instrumentation and broader
native execution remain absent. Newly reviewed Debug_Info sentinel aliases need
regeneration/verification. Window39404f30 repairs bounded pinned download retries
(28 helper tests pass), not renderer execution. Filtered CI retains ARM64 xxhash
intrinsic and x64 native test-library failures. Native resources and original
opaque corpus/Focus acceptance remain coordinator gates.

### Integration worker refresh23 audit and production results

Compiler6080ff0a enum dependency implementation retains declaration/reflection
order and ordinary dependency cycles. Structural expansion whose implicit
predecessor depends on that expansion still diagnoses rather than seeking an
unreviewed fixed point. Core6/backend1 focused tests pass after merge; native
Windows/Linux and full-corpus proof remain separate.

Socket mutable facade aliases formerly used immutable `::`, causing host reads
and failing storage/visibility requirements. The generator now emits explicit
anonymous filtered using imports. General compiler export registration was
missing for that parsed form and is fixed without changing constant semantics,
public names or storage. Red regression retained; all52 module tests pass.
Actual production resolver, SDK storage identity/mutation, interpreter/native
both Mac CPUs O0/O2 and strict lint pass. Staged candidate patch is removed;
verifier now compares regenerated bytes and consumes Root stdlib directly.
The older claim that this was a mutable-constant language requirement is
superseded; see compiler/foreign-data-reexports.md. Full ABI still fails missing
reviewed Mac hostent shape; no different-platform proxy or assertion removal.

Data/resource producerb1c6b1a5: only its five scoped source commits were consumed,
without importing base integration history. Every public declaration is present,
but declaration count is not functionality certification. Code/report audit:
ICO uses real pinned stb resize with reviewed zero padding; pixel filter details
remain a narrow question. Package views borrow separate TOC/payload buffers and
preserve first duplicate lookup; malformed inputs are safely rejected. Subtitles
intentionally emits raw HTML/CSV section columns. Windows transactions check
update/commit/discard results; actual native mutation/discovery/Icon remains
unverified here. Compiler option buffers deliberately survive the compiler
process, costing retained memory. Image WASI lacks actual native dependencies and
is not certified. Proper follow-up: native Windows CI, reviewed pixel/path/help
precision and measured lifetime cleanup where API ownership permits.

Data runner initially hardcoded its native dependency output in the Python wire
consumer, ignoring the caller's real library selection. Explicit --native-libs
now configures both actual Jai and C SDK consumers; source-built tool paths are
explicit options and Root stdlib is mandatory. Complete host/WASI/SDK wire/target
lint/check suite passes with no source overlays. Native Windows jobs register the
same suite with real pinned SDK DLL construction and resource/+Icon readback;
workflow edits are unexecuted native preparation, not Windows proof.

Latest reviewed Debug_Info sentinel values regenerated normally; all seven
ID/TYPE/RECTYPE values are present, with zero unresolved generator aliases.
New canonical-name/u16/value fixture is in the full developer suite; typed
CodeView byte parsing remains incomplete. Earlier missing-value questions are
resolved, not carried forward as blockers.

Full default-profile production heap sweep passes71 checks, including host
ASan/UBSan safety/page-granularity probes, six desktop public C layout targets,
actual private counters/callbacks, scoped format/lint and70 Python tests. This
uses unchanged Root production library and explicit private false profile; raw
enabled production-profile/full options and other native OS execution remain
required. Failed intermediate evidence is retained. No staging pass is relabeled.

Extensions6b0f2229 dependency changes are verified by their producer but remain
separate due to the explicit preserve-Extensions user rule versus mailbox scope
conflict. Original failing gates remain enabled; no stub/extra Basic export or
compiler exception substitutes. Coordinator must resolve that authorization
boundary. Full quality target applicability, broad catalogue, current-head
partial edits, native targets and opaque corpus remain open.

### Integration worker: authorized Extensions lifecycle correction

Coordinator's latest AGENTS clarification authorizes dependency migrations as
normal new Extensions history. The earlier preservation hold is resolved; approved
6b0f2229 is merged normally. The producer coordination mailbox is removed from
the product tree in a follow-up commit; the initial merge message overstated its
immediate omission, and that removal is now explicit. No history was rewritten.

Audit found `assert(Thread.thread_init(...))` and
`assert(Thread.thread_is_done(...))` in Io runtime/ownership. Optional assertion
discarding removed essential preparation and completion waits. A real
Compiler.remap_import/Basic(false) regression reproduced zero completed workers
and invalid lifecycle diagnostics. Calls now execute before optional assertions.
Failed preparation/wait logs and exits1 even when assertions are disabled; these
void APIs do not return a partially usable worker set. Thread-record storage uses
public uninitialized NewArray, checks allocation before Initialize and releases
the allocation-base result. This retains explicit process-fatal resource failure;
transactional recovery is not claimed, and arbitrary user callback side effects
cannot be rolled back. Production default behavior already terminated on such
assertion failures. A recoverable API would require an independently reviewed
error/partial-work protocol, not ignored failures.

Ten actual interpreter/native ARM64/x64 O0/O2 worker executions pass under both
assertion profiles with all production Jai hashes unchanged. Strict configured
context lint and format check pass. The first native candidate lacked its real
portable_crash runtime library; building that dependency from its own C source
fixed the link. Earlier parent invocation used runtime -- arguments instead of
metaprogram -, and the first test used an unexported qualified atomic_load;
corrected public atomic_read and command-line handling retain the red lifecycle
evidence. No test-only library body/default rewrite or compiler bypass is used.

Io_Uring producer uses canonical sequentially consistent atomics, stronger than
the prior acquire/release/relaxed calls. This may cost barriers/locked stores;
kernel mmap/syscalls/record layout and assertions remain. Actual Linux kernel
runtime remains required; host caller-memory handshakes are only userspace
publication evidence. Native ARM64 xxhash source-guard repair is integrated with
exact pinned-source validation; full Windows execution remains a CI gate.

### Integration worker: refreshed allocator/tooling/native audit

Bindings7eafe15f implements the reviewed generic mode table and real immutable
counter captures. STARTUP intentionally ignores initialize's return per the
reviewed contract; this is not a claimed success. Six native domains now include
both raw-base layouts; increased native caches and prior graph-copy/serialization
costs remain. Snapshot calloc failure is transactional and marks builder.failed;
formatting outside the SDK lease preserves allocator reentry and prior prefixes.
Separate heap/span association metadata OOM remains fail-fast. Private PRETTY_PRINT
true is independent packaging, not a public default/parameter. Host default-profile
production verification passes169 checks on the merged library. The initial raw
profile runs186/187: only a unit test incorrectly requiring the baseline false
selector fails under explicitly selected true configuration. It now validates
the requested profile from explicit verifier input, still requires false for the
unconfigured baseline and still rejects public parameter invention. No program,
diagnostic or assertion is omitted. C sanitizer recovery is disabled so reported
UB cannot produce a passing exit. Native Windows/Linux and other options remain
unverified; production native packaging still needs integration beyond this host
SDK builder and source pins.

Developer8554e42b audit adds genuine measured manual profiler zones, literal client
setup, finite Codex metrics and initialized MSF bit maps. Manual profiler state
is process-lived/default-allocator owned, stores stable borrowed Zone pointers,
has MAX_DEPTH100/MAX_HASH_SIZE65536 bounds and includes first-hit/native-clock
overhead in measurements. Automatic instrumentation/history/report/graph paths
remain absent; no tracker/history defaults are counted as measurements. Codex
IF/CASE/resolved Basic forms diagnose unsupported weights; unique-node traversal
is quadratic in worst case. MSF helpers require initialized in-range caller maps,
support 4096-byte big-map reserved positions only and leave growth/rover policy
unchanged. Real Windows profiler/debug cross-builds are not native execution.
The full prior61-fixture suite predates these additions and must rerun.

Native build repaircad699d4 is consumed through1d9885f3. Its one verified v0.7.0
preprocessor guard selects existing portable multiplication on Windows ARM64;
all four original source hashes and the exact guard anchor remain required.
Five policy tests and full official static/shared Mac vectors pass; actual
Windows vector execution remains required. This is a documented pinned C build
patch with unbenchmarked performance, not a fake __emulu or changed hash ABI.

Mac network database records now follow the synchronized exact reviewed shapes.
Normal generation preserves field/enum order and canonical facades; original
full host C ABI test passes after the four missing Mac variants are emitted
(rpcent was already present). No other-platform surrogate or ABI assertion change.

Root3b50fee6 full workspace is819 passed/10 failed/one inherited ignored. Full
owned partial edits pass1178 files/31214 edits/3423923 assertions. Broad400-case
catalogue finishes315 interpreter positives/80 failures and310 nativeO0 positives/
78 failures, five expected negatives each and seven native compile-only cases.
That includes six newly discovered data-suite programs requiring their prepared
inputs or Windows host; their specialized production suite already passes, but
generic catalogue routing still needs correction rather than calling those
misconfigured invocations compatibility defects or disabling the tests. Genuine
remaining failures (including Json cleanup) stay visible. First O0/O2 catalogue
attempts failed ENOSPC; only own reproducible incremental/superseded compiled
caches were removed, retaining all sources/evidence. O0 retry completed; O2 must
rerun. These counts are for the older Root, not the newer candidate.

The explicit raw-enabled production sweep now passes187/187 after the profile
expectation correction; the normal packaged false selector is restored byte for
byte. This does not add further option coverage or native platform claims.
# Native Mac measurement limitations, 2026-10-15

Fresh shared baseline7467b49d combines portable70eb7fb0, compiler328b6c46,
profiler8a284119, tooling4d3a1106, model4675c90a and platform943637d9 through normal
merges. Generator/Token_Info/Library_Symbols have one canonical definition/load.
Worker-specific staged model-query scratch was excluded from product tracking;
producer reports remain evidence, not integrated test passes. Portable Default,
Project and Example verification drivers now select actual production stdlib
and never read peer working trees or patch facades/load lists. Their old staging
composition is not final proof. Default -no_check behavior executes real child
artifacts/callbacks; whole-module lint still exposes missing Check.get_plugin.
Project behavior/XML/ownership checks run, but full lint fails unavailable sandbox
_NSGetExecutablePath. Example's production O0 workflow and strict lint pass.
Natvis is an explicit negative, not stored-only successful emission; other
unsupported compiler settings remain limits. Profile selection is explicit and
does not claim O2 when O0 was selected.

Json numbers completed unchanged in isolation under the refreshed compiler:
149.449 seconds, exit0, exact ok stdout, empty stderr. Original120-second timeout
is retained; the catalogue's existing180-second default is unchanged. No numeric
assertion or sweep size was reduced. Six merged graphics cases passed all12
interpreter/native ARM64 O0 executions at032b0793, with native clipboard guard.

General Mac FFI correction: native main-thread routing was activated only after
Objective-C/NS/CGL/selector symbol-name hints. A library with opaque names could
call Cocoa first on the compiler worker. Actual SDL reported No available video
device despite three real drivers; compiled native execution initialized normally.
A library-neutral C pthread_main_np regression failed before the fix and passes
after. The name activation gate is removed; existing loaded-image affinity policy
applies from the first call. Original SDL WM now passes interpreter/native O0 and
all19 CLI tests pass. There is no SDL/module-name exception or dummy video path.
The existing system/libc++ direct fast path and non-root/fork handling remain;
unknown library calls conservatively pay main-thread handoff cost. Per-image
classification is cached. Native library TLS/errno interaction across execution
threads remains a broader policy risk; do not infer full native-thread identity
conformance from GUI success. Proper follow-up is general affinity/context tests,
not more symbol-prefix exceptions.

Remaining detected producer tradeoffs include64-level limits in cpp typedef/name
and type-emission traversal, conservative partial overload equivalence, ASCII-only
identifier policy, diagnostic Iprof graphics callbacks and borrowed libclang file
handles. Exact producer paths/limits are documented in generator-model/platform,
developer-tools-deviations and profiler-codex-workflows. Avoidable traversal limits
need cycle-aware replacement; unreviewed equivalence/context/graph behavior remains
in questions. No module-completeness count is inferred from declaration presence.

Merged Mac repair snapshots: Extensions34c06fa3 and graphics7a5cce7a, through normal
merge commits e026e5f3/b99d2f02. Latest reviewed specs/guidance are byte-identical
to the saved authoritative copies. Producer mailbox was excluded from the merge
index before committing. Extensions parsing delegates slow conversions and
float32/subnormal formatting to public Basic APIs; transient output allocations
are freed. Shared formatter comparisons are not independent numeric oracles;
native strtod/strtof bits and fixed spellings remain independent checks. Empty
error paths and keys have real ownership cleanup. Http/Io use sequentially
consistent canonical atomics, a stronger-order cost. Http elapsed time uses an
explicit checked 128-bit subtraction, not an unreviewed Apollo operator.

Graphics uses the canonical NSString byte-length initializer via getTempString,
not an invented selector. Native notifications are retained across pump boundaries
and released on consumption; queue capacity and the observer remain process-lived.
This adds one retain/release and queue operation per notification. It fixes lost
between-frame events; it is not a compiler callback bypass. Unreviewed bitmap,
arrow-cursor, contextless-swap and helper-type expectations were removed/migrated
as detailed in the producer report, not counted as supported negative coverage.
Actual image samples, input/window identities and GL effects remain asserted.

Native clipboard restoration guard preserves materialized bytes/types, not lazy
provider identity, changeCount or external files. Concurrent external clipboard
changes can be overwritten; verification requires an isolated session. Catalogue
clipboard cases now require that real guard and serialize within one runner.
The guard enforces a child deadline, kills/reaps a stuck child, restores/verifies
native clipboard bytes and reports124, never success. A real source-built hanging
child verifies this path at50ms (measured0.188s including restoration). Native
polling adds up to10ms completion latency to these tests. Outer guard failure or
unavailable native services remain failures; no fake clipboard is used. Private
WASM scheduler token fixtures now explicitly reject native execution to prevent
accidental undersized pthread calls.

At b99d2f02, merged Extensions catalogue results are28 native ARM64 O0 passes and
27 interpreter passes/one120s timeout (Json/tests/numbers). Exact per-case elapsed
was not retained by the existing runner; its runtime is at least120s. This is not
a numeric pass. Original assertions/sweep sizes remain unchanged. Full client
context lint remains incomplete as reported by its producer; a smaller passing
context is not accepted as its replacement. Other platform execution is pending.

Socket generator correction: reviewed Unix select declarations refer to TIMEVAL,
while the reviewed public TIMEVAL export is Windows-only. The implementation now
defines a private type alias to canonical POSIX.timeval for Unix signatures. The
official installed SDK sys/_select.h and sys/_types/_timeval.h establish the C
parameter/layout; the reviewed POSIX record supplies canonical Jai identity.
This is independently designed ABI glue, not a copied public declaration or a
new compatibility export. All public parameter names/overloads/defaults/native
symbols are retained. New actual host select call and enclosing canaries pass;
original full C ABI also passes. Generated output matches a second generation.
Cross-platform runtime/select variant behavior remains unverified, not hidden.

System facade correction: CPU-X64 `M64` now directly imports the reviewed
Machine_X64 module rather than assuming the private Windows backend exports it.
Canonical module/type/enum identity is asserted; ARM64 still has no M64 export.
Host native/interpreter behavior and the original Windows-x64 source failure are
verified. Android/Toolchain's dependent source error is also resolved. Native
Windows runtime verification is outstanding; source checks do not substitute it.

Corrected compiler storage checkpoint eaf39199 was reviewed as a net snapshot
against6080ff0a, including producer handoff/status/deviation reports. Its only
production delta is anonymous filtered using registration already present here
from57cb0b51. No live `::` alias implementation or its history was merged. Corrected
tests/docs are imported, with58 module/core cases passing and workspace Clippy
warnings denied. The new jailint fixture uses an intentionally minimal source-only
bootstrap; core reflection tests likewise use the existing VFS reflection bootstrap.
These are compiler unit controls, not production library validation. New LLVM
native/WASM O0/O2 and actual wasm32 runners are supplied but not executed in this
checkpoint, avoiding optional matrix expansion before the combined baseline is
green. Their verification remains outstanding. Producer staging/overlay claims
are not counted as integrated production proof. No new production compiler change
is hidden in this import.

Catalogue routing follow-up: input metadata names only actual fixture prerequisites,
not expected failures. Scratch paths are isolated under the runner's existing
owned temporary directory and cleaned by its existing finally block. The caller
must supply a real font through `JAIC_TEST_FONT_PATH`; there is no fake metric,
texture, hardcoded fallback or copied production library. Six OS-specific fixtures
are now unavailable on Mac; native Windows/Linux evidence remains required and
not green. Actual host/label mismatch is rejected. Source target guards and strict
negative baselines are unchanged. SDL source-built C probes remove missing-symbol
errors, but interpreted WM still fails `SDL_Init: No available video device`.
Native WM passes. Its diagnostic helper uses Basic.assert with caller location
and prints SDL's actual error, retaining all ABI/ownership/canary assertions.
Proper fix requires diagnosing actual interpreted SDL/Cocoa initialization and
native library selection; no cause or graphical fallback has been assumed.

Compiler options follow-up: `stdlib/internal/compiler-api/workspaces.jai` now
rejects `use_natvis_compatible_types = true` explicitly. The independent backend
has no Natvis-specific type emitter; accepting this flag silently was reduced
semantics. A failing negative test demonstrated that acceptance before the fix.
This is an honest unsupported diagnostic, not completed Natvis support. Proper
completion requires target/debugger-specific type emission and native debugger
consumer tests. Alternate X64 backend and raw LLVM command lines remain explicit
unsupported requests. The positive intercept/continuable-report fixture now uses
supported settings, accumulates all message batches (including empty batches),
and retains exact totals and failure/continuation checks. Unsupported requests
have separate precise negatives. No diagnostic or message-kind assertion is
ignored. Full CLI suite now reports17 passed/one failed (Default_Metaprogram).

The frozen `90fea8ab` workspace/catalogue measurements remain red; exact evidence
is in `docs/status/mac-integration-baseline.json`. `Debug` native helper was not
built in this candidate, so `backtrace_sees_compiled_callers` fails to link rather
than proving a backtrace regression. Proper fix: source-build the actual private
native helper and verify the original caller assertion. Generic catalogue routing
does not supply argv, fonts, SDL C probes or prepared resource inputs to specialized
fixtures, and selects Linux/Windows-only programs on Mac. Those failures remain
failures; proper fix is explicit supported-target/prepared-suite routing with
required separate execution, not a skip baseline. Unknown identifiers and failed
runtime assertions still require individual reviewed-contract comparison.

The test commands finished with no timeouts. One inherited ignored workspace test
is reported explicitly. Native Windows/Linux execution, full opaque public corpus
and Focus GUI remain unverified here. Process inspection is denied by the OS;
no alternate inspection path was attempted. No remote action was performed.
# Thread fixture contract migration audit

`tests/compiler-semantics/sandbox-threads` intentionally uses opaque u64 tokens
from our own SandboxHost provider, not native pthread structure layouts or a new
public standard-library API. Its s64/s64 deadline and timeout110 follow that
private provider's implementation. The fixtures are only executed with `-os wasm`.
Native Thread availability is unchanged. The three existing CLI assertions remain
strict, including deadlock detection and timed wake progress. Initial construction
errors (missing context in a C callback and native-only Basic sleep) were corrected
using an explicit captured context and the actual private usleep provider. No
fallback return or fake wake event was added. Real wasm32/browser verification
of this new exact fixture remains a later gate; this checkpoint proves CLI sandbox
execution, not all browser/native platforms.

Seven existing independent thread fixtures now use the reviewed public APIs;
no Thread/Basic facade exports, compiler bypasses or production defaults changed.
Removed tests assumed results from canonical void functions and invalid-state
behavior absent from the oracle (enumerated in the questions document). This
reduces unestablished legacy negative assumptions; it does not certify those
states. Real supported contention, allocator byte preservation, work ownership,
STOP, shutdown timeout/retry, condition wake, semaphore permit/timeout, inherited
context/logger and caller-owned scratch tests remain. Allocator calls use scoped
public context selection; temporary storage is freed only after completion and
deinit. Group logging is explicitly disabled in fixtures to retain exact stdout,
not suppressed globally or by the test runner. Mac native Debug prerequisite was
source-built, with no library overlay. Other platforms remain unverified.

## Basic/Math shared context checkpoint b821bf6d

Combined production sources pass39/39 focused commands via check-core-public.py (artifacts/mac-baseline/core-b821-combined/results.json). The runner now accepts existing test-tool environment selection instead of assuming a producer T7 directory. Cross-configuration struct callbacks in stdlib/internal/basic/format-support.jai copy the complete builder prefix/output through canonical owned storage; this preserves output and allocator ownership but adds allocation/copy cost and does not establish raw cross-configuration buffer identity. Exact identity and signed128 overflow questions remain in specs/questions/basic-core-public.md. No compatibility aliases were invented. Full combined baseline remains pending.

## Additional stable producer checkpoints

executable_formats f68873b9 supplies508 declaration rows, not508 certified behaviors. Production CodeView records use canonical Debug_Info.Guid and copy wire input into aligned storage; real original C/PE/PDB oracle fixture passes interpreter/native ARM64 O0 here. Generator modelba878c70 adds dependent template/signature comparison. Its recursion cap64, represented-type-only arguments, diagnostic rejection of unsupported qualifier graphs and modeled128-bit size recognition in generator-model-helpers.jai remain limits, not general C++ equivalence. Reopened scopes use owned session state, freed during session_close. The independent C++ layout oracle and actual combined templates fixture pass interpreter/native O0. SDK23 evidence still does not certify reviewed SDK21. platform81c8217b is evidence/provenance only; its copy helper implementation was already integrated.

Actual combined workspace ac9b8723:852pass/2fail/1ignored,101 test binaries, four nested summaries excluded. WASI tour still imports native-only Thread; target ledger retains186 differences. Full details are in mac-current-baseline.json. Broad actual formatter reports two unformatted profiler-context compiler-request fixtures; no lint suppression or fake formatter proof is used. Current catalogue remains pending; no green combined claim.

## Callback bridge allocation failure repaired

A new independent public-API allocator test first reproduced lost failure state at ac9b8723: scratch callback output succeeds, destination copy allocation fails, then format-support.jai clears builder.failed. The bridge now preserves destination OR scratch failure. core-builder-allocation.jai covers both failing allocation positions and zero live allocations after cleanup. The actual combined focused runner passes45/45 commands (interpreter/native O0/O2 and strict roots), with no allocator fallback or library staging. Broader unchanged jaifmt now passes after formatting two own compiler-request fixtures. Frozen full counts remain those of ac9b8723, not a claimed full replay of this follow-up.

## Test reporting and clipboard prerequisite

The catalogue previously measured then discarded per-case elapsed times and consumed ordered pool results, hiding completed independent cases behind a slow case. tools/stdlib_runtime.py now offers --report with completed-case durations and timeout/error/category records as futures finish. Ten existing protocol tests pass; six actual case/mode checks retain two positives, two precise negatives and two genuine compiler fixture failures. An intentionally tiny deadline verifies timed_out/failure/duration reporting only and is not functionality evidence. No timeout was increased or assertion weakened. The GetRect widget fixture also mutates the real system clipboard; its case now requires the existing native all-type restoration guard, since its own text-only restore is insufficient. This does not fix its outstanding API errors or turn it into a pass.

## General Code reconstruction and custom-loop checkpoint59a69c03

Compiler-owned structural attributes retain syntax absent from public records; serializer public fields remain authoritative for represented edits. No original source-text passthrough is used. Private attributes are compile-time associations; native caller-created graphs can only serialize represented public syntax. Expression recursion is bounded at512; unsupported/inconsistent graphs, missing required operands, multiple modify blocks and unestablished module maps are rejected. Floating decimal spelling is regenerated with precision flags; nonfinite values use overflow spellings, not original source text. Arbitrary copied-body ownership and conflicting scope donors remain unresolved. Proper expansion requires reviewed contracts plus general record ownership/representation support, never private identity fields exported as API.

General custom iteration forwards the actual innermost array-removal frame along with jump/defer state; numeric removal remains rejected. Five combined Rust catalogue tests and20 actual native ARM64 O0 build/run commands pass. Rustfmt and workspace Clippy with warnings denied pass. The previous partial-edit sweep was interrupted after93/923 files and2451 edits with zero completed-file failures to consume this functionality checkpoint;830 files remain unverified, not skipped or passed. Old workspace/catalogue counts remain frozen at ac9b8723.

## Interception fixture construction corrected

compiler-typechecked-messages previously asserted every selected declaration belonged to the main import, contradicting canonical library-record participation. It now requires every enclosing load/import to exist and applies its application-specific Settings/VERSIONS/work/layout/mutation assertions only to its application import. No production interception rule changed, and selected-library coverage remains in the Rust core/CLI tests. The previously failing fixture now passes interpreter and native compile-time construction; it has no runtime main, so native executable execution is not claimed. Full catalogue counts remain ac9b8723 until a fresh full run.

Target-ledger audit: eleven of its35 reported passes-now rows name entries not discovered under that exact spelling (including removed legacy names and macos/macOS casing). They must not be cited as35 completed positive source checks. The actual ledger still fails; reviewed platform exclusions need the pending bindings9bc40a8 audit. No unsupported implementation guard has been accepted as green.

## Canonical runtime fixture migration

Three compiler-regressions fixtures now use the canonical Runtime_Support import instead of requesting a separate all-false bootstrap. The context fixture uses reviewed #Context rather than inventing a Context export, and adds canonical Context_Base identity. Original memory/output/context/intrinsic assertions remain. Two source/output fixtures pass interpreted #run and native compile-time checks; the context fixture passes interpreter and actual native O0 execution plus strict lint. This is test construction against supported canonical bootstrap, not proof of unsettled differing-parameter instance semantics or nullable strlen reference behavior. Those remain explicit questions. No production module, ABI, parameter validation or assertion policy changes.

## Additional generator checkpoint753b30c7

The six production runners (integer range, cursor/type queries, pointer defaults, multiple inputs, byte-string macros and omission visitors) pass against combined sources after rebuilding the actual private C helper. Six new runners now select the existing CARGO_TARGET_DIR compiler/linter rather than assuming target/debug; generated fixture paths and production library are unchanged. Raw producer gate output remains ignored, not a product doc.

Limits: binding-cursor-source.jai reconstructs libclang token spellings separated by spaces, discarding comments; it does not preserve exact whitespace. binding-type-queries.jai uses allocated visited-pointer lists with linear searches, quadratic in chain depth; unsupported/unnamed shapes can return empty names, and malformed numeric widths diagnose. bindings-driver.jai supports multiple source headers through one actual native parse/model graph but still requires one explicit Library and rejects newline/CR/quote bytes in multi-header paths; proper wider support needs robust include-path encoding and reviewed multi-library ownership. binding-native-model.jai and clang-bindings/main.c accept evaluated byte-string constants only with matching array extent and CString length; wide, embedded-NUL and nonliteral cases reject rather than truncate. Explicit manually represented Literal byte emission still preserves embedded NUL. Proper embedded-NUL macro support needs a native length-bearing evaluation API/validated byte extraction, never unchecked reads past CString allocation. Recursion64 remains a diagnostic limit. Signed128 range checks cover u64 inputs against represented128-bit targets, not128-bit foreign argument/literal emission. Omission workflow reuses canonical model visitor state; global C++ free-function classification, full wrappers/vtables and normalized typed cross-configuration options remain partial. SDK23 and Mac executions do not certify SDK21 or foreign native runtimes. No overall generator completion is claimed.

## Deferred compile-time calls89560db9

Nineteen focused core/CLI tests pass in the combined tree; Rustfmt and all-target workspace Clippy with warnings denied pass. Retained owning-interpreter frames resume declared placeholder dependencies without restarting caller prefixes. Module/workspace lexical scope and duplicate/unknown-name diagnostics remain strict. This is the compiler primitive, not completed Metaprogram_Plugins facade integration.

Exact restrictions remain: native callbacks and live managed-thread boundaries cannot suspend into compiler evaluation and diagnose; opaque callback storage is inspected nonblockingly, with direct exposure requiring readiness. A body that executes a generator and then finds another unresolved placeholder fails terminally rather than replaying side effects. Proper broader lowering needs a per-body generator checkpoint/cache and transactional continuation, not retrying successful effects. Active workspace destruction/cancellation and additions after workspace completion reject. Ownership of arbitrary copied bodies remains unresolved. Full combined replay is still required; no earlier counts were projected from these19 tests.

## Qualified module-value IDE metadata

Basic.temp navigation failed independently despite correct hover. A successful module-member lookup now records its actual declaration entity, consumed only at the matching member span and reset before another lookup. Constants/globals get entity references; primitive type aliases preserve definition associations. No spelling checks, invented definitions, public visibility changes or runtime behavior changes were added. Real JSON requests and incremental range edits pass, as do all42 feature/module tests and warnings-denied workspace Clippy. Exit minimal cases pass unchanged and are never executed. Broader real-world intermittent exit reports remain unconfirmed without their actual document/configuration.

## Retained member bodies and reviewed type flags9b3d4932

Canonical lowered-member body events/contextual enum syntax and correct public array/type-directive flag values are integrated together with deferred calls. In the isolated authorized T7 target, core flags1/1, deferred CLI7/7 and compiler catalogue7/7 pass. Workspace Clippy warnings denied passes. The statement fixture previously relied on caller visibility of ordinary inserted locals after Code reconstruction; all original value assertions now execute inside their declared block, and outward assignment has an additional assertion. A separate identity-insertion positive/local-duplicate negative is registered. An experimental flattening change was rejected because it caused enum declaration collisions; no production insertion semantics were changed. Compiler scope contracts remain explicit questions. Producer native children select crash-backtrace OFF due its absent owned prerequisite: that is limited staging evidence, not production default-crash/package proof. Actual combined profiler workflows remain required.

## LSP owner consolidation

Owner cf7dd80+5214e9c supersede the independent d2577883 metadata implementation. The single existing last_entity path is now span-bound for both identifiers and module members; the redundant independent slot is removed. Both independent JSON/member regression sets remain, with the owner failure-state/UTF16/visibility cases. All46 features/modules/qualified-values tests pass in the isolated T7 target. The source-copy investigation tool changes workspace membership and omits native SDK links; that is scoped investigation evidence only. Final protocol verification will invoke its investigation engine using the actual production server and actual production stdlib, with no source patch or manifest overlay.

## Coherent portable snapshotb74c4ab

Actual production Metaprogram_Plugins and Default loader now pass their runners with compiler89560db9/9b3d4932 combined: computed names/parameters, real initialized objects, aggregate statuses, same-name replay, unchanged visibility/unknown-module negatives and full context-aware strict lint. Default uses the one public loader rather than private CLI source generation. Four default Deep_Copy fixtures pass interpreter/native O0/O2 and strict lint with actual SDK clock queries outside optional assertions. Private crash-helper relocated package test passes native ON/OFF behavior and rpath/install-name checks with JAIC_NATIVE_LIBS absent. That test certifies the crash helper only, not libclang/whole dependency closure.

Integration removed producer driver peer copies, production-to-itself copies and rejected draft overlay options. Drivers select the actual library; the legitimate relocation test copies that complete library unchanged. Deep_Copy producer evidence for altered-default Basic false was staged code, so the production runner does not claim that profile. Remaining disabled-default coverage needs a supported configuration mechanism; no global Basic defaults are modified. Obsolete pending draft dirs are kept only under ignored artifacts. JKS keytool positive SDK verification and broader Android signing remain partial. Portable inventory4076 rows/3574 complete-source/455partial/47missing is scoped source inventory, not full conformance or whole-module certification.

## Foundations profiler/Codex snapshot9a8db93a

Combined production runner check_profiler_codex.py passes198/198 commands, including four real modules-on/off native O0/O2 profiler workflows,22 fixtures, actual interpreted edited child code, native C wire consumers, hooks and generated configurations. No compiler/library overlay or source/name filtering is used. Startup collection is an independent explicit policy: generated automatic instrumentation is disabled until entry-point setup and after final reporting, while all eligible procedures remain instrumented and public manual zones are unchanged. Proper parity for pre-entry/post-report rows still needs the precise lifetime/collection contract in profiler-codex-questions.md. Windows/Linux evidence here is source-only. The owner139-name inventory is scoped source completion, not whole stdlib certification. Compiler-owned reduction inputs are retained, with an additional byte-store assertion; original assertions are preserved.

## T7 AppleDouble DWARF verification

The isolated full workspace found two debug-tool failures: llvm-dwarfdump verified the actual Mach-O payload with no errors, then treated filesystem-created ._prog sidecars as objects while walking the dSYM bundle. debug_info.rs now verifies Contents/Resources/DWARF/<executable> directly. All5 original debug tests, including every DIE/compile-unit assertion and LLDB breakpoint/backtrace/variable checks, pass on T7. No files/assertions are deleted or suppressed. Frozen4397e23c full count remains879pass/4fail/1ignored; this is a focused test-construction repair, not a projected full-green count.

## Filtered parameter serializer repair

The full catalogue exposed a stale static-using expected-failure assertion after supported syntax printing landed. A positive exact spelling/roundtrip assertion replaces that obsolete expectation while preserving every public filter and body check. That revealed a genuine production defect: procedure() printed both parameter_usings filter syntax and the argument IS_USING flag, producing using,except(...) using item and losing EXCEPT during parsing. It now emits one authoritative explicit prefix, retaining bare-using fallback when no explicit record exists. Actual interpreter/native compile-time contract checks and strict production Program_Print lint pass. No assertion is ignored, public schema/export changes or source-text fallback added.


## rpmalloc generated-domain build cost

tools/native_bindings/rpmalloc_profiles.py currently defines96 combinations, each with SDK/callback libraries and static/dynamic outputs. This expands native build cost and does not mean96 configurations were tested. The integration runner builds only the four required diagnostic combinations using selected profiles. Retain actual supported-configuration selection for application/baseline builds; do not run the full optional cross-product before the primary Mac baseline or label generated declarations as verified behavior. Existing rpmalloc-no-thread-cache.jai contains now-reviewed invalid global=true/thread=false positive imports; owner reconciliation must preserve valid both-off ownership/layout assertions and precise rejection checks.


## Workspace native object routing

General LlvmBackend target selection now uses workspace OS/CPU or explicit LLVM triple instead of host-only native output. Actual seven-target object headers and explicit override/invalid CPU unit checks pass; no module-specific bypass. Native Windows/Linux runtime remains unexecuted. Frontend build::new_compiler does not independently derive ABI settings from a custom workspace triple; mixed CLI/workspace precedence and long-double ABI coherence remain compiler-owned verification gaps, not established by integer-return object headers. See compiler/workspace-object-targets.md and status/workspace-object-targets.json.
