# Basic float formatting and the compiler's Long_Double extension

## Resolved: root ext.14 presentation policy review

Root approved the existing compiler extension's float64-presentation promise for plain, `FormatFloat`, aggregate, variant, distinct, and borrowed values. Formatting modes operate on the converted binary64 value; original wide precision/range and shortest-wide output are not promised. This is an own-compiler extension policy, not a new official Jai type claim. The implementation and focused evidence are documented in [Basic wide-float presentation](../../basic-wide-float-presentation.md).

The diagnosis and proposed probes below record the initial question. Their approval dependency is superseded by that review; original Linux native verification remains required.

## Required failure and source cause

Linux CI's `stdlib/Extensions/Long_Double/tests/libm-foreign.jai` remains a required positive. Root reports that interpreter and native execution reach Basic's 4/8-byte assertion. The original fixture and its `tprint("%", sqrtl(one * 2)) == "1.414214"` assertion remain unchanged. Exact sanitized CI argv, diagnostic, architecture, and tool identity have been requested; no Linux execution is claimed here.

The current source path is:

1. `render_item` in `stdlib/internal/basic/format.jai` sends reflected `.FLOAT` values unchanged to `print_float`, with the active style's defaults.
2. `print_float` in `format-float.jai` delegates to `emit_float`.
3. `emit_float` unwraps variant metadata and asserts both float kind and runtime size 4 or 8. The remainder decodes IEEE binary32/binary64 bits. Merely accepting size 16 would incorrectly read and decode the value.
4. The compiler's `long_double_for` selects x87 on Linux x64 and binary128 on Linux ARM64. Its public Long_Double declaration documents 16-byte wide storage on those targets; both therefore reach the unsupported-size assertion.

The source evidence identifies a missing presentation conversion, rather than a foreign `sqrtl` signature failure or a caller/path-specific routing defect. This diagnosis does not establish the policy for that conversion.

## Contract question for reviewer/root BEFORE production or fixture edits

The reviewed Basic module specification says floats use the active defaults and `FormatFloat` requires a float value. It does not specify wide-float precision/range or conversion policy. Separately, this compiler's public [Long_Double documentation](../../language/long-double.md) at rule ext.14 and `stdlib/Extensions/Long_Double/module.jai` explicitly promise printing through float64. This is an opt-in jaic extension, not an official Jai type/module. The documentation's obsolete implementation-file reference is not an implementation input; that body was neither sought nor read.

Please confirm whether the compiler-owned ext.14 float64-presentation policy is approved for integration with Basic. If approved, clarify that it covers plain values, explicitly constructed `FormatFloat`, nested aggregate members, and numeric variants, and that formatting modes operate on the converted binary64 value. This would preserve the existing fixture expectation while distinguishing the compiler extension from official Basic compatibility. It must not promise preservation of the original wide precision/range or shortest representation.

Potential production scope, awaiting that review: the `emit_float` conversion boundary and a private helper, if necessary. `render_item` already forwards the right metadata/payload; no fixture-specific branch is justified. Conversion must use the actual represented format, preserve borrowed storage, and keep nonfloat rejection and binary32/binary64 behavior. A 16-byte size alone is not sufficient evidence of a supported representation. No assertion waiver, caller cast, target skip, or new public export is authorized by this question.

## Independent control proposals

Authored inputs are pinned in the own T7 `stdlib/basic-long-double-diagnosis` packet; they have not been executed or admitted as passing tests.

- Official public-type control: binary32/binary64 plain and `FormatFloat` output, including a distinct binary64 wrapper. Only these existing public types are suitable for an official Jai probe. Root should use its already authorized runner and return exact version/host/argv, compile status, runtime status, stdout/stderr, and input hashes.
- Nonfloat negative: `FormatFloat` with a nonempty integer payload. Keep rejection required; confirm the public failure classification without guessing an exact diagnostic or exit code.
- Own compiler metadata control: Long_Double kind, runtime size, explicit arithmetic/cast identities. Source-check and interpreter/native on Linux x64 and ARM64 independently of foreign libm calls.
- Own compiler presentation control: direct, boxed borrowed, explicit `FormatFloat`, aggregate, and distinct Long_Double values. The existing ext.14 proposal expects the binary64 presentation of a simple exactly representable value. After policy approval, add exact half-way rounding, signed zero, NaN/infinity, overflow/underflow-to-binary64 and shortest-after-conversion controls. Preserve the original sqrtl fixture as an independent full integration positive.

An official import of `Extensions/Long_Double` would test an unsupported extension name, not the conversion policy. No official wide-type verdict is requested unless root identifies a separately reviewed official public type with that representation.

## Disposition

At the initial diagnosis checkpoint, production and original fixtures were unchanged. Following the approved review, only Basic's private `emit_float` conversion boundary changed; original fixtures remain unchanged. New focused controls now exercise both Linux interpreter representations and native Mac ARM64/x64. The original Linux sqrtl interpreter/native CI replay remains required; local cross-configuration interpretation is not Linux native execution. The atomic/x86/output-boundary compiler work, allocator alias seal, and completed HTTP lifetime packet remain untouched. No reference bodies, previous library sources, native reference binaries, network service, benchmark, or arbitrary fault program was used.
