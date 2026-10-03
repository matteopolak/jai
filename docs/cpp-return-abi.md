# C++ record return ABI

## What it is

`#cpp_return_type_is_non_pod` preserves the Microsoft C++ record-return policy in a callable signature. This recovered parser companion is paired with canonical type and LLVM result classification. Its source has been rebased and formatted; the regression tests and combined compiler gate remain required.

## How it works

A foreign declaration can request the policy explicitly:

```jai
make_pair :: () -> Pair #cpp_return_type_is_non_pod #foreign native;
Callback :: #type () -> Pair #c_call #cpp_return_type_is_non_pod;
```

The lexical boundary converts the directive spelling into a token enum. The shared procedure modifier parser produces `ForeignReturnAbi::CppNonPod`; ordinary headers carry `Natural`. Named definitions, anonymous definitions, foreign prototypes and callable type annotations retain the same enum. A second marker fails at that marker rather than silently overriding it. The marker also prevents an otherwise unbound foreign declaration from entering the legacy Jai source-contract bridge.

The paired implementation must preserve this policy in canonical procedure types, source specialization, reflection, replay and both direct and indirect LLVM calls. Accepting the syntax alone is insufficient: an indirect callback needs the same physical result parameter and argument ordering as its declaration.

Microsoft allows only certain user-defined results in return registers. Other results use caller-owned storage passed as an implicit parameter. C++ method return classification also depends on the receiver. See [Microsoft's x64 calling convention](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170) and [LLVM 22's Microsoft C++ classifier](https://github.com/llvm/llvm-project/blob/llvmorg-22.1.1/clang/lib/CodeGen/MicrosoftCXXABI.cpp). A constructor alone does not establish an Itanium nontrivial-for-calls return policy; the [Itanium ABI](https://itanium-cxx-abi.github.io/cxx-abi/abi.html) treats that separately. The explicit marker is a Microsoft policy and must not be used to guess another platform's return carrier.

## How to change it

The directive token is in `jai-lexer/src/tokens.rs`. Shared modifiers and callable type parsing are in `jai-syntax/src/procedures.rs`; named and anonymous source headers use `source_procedure_headers.rs`. Extend the canonical `ForeignReturnAbi` enum and its actual target classifier together. Preserve the policy when copying a checked signature instead of replacing it with `Natural`.

The authored syntax regressions cover foreign and indirect signatures, named and anonymous source headers, and duplicate-marker location. They remain unrun. The matching backend must verify physical receiver/result argument mapping and genuine native behavior before this feature is marked complete.

## Configuration

The directive selects the return policy. Target selection determines the physical ABI; unsupported combinations must produce a target diagnostic. No environment variable enables parser acceptance, and ordinary result classification remains the default when the directive is absent.

## Dependencies

The feature uses `jai-lexer`, `jai-syntax`, canonical `jai-types` procedure signatures, source preparation and reflection, and the LLVM library backend. The private syntax packet adds no package dependency. Its matching type/backend packet supplies `ForeignReturnAbi` and remains a required integration dependency.
