# Floating-point source pipeline

## What it is

The float pipeline carries `float32`/`float64` source values through semantic resolution, checked IR, compile-time execution, and native LLVM instructions. Constants retain IEEE bit patterns, including signed zero and NaN payloads.

## How it works

The parser preserves normalized decimal spelling until a target width is selected. Semantic `WeakFloat` expression trees defer decimal rounding through unary negation, arithmetic, and conditional arms; a `float32` context parses directly into `f32`, without first rounding through `f64`. Bit literals such as `0h7fbf_ffff` and `0h8000_0000_0000_0000` are already typed and preserve their bits.

`jai-eval::floats::bind_weak_float_paths` can produce an immutable `WeakFloatValue`: a bound expression retaining validated `DecimalLiteral` nodes. Its `round(target, span)` method reuses the exact lexical input independently in each context, and binding resolves all names and conditional arms before any evaluation.

Unannotated named decimal constants are cached as `Value::WeakFloat(Arc<WeakFloatValue>)`. Alias expressions keep the same bound exact inputs, so `K :: 1.0000000596046448; a:float32=K; b:float64=K;` rounds independently for each use. An explicit cast such as `K :: cast(float32) ...;` freezes the constant's width. Constant caches clone immutable values instead of requiring every numeric value to be `Copy`.

`WeakFloatValue::request_key()` provides an immutable typed key for module parameters and capture caches. The key retains validated decimal spelling, operation order, typed operands, and conditional conditions, while excluding diagnostic source positions. Equal expressions at different offsets can share a request; two distinct exact decimals remain distinct even if both currently round to the same IEEE bits. `WeakFloatValue` equality and hashing use this key rather than executing arithmetic or formatting debug strings.

Named aliases retain shared expression and semantic-key DAGs. For `NEXT :: PREVIOUS + PREVIOUS`, both operands reference the frozen previous value rather than copying all its descendants. Each key node caches its semantic hash; equality still compares the exact tags and children with an iterative visited-pair traversal, so a hash collision never merges distinct constants. A chain of 128 such declarations denotes `2^128` leaves but retains only 258 semantic-key nodes. Debug formatting does not expand shared descendants.

Each immutable weak value memoizes successful `float32` and `float64` results separately. The bound expression already freezes integer check policy and contains no effects; width is the remaining rounding input. Failed evaluations are not cached, preserving the original operator origin or the current use span for contextual range errors. A new rounding policy must become part of the cache key before it can affect evaluation. This sharing applies only to pure bound constants, never to a procedure call or runtime expression with effects.

Constant binding attaches the definition's `SourceId` with `Value::with_fallback_source`. A deferred integer expression or conditional guard error keeps that definition origin through cross-file aliases. Decimal conversion errors use the materializing span instead: `BIG :: 1e39` is a valid exact constant, and a later `x:float32=BIG` reports the failed conversion at that declaration in the file declaring `x`. Origin metadata never changes semantic request identity or successful rounding results.

Typed float storage uses the general `TypeId`/`Place` path. `FloatExpr` wraps constants, loads, calls, arithmetic, casts and conditional joins; calls and returns use the same generic `ValueExpr` path as aggregate values. Arithmetic has no fast-math flags. Comparisons are ordered except `!=`, which is unordered-or-not-equal, so NaN compares unequal to itself and positive/negative zero compare equal.

The pure `jai-types::FloatValue` domain supplies the VM's arithmetic and comparison rules. LLVM constants are integer bitcasts constructed with the safe builder API; numeric `const_float` conversion is unsuitable for preserving signaling NaN payloads. A temporary LLVM insertion point satisfies the builder API and the folded constant remains owned by its LLVM context.

Static source tutorials document precision-dependent inference: `reference/how_to/002_number_types.jai` and `085_default_types_for_literals.jai` show small decimal literals defaulting to `float32`, and longer literals to `float64`. The shipped `reference/modules/Jai_Lexer/module.jai` sets `DEFAULTS_TO_FLOAT64` at eight significant figures and `REQUIRES_FLOAT64` above eight; its comments explicitly describe that digit heuristic as approximate. This implementation's supported digit policy counts significant mantissa digits after trimming leading and trailing zeros, selecting `float32` for at most seven digits. That normalization and cutoff do not establish full reference-compiler parity.

The same source lexer's `has_a_big_exponent` compares normal finite `float64` exponents against the normal `float32` range `[-126, 127]`. It explicitly excludes exponent field zero, which covers zero and `float64` subnormals, as well as the infinity/NaN exponent field. The shared inference helper follows that boundary: `1e-37` defaults to `float32`, while `1e-40` defaults to `float64`, even though the latter can round to a nonzero `float32` subnormal. The source helper's exponent-zero exception leaves `1e-310` defaulting to `float32` and rounding to zero; this is a pinned source-helper behavior, not a claim about an independently executed reference compiler. An explicit `x: float32 = 1e-40` still rounds the exact decimal directly to `float32`; the exponent rule chooses a default type rather than restricting contextual conversion. Literals whose direct `float32` rounding overflows also select `float64`.

Explicit float-width casts and integer-to-float casts use IEEE rounding. The reference Math wrappers demonstrate ordinary width reduction, but checked precision-loss and float-overflow corner rules have not been established. This implementation does not claim reference parity for those corners.

Explicit float-to-integer casts truncate toward zero, then check finite range. The LLVM check dominates conversion, preventing NaN and overflow from reaching `fptosi`/`fptoui` poison. Static Math/Sound source demonstrates numeric float/integer conversion, but invalid unchecked cast behavior is not established; `cast,no_check` from float to integer is therefore explicitly rejected. The distinct `cast,trunc` source modifier is also rejected for float-to-integer and any floating-point destination until its floating-point policy is established; it is not silently mapped to the checked conversion or the integer low-bit truncation rule. NaN payload results from arithmetic or width conversion are not guaranteed to be identical across host and target, while same-width loads, calls and constants preserve payload identity.

## How to change it

Change contextual binding and source operators in `crates/jai-sema/src/floats.rs`. Extend `jai-eval/src/floats/keys.rs` alongside any new bound expression kind, retaining its numeric meaning and excluding diagnostic spans. Raw LLVM constants are isolated in `crates/jai-codegen/src/floats/constants.rs` so their bit-preservation tests can run against the actual helper independently of semantic migration. Add IR cases and verification together in `jai-ir`; update `jai-codegen/src/floats.rs` and the VM dispatch for any new case. Keep arithmetic rules in `jai-types/src/floats.rs` instead of independently implementing VM rules.

Any inference-policy change requires direct-rounding regressions, especially `1.0000000596046448`, which demonstrates the difference between direct `f32` rounding and double rounding through `f64`. Cast changes need negative fractional values near signed minimum, values around every integer power-of-two upper boundary, NaNs, infinities and both zero signs.

## Configuration

Float widths come from source annotations and bit-literal widths. No host environment variable changes numeric rules. LLVM native validation uses the trusted LLVM installation selected by `LLVM_SYS_221_PREFIX`; native regression tests use the shared [native test tool selector](native-test-tools.md). No original compiler binaries or libraries are loaded.

## Dependencies

`jai-syntax` supplies validated decimal spellings. `jai-types` supplies widths, registry identities, raw IEEE values and pure operations. `jai-ir` supplies checked expression trees. `jai-eval` binds pure constant expressions with the same contextual decimal rules. `jai-vm` evaluates compile-time values; `jai-codegen` uses Inkwell and LLVM's native instruction APIs.
