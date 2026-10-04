# Fixed array to pointer decay

## What it is

A fixed array `[N] T` converts implicitly to `*T` (the address of its first element). This lets C-shaped fields such as Vulkan's `char extensionName[256]` (`[256] u8`) go straight into `to_string(*u8)`.

## How it works

`implicit_cost` in `crates/jaic/src/sema/convert.rs` returns the `INT_TO_FLOAT` rank for a fixed array to a pointer to the same element type. That rank is worse than the view conversion (`[N] T` to `[] T`) but better than boxing into `Any` (`TO_ANY`). The second part matters: `String.to_string(value: Any)` would otherwise win and print the byte array as `[86, 75, ...]` instead of the C string. `coerce` emits the array's address.

## How to change it

Adjust the ranks next to `POINTER`/`INT_TO_FLOAT` in `convert.rs`. Resizable arrays do not decay (they convert to views only). Regression: `tests/stdlib/cpp-method-and-array-decay.jai`.

## Configuration

None.

## Dependencies

`sema/convert.rs` overload ranking (`calls.rs`) and the stdlib `to_string` overloads.
