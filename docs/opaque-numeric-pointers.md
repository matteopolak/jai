# Opaque numeric pointers

## What it is

The VM preserves ordinary numeric pointer values, including allocator capability bitmasks and `cast(*void)1`, without assigning those bits an allocation or procedure identity. Null, data, code, and numeric pointer origins are distinct variants of one closed representation.

## How it works

`Pointer` contains an origin and the nominal pointee type. Only its `Data` variant retains a Memory/allocation identity, projection path, and allowed byte region. `Code` contains an existing canonical procedure receipt. `Opaque` contains either 32-bit or 64-bit numeric bits; zero normalizes to `Null`.

Weak literal constants use the existing IR `NativePointerConstant` recipe and normalize when the execution target is selected. Strong integer casts preserve same-width bits, extend according to source signedness, and apply checked, unchecked, or truncating conversion rules. Numeric pointer truth, null comparisons, pointer equality, and integer round trips use the selected bits. Equality with an actual virtual address does not confer that address's capability. Integer conversion from an opaque pointer produces an ordinary integer without `AddressProvenance`.

ByteImage encodes numeric pointer bits in target byte order without a handle relocation. Reading untagged numeric bytes as a pointer creates an opaque value. Genuine data and code handle receipts continue to survive typed stores and copies. Reading numeric bytes as a runtime `Type` or procedure fails; numeric bits cannot create their receipts.

Dereference, writes, allocation release, and host buffer access require a `Data` origin. Heap free/reallocation additionally require exact ledger ownership. Numeric pointers fail with `numeric address has no allocation provenance`, or `pointer is not owned by the virtual heap` at the heap boundary. Numeric pointer layout admission consumes one work unit before inspecting the nominal type or target domain.

## How to change it

Change the origin model in `jai-vm/src/memory.rs` and the typed numeric variants in `memory/opaque_addresses.rs` together. Address casts live in `memory/addresses.rs`; IR constants enter through `constants::native_pointer`. Byte storage must preserve the distinction in `byte_memory/handles.rs` and retain the runtime Type/procedure guards in `byte_memory.rs`.

A new operation on numeric pointers must operate on numeric bits explicitly. Do not recover an allocation or code receipt by searching for matching token bits. Scalar compiler constant publication uses the existing `NativePointerConstant` leaf. Descriptor byte storage preserves the nominal type, initialization mask, and numeric bits; publishing descriptor images as compiler graphs requires the separate symbolic-storage image path.

## Configuration

The execution `ByteTarget` selects layout policy and byte order. Numeric values support the language's 32-bit and 64-bit pointer targets; values from another target width are rejected rather than widened into a capability. VM fuel and value-cell limits still apply. No host pointer-size fallback or environment variable changes are introduced.

## Dependencies

The feature uses `jai-types` integer casting and target layouts, `jai-ir` native pointer constant recipes, VM Memory and virtual heap receipts, and ByteImage initialization/provenance metadata. Native lowering consumes the same numeric IR recipe; its execution tests use installed LLVM 22 tools and newly generated programs.

The main workspace all-targets check passes. Eight VM tests cover 32-bit and 64-bit casts, byte order, storage, data/code receipt retention, descriptor and allocator target domains, materialization quotas, and rejected operations on guessed addresses. Two semantic publication tests pass. All nine allocator source tests pass, including the unchanged standard-library CAPS and ownership bodies. Both native pointer test groups pass at O0/O2, including scalar `#run` result publication. Native execution uses the host target; the 32-bit evidence is VM and semantic coverage. The full VM suite, strict Clippy, and broader captured-storage graph acceptance were not part of these gates.
