# Basic and collection modules

## What it is

These independently authored Jai sources provide general utilities and in-memory containers. The pinned maintained OpenJai public contracts take precedence when they conflict with the supplied historical distribution; compatible historical helpers remain available where possible.

## How it works

`Basic/module.jai` loads separate allocation, array, string, builder, formatting, 128-bit, and time components. Allocation dispatches through `Allocator_Proc`; the array component captures an allocator in each resizable descriptor and grows by allocating replacement storage, copying live elements, and releasing the previous allocation. Array removal supports ordered shifting and unordered replacement by the final element. The maintained `array_find` overload for resizable arrays returns a boolean, while the historical view overload returns a boolean and index.

`Basic/protocol.jai` exports qualified aliases to the selected independent `Preload` source declarations. `Basic.Allocator`, reflection descriptors, diagnostics, and storage views therefore refer to the compiler's actual protocol types. `Basic.Any` names the builtin dynamic type, and `Basic.Temporary_Storage` aliases the selected `Runtime_Support` declaration. The canonical named-Preload source graph preserves declaration identity through the two-line `stdlib/Preload.jai` facade; these aliases do not create replacement records.

Several maintained example schemas still differ from that compiler ABI. The first three allocator modes agree, but the maintained `FREE_ALL` member is absent and value 3 means `STARTUP` in the selected protocol. Reflection-tag ordinals differ; struct members use descriptor pointers and enum flags rather than maintained `Type` and `s64` fields; struct metadata has a view and additional fields; pointer metadata uses `pointer_to`, while the maintained name is `points_to`. Runtime temporary storage also has different fields, and a qualified `Basic.Context` alias remains absent until the synthesized context identity is verified. Qualified aliases provide actual compiler interoperability; exact maintained schema equivalence is not claimed.

`Bit_Array` stores bits in maintained `words: [..]u64` storage and preserves its two declared fields, `words` and `count`. The incompatible historical `slots` and separate `allocator` fields are absent. Whole-array operations mask the unused trailing bits. Index operations check the logical bit count, and iteration exposes a boolean and logical bit index.

`Hash_Table.Table` preserves the maintained `keys`, `values`, and `count` fields and the two type parameters. Its authored lookup scans the packed key vector backward, and mutation reserves both vectors before appending or shifts both vectors together when removing a row. Maintained `table_add` and `table_set` replace an existing value; `table_add_duplicate` is an explicit historical-behavior helper. Values remain stable until an operation grows or shifts their vector. The historical custom-hash template and tombstone layout are separate compatibility gaps.

`Sort.quick_sort` uses stable bottom-up merging. `IntroSort.intro_sort` uses an in-place heap. The names preserve the public entry points rather than prescribing an implementation algorithm. `RadixSort` provides the maintained fixed array of 65,536 ranks and sorts those indexes using stable merging without modifying the input. Equal values retain input order; floating-point NaNs follow numeric values. A rank count exceeding the fixed capacity triggers an assertion.

`Bucket_Array`, `Pool`, and `Flat_Pool` use source-managed storage rather than importing supplied native allocators. Incompatible historical bucket and flat-pool layouts live under `stdlib/legacy/`; `Treemap` uses the historical stable bucket contract. `Relative_Pointers` encodes address differences into caller-selected integer widths. `Soa` owns per-column storage and packs/unpacks rows through reflection. Their detailed callable and layout limits are recorded in `stdlib/.coverage/storage-layout.json`.

The maintained bucket uses parallel item and occupancy arrays and reuses the smallest vacant slot. Growth can move returned pointers. Its legacy variant allocates fixed buckets and keeps pointers stable until removal or reset. Maintained bucket reset retains capacity; legacy reset releases bucket storage.

Pools reuse linked ordinary heap blocks and release them together. Flat pools allocate one eager backing region and assert on exhaustion; they do not commit native pages incrementally. Their allocator callbacks retain shrinking resizes, copy growing allocations, and ignore individual frees as required by arena ownership. Initialize backing allocation before selecting that pool as `context.allocator`; selecting itself as its backing allocator is rejected. Default pool and flat-pool management fields, and treemap revision fields, are additional storage fields: exact maintained binary layout is not established for those records.

Treemap nodes borrow names, sum leaf weights into parents, and lay out descending-weight siblings in squarified rows. Border callbacks shrink content bounds. Set `treemap.dirty` after changing leaf weights; use display dirty/force when callback behavior changes. Each display uses a revision stamp, so multiple displays can refresh independently. Removal, cyclic trees, and rendering are outside the implemented contract.

SoA columns use packed reflected storage. Index reads reconstruct a row, writes scatter it, and pointer iteration writes its temporary row back after the body. Generated named columns such as `soa.x` are absent; unions are rejected. Relative-pointer storage uses signed displacements with the sign bit toggled: zero represents null, self-pointers remain representable, and the most-negative displacement is reserved. Relative strings borrow their target memory.

Formatting, numeric parsing, time conversions, and 128-bit arithmetic are authored in the separate Basic components. Formatting adds a source context field for `Print_Style` instead of reproducing the maintained example's incompatible `Context` declaration. Clock acquisition lives in `Basic/platform-time.jai` and uses independently declared host clock APIs. Allocation and temporary storage have their own coverage report from the allocator family.

Current utility limits are explicit: character classification is ASCII, integer parsing supports bases 2–36 and at most 64 bits, and float parsing accepts decimal exponent notation. Float formatting supports at most 18 fractional digits; its historical `SHORTEST` mode is approximate. Union formatting is unavailable, and pointer formatting displays addresses without dereferencing them. Output byte counts report bytes attempted because the runtime output sink returns no count. The maintained `Calendar` identifier has no declaration in the pinned module; calendar conversion cannot be claimed complete from that source alone.

## How to change it

Extend array behavior in `Basic/Array.jai`; keep descriptor counts and allocator ownership consistent when changing growth or removal. Extend the Basic utility files through their existing loader entries. If adding a new file, update `Basic/module.jai` and the documentation index.

Keep `Hash_Table`'s key and value vectors synchronized. Directly resizing one vector bypasses that invariant. Add new comparison or ranking behavior through the sort comparators; changing only the algorithm should preserve comparator ordering and duplicate stability where documented.

Preserve the default maintained field names and signatures. When a historical layout or return convention cannot coexist with them, provide an explicit legacy module or helper and record the incompatibility. Add protocol aliases through the selected source namespace in `Basic/protocol.jai`; preserve its canonical `Preload` import and the stable two-line facade. Do not duplicate protocol records to hide a schema conflict.

## Configuration

`Basic` retains `MEMORY_DEBUGGER`, `ENABLE_ASSERT`, `REPLACEMENT_INTERFACE`, `VISUALIZE_MEMORY_DEBUGGER`, and `TEMP_ALLOCATOR_POISON_FREED_MEMORY` parameters. `MEMORY_DEBUGGER=true` is currently rejected explicitly; it does not silently enable incomplete tracking. `ENABLE_ASSERT` controls source assertion expansion. Temporary-storage poison policy is implemented by the allocation component.

The default `Hash_Table` has no module parameters and does not expose historical collision or load-factor settings. `RadixSort.MAX_RADIX_COUNT` is 65,536. Collection allocations otherwise use the array descriptor's allocator or `context.allocator`.

`Pool.memblock_size` defaults lazily to 65,536 bytes. `Flat_Pool` defaults to eight-byte alignment; set its block size before lazy acquisition or call `init` with a reservation size. The legacy pool additionally preserves its 6,554-byte oversized threshold, custom alignment, reset stamping/free policy, and allocation logging. `USE_UNMAPPING_ALLOCATOR=true` rejects explicitly. Legacy flat-pool module parameters retain a 256 MiB default reservation and `OVERWRITE_ALL_POOLS_ON_RESET=false`.

For source-only checks, select the authored module root and independent prelude. The integration owner runs `tools/stdlib_api_inventory.py` with a frozen repository-built CLI. Module parsing alone does not establish typed execution, host service availability, or ABI equivalence.

## Dependencies and verification limits

These modules depend on the independent prelude descriptors, `Runtime_Support`, and the authored host clock declarations. `Treemap` additionally depends on vector math and historical stable bucket storage. No reference compiler, supplied native library, or original implementation is used as execution input.

The authored behavioral smoke source is `tests/stdlib/basic-collections.jai`. It checks array mutation, tail-word bit access, hash replacement/removal, sorting, and stable rank ties when executed by the integration owner. `tests/stdlib/basic-protocol-aliases.jai` probes qualified assignments between Basic aliases and the selected Preload protocol types. Both sources parse; execution is pending. The frozen library checker currently stops at `Basic/String_Builder.jai`'s typed compile-time size expression. Exact legacy layouts, maintained protocol-schema equivalence, qualified synthesized context, historical duplicate-table semantics under the default `table_add`, and the complete memory debugger are not established.

Machine-readable evidence is in `stdlib/.coverage/basic-collections.json`, `basic-utilities.json`, and `storage-layout.json`. These reports distinguish authored bodies, source parsing, known API differences, and behavior that has not been executed.
