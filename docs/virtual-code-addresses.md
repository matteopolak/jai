# Virtual code addresses

## What it is

The VM can read a procedure cell through an opaque pointer view, as `Basic.Print`
does. A private `CodePointer` proof retains the canonical procedure token owned
by that VM's `Memory`, without creating data storage or exposing a host address.

## How it works

`reference/modules/Basic/Print.jai:794` reads a boxed procedure with
`.*cast(**void) item.value_pointer`, checks null, and formats the opaque address.
This is a read of the procedure cell; it does not dereference the code address.
The source is inspected statically, and no supplied native code is loaded.

Memory already assigns aligned, target-width virtual tokens to canonical
`HandleKey::Procedure { signature, procedure }` entries. The proof helper looks
up an existing entry and retains its memory owner, exact signature, procedure
identity, and token. It never allocates backing bytes or derives an address from
the procedure's numeric index. Revalidation checks the same live ledger entry.
Rollback removes receipts created after the snapshot; tokens are not recycled.

Recovering a procedure handle requires the original signature. The normal VM
call boundary must still check the provider's canonical signature and checked
body; a code-address receipt grants no execution permission. Integer conversion
must retain the opaque receipt alongside the bits. Roundtrip checks memory,
registry, target width, and exact token correspondence. A plain integer cannot
issue a receipt, and transformed bits do not acquire new code provenance.

After canonical retokenization, Memory certifies complete procedure relocations
in its byte images. Reading one through `**void` yields a pointer with a distinct
code origin; reading it through `*u64` retains the same address receipt. Reboxing
the opaque pointer and reading the new cell through the original procedure type
recovers the callable. Recovery through a different signature is rejected.
Unowned `ByteImage::encode` tokens cannot issue these certificates.

A code address outlives the data cell from which it was read. It still belongs to
the VM's canonical code ledger, so this does not extend the borrowed lifetime of
the original `Any` payload cell. Code pointers support null, identity, truth, and
exact address-integer roundtrips. They reject data reads, projections, release,
and nonzero offsets. Arithmetic on their integer bits retains provenance;
transformed bits cannot construct another code pointer. A `#run` result cannot
publish those virtual bits as a native constant.

This cell-view support does not establish full `Basic.Print` execution. Its
pointer formatter subsequently treats the address as an integer, branches on
it, and indexes a digit alphabet. The current VM deliberately rejects those
ordinary address-derived control and indexing operations. Supporting diagnostic
formatting requires checked value and control taint through numbers, booleans,
bytes, and strings, plus explicit diagnostic-output consumption. Removing the
guards would allow virtual-address information to become portable constants.

Truth conversion and incoming VM argument/storage validation recheck the issuing code ledger. A receipt minted by a rolled-back transaction cannot become a true pointer or address integer merely because its old bits are nonzero.

## How to change it

The proof lives in `crates/jai-vm/src/memory/code_pointers.rs`. When integrating
opaque pointer views, retain a memory-issued receipt on the complete relocation
after canonical retokenization. The global temporary tokens from unowned
`ByteImage::encode` must not create a code-pointer receipt during decoding.

Keep code origin distinct from allocation origin in Pointer handling. Code
addresses must reject data dereference, field/index projection, release, and
nonzero pointer arithmetic. Reuse the existing address-integer provenance path
so code-address bits cannot be published as portable scalar constants.
The certificate adapters live in `memory/code_images.rs` and
`byte_memory/handles.rs`; Pointer, number provenance, and handle
decoding must preserve their separate code origin.

`jai-sema/tests/procedure_address_safety.rs` checks wrong-signature recovery,
data access, offsets, transformed integer inverse, and `#run` publication.
`jai-codegen/tests/procedure_addresses.rs` checks freshly generated function
addresses and source-to-VM behavior. The independently authored
`jai-sema/tests/fixtures/procedure-address-formatting.jai.pending` retains the
unmet digit-formatting demand; syntax acceptance is separate from VM support.

## Configuration

`ByteTarget` selects pointer width, alignment, and endian order.
`Limits.value_cells` bounds the existing handle-token ledger, and its virtual
address space is bounded by the selected pointer width. There are no additional
environment variables, hidden allocators, or host function bindings.

## Dependencies

The proof uses canonical `jai-types` signature identities, `jai-ir::ProcedureId`,
VM Memory snapshots, complete byte-relocation certificates, address-integer
provenance, and the existing token ledger. It introduces no external dependencies.
