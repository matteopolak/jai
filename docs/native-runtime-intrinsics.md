# Native runtime intrinsics

## What it is

The native backend implements the closed `jai-ir::RuntimeIntrinsic` catalog with actual LLVM instructions and target-checked helper calls. A reached `PrototypeOrigin::Intrinsic` gets a real Jai function body, so direct calls, indirect calls, and stored procedure values use the same implementation.

## How it works

The backend rechecks the concrete fixed signature and target scalar layout before emitting a wrapper. Intrinsics use the ordinary Jai ABI with no implicit context. Capability selection comes from the checked enum carried by the prototype; an ordinary source procedure called `memcpy` receives no special behavior.

`MemoryCopy` and `MemorySet` use Inkwell's LLVM memory builders with one-byte access alignment. Signed negative counts trap before conversion. Counts must fit the target pointer-sized integer. Empty operations return without examining pointers; nonempty operations reject null pointers and address-range overflow. Copy rejects overlapping ranges, including identical nonempty ranges, before modifying storage. Real pointer bytes pass through these memory operations without virtual handle conversion.

`MemoryCompare` calls installed libc `memcmp` through its concrete C signature on supported native C targets. It converts the returned C `int` to the sign-only Jai `s16` result: -1, 0, or 1. This avoids truncation changing the sign of an arbitrary libc result. Unsupported C targets produce an explicit target diagnostic.

The supplied OpenJai memory contracts have separate checked variants. Destination-returning copy and fill return the exact first argument, including a null destination on a zero-byte operation. The signed `s64` fill value is truncated to eight bits before the LLVM memory instruction; the pinned `u8`/void-result ABI stays distinct.

`Swap` emits two typed loads before either store, with one-byte access alignment. Its wrapper rejects null pointers, wrapping byte extents, and partial overlap. Identical addresses return without writes, preserving raw bool aliases and padding bytes. Scalars, nominal values, records, arrays, and pointer fields follow their ordinary LLVM storage representation. The VM preserves its virtual handle provenance and separately charges aggregate/snapshot work before executing the swap.

`CompareAndSwap` emits strong, sequentially consistent LLVM `cmpxchg` for success and failure. Its return carrier stores `(success, observed)` in Jai order. Integers, enums, pointer values, and nominal variants retain their checked identity while using their concrete storage representation. Nonnull pointers must be aligned to the scalar's storage size before an atomic instruction executes.

Bool values use LLVM `i1` with byte storage. LLVM atomics require at least eight bits, so bool CAS uses `i8`. A retry loop compares the observed byte's low bit, preserving the same bool semantics as an ordinary load even if a byte alias changed the upper bits. A successful replacement stores a canonical zero or one byte. These storage and ordering requirements follow the [LLVM language reference](https://llvm.org/docs/LangRef.html#cmpxchg-instruction).

`DebugTrap` invokes `llvm.debugtrap` and returns normally if a debugger or signal handler resumes execution. It is not a nonreturning operation; this follows the [LLVM debugtrap contract](https://llvm.org/docs/LangRef.html#llvm-debugtrap-intrinsic). Validation failures in other wrappers use nonreturning `llvm.trap`.

The native ABI does not carry VM allocation bounds, lifetime, or readonly metadata with a pointer. Its guards establish count representability, nonnull access, nonwrapping address ranges, copy disjointness, and atomic address alignment. Callers remain responsible for providing live, accessible memory ranges. The VM separately checks virtual allocation ownership and declared alignment; native atomic alignment checks the actual machine address.

## How to change it

Extend the checked catalog and signature validation in `jai-ir` first, then add the LLVM implementation in `crates/jai-codegen/src/native_intrinsics.rs`. Preserve `PrototypeOrigin` as the capability boundary and update the exhaustive reachability prototype handling when adding a new origin. Wrapper bodies feed the existing call/result code without a parallel result or aggregate-storage path.

`tests/runtime_intrinsics.rs` constructs checked IR without the frontend. It executes direct and indirect memory calls, copies a record containing a real pointer, checks integer widths and nominal/pointer CAS values, exercises upper-bit bool aliases, and verifies null/negative/overlap/trap behavior. An LLVM control-flow test checks that the debugtrap wrapper returns and its caller retains the checked continuation; it does not claim an attached-debugger run. A self-written C fixture runs four pthreads through a generated C adapter and verifies all 8,000 CAS increments.

## Configuration

The selected `NativeTarget` supplies pointer width, scalar layout, object emission, and C target support. No intrinsic-specific environment variable changes semantics.

Run `LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --test runtime_intrinsics --locked -j1`. Tests require installed LLVM and Clang; the concurrency fixture links `-pthread`. Tests generate their own objects and C source and do not load reference artifacts.

## Dependencies

This module uses `jai-ir`'s checked catalog, `jai-types` storage identities/layout policy, Inkwell's instruction builders, and the existing native target and C ABI adapters. Native compare uses host libc; the concurrency regression uses the host pthread implementation. See [runtime intrinsics](runtime-intrinsics.md) for source binding and virtual execution.
