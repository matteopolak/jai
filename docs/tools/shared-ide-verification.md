# Shared IDE verification

Owned compiler checkpoints47a2bfa7,94ddd821 and4dac97bb add strict redacted
audit progress and real definition targets for static filters, aggregate using
and named module arguments. Integration applies their narrow Rust/tool/independent
fixture deltas; it does not import producer library snapshots, coordinator inboxes
or original corpus results. Existing span-bound pending entity identities and
IDE-only recovery remain intact. Normal application compilation stays strict.

`cargo test --locked -p jai-language-server --all-targets` passes263 tests with
zero failures/ignores. `python3 -B -m unittest discover -s tools -p
test_ide_corpus_audit.py -v` passes5 metadata-only progress tests. Rustfmt and
workspace clippy with `-D warnings` pass. Synthetic VFS fixtures are unit evidence;
they do not substitute for the actual server and combined production library.

Build the real server with `cargo build --locked -p jai-language-server`. Run
`python3 -B tools/ide_native_smoke.py --server <own-build>/jailsp --stdlib
<immutable-production>/stdlib --source-id <exact-compiler-commit> --stdlib-id
6295584c --output <new-owned-directory>` for four independent protocol sessions.
The driver does not patch or copy the server source and does not execute its
Jai documents or exit calls. Native protocol acceptance is recorded separately.

The root original-corpus audit remains red, including observed crash/panic cases
being repaired by the compiler owner. Clean integration never reads original
vendor bodies or runs the original application corpus. Strict audit reports
retain incomplete contexts, unexecuted files, incorrect targets and identifier
gaps; zero local diagnostics alone cannot establish acceptance.
