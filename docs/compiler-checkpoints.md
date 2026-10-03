# Compiler checkpoints

## What it is

Regular Git checkpoints preserve the independent compiler implementation while parallel feature work continues. A checkpoint records its verification scope; it does not imply complete Jai compatibility.

## How it works

The integration owner coordinates shared AST, IR and scheduler changes and serializes builds using the main Cargo target. Feature owners can prepare and test independent component changes concurrently. Before a checkpoint, finish paired consumers, check the workspace and format changed Rust files, then briefly hold shared mutations while staging the reviewed sources.

Commit implementation, authored fixtures, source-free manifests and developer documentation. Keep supplied reference inputs, upstream checkouts, generated objects, executables, benchmark captures and compiler crash reports outside Git. A separate frozen compiler executable allows acceptance sweeps to continue while later changes are built.

Report executable hashes and actual test outcomes. Hashes collected from the working tree during a sweep describe that observation; they are not proof of which sources produced an earlier executable. Preserve failing compatibility results alongside successful feature tests.

Checkpoint `11f4e0a` on 2026-10-02 is a compilable work in progress. Workspace checking and Rustfmt passed under a shared write freeze. Focused source gates passed for anonymous procedures (10), operators (54), global initializers (2), headers (7), placeholders (11) and source `#run` (25). Newly integrated native gates passed 21 tests covering canonical storage, type paths, anonymous procedures, static byte views and layouts. Its full VM run passed 529 of 542 tests, and three repaired callback-contract cases still awaited a rerun. The earlier frozen executable's 189 focused passes belong to that earlier build, rather than every later working-tree change.

Later integration gates passed all 551 VM tests and all 69 procedure-value VM/native tests. Cumulative publication-budget hooks then passed workspace checking but exposed eight failures in a 554-test VM run. After accounting for measured transaction-entry and validation costs while retaining the source-operation bounds, the repaired suite passed all 557 tests. This validates that budget batch; broader source-controller registration remains pending.

The separate pushed checkpoints `77acb21` and `d13019d` remove the vendored bootstrap and add prepared reflection-policy transactions. Bootstrap verification covered 50 focused Rust checks, an authored VM/native witness, and identical original/authored prelude outcomes across 669 genuine sources. An immutable 28-input actual-source type-component snapshot passed 114 tests and strict all-targets Clippy for the prepared transaction API. Complete source reflection journals, standard-library acceptance and project builds remain pending.

Public CI for `d13019d` stopped at oversized typed error contexts in IR Clippy. Checkpoint `47dc066` boxes only the mismatch policies, with ten focused IR tests and strict IR Clippy passing locally. Checkpoint `0104568` binds named Preload imports to the selected bootstrap and adds the authored library facade; all 16 module/bootstrap gates pass, including qualified declaration identity through the real physical prelude. Hosted verification of these fixes is separate from their local gates.

Public CI for `17812fc` then stopped at three groups of unused VM test helpers. The helpers now compile only under `cfg(test)`; production retains its allocator implementation and precharged fork path. The current live VM suite passes 558 tests, and strict workspace Clippy passes the VM before reaching pending semantic producers. These are local integration results, not a claim that the public checkout's full matrix passes.

Checkpoint `72a9354` retains actual import bindings when a provider suspends discovery. Five new module regressions and the existing import-order regression pass. Namespace and anonymous type-alias execution tests remain separate semantic integration gates.

The subsequent live source-controller batch passes 29 tests for retained `Code`, global initializers, header and initial-type prerequisites, source insertion and per-run prefix checkpoints. All nine `using` source tests pass, including namespace and anonymous aliases imported from a suspended provider. Five driver tests cover repeated source rebuilds, pending continuation cancellation, late failure rollback and handled child failures. These results belong to the live batch and do not update the older frozen CLI corpus counts.

Dependent baked values are now rechecked after a modifier changes their formal type. The original seven record-modifier tests and a narrowing rejection pass. Two additional distinct-type witnesses remain pending because canonical typed-constant preparation fails before the modifier runs. Allocator source tests pass six of seven; the independently authored default allocator's numeric pointer ownership sentinel requires an opaque VM pointer representation without allocation authority. Keep unresolved behavior explicit until its actual source gate passes.

An additional prefix regression now passes with the original omitted `bool` argument in both `#run read()` and an ordinary runtime call. The source stage waits for the real declared default before producing its checkpoint, and the VM returns 42. All five prefix tests pass; earlier lifecycle fixtures with explicit arguments remain separate coverage.

Public CI for `e072f77` stops at semantic Clippy diagnostics. The cleanup replaces singleton cloned slices, removes an unnecessary reference conversion and orders an existing trait implementation before its test module. Genuine production producers must be registered or removed according to their actual consumers; lint allowances do not establish feature readiness. Strict hosted verification remains separate from the passing source tests.

A fresh owned CLI snapshot, `017353c4`, retains 919 authored source inputs and verifies 10,438 captured inputs before and after its successful build. Its immutable executable and receipt live under `artifacts/integration-checkpoints/source-verified-20261002/`. The full source sweep parses 1,784 of 2,142 files and checks 101 support files with reference Preload enabled and Runtime Support disabled. Its authored-library sweep parses 370 of 390 files and checks 27 of 128 module entrypoints. All source and family-report hashes remain unchanged during that library sweep; these results establish source checks, not native library or project acceptance.

The next live language batch passes 72 focused tests: eight opaque-pointer VM cases, two scalar publication cases, nine allocator source cases, four caller-return syntax cases, nineteen caller-return source cases, twenty-seven caller-location cases, and three native fixture groups. The real default allocator ownership-ledger case now passes with numeric pointers represented as opaque bits; those bits grant no allocation or code authority. Native fixture groups use trusted LLVM at `-O0` and `-O2`. The closing workspace all-targets check passes, with 1,776 source/configuration inputs unchanged across the recorded main-tree gates. Two initial test API mistakes were corrected without weakening assertions. These results do not update the older frozen CLI's corpus counts or establish complete library/project builds.

## How to change it

Coordinate shared interface changes with the integration owner. Split later checkpoints by coherent feature batches and include the tests and documentation needed to understand each change. Push normally to the configured repository; avoid force pushes or resetting another owner's work.

## Configuration

`.gitignore` excludes `reference/`, `corpus/upstream/`, `target/`, `artifacts/` and Rust compiler crash reports. The Cargo dependency policy, pinned toolchain and LLVM configuration apply to checkpoint validation. The Git remote selects the push destination.

## Dependencies

Git, the compiler workspace, the integration test suite, Rustfmt, the corpus tools and the independently installed LLVM toolchain. Hosted CI verifies the public checkout separately from local source acceptance.
