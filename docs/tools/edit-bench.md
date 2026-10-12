# Edit benchmark

`crates/jai-language-server/examples/edit_bench.rs` measures how long `jailsp` takes to answer after an edit inside a procedure body: the typing loop, where each keystroke costs a compile of the whole program.

```sh
cargo run --release -p jai-language-server --example edit_bench -- [--edits N] [--stdlib DIR] DIR FILE LINE
```

## How it works

- `DIR` is opened as a workspace folder in a `Session` and `FILE` (under it) as the one open document, as an editor would. The stdlib defaults to the repo's `stdlib/`.
- Each round inserts `bench_edit := 1;` (indented like the line) before 1-based `LINE`, or removes the one inserted the round before, with `Session::change`.
- After each change it asks for diagnostics and hovers the first character of the line, which is what an editor asks for after a keystroke.
- It prints each round's milliseconds and how many compiles it started (`Session::compile_counts`), then the mean.

```
open: 866 ms, 1 compiles, 15 diagnostics, hover true
edit 0: 839 ms, 1 compiles, 16 diagnostics, hover true
...
mean edit: 834 ms
```

A body edit should start exactly one compile. More points at a cache that is not reused; a changed diagnostic count between runs of the same input points at a behaviour change, not only a speed one.

With `JAIC_PROFILE=1` the interpreter's profile of all compiles (instructions per procedure) goes to stderr at the end. `--edits 0` profiles the opening compile alone. Under `/usr/bin/time -l` (macOS) or `-v` (Linux) it also gives the session's peak memory.

Good input: Focus (`corpus/upstream/focus-editor--focus`, `src/editors.jai` line 61), a large program built through a metaprogram with a message loop.

## How to change it

- `statement` is the inserted text; `answer` is what is asked after each change.
- Keep the session single-file: opening more documents measures their requests too.

## Configuration

- `--edits N`: rounds (default 6).
- `--stdlib DIR`: the stdlib to import from.
- `JAIC_PROFILE=1`: interpreter profile on stderr.

## Dependencies

- `jai_language_server::Session` (`change`, `diagnostics`, `hover`, `compile_counts`).
- `jaic::sema::NativeFs` and `Options::host()` for the environment, `jaic::interp::profile` for the profile.
