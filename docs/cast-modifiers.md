# Cast modifiers

## What it is

`jai-types::CastModifiers` preserves the distinction between checked casts, `NO_BOUNDS_CHECK`, `TRUNCATE`, and the two storage reinterpretation strengths. Parser and compiler metadata consumers share this typed policy rather than treating every permissive cast as the same flag.

## How it works

A default modifier set selects `CastMode::Checked`. Inserting `CastModifier::NoBoundsCheck` selects `Unchecked` and emits compiler flag `0x8`; inserting `Truncate` selects the distinct `Truncate` policy and emits `0x10`. Lowercase `force` selects `Force(EqualSize)` and emits `0x80`; uppercase `FORCE` selects `Force(Prefix)` and emits `0x100`. These policies enter a dedicated checked storage cast, preserving byte representation rather than numerical value. Duplicate or conflicting insertions return a structured error while retaining the previous selection. See [Storage bitcasts](storage-bitcasts.md) for layout and byte-validity obligations.

Integer truncation keeps the target-width bit pattern. Pointer conversions retain their policy until the selected target determines address width. The VM preserves address provenance independently of the cast policy. Float and boolean truncation require a supported domain contract; the shared IR currently admits only checked float-to-integer conversion. See [pointer/integer conversions](pointer-integer-conversions.md) for target and VM limits.

## How to change it

Add source modifiers to `cast_modifiers.rs` and keep their compiler flags distinct. Update syntax parsing, pure evaluation, semantic coercion, VM execution, native lowering, and the shared IR proof together. `compiler_flags()` reports retained policy; callers cannot install an arbitrary integer flag set.

The public modifier insertion tests cover duplicates, conflicts, and policy round trips. Shared IR tests in `tests/cast-policies.rs` check integer policy retention and reject unproven float truncation before execution.

## Configuration

There are no environment variables. The source modifier selects the policy, and target layout selects pointer width. A cast does not change arithmetic overflow or array bounds policy; those use `CheckMode` separately.

## Dependencies

The policy lives in `jai-types` without external dependencies. `jai-syntax`, `jai-eval`, `jai-sema`, `jai-ir`, `jai-vm`, and `jai-codegen` consume it.
