# Portable SIMD lane implementation

`SIMD/module.jai` loads canonical aggregate definitions and independently grouped
scalar kernels under `internal/simd`. The fallback allocates no storage and has
no target ISA requirement. It implements contiguous and offset loads/stores,
index generation, vector and scalar arithmetic, all six comparisons, min/max,
both horizontal reductions and mask extraction with the reviewed
names, parameters and flags. Scalar min/max delegates to Basic; Math's reviewed
min/max overloads operate on its own vector types. Public aggregate names and
the union's exact field order are retained.

The updated reviewed contract resolves comparison lanes as scalar conversions of
true/false, giving integer and float lanes 1/0. Mask extraction tests scalar truth
and maps lane i to bit i, supporting up to 64 lanes. The earlier unreviewed all-ones
and MSB policy is removed; its test expectation was corrected explicitly from
the new oracle. Arithmetic retains its reviewed flags, while horizontal reductions
perform ordinary scalar additions in lane order. Floating-point operations use
scalar backend semantics; no hardware throughput or identical intrinsic NaN
behavior is claimed.

The updated oracle explicitly supplies `load`'s result, byte displacements for
gather/scatter, lane-order repeated scatter overwrite, index values i*STEP and
interleaved pair sums. Contiguous and offset memory operations copy bytes, allowing
unaligned storage. Integer offset lanes and matching scatter widths are checked.
Looping indices establish positive widths; mask extraction checks at most 64 lanes
and horizontal add checks even widths. Raw pointer bounds remain the caller's
responsibility. The reviewed source has defects in scatter's input and horizontal
add's full-width writes; our implementation follows its documented intended mapping
and complete pair ordering, with real input/output tests rather than uninitialized
results. Scalar arithmetic retains the reviewed `#symmetric` flag, including
subtraction/division; reversed noncommutative ordering remains unspecified and no
extra overload is invented.

`tests/portable-stdlib/simd.jai` checks actual vector/scalar integer operations,
floating arithmetic/truth masks, integer wrapping, scalar comparison values,
complete interleaved reductions, unaligned loads/stores, repeated/negative byte
offsets, repeated scatter destinations, guard bytes, index steps, the 64-lane mask
boundary, union overlay and reflected canonical type names. Interpreter and native
execution use our source-built compiler. Generation is byte-identical on rerun.
