# Integration requests

## General link_always repair owned by integration

Integration independently repaired the Objective-C interpreter/native discrepancy
with generic native required-library loading and named-library metadata ordering.
No Objective-C name/path activation or fixture preload was added. Original real C
constructor cases, native O0 executions, precise failure/pure compile-time/
SandboxHost boundaries and the actual Objective-C interpreter fixture pass.
Compiler owner should avoid a duplicate patch; see
compiler/native-required-libraries.md. Current non-required explicit library
global-symbol fallback still needs reviewed policy before changing its behavior.

## Current shared generator type/protocol review

All model/names/platform/emission/modifier helpers consume the single
generator-session owner; duplicate typed options values and both extra Context
modules were removed. However configured TARGET_OS facades still load nominal
Generator/CType/Declaration/options types per instance and cast borrowed opaque
pointers to those instance types. Sharing fields alone does not establish
cross-instance canonical type/default/ABI identity. Tooling's new
developer-tools-context-protocol.md proposes one unparameterized model and typed
normalized options view; it is explicitly marked a proposal, not production.
Model/lifecycle owners must reconcile this architecture and reviewed
TARGET_OS-dependent defaults, implement one typed protocol and migrate consumers
without exposing new API names or leaving parallel snapshots. Preserve all
original public helper and nested-context regressions. No default successful
view may stand in for required supplied state.

## Corpus takeover metadata at17ab409a

The restricted app-only stage excluded268/1044 records before source access,
including all249 module-directory records found by the metadata audit. Existing
unchanged jailint checked337 of400 configured entries using actual production
stdlib/SandboxHost strict program contexts:296 complete source checks,41 failures,
63 configurations unexecuted (excluded/opaque projects or required CLI capability).
No native build/execution or full corpus success follows. IDE/type facts reported
706/776 permitted files,271 with Check errors,70 unreported. Vk-Engine reached
its180s deadline after180.005s, reporting33/101 files; no success is claimed.
Reports retain only metadata; raw diagnostics are not handoff inputs. Both local
commands completed before coordinator takeover. Full original400-entry run is
the acceptance gate; provide only sanitized independent reductions to producers.

## Interpreter/native link-always discrepancy at8928fb1a

Compiler owner: unchanged new producer `tests/native-bindings/objc-runtime.jai`
passes actual native ARM64 O0 but interpreter fails `pool != null` immediately
after `Objective_C.objc_new(NSAutoreleasePool)`. Same production library/native
prefix, no staging. Objective_C/declarations.jai has unnamed
`#library,system,link_always "Foundation"` and `QuartzCore`; the interpreter
loads native libraries only lazily for foreign-symbol resolution. libobjc loads,
but Foundation's classes have not registered before objc_getClass. Source-built
native executable correctly links/loads both. Evidence:
`artifacts/mac-baseline/canonical-generator-all-helpers/objc-runtime-{interp,native}.log`.
Please repair general link_always loading/initialization for native interpreter
execution and compile-time runs, preserving SandboxHost/IDE/tool capability
distinctions and actual missing-library diagnostics. Add original independent
constructor-side-effect tests, not Objective_C/library/name-specific activation
or a fixture-only Foundation pre-load. No workaround was applied here.

## Canonical merged generator baseline db2962e7

Compiler e9affab7 is merged as the sole ordering implementation; model b00aa052
is merged with its alternate linter driver excluded and both original test sets
retained. Names83ba1961 is integrated through canonical gm_active_options; no
separate bindings_generator_options Context value remains. Actual shared library
passes52 focused commands and both module-context regression sets (12 tests).
Lifecycle owners must install the one borrowed options pointer and preserve its
lifetime through native callbacks; see generator-session.md. Options defaults
apply only when no caller options are active, not as fake replacement state.

Platform status discrepancy: approved3cecb481 still contains only seven of the
original ten platform helper names in platform-helpers.jai, identical to943637d9.
Its changes add macro diagnostics tests and integrate the already-consumed
compiler ordering fix, not find_lib_for_foreign_name/get_libc_paths/cache helper
bodies. Please supply the actual committed all-ten checkpoint rather than count
the draft as integrated. No peer dirty source or alternate checkout was read.

## Current 414-case catalogue failures at ad575d16

Compiler owner: five own fixtures fail both host modes. `lang-asm` and
`rules-simd-asm` include unguarded x64-only pause/cpuid on ARM64, and the latter
expects fabricated zero cpuid features. Keep meaningful real ISA checks and
precise unsupported-ISA negative coverage; no fake compiler feature results.
`rules-prelude-and-runtime-support`, `runtime-support-output` and
`runtime-support-source` explicitly request runtime params conflicting with
the one configured canonical bootstrap instance. Migrate to reviewed canonical
runtime tests, retaining output/duplication/context assertions and strict
parameter negatives. Do not restore arbitrary multiple bootstrap instances.

Window/numerics owner: six own graphics regressions still use old unreviewed
APIs: GetRect.set_asset_root, GetRect_LeftHanded.Font,
Input(ENABLE_NATIVE_INPUT_ADAPTERS=false) in three fixtures, and
Window_Creation.set_window_dimensions. Please migrate their real rendering,
widget/focus/published-event/temporary-allocator assertions to the reviewed
public APIs without fixture-only modules or invented exports. Exact names and
diagnostics are in the current machine baseline report. The separate actual
macos-events fixture now passes both modes after pumping queued native
notifications before reading frame records, preserving every assertion.

Extensions/compiler performance owners: Json/tests/numbers interpreter times
out at 180s with two catalogue jobs; native O0 passes. Earlier isolated same
Json sources passed in149.45s at7467b49d, before the general Mac FFI affinity
repair. This is a real deadline failure, not evidence of assertion failure or
permission to reduce the random/edge-case coverage. Investigate actual cost;
full sweep is already false. No tests or assertions were skipped.

## Combined ad575d16 replay: active failures

Compiler owner: stable full workspace replay now has only native-test
`wasm_target::wasm_tour_runs_as_a_wasi_command` and target-ledger failures.
The exact tour reproducer is `jaic examples/tour/main.jai -os wasm -exe tour.wasm`;
`examples/tour/threads/threads.jai:5` unconditionally imports native-only Thread.
Keep the platform guard and actual threading behavior; the own browser tour
needs an honest target-specific demonstration, not a fake successful thread API.
Please provide a committed corrected application fixture with native behavior
preserved and the original WASI output checks passing.

Full target checking reports 186 differences: 35 stale success entries, 71
changed diagnostics and 80 new failures. They include real unsupported backend
assertions and Windows TLS allocation API errors, not just stale bookkeeping.
Do not blanket-regenerate accepted failures. Reviewed target availability must
justify negative entries; actual missing behavior remains failed. All Mac ARM64
differences are platform/CPU guard diagnostics or stale passing entries; the
cross-target failures remain part of the complete command.

All 80 exact new module/target diagnostics, mechanical cause classifications and
provisional owners are published in [mac-target-failures.json](status/mac-target-failures.json).
No assertion in that inventory is accepted as passing functionality. Full opaque
public-project corpus compilation remains coordinator-owned because vendor
library bodies are sandboxed; its denominator is separate from the 414-case
local behavior catalogue. Please run originals externally and return filtered
results/minimal independent reproducers. Full corpus compilation is the current
publication gate; no remote operation is authorized here.

## Current native Mac candidate, 2026-10-15

Shared clean baseline7467b49d is ready for worker dependency adoption: compiler,
portable, profiler, tooling, model and platform snapshots are integrated; canonical
Generator/Token_Info/Library_Symbols are defined/loaded once. Do not coalesce
duplicate Context fields; latest reviewed context guidance still rejects them.
Respect newly assigned generator-names/modifiers and Debug ownership from inbox.

Integrator resolved original SDL WM failure generally: symbol-name activation
prevented first native library calls from reaching existing Mac main-thread routing.
Removing that gate fixes a library-neutral C regression, actual SDL WM and retains
all19 CLI passes. Avoid overlapping native.rs/mod.rs affinity changes. Fork/direct
and system fast paths remain; broad native regressions will run in full baseline.
Json interpreter numbers passes unchanged in149.449s under refreshed compiler;
earlier120s timeout remains recorded, default catalogue budget180s unchanged.

Compiler owner reproducible remaining lint defect: production Project_Generator
module and collection fixture fail jailint on _NSGetExecutablePath unavailable
during compile-time initialization. Actual interpreter/native behavior and real
VS/XML artifacts pass. Command: JAIC_STDLIB=$PWD/stdlib jailint -D warnings
tests/portable-stdlib/project-generator/collection.jai. No module-specific skip,
fake executable path or repaired staging library is accepted. Default whole-module
lint still fails missing Check.get_plugin; reviewed no_check workflow is real but
does not complete ordinary default Check behavior. Tooling owner: type-emission/
cpp parent traversal includes avoidable64-depth caps despite existing cycle checks;
replace with cycle-aware traversal while preserving valid deep model support.

New SDL graphics/compiler reproducer after real C probes are built: original
`stdlib/SDL/tests/sdl-wm.jai` passes native ARM64 O0, but interpreter fails actual
SDL_Init with `No available video device`. All preceding SDK size/offset/union,
null-window error and packet canaries pass. Build prerequisites with
`python3 tools/native_bindings/build_dependencies.py --output artifacts/native-sdk
--library sdl_abi_probe --library sdl_runtime_abi_probe`; run
`tools/stdlib_runtime.py --filter SDL/tests/sdl-wm --modes interp,native --opt O0`
with the candidate stdlib and that prefix first in JAIC_NATIVE_LIBS. Fixture now
prints actual SDL error and caller assertion location instead of bare abort;
none of its conditions changed. Please include this in graphics/compiler Cocoa
investigation; do not install dummy video, skip interpreter or weaken canaries.

Portable owner now explicitly owns Default_Metaprogram per inbox; compiler Mac
repair owner owns remaining compiler catalogue and WASI tour from d30311a5.
Integrator's production options repair is committed783f37c0: Natvis unsupported
requests are diagnosed, supported interception totals/continuable errors pass,
all18 CLI tests run with17 passed/one missing-Default failure. Avoid overlapping
edits to that test batch when refreshing the compiler worker.

Candidate path remains `artifacts/integration-clean/thread-fixtures`, branch
`integration/thread-fixtures`; latest committed head `d30311a5` plus a focused
reviewable compiler-options repair in progress. Frozen source90fea8ab measurement
is committed in `docs/status/mac-integration-baseline.json`: workspace822/7/1;
catalogue interpreter327/76/5negative, native320/76/7compile-only/5negative.
Original thread/backtrace/sandbox regressions now pass focused verification.
No aggregate green or Windows/Linux native claim. No remote operations.

Producer ownership inbox is acknowledged: do not duplicate Extensions Json/Http/
Byte_Search/Io-test repair or the assigned clipboard/window/Objective-C fixture
repairs. Their original failures remain in the frozen report until stable approved
commits are supplied. Integrator retains production Io, compiler and routing work.

Default_Metaprogram review request: the page defines `build` and lifecycle, but does
not establish import-time automatic invocation. Integration will use explicit
`#run { build(); }` in positive fixtures unless that side effect is reviewed.
Legacy `-os`, `-cpu`, `-no_output` are not in the reviewed option list and cannot
justify exports/options. More materially: default Check loading is required by
the page, but Check's public inventory has no `get_plugin`, and listed callbacks
are Windows-conditional. Clarify default Check construction/availability on Mac
and how `-no_check_bindings` configures it through the reviewed public API. Do not
supply private procedure bodies. Until resolved, a no-op Check plugin or silently
omitted default check would be an unsupported workaround, not completed behavior.

Root tracking branch has not been moved by this candidate. Preserve synchronized
guidance/spec edits before a safe fast-forward; current exact handoff will be
recorded after the scoped repair commit. Coordinator owns opaque full public
corpus, Focus launch/signed-wheel acceptance, and later ordinary native CI.

Requests are read by coordinator; this worker cannot send messages to the desktop thread.

Current refresh23 updates (supersede historical requests below):

- Compiler alias owner: integration has resolved the Socket facade defect via
  proper filtered storage reexports and general anonymous using-import export
  registration. See [exact reduction and verified fix](compiler/foreign-data-reexports.md),
  `tests/compiler-semantics/foreign-data-reexport`. Reviewed language explicitly
  does not authorize `Exported :: Impl.mutable_global` as a live alias. Please
  avoid a concurrent change that makes immutable declarations mutable aliases.
- Compiler6080ff0a forward enum fix is merged and seven focused enum tests pass.
  Production macOS resolver now passes interpreter/both CPUs nativeO0/O2/strict
  lint. Original full ABI suite advances to missing macOS `hostent`: public
  inventory declares hostent/netent/servent/protoent/rpcent, but exact Mac Jai
  shapes are absent. Supply those reviewed field names/types/ordering; retain
  existing C ABI assertions. No Linux shape surrogate is accepted.
- Approved data/resource sourceb1c6b1a5 is integrated through its five scoped
  producer commits; production supported-scope runner passes. Ordinary native
  Windows x64/ARM64 jobs now register real resource/discovery/+Icon SDK readback.
  Those jobs are prepared, not dispatched or reported passed locally.
- Verified Extensions6b0f2229 is available. The standing user instruction and
  AGENTS still require preserving Extensions exactly except SDL3, whereas the
  mailbox requests Io/Args/Io_Uring dependency changes. Keep the verified producer
  checkpoint separate until coordinator resolves that scope conflict; this
  worker does not treat a mailbox as permission to override that explicit rule.
  Existing fiber/two WASI formatter failures remain visible, not skipped.

1. Run full original public application corpus externally without exposing vendored library/compiler sources to this worker. Supply filtered diagnostics and minimal independent reproducers only. Local integration must use vendor-free staging of permitted unchanged application entries.
2. Provide refreshed stable producer refs/manifest when meaningful checkpoints are ready. This worker uses only manifest-listed independent refs; it will not inspect shared/quarantined integration history or another checkout's scratch data.
3. After review, run native temporary-branch CI including macOS x64 and Windows. No publication/release jobs may run. Focus build/launch and issue #1 signed wheel/event propagation remain coordinator-owned checks; latest guidance makes human acceptance optional while the user is away.

4. Foundations: latest Basic spec defines five parameters and ENABLE_ASSERT default true/layout behavior. Production Basic declares none and omits ensured_count by default. Implement parameter propagation/assert-discard/temporary stamping. Latest reviewed Memory_Debugger_Interface now specifies all four hooks, so the former missing-shape blocker is resolved. Production formatting still imports localeconv/snprintf/strtod into WASM runtime even for integer-only programs; implement a real WASM backend or supported native C linkage. Foundation owner is active; supply a committed checkpoint when verified.
5. Bindings: newly reviewed POSIX.itimerval macOS x64/Android x64 shapes are regenerated. macOS x64 builder-format.jai -check -no_dce now fails unknown timeval. Inventory declares timeval for MacX64, but its actual reviewed shape section remains ARM64-only. Please resolve the shape label/selection contradiction without guessing cross-architecture layouts. Objective_C/AppKit is still absent from the committed bindings snapshot; refreshed Window_Type/Window_Creation now correctly import that reviewed module. Supply a stable real AppKit checkpoint.
6. Numerics refresh resolves canonical Simp font/texture/effect identities, Type_Indicator, real metrics/texture fields and precision errors. Production suite is now 40/83. Remaining failures include AppKit, Windows filename loading/File support, unsupported Wasm Window_Type and Wasm formatting imports. Audit NSCursor identity against AppKit and provide native target evidence; prior fixture passes remain insufficient.

7. Window/render issue #1 REQUIRED: tests/window-render/signed-wheel-windows.jai encodes +120/-120/-240/+30/-30 as the WM_MOUSEWHEEL high word, calls public MyWindowProc and checks exact signed delta in the shared queue, typical units, window identity and frame clearing. Refreshed real Win32 pump now passes Windows x64 -check -no_dce. Execute this fixture on Windows x64/arm64 CI and test coordinator Focus. Separately tests/window-render/signed-native-fields.jai imports private internals from an application directory and fails strict privacy; relocate it under library-owned tests or exercise public behavior, preserving strict import rules.
8. Compiler enum forward-reference blocker after the type-only array-index fix: `Flags :: enum_flags u32 { MASK :: FIRST | LATER; FIRST :: 1; LATER :: 4; } #assert(cast(u32) Flags.MASK == 5);` fails unknown FIRST/LATER. Production socket-abi.jai AI.MASK references ADDRCONFIG declared later. Implement lazy dependency-aware enum constant binding (including cycles, implicit values and conditional/inserted members) without module-name exemptions or reordering ABI/reflection contracts. Native macros/ABI suites retain these failures.
9. Runtime explicit imports: production Mail and runtime-temp-default fixture set DEFINE_SYSTEM_ENTRY_POINT=false while bootstrap selects true. Current integration rejects conflicting singleton runtime configurations explicitly. Reviewed specs do not settle explicit runtime instance identity/flag behavior; resolve this rather than restoring silently ignored parameters. Correct ordinary library imports to use the configured runtime where no alternate entry behavior is intended, retaining startup ON/OFF tests.

10. The three private window/input/rendering fixtures have now been relocated into
stdlib/Input/tests, stdlib/Simp/tests and stdlib/Window_Creation/tests, preserving
their assertions and strict application import rejection. Exhaustive signed-word
test passes interpreter/native O0/O2; Linux-target texture packing passes. Cocoa
test still fails missing committed AppKit. Update later producer runners to use
the library-owned locations; check_window_render.py already does so here.

11. Latest reviewed Basic/debugger, Input text, Keymap grammar, Simp shader/font/
mipmap and window default contracts are preserved. Implement those exact contracts
rather than retaining historical missing-contract blockers. No extra IME API is
required by the reviewed Input contract. Bindings: please supply the independent
procedure-reflection marker reproducer and stable AppKit/ABI checkpoint through
approved snapshots; no quarantined implementation is admissible.

12. Compiler checkpoint ec7e23e does not include the generic-default metadata used
by foundations' staged passes. Production type-parameter-format and
formatter-parameter-defaults fail real assertions; standalone source descriptors
have no parameter defaults. Supply the stable general reflection checkpoint.
Integration independently repaired scratch-context initialization at all three
creation sites and the hidden-procedure member marker (007711f, 8cfb5a7).

13. Foundation staged lint passed with nonverbose jailint, which can return zero
after incomplete compilation. The integrated runner now requires verbose complete
compilation. It exposes three Windows-only implementation files checked as host
roots; no warning suppression/exclusion was introduced. Provide target-aware
verification with actual supported tooling. Current owned positive host source
checks must not be called full platform lint.

14. Basic.log and both log_error overloads are explicitly reviewed in basic.md
inventory, including location/flags/user_flags/section parameters. They are absent
from the committed facade; LSP ambiguous-log tests therefore expose a real gap.
Earlier integration classification of Basic.log as unreviewed was wrong and has
been corrected. Implement real logger forwarding and metadata; keep failing
behavior assertions. Only source-location assumptions in navigation tests are
migrated to the independently organized canonical implementation paths.

15. Canonical navigation migration exposes another genuine IDE regression in
links.rs: with one unavailable independent import, definition of a re-exported
deep() call nested inside an overloaded qualified facade call is empty. The
diagnostics correctly contain only the missing import. The original using-import
visibility/definition assertions remain enabled. Correct the general semantic
recording/recovery path; do not remove the missing-import fixture or re-export test.

16. Request 12 is resolved by approved compiler 890329b. All 24 foundation host
cases and 19 WASI cases pass O0/O2 with production metadata. Source/runtime
configuration tests are split correctly: the original conflict source remains a
required compile-rejection case, and unchanged temporary-storage assertions run
with the configured runtime. Portable production now passes 92/92 ordinary cases
plus all fault/rejection/SMTP/channel/parent/startup checks. Runtime alternate-
instance compatibility remains an explicit question, not a claimed guarantee.

17. Fourth refresh: fourteen macOS window cases pass interpreter/native O0/O2,
including actual GL texture/readback/shader drivers; numerics is 107/123. Windows
Keymap/renderer checks fail File's unconditional OS_IS_UNIX guard. Implement real
Windows File without API changes/fixtures. Signed-wheel still passes x64/arm64
all-code checking; actual native Windows runs remain required.

18. Broad partial-edit coverage completed with one genuine failure in private
runtime/startup.jai: line 19 byte/UTF16 26 loses appended __tail_local typed hover,
completion and inferred hint. Latest compiler retry still fails three assertions
across 24 edits/860 assertions. Full evidence: 537 files, 14,257 edits, 2,563,157
assertions, one failed file. Preserve strict source admission and repair general
IDE recovery; do not weaken the harness.

19. Native SDL WM-info canary/error/window and Objective-C/AppKit tests pass.
SDL2 RWops/UserEvent assertions still fail 48/72 and 8/32. Caller-owned RWops/
callback conventions need safe private storage/marshalling or explicit unsupported
diagnostics. No mismatch assertion is waived. The real new SDK probe is now in
the build selector and its private fixture lives under stdlib/SDL/tests.

20. Fifth refresh merges portable c8d1f5d, foundations a11c0c8 and platform-io
eb5d83d. Request 17's Windows File gap is resolved: host real tests, Windows
unused-code checks and coordinator-filtered native x64/arm64 File and wheel
results pass. The workflow overall remains failed. Platform-io owns remaining
Windows runtime/Process/System/Thread; retain all failures. Request 18's refreshed
sweep finishes 558 files/14,835 edits/2,600,590 assertions with the same startup
failure. Basic's contextual interface helper is now private and selected public
debugger identity/callback tests pass. General unused module-interface validation
still incorrectly accepts the invalid fixture; compiler owner should reject it
without special-casing Basic. Autorun's pending mixed scalar/spread variadic
reproducer still loses the prefix, so its real argv workaround remains documented.

21. Filtered fuzz CI failure is independently reproduced and fixed here: Wasm
File now uses private opaque stream C ABI supplied by unchanged Wasi_Runtime,
with real interpreter/WASI O0/O2 File behavior and formatter saved regressions.
No POSIX guard was weakened. Integrate this change into the next reviewed CI
candidate; full workflow/corpus still needs coordinator execution.

22. Reviewable source checkpoint 33f0c42 also fixes the Windows font File import
guard and rejects null fd-set pointers while preserving names/signatures. Both
Windows CPUs pass editor/public font all-code checks; execute real FreeType/font
loading in native CI. The prior window source checks missed this unused path;
the runner now includes it. The target matrix additionally discovers all nested
public facades (819 checks over seven profiles), with isolated scratch inputs.
Existing error inventory differences include intended native-platform guards,
stale old-path expectations and genuine semantic/ABI gaps; do not equate their
count with an equal number of compatibility bugs or bless them all as intentional.

23. Actual source-built wasm32 compiler/formatter: 24 golden formatter cases
pass, but full engine check fails Thread's documented native-only guard in tour.
Browser C bridge legacy fixtures now use explicit C declarations while keeping
all input/EOF/exit assertions; negative Basic allocation is separately required
to produce a contained diagnostic. Missing reviewed logger and IDE expansion
assertions remain failing. Native Wasm corpus agreement also retains its
null-deref-plain-load mismatch; supply a minimal independent semantic reproducer
through the compiler owner rather than relaxing pointer safety or expected output.
# Refresh-nine request: foundations helper contract synchronization

## Bindings refresh-ten: SDL proxy violates native-pointer contract

Snapshot `fddae00`, `stdlib/SDL/wrappers.jai:SDL_RWFromFile`, returns a newly
allocated `Binding_File_RWops.surface` rather than the pointer returned by SDL.
Its callbacks use the ordinary Jai ABI. A native C client calling official
`SDL_RWsize(stream)`/`SDL_RWclose(stream)` therefore receives a proxy with the wrong
callback ABI and no native hidden union. It cannot interoperate as the SDL-owned
native pointer required by the latest reviewed sdl.md. The default #Context used
by the BMP callback bridge is also an unresolved policy, not established source
behavior. The newly authored proxy tests do not establish that contract.

Integration retains the prior direct native SDL_RWFromFile/SDL_LoadBMP_RW paths
and the already-safe full-storage WM-info adapter; it does not import the proxy
or invent a caller context. Root pointer-only supported behavior remains actual
SDL-owned objects; a Jai-created/copied 48-byte record is not a native RWops and
must not be supplied to C. The rejected code remains available in the permitted
producer commit for owner review, not production integration proof.

Required producer regression: open an independently authored BMP through the
public factory, pass its result to an official-header C helper that calls native
SDL_RWsize and SDL_RWclose, and verify real bytes/status and freesrc failure
cleanup. Preserve the exact public 48-byte record and Jai callback types. Do not
replace native object identity or fabricate context capture. Any future custom
callback support needs reviewed context/ownership semantics and full private C
storage. Preserve original ABI mismatch evidence and classify proxy-only test
expectations against the reviewed native-pointer boundary.

Additional reviewed mismatch: `internal/basic/logging.jai::dispatch_log` invokes
the logger for an empty formatted message. Latest Basic requires no dispatch for
empty messages; retain nonempty metadata/lifetime/default logger assertions.

Actual strict integrated lint exposed the fixture's unused `allocator` in
`memory-debugger-interface.jai::check_free`. Integration will strengthen that hook
to assert the valid allocator procedure, as the neighboring hook already does.
The foundation runner now selects real native target profiles and requires every
owned file in jailint's checked-file manifest; earlier quiet partial passes are
not accepted. Pending alias probe imports use their real test module directory.

## Native Windows feedback follow-up

Filtered coordinator evidence at `cc07c00` retains real failures: zero-argument
interpreter startup reports Windows command-line conversion failure; renderer
native O0/O2 requests nonexistent `gl.lib`/`gdi.lib`; ARM64 ordinary corpus startup
selects an unsupported x64 handler. Integration traced zero-argument failure to
the compiler's deliberate null CommandLineToArgvW interception interacting with
the stricter real runtime. A separate next snapshot will preserve an explicit
empty C argv before Unicode normalization, remove that fabricated API failure,
and regenerate Windows library mappings to official opengl32/gdi32 names.
Actual Windows execution still belongs to coordinator CI. Compiler owner should
inspect AUTO versus explicit ON backtrace propagation for ARM64; do not disable
an explicit unsupported request or invent ARM64 handler layouts.


Owner: foundations; integrated snapshot `cc089d7`. Latest reviewed
`docs/specs/stdlib/modules/basic.md` now settles these choices. Please update
implementation and original behavior assertions together, preserving their coverage:

- `internal/basic/stream-helpers.jai`: sequence strings must be quoted;
  `print_bytes` formats unsigned hexadecimal and appends a newline;
  `consume_u8_and_length` copies to the destination, rejects negative/excess
  lengths without advancing, and succeeds for zero length. Current code compares
  destination bytes instead of copying and asserts for negative length.
- `internal/basic/reflection.jai`: missing fields return `(null, 0)`;
  empty enum ranges return `(0, 0)` rather than asserting.
- `internal/basic/stack-traces.jai`: metadata-bearing lines use
  `'procedure' at file:line`; print uses low-level runtime output, returned strings
  and array use temporary storage, missing metadata is omitted, and logged lines
  include a newline. Current normal-allocator strings and alternate presentation
  conflict with the reviewed contract.
- `internal/basic/arrays.jai`: slice resize must use the current allocator's
  real resize operation, including shrinking backing storage. Current count-only
  shrink and allocate/copy/free growth need correction against the settled policy.

These are integration-detected compatibility gaps, not unspecified contracts or
permission to weaken tests. This worker continues compiler/tool integration while
the active owner corrects the shared foundation batch.

## Refresh eleven follow-up

SDL proxy request above is resolved in source by bindings40e37e9; production native verification remains pending. Basic helper batch is corrected by foundations841b417; production regression rerun pending. Runtime configuration consumer is adopted in canonical internal/runtime, with actual production CLI allocation tests passing.

Portable owner: reconcile internal/simd/lanes.jai and its generator/tests with latest reviewed simd.md. Comparisons use scalar bool-to-element values (integer1/0), get_mask tests truthiness, load returns SIMD_Array(N,F), gather/scatter use byte offsets and ordered repeated writes, looping indices are i*STEP, and horizontal_add fills all interleaved pair sums. Preserve documented reviewed reference defects; do not treat now-settled contracts as unspecified.

Compiler owner: create_thread ignores stack/security arguments and unknown flags. Implement actual supported native handling or explicit diagnostics; default-input tests cannot establish nondefault support. Preserve suspended/resume/count and real ABI/thread identities.

## Audio integration handoff

Merged controlled kernels from7d641f8 with portable canonical records/topology
and accumulator retained; duplicated types removed, Cached_Ogg_Decoder added to
the canonical generator, sample guards/magic retained, helper privacy enforced.
Latest sound-player.md now answers many earlier questions: power law and raw
master-volume setter corrected, gain step bounded by actual backend sampling
rate. The private backend_properties must be populated by genuine initialization;
no fake44100 default is provided. Finish real lifecycle/queues/devices and
category mix levels, review no_overflow/page interpolation and quaternion
normalization against remaining exact contracts. New perceptual-volume regression
failed before the fix and passes afterwards. Full playback remains incomplete.

Foundation pending strict lint is corrected by5c5e27b; retain the combined
target-aware union rather than restoring the producer's host-only staged lint.

## Windows public backend gaps confirmed by integrated target checks

Portable/platform owners: Socket public Windows API is specified (socket.md
Windows Socket/WINSOCK_VERSION/init/error variants), but canonical module.jai
asserts OS_IS_UNIX. Minimal original reproducer: S :: #import "Socket"; main :: () {}
with -os windows -cpu x64 or arm64 rejects before public API binding.
Shared_Memory_Channel similarly rejects Windows despite reviewed native mapping
records and reader/writer lifecycle variants. Reproducer: #import "Shared_Memory_Channel";
main :: () {} under either Windows CPU. Implement real Winsock/mapping backends,
preserve exact public layouts and require real loopback/IPC native CI. Combined
target failures remain visible; Unix runtime passes do not cover these gaps.

## Generic global-initialization address dependency / UI strict lint

Actual combined production strict lint of stdlib/GetRect/module.jai and
stdlib/GetRect_LeftHanded/module.jai rejects circular dependency while resolving
default_overall_theme. This predates the unused-result cleanup; original broad
logs retain it. Positive UI execution is not proof of complete library body lint.
A minimal original related address-initialization reproducer is
tests/compiler-semantics/pending/typed-global-address.jai: a typed global record
has a default owner pointer to its own address. -check -no_dce reports a circular
dependency on settings. The initial callback-only candidate passed and is not
claimed a reproducer; adding the real self-address dependency demonstrates it.

Compiler decls.rs::resolve_global_var allocates storage before initializers, but
its comment claims pending_globals support which has no corresponding state.
Proper resolution needs declaration/type/storage availability for legitimate
address/procedure references while still rejecting cyclic value evaluation and
compile-time reads before initialization. Do not mark a global fully initialized
early and silently supply zero values. Compiler owner should fix the general
dependency lifecycle and retain cyclic-value and self-address regressions, then
rerun actual production UI strict lint. No public theme/layout or initializer is
changed to evade this defect.

## Windows managed thread remaining native alias/lifetime gap

Source3084377 correctly exposes a real owned kernel handle for description APIs,
but thread_main records its Jai result and returns Rust unit. Managed exit/wait
hooks use scheduler state; unmanaged duplicates query the kernel. Nonzero exit
codes and completion boundaries therefore require actual alias/native-entry
regressions and coherent integration; do not invent native results or whitelist
naming warnings. Existing parked-worker teardown is an unbounded OS-thread
retention risk for a persistent interpreter/LSP. Proper long-term work is owned
native entry/exit lifecycle and safe cooperative cancellation/join, including
opaque blocking foreign-call limits, with explicit unsupported behavior where
necessary. Closing through external native code must also preserve/validate
ownership and handle-reuse identity; transferred raw handles cannot shadow an
unrelated reused kernel object.

## Reviewed current portable/foundation gaps

Latest Basic/Hash specs resolve previously withheld behavior: seconds_since_init
uses a lazy first-call monotonic baseline (no first-use thread-safety guarantee);
scalar fnv1a_hash performs whole-u64 xor then one FNV multiply;
test_unsigned_division is x64-conditional with documented deterministic/random
callback exercise; wide conversions have exact kind guards. These are supported
work requests, not unresolved oracle questions. Producer2f54d0c/ad84008 still lack
the first three APIs and wide guards. Required positive sources are
tests/portable-stdlib/pending/hash-scalar-fnv.jai and basic-division-exercise.jai.
Foundation runner keeps them red. Portable owns the lazy clock helper;
foundations owns the others. Integration independently fixed clock_gettime and
Flat_Pool release side effects inside optional assertions; preserve those fixes.


## Portable calendar/Pool contract follow-through (integration, 2026-10-15)

Latest authorized portable snapshot0c09ce4 has actual clocks/CPU/Windows channel
code, but reviewed basic.md line565 establishes POSIX normalization/DST delegation
and -1 seconds -> zero Apollo, while internal/basic/clock-calendar.jai rejects
components/normalized output and uses APOLLO_TIME_INVALID. Minimal public repro:
ct: Basic.Calendar_Time = .{year=2024,month_starting_at_0=12,
day_of_month_starting_at_0=0,time_zone=.UTC}; calendar_to_apollo(ct) must delegate
normalization, not reject month12. Separately valid1969-12-31 23:59:59 UTC reaches
the documented -1 collision and returns zero. Windows invalid conversions are
asserted per reviewed prose; current prevalidation silently returns invalid.

Reviewed pool.md line66 now resolves USE_UNMAPPING_ALLOCATOR default selection:
absent explicit allocator selects public global Unmapping_Allocator and sets
free_memblocks_on_reset=true; explicit allocator wins unchanged; pool never owns/
destroys allocator. Existing specialization rejection is unfinished, not an
acceptable fallback. Reconfiguration after first use must log/retain prior choice.

Producer ownership remains portable; coordinator please relay exact current
spec updates and request focused original public regressions. Integration retains
these as production gaps and continues other stable scopes. No legacy oracle or
unsafe platform mock is requested.


## Audio operational checks/ownership (integration audit11bc663)

Please move real actions out of optional assertions: player.jai line78 output
worker join; decode-queue.jai line121 join/line155 semaphore wait; vorbis.jai
line93 open/line95 seek. Check stored results, preserve diagnostics and keep
live resources owned if shutdown/seek fails and an assertion handler returns.
Backend shutdown/lose_output_device nulls output_handle before checking native
close status: C correctly keeps live callback storage on disposal failure, but
a continuing handler loses the retry handle. Do not free possible callback state
or fabricate shutdown success. Add original failure/state-preservation coverage
at the proper native boundary. Native default assertion behavior passes do not
prove this error continuation path.

Integration keeps private VBAP helper private; moved valid selected-pair public
behavior assertion to actual initialized6/8channel controlled-output test.
Producer panning.jai had directly called an unreviewed helper. Preserve public
coverage and report native opened/unavailable counts independently.


## Refresh17 compiler/regression follow-through (integration, 2026-10-15)

Fullworkspace7aec510:742aggregatepass/32fail/oneignored across85summaryrows;
all failing evidence retained artifacts/integration-clean/workspace-refresh17.log.
Integration OWNS the new optional interpreter assertion transport and related
runtime_config/procs paths; defaultC.abort hosttermination reproduced and fixed
locally, preserving customcallback/nativebody/privacy. Compilerowner avoid
duplicating that pending change. Other concrete semantic concerns:
- field_type_queries_infer_values_select_branches_and_reject_real_cycles:
  Record::{COUNT::size_of(type_of(value));value:[COUNT]u8;} gives truefieldcycle;
  audit test oracle before change (dependency may actuallybe cyclic).
- compiler-workspace-ids native builds execute get_current_workspace as runtime
  primitive inside a function-local #run; compare exact languagecontract and
  preserve compile-time-only behavior, no function-name/path bypass.
- objc_selectors test finds0calls/table entries, optimized_split finds0kept-out
  functions; inspect actualIR/observability before altering compiler/tests.
- LSP Math namespace quickfix nowalsooffers newlyreviewed Codex.Math reexport.
  Valid alternative is not an implementation defect; preserve meaningful import/
  resolution assertions rather than an unsupported exactcandidatecount.
Integration triages remaining legacy API Rustfixtures separately, preserving
compiler/safety/Extensions/ABI/issue coverage. Threaddeinit tests must establish
completion per reviewed Threadcontract; thread_startreturnsvoid. No ThreadWASM
facade promised; preserve core sandbox scheduler via independent compiler/native
ABI tests rather than adding unreviewed platformexports. PublicExtensions still
call old Basic.free(ptr,allocator); APIs maynotbeexpanded forlegacy conveniences,
so a supported compatibility architecture needs coordinatorreview while existing
Extensions bodies remain intact. No assertions or coverage disabled.

## Refresh18 foundations/portable: Pool lifetime registry breaks returned reports

Owners foundations + portable (active). Production command:
JAIC_STDLIB=$PWD/stdlib target/debug/jaic -interp
tests/portable-stdlib/basic-leak-reports.jai
fails at second make_leak_report(for_visualizer=true): twice logs Pool allocator
cannot change after first use, then null procedure call at pool.jai:allocate_block.
First report is returned by value and deinitialized through its moved Pool.
Pool's new Use_Record registry keys only the original Pool address; release at
the returned address cannot retire that original lifetime. Reusing the callee's
stack slot for a fresh zero Pool then rejects set_allocators and calls null.
This is an integration defect, not an invalid leak-report oracle. Preserve every
leak/count/cleanup assertion. Proper solution must support value-return ownership
in public Leak_Report without stale address-only lifecycle state, canonical
layout changes or private module/name compiler special cases. Add an independent
Pool value-return/reuse/release regression, plus keep this public foundations
fixture. Original log: artifacts/integration-clean/production-suites-refresh18.log.
Foundation run stops at this case after earlier positives; later cases unverified.

## Refresh18 portable reviewed refinements

Registry positive zero-extended HKEY values and caller-return ConvertToApollo
are settled by latest authoritative module specs. eab3383 still omits the ten
HKEY values and ConvertToApollo. Implement exact public forms and safe private
SDK handle translation where needed, with a typed containing Apollo_Time
procedure regression. Do not add a procedure result annotation or silently
sign-extend public constants. Native Windows evidence remains mandatory.

## Refresh18 production audio provenance/scope integration corrections

Integration corrected add_vbap_gain_for_direction visibility to the reviewed
public scope (sound-player.md explicitly lists it), alongside prior publicskip
helper. The earlier helper relocation was an integration mistake. Full production
27-case audio suite now passes host interpreter/nativeO0/O2, six-target source,
strict format/lint/private rejections and required actual2/6/8logicalstreams.
Additional integration-authored perceptual-volume.jai is recorded explicitly in
the manifest; producer26-case declaration alone had correctly rejected mismatch.
Disabled-global-assert Thread dependency remains open; copied audio facades in
test-stage are not production proof and must stay labeled/cleaned up.

## Refresh18 completed gates and precise partial-edit recovery failures

Whole workspace at7dc08ed:767aggregatepasses/16failures/oneinheritedignored;
fourfailedtargets. Detailed own log workspace-refresh18-reviewed.log retained.
Partial edits completed1086ownedfiles/28772edits/3285512assertions/twofailedfiles;
report artifacts/integration-clean/partial-edits-refresh18.json. No vendor or
opaque public corpus files selected. Failures are not crashes/incomplete workers.

1. stdlib/SDL/wrappers.jai last conditional import (source line51, augmentedline55)
   suffix cutbyte15: independent tail's literal23 loses typed hover/completion/
   inferred hint, falling back to Source syntax declaration. Head remains typed.
2. tests/compiler-regressions/modules/Rules_Scoping/context_part.jai
   #add_context rules_scoping_level :=5; suffix cutbyte12 (augmentedline7).
   Tail becomes part of a different valid current statement; strict scope oracle
   already records this, but anchors still require tail as a top-level symbol and
   typed locals. Review actual Context-extension syntax scope versus the harness
   oracle before changing production semantics or weakening assertions.
   Preserve unchanged source edits; no symbol-name special cases. Baseline
   semanticerrors SDL2/context0, both baseline syntax0. Re-run exacttwofiles
   after approved compiler4de36d6; then generalLSP/context fix or justified
   oracle repair with original evidence, not wholesale exclusions.

Full public binding source matrix:350passed18failed70unsupported declarations/
sourcechecks; privacy216passed72unsupported. FSEvents private-source test was
outside its legitimate boundary and embedded a producer .work library path:
verifier now uses general private placement/cleanup and fixture system-library
lookup through explicit native SDK directory. This is private ABI evidence,
not a promoted public export. Mobile CLI targets Android/iOS still unsupported;
remaining missing DXC/Objective_C/rpmalloc/X11 public names are genuine required
work. Full SDK dependency retry plus two official X.org transports again timed
out/reset with all hashes retained; scoped nativebuilds are not a full-pin pass.

Removed portable runner's default-allocator/x64 target exclusion. Its optimized
implementation gap is now a required failure rather than an omitted selected
case; do not add a libc fallback or change API/capabilities to hide it. Other
platform-only fixture classifications remain disclosed/require review.

## Real configured assertion tests without copied production libraries

For Thread/audio optional-assert proof, use reviewed Compiler.remap_import on a
real childworkspace before loading Thread/Sound_Player: map their Basic import
to a NEW testmodule that only reexports canonical Basic(ENABLE_ASSERT=false).
The wrapper imports only publicBasic and introduces no bootstrap/types/algorithm.
Actual stdlib source remains untouched; canonical bodies execute under the
configured import. Keep test-oracle Basicasserts enabled separately. A real
--context program can then supply this configuration to target-aware lint.
This is a proposed production-source verification architecture, not an executed
pass or requirement to infer new API. It avoids replacing text/copying library
facades used by current audio_no_assert staging. Verify correct host_module_name
from normal loader metadata, public privacy and negativebaseline before credit.

Remaining WASI fixtures depend on native-only reviewed Thread and POSIX/Windows
Basic.exit; original compiler scheduler coverage must migrate to independent
own compiler protocol tests while keeping genuine Thread platform rejection.
Do not add extra standard-library exports merely to satisfy old own conveniences,
nor change public applicationcorpus. Proper ownWASI tool/backend extension needs
documented architecture; unchanged jaifmt native build already passes.

## Refresh20 precise compiler and native input requests

Compiler owner: `tests/compiler-semantics/forward-enum-dependencies.jai` is a new minimal original reproducer. `jaic -check` rejects the later explicitly valued member LAST while evaluating MASK. The reviewed Socket AI.MASK on macOS/Android has the same forward dependency on ADDRCONFIG; full Socket contextual lint therefore fails before checking bodies. General enum declaration collection/dependency evaluation is required, preserving implicit numbering, conditional/insertion semantics, duplicate/cycle/range diagnostics and reflection order. Do not replace the public expression with fabricated constants or reorder the API as a compiler workaround. Red evidence: artifacts/integration-clean/forward-enum-red.log.

Coordinator input synchronization: the filtered mailbox approves window-render3ced6c4 and SDL3b4d6859, but neither object is available in this sanitized repository (`git rev-parse --verify <OID>^{commit}` fails); coordinator/window-render still387efe2 and coordinator/sdl3 still0b2dc3c. Please refresh those safe refs/objects. WGL387efe2, compiler093712a, portablee81f1a5, developer4f87fd6 and fuzz172558a are integrated. No remote fetch or peer checkout access was attempted.

## Refresh21 native dependency and environment follow-up

Sanitized ref synchronization is still outstanding: approved compilerf92f10e9, bindings78d73e86 and window-render39404f30 objects are absent here; refs remain093712a/2a18c3c/387efe2. CI2fa2bc2 and its SDL3/WGL repairs are already integrated. Please import the stable independent snapshots into this sanitized repository; no alternate Git access/fetch was attempted.

Bindings/native owner: latest Windows ffi.lib/binding_ffi.lib/sdl_abi_probe.lib/sdl_runtime_abi_probe.lib errors are not removable tests. tools/native_bindings/build_dependencies.py builds Unix ar/shared outputs and is absent from the Windows production workflow. The actual varargs bridge requires libffi; Windows needs a source-pinned, target-correct libffi/native helper build and proper artifact/search-path integration (both CPUs), not renamed .a files or fixture-only repair. Root host binding_ffi source-build against the official macOS SDK passes; no Windows completion inferred. xxhash __emulu remains assigned to bindings owner by filtered mailbox.

Foundations visualization runtime cannot acquire its exact public channel: actual official C SDK O_CREAT|O_EXCL probe reports errno17(EEXIST) for /Jai Memory Visualization, while a fresh own process-named channel creates/maps/releases successfully. No existing object was opened/read/unlinked, because its ownership is unknown. Canonical test remains failed; coordinator can rerun on an isolated native test host. No renamed public constant, memory-only substitute or test skip is introduced. Unique-channel SDK extent is16384 after requesting8192, a real macOS page-rounding observation.

## Current frozen Mac checkpoint and distribution audit

Candidate integration/thread-fixtures at ac9b8723813af8b108d92867932b97a084dbc6e4 in artifacts/integration-clean/thread-fixtures is running one complete native ARM64 workspace command, then the catalogue. Basic/Math b821bf6d, executable formats f68873b9, platform81c8217b and modelba878c70 are consumed. Focus and full original corpus remain coordinator-owned. Root tracking remains3b50fee6; do not use that as this candidate.

Distribution gap: tools/build_developer_bindings.py build() emits an absolute LLVM SDK rpath, symlinks bundled libclang to SDK, and writes absolute compiler-path.txt. Bindings_Generator/native-parser-api.jai:106 and native-extended-api.jai:540 name the relative private clang path; JAIC_NATIVE_LIBS is not proof that these direct paths relocate. Release workflow Package currently copies stdlib and builds general native-libs, without a demonstrated developer helper dependency relocation pass. Proper completion needs bundled dependency copying/install-name/RPATH handling and a relocated package smoke with SDK paths absent; no new override feature is authorized. Existing helper copy contract must remain. Platform owner should finish its assigned lookup path; integration retains general loader ownership.

## Compiler fixture contract follow-up, current candidate

compiler-typechecked-messages asserts every declaration belongs to main_import, but canonical library bodies now participate in interception. Preserve each declaration ownership/non-null assertion, distinguish application records by enclosing_import, and retain all Settings/VERSIONS/work/baked-layout/mutation assertions. Reproducer: tools/stdlib_runtime.py --case compiler/compiler-typechecked-messages --modes interp,native --opt O0. Do not restore library-body exclusion as a fix. Runtime_Support three fixtures explicitly expect a second conflicting reserved bootstrap instance; reviewed language module page still leaves differing-parameter instance semantics unresolved. Supply precise contract correction/independent oracle before changing that assertion. lang-asm and rules-simd-asm unguarded x64 instructions require host-appropriate test construction while keeping actual x64 native coverage; no fake zero CPUID.

## Basic callback bridge allocation loss reproduced

Independent public-API allocator regression against combined ac9b8723 fails with callback output copy allocation failure must survive the ABI bridge. stdlib/internal/basic/format-support.jai assigns builder.failed = scratch.failed after copying scratch buffers; that clears allocation failure raised by destination append. Integrator will preserve both failure flags and add the actual failing allocator test after the frozen catalogue exits, keeping active measurement immutable. This is an integration-owned repair to the canonical bridge, not an extra public API or allocator fallback.

## Ready checkpoint objects absent locally

Latest coordinator inbox requests bindings9bc40a8 platform audit and portable0504879 native crash-helper relocation. Neither object resolves in this sanitized Git. Please refresh only those independent producer refs/OIDs into this repository; no unrestricted fetch or alternate checkout will be attempted. Compiler59a69c03 is integrated at396707e7 with5 Rust catalogue tests,20 native O0 commands and rustfmt/clippy passing. CLI/lint/LSP rebuilt together from that source. The control inbox is preserved outside product commits. The WASI tour has native-only Thread plus native Input/Window_Type GPU dependencies; a partial Thread guard alone cannot establish browser compatibility. Required native and real sandbox scheduler tests must remain when migrating the example.

## Further ready input absent and release-policy conflict

Portable97eddd4 is named ready in the latest inbox but its object is absent here, as are0504879 and bindings9bc40a8. Please refresh those safe committed producer objects. Compiler89560db9 is now integrated at41e78573 and its19 focused tests pass. Basic.temp navigation defect is independently reproduced and a general IDE module-entity repair passes42 features/module tests; exit hover/definition and incremental edits pass without executing exit.

The latest working docs/tools/releases.md edit is preserved, but its historical-workflow rebuild instructions and editor0.18.0/compiler-v0.17.0 repin text conflict with this task restriction: only finalv0.17.1 after coordinator history insertion, no historical release rebuilds. No release/remote action was performed. Resolve that guidance and review tag/manual workflow triggers before any future publication; temporary ordinary CI must not dispatch release workflows.

## Latest reviewed generator contract drift

Fresh reviewed bindings-generator.md exposes three concrete gaps in current model helpers: gm_functions_equal in generator-model-helpers.jai compares return/VARIADIC and omits Function.name, while the public relation requires equal names/counts and is_same_type on compared arguments only. gm_visit_without_cpp classifies CPP flags rather than foreign_name !=name, missing mangled global C++ functions and incorrectly omitting equal-name flagged records. gm_macro_identifier in generator-model-lookup.jai rejects NEEDS_CHECKING instead of running real macro validation; check_macro_value itself is not implemented in the integrated facade. Please route exact public-record regressions to canonical model/emission owners; keep malformed-storage negatives and actual native macro effects. Do not certify the previous helper fixtures as fresh-reference equivalence. Uncached polymorphic extra-info/vtable production remains separately partial.

Owner LSP cf7dd80+5214e9c objects are now available. Integration will consolidate onto owner production implementation and retain independent JSON/member regressions, replacing d2577883 implementation without history rewriting. Latest inbox explicitly corrects final planned version to0.18.0; earlier0.17.1 conflict is superseded, while historical release rebuild instructions remain unsafe for this task. Publication remains held.

## Fresh combined deferred scheduling regressions — urgent

Frozen a7bd9b9c production catalogue reproduces compiler/compiler-module-placeholder-insert and compiler/placeholder-defined-by-metaprogram failing in both modes. Existing independent sources wait for a declared placeholder in a top-level #insert generator; the parent supplies definitions at TYPECHECKED_ALL_WE_CAN via interception. New dependencies.rs:satisfy_body_dependency_inner calls this deadlock before that phase can yield; consteval call_thunk increments ct_executions even when the thunk only requests an unlowered body, so expand_pending cannot park it as effect-free semantic work. Do not cancel/restart an executed prefix or special-case these fixtures. Proper fix must preserve interpreter continuation/exact-once behavior and permit the ordinary parent-interception phase to supply sources. Repro: stdlib_runtime.py --case compiler/compiler-module-placeholder-insert --case compiler/placeholder-defined-by-metaprogram --modes interp,native. Root plugin-evaluation/compiler owner should repair this general integration boundary; existing7 deferred positives/negatives must remain.

The static using Program_Print negative is stale after real serializer support; integration will preserve all reflected filter assertions and verify a real successful round trip. Native macos-events also caught a real Space event although it posts only A; focused serial reproducer is running. No assertion is relaxed. Json interp timed out at180.00517375000345 seconds; actual completed native Json case passes.

OID clarification:62b8f173 here is qualified C++ adapter generation, whose handoff still records absolute LLVM/libclang dependency gaps, not the claimed libclang relocation batch. Supply the intended relocation OID/closure; no partial libclang-only package claim will be made. Bindings9bc40a8 audit is still absent locally.

## Shared transition: compiler-owned filtered parameter using

The independently verified b02bf2da regression is retained in tests/stdlib-contract/compiler-using-records/main.jai. Its production Program_Print fix is intentionally not copied because compiler owns static-filter reconstruction/scanning in the shared tree. The retained parameter roundtrip currently needs that owner checkpoint. No c018dd52 live::alias semantics are admitted.

## Shared source ownership and remaining test integration

ASN1/Socket 67c9dc52, crypto/JKS 47bf26ec + cd8a6c33 and APK 3e89682b owned files are reconciled into shared production. Existing Socket null check and TIMEVAL alias are retained. Integration target: /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/integration/target; scratch: artifacts/shared-integration. Forward enums and corrected filtered storage reexports already exist in adc1e8f1. No unsupported live::alias behavior is adopted.

ASN1/Socket owner: replace archive/staging runner with shared production checks; coordinator must synchronize missing reviewed CMSG_SIZE/domain/hex paragraphs without replacing latest root specs. Crypto/APK owners: preserve all private framing/EVP assertions while replacing facade aliases/staged-library proof with independent unit coverage plus unchanged production public consumers. tools/check_shared_portable.py supplies the latter for nine fixtures, O0 native ARM64. Other platform/package execution remains open.

Generator/tools owner: all-zero PDB/CIE corruption is NOT waived. Shared tree initially has no target fixtures; 17 inputs in integrator retained target are nonzero (hashes: ignored artifacts/shared-integration/old-native-input-audit.json). Please name exact failing input, command and pre/post hash or supply independent reduction; preserve failed bytes before regeneration. Native fixture generation/consumption must be serialized with unique outputs and hash invariants. Root original corpus/Focus remains coordinator-owned.
