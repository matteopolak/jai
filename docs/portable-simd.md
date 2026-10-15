# Portable SIMD lane implementation

`SIMD/module.jai` loads canonical aggregate definitions and independently grouped
scalar kernels under `internal/simd`. The fallback allocates no storage and has
no target ISA requirement. It implements set/store, vector and scalar arithmetic,
all six comparisons, min/max, horizontal sum and mask extraction with the reviewed
names, parameters and flags. Scalar min/max delegates to Basic; Math's reviewed
min/max overloads operate on its own vector types. Public aggregate names and
the union's exact field order are retained.

The fallback currently represents a true comparison lane with every bit set and
false with zero. Mask extraction collects each lane's most significant bit into
the corresponding low bit of an s64, supporting up to 64 lanes of 1/2/4/8 bytes.
It detects byte order rather than assuming little endian. Integer arithmetic and
horizontal accumulation wrap. These detailed policies need contract review;
the reviewed page establishes portable operations but does not specify mask bits
or overflow behavior. They are tested implementation choices, not independently
verified reference behavior. Floating-point operations use scalar backend
semantics; no hardware throughput or identical intrinsic NaN behavior is claimed.

`load` is withheld: its reviewed declaration has no return or output parameter,
while an ordinary no-result procedure cannot return a vector. No invented return
signature or no-op body is supplied. Offset units for gather/scatter, looping
index wrap and horizontal-add interleaving are also unresolved. Their exports
remain unfinished pending review. Scalar arithmetic retains the reviewed
`#symmetric` flag, including subtraction/division; scalar-left ordering needs
explicit review before claiming its compatibility.

`tests/portable-stdlib/simd.jai` checks actual vector/scalar integer operations,
floating arithmetic/sign masks, integer wrapping, comparison masks, reductions,
unaligned stores, the 64-lane mask boundary, union overlay and reflected canonical
type names. Interpreter and native execution use our source-built compiler.
