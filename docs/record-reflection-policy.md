# Record reflection policy

## What it is

`RecordReflectionPolicy` represents the three record metadata reductions documented in the supplied `935_type_info_reduction.jai` tutorial. It controls reflected members, independently of the record's physical storage and checked field types.

## How it works

`RecordReflectionFlag` names `NoTypeInfo`, `ProceduresAreVoidPointers` and `NoSizeComplaint`. The sealed policy accepts typed flags or checked source bit values; unknown bits are rejected. `TypeRegistry::add_record_reflection_flags` validates the actual nominal identity before monotonically combining flags. Procedure reduction also interns the canonical `*void` metadata type after that validation, so immutable descriptor construction can use its real identity. Interning alone never promotes a type into the source-visible runtime catalog. Source reservations can receive flags before their fields finish resolving. Frozen `Types` retains the same policies.

`member_type` validates an actual `FieldId` against its owning record first. It then returns `Omitted`, the unchanged declared type, or `VoidPointer` for a procedure field. `NoTypeInfo` hides member metadata; it never makes the record physically empty. Procedure reduction affects reflected edges only, so `type_of`, procedure calls, layout and ABI keep the original signature. `NoSizeComplaint` suppresses the large-metadata warning rather than imposing a new size or dropping descriptors.

`ReflectionGraph` uses these decisions while closing descriptor dependencies. Hidden members introduce no descriptor edges. A reduced procedure field points to the canonical `*void` descriptor and keeps its real `FieldId`, offset, name and notes. Serialization sets the source member flag `IS_PROCEDURE_AS_VOID_POINTER` (`8`) from that retained edge and physical field proof. An old immutable graph continues to describe the policy under which it was built; later registry settings never rewrite its objects.

Semantic descriptor publication remembers the record policies used by the shared static arena. Changing a published policy currently reports pending descriptor revision instead of returning stale metadata or mutating a borrowed `Arc`. The remaining transaction must rebuild the final runtime publication from versioned descriptor recipes while retaining earlier compile-time value snapshots and canonical identities. This pending revision is an implementation readiness boundary, not a language restriction on when flags may be added.

`RecordReflectionTransaction` stages registry changes without changing policies or interning descriptor pointer types. Its first successful stage binds the transaction to the target's canonical compilation arena, including no-op stages. Each target retains its original canonical `TypeId` and observed policy; repeated stages combine flags monotonically. `validate` checks the arena, all targets and their observed policies. Consuming `commit` repeats that preflight before interning `*void` or publishing any policy, then returns a sealed `RecordReflectionCommit`. Its changes expose exact `record`, `before` and `after` values. Inspecting staged changes cannot manufacture a commit receipt. A foreign target, invalid nominal type or stale policy leaves every registry target unchanged. Dropping a staged transaction cancels it; no-op updates produce an empty commit receipt.

`prepare` separates fallible validation and storage preparation from policy publication. It returns a `PreparedRecordReflectionTransaction` holding an exclusive borrow of the same registry, preventing intervening type or policy mutations. Pointer interning, map capacity reservation and receipt storage happen before a caller commits external effects. Consuming `apply` then publishes policies and returns the sealed commit receipt without a fallible validation or allocation phase. Dropping the prepared guard cancels policy changes; auxiliary canonical pointer types and reserved capacity can remain, but no source schema or reflection policy is published. The convenience `commit` uses this same preparation and application path.

The transaction core does not publish descriptors or grant compiler effects. The source compiler journal must retain actual source locations, admit retained transaction resources, validate the rest of the job, and arrange descriptor revision from committed receipts. Earlier immutable descriptor snapshots remain owned by their existing values. Connecting `compiler_set_type_info_flags` to that complete source journal and publication flow still needs integrated source tests.

Source directive parsing, `compiler_set_type_info_flags`, revision scheduling and native runtime-table publication require their own integrated source tests. The core API and descriptor construction alone do not establish acceptance of those features. There is currently no large-metadata warning producer for `NoSizeComplaint` to suppress; the policy is retained without changing members or layout.

The production frontend adapter retains exact source settings as `RecordAttribute::Reflection(RecordReflectionSettingSyntax)` with canonical flags and byte spans, alongside the existing `TypeInfoNone` attribute. Static, generic, anonymous and local shape producers apply the policy to the original nominal identity. Unrelated or misspelled directives remain parser errors. [Ordered record source metadata](ordered-record-source-metadata.md) documents this activation and its pending centralized source gate; older isolated parser receipts establish only their own historical checkpoints.

## How to change it

Extend the typed flags and checked input mask together if a newer source distribution defines another flag. Apply policies while constructing reflection edges and members, rather than mutating `RecordDefinition`. Compiler calls may add flags but must never replace or clear earlier source settings. Preserve nominal ownership checks even when a policy hides all members.

Tests cover unknown source bits, monotone combinations, foreign and structural identity rejection, early reservations, frozen policies, physical layout preservation and member-owner validation. Descriptor tests additionally verify that hidden records retain their layout and notes, that procedure reduction prunes signature dependencies, and that an earlier graph remains unchanged.

Transaction tests additionally cover repeated staging, stable first-target receipt order, later-target stale failure before pointer interning, foreign-commit isolation, cancellation, stale restaging, cross-arena staging and checked no-op targets. The immutable actual-source checkpoint `artifacts/component-checkpoints/record-reflection-transactions-20261002T135545Z` passes the full 111-test type suite, including twelve policy/transaction tests, and strict all-targets Clippy. Its input hashes, executable hashes and logs are recorded in `validation.json`; broader source acceptance is separate.

## Configuration

Source flags use the documented `u32` values `1`, `2` and `4`. A record without explicit settings receives the default policy. Policies are local to one canonical type registry; matching source names never transfer settings to another nominal type.

## Dependencies

The `jai-types` registry, `TypeView`, canonical `TypeId` and `FieldId` proofs. The frontend supplies source settings; semantic reflection, compiler intrinsics and the LLVM backend consume the resulting metadata policy.
