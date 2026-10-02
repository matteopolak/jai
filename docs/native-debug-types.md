# Native debug type descriptions

## What it is

The native backend describes supported source records, unions, fixed arrays, pointers and procedure values in DWARF, including recursive record pointers. Descriptions use the published semantic type and field identities, original source spellings and the selected target's checked storage layout.

## How it works

The semantic source sidecar retains `TypeSource` by `TypeId` and `FieldSource` by `FieldId`. Named declarations carry their actual spelling; anonymous records have no invented name. Field names and declaration locations come from the bound semantic member. Publication validates the nominal identities and the retained immutable source records.

`jai-codegen::debug::types` preflights the complete reachable type graph before building a variable descriptor. Every record member must have source provenance and a supported type. Missing information omits the variable descriptor instead of inserting names such as `f0` or describing a record as an integer. Instruction locations remain available independently.

`LayoutEngine` computes sizes, alignments and declaration-order offsets using a policy derived from the actual LLVM `TargetData`. Packed records, explicit field alignments and unions keep those checked layouts. Member metadata uses the effective field alignment, including reduced packed alignment; pointers use the selected target's width. Fixed-array lengths must fit LLVM's signed subrange count. All conversion from bytes to bits is checked.

Procedure values use a pointer to a subroutine descriptor built from the checked signature's parameters, results, variadic policy and calling convention. Multiple results use the checked tuple layout. These descriptors are emitted only when the complete signature type graph is supported; a pointer alone does not stand in for a missing signature. The CLI regression follows the callback variable's metadata references to its actual signature, inspects the emitted DWARF and executes the fresh program at both optimization levels.

Subprograms use the same checked source signature. Declared parameters exclude the implicit Jai context pointer: that pointer is a compiler ABI argument, rather than a source formal. Multiple results have an unnamed artificial tuple with unnamed artificial members at canonical target offsets; the compiler invents no result field spellings. The sealed factory independently checks sequential placement, alignment, overflow and exact tail padding. C variadic signatures carry an ellipsis. Normal Jai and C signatures use `DW_CC_normal`, and `#stdcall` uses `DW_CC_BORLAND_stdcall`. The C++ method convention follows the current target classifier's normal convention. This describes source types; it does not promise debugger expression evaluation can perform every Jai or C++ ABI call. Unsupported parameter or result types still prevent a complete signature description.

The sealed `jai-llvm::DebugSession` constructs opaque `DebugType` handles. A handle contains a session brand and a stable table slot, not a copyable raw metadata pointer. Recursive records are reserved before their pointer members are constructed. Completing a record replaces its temporary metadata and updates its slot; previously returned handles resolve the updated slot. LLVM's [replacement implementation](https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-22.1.0/llvm/lib/IR/DebugInfo.cpp) deletes the replaced temporary, so retaining its raw pointer would be invalid.

Cross-session child types, repeated record completion, invalid field extents or alignments, and oversized array counts are rejected before the raw constructors. Storage extents must be multiples of their alignment, including tail padding; zero-size storage is permitted. A private graph of record and array storage edges also rejects recursion by value; pointer edges terminate that graph. Traversal visits each reachable slot once and follows only edges created by earlier checked factory calls; it has no extra recursion depth or expansion limit. A rejected completion leaves its construction token available for a corrected retry. Unfinished bridge records become genuine forward declarations on finalization or drop. Native preflight normally completes every published record. The owning module and context remain borrowed until the session is finished.

## How to change it

Collect new source names and locations at semantic binding sites, preserving the exact `TypeId` or `FieldId`. Extend the checked source sidecar before extending native descriptions. Do not infer names from an LLVM storage struct or from field position.

Extend native graph preflight and target layout handling together. Add session-owned factories in `jai-llvm/src/debug_records/types.rs` and checked raw constructors under its private `raw` module. Keep raw metadata inaccessible and use slot resolution when handling recursive types. The registry regression covers packed members, unions, arrays and missing provenance; bridge regressions cover recursive replacement, retained handles, ownership rejection and unfinished-record cleanup.

Enums, distinct types and compiler descriptor types such as slices still require further faithful descriptions. They remain explicitly unsupported rather than being mislabeled as their storage representation.

Composite types currently belong to the compile unit. Their original declaration file and line are retained, while each variable keeps its checked lexical scope. The type sidecar does not yet encode local type declaration scopes or generic template arguments.

## Configuration

`-g` enables variable and type descriptions. `-gline-tables-only` omits variable types; `-g0` disables debug information. Native compilation supplies the actual target layout to `LineTables::new_with_policy`. The convenience constructor retains an LP64 policy for direct callers; use the explicit policy when building another target.

The source integration fixture inspects the generated LLVM metadata and native DWARF at both `-O0` and `-O2`, then executes the newly linked programs. Optimization may remove storage locations or values even when type and variable identities remain present.

A separate registry fixture emits i686 and x86-64 Linux objects and inspects their DWARF pointer widths, procedure signatures, artificial result tuples and record member offsets against the selected target layout. The source fixture also checks semantic `size_of(Packet)`, source-named records and an actual callback initialized from a source procedure. Its callback has a 32-bit or 64-bit pointer to the checked return and declared parameter types. These cross-target checks establish metadata and object emission; they do not execute those objects or establish foreign-library availability. Separate host callback fixtures inspect DWARF and execute scalar and multiple-result callbacks to `42` at O0 and O2.

## Dependencies

The checked `jai-ir` source sidecar, `jai-types::TypeView` and `LayoutEngine`, LLVM target data, the sealed `jai-llvm` bridge, and independently installed LLVM tools for inspection. Fixtures contain only self-written source and newly generated native artifacts.
