# Atomics over supported compare-and-swap

The facade preserves the exact legacy aliases to bootstrap atomic load/store/
exchange. Arithmetic and bitwise operations use naturally aligned 1/2/4/8-byte
unsigned CAS loops, preserving the observed prior value across retries. Pointer
addition operates on raw byte addresses. Addition wraps at the target width;
decrement returns whether its successful update reached zero. Bit test/set
supports 2/4/8-byte integers/enums, with negative indices counted from the high end.
Invalid targets/indices produce checked errors rather than accessing adjacent bits.

The private word conversion copies representations rather than interpreting
pointers as element-scaled arithmetic. No additional public helper is exported.
Ordering follows the compiler's existing compare-and-swap implementation; this
does not assert an unspecified reference ordering or lock-freedom guarantee.
CAS retries may be slower than native fetch/update instructions under contention.

The supported type policy currently classifies naturally sized integer, bool,
float, enum, pointer and procedure values as atomic scalars. Arithmetic accepts
integers/pointers with integer increments; bitwise updates accept integer/enum
targets. The reviewed page does not fully specify the accepted type sets or
out-of-range conversion policy; these choices require review. No floating-point
fetch-add support is claimed.

The updated independent source compiler now lowers atomic load/store/exchange.
The original intrinsic regression passes interpreter/native and is promoted to
`tests/portable-stdlib/atomic-intrinsics.jai`, with direct module-alias calls added.
The three public aliases retain the original bootstrap entities; no wrapper
procedure or alternate implementation was substituted. Earlier missing-intrinsic
diagnostics are a resolved compiler integration gap.

Single-thread tests cover integer widths, wrapping, enum masks, negative bit
indices and byte-based pointer increments. Four simultaneous threads verify
the sum of returned prior sequence values, all claimed bits exactly once,
bitwise updates and exactly one successful zero-reaching decrement. Additional
programs require rejection of a one-byte bit target and fault on an invalid
negative index. Target checks cover the scalar implementation on Linux/Windows;
thread contention currently runs only through the supported Unix Thread backend.
