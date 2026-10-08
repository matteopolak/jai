# Basic and collection modules

## What it is

`Basic` is the module almost every program imports: allocation helpers, resizable arrays, printing, string builders, 128-bit integers, Apollo time and a memory debugger. Next to it are plain Jai containers and algorithms: `Hash_Table`, `Bit_Array`, `Bucket_Array`, `Sort`, `IntroSort`, `RadixSort`, `Soa`, `Tagged_Union`, `Treemap`, `Relative_Pointers`. Calendar time and the working directory are in [time and platform](basic-time-and-platform.md).

## How it works

`stdlib/Basic/module.jai` loads its parts:

| File | Content |
| --- | --- |
| `allocation.jai` | `alloc`, `free`, temporary storage |
| `Array.jai` | `array_add`, `array_copy`, removal, `array_find` |
| `Simple_String.jai`, `String_Builder.jai` | strings and builders. `string_to_float64_new` returns success first (`ok, value, rest`), the order toml-jai expects. |
| `Print.jai` | `print`, `tprint`, formatters. Exact float digits run on a `u64` and fall back to 36-limb arithmetic on overflow. Integer and float formatters see through variants (`#type,distinct float64` and `isa` chains of them). Edge forms (`tests/stdlib/basic-print-edge-forms.jai`): negatives in another base are two's complement at their width, fixed precision rounds ties away from zero, removed trailing zeros keep their width as spaces, `Inf`/`NaN`, `(enum out of range: N)`, `[1, 2...]` for a cut-short array. |
| `Int128.jai` | `S128`/`U128` with wrapping arithmetic |
| `Apollo_Time.jai`, `platform-time.jai` | time |
| `Memory_Debugger*.jai` | only when `MEMORY_DEBUGGER` is set |
| `protocol.jai` | re-exports prelude types (`Allocator`, `Any`, `Temporary_Storage`, reflection) as `Basic.*` |

Resizable arrays keep their allocator in the descriptor and grow by allocating a new block, copying and freeing the old one. Ordered removal shifts elements; unordered removal moves the last element into the hole.

`Hash_Table.Table(Key, Value)` is open addressing: `table_set`, `table_add`, `table_find`, `table_find_pointer`, `table_contains`, `table_remove`, `table_reset`. `table_find` and `table_remove` return success first, the order corpus programs expect. The hash and compare functions, `LOAD_FACTOR_PERCENT` and `REFILL_REMOVED` are struct parameters. `init(*t, n)` allocates `n` rounded up to a power of two (`init(*t, 5)` gives 8 slots); `SIZE_MIN` (32) applies only when no size is given.

```jai
#import "Basic";
#import "Hash_Table";

main :: () {
    t: Table(string, int);
    table_set(*t, "a", 1);
    found, v := table_find(*t, "a");
    print("% %\n", found, v);   // true 1
}
```

The rest:

- `Sort`: `bubble_sort` and `quick_sort`, in place and not stable, by comparator or key, with `compare_floats`/`compare_strings`. `IntroSort` has the same shapes.
- `RadixSort`: sorts `u32`, `u64` and `float` keys into a `ranks` buffer (record fields `ranks`, `ranks2`, `valid_ranks`, `allocator`). It is stable, so re-sorting keeps the previous order of equal keys.
- `Bit_Array`: bits in 64-bit slots. `set_all_bits` and `toggle_all_bits` keep the unused tail of the last slot clear.
- `Bucket_Array`: stable addresses, with a two-part locator; `Treemap` and `Keymap` use it.
- `Soa(T, N)`: one column per member, generated with `#insert`.
- `Tagged_Union(types)`: a value plus a `Type` tag.
- `Relative_Pointer(Storage, T)`: a signed offset where zero is reserved for null.

### Memory debugger

With `MEMORY_DEBUGGER`, the visualizer (`Visualize_Memory_Debugger.jai`) does nothing until one connects, so programs don't pay per allocation. `make_leak_report` merges identical stack traces through a hash table of trace hashes (`_md_trace_hash`).

`log_leak_report` prints one block per leak site: a `----- N bytes in M allocations -----` banner (totals include aggregated children), optional indented notes, then the trimmed stack trace. It ends with `Total: ...` and `Marked as non-leaks: ...`. `tests/stdlib/memory-debugger-report-format.jai` matches the banner and the two closing lines; the notes' wording is free. Counts go through `_md_quantity` (thousands separators, plural `s`).

## How to change it

- Add Basic functionality to the matching part file, not `module.jai`.
- `Basic.String_Builder` and the one in `String` both exist; qualify the type if a file imports both modules.
- Container changes need a case in `tests/stdlib/`: `basic-collections.jai`, `bit-array-standard.jai`, `bit-array-slots.jai`, `bucket-array-*.jai`, `hash-table-collisions.jai`, `intro-sort-api.jai`, `radix-sort-ranks.jai`, `sort-entry-points.jai`, `soa-generated-*.jai`, `tagged-union-layout.jai`, `storage-treemap-contract.jai`.

## Configuration

- `Basic`: `MEMORY_DEBUGGER` (false), `ENABLE_ASSERT` (true), `REPLACEMENT_INTERFACE`, `VISUALIZE_MEMORY_DEBUGGER` (true), `TEMP_ALLOCATOR_POISON_FREED_MEMORY` (false).
- `Hash_Table`: `COUNT_COLLISIONS` (false).
- `Tagged_Union`: `DEBUG`.

## Dependencies

`prelude/`, `Runtime_Support` (context and temporary storage), `Math` (`Treemap`), and libc for the system allocator ([memory and allocators](memory-and-allocators.md)).
