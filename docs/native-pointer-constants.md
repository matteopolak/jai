# Native pointer constants

## What it is

`NativePointerConstant` represents an integer-to-pointer cast intended for native
constant storage. It retains a canonical pointer type, source integer, and cast
mode; it never creates VM data or code provenance.
Storage `force` modes cannot enter this numeric-address capsule; they require
their dedicated storage-bitcast representation.

`ConstantKind::NativePointer` retains this payload for declaration defaults and
global, record, or parameter initialization. Native emission normalizes against
LLVM TargetData; the VM importer uses its explicit target layout. The helper's
five focused tests pass; the newly activated source and native integration
fixtures still await their shared-consumer test checkpoint.
Two active IR integration proofs also pass: a capsule cannot be placed under a
different pointer type, and conversion to an expression retains its source
integer and exact cast mode.

## How it works

An untyped integer literal stays `NativePointerSource::Weak(i128)` until the execution or native target selects its pointer width. An explicitly typed integer stays `Strong(Integer)`, retaining source width and signedness. Checked weak values must fit the selected unsigned width (or signed width for negative values); unchecked and truncate casts keep the selected low bits. `ValueExpr::NativePointer` carries this recipe unchanged through expression lowering, including private semantic preparation, so there is no implicit LP64 normalization.

The payload validates the pointer type without assuming a host address width.
`address(selected_bits)` computes an unsigned address representation for the
execution target. Same-width signed values preserve their bits; smaller signed
inputs sign extend. A checked conversion from a wider input requires a
nonnegative value within the target's range. `no_check` and `trunc` retain their
separate source modes while narrowing to the target's low bits.

For example, signed 64-bit `-1` becomes all ones at 64 bits. A checked conversion
to 32 bits fails, while `trunc` produces `0xffffffff`. A signed 8-bit `-1`
sign extends to all ones at 64 bits. Tests cover 8-, 16-, 32-, and 64-bit target
normalization and reject unsupported widths.

Native constant emission must normalize using actual LLVM TargetData and then
construct a constant integer-to-pointer conversion. The VM must use its explicit
target layout: zero becomes a canonical null pointer, while a nonzero numeric
address remains opaque. Sentinel comparisons and numeric round trips operate on
those bits; they do not grant allocation bounds, a callable receipt, or host
memory access. Dereference and heap operations still require actual provenance.

The native `cast_dialects` integration suite compares the nonzero `-1` sentinel
with null in both the VM and a newly generated executable. Its separate
provenance-bearing data-pointer-to-narrow-integer case still requires the VM's
explicit unsupported-operation result, because virtual addresses cannot predict
a native allocation's low bits.

## How to change it

Update `jai-ir/src/native_pointer_constants.rs` alongside the constant verifier,
declaration defaults, native constant emitter, and VM constant importer. Keep
target normalization at the execution boundary rather than guessing a width in
declaration-default evaluation. Static object relocations are a separate storage
representation and must not be encoded as native integer addresses.
Declaration defaults validate against `Nominals::annotation_target()` when the
selected layout is already known. When it is not known, they retain the source
recipe for execution-time validation. A source zero uses the ordinary null
constant; a nonzero source that truncates to zero for one width retains its
capsule rather than discarding target-dependent information.

## Configuration

The selected target's pointer width controls normalization. The helper accepts
8, 16, 32, or 64 bits; an unsupported width fails explicitly. There are no
feature-specific environment variables.

## Dependencies

The helper uses `jai-types` canonical TypeId, integer representation, CastMode,
and TypeView. Its execution consumers use typed IR constants, LLVM target data,
and the VM's explicit target layout and provenance rules. Primary source evidence
for nonzero sentinels is `reference/modules/POSIX/bindings/linux/base.jai:372`
(`MAP_FAILED`) and `reference/modules/POSIX/bindings/linux/pthread.jai:59`
(`PTHREAD_CANCELED`), both declaring `cast,trunc(*void) -1`. These files are
inspected statically only.
