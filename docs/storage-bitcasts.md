# Storage bitcasts

## What it is

`StorageBitcast` is a sealed, target-bound layout proof for an explicit byte
reinterpretation. Lowercase `force` requires equal source and destination sizes;
uppercase `FORCE` permits a smaller destination from the source's byte prefix.

## How it works

The primary source contracts are `reference/CHANGELOG.txt:3209`, which separates
the two strengths, and `:1794`/`:2145`, which describe fixed-array element views.
`reference/modules/Basic/Int128.jai` repeatedly converts its distinct `S128` and
`U128` records without changing their two-word storage. These files are inspected
statically; the supplied compiler and native artifacts are never executed.

The proof retains the actual source and destination `TypeId`s, selected
`LayoutPolicy`, strength, both byte extents, and the maximum of their required
alignments. Construction checks arena ownership and completed byte layouts.
Revalidation checks the consuming compilation's types and policy again.
Completed zero-byte records are valid; unsized `Code` and `void` are rejected.
Different nominal identities remain distinct after proving compatible storage.

The compiler flag identities remain separate: `force` uses `FORCE` (`0x80`),
while `FORCE` uses `VERY_FORCE` (`0x100`), as retained by the supplied Compiler and
Program_Print modules. Neither strength means unchecked numeric conversion or
integer truncation.

This proof certifies layout compatibility only. It cannot issue pointer or code
provenance, initialize unread bytes, validate Boolean bytes, or permit a virtual
address to become a portable constant. Those obligations belong to the checked
IR, byte-image codec, and publication boundary. Passing layout tests alone does
not establish actual Int128 or standard-library execution.

Checked IR verifies the complete runtime-storage closure, including a genuine
`RuntimeTypeSchema` for `Type` values. A pointer-sized layout alone cannot
substitute for that metadata relationship. It retains either a real source place
or one value-producing expression.
The synchronous VM resolves or evaluates that source once. Its continuation plan
keeps the same source as one computed operand, then applies the cast without
reevaluating source IR. A place is read through its byte image rather than a
structural value load, so a prefix can use initialized leading fields while an
unrelated source tail remains unwritten. String rvalues normalize to descriptors
before encoding.

VM conversion retains initialization masks and relocation receipts. Aggregate
results use sealed stored-image carriers so padding and inactive bytes survive
a later storage roundtrip. Selected semantic bytes must be initialized, and
ordinary Boolean leaves must contain exactly zero or one. Integer views of data
pointers retain address provenance; the cast cannot turn a receipt into a
portable integer or issue a code receipt from a data receipt. Publication still
requires its existing complete-image proof.

An integer receipt can reconstruct a root pointer or procedure value only through
Memory's explicit inverse checks for issuer, bits, lifetime, region, and callable
signature. The generic byte decoder does not gain this permission. Nested
integer-to-pointer views inside aggregate targets remain an explicit unsupported
case until target traversal can apply the same checks to each selected field.

Before conversion, the VM prepares demanded source and target layouts and charges
the source image work, selected metadata, and destination value expansion. A
zero-byte destination with many zero-sized elements therefore consumes fuel
before its semantic values are allocated. Both execution paths share these
memory APIs and limits. Codec layout work includes zero-count array element
closures separately from decoded value nodes.

Native lowering resolves the source once into scratch aligned to the maximum
source/destination requirement. A place uses a byte copy rather than a typed
load of an unwritten source tail. Ordinary Boolean leaves receive runtime
representation guards. LLVM aggregate values currently omit implicit record
padding, so native casts involving padded value sources or padded destination
values reject at the backend with an explicit source/destination role. Padded
place sources can still use a raw copy into a scalar or supported prefix. A
complete physical record representation remains required for padded native
roundtrips; two-word Int128 records have no such gaps.

`jai-codegen/tests/storage_bitcasts_ir.rs` checks both typed rejection roles and
executes a padded place-to-scalar copy at `-O0` and `-O2`. The same fixture checks
aligned snapshots, initialized prefixes, and canonical Boolean representation
guards. These boundaries must change together with the physical record
representation; removing the diagnostic alone would lose known gap bytes.

Exact pointer-tagged integer receipts can be recovered at a root pointer or
procedure destination through Memory's existing inverse proof of bits, owner,
lifetime, region, and signature. Plain, transformed, partial, or unowned bits
cannot create a VM pointer. Nested integer-receipt pointer destinations and
opaque malformed union aliases require further typed decode support. Baked
Force constants likewise require a selected VM materialization recipe; they do
not silently use numeric wrapping.

All nine authored source acceptance tests pass, covering signed/unsigned two-word records,
fixed-array element views, uppercase prefixes over unwritten tails, scalar
float bit patterns, pointer receipt recovery, and invalid target views. Pure
declaration defaults diagnose the missing selected storage recipe before numeric
or record coercion can run. Native
acceptance runs fresh LLVM output at `-O0` and `-O2`, including alignment changes,
zero-byte producer effects, Boolean traps, and an independently written C
argument/result boundary. These fixtures establish their specific contracts;
checking unchanged full `Basic` remains a separate source-library gate.
The CLI suite `crates/jai-cli/tests/storage_bitcasts.rs` independently verifies
`#run` and native numeric/record bit patterns and byte prefixes, located extent
errors, and preservation of existing output when compilation fails.

## How to change it

The pure proof and focused tests live in
`crates/jai-types/src/storage_bitcast.rs`. Keep its fields private and revalidate
proofs at every independent IR or backend admission boundary. Add a strength
only with a source-backed extent rule and a distinct source/compiler policy.

The VM consumer lives in `jai-vm/src/execute/storage_bitcasts.rs`, with byte-image
conversion and preflight in `memory/storage_reinterpretation.rs`. The continuation
lowering and apply operation retain one source operand; keep place sources out of
the ordinary `Load` path. Extend checked-IR and execution regressions together
when adding source or destination forms. Boolean validity through union aliases
is a separate codec capability and must not be inferred from ordinary Boolean
leaf validation.

VM admission must use Memory-owned retokenization and complete relocation
certificates. Native scratch storage must
use the maximum alignment; allocating with only the source alignment would make
a stronger destination load invalid. Initializedness, padding, Boolean validity,
and provenance-erasing views require an explicit consumer policy before runtime
activation.

## Configuration

The selected target layout controls sizes and alignments. Byte order belongs to
the actual VM/native target and governs the prefix's numerical interpretation.
Existing compiler execution and allocation limits continue to apply; the proof
does not allocate storage or depend on the Rust host representation. There is no
cast-specific environment variable.

## Dependencies

The proof uses the canonical type registry and iterative `LayoutEngine` in
`jai-types`. Execution depends on typed IR, source place resolution, the VM's
initialization masks and relocation receipts, and LLVM storage lowering. Native
fixtures use the trusted tools documented in [Native test tools](native-test-tools.md).
