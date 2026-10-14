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
