# Parallel implementation and acceptance

## What it is

The compiler rewrite is divided into implementation, review and acceptance lanes. An assigned lane means someone owns the remaining work; it does not mean the feature or project already passes.

## How it works

After the interruption, the previous agent sessions were no longer active. The resumed implementation has fresh owners for integration, callback contracts, source preparation, anonymous procedures, compiler-only Code, reflection and compiler intrinsics, native runtime information, constant slices, byte views, record storage and VM initialization, frontend literals, placeholders and modules, generic partial application, process execution, scalar domains, caller exports, project acceptance, benchmarks and targets, the independent prelude, and the scripting runtime. An architecture reviewer checks these changes alongside implementation. Dedicated child owners prepare the Code VM adapter and slice-memory certification.

Integration serializes the shared build cache and interface activation. The parent owns broad frozen-compiler sweeps and [regular Git checkpoints](compiler-checkpoints.md). The assignments below also retain the earlier subsystem coverage map; they are not evidence that interrupted sessions remain alive.

The 2026-10-02 coordination checkpoint assigns all sixteen groups in the [project requirements inventory](project-requirements.md). Finished feature owners move onto full library or application acceptance instead of leaving those gates uncovered.

| Work | Owners |
| --- | --- |
| Declaration phases, shared integration and final acceptance | Parent |
| Parser and lexer coverage | Frontend; short lambdas |
| Overloads, generics, modifiers and record methods | Polymorphism; generic records; local declarations; procedure constants |
| Callback contracts, code expansion and reflection | Required results; reflection; source run |
| Conditional discovery and module instances | Compile-time conditions; compilation units; parent |
| Runtime types, checked IR and correctness review | Type core; semantic scope review |
| Compile-time memory and resumable execution | VM; byte memory; type core |
| Stallable recipes, compiler waits and workspace lifecycle | Driver integration; VM; compiler intrinsics; source run |
| Discarded arguments and retained declaration metadata | Frontend; reflection; procedure constants; Preload integration |
| Runtime intrinsics and virtual allocation | Runtime intrinsics; VM |
| Host files and processes | Compile-time I/O; OS acceptance |
| Native ABI, libraries, context globals and dependencies | Context backend; native target; procedure calls; driver CLI |
| Execution-phase branches and SIMD | Float pipeline; LLVM types |
| Aggregate and pointer debug information | Native debug; source provenance |
| Broad reference and feature acceptance | Parent; corpus features; OS library acceptance |
| Performance and allocation baselines | Benchmark integration |
| Target compatibility | Cross-target backend integration |
| Formatting, strict linting and mechanical cleanup | Semantic scope review; each feature owner; parent |

Full application coverage has separate owners:

| Project | Acceptance lane |
| --- | --- |
| `focus-editor/focus` | Safety and application integration |
| `rluba/jaison` | Safety and application integration |
| `SogoCZE/Jails` | Inline types and application integration |
| `Ivo-Balbaert/The_Way_to_Jai` | Inline types and application integration |
| `ostef/Vk-Engine` | Procedure calls and graphics integration |
| `roeyb1/sgpu` | Procedure calls and graphics integration |
| `withlang-dev/open-jai` | Runtime intrinsics and standard-library integration |

Basic/Any, collections and OS module behavior also have dedicated library lanes. Project owners route shared language failures to the feature owner and implement independent gaps while that repair proceeds.

Agents edit separate helpers and tests whenever possible. Shared AST, IR and scheduler changes require a short coordinated adapter window: the owner updates every consumer and restores the workspace compile gate. These windows serialize interface changes, while independent implementation and tests continue. Passing an isolated helper never substitutes for integrating it into the actual compiler.

The latest live assignment audit found several completed agents with outstanding integration boundaries. Those owners have been restarted on the remaining work: Any and pointers own opaque procedure-cell views; inline types and LLVM own promoted literal capture; runtime intrinsics own OpenJai integration; compile-time I/O and OS integration own genuine File, Process, Thread and async behavior; driver CLI owns full command acceptance and CI; native target and context backend own debug and target ABI checks. Compile-time conditions, float/SIMD, corpus feature triage, type-core review and semantic scope review have also been restarted. The parent owns immutable compiler snapshots, broad corpus and standard-library sweeps, and final integration.

Run flags, declaration-style `using`, record `#this`, optional baked formals and type restrictions have passed their feature checkpoints. The current shared window integrates procedure-owned expression bindings into semantics, LLVM and the ordinary/resumable VM. Storage bitcasts follow that window; native pointer constants and external data have separate coordinated producers. Record placement can prepare additive layout metadata independently while sparse writes and storage-only VM snapshots await their joint integration.

The latest assignment refresh moved completed owners onto local generic operators, imported overloads, unsigned indexing, graphics entry syntax, runtime-info provider integration, public CI and fresh corpus acceptance. Original source evidence explicitly rejects runtime closures, so the lambda lane preserves that diagnostic and implements supported block expressions and static captures. Waiting agents prepare independent helpers, source fixtures and documentation rather than launching duplicate broad builds. Source-contract prototypes retain Jai calling conventions and cannot supply an executable provider merely by declaring a symbol. Reflection, type core and compiler intrinsics jointly own the remaining real runtime type-information table and external-data bridge. The earlier architecture and bulk review agents remain unavailable and are not counted as active reviewers.

The immutable `a19b4808` compiler checkpoint and the independent 107-case benchmark capture have completed their sweeps. Fresh corpus triage prioritizes the baked-operator declaration in unchanged `Basic/Int128.jai` that blocks 510 checks, and the dynamic `context.allocator` parameter default in newer OpenJai `Basic` that blocks 336. The newer parser gate passes all original Int128/Thread cases; that result does not update the historical broad corpus counts.

Driver integration currently holds a brief production-registration freeze through runtime-default and short-lambda execution. Previously saved helper consumers must close coherently before those gates retry; private implementation and independent tests continue. The next coordinated schemas are allocator projection plus target-aware weak/strong pointer constants, then caller references. Literals, anonymous procedures, source placement, implicit conditionals, case ordering, raw-byte parameters and placeholder syntax follow in reviewed batches. Each batch updates all consumers and restores the shared compile gate before the next one opens.

[Independent component checks](parallel-component-checks.md) have verified real frozen module sources separately from the main cache. Private modified component workspaces also test pending raw-byte parameters, typed-literal syntax, implicit conditionals and canonical LLVM record padding; their manifests distinguish prototype changes from live source. Full-workspace and project acceptance still require integrated source tests. The parent has added same-arena atomic reflection-policy transactions with distinct staged changes and sealed commit receipts. Reflection and compiler-intrinsic owners still need to connect those receipts to the actual compiler journal and descriptor revision service.

Compiler-only `Code` results have separate checked-plan, retained-VM-continuation, source-journal and reflection-capture owners. The controller must keep one effect journal across native leaves and code returns; ordinary runtime values and ABI signatures do not acquire a fake `Code` representation. Reflection constant storage additionally has a dedicated checked byte-view proof owner. Ordinary `#bake_arguments` partial application has its own procedure-value lane, beyond the iterator macro preparation.

An owner can be temporarily interrupted by model capacity or wait for another interface. Check live agent state before reporting active work, restart interrupted owners, and give waiting owners independent implementation or acceptance tasks. Resumable execution must preserve the actual VM continuation and transactional state; replaying a recipe or inventing a completed child workspace does not satisfy that lane.

## How to change it

Reassign a finished owner to a remaining acceptance gap and update this table. Keep the [completion plan](completion-plan.md), corpus reports and feature docs separate from task assignments. Record compiler hashes for broad acceptance runs, and rerun integration after shared interfaces change.

## Configuration

Agents share the same working tree and Cargo target directory. Use narrow file ownership and coordinate mutations; do not reset another lane's changes. Tests use the pinned Rust toolchain and LLVM setup described in [dependencies](dependency-policy.md) and [LLVM setup](llvm-backend.md).

Original reference binaries and native libraries remain static inputs on the development host. The former vendor Preload exception is retired; current public bootstrap sources are independently authored. Other original source uploads are not authorized.

## Dependencies

Compiler workspace crates, the live agent assignments, source requirement and acceptance manifests, trusted Rust/LLVM toolchains, and platform-specific SDKs for actual application builds.
