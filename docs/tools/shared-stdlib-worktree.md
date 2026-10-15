# Shared standard-library worktree

## What it is

All active clean standard-library implementers converge on one independent combined checkout. This replaces stale partial source overlays with shared production source while preserving clean-room isolation.

## How it works

Workers checkpoint their original owned changes before moving. The integration owner reconciles those commits into this tree. Original portable, ASN.1/Socket, crypto/APK, bindings and generator ownership stays explicit; workers inspect shared dependencies rather than copy old whole stdlib trees. Only integration stages and commits changes or runs broad mutation-prone suites. Implementers edit assigned files and run scoped tests with separate outputs.

## How to change it

Agree file ownership before overlapping edits. Never reset, clean or switch the shared checkout while peers work. Keep fixture generation and native binary/PDB/CIE output in worker-specific scratch directories, with immutable input hashes checked. Coordinator retains old checkouts until all dirty work is preserved and transfer verified.

## Configuration

The transition and worker destinations are recorded in coordinator state.json. The branch is `codex/stdlib-shared`; CARGO_TARGET_DIR stays separate under each worker's T7 namespace. Release 0.18.0 publication remains held.

## Dependencies

Clean producer checkpoints, canonical library/compiler contracts, independent compiler source, integration tests and coordinator-only full original corpus/reference oracles. No original/reference/vendor implementation or quarantine transcripts become accessible to clean implementers through this transition.
