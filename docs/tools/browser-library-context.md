# Browser library context and diagnosed failures

The admitted ae6 scripting job117243021542 failed 19 cases. This repair is tested
against exact current independently authored producer0268330849a5b7c90a3b5291661307276ae53103,
not relabelled as that CI job. No corpus/reference implementation is an input.

## Explicit library layout

A module fixture used to be copied from `stdlib/Module/tests/file.jai` to
`/workspace/Module/tests/file.jai` while imports came from `/stdlib`. The compiler
correctly rejected its private imports: the caller was outside its library.
The adapter now retains the repository-relative `stdlib/` prefix and supplies
`libraryRoot: "stdlib"`. Every library source and supported test resource remains
in the request; unrelated audit metadata stays excluded by the d4 repair.

The engine pushes an optional relative library root on byte channel5 and checks
`jai_play_accepts_library_root` before using it. This field participates in the
unchanged16MiB aggregate bound and is cleared by reset. Ordinary calls omit it.
A stale binary fails explicitly instead of silently treating a private unit as an
external program. No capability or TypeId fallback repairs a mismatched artifact.

`run_with_library` selects that workspace directory as the actual compiler library
root, using its real prelude and import path. The old bundled tree is omitted in
this mode, so changing the selected library cannot expose unselected bundled
private sources. The compiler checks ownership normally; no visibility rule,
namespace, parser, source-access predicate or Core module resolver is changed.
External callers cannot import the supplied private helpers, and their public
facades can use those helpers. Absolute/traversing/dot/backslash/drive-like roots
and directories without a prelude reject as input errors.

Current module request:1351 files, path71219 +source16183557 +main40 +libraryRoot6
=16254822 bytes, below16777216. The independent boundary fixture adds five files
and remains16255253 bytes. No input-limit increase or source/test trimming occurs.
Conservative whole-source transport can eventually reach the bound as the library
grows; that must remain an explicit rejection pending a reviewed transport design.

## Failure phase and strict negative contracts

The API `exitCode` is a program exit, not the command-line compiler process status.
Compilation errors return null with error diagnostics. The old checker incorrectly
required a numeric nonzero program exit. `failurePhase` now distinguishes input,
compile and runtime failures without changing `exitCode` or inventing a result.

A check-fail contract requires a compile-phase failure and the precise expected
text in an actual error diagnostic. Rendered source containing that text, unrelated
errors, runtime traps, input rejections, missing results and successful programs
cannot pass it. An explicit error_contains contract expecting CLI failure status1
can match a diagnosed compiler/runtime failure; other explicit runtime statuses
remain exact. Original compiler/hash/HTTP diagnostic strings are unchanged.

The old Node oracle conflated tool failure status with program exit. Its replacement
assertions follow the documented PlayResult and actual browser protocol, retaining
nonzero runtime status/stdout/stderr controls and adding phase/error-message negatives.
No diagnostic golden is refreshed and no assertion is disabled.

## Predeclared browser-host capabilities

Two exact authored programs request measured REPORT_RUNS/POLYMORPHS. Core
`MetaOp::BeginIntercept` explicitly has no compiler-host monotonic clock on wasm32.
This is a host property, not a blanket target-WASM prohibition: a native compiler
emitting WASM may have the clock. These two browser cases require
`compiler-monotonic-clock` before dispatch and remain native execution obligations.

Three Bindings_Generator fixtures explicitly call clang_parseTranslationUnit2 and
real libclang callbacks. The reviewed public Bindings_Generator inventory specifies
those foreign SDK APIs; their imported implementation also requires native Process.
After layout repair they get past privacy and reach that genuine native boundary.
Their exact `native-libclang-sdk` requirement is declared before dispatch; no error
code/message determines availability and unrelated module cases are not deferred.
The initial three failures are retained. The canonical catalogue owner is asked to
adopt these exact SDK requirements across native/target selectors. Native checks
still require actual providers and must fail if those providers are missing.

Http router ownership remains selected. Its missing Group export is NOT promoted
to unavailable. Current Http/module.jai loads router/app only in its non-WASM branch.
An independent tiny actual-WASM reducer reproduces the missing public Group without
the original test complexity. Compiler/plugin/library owners must repair the
required source/export closure; this worker does not modify Extensions or load
native Http dependencies unconditionally to bypass that contract.

## Actual and source verification

The baseline source-built WASM reproduces six representative original failures:
invalid-workspace, private Hash seed, HTTP date negative, Debug state, resource-wire
and Http Group. The patched artifactSHA256 is
`ba78040feffc9d96d9a5a8e1e772227243d8b92dd8a7b96a820672e354524631`.
Matching engine/provider hashes and immutable source guards accompany it.

All 19 original selected IDs were replayed sequentially through the actual checker
and WASM:13 pass,2 predeclared clock exclusions,4 fail. The Hash positive baseline
also passes. Source review then declares the three native SDK requirements and
replays their actual predispatch paths:0 execution passes,3 unavailable. Final
combined evidence is13 pass,5 declared unavailable,1 required Http Group failure;
it is not a fresh single whole-job result. Full original logs remain preserved.
Android logger passes in WASM SandboxHost: write routes to virtual stdout/stderr,
without native SDK/libc execution. An earlier source-only mailbox qualification
was corrected after this authorized browser replay.

Independent actual-WASM probes verify owned private access, denied external access,
public facade access, malformed-root input phase, oversized-input rejection,
same-engine reset recovery and stale-artifact rejection. Native Rust tests cover
2 supplied-library boundaries and4 reset/byte/malformed protocol controls. Scoped
Rustfmt and native Clippy lib/tests -Dwarnings pass. Node19 and canonical Python6
tests pass. Existing Core wasm-only dead-code warning is recorded, not suppressed.

All artifacts and temporary paths live in assigned T7 lsp/scratch/browser-ae6.
The local72b3afcd alignment is a prerequisite only: integration already owns it.
Transport only NEW narrow changes on that baseline, preserving source/engine pairing.
No Core, stdlib/Extensions, API oracle, timeout, benchmark, release or remote action
changes. Actual merged CI, native Windows and the remaining Http closure are still
required; producer-local evidence does not establish a green release matrix.
