# Language conversions and assignment forms

## What it is

Implicit and explicit conversions plus a few assignment/`ifx` forms that the Way_to_Jai
examples rely on. Regression program: `tests/stdlib/lang-conversions.jai`.

## How it works

- **Loose enums.** `E.loose` is a second enum type (`EnumInfo::loose_of = Some(E)`, created by
  `Types::loose_enum`) with the same members. It converts implicitly to and from integers
  (`implicit_cost` in `sema/convert.rs`); `cast` converts between `E` and `E.loose`.
- **String literals to C strings.** A constant string converts to `*u8` (in calls, assignments
  and `cast(*u8) "..."`). Literal data is always NUL-terminated (`string_global`), so the data
  pointer is a valid C string. Non-literal strings do not convert.
- **`string` <-> `[] u8`.** Same layout, so `cast` reinterprets the address (`explicit_cast`).
- **`cast(bool)` of strings and arrays** is "non-empty" (`truthy`); a fixed array's count comes
  from its type, not from memory.
- **Procedure casts.** `cast(proc type) some_proc` and `cast(*T) some_proc` reinterpret the
  procedure address (used for `objc_msgSend`).
- **Integer meets untyped float constant.** `n * 0.5` converts the integer variable to
  `float32` (`check_binary`). Two typed variables of different class still do not mix.
- **Overloads and deferred arguments.** `.{...}`, `.[...]` and `.NAME` arguments are checked
  after overload selection; `arg_cost` now rejects scalar parameters for aggregate literals and
  non-enum parameters for `.NAME`, so a float overload no longer captures `.{x, y}`.
- **Assignment.** `a, b = v;` assigns one value to every target, `a, b += 1;` applies the
  operation to each target (the right side is re-evaluated per target), and untyped constants in
  `x, y = 1, 2;` take the type of their own target.
- **`ifx` without `then`.** `ifx !f(x) else e` uses the interesting part of the condition as the
  value (`implicit_then_expr`): `!c` gives `c`'s part, `x >= y` gives `x`, `f(x, ...)` gives `x`.
  `ifx c then a` and `ifx c` default the else value to zero.
- **`using E :: enum {...}` at file scope** brings the members into that scope; when exported,
  the members are exported constants (`expand_pending_item` in `sema/modules.rs`).

## How to change it

Conversion rules live in `implicit_cost`/`convert`/`explicit_cast` (`sema/convert.rs`); call
ranking in `arg_cost` (`sema/calls.rs`); binary operand unification in `check_binary`
(`sema/expr.rs`). Gotcha: `implicit_cost` only sees types, so constness-dependent rules (string
literals) have to be added in `arg_cost` and `convert` as well.

## Configuration

None.

## Dependencies

`sema` only; `Basic` formatting (`stdlib/Basic/Print.jai`) follows the reference API:
`formatInt`/`formatFloat`/`formatStruct` return formatter records taking `Any`, and
`Print_Style.default_format_*` are values (so `context.print_style.default_format_int.base = 16`
works). `get_capabilities` returns `Allocator_Caps`.
