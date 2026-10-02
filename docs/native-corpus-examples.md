# Reviewed native corpus examples

## What it is

`tools/check_native_examples.py` verifies explicitly reviewed original pinned programs through our compiler's six stages, including exact native behavior. It records source, Preload, compiler and generated executable fingerprints without copying original source into reports.

## How it works

The runner validates `corpus/native-safe-examples.json` against the pinned inventory and requires an explicit source review and exact exit/stdout/stderr expectations. Its narrow standalone profile rejects source directives and Compiler API references. It selects the actual unchanged reference Preload, disables Runtime_Support and uses the ordinary application entrypoint check.

After LLVM emission, every generated call must target a function defined in that same IR or an LLVM intrinsic; indirect and external calls block linking. Source and Preload hashes must remain unchanged before build and execution. Builds use our CLI and trusted `/usr/bin/clang`, with fresh output enforced by the corpus harness. Execution requires a regular nonsymlink executable whose hash matches build evidence before and after running. Temporary generated files are removed afterward. This is bounded host execution of reviewed own output, not VM isolation or acceptance of original native tooling.

The immutable compiler `43b1705dd388ff63d71089ea0d542ac713da9e2bf547b86908d94d81ea66be64` passes all six stages for unchanged `Ivo-Balbaert/The_Way_to_Jai:examples/30/main5.jai`. Its review covers only local pointer/address-of declarations; runtime exits zero with empty stdout and stderr. The build and runtime executable SHA is `c16183af86345106e686833c9505083dfc988e1b8ed01181abc353ce338d731f`. Local evidence is `artifacts/native-corpus-43b1705d.json`. One example does not establish complete project, platform SDK or Runtime_Support acceptance.

```sh
python3 tools/check_native_examples.py \
  --compiler target/corpus-snapshots/43b1705dd388ff63d71089ea0d542ac713da9e2bf547b86908d94d81ea66be64/jai-rs \
  --report artifacts/native-corpus-43b1705d.json
python3 -m unittest discover -s tools -p test_native_examples.py
```

## How to change it

Review an original pinned source before adding its exact ID/hash and behavior expectations to the manifest. Review new imports, directives, metaprograms, native dependencies and generated calls rather than relaxing the profile to bypass a failure. Extend `reviewed_cases`, `audit_calls` and their regression tests when the review model changes. Keep failed stages visible and preserve compiler snapshots so subsequent source changes cannot alter measured evidence.

## Configuration

`--compiler` requires our repository `target/.../jai-rs`; `--manifest` selects the review manifest, `--report` selects local JSON output and `--timeout` bounds each compiler/runtime process. The runner explicitly selects Preload search and disables Runtime_Support. Reports cannot overwrite reference, corpus or vendor sources. No original source is uploaded or original compiler, native library or native object executed.

## Dependencies

Python's standard library, our integrated Rust CLI, trusted `/usr/bin/clang`, pinned read-only sources and the actual reference Preload. It reuses inventory, artifact freshness and staged evidence from `check_corpus.py`, and executable provenance/runtime assertions from `check_feature_matrix.py`. See [staged corpus acceptance](corpus-acceptance.md).
