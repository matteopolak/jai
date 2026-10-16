# Required generator runtime CI: provider setup and reviewed C++ pairing

The ac174e80 Mac ARM64 required C++ job failed before native consumption, loading
`developer_tools_cpp_custom`. Linux reported unavailable `gp_library_open`.
Current source inspection and independent controls separate actual preparation
and filename search from compiler foreign-call routing. No compiler dispatch,
thread naming, WASM/Console, workflow, public signature or generated ABI is patched.

## Narrow repair

- `build_generator_platform.build()` is now a callable canonical builder using
  the same official SDK discovery as other developer tools. The CLI remains
  available. On Linux it really builds the shared provider with PIC and libdl;
  it does not rely on a Darwin-only verifier running first.
- The C++ checker builds that actual helper and its original native C++ input
  **before** invoking the generator. Generated adapters can only be compiled
  afterwards, in a separate process. Original C-model regression inputs are
  likewise built before their required roots rather than relying on later outer
  orchestration or stale target artifacts.
- Existing generator fixtures specify their output directory through public
  `library_search_paths`. The provider/setup checkpoint retains every existing
  assertion; the separate reviewed migration below corrects its invalid pairing.
- Within each search location the canonical provider keeps literal filename
  priority and also tries the conventional POSIX `lib` prefix on the final path
  component. Both shared spellings precede static fallback. An already-prefixed
  filename is not prefixed twice. Windows literal-name rules are unchanged.
  The logical/physical Library_Info separation and native handle identity remain
  intact; no loader environment override or renamed fixture image is required.

The prefix search policy is implemented coherently and tested against real SDK
images. The exact public compatibility refinement was requested in
`specs/questions/generator-runtime-ci.md`; native-host versus cross-target
availability is likewise kept distinct. No automatic target-ABI host remap was
introduced. Ordinary host execution uses the existing NativeHost and real helper.

## Real evidence, not whole-workflow acceptance

All artifacts are in the assigned T7 namespace
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/generator-platform/runtime-ci-ac174e80`.
The immutable final capture `capture-34_er4z6/verification.json` uses compiler
SHA-256 `455327f294ddaef87afb109be7f9e3223f8209003cfac9bf6dc1e41d678e233a`
built from its captured current shared Rust sources, with `source_drift = []`.
Ambient dynamic-library search overrides are removed; source-built helpers use
their normal canonical locations. Official LLVM/libclang closure is prepared in
the capture, not taken from an old checkout or another worker's cache.

The capture records **33 passing command controls and five retained required RED
observations**, never a 38-pass CI result. The 33 include one deliberate
missing-helper negative control, along with builds/source checks. Positive native
controls include:

- Real SDK image open, symbol lookup, native return value, close and reopen.
- Missing canonical helper reproduces unavailable `gp_library_open`; building
  that actual helper alone makes the same source execute successfully.
- The public provider and direct helper execute interpreter/native Mac O0/O2,
  including real value calls and closed-image lifetime handling.
- Actual generated C++ adapters link and execute SDK O0/O2 overload, POD out
  result, and reference identity/mutation assertions.
- Source-built formatting, seven complete strict provider/fixture lint contexts,
  and six desktop C++ source checks pass.

The separate preparation tests validate Linux builder arguments, ordering of real
input builds before the first emitter, and preservation of required assertions.
They are not counted as native Linux or C++ functionality proof. Python formatting
and Ruff checks pass. The initial source-lint context-path mismatch was retained
and corrected by supplying the current stdlib through the standard compiler
setting; no incomplete lint result is credited.

## Preserved initial C++ failure evidence

The unchanged emitter now passes `generate_bindings` and `generate_bridge` but
fails `inner_prints == 4 && foreign_prints == 8`. A failure-only diagnostic variant
retains that assertion and records **inner=0, foreign=4**. The original assertion
also fails in native O0 and O2. No callback is invoked merely to satisfy a count.

There is a second concrete workflow mismatch. Generated Jai names the original
C++ manglings and returns `Custom_Record` by value. The separate bridge exports
C adapter names and takes a leading out pointer for that result. The unchanged
consumer assumes the latter ABI and source checking fails at its original
`G.make_custom_record(*record, value = 41)` call. The reviewed contract explicitly
does not promise an automatic cross-call rewrite between those two generation
workflows, and says C++ bridge arguments do not use the Jai printing callback.

The initial diagnostic verifier still exited nonzero after retaining these REDs.
Original logs and failing destinations remain available in that immutable capture.

## Reviewed fixture migration

The updated reviewed contract distinguishes ordinary Jai printing from C++
adapters. The fixture checks one foreign-argument callback per visible ordinary
function: four functions after redeclaration coalescing and omission. Those
functions require no outer/inner argument wrappers. It snapshots all three
counters before bridge generation and requires they remain unchanged afterwards.

A second independently authored real native C input has one const-int pointer
parameter. Its visitor requests the supported `NEEDS_ARGUMENT_WRAPPER` and
`POINTER_TO_VALUE` transformation. Ordinary generation must invoke each callback
mode once. The actual consumer calls the generated value-taking wrapper with 10
and requires the native pointer-taking implementation to return 103. This control
exercises callback paths rather than manufacturing bridge callbacks.

The old negative-name case assigned the same name to integer and floating
overloads, which are valid ordinary Jai declarations. The first migration replay
retains that failed negative assertion in `capture-3cj_bfl3/verification.json`.
The fixture now supplies a lexically invalid output identifier instead, retaining
both false-return checks, error logging and unchanged destination verification.
The next replay, `capture-ad4kowza/verification.json`, passed those checks and
correctly rejected an initially misspelled schema offset check. The corrected
schema uses `offset_of(Custom_Record, "number")`; an independent source-only
consumer check passes. Neither issue required a production/compiler change.

The emitter writes a separate adapter schema with C export names, a leading output
pointer/void return for the POD result and a pointer-shaped reference return. The
consumer retains the integer/floating overload, POD value and reference identity
and mutation assertions. Ordinary bindings retain C++ names and a by-value POD
return. Each emitter phase also requires source rejection when that ordinary
schema is paired with the adapter consumer. An unrelated compile error cannot
satisfy this negative control.

The targeted runner formats and strictly lints all three schemas and builds real
adapters at SDK O0/O2 for every interpreter/native O0/O2 emitter phase. Consumer
interpreter and native results remain required. The proof runner no longer
injects the historical invalid assertion; the immutable initial RED receipts
retain it.

The immutable `capture-f0ybh9je/verification.json` completed all three emitter
modes, six SDK adapter builds, six interpreter consumers and six native consumers.
All original C++ result assertions and the new callback wrapper result passed.
All three schemas passed formatting and strict lint in every emitter phase;
the wrong-schema source rejection passed three times. The combined runner then
failed the required, unchanged `bindings-custom.jai:48` enum conversion check.
This is a C-model dependency routed to the model/tools owner, not C++ success for
the whole checker. Its initial combined-failure receipt remains immutable.

The runner exposes separate C++ and C-model phase functions; default `main`
still requires both. The verifier records both phase results, collects remaining
SDK/source/lint evidence after a C-model failure and exits nonzero if that required
phase fails. A focused policy test requires default-main propagation of a model
failure. No native Linux or complete CI acceptance follows from Mac C++ results.

Final named-phase evidence is `capture-ohxeb546/verification.json`, compiler
SHA-256 `b30cbe41728ec7e6fcb8c9a6c85adc40fa7435801e7c91ca677aa1bfeb7a33b4`,
with `source_drift = []` and all recorded live-owned files matching the capture.
Its 34 command rows contain 33 passing controls (including the deliberate
missing-helper negative) and one required C-model failure. The C++ phase passes
all real emitter/consumer modes; independent generated-adapter SDK O0/O2 controls,
owned Jai formatting, eight complete provider/fixture strict-lint contexts and
six desktop C++ source gates pass. The verifier deliberately exits nonzero for
the model failure. No whole-CI pass is claimed.

The two changed Jai roots additionally pass 14 current source/strict-lint checks
across Mac/Linux/Windows x64/ARM64 with no source drift. Five focused Python
policies, Ruff and Python formatting pass. Exact source hashes, the NEW-only
fixture packet and remaining dependency inventory are recorded in
`status/generator-cpp-reviewed-ready.json`. Integration alone commits the packet.

## Integration dependencies and boundaries

Integration alone owns Git/index and shared CI/native preparation. It must stage
the source-matched generator provider on every required native host and retain
libclang/debug helper closure for the separately reported Mac ASan job. Linux
native jobs must replay the original required tests; Mac evidence cannot clear
Linux runtime failures. Cross-target source checks do not establish host-call
ABI remapping. Apple text stubs and other previously unsupported native domains
are unchanged. Release remains held.

The NEW-only patch and exact before/after source hashes are in
`status/generator-runtime-ci-ready.json`. No old provider body/history, reference,
quarantined implementation or unrelated peer work is included. Consume only that
narrow provider/setup patch separately from the reviewed fixture migration,
without replacing peer work.
