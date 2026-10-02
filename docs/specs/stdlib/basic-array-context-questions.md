# Basic array declaration context questions

Resolved by root's actual offline official Jai 0.2.030 independently authored seven controls: pokes affect the target module's own generic definitions, including #load definitions; they do not affect an aliased provider generic's lexical lookup. Record equality requires a visible explicit overload. Public Basic.array_find sees equality explicitly poked into Basic. No blanket compiler alias refresh or poke propagation is justified.

Resolved by current reviewed basic.md:585: resizable(slice, set_allocators=false) leaves allocator fields uninitialized and requires the caller to supply them before allocation/free. The fixture's initial zero-field assumption was wrong; the failure is retained, and the corrected test verifies real supplied-owner freeing under an alternate context.

Separate compiler dependency, not resolved by this library architecture: a forward-declared custom interface type supplied as the Basic program setting REPLACEMENT_INTERFACE=Hooks fails with 'set here after the module already used another value'. The fixture implements the four reviewed interface methods. The same source and compiler fail before and after the owned array changes. Root/current compiler owner should establish the required ordering and run the source-only official probe if necessary. No default substitution, cast, type-name exception or new public helper is supplied here. Exact before/after inputs and diagnostics are retained in own T7 custom-interface-before-array-owner.json and complete-family-matrix/checks.json.

Default MEMORY_DEBUGGER=true instrumentation and canonical type/procedure identity across ordinary program settings pass in the owned fixture. Broader custom-interface success, native platforms other than Mac ARM64, full corpus and original application runtime remain unclaimed.

Root supplied the official build verdicts on 2026-10-16: independent basic-empty,
plain-import and baseline controls all accept. Their source SHA256 values are
f467ea6162ca7877fe1277c3042370111c7f4c536ff7974be071061a94df9f5b,
b9b257185a6aec62f9dfd32fa951ed089a137ddf353f702147715245d9461445 and
33db4c1776fc59be1b34af3a5706b237f92336e20cf385400629b735be59e926.
The custom typed program-interface rejection is therefore a confirmed compiler
compatibility defect, not an expected API rejection. General parameter ordering
and constraint repair belongs to the compiler/runtime owner. Integration's
frozen e0e287ea source check still fails before the array body; its positive-case
failure remains in the Mac receipt. No reference implementation, binary or raw
reference log was accessed here.
