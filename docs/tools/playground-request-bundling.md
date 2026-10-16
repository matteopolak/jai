# Browser stdlib request bundling and scalar protocol

## Failure and causal classification

The user reports actual job117201496850 at source833 failing many browser stdlib
cases with `input byte limit exceeded`, despite earlier Rust-suite passes.
The exact job source/artifact/count receipt was requested through the filtered
inbox and has not yet been supplied. No job logs, credentials or harness auth were
accessed. Source and actual execution evidence below belongs to the independently
authored safe current producer673a14d9e69dc17b17ae54748b99562205561869.

The checker gave each module-family test the entire stdlib text tree, including
large audit inventories, coverage JSON and library documentation. These are not
execution fixtures. The scalar ABI counts every UTF-8 path/content/main byte
against16,777,216 bytes per reset. Module tests were already over that budget
before compilation. Fresh Worker/engine per case plus engine.prepare resetting
before each request ruled out an assumed cross-case accumulation cause.

Actual source-pinned WASM replay:

| Request | Files | Paths | Contents | Main | Total |
| --- | ---: | ---: | ---: | ---: | ---: |
| Original source/text bundling |1359|62073|26805098|40|26867211|
| Source plus test-fixture bundling |1346|61568|16173379|40|16234987|

The original request is rejected with exactly `input byte limit exceeded`.
The corrected request runs the unchanged
`Basic/tests/portable-filetime-kernel.jai` twice on the same engine, each returning
exit0, stdout `ok\n`, no errors. This is an original pure arithmetic fixture;
no exit program, native SDK, GUI, fault or network operation was executed.

The complete original checker, selected to this case, reproduces0pass/1failure
with the limit crash. The patched checker with matching engine/wasm reports
1pass/0failure/0unavailable in a fresh worker. A separate genuine oversized-source
probe33012236 bytes remains rejected, with input counts, and is not counted as
unavailable, expected Jai rejection or passing execution. The temporary probe
was removed in finally; accepted source files are untouched.

## Narrow repair

`tools/playground_request.mjs` collects every Jai source, including sources used
by relative/cross-directory #load, and all supported txt/json/md fixtures under
test directories. Module workspace paths/base/main stay unchanged. Unrelated
non-source library audit/documentation outside test directories is not resent as
user input. Other regression-family workspace collection keeps its previous text
classes. No selected testcase, precise negative oracle or target-capability/
unavailable classification is removed or changed.

AppleDouble `._` sidecars are filesystem metadata and are excluded; real dotfile
fixtures such as .settings.json under tests remain. This mattered in the own T7
capture: the first actual replay still exceeded the limit because1346 generated
sidecars added5604396 bytes. That failed staging receipt is retained separately
and is not attributed to Linux job833. Node red/green coverage confirms this
distinction. Every actual source and test fixture remains present.

The host measures UTF-8 wire bytes (file paths, contents and main), not UTF-16
string lengths or filesystem allocation. A rejected request is reported with
these counts. It cannot satisfy a Jai negative test or become native-unavailable.
A WebAssembly runtime trap remains classified as a compiler crash. Native/graphics
family selection and unavailable diagnostic handling are unchanged.

No Rust product protocol, limit, state transition, compiler/parser/sema/import/
IDE cache or stdlib/Extensions source is changed. Three protocol-only Rust tests
cover exact aggregate limit across channels, rejection then reset, all buffers/
errors/output cleared with execution limits preserved, and malformed byte/channel/
UTF-8 path rejection. Rust run tests were not substituted for the actual WASM
consumer; both source checks and actual replay are recorded separately.

## Verification and ownership

Own T7: `scratch/wasm-request-20261016`,
target `target/wasm-request-20261016`.
The safe tracked-source snapshot includes four current Rust packages, NEWstdlib
and independent reviewed test families, rejects unsafe/link members, and pins
source673a14d9e69dc17b17ae54748b99562205561869. Cargo workspace was narrowed for
the build; every retained lock package record is byte-equivalent as structured
data, with only unused records removed. The existing cooperative-tour source was
required by include_str for test compilation; it was not executed.

Checks:5 Node host tests,3 Rust protocol tests, JS syntax, scoped rustfmt, jai-wasm
native Clippy lib/tests with warnings denied, and source-built wasm32 build pass.
The wasm build emits an existing target-specific Core dead-code warning; no
compiler edit or lint suppression was introduced. Source guard checked2175
archived files: only workspace/lock adjustments and the owned Rust test addition
differ. Protocol product bytes, compiler and stdlib/Extensions are unchanged.

WASM SHA256:
`aee77e838b3e4d712f14f435894f97f541d3e9cb677c308e672eddd82ad0e6ea`.
Stage build-metadata pins matching engine/provider sources. Actual replay logs/
JSON, initial setup/staging failures, source guards and command results are durable.

Local prerequisite177d4203 adopts only the NEW producer's already accepted
catalogue-based checker, so the owned patch can be narrow. Integration already
owns that prerequisite: do not replay it or replace a whole accepted script with
an older ancestor. Apply only the new source diff plus helper/tests/docs.
Integration alone owns the shared index. Native lease was released after the
bounded protocol/pure-WASM checks; no unrelated LSP performance work was added.

## Limits and final integration

Collection intentionally keeps all module-workspace source for relative loads.
It is conservative, not an import/dependency parser. A genuinely larger source
and fixture workspace still exceeds16MiB and must report rejection; no source is
trimmed or limit silently raised. Future request-resource declarations or a
reviewed dependency transport could reduce that source payload, separately from
this repair. Non-source fixtures belong under test directories; new cases needing
outside resources require explicit workspace-input review rather than a hidden
bypass. Full module/API browser coverage is not claimed by one portable case.

Root must apply the exact NEW patch and replay the original scripting job/full
consumer with the actual accepted source and matching build tools. Source673
results do not establish exact833 or the full browser suite. Unsupported native/
SDK/graphics capabilities remain unavailable evidence requiring their normal
target checks, not browser passes.
