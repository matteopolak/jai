# Foundations catalogue target and negative-mode contracts

This batch classifies exact independently authored programs using public module
guards, fixture purpose and the native SDK dependencies they actually call. It
adds no diagnostic-driven availability, public API, fallback or human deferral.

## Selection and accounting

`foundations_case_capabilities.NATIVE_SERVICE_CASES` names individual mixed
compiler, Io/Tls, Linux-linker, Simp, resource-image and rpmalloc programs.
Thread/System/Process accept Windows, Mac, Linux and Android; Socket accepts
Unix/Windows. Io/Tls explicitly reject WASM fibers. Default Simp loads GL, whose
guard accepts Windows/Linux/Mac. The rpmalloc fixtures require the real native
SDK and callback-context/thread provider. ICO image construction calls the native
stb resize provider. Desktop execution remains required: missing native libraries
are failures, never successful or unavailable native results.

The Windows TLS/JSON provider reproductions are Windows checks recorded in the
existing HTTP/TLS target repair. They import Tls even where the main operation is
JSON freeing. General TLS tests remain required on supported desktop platforms.
The private linux_build fixtures exercise Process-dependent linker machinery;
their names do not make them WASM-portable or prove the Windows-only public
plugin workflow on Mac.

`http-date-target` supplies explicit epoch seconds and remains required on WASM.
Http loads date.jai unconditionally and date_native.jai only outside WASM. The
unchanged `http-date-now-wasm-negative` therefore has an explicit check-fail
contract for both WASM modes: nonzero compilation with the precise missing
`http_date_now` member diagnostic. Native modes keep their positive behavior.
Arbitrary errors, timeouts and unavailable status cannot satisfy this negative.

`case_for_mode(case, mode)` returns an independent top-level case overlay.
Dispatchers must use that result for expected-result checks and negative counts
as well as availability. Integration owns the runtime-wrapper import/overlay
hunk; browser/LSP owners must consume the same policy. The browser's current
diagnostic-driven unknown-library/unavailable promotion remains an outstanding
selector dependency. The external candidate runtime hunk is tested through the
real Python runner with mocked commands: dispatch evidence, not program execution.

## Portable controls and real inputs

The original portable-data-resource program is unchanged. Its real resizing,
ownership and file writes require the caller's scratch directory (`args.count ==
2`, including the program name). Integration owns argv preparation; no fabricated
argument or image result replaces that workflow.

The new portable-data-resource-wire control separately tests checked directory
extents, borrowed payload identity, resource-ID boundaries, malformed/truncated
input and version overflow. Its payloads are opaque bytes, not decoded images.
The new foundations-portable-compile-time control exercises baked enum defaults,
recursive #run and phase distinction without native System/Process. Original
mixed programs remain required native checks. Existing HTTP codecs and bootstrap
atomic scalar controls also remain selected on WASM.

Integration also requested a separate allocator-caps fixture correction. Its
default-allocator query now expects CREATE_HEAP and IS_THIS_YOURS on the reviewed
`(CPU.X64 && OS != IOS) || OS.NN_SWITCH2` heap branch, retaining the exact fallback
bits elsewhere. Pool identity, actual allocation, temporary/debug allocator and
all existing lifetime assertions remain. No allocator implementation changes.

## Architecture and integration obligations

lang-asm and rules-simd-asm remain x64-required, including on Linux x64. Both
sources assert real CPUID outputs are zero: leaf-1 EBX in the former, and
EBX/ECX/EDX plus XGETBV in the latter. This is an observed source premise, not
proof of the newly reported Linux failure. Exact Linux diagnostics are requested.
No generic backend deferral is authorized here. TODO's named corpus x64/Vulkan
deferrals do not apply to these regression IDs. Native Windows console colors
retains its existing explicit human deferral. Reference-rejected fixture hash
accounting is unchanged.

GetRect4 is numerics-owned and Debug is stdlib-tools-owned; their policy is not
duplicated. The numerics T7 packet was OS-denied and its shared transport directory
is absent in this sandbox. Safe admission is requested without alternate access.

Root reports 128 failures in job117201496943: 19 interpreter, 16 native, 46 WASM
interpreter and 47 WASM native. Exact sanitized case/mode diagnostic records have
not been admitted here. Counts alone cannot establish their execution outcomes.
The generated case-mode-policy receipt is explicitly a selection inventory with
passed=null, not CI execution. Catalogue counts are recorded at capture time;
other owners add controls, so no old444/full400 receipt is relabelled.

## Verification

Frozen previously source-built jaic/jailint tools are reused and hashed; no
moving-HEAD rebuild or complete SDK/catalogue replay is claimed. Commands, hashes,
diagnostics and portable results are recorded in [the handoff](../status/foundations-catalogue-128.json).
Earlier failed setup/lint harness receipts remain separate. Native provider
closure, Linux/Windows execution, selector adoption and root CI replay remain
required integration gates.

Final auditing found all six generated WASM modules had become zero-filled after
their earlier successful Node executions. The files and successful command
receipts are retained, but durable emitted-WASM replay proof is withdrawn. This
matches a separately reported producer durability problem; its cause is not
established here. No library fallback or unavailable classification hides it.
WASM source/lint/interpreter evidence and Mac native runs remain separate.

Integration adoption: runtime dispatch and the browser catalogue now select the exact mode contract before execution. Browser diagnostics never create an unavailable classification. Local integration checks: 15 capability policies, 12 runtime-runner policies, and 5 browser-accounting policies passed; these are not native/browser engine execution proof. The producer emitted-WASM durability evidence remains withdrawn.
