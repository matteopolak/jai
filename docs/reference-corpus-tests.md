# Reference corpus tests

## What it is

Three syntax integration tests inspect separately supplied reference and pinned upstream source files. They are opt-in; the normal syntax suite uses independently authored fixtures available in public checkouts.

## How it works

The `cast_dialects` integration test loads five original files at runtime and parses selected statement spans with this repository's lexer and parser. It executes no original compiler or native tool. Typed expectations distinguish accepted cast forms from the current unsupported macro-capture form.

The test stores paths, byte lengths and span ranges instead of embedding original source statements. Length and range checks detect some input changes; they are not cryptographic identity checks. A missing file or invalid span fails an explicitly requested run. The always-on cast unit tests remain in `jai-syntax`'s `casts` module. The opt-in `context-bindings` and `insertion-replacements` tests parse original context declarations and collection replacement forms; their authored tests remain enabled.

## How to change it

Add ordinary parser regressions as independently authored fixtures. Use the opt-in corpus test when original spelling matters. When changing the pinned source inventory, review its actual bytes and update statement spans, lengths and typed expectations together. Do not copy original source bodies into public tests or weaken parse assertions to hide unsupported syntax.

## Configuration

Provide `reference/` and `corpus/upstream/` at the repository root, using the pinned inputs described by the test cases. Run the source-only check explicitly:

```sh
cargo test -p jai-syntax --test cast_dialects -- --ignored
cargo test -p jai-syntax --test context-bindings -- --ignored
cargo test -p jai-syntax --test insertion-replacements -- --ignored
```

These files are absent from public CI. The test is ignored by default; `cargo test -p jai-syntax` still runs authored syntax coverage. This convention does not authorize execution of supplied binaries.

## Dependencies

The test uses `jai-source`, `jai-lexer`, `jai-syntax`, and read-only access to separately supplied source files. No VM, LLVM backend, network service or reference executable is involved.
