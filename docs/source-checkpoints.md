# Persistent source checkpoints

## What it is

Source checkpoints preserve the independently authored workspace during integration and recovery. They are local source copies, not evidence that a compiler or feature passes its tests.

## How it works

Run `python3 tools/checkpoint_sources.py before-integration` to create a new directory under `artifacts/source-checkpoints/`. The script includes tracked and non-ignored untracked files, records deletions, and preserves symlinks without following them. It checks source hashes and the inventory again before writing the manifest; concurrent edits cause capture to fail.

The reference folder, upstream corpus, Git internals, build output, and existing artifacts are excluded. Nothing is executed or uploaded. A failed capture directory has no sealed manifest and must not be treated as a valid checkpoint.

## How to change it

Change exclusions in `tools/checkpoint_sources.py` when source ownership changes. Keep supplied reference bytes and generated build output outside these checkpoints. Integration candidates and agent patches should live in persistent, ignored `artifacts/agent-packets/` directories rather than relying on temporary storage. Keep each candidate's source hashes, base commit, and actual test results together.

## Configuration

The required argument is a fresh directory name; existing destinations are refused. `artifacts/` is ignored by Git. Coordinate a short source-edit pause for a whole-workspace capture. Capture does not establish an atomic transaction across independently changing files or verify build inputs outside the repository.

## Dependencies

Python's standard library and Git. Compiler checks still use the pinned Rust toolchain and the configured LLVM installation.
