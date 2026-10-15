# Integration requests

Requests are read by coordinator; this worker cannot send messages to the desktop thread.

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
