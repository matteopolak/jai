# Aggregate LLVM execution

## What it is

`jai-codegen` lowers shared checked IR records, enums, projected places, and ordered procedure results using the same storage and call machinery as scalar values. `aggregates.rs` contains whole-value expression, constant, store, and result-carrier lowering; `lib.rs` retains the shared local/global slot and cleanup control flow.

## How it works

`ValueExpr::Record` evaluates declaration-order fields into an LLVM SSA struct with `insertvalue`. Source literals use `RecordBuild` to evaluate supplied initializers in source order and insert them at checked field ordinals; this preserves effects when named fields appear out of declaration order. Loads produce whole-value SSA snapshots. Stores copy those snapshots into the destination slot, so subsequent field mutation does not alias the copied record. Default values use a typed LLVM zero value. Recursive global initializers construct named LLVM struct constants through Inkwell.

A projected `Place` refers to the shared IR `Places` arena. Addressing walks the projection chain iteratively to its existing local or global root, validates each `FieldId` against its nominal owner, and addresses the semantic byte offset. Each slot records its guaranteed alignment; nested projections reduce it according to their byte offset. Scalar, aggregate, context, and pointer accesses use explicit LLVM load/store alignments. An rvalue field projection evaluates its base once and extracts the field from that SSA snapshot. Custom records use a typed packed payload with explicit padding and a verified zero-sized alignment carrier. Dynamic custom construction and extraction use compiler-owned entry temporaries; constant constructions and projections stay LLVM constants so immutable array views retain static backing storage. Scalar and explicit enum-representation bridges then feed ordinary integer/boolean operations.

Procedure parameters are basic LLVM values stored into the procedure's ordinary local slots. A single aggregate result returns its whole SSA value directly. Multiple internal results use an LLVM literal struct in signature order. A destructuring assignment captures each requested destination address in source order before evaluating the call, then executes the call once, extracts its values, and stores through those captured slots. A callee that changes an index, pointer base, or context cannot redirect the assignment. Ignored results capture no destination. All return expressions are captured before deferred cleanup executes, preserving their values when cleanup mutates source storage.

Enum literals and loads use the enum's fixed-width integer representation while checked IR retains nominal identity. Conversion to numeric operations requires an explicit enum-representation bridge. LLVM signedness-sensitive operators and checked integer casts continue to use the established semantic integer representation.

[Unions](union-storage.md) share one target-aligned payload and project members at offset zero. [Foreign C calls and definitions](foreign-abi.md) use platform classifiers and marshaling adapters; internal result carriers remain independent. Direct and indirect procedure values use the same checked signatures, and sparse procedure identities map through keyed function tables.

## How to change it

Extend the shared `jai-ir` value/place contract and its finalizer before adding lowering cases. Add expressions to `Generator::value`, source-level storage changes to the shared slot walker, and constant-only behavior to `aggregates::constant`. Do not introduce a separate record allocation or load/store path.

Keep record field order aligned with the frozen registry and validate nominal field ownership before using an LLVM ordinal. If internal multiple-result layout changes, update `TypeLowerer::function`, `return_values`, and `call_results` together. Keep source evaluation order before reordering named call arguments into parameter order.

## Configuration

There are no aggregate-specific environment variables. The LLVM configuration and target-data policy are described in [LLVM type lowering](llvm-types.md). Internal procedure convention and context mode come from the checked registry signature.

## Dependencies

The normal backend depends on `jai-ir`, `jai-types`, and Inkwell/LLVM. Source-level native integration tests additionally depend on `jai-syntax` and `jai-sema`. No reference Jai native code is loaded or executed.

## Verification

`crates/jai-codegen/tests/common_ir.rs` builds actual finalized shared IR, emits verified LLVM and object files through the backend, links those new objects with independently installed `clang`, and executes the newly generated programs. Its cases cover nested copy independence, aggregate parameters and return snapshots across cleanup, ordered mixed result destructuring, explicit enum runtime operations, typed defaults, source-order field initializer effects and single rvalue-base evaluation, and nested record/enum global initialization with projected stores, sparse foreign procedure calls and indirect values, C aggregate definitions, union copy independence, and nested union constants with actual pointer relocation reads, and direct/indirect destructuring calls whose callee mutates both destination indices and pointer bases.

Run the normal package suite with:

```sh
LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-codegen --locked -j1
```

During the shared IR/frontend migration, the execution cases also run through a temporary dependency-only test manifest pointing at the same `common_ir.rs` file and depending on `jai-codegen`, `jai-ir`, and `jai-types`. That isolated check verifies backend execution without claiming source-level aggregate semantics are already integrated. Backend library Clippy and the isolated test's Clippy passed with warnings denied.
