# Basic and collection modules

## What it is

`Basic` is the module almost every program imports: allocation helpers, resizable arrays, printing, string builders, 128-bit integers, Apollo time and a memory debugger. The collection modules next to it (`Hash_Table`, `Bit_Array`, `Bucket_Array`, `Sort`, `IntroSort`, `RadixSort`, `Soa`, `Tagged_Union`, `Treemap`, `Relative_Pointers`) are plain Jai containers and algorithms. Calendar time and working-directory helpers are in [basic-time-and-platform](basic-time-and-platform.md).

## How it works

`stdlib/Basic/module.jai` loads its parts: `allocation.jai` (`alloc`, `free`, temporary storage), `Array.jai` (`array_add`, `array_copy`, removal, `array_find`), `Simple_String.jai`, `String_Builder.jai`, `Print.jai` (`print`, `tprint`, formatters; exact float digits run on a `u64` and fall back to 36-limb arithmetic on overflow), `Int128.jai` (`S128`/`U128`, wrapping arithmetic; 32-bit limb multiply and a 64-bit-divisor fast path), `Apollo_Time.jai`, `platform-time.jai`, and `Memory_Debugger*.jai` (loaded only when `MEMORY_DEBUGGER` is set). `protocol.jai` re-exports the prelude types (`Allocator`, `Any`, `Temporary_Storage`, reflection descriptors) under the `Basic.` namespace.

Resizable arrays capture the allocator in their descriptor and grow by allocating a new block, copying and releasing the old one. Ordered removal shifts elements; unordered removal moves the last element into the hole.

`Hash_Table.Table(Key, Value)` is an open-addressing table. The key API is `table_set`, `table_add`, `table_find` (returns `value, found`), `table_find_pointer`, `table_contains`, `table_remove`, `table_reset`. Its parameters (`given_hash_function`, `given_compare_function`, `LOAD_FACTOR_PERCENT`, `REFILL_REMOVED`) are struct parameters, and `COUNT_COLLISIONS` is a module parameter.

```jai
#import "Basic";
#import "Hash_Table";

main :: () {
    t: Table(string, int);
    table_set(*t, "a", 1);
    v, found := table_find(*t, "a");
    print("% %\n", v, found);   // 1 true
}
```

`Sort` provides `bubble_sort` and `quick_sort` (in place, not stable; by comparator or by key) with `compare_floats`/`compare_strings`. `IntroSort` and `RadixSort` follow the same shapes: the radix sorter keeps a `ranks` buffer and sorts `u32`, `u64` and `float` inputs. `Bit_Array` stores bits in 64-bit slots. `Bucket_Array` has stable-address storage with a two-part locator and `bucket_array_add`. `Soa(T, N)` generates one column per member with an `#insert`. `Tagged_Union(types)` stores a value plus a `Type` tag. `Relative_Pointer(Storage, T)` stores a signed offset where the sign bit reserves zero for null.

## How to change it

- Add Basic functionality to the matching part file, not `module.jai`.
- When two `Basic`-level builders exist (`Basic.String_Builder` and the newer one in `String`), qualify the type if both modules are imported.
- Container changes need a matching case in `tests/stdlib/` (`basic-collections.jai`, `bit-array-standard.jai`, `bucket-array-*.jai`, `hash-table-collisions.jai`, `intro-sort-api.jai`, `radix-sort-ranks.jai`, `bit-array-slots.jai`, `sort-entry-points.jai`, `soa-generated-*.jai`, `tagged-union-layout.jai`, `storage-treemap-contract.jai`).
- `Hash_Table.table_find` returns `(success, value)` (success first), the order the upstream corpus programs expect; `table_remove` returns `(success, value)` too. `RadixSort` follows the reference record (`ranks`, `ranks2`, `valid_ranks`, `allocator`) and merges stably, so re-sorting keeps the previous order of equal keys. `Bit_Array.set_all_bits` and `toggle_all_bits` keep the unused tail bits of the last slot clear.

## Configuration

The memory debugger's visualizer (`Visualize_Memory_Debugger.jai`) does nothing until a visualizer connects, so
programs built with `MEMORY_DEBUGGER` do not pay for a leak report per allocation. `make_leak_report` merges
identical stack traces through a hash table of trace hashes (`_md_trace_hash`), not a pairwise scan.

`log_leak_report` prints one block per leak site: a `----- N bytes in M allocations -----` banner (totals include
aggregated children), optional indented notes that split out the site's own bytes or name the call that grouped
several traces, then the trimmed stack trace. It ends with `Total: ...` and `Marked as non-leaks: ...` lines.
The banner and the two closing lines are matched by `tests/stdlib/memory-debugger-report-format.jai`; change the
wording of the notes freely, but update that test if you touch those three lines. Counts go through `_md_quantity`
(thousands separators plus `s` plural).

`Basic` module parameters: `MEMORY_DEBUGGER` (false), `ENABLE_ASSERT` (true), `REPLACEMENT_INTERFACE`, `VISUALIZE_MEMORY_DEBUGGER` (true), `TEMP_ALLOCATOR_POISON_FREED_MEMORY` (false). `Hash_Table`: `COUNT_COLLISIONS` (false). `Tagged_Union`: `DEBUG`.

## Dependencies

The `prelude/` types, `Runtime_Support` for context and temporary storage, `Math` (Treemap), and libc for the system allocator (see [memory-and-allocators](memory-and-allocators.md)).
