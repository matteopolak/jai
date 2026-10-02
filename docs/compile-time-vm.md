# Compile-time VM

## What it is

`jai-vm` executes checked Jai IR with bounded virtual memory and transactional compiler effects. It uses no LLVM or native code and never loads reference compiler executables, libraries, or objects.

The engine depends only on `jai-ir` and `jai-types`. Parsing, source `#run` binding, constant publication, and dependency scheduling belong to the semantic layer and driver. See [source execution](compile-time-execution.md) for that integration boundary.

## How it works

A `ProcedureProvider` supplies a read-only `TypeView`, procedure signatures, global definitions, checked places, and an optional context schema. `Program` and `Library` implement this interface for fully validated IR. A scheduler can supply ready checked bodies before unrelated declarations and types finish resolving.

Readiness is explicit: `Ready(CheckedProcedure)`, `Compiler`, `Runtime`, `FileAbi`, `HeapAbi`, `Pending`, `Missing`, `Foreign`, or `Failed`. The ready proof must come from `jai_ir::verify_procedure` or its context-aware counterpart, against the same provider environment. The VM checks that environment before executing the body. Pending procedures, demanded incomplete nominal types, and deferred effects yield `Outcome::Pending`; unused globals and unrelated incomplete types do not block execution. Globals initialize on first access.

The provider can mark a global alignment request as pending. A demanded global address then yields `Dependency::GlobalAlignment` before allocating or reading its storage. The scheduler resolves the actual alignment expression and publishes its sidecar entry before retrying, so compile-time reads cannot silently materialize a global with a weaker alignment.

```rust,ignore
let mut vm = jai_vm::Vm::new(&provider, jai_vm::NoEffects, limits)?;
let execution = vm.execute(procedure_id, arguments);
match execution.outcome {
    jai_vm::Outcome::Complete(values) => publish_constants(values),
    jai_vm::Outcome::Pending(dependencies) => schedule_dependencies(dependencies),
    jai_vm::Outcome::Failed(error) => report(error),
}
```

`execute` calls a procedure with parameter-ordered values. `evaluate` and `evaluate_call` verify their staging expression/call against the provider before beginning a transaction; they require neither a synthetic wrapper procedure nor a frozen whole program. Their `*_validated` forms also run a result-publication validator before committing effects. The semantic scheduler uses that callback to reject values it cannot publish while rollback remains possible. Local access without a frame fails explicitly.

The separate resumable entry points retain typed task stacks, operands, and staged effects across suspension. Their `_at` forms pin trusted source origins, and results remain uncommitted until validated finalization. See [resumable VM execution](resumable-vm.md) for ownership, transfer, and cancellation.

Arguments execute in IR order before parameter reordering; semantic lowering inserts defaults. Conditions and boolean operators are lazy. Store destinations and indexed sequence descriptors are captured before evaluating the RHS or index call. Return values and multiple results are captured before cleanup. Named loop transfers propagate through nested loops, and inclusive ranges stop before their endpoints wrap.

The checked `CompileTime` boolean predicate evaluates to `true` in this engine. Its source lowering and native phase selection are described in the corresponding semantic/backend integration documentation.

The interpreter supports integer and float arithmetic/conversions, enums, distinct values, record/union construction, aggregate calls, multiple results, procedure values and indirect calls, arrays and sequence descriptors, typed pointer casts/offsets/differences, and immutable static data graphs. Integer operations use target-width bits and scoped overflow checks. Disabled overflow checks wrap add/subtract/multiply/negation and signed minimum divided by minus one; the corresponding remainder is zero. Zero divisors, invalid shifts, and checked casts still fail. Explicit truncating integer casts wrap the destination bits while retaining any address provenance. Floating operations use shared typed float helpers. Unbound foreign procedures fail explicitly. Explicitly bound runtime intrinsics execute virtual memory copy/compare/fill, compare-and-swap, or a structured debug trap; their byte work is charged before invocation. Compiler procedures use the effect interface.

Runtime `Type` cells contain descriptor pointers certified by immutable reflection storage. The VM checks their canonical identity across typed calls, raw pointer aliases, nested constants, and state transfers. Null `Type` is a genuine absent descriptor. See [compile-time Type values](compile-time-type-values.md).

## Virtual memory and persistence

`Memory` addresses allocations with opaque handles containing memory identity, monotonic allocation identity, a typed projection, and checked storage bounds. It never exposes a host address. Null, foreign, dangling, uninitialized, read-only, and out-of-bounds accesses fail. One-past pointers can participate in comparison, subtraction, and arithmetic back into storage; they cannot be dereferenced or describe a nonempty slice.

Pointer equality uses allocation identity and target-layout byte offsets, so a record and its first field, union members, and an array's first element compare at their actual shared address. Reinterpreted views use [virtual byte storage](virtual-byte-memory.md), preserving target endianness, packed-field offsets, aliased writes, and opaque pointer/procedure relocations. Arbitrary bytes cannot forge virtual pointer provenance. Projection bounds remain attached through casts. A leading header can be downcast to its proven owning allocation type; unrelated projections cannot escape into adjacent storage.

Explicit pointer-to-integer casts produce typed address integers backed by aligned virtual regions. Integer arithmetic and byte aliases retain their provenance; numeric literals with the same bits remain ordinary integers. Only proven affine identities can be cast back to pointers. Constant publication and scalar consumers reject unresolved address dependence, while same-allocation differences and proven alignment residues are ordinary numbers. See [compile-time address integers](compile-time-address-integers.md) for the target and publication boundary.

Jai strings retain arbitrary bytes. Literal bytes have independent immutable backing; mutable string descriptors can change count/data or be reassigned without changing an earlier data pointer. Constant array views have pooled immutable backing that outlives their callee. Nonconstant temporary backing remains frame-owned. Variadic concatenations snapshot each part in order into caller-owned storage and share a bounded per-frame temporary budget. Top-level expression temporaries live through result validation and are then released. `materialize_value`/`materialize_values` copy virtual string views into owned bytes with bounds and output/work budgets before compiler effects or constant publication. See [compile-time sequences](compile-time-sequences.md) and [variadic packs](compile-time-variadic-packs.md).

Each call releases its locals and temporaries. Successful transactions retain globals, literal/static backing, and default context storage. `into_state` transfers an opaque `VmState`; `with_state` resumes it against another ready-provider snapshot after checking registry identity, unchanged global definitions, compatible materialized global alignment, context schema, and limits. Appending globals is allowed. Failed or pending executions restore memory, lazy global state, backing caches, and effects. Allocation identities and virtual address reservations are never recycled, so handles from an abandoned attempt stay dangling.

Bound `HeapAbi` allocator declarations operate on `VirtualHeap`, a ledger of exact VM-owned byte allocations. It persists with `VmState` and rolls back with Memory. Allocation and reallocation preserve uninitialized holes and pointer provenance; foreign free cannot release stack, static, or file-token storage. `configure_heap_limits` is allowed only while there are no live heap allocations or active calls. See [virtual C allocator storage](virtual-heap.md).

## Implicit context

A checked context schema defines one record type and its default value. Default virtual storage is materialized when first accessed or passed to an implicit-context root call. Implicit calls share the active record; no-context callees hide it and require an explicit push before an implicit call.

`Context` values snapshot the record. `PushContext` allocates a copy and restores the caller's pointer on return, break, continue, pending dependency, or failure. Cleanup IR records the procedure or lexical push context captured by each defer; cleanup therefore sees its registration context even while another push is active. Successful default-context mutations persist through `VmState`.

## Compiler effects

A provider identifies compiler procedures explicitly by checked signature and typed intrinsic. Arguments become `CompilerRequest` values for source text/files, workspaces, build option reads/writes, or diagnostics. `CompilerEffects` stages requests between `begin` and `finish`; failed and pending executions must discard them. `finish` returns a checked result: rejecting commit also fails execution and restores memory. A handler must validate before publishing changes, including reserved response identities.

`NoEffects` rejects requests. The VM itself performs no filesystem reads, subprocess calls, or native foreign execution. A driver validates source access, workspace membership, supported targets, and publication policy. Workspace handles are opaque nonzero IDs; target triples validate text structure, while LLVM target support is checked by the driver. Paths use `PathBuf`, and text/path source adapters explicitly require UTF-8. Optimization enums are shared with the native build configuration in `jai-types`.

Explicit `FileAbi` capabilities select a checked stdio declaration, library, nominal `FILE` type, and exact C signature; symbol spelling alone grants no access. `HostFileMachine` uses bounded virtual buffers and readonly opaque `FILE` tokens. File requests pass through `CompilerEffects::host_request` and an explicitly supplied `host_file_scope`, sharing the same `begin`/`finish` transaction. Unavailable services reject requests, and deferred host observations yield `Dependency::Host`. The driver coordinates host publication with compiler-state commit. A request must close every opened file before commit; failed or pending execution restores both its virtual file ledger and Memory. `configure_file_limits` controls file handles, buffered payload bytes, and transfer sizes separately from ordinary VM storage. Actual response and transfer work consumes fuel before installing state.

The exported `virtual_process` module independently models descriptor sharing, IPC events, and process states. The owned continuation engine is available, but its process branch/exec adapter is not yet wired, so this ledger does not activate source POSIX process calls. See [virtual process protocol](virtual-process-protocol.md).

`SourceOrigin` is trusted scheduler metadata for directive replay: workspace, path/span, exact body bytes, fingerprint, and canonical specialization bytes. `set_source_origin` is a default no-op hook for handlers that do not replay. Runtime Jai strings do not select capabilities. A replaying driver must validate the complete ordered request/response stream before publishing changes.

Internal u64 workspace transport is separate from source Compiler ABI binding. Source adapters account for signed workspace values, the current-workspace sentinel, source parameter order, nominal option fields, and report modes/locations. Unsupported Code/location suffixes or foreign APIs produce diagnostics rather than successful empty effects. See [source compiler intrinsics](source-compiler-intrinsics.md) and [driver effects](compiler-effects.md).

## How to change it

Add checked operations to `jai-ir` first, then extend the VM dispatcher and relevant helper. Keep semantic resolution out of the VM. `execute.rs` owns frame/transaction/proof boundaries; its child modules handle values, floats, sequences, static graphs, and context. `execute/budgets.rs` admits aggregate children, call arguments, and multiple return values incrementally under one list budget, including pointer metadata, before appending them. Oversized lists therefore fail before evaluating later expressions or dependencies. The same module charges zero/default aggregate expansion before constructing nodes. `memory.rs` preserves allocation/address bounds, `byte_memory.rs` encodes target storage, `value.rs` checks value shapes, and `effects.rs` defines the driver contract.

Use independent checked-IR fixtures without a `jai-sema` dev dependency. Cover observable evaluation order, cleanup snapshots, pending retries, publication rollback, pointer aliases/provenance, and resource exhaustion. Source/native parity belongs to semantic/backend integration tests.

## Configuration

`Limits` controls fuel, call stack, active expression nesting, live allocations, and materialized value cells. Defaults are 1,000,000 steps, 128 frames, 256 nesting levels, 16,384 allocations, and 1,000,000 cells. Fuel includes expressions, statements, calls, blocks, loop checks, and materialized compiler-effect arguments. Internal Rust stack protection caps interpreter calls/nesting at 128/256; the recursive byte codec also has a 128-level ceiling. Limit failures are structured errors.

Cells count stored values, descendants, string bytes, pointer projection paths, and address-origin metadata. Cached byte images charge their bytes and every retained provenance/relocation path against the same live budget; encoding and decoding also enforce their individual bounds. ABI padding counts as encoded storage rather than a language value. Runtime byte operations, CAS, Swap, and SIMD charge whole-root snapshot work before touching a small projected range. `Statistics` reports steps, call attempts, and maximum stack depth.

`Vm::new_with_target` and `Memory::with_target` select `ByteTarget` layout and byte order independently of the Rust host. `ByteTarget::from(&BuildTarget)` carries actual native target facts. The convenience constructors select the documented LP64 little-endian virtual profile. No environment variables or external services configure the crate.

## Dependencies and verification

Only local `jai-ir` and `jai-types` crates are required. Focused verification needs no LLVM:

```sh
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test --locked -p jai-vm -j1
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo clippy --locked -p jai-vm --all-targets -j1 -- -D warnings
```

Provider intrinsics require an exact declared signature-map entry before dispatch. Readiness proofs and compiler/runtime capabilities cannot replace a procedure's declared type. Snapshot transfer performs an iterative, type-independent constant shape preflight before cloning or comparing global/context metadata, so unused incomplete declarations remain lazy. The shared `value_cells` limit bounds these metadata nodes and string bytes as well as separately bounded live values.

Immutable static graphs use cached publication prefixes; see [compile-time static data](compile-time-static-data.md). Checked admission validates a graph, while execution allocates and initializes each appended object once and charges new object/value traversal and each address projection.
