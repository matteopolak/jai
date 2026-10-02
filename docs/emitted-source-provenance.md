# Emitted source provenance

## What it is

Semantic lowering records source locations, lexical blocks and named runtime
locals alongside the IR it actually emits. The immutable debug sidecar uses
typed structural paths, so generated statements do not shift unrelated source
locations or variable declarations.

## How it works

`debug_capture::Capture` pairs the current source statement with its returned IR
node. The block emitter records that node at `out.len()` immediately before the
push. Nested helpers attach their completed block at an explicit `DebugBranch`,
and cleanup bodies use their actual `CleanupId` root. Sequence iteration and
macro helpers shift their captured body by the number of IR prefix statements
they explicitly insert. Neither AST statement counts nor tree traversal order
determine this association.

The capture module separates emitter bookkeeping, exact-record lookup and final
path publication into `emission.rs`, `resolver.rs` and `publication.rs`. An
iterative walk of a returned IR node attributes its generated descendants to the
real triggering statement while stopping at explicitly captured child blocks.

Named declarations record the real `LocalId` as binding allocates storage.
Their types remain the actual `Procedure.locals` storage `TypeId`s backed by the
library's immutable type registry; source records do not duplicate type layouts
or derive types from source text.
The type sidecar publishes real nominal `TypeId` spellings and opaque `FieldId`
spellings from completed semantic shapes. Generic records retain their original
definition location, while anonymous records retain an absent name. An erased
alias cannot rename the shared underlying type identity. A physical field with
no source spelling is omitted; consumers must omit an unsupported descriptor
rather than invent a field name. Native member sizes, alignments and offsets
come from the target's checked layout engine.
Parameters retain their source spans and zero-based runtime formal indices;
native lowering adds one for DWARF argument ordinals. Hidden context storage is
excluded. Loop bindings move to the captured loop-body
scope. Projection aliases without their own runtime local are not presented as
independent stack slots.

Declarations address their actual containing block. A loop control binding can
address its immediate `While` or `Range` statement while belonging to that
statement's body scope. Generated sequence iterators address their real body
initializer; a containing generated wrapper does not widen their scope.

Source identity is independent of name lookup. A quoted code insertion brackets
lowering with its retained original `SourceId`, including `#insert,scope()`.
Macro bodies use their defining file while runtime argument initializers retain
the caller origin. A local macro declared by a current-scope insertion retains
the quote's source even though its lexical capture belongs to the caller's file.
The capture keeps a separate chain of exact invocation `SourceSpan`s, ordered
from the outermost to the current expansion. Caller directive lowering can read
the required invocation without replacing its AST source. Each expansion
restores the chain on success or failure; a code insertion can temporarily clear
it while resolving the captured source. Debug emission policy is independent of
both origins.
The source inventory holds shared original `Arc<str>` records
and indexes coordinates once per file. No node copies a complete source file.
Errors preserve the same typed origin through context restoration; see
[Source diagnostic origins](source-diagnostic-origins.md).

Only successful procedure bodies publish their captures. Finalization checks
that each path addresses the emitted IR, that local storage belongs to the same
procedure, and that every location belongs to the exact retained source record.
Generated operations inherit their genuine triggering source statement's checked
location. Explicitly captured child blocks retain their own origins. Cleanup
roots also retain their declaration's lexical parent, including a parent inside
another cleanup; invocation in a deeper scope cannot change that parent.
Callable aliases also share the original procedure identity. Only its actual
procedure or prototype declaration publishes its name and definition range;
an alias declaration cannot replace that provenance.
After body binding, graph-backed callable metadata is refreshed from the
file declaration's complete parser-owned range. The procedure header's own span
identifies its name token for diagnostics and cannot supply that full range.

`#no_debug` uses a separate `DebugPolicy`. Suppression removes locations and
named runtime local metadata while retaining the source identity used by quotes,
diagnostics and caller locations. A suppressed expansion keeps already evaluated
caller argument locations and hides its formal and body variables. Nested
expansion cannot reenable suppressed capture. Whole procedures retain their
canonical `ProcedureSource` and a checked suppression policy so native lowering
can omit their subprogram metadata without inventing a fallback frame.
Procedure user notes use the same retained source inventory but remain
independent of debug emission. Their ordered exact source bytes and locations
are checked against the real procedure identity; see
[Procedure notes](procedure-notes.md).

## How to change it

When adding a helper that nests a resolved block, call `attach_block` immediately
after lowering it, using the precise relative child path in the returned IR.
When inserting a prefix, call `prepend_block` with that emitted prefix's length
before moving the body statements. When a wrapper returns a quoted statement
unchanged, call `forward_statement` to retain its original source association.
Register separate cleanup bodies with `cleanup(id)`.

Keep source override restoration next to lexical-scope restoration in code
insertion and macro expansion. Append the actual invocation span before
switching to a macro's definition source, and restore the caller chain on every
returned result. Add a regression that checks source text at the
final `StatementPath`; checking declaration locations alone misses generated
prefix errors. Native lowering and DWARF validation are described in
[Native source debug information](native-debug-information.md).
When publishing a new nominal type family, add its genuine original source to
the semantic type inventory and extend `modules/debug_sources/types.rs` using
the final registry identities. Keep unnamed source entities unnamed. Extend
the sidecar's registry validation whenever the allowed nominal kinds change.
Policy entry and restoration must bracket only the intended procedure or macro
body; keep source override restoration independent of debug emission.
A semantic rebind under the same procedure identity calls
`DebugSources::clear_procedure` before lowering the replacement body. This
removes its stale paths, locals, cleanup parents, notes and emission policy while
preserving the shared source inventory and nominal type origins.

## Configuration

`#no_debug` suppresses procedure or expansion metadata. Native debug emission is controlled by the backend's
debug-information mode; an absent source record produces no invented location.
Source ranges remain half-open UTF-8 byte ranges, with checked one-based line
and character-column coordinates.

## Dependencies

`jai-source` owns immutable records, `jai-syntax` owns full statement spans,
`jai-modules` supplies original file identity, and `jai-ir` validates the sidecar
at the program publication boundary. `jai-types` owns nominal and field
identities, layout policy, and the debug emission policy.
