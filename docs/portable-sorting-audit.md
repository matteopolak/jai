# Sort, IntroSort and RadixSort

The twenty reviewed public declarations have supported bodies and focused shared-library evidence. RadixSort's public index operator was missing from its facade; a filtered import now exposes the existing canonical operator entity. No wrapper, extra helper export or private type-module visibility bypass was added.

Genuine red `radix-operator-red-1cqcb931/results.json` records failure of a consumer with an ordinary lexical public import. This is distinct from the coordinator-confirmed rejection of symbolic operators through a qualified namespace import alone. The repaired consumer also checks repeated-import operator identity and absence of private radix helper exports.

`sort-contracts.jai` covers empty/singleton and larger duplicate-key records, both quick-sort overloads, both IntroSort procedures, same-view return/storage identity, sorted order and independent identity permutation, untouched storage outside the view, and float/string comparison. It does not assert stable ordering of equal elements.

`radix-contracts.jai` exercises every pointer/view overload for u32, u64 and float; rank and public indexing; unchanged inputs; null/zero no-op retention; reset invalidation with retained storage; shrinking without reallocation; same-size validity preservation; resizable-array reorder; release; and the public self-test. The exact signed-input negative requires the named no-matching-sort-overload error, rather than accepting an unrelated failure.

Run `tools/check_portable_sorting_shared.py` with worker source-built tools and `CARGO_TARGET_DIR`. Receipt `artifacts/local-verification-stdlib/cargo-target/sorting-shared-8z4vmm3z/results.json` has 43 passing checks: six actual interpreter/native Mac ARM64 O0/O2 executions, four builds, twelve source checks, twelve complete strict production/fixture lint contexts, eight format gates and the signed-overload rejection.

Native other platforms, NaN ordering, invalid comparators and allocation-failure recovery are not verified here. Pre-existing implementation choice: two-argument `quick_sort` uses heap sorting, its key overload uses insertion sorting, and `intro_sort` delegates to the comparison sorter. The reviewed interface specifies ordering and mutation, without an algorithm-selection or timing guarantee. This audit does not claim a distinct quick-partition/introspective performance implementation.
