# Bootstrap atomic lowering

The reviewed atomic_load, atomic_store, atomic_exchange and compare_and_swap
intrinsics use the shared atomic IR. There is no module/path bypass. Scalar
integer/enum, bool, float, pointer and procedure representations of 1/2/4/8 bytes
are supported. Aggregates and wider representations are rejected; intrinsic
signatures must preserve the pointer's scalar type and documented results.
Exchange and CAS compare/exchange bits, including NaNs and signed zero.

Bootstrap operations use sequential consistency, the compiler's existing CAS
choice. The public reviewed pages do not promise exact ordering, so this stronger
implementation guarantee is not presented as a recovered reference guarantee.
Existing explicit-order compiler intrinsics reject unknown/high-bit orders,
invalid load/store orders, and failure orders stronger than CAS success.

Every access checks natural alignment through ordinary checked IR before the
backend operation. Check reason 8 denotes atomic alignment, with address and
required byte alignment as its two details. Runtime-support providers can render
this reason; the compiler/interpreter also has its own diagnostic text.

The interpreter uses Rust host atomics over aligned, mapped scalar storage,
retaining atomicity against concurrent native foreign threads. The allocation
must remain live and concurrent accesses must use compatible atomic operations.
Cooperative hosts poll after atomic completion to permit other tasks to progress.
LLVM emits ordered atomic instructions and bitcasts scalar representations.
WASM programs containing atomic IR require +atomics; explicit -atomics is an
error. Shared-memory linkage/configuration remains the embedder's responsibility.

Original tests in the core and LLVM cleanroom_atomics suites cover bit patterns,
prior values, invalid types/orders/alignment, native O0/O2 execution, host CAS
contention, and four WASM shared-memory workers. Native and WASM contention each
validate 120,000 updates and the sum of all prior values. They do not substitute
for full platform CI or production library integration.
