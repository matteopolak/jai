# Source external data

External data declarations refer to existing program or library storage. They
retain their declared type, source location, library identity, and optional
linkage symbol without supplying an initializer. The source parser, checked
semantic registry, VM storage boundary, and final library publication use the
same declaration metadata; native compatibility is verified separately.

## How it works

Bare `#elsewhere` identifies a program symbol. A library binding resolves the
actual lexical or imported foreign-library declaration and preserves its
metadata; an explicit symbol overrides only linkage spelling. A symbol name
does not grant a compile-time host-read capability. The general VM boundary
must reject access without a checked provider, while unused external
declarations remain valid. Native storage is emitted as an external declaration
with no fabricated zero initializer.

Procedure-local declarations occupy a source ledger independently of dense
program `GlobalId` storage. The existing `LocalDeclarationId` carries the
concrete procedure owner, lexical scope, defining source, declaration extent,
and parser-owned ordinal. An append-only mapping assigns its typed
`LocalExternalDataIndex` once. Binding retries reuse that identity and storage
slot. Equal symbol spellings in different scopes or specializations retain
separate declaration identities.

`ExternalGlobals` publishes only checked `ExternalData` with that exact source
identity and location. Its snapshot combines the original immutable file-global
prefix with the appended external globals. VM ready providers and final library
publication must use that same snapshot, so a local external cannot disappear
between semantic binding and execution. Changing a published declaration or
replacing its original prefix is an error.

External storage cannot be an owned `#add_context` field: that path needs an
owned field value and receives a located diagnostic instead of inventing an
initializer. A source export of external data must use its real `GlobalId`; a
different export spelling that would require a native data alias remains an
explicit unsupported boundary.

Header prerequisites can run before file-global publication. The registry
reserves the expected prefix count and rejects premature storage publication;
it does not append at a temporary index zero. The semantic scheduler must
retain this as genuine preparation readiness and diagnose a real prerequisite
cycle when it cannot progress. The agreed readiness carrier is
`Dependency::GlobalDefinitions`, distinct from constant or record-field jobs.
Declaration identity can be reserved while waiting, but no placeholder globals
fill the missing prefix. Pure prerequisites without external storage still see
their actual partial file-global prefix. The finalized prefix is certified once
before local external publication and is retained for native body binding as
well as compile-time providers.

Anonymous `#run` bodies have genuine compile-time procedure identities, but do
not belong in the native procedure ledger. `CheckedSourceProcedureOwner` retains
their actual checked body, context, immutable source allocation, and complete
file-global prefix. `SourceProcedurePlaces` shares the exact checked place snapshot
by allocation identity; last-owner disposal is iterative, so retaining an unused
deep operand cannot trigger an unchecked recursive clone. Additional globals
after the sealed prefix must be validated external declarations.

The separate owner ledger rechecks each body against final types and signatures
before external globals or local foreign libraries use it as an ownership
receipt. It rejects collisions with runtime bodies or prototypes and changed
global prefixes; it adds no runtime entry or placeholder body. The IR ledger is
registered in `ProgramBuilder` and `Library`. Source ready providers use the
same global snapshot, and anonymous bodies retain a receipt only when a local
external or foreign library actually requires their ownership.

The compiler's `__runtime_info` program data additionally needs a real generated
table receipt. Its spelling cannot rewrite an ordinary external into reflection
storage. See [compiler runtime information](compiler-runtime-info.md) for the
separate certified snapshot and native metadata boundary.

## How to change it

Keep syntax binding metadata, `ExternalDataId`, checked IR storage, the local
source ledger, ready-provider snapshots, and final publication coherent when
adding a declaration form. Add source/native fixtures for scalar and aggregate
storage, lexical library aliases, renamed symbols, repeated binding, and
unused declarations. Access tests must prove that an unavailable VM provider
fails without manufacturing a value.

The append-only semantic registry lives in
`crates/jai-sema/src/local_declarations/external_data.rs`. Extend identity rules
there rather than deriving IDs from spelling or source hashes. Preserve real
source ordinals and exact source spans for imported and generated declarations.
The owner proofs are in `crates/jai-ir/src/source_procedure_owners.rs`.
Keep their validation ahead of external-data and local foreign-library owner
checks. Incomplete canonical record definitions must preserve a real type
readiness dependency, rather than supply guessed fields.

The focused IR check is `cargo test -p jai-ir --lib --test external_data
--offline --locked -j1`. The recorded run passed all 97 unit tests, including
10 source-owner cases, and all six external-data publication integration cases.
`artifacts/ir-source-owner-external-lease.json` retains the command, source and
executable hashes, log, and resource limit result. Source execution and native
provider tests remain separate checks.

## Configuration

Configured graph sources and lexical foreign-library declarations determine
linkage provenance. The selected target controls storage layout; declared
alignment remains a separate checked storage policy. No configuration permits
loading supplied native compilers, libraries, or objects.

## Dependencies

This feature uses source identities, syntax binding metadata, canonical type
proofs, foreign-library metadata, checked IR globals, semantic ready providers,
and LLVM external-data emission. It adds no external dependency.
