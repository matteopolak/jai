# Shared checked IR

## What it is

`jai-ir` owns the target-independent representation shared by semantic lowering, the compile-time VM, and LLVM. `Library` and `Program` have private fields and are published only after the complete staging graph passes a checked builder; semantic compatibility reexports do not create another IR model.

## How it works

Semantic resolution starts with a mutable `jai-types::TypeRegistry`. Source types and signatures become registry `TypeId` values; nominal records, enums, and distinct types keep their own identities. The resolver constructs staging procedures, typed constants, and places, then freezes the types and calls `ProgramBuilder::finish_library()`. `finish(entry)` additionally checks that the selected defined procedure has no explicit parameters and returns either no values or one `s64` value.

The builder checks every procedure body, including unselected expression branches and cleanup bodies. Its proof covers local ownership, type provenance, field owners, exact argument/result identities, supported scalar bridges, projected places, control-flow summaries, loop exits, and cleanup cycles. Runtime representation walks are iterative and stop at pointer or descriptor boundaries; by-value dependencies must be complete. Recursive proof frames have a limit of 128; by-value type and constant depth have a limit of 256. Constant graphs also have a one-million-node limit. Memoized subtree heights preserve these limits when a shared type dependency was already visited through a shallower path.

An excessive staging graph returns an `IrError`. The consuming builder and immutable library dispose owned expressions, blocks, and constants iteratively, including on early metadata failures. This matters because rejecting a deeply nested value and then recursively dropping it would still overflow the process stack. Static objects likewise validate bounded admission before retaining their contents and share immutable objects between published snapshots.

### Values and storage

All storage uses `LocalId`, `GlobalId`, and a common `Place` carrying a registry type. Local and pushed-context identities include their owning `ProcedureId`. Immutable `Places` snapshots retain arena ownership for field, dereference, index, and descriptor-field projections. Creating a field projection checks its nominal `FieldId`; finalization also checks the referenced roots and operand expressions. `Place` stays copyable while its arena owns operands that must be evaluated to obtain an address.

`ValueExpr` represents scalar and aggregate snapshots, loads, calls, explicit enum/distinct conversions, pointer operations, sequence descriptors, and context snapshots. The integer/boolean/float wrappers remain convenient arithmetic domains. They do not create separate storage or nominal identity systems. For example, an enum can enter integer arithmetic only through the explicit representation bridge; a distinct type requires explicit wrap/unwrap nodes with the exact underlying type.

Canonical `Any` storage reuses the record field machinery through `TypeView::record_storage_definition`. Ordinary `record_definition` remains strict, so an `Any` descriptor cannot impersonate a nominal struct, context schema, or union. `AddressOfValue` evaluates an rvalue once and materializes typed storage in the caller frame; an addressable source value uses `AddressOf` to preserve its alias. These nodes retain ordinary pointer identities and lifetime rules.

Record literal initializers preserve source evaluation order. `R.{b = bump(), a = bump()}` becomes `RecordBuild` with `b` first and `a` second; field IDs determine where the resulting values are inserted. Pure constant records use declaration-order fields. Union construction keeps its active field and exact payload type. Fixed arrays keep their count and element identity; strings retain arbitrary bytes rather than relying on NUL termination. Array views and descriptor views are separate operations so a consumer can distinguish temporary backing storage from a descriptor copy.

`CompareStrings` compares string bytes and length for equality or inequality. Both operands must have the canonical string type, and their expressions retain evaluation order. Embedded NUL bytes and empty strings need no special representation.

Runtime `Type` values occupy a descriptor-pointer cell. `RuntimeTypeConstant` derives its represented type from an immutable descriptor object registered using a checked reflection descriptor; callers cannot pair an arbitrary pointer with a chosen `TypeId`. `TypeDescriptor` extracts the catalog's exact header-pointer type. The registry must have a ready `RuntimeTypeSchema` before a `Type` value can be stored or evaluated. A VM that decodes a dynamic cell must additionally establish that its actual pointer addresses the registered header before using its opaque `RuntimeTypeIdentity`.

Indexes and pointer offsets use `s64` operands. Pointer subtraction additionally requires matching pointer identities and a complete, nonzero pointee representation. The IR records checked float-to-integer conversion; the current publication contract rejects unchecked float-to-integer conversion. Consumers implement finite/range failure without emitting an undefined native conversion.

Integer/pointer casts retain their explicit `CastMode`, including the distinct truncating policy, while pointer offsets with an integer on the left have a separate node that evaluates that operand first. `CastModifiers` preserves the different compiler flags for no bounds check and truncation; see [cast modifiers](cast-modifiers.md). The proof checks kinds and registry ownership; the selected target determines address width. VM address integers retain provenance through arithmetic and byte storage. Unknown virtual addresses and address-derived compile-time publication have explicit capability limits rather than becoming host addresses.

`CheckMode` records overflow and index checking policy independently of operand types. Source lowering explicitly enables checks unless the corresponding source attribute disables them. The low-level `IntExpr::new` keeps its existing disabled policy for fixture compatibility; new producers must set the intended policy on each arithmetic node. Index projection reconstruction must retain its original mode.

`SimdBlock` has its own branded register domain rather than introducing source-visible vector storage types. Its builder checks register initialization, operand widths, declared ISA features, and bounded instruction counts. Final publication additionally checks every memory address through the ordinary value verifier, including nested calls and local ownership. Target support is a consumer capability check; see [SIMD assembly](simd-assembly.md).

### Calls, results, and context

Calls retain arguments in source evaluation order as `(ParameterId, ValueExpr)` pairs. Validation establishes unique, complete bindings before a consumer reorders values into signature order. C variadic tails must already contain promoted argument types. Bodyless foreign/compiler prototypes share the procedure signature map with source definitions; defined procedure IDs can be sparse, and consumers use `procedure_by_id` instead of indexing the body vector.

`Call::new` starts with an automatic inlining policy; `with_inline_hint` carries an explicit call-site request. Indirect calls retain the same typed policy, and forced inlining requires a statically known procedure value. Source and native capability checks diagnose unavailable bodies or conflicting explicit hints; ready IR proof does not require a callee body merely to validate its signature.

`SequenceConcat` is admitted only as the top-level actual parameter for a checked Jai variadic slice pack. Its ordered parts contain exact element values or matching slices. A consumer snapshots each spread before evaluating the next part, then constructs caller-frame backing. The shared `sequence_temp_allocation_charge` accounts for alignment and allocation metadata against `MAX_SEQUENCE_TEMP_BYTES`; empty packs need no allocation. Returned aliases are subject to ordinary frame lifetime checks.

Procedure values have the runtime representation of callable addresses. Null/default procedure values use the existing typed `Zero` expression; truth tests and equality preserve the complete procedure signature identity, including its context mode. Data-pointer arithmetic, dereferencing, and pointer casts remain separate operations.

`ConstantKind::Procedure` stores a procedure identity under its canonical signature type. Type-only constant constructors establish its shape; publication and ready execution additionally close every nested procedure constant against the exact signature ledger. This includes record/array/union constants, context defaults, and immutable static data. `verify_constant_procedures` provides that bounded identity pass without demanding unrelated incomplete aggregate definitions; it does not prove the other constant contents by itself.

Results are an ordered list from the checked signature, not an invented tuple type. `CallResults` executes a direct call once and records requested destinations; `IndirectCallResults` does the same for a procedure value. Return expressions produce snapshots before exit cleanup runs. A target may choose a result carrier, such as LLVM's internal struct carrier, after this language-level list is established.

`ContextDefinition` records a struct type, its hidden ABI pointer type, and a checked default value. `ValueExpr::Context` returns a record snapshot. `PushContext` evaluates a record once, copies it into scoped storage, and restores the prior context on all control-flow exits. A procedure without implicit context can call an implicit-context procedure inside that scope.

Cleanup metadata captures either the procedure context or an owned `PushContextId` at declaration. An outer defer therefore uses the outer context even when invoked while an inner push is active. The verifier checks capture ancestry, unique push IDs, and that an invoked pushed capture is an active lexical ancestor. Cleanup bodies are checked against the captured environment. Return expressions are captured before those bodies run.

### Ready execution before finalization

`verify_procedure` and its `*_with_context` form return a borrowed `CheckedProcedure` without requiring callee bodies or unrelated nominal definitions to be ready. The verifier checks all global identities shallowly and validates a global initializer when the body references that global. Final library publication validates every initializer.

`verify_expression` and `verify_call` provide corresponding root proofs without a local frame. Their context-aware forms take the same type/signature/global/place environment plus optional context metadata. These checks occur before root evaluation can perform compiler effects. Proof objects retain the exact immutable environment; a VM provider must execute with that environment or establish that its environment matches.

`BoolExpr::CompileTime` is a phase predicate: VM execution produces `true`, and native execution produces `false`. This leaf differs from the procedure execution policy. `ProcedurePhases` records whether an actual defined body is available only at compile time; it preserves that body's signature and checked IR for the VM. Native reachability checks the policy by procedure identity, including aliases and stored callbacks. See [execution phase](execution-phase.md).

`StaticData` is a separate immutable storage graph for runtime constants with typed symbolic addresses. Its object IDs and field/index paths contain no host addresses. Graph validation is bounded and permits cycles through pointers. `is_static_value` conservatively classifies expressions that can use constant backing storage; a potentially foldable CFG expression remains a runtime expression until a consumer can prove its backing lifetime.

Static `Type` cells use symbolic addresses within their own graph and must point to the exact registered descriptor header. Nested `RuntimeTypeConstant` graphs are rejected, preserving bounded validation and disposal rather than introducing chains of recursively owned static graphs.

Within one proof, immutable static graph prefixes are checked once against the fixed type and signature environment. Unique closure nodes and address path steps share a one-million-unit work budget, so repeated constant leaves cannot multiply a large closure walk. Referenced global initializers are likewise checked once per ready procedure or root proof.

### Publication metadata

Foreign prototypes refer to checked `ForeignLibrary` declarations rather than unresolved source names. The library table also retains unreferenced `link_always` declarations. Publication validates unique declaration identities, lexical procedure ownership, target spelling/options, and exact agreement between a prototype's binding and the table. See [foreign libraries](foreign-libraries.md) for source resolution and linker behavior.

Optional `DebugSources` preserves procedure spelling, statement locations, lexical blocks, and locals without adding fields to executable expressions. `BlockPath` and `StatementPath` identify actual IR branches, including case subjects and separate cleanup roots. Local records use exact `LocalId` values and zero-based explicit parameter ordinals; hidden context parameters are excluded. Ordinary declarations retain their exact containing block; a case subject does not introduce a block. A loop binding may be declared at its controlling statement while belonging to its immediate child body scope. Cleanup roots retain their original declaration scope through a checked, cycle-free lexical parent map, whose chain depth is bounded to 128.

A location comes from a `SourceRecord`, and the sidecar retains that exact immutable text allocation. Finalization checks sparse procedure IDs, actual path targets, source allocation identity, UTF-8 span boundaries, and derived line/column coordinates. Equal numeric source IDs from different source maps cannot substitute for the retained record, even when their paths and text match. Source text and paths are shared through `Arc`; coordinate indexes are built once per retained file. Semantic capture attaches locations as nodes are emitted, including the true origin of quoted code, rather than guessing correspondence from AST and IR order.

Type and field source records use the actual registry `TypeId` and `FieldId` and undergo the same source provenance checks. Anonymous types can retain a location without an invented name. Native debug producers use these records alongside target layout when constructing type metadata.

Storage alignment requests and procedure inlining hints are separate sidecars keyed by checked storage or procedure identities. Alignment requests must be nonzero powers of two; a consumer combines them with the natural target alignment. Program exports retain typed declaration/target identities and validated native symbols. The source-language entry remains distinct from an explicitly exported native C `main` trampoline.

## How to change it

Add new value domains to the focused expression/storage modules and the corresponding verifier module. Extend VM and LLVM exhaustive matches together, and add a public-builder rejection case for each new invariant. Keep syntax operators below the AST boundary in `jai-types`; parsing can translate source tags into these checked tags.

Staging constructors are intentionally available to compiler stages and independent consumer tests. They are not an execution proof. Do not expose an unchecked `Program` constructor, pass raw staging procedures to the VM, or recover from a failed proof by fabricating an empty body. Use `TypeView` for ready descriptor access and the final frozen `Types` for publication. Preserve lazy readiness: unused incomplete globals must not block an unrelated ready scalar procedure.

Backend capability checks remain necessary after IR validation. A checked compiler prototype does not make native compiler-effect calls or foreign execution available. Source support is established by source-level semantic and execution tests, beyond constructing valid IR by hand.

## Configuration

There are no environment variables in this crate. Calling convention, implicit context, variadic behavior, check policy, defaults, and the entry point are explicit metadata. Verification limits are internal constants; `StaticDataLimits` configures bounded static graph construction. `MAX_SEQUENCE_TEMP_BYTES` is 1 MiB per caller frame and the allocation charge helper is shared by VM and native consumers. Registry and arena identities are process-local handles and must not be serialized as source identities.

## Dependencies

The normal `jai-ir` dependency set contains only `jai-source` and `jai-types`. It does not depend on syntax, semantic resolution, the VM, or LLVM. `jai-sema` publishes it, `jai-vm` executes it, and `jai-codegen` lowers it. This direction lets VM and backend tests build checked fixtures independently of unfinished source features.

Focused verification requires no LLVM installation:

```sh
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-ir --locked
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo clippy -p jai-ir --all-targets --locked -- -D warnings
```

The public boundary tests are in `crates/jai-ir/tests/`, including construction, context captures, procedure addresses, foreign declarations, and source provenance. Static graph and storage tests live alongside their modules. Native shared-IR execution is documented in [aggregate code generation](aggregate-codegen.md), and ready execution in [the compile-time VM](compile-time-vm.md).
