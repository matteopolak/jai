# Completion and acceptance plan

## What it is

The active goal is a complete independent Jai implementation with verified standard-library, reference-example and recent-project compatibility. Passing focused feature tests does not complete that goal.

## How it works

Track supported source semantics and actual builds separately. The current bulk implementation has parallel owners for each major subsystem and all seven requested projects; see [parallel workstreams](parallel-workstreams.md). Shared interfaces are integrated in coordinated rounds so independent tests can run against a coherent compiler.

| Component | Current implementation evidence | Remaining acceptance |
| --- | --- | --- |
| Values and expressions | Integers/floats, aggregates, sequences, pointers and `Any` boxing have source/VM/native proofs | Remaining operators, casts, universal values and all corpus forms |
| Declarations and calls | Procedure values/context, local namespaces, multiple results, source `#must` obligations and generic procedure/record specialization tested | Record-method integration, modifiers, complete restrictions and overload behavior |
| Control flow | Conditions, ranges, exits, cleanup, cases; custom iteration and array removal have bounded source/VM/native acceptance | Full original iteration corpus parity, complete aggregate cases and remaining modifiers |
| Types | Shared nominal/structural registry, custom layouts, checked IR, `Any` and reflection; static-layout native proofs | Full source reflection, conversions and remaining type/member forms |
| Compilation units | Scoped imports, source overlays, scalar/enum parameters, builtin/source-nominal type parameters and bound interfaces have graph/source/VM fixtures; target facts and transactional workspace scheduler tested | Native parameter acceptance, advanced generic/inherited/modified interfaces, actual CLI scheduled artifacts and advanced scope forms |
| Compile-time engine | Checked VM with context, memory, transactions and replay; source `#run`, reflection and code insertion tested | Complete expansion/modification, compiler API schema and early generated declarations |
| Native backend | LLVM object/optimization pipeline, system libraries, context, runtime memory/CAS intrinsics and static relocations tested | Complete ABI/targets, richer debug information and all source integration |
| Runtime/library | Authored compiler prelude has complete schema, intrinsic and generated-source replay tests; genuine-source paired checks preserve the baseline's outcomes | Compile actual runtime and every library module through appropriate entrypoints |
| Corpus | Recorded integrated CLI snapshot: 1,759/2,142 parse passes, 100 support-file check passes and one intended rejection with actual Preload and Runtime Support disabled; all lex passes; 36 positive native feature contracts and 10 intended rejections pass on a separate earlier feature checkpoint | Remaining syntax, application-root checks, actual project builds and runtime behavior |
| Targets | Published scalar checks on ARM64 macOS and x86_64 Linux; additional host native fixtures | Hosted verification of the bulk implementation; Windows/mobile/wasm and platform dependencies |

These are working-tree milestones, not a claim that the full standard library or upstream projects compile. The recorded integrated snapshot (`b1b82044`) has one curated root parse failure, eleven check failures, and one intended rejection; no selected full project passes. Its library sweep parses 202 of 253 entrypoints and fixtures. With Preload enabled, 38 library/example entrypoints and six fixtures check; with Runtime Support also enabled, every parsed entry still fails checking. Neither sweep records a compiler panic. Reviewed original examples have separate native evidence. Parsing never establishes semantic or native acceptance. Reports retain compiler/source fingerprints in local `artifacts/`; see [corpus acceptance](corpus-acceptance.md).

The `b1b82044` executable has a verified immutable hash. Source input hashes observed during these sweeps describe the changing working tree, rather than a verified build manifest for that executable. Later anonymous-procedure, source-preparation, storage and prelude changes require a new executable checkpoint before their effects count toward these totals.

The required-result subsystem has located source rejection tests and generated VM/native fixtures for consumed results, indirect callbacks and optional multi-result discard effects; see [required procedure results](result-obligations.md). The integer [safety-check suite](safety-checks.md) verifies ten source/VM/native policies. Type/interface module parameter evidence currently includes eight graph tests and four semantic tests, with three VM programs returning 42; native and advanced interface acceptance remain separate gates. [Custom iteration](custom-iteration.md) has eighteen passing integration tests (sixteen valid execution cases and two invalid-source groups); [array iteration/removal](array-iteration-and-removal.md) has eleven (ten valid execution cases and one invalid-source group). These suites include generated VM/native programs and retain the documented source restrictions. Record methods remain under integration review.

For each meaningful feature, add rejection checks, generated behavior tests, developer docs and relevant allocation/time benchmarks. Run hosted checks on published compiler checkpoints. Keep unavailable SDK/hardware cases explicit rather than recording passes.

Completion requires successful standard-library and real example/project builds, demonstrated metaprogramming and compiler API behavior, appropriate native/runtime tests, and resolved target acceptance. Support files need not have standalone `main` procedures, and deliberately failing examples need their intended diagnostics. See [reference compatibility](reference-compatibility.md).

## How to change it

Update the coverage table and corresponding subsystem docs as behavior becomes implemented and verified. Preserve evidence links and distinguish Rust-generated execution from original reference experiments. Do not mark the active goal complete while required work remains.

## Configuration

Pinned source corpus revisions, platform SDKs, module/build parameters, Cargo's dependency-age policy and native tool paths affect acceptance. The former hosted developer-help probe and vendor input are retired. Original native binaries/libraries remain static inputs on the development host, and other original source uploads are not authorized. Public bootstrap tests use the independently authored compiler prelude.

## Dependencies

All compiler workspace crates, corpus manifests, developer docs, correctness tests, Divan benchmarks and hosted compiler checks. Some eventual integration tests require platform SDKs or graphics hardware.
