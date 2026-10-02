# Corpus stage reports

## What it is

`tools/summarize_acceptance.py` renders a source-free JSON record and Markdown stage table from existing measured acceptance reports. It reads reports and compiler bytes; it never runs a compiler, project script, native tool, or generated program.

## How it works

Each input must be a format-one measured report from the corpus, standard-library, feature-matrix, or reviewed native-example harness. Its compiler must exist at `target/corpus-snapshots/<sha256>/jai-rs` or `target/standard-library-snapshots/<sha256>/jai-rs`, and the actual bytes must match the recorded SHA-256. Mutable `target/debug` binaries, missing snapshots, and reported compiler drift are rejected. The input report and compiler fingerprints are rechecked before rendering completes.

The table keeps `lex`, `parse`, `check`, `codegen`, `build`, and `run` separate. Missing stages remain `not-run`. A successful parser does not establish a semantic check; a library check does not establish an application entrypoint or native build. Checking profiles have separate totals, and source bytes must match across profiles for the same case within a report. Totals are recomputed from individual records rather than copied from a report's headline counts.

Passed compiler stages require exit code zero. Passed output stages also require their artifact fingerprint. Runtime success may have a nonzero expected program exit, but it must refer to the exact artifact of a passed build. An expected source rejection requires ordinary compiler exit code one; crashes, signals, and unexpected successful acceptance stay distinct. The renderer preserves a harness's recorded diagnostic classification rather than rerunning that assertion. Reviewed negative intent and matched rejection stages are listed separately, so an unattempted negative cannot become a passed test. Upstream negative intent without a reviewed contract stays unreviewed.

Output retains case IDs, input/artifact hashes, stage statuses and exit codes, compiler metadata, and report hashes. It omits diagnostics, reasons, source/IR contents, source paths, dependency excerpts, commands, and environment values. A compiler's reported evidence kind remains visible; an isolated frontend adapter cannot establish later compiler or runtime stages. Independently observed current source-input fingerprints are not proof of which source bytes built that compiler. Different reports and compiler hashes remain separate rows.

```sh
python3 tools/summarize_acceptance.py \
  artifacts/corpus-a19b4808-bootstrap.json \
  artifacts/corpus-a19b4808-project-roots.json \
  artifacts/standard-library-a19b4808.json \
  artifacts/native-book-inlining-a19b4808.json \
  --json artifacts/corpus-stages-a19b4808.json \
  --markdown artifacts/corpus-stages-a19b4808.md

python3 -m unittest discover -s tools -p test_summarize_acceptance.py
```

These example inputs are local historical measurements. Running the renderer does not refresh them or establish acceptance of subsequent source changes. Reports without measured compiler records, including inventory-only scans, are rejected. Output is local; rendering does not upload or publish anything.

## How to change it

Extend `stage_evidence`, `row_summary`, and their hermetic tests when a measured evidence contract changes. Keep output fields explicitly selected: copying arbitrary report fields can include original source or environment data. Preserve the distinction between accepted source, intended rejection, failure, and unattempted work. Keep target and runtime authority in the existing runners; this renderer grants none.

Tests use inert authored byte fixtures for frozen snapshots and generated artifacts. They verify independent stage counts, negative intent, artifact identity, source-free output, and rejection of malformed or changing inputs without executing any fixture.

## Configuration

Pass one or more report paths and `--json`, `--markdown`, or both. Each input is bounded to 64 MiB. Output must use a `.md` or `.json` filename extension, differ from input reports, and stay outside protected reference, vendor, upstream-corpus, and Git input trees. There are no environment variables or compiler options.

## Dependencies

Python's standard library and the `Stage` / `Status` definitions from `tools/check_corpus.py`. Existing frozen compiler files are read for hashing only. See [staged corpus acceptance](corpus-acceptance.md), [corpus feature matrix](corpus-feature-matrix.md), and [reviewed native examples](native-corpus-examples.md) for the runners that produce measured evidence.
