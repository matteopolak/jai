# Core syntax, declarations, types and values

This page summarizes the value-level language shown in Jai. The core lessons introduce a statically typed language with declaration-driven inference, value aggregates, explicit casts, and compile-time type values.

## Source evidence

The tutorial corpus covers declarations, literal typing, numeric and boolean values, arrays and strings, structs, enums, typechecking, formatted output, type information, and `Any`. Larger programs exercise these features in data structures, visualization, animation, and game code.

## Declarations and scope

The declaration shape is `name: Type = value;`. Omitting the type infers it from the initializer; omitting the initializer produces the type's default value. A second colon denotes an immutable binding, commonly used for procedures, types, and constants. `:=` is a concise inferred mutable declaration.

```jai
limit :: 12;
current := limit;
next: s32 = current + 1;
zeroed: [3] u16;
```

Declarations need enough information to determine a type: either a type or an initializer. The lessons distinguish data scopes (file, enum, struct declaration scopes) from imperative procedure scopes. Runtime statements belong in procedures. A nested procedure does not close over runtime locals; constants and declarations from data scopes can still be referenced. Braced runtime blocks create nested scopes. `#if` is a special case: its selected branch contributes declarations to the surrounding scope rather than introducing a normal block scope.

The corpus does not fully specify declaration-order and name-shadowing corner cases. Do not infer them from a single sample; consult direct compiler compatibility evidence when implementing those cases.

## Primitive types and literals

The lessons show `bool`, signed `s8/s16/s32/s64`, unsigned `u8/u16/u32/u64`, `float32`, and `float64`, plus aliases `int` for `s64` and `float` for `float32`. Integer literals default to `s64`. Decimal floating literal precision follows the lexer metadata heuristic, not a test that the value round-trips exactly through `float32`: a normal binary exponent outside -126 through 127 selects `float64`; otherwise more than eight significant fractional digits require `float64`; exactly eight counted fractional digits default to `float64` when the expression has no stronger contextual type; fewer than eight default to `float32`. Leading integer digits do not count toward this fractional-digit threshold, and trailing fractional zeroes are ignored. Thus `12342345234.0`, `16777216.0`, and `9876543210.125` default to `float32`, while `0.123456789` requires `float64`. Context may select a type for a literal that merely defaults to `float64`, but a literal marked as requiring `float64` cannot implicitly narrow to `float32`; use an explicit cast to permit rounding. Numeric literal values can fit implicitly into a requested numeric type when the literal's precision metadata permits it and the value is in range; a mutable variable's declared type does not shrink merely because its current value would fit.

Integer syntax includes decimal, `0x` hexadecimal, `0b` binary, and underscores for visual grouping. The `0h` form expresses IEEE bit patterns for floating values. `type_of` yields a compile-time type value, and `size_of` can query a type's storage size.

Implicit conversions are intentionally constrained: integer and float variables do not receive C-style general arithmetic conversions. The examples demonstrate widening when the destination can represent the entire source type range, not merely its current value. Signed-to-unsigned and unsigned-to-signed conversions therefore depend on representable ranges. Explicit `cast(T)` permits a conversion; checked narrowing can fail at runtime, while `cast,no_check(T)` suppresses that range check. Literal fit is a distinct compile-time convenience.

For prefix casts combined with shifts and other bitwise operators, those operators are part of the cast operand. The cast does not change the type used to type an already typed operand expression: `cast(u32) byte << 2` groups as `cast(u32) (byte << 2)`. Write `(cast(u32) byte) << 2` to make the shift's left operand `u32`. This grouping and bottom-up operand typing are demonstrated in the [operator precedence](../../language/operators.md) and [cast](../../language/casts-and-conversions.md) examples. Those examples do not establish whether a shift on a narrow typed operand promotes its result or preserves that operand's width, so the numeric result of the first form is unresolved here. Do not substitute C precedence or integer-promotion rules for the documented grouping.

The lessons show numeric-to-bool conversion as false for zero and true for nonzero, and use that same truth rule in `if`. Negative floating zero is false; a nonzero bit pattern remains true even if ordinary printing rounds it to zero. They also show pointers and strings in conditions. Full truth-conversion rules for every type are not exhaustively established by these samples.

## Arrays and strings

`[N] T` is a fixed-size, inline array whose elements are contiguous and homogeneous. Its length is part of the type. An array view `[] T` carries a count and data pointer and does not own the storage. Fixed arrays can convert to views for calls and assignments. Indexing and iteration are bounds checked in the demonstrated checked configuration; statically known invalid indices can be diagnosed during compilation. A caller can mutate a view's count or data pointer, so its validity depends on the backing storage and correct metadata.

```jai
samples: [4] s16 = .[2, 4, 8, 16];
window: [] s16 = samples;
window.count = 2;
for value, index: window {
    samples[index] = value + 1;
}
```

The lessons also show resizable `[ .. ] T` arrays, array literals `.[...]`, inferred array element types, empty literals with an expected type, and `..` range expressions. Do not treat a resizable array as a fixed array or view: its storage can move when grown, invalidating previously saved element pointers or views. Range endpoint and empty-range details vary across loop forms and are treated on the control-flow page.

`string` behaves like a byte-oriented view with a count and data pointer, and string literals provide convenient values. The lessons distinguish ordinary strings from C-style zero-terminated data and show formatting, concatenation, comparisons, and indexing. A string view does not imply ownership or lifetime extension. The supplied examples do not define Unicode normalization or general text encoding semantics; implementations should preserve the demonstrated byte-oriented operations rather than inventing higher-level text guarantees.

For a named fixed-array constant, the declaration and examples establish its element values and array type. They do not promise that repeated `.data` evaluations, explicit address-taking, or conversions to views yield one canonical address, nor do they specify whether writes through such a pointer are accepted or how long an address remains valid. Code that needs stable mutable storage should provide an explicitly mutable object with a suitable lifetime. Equal-valued constants are not specified to share or to have distinct storage. Treat these address-identity and mutation questions as unresolved language behavior rather than inferring a guarantee from array contiguity or from one observed compiler result.

Formatting helpers illustrate ownership differences: console formatting returns a byte count, `sprint` returns allocated text through the active context allocator, and `tprint` returns temporary-storage-backed text. The format language supports sequential `%` slots and numbered references such as `%2`; the default metaprogram checks argument counts and indices. `Any` is a uniform type-erased wrapper carrying type metadata and a pointer to its value. It does not own or copy arbitrary payload storage, so it can alias a mutable value and can dangle when that value's storage expires. Assigning one `Any` to another copies the wrapper.

## Structs, unions and enums

`Name :: struct { ... }` declares an aggregate type. Fields are laid out as members; `.{field=value}` is a named struct literal, and positional literals are also shown. Omitted members receive defaults. Nested literals can use contextual type information. Structs are plain data layouts: procedures declared inside a struct declaration are not automatically instance methods and do not capture an instance.

`#as using field: Base` is shown for embedding a base-shaped struct as the first member and exposing its members through `using`. Struct composition and `using` are not evidence of virtual dispatch or class inheritance.

Enums declare named constants with an integer backing type; explicit values and automatic sequencing are both demonstrated. `#specified` marks enums whose numeric values are intended to be explicit/stable. `.MEMBER` is contextual enum-member syntax when the expected enum type is known. `enum_flags` is shown for bit flags. `#complete` appears on enum-related branch handling (see the control-flow lesson), not as a general enum declaration modifier. The lessons distinguish a normal enum from flag enums; they do not establish every implicit conversion or duplicate-value rule.

The type lessons show tagged-union-style data built from an enum discriminator and a union payload, then branch on the discriminator before reading the matching field. They also show `#type,distinct T` for a non-interchangeable variant and `#type,isa T` for a type that can be used where its underlying type is accepted. These features should retain nominal identity where declared distinct; do not reduce them to ordinary aliases.

## Type values and restrictions

Types are first-class compile-time values. `Type` parameters and expressions such as `type_of(x)` permit metaprograms and polymorphic procedures to inspect or construct types. Runtime reflection through `type_info(T)` is separate: it embeds requested metadata into the program and can be trimmed with the demonstrated type-info directives.

One focused lesson uses member names, types, offsets, and sizes to copy matching fields between two structs. This is reflection over emitted metadata, not structural typing or an implicit assignment rule. Another lesson shows metadata reduction tradeoffs in more detail on the metaprogramming page.

The type-restriction lesson introduces named constraints for polymorphic types, and other lessons show compile-time predicates and `#assert`. The source examples establish useful patterns but are not a complete grammar for every restriction expression. Preserve type errors when a restriction is not met; do not silently fall back to a different overload.

## Implementation notes and open edges

- Keep literal typing separate from variable conversion. A variable initialized from `9` is still `s64` unless explicitly typed or held as a constant usable as a literal-like value.
- Keep compile-time type identity distinct from runtime values; `Type` is not a universal boxed value.
- Array views are non-owning. Bounds checking cannot make a forged count or stale pointer safe.
- The lessons often describe default initialization as zero-filled representation. Types with special initialization behavior and every aggregate corner case need targeted evidence.
- Numeric overflow, cast-check switches, and optimizer/build effects are discussed in the broader compiler documentation; this page records only the language-level examples.
