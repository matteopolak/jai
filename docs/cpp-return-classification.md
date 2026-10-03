# Canonical C++ result classification

## What it is

`ForeignReturnAbi` is part of canonical procedure identity. `Natural` uses ordinary result classification; `CppNonPod` explicitly requests the Microsoft C++ caller-owned class result ABI for `#cpp_return_type_is_non_pod`.

This recovered private packet pairs the parser, canonical type and LLVM consumers on the guarded advanced compiler candidate. Formatting and dry-apply checks are source checks; the combined compiler and nine authored regressions remain unrun.

## How it works

The source enum survives module-bound callable types, lexical headers, generic specialization, callback patterns, bound signatures and signature reconstruction. Structural callback checks compare it. Stable module/source replay keys encode it; immutable reflection descriptors retain it and emit the existing prelude flag `HAS_CPP_NON_POD_RETURN_TYPE` (`0x2000_0000`). The receiver flag keeps its separate `0x1000_0000` bit.

Registry publication requires a context-free C or C++ method signature with exactly one actual record result (a distinct representation may wrap it). The LLVM classifier preserves the checked storage type and alignment, with existing placed-record and bitfield by-value guards. It allocates an indirect result even when an ordinary eight-byte result would fit in a register. Empty zero-extent Jai records are rejected because they do not prove a C++ empty-class representation.

A classified signature contains the exact physical result index and the first physical carrier index of every source parameter. Microsoft free/static calls use result slot zero; C++ methods put the receiver first and the result pointer second. Calls, definitions and indirect function pointers use this shared mapping. Reusing an existing LLVM symbol additionally compares its typed `sret` and `inreg` attributes, since opaque pointer function types alone cannot distinguish receiver/result order or the ARM64 register rule. Microsoft methods returning a record are indirect even under `Natural`, consistent with the actual Microsoft C++ ABI. Scalar method parameters keep their existing profile; aggregate method parameters still require a separate ABI proof. Windows ARM64 adds `inreg` to the C++ result pointer, selecting the Microsoft indirect-result register rule.

Actual native module paths require an explicit `msvc` target environment for the Microsoft policy; Windows GNU is not treated as proof. The public `Signature::classify` API takes an explicit ABI `Platform`, as before. A constructor alone does not imply an Itanium nontrivial copy/destructor return: this marker is rejected on the supported Itanium platforms rather than converting it into a different C++ property. The policy specifies the physical call interface; it does not invent C++ destructor calls or exception cleanup.

The retained historical signature output came from an independently authored header-free probe and trusted installed Clang 22.1.1, targeting Windows x64, Windows ARM64 and Linux x64. The full old LLVM IR files were lost; this recovery preserves the source and printed signature output, without claiming fresh Clang execution or old packet hash equality. Windows constructor-only results are indirect; Linux constructor-only results are direct. Windows methods place `sret` after `this`; Linux nontrivial copy/destructor methods place it first. No object, library, linker or executable was produced.

The mapping is supported by [Microsoft's x64 return-value rules](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170), [LLVM 22.1.1's Microsoft C++ classifier](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.1/clang/lib/CodeGen/MicrosoftCXXABI.cpp) and the distinct [Itanium nontrivial-return rules](https://itanium-cxx-abi.github.io/cxx-abi/abi.html#non-trivial-return-values).

## How to change it

Change `jai-types/src/foreign_return.rs` and the registry validation together. Preserve the enum in every source or canonical signature copy; new constructors need `Natural` only when they are independently synthesized without a foreign result contract. Keep module identity, generic callback matching, replay and reflection materialization paired with any new policy.

Modify `jai-codegen/src/cpp_methods.rs` for checked C++ result rules and `abi.rs` for physical carriers/attributes. `foreign.rs` must keep definition recovery, result stores and direct/indirect marshaling on the same physical parameter map. Actual target-environment admission is checked by foreign declarations and indirect native calls. A new C++ result policy needs actual target ABI evidence, including method receiver ordering and indirect calls.

The draft regressions cover canonical identity/invalid policies/reflection, source callback identity, both Microsoft target classifiers, direct and indirect calls, definition parameter recovery and unsupported Itanium/GNU combinations. They need the centrally serialized compiler gate before any readiness claim.

## Configuration

The source directive selects `CppNonPod`; no environment variable changes it. Native target selection supplies the actual LLVM triple and data layout. Microsoft target admission requires a Windows triple with an explicit `msvc` environment. The pinned Rust toolchain remains `nightly-2026-08-29`; this packet runs no Cargo build.

## Dependencies

This feature uses `jai-types`, `jai-modules`, `jai-sema`, `jai-ir` reflection validation and the LLVM 22 backend through `inkwell`. The lexer/parser companion is mandatory. The target evidence uses installed Clang 22.1.1, official ABI documentation and independently authored C++ source; it does not use supplied reference compiler objects or libraries.
