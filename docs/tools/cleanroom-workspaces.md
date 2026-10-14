# Clean-room implementation workspaces

## What it is

`tools/prepare_cleanroom.py` creates an independent source snapshot and two Git worktrees for compiler and standard-library implementation. Its Git history contains only the sanitized baseline, so old library bodies cannot be recovered through Git commands.

## How it works

The snapshot first requires the API auditor's documentation checks to pass: inventoried types need shapes, code blocks must be complete, and explicit implementation-body markers are rejected. It then copies current tracked files and current specification pages. It excludes the previous standard library except `stdlib/Extensions`, the old root bootstrap directory, reference distributions, audit artifacts, and the source-scanning auditor. Deleted working-tree files remain deleted. It refuses source symlinks rather than allowing a link to expose files outside the snapshot.

Use a durable destination in the checkout's ignored artifacts directory:

```sh
python3 tools/prepare_cleanroom.py artifacts/cleanroom-workers \
  --roles compiler stdlib bindings numerics
```

The result includes `base` and the requested worktrees, a file-hash snapshot manifest, a macOS sandbox profile, and a private harness directory. The profile denies reads of the original source repository except the sanitized workspace subtree, original harness state and transcripts, previous implementation snapshots, other temporary artifacts, and the coordinator's snapshot manifest. It similarly permits writes only to the sanitized subtree within the original checkout. System tools and dependency caches remain accessible. A fresh implementation process must run under this profile with the private harness directory as its `CODEX_HOME`; a separate worktree alone does not enforce the boundary.

Keep worktrees, logs, local commits, and coordinator recovery records on durable storage. macOS clears `/private/tmp` during reboot, so temporary directories are unsuitable for the only copy of implementation work. The ignored artifacts directory survives a restart and remains excluded from commits. An external durable destination is also supported.

Validate isolation before starting implementation: reading the specs and compiler sources must succeed; reading the original checkout, prior library snapshots, and agent transcripts must fail. Start fresh processes without inherited conversation history, plugins, or user configuration. The isolated harness uses the existing local sign-in file, copied with private permissions; never commit or print that file. Delete the private harness directory after the implementation processes finish.

## How to change it

Extend the source exclusions when adding generated artifacts or other inputs that expose previous implementations. Extend the sandbox allowlist only for a required tool or dependency. Recheck denied paths after any profile change. Changes are reviewed and integrated back into the original repository by the coordinating agent; implementation worktrees never publish directly.

## Configuration

The positional destination must be new and either outside the source checkout or below its Git-ignored `artifacts/` directory. `--source` selects the source checkout. `--roles` selects the worktrees to create; it defaults to `compiler stdlib`. Implementer processes use the generated profile and an isolated `CODEX_HOME` and temporary directory. Model selection is specified explicitly when launching each process.

## Dependencies

Python 3, Git, and the coordinator's `tools/stdlib-api-audit/audit.py` are needed for preparation. Enforced local isolation currently uses macOS `sandbox-exec`. The implementation processes additionally need the configured model harness, Rust toolchain, and the project dependencies. Supplied reference binaries are never required.
