# Opaque procedure addresses

## What it is

Procedure handles stored in `Any` can be inspected through the pointer-cell views
used by Basic's formatter. An opaque code address preserves identity without
becoming readable data storage.

## How it works

```jai
Increment :: #type (value: s32) -> s32;
increment :: (value: s32) -> s32 { return value + 1; }
boxed: Any = increment;
address := (cast(**void) boxed.value_pointer).*;
bits := cast(u64) address;
callable := (cast(*Increment) boxed.value_pointer).*;
```

The descriptor points to a data cell containing a procedure handle. Reading that
cell through `**void` yields an opaque code address; it does not dereference the
code address itself. Reboxing that address preserves its provenance. A null
callable cell yields a null address and zero integer bits.

Native LLVM stores actual generated function pointers in these cells. Opaque
pointer casts, comparisons, pointer-to-integer conversion, and exact-width integer
roundtrips retain the same native address. Typed callable recovery still uses the
canonical procedure signature and existing indirect-call ABI. This path needs
no direct procedure-to-`*void` cast; those source casts remain rejected.

The VM uses a sealed receipt issued by the owning Memory for an admitted canonical
procedure token. The receipt retains the original procedure identity and exact
signature, never a fabricated allocation or a raw procedure-ID integer. Byte
images preserve receipt metadata across cell views and copies. Recovery validates
the issuing Memory and signature. Integer address values retain their provenance;
arbitrary integer bits cannot invent a callable receipt or publish a native
address from compile-time execution.

Exact receipt-preserving integer views can roundtrip and compare the same code
address. Address-derived numeric control flow and transformed address digits do
not yet have a diagnostic-output consumption policy. The VM therefore rejects
the formatter's numeric truth, digit indexing, and output-storage path explicitly;
the corresponding freshly generated native fixture executes successfully. This
boundary must not be relaxed merely to make formatting pass.

The VM rejects data dereference, nonzero arithmetic, and freeing of code addresses.
An offset of zero preserves the original receipt.
Native erased pointers do not carry a dynamic code-versus-data class: unsupported
data operations on a function address may be undefined native behavior. Native
tests execute only valid formatter views, identities, and callable recovery;
invalid data-operation tests belong to the VM. No original native compiler or
supplied native object is executed.

## How to change it

Coordinate `jai-vm/src/memory/code_pointers.rs`, the byte-image codec, Any source
lowering, and native pointer conversions. Preserve issuing-Memory ownership and
exact signature identity rather than deriving provenance from a numeric token.
Keep code addresses outside data allocation bounds and lifetime machinery.

`jai-codegen/tests/procedure_addresses.rs` contains independently authored source
cases for the formatter's opaque and integer cell views. Existing Any tests cover
descriptor construction and ordinary typed callable-cell recovery.
The separate formatter digit fixture checks native execution and the VM's explicit
unsupported-capability diagnostic, rather than claiming VM formatting support.

## Configuration

The selected target layout governs pointer width and byte order. The formatter's
raw `*u64` cell-view fixture exercises its 64-bit target path. VM limits and
compile-time materialization rules remain in force. Native tests use the trusted
Clang selection described in [Native test tools](native-test-tools.md).

## Dependencies

This feature uses typed Any descriptors, canonical procedure signatures, existing
pointer casts and dereference IR, VM handle-token receipts and byte metadata,
LLVM opaque pointers, and indirect-call ABI lowering. Basic's Print source is
static evidence for the cell views; native evidence comes from newly generated
programs.
