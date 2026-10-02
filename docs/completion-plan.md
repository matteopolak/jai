# Completion and acceptance plan

## What it is

The active goal is a complete independent Jai implementation with verified standard-library, reference-example and recent-project compatibility. Passing the current scalar tests does not complete that goal.

## How it works

Track supported source semantics and actual builds separately. The current frontend, scalar constant evaluator and LLVM backend are foundations for the following remaining work:

| Component | Current coverage | Remaining acceptance |
| --- | --- | --- |
| Values and expressions | All integer widths, Boolean expressions, casts, constants, scalar `ifx` | Floating point, strings, composite values, block/implicit `ifx`, remaining operators |
| Declarations and calls | Scalar procedures, globals, local scopes, constant defaults, named arguments | Runtime defaults, multiple/named results, overloads, procedure values, nested declarations |
| Control flow | Conditions, scalar ranges, named exits, deferred cleanup, scalar cases/through | Expression/aggregate cases, array/custom iteration, removal, remaining modifiers |
| Types | Scalar typed IR | Records, enums, unions, arrays, pointers, layouts, recursive types, reflection |
| Compilation units | Recursive `#load` with mapped diagnostics | Imports, modules, scopes, parameters, AST-level source IDs |
| Polymorphism | Not implemented | Generic procedures/types, restrictions, specialization, operators and auto-baking |
| Compile-time engine | Pure scalar constants | Procedure VM, `#run`, insertion, code values, hooks, workspaces and Compiler API |
| Native backend | Verified LLVM scalar modules and trusted Clang | Complete ABI, object emission, targets, linking, debug info and optimization |
| Runtime/library | Original lexer inputs, one vendored probe bootstrap | Compile actual runtime and all library modules through their entrypoints |
| Corpus | 702 local and 1,440 upstream lexical checks | Actual project builds, negative cases, runtime behavior and documented target dependencies |
| Targets | ARM64 macOS scalar execution | Linux, Windows, iOS, Android and reference wasm64 validation |

For each meaningful feature, add rejection checks, generated behavior tests, developer docs and relevant allocation/time benchmarks. Run hosted checks on published compiler checkpoints. Keep unavailable SDK/hardware cases explicit rather than recording passes.

Completion requires successful standard-library and real example/project builds, demonstrated metaprogramming and compiler API behavior, appropriate native/runtime tests, and resolved target acceptance. Support files need not have standalone `main` procedures, and deliberately failing examples need their intended diagnostics. See [reference compatibility](reference-compatibility.md).

## How to change it

Update the coverage table and corresponding subsystem docs as behavior becomes implemented and verified. Preserve evidence links and distinguish Rust-generated execution from original reference experiments. Do not mark the active goal complete while required work remains.

## Configuration

Pinned source corpus revisions, platform SDKs, module/build parameters, Cargo's dependency-age policy and native tool paths affect acceptance. Original binary execution remains confined to inspected, authorized hosted experiments; original source upload authorization currently covers the single vendored Preload input.

## Dependencies

All compiler workspace crates, corpus manifests, developer docs, correctness tests, Divan benchmarks and hosted compiler checks. Some eventual integration tests require platform SDKs or graphics hardware.
