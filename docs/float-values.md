# Typed float values

## What it is

`jai-types::FloatValue` stores IEEE binary32 and binary64 values as exact bit patterns. It supplies shared arithmetic, comparison and explicit conversion policies for checked IR, constant folding and the compile-time interpreter without extending the legacy integer/Boolean `ScalarType` enum.

## How it works

`FloatValue::F32(u32)` and `F64(u64)` retain their width, sign bit and NaN payload. Derived `Eq` and `Hash` describe constant-key identity: positive and negative zero are different keys, as are different NaN payloads. Use `compare(Relation, rhs)` for numeric comparisons. It makes signed zeros equal and NaNs unordered; NaN `!=` is true. Arithmetic and comparisons reject mixed widths so semantic conversion must be explicit.

`FloatOp` covers addition, subtraction, multiplication, division and remainder. Operations use Rust's ordinary `f32`/`f64` IEEE operations at the stored width. Division by zero and invalid operations produce infinity or NaN. `negate` flips only the sign bit; `abs` clears it. These bit operations preserve all other input bits, including signaling NaNs. Arithmetic NaN payloads and signs inherit Rust's host-dependent behavior, so the API does not promise deterministic arithmetic NaN keys across targets. See the [Rust float documentation](https://doc.rust-lang.org/std/primitive.f32.html#nan-bit-patterns).

The syntax frontend keeps weak decimal literals as validated `DecimalLiteral` spellings with underscores removed. Call `FloatValue::parse_decimal(target, decimal.spelling())` only after choosing the context's width. It parses directly as `f32` or `f64`, checks finite literal range, and permits normal underflow rounding. Parsing as `f64` and then narrowing can round twice: `1.0000000596046448` rounds to the next value above one directly in binary32 but rounds to one through binary64. Signs are unary syntax; negative zero can also enter through raw `0h` bits.

`cast(target)`/`convert(target)` perform explicit IEEE width rounding; overflow may produce infinity. Same-width conversion returns the original bits. `convert_exact(target)` is a separate strict finite, lossless policy with distinct nonfinite, overflow and precision-loss errors. `from_integer(target, value)` rounds directly into the chosen width; `from_integer_exact` additionally checks lossless representation.

`to_integer(target, mode)` rejects NaN, infinity and integer range overflow. `FloatToIntMode::Exact` also rejects fractional values; `Truncate` explicitly discards the fraction toward zero before checking the integer range. Conversion uses an `i128` intermediate, whose bounds exceed every supported integer domain, to avoid mistakes from comparing against rounded floating-point versions of `s64::MAX` or `u64::MAX`. For example, binary64 `2^64` is rejected for `u64`, while its immediately preceding value is accepted. These named policies are implementation choices for callers, not verified mappings of every Jai checked or unchecked cast modifier. Unchecked nonfinite/out-of-range float-to-integer behavior is intentionally unspecified here rather than delegated to LLVM poison or Rust saturation.

The inspected `reference/how_to/002_number_types.jai:94-124` establishes two IEEE widths and raw `0h` NaN/negative-zero literals. `085_default_types_for_literals.jai:208-226` explains weak literal width selection. The numeric tutorial's general checked-cast discussion does not settle float-to-integer NaN, fractional or overflow corner cases. Recent pinned jaison `module.jai:259-272` classifies binary32/binary64 special values using IEEE masks, corroborating the representation. No original compiler or upstream script was executed.

## How to change it

Keep key equality separate from numeric comparison. Preserve raw values through syntax/IR construction and round decimal spelling only when the destination width is known. New operations must enforce width, use the same helpers in constant evaluation and execution, and document any dependence on host behavior. A new checked source cast policy needs source evidence and matching backend bounds checks before being mapped to these helpers.

Regression tests cover direct contextual rounding, signed-zero/NaN identity and numeric relations, width mismatch, special arithmetic results, exact conversion losses, and the signed/unsigned power-of-two boundaries of all eight integer types. Registry `float(FloatType)` accessors retain the same builtin type IDs through `freeze`.

## Configuration

There are no environment settings or external precision libraries. Callers explicitly choose `FloatType`, arithmetic operation, comparison relation and conversion policy. Backend fast-math settings must not relax these semantics without an explicit language/configuration decision; cross-target arithmetic NaN payload parity is not promised.

## Dependencies

The Rust standard library, `jai-types` integer domains and shared `Relation` enum. The frontend supplies validated decimal spellings. Rust's [numeric cast reference](https://doc.rust-lang.org/reference/expressions/operator-expr.html#numeric-cast) describes the host conversions used internally; the API checks float-to-integer inputs rather than exposing Rust's saturating cast policy as Jai behavior.
