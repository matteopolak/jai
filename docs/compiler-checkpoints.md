# Compiler checkpoints

## What it is

Regular Git checkpoints preserve the independent compiler implementation while parallel feature work continues. A checkpoint records its verification scope; it does not imply complete Jai compatibility.

## How it works

The integration owner coordinates shared AST, IR and scheduler changes and serializes builds using the main Cargo target. Feature owners can prepare and test independent component changes concurrently. Before a checkpoint, finish paired consumers, check the workspace and format changed Rust files, then briefly hold shared mutations while staging the reviewed sources.

Commit implementation, authored fixtures, source-free manifests and developer documentation. Keep supplied reference inputs, upstream checkouts, generated objects, executables, benchmark captures and compiler crash reports outside Git. A separate frozen compiler executable allows acceptance sweeps to continue while later changes are built.

Report executable hashes and actual test outcomes. Hashes collected from the working tree during a sweep describe that observation; they are not proof of which sources produced an earlier executable. Preserve failing compatibility results alongside successful feature tests.

The resumed 2026-10-02 checkpoint is a compilable work in progress. Workspace checking and Rustfmt passed under a shared write freeze. Focused source gates passed for anonymous procedures (10), operators (54), global initializers (2), headers (7), placeholders (11) and source `#run` (25). Newly integrated native gates passed 21 tests covering canonical storage, type paths, anonymous procedures, static byte views and layouts. The current full VM run passed 529 of 542 tests; 13 failures in the evolving retention and process work remain under repair. Three new callback-contract cases were repaired after their first failed run and still need a rerun. The earlier frozen executable's 189 focused passes belong to that earlier build, rather than every later working-tree change.

## How to change it

Coordinate shared interface changes with the integration owner. Split later checkpoints by coherent feature batches and include the tests and documentation needed to understand each change. Push normally to the configured repository; avoid force pushes or resetting another owner's work.

## Configuration

`.gitignore` excludes `reference/`, `corpus/upstream/`, `target/`, `artifacts/` and Rust compiler crash reports. The Cargo dependency policy, pinned toolchain and LLVM configuration apply to checkpoint validation. The Git remote selects the push destination.

## Dependencies

Git, the compiler workspace, the integration test suite, Rustfmt, the corpus tools and the independently installed LLVM toolchain. Hosted CI verifies the public checkout separately from local source acceptance.
