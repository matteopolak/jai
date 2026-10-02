# SIMD source syntax

## What it is

The syntax layer retains the closed SIMD `#asm` subset demonstrated by the upstream `examples/28/28.6_simd.jai` source. It produces typed opcode, feature, and width enums and separately retains unsupported statements as source spans so inactive source branches can be selected before semantic diagnostics.

## How it works

`#asm` statements contain optional comma-separated `AVX` and `AVX2` requirements followed by a brace-delimited block. Register declarations use `name: vec;`; instructions use `movups`, `addps`, `movdqu`, or `paddb`, each with an `.x` or `.y` modifier. Operands retain source order and are either register names, inline register introductions such as `v1:`, or bracketed addresses parsed with the ordinary expression parser.

```jai
#asm AVX, AVX2 {
    movdqu.x left:, [ptr1];
    movdqu.x right:, [ptr2];
    paddb.x sum:, left, right;
    movdqu.x [ptr3], sum;
}
```

`StatementKind::Simd` wraps a `SimdBlock`. Blocks, feature requirements, declarations, instructions, and operands preserve source spans; register names use the same interned `Symbol` table as ordinary source. `AVX` and `AVX2` have closed feature tags. Other valid feature identifiers, including Runtime Support's `SYSCALL_SYSRET`, retain their interned identity as `SimdFeature::Unsupported(Symbol)` so inactive platform branches remain parseable; selected use receives a semantic capability diagnostic. Malformed feature lists remain parser errors. Known SIMD instructions retain strict width and operand parsing. Unknown instruction names and non-`vec` register declarations become `SimdStatement::Unsupported { span }`; their tokens must balance parentheses, brackets, and braces and end with a semicolon. This retained syntax supplies no assembly string or evaluated expression to later stages. Semantic checking diagnoses unsupported statements only in selected source branches.

Exact `int3;` statements use `SimdStatement::DebugTrap`. Exact `int 0x41;` statements use `SimdStatement::Interrupt`, with a checked `u8` integer vector retained alongside the span. Invalid interrupt literals and unterminated or unbalanced syntax remain parser errors, even in inactive branches. Semantic checking decides instruction arity, register identity and initialization, operand types, target feature constraints, and interrupt support; parsing a block alone does not establish that it is executable.

## How to change it

Extend the closed enums and parsing matches in `crates/jai-syntax/src/simd.rs`, then add source-backed cases to `crates/jai-syntax/tests/simd.rs`. Any new opcode or width needs corresponding semantic checking and execution support before it is accepted as compiled functionality. Preserve ordered operands and their spans for later diagnostics. `vec` is local assembly register syntax; it does not introduce a nominal vector type or change ordinary records named `Vector` or `Quaternion`.

`crates/jai-codegen/tests/simd_source.rs` exercises independently authored, headerless source through checking and VM execution. It checks every float and byte lane, including byte overflow, plus address-call evaluation counts and overlapping load/store snapshots, and emits newly generated x86-64 objects at O0 and O2. Object headers verify the emitted architecture. Executable checks run only on an x86-64 host that reports AVX2; ARM hosts verify portable VM behavior and native architecture rejection without executing x86 artifacts. Negative source fixtures retain located diagnostics for operand shapes, initialization, scope, and declared feature requirements.

The same source suite evaluates an AVX float operation through `#run`, embeds its checked result into runtime `main`, and verifies that native reachability omits the SIMD helper and vector instructions. It then links and executes a newly generated object for the actual host, requiring exit code 42. This staged path works on ARM because the SIMD computation runs in the checked VM and the emitted runtime program contains only the embedded result; it does not enable x86 SIMD instructions on ARM.

The original OpenJai corpus example is an optional runtime-read parser probe because `corpus/upstream/` is ignored. If absent, its test prints an explicit skip message. Mandatory self-authored tests still cover all supported widths, register declarations and introductions, feature identity, spans, memory expressions, inactive unsupported syntax, and malformed input. No corpus source is copied into tracked fixtures.

## Configuration

There are no parser environment variables or feature flags. Source declares assembly feature requirements with `#asm AVX` or `#asm AVX, AVX2`; `.x` and `.y` are retained as `SimdWidth::X` and `SimdWidth::Y` for checking and lowering.

## Dependencies

The implementation uses the existing lexer `Directive::Asm`, punctuation tokens, the syntax expression parser, and `jai-source` symbols, spans, and diagnostics. The source corpus is evidence for accepted syntax; no original native artifact is loaded or executed by the parser tests.
