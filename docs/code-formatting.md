# Code formatting

## What it is

The repository uses the pinned nightly rustfmt and a shared `rustfmt.toml` to keep Rust code readable. Definitions are separated by blank lines, and compact item bodies, struct literals, and conditional blocks are expanded.

## How it works

Rustfmt reads the root configuration automatically. The existing CI formatting check rejects deviations. Format the workspace with `cargo fmt --all`, then check it with `cargo fmt --all -- --check`.

Rustfmt inserts spacing between top-level items. It does not insert every desired blank line between `impl` methods, decide where a function changes logical steps, or identify conceptual field groups. Add those blank lines deliberately during implementation and review; up to two consecutive blank lines are preserved.

## How to change it

Change `rustfmt.toml`, inspect representative formatted code, and coordinate a formatting pass after active integration work is frozen. Keep formatting changes separate from behavior changes so reviews and recorded build inputs remain easy to compare.

Run rustfmt separately on Rust files outside the workspace, such as the standalone fuzz package. Use the same root configuration via `--config-path` when formatting temporary candidates outside the repository.

## Configuration

`rust-toolchain.toml` pins the formatter. The shared configuration sets a 100-column width, Unix line endings, at least one blank line between items, and expanded compact blocks. Its item-spacing options require nightly rustfmt.

## Dependencies

This policy depends on the Rust toolchain's `rustfmt` component and the formatting check in `.github/workflows/ci.yml`.
