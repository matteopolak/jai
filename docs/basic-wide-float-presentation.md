# Basic presentation of the compiler's wide float

Root's reviewed ext.14 policy approves the compiler's existing `Long_Double` promise: format its conversion to float64. This applies to plain values, `FormatFloat`, aggregates, variants, distinct values, and borrowed `Any` storage. Decimal, scientific, and shortest modes operate on that converted binary64 value. It does not promise preservation of wide range, precision, or a shortest representation of the original wide value.

Only `stdlib/internal/basic/format-float.jai::emit_float` and its file-private type constant change. After unwrapping numeric variant metadata, binary32/binary64 follow their existing path. Other float storage must have the canonical compiler-selected long-double metadata identity. The compiler's normal cast then converts the actual x87 or binary128 representation to a local float64, which enters the existing formatter. A storage size of sixteen bytes is insufficient to select this path. No raw wide-bit decoder, public export, Extensions import, caller/path exception, or fixture cast was added. The local copy neither changes the caller's metadata nor writes borrowed payload bytes.

The original `tests/extensions/rules-jaic-extensions.jai` remains unchanged, including its libm calls and expected `1.414214` result. The original extended arithmetic fixture, Basic IEEE float fixtures, public signatures/layouts, and completed HTTP/runtime allocator work remain unchanged.

## Focused controls

[long-double-formatting.jai](../tests/extensions/long-double-formatting.jai) covers plain/borrowed values, explicit formatters, arrays/structs, distinct and nested `isa` wrappers, payload-byte preservation and borrowed identity/mutation visibility. It compares presentation in all modes with the reviewed binary64 conversion and independently asserts an exact midpoint rounds to `1` while a representable wide value above it prints `1.0000000000000002`. Cases include signed zero, NaN, infinities, wide values outside binary64's range, and IEEE32/64 shortest values.

Dedicated negative inputs in `tests/extensions/negative/` require rejection of integer `FormatFloat` payloads, rejection of a synthetic sixteen-byte float descriptor without canonical identity, and absence of the private type name from Basic's exports. They are not ordinary positive catalogue entries. Interpreter negatives execute and require the specific guard classification with no continuation; privacy negatives must fail source checking. No assertion is disabled.

Before production changed, the positive control reproduced the expected IEEE32/64 assertion in both Linux x64/x87 and Linux ARM64/binary128 interpreter configurations. The earlier incorrect authored distinct-type syntax is preserved separately as a setup failure, not a behavioral red result.

Final guarded verification passes 59 commands: five formatting checks plus the final formatting write; 14 positive source checks (new control and original sqrtl fixture across seven profiles); seven complete strict lint contexts; seven private-name source negatives; five positive and ten negative interpreter runs; two existing Basic fixture interpreter runs; and four native builds/runs. Native execution is Mac ARM64 and x64 at O0/O2. The final guard covers 1,391 source inputs with no drift. Additional strict lint of the valid negative fixtures is recorded in the ready manifest.

The compiler and linter were freshly source-built using locked, offline dependencies in the owner's T7 namespace. [The ready manifest](status/basic-wide-float-ready.json) pins tools, source inputs, executable headers/hashes, command receipts, and the new-only patch inventory. Prior diagnosis, setup failures, and initial successful executions remain preserved.

## Remaining verification

Actual Linux x64/ARM64 native execution and the original foreign-sqrtl Linux interpreter/native CI replay remain required. Cross-target source checks and local interpretation do not establish those Linux execution gates. Windows received source/lint/privacy checks; Windows native execution is not claimed. WASM interpreter checks exercise binary128 conversion, but emitted-WASM durability and native SDK providers are separate compiler/integration dependencies.

No sanitizer settings, allocator behavior, compiler conversion implementation, public float metadata, or Extensions source changed. Integration remains the sole index/commit owner.
