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

## How to change it

Coordinate shared interface changes with the integration owner. Split later checkpoints by coherent feature batches and include the tests and documentation needed to understand each change. Push normally to the configured repository; avoid force pushes or resetting another owner's work.

## Configuration

`.gitignore` excludes `reference/`, `corpus/upstream/`, `target/`, `artifacts/` and Rust compiler crash reports. The Cargo dependency policy, pinned toolchain and LLVM configuration apply to checkpoint validation. The Git remote selects the push destination.

## Dependencies

Git, the compiler workspace, the integration test suite, Rustfmt, the corpus tools and the independently installed LLVM toolchain. Hosted CI verifies the public checkout separately from local source acceptance.
