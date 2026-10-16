# Portable-data public-context lint

Windows 940 MSVC job 117173045723 rejected the portable-data runner's direct
private-module lint roots. The runner now checks library sources through a real
program importing the five public facades: Ico_File, Icon, Simple_Package,
Subtitles and Windows_Resources. It checks each fixture through that fixture's
actual program context. No private import guard or library implementation is
modified.

`tools/portable_data_context_lint.py` retains the runner's complete source
inventory: 40 Jai files, including 23 private implementation files. Its seven
profiles are macOS, Linux and Windows on x64/ARM64, plus WASM. Windows-only
fixtures and private Windows providers receive Windows contexts. The three
resource-wire providers reached publicly through Windows_Resources are requested
through that facade on Windows; the existing library-owned portable fixtures
also exercise their pure operations. Every owned file must appear in both the
actual checked-file list and a complete compiler context. Imported but unreported
files, failed contexts and never-visited files cannot establish lint coverage.
There are no directory or private-file exclusions from the final coverage check.

All invocations retain `-D warnings`. Each profile also requires an independent
application's private import to fail with the real privacy diagnostic. The
negative program references the imported alias so an unrelated unused-import
diagnostic cannot substitute for the required privacy rejection. The first
negative draft's extra unused-import failure is retained in the evidence.

The original source roots, runtime functions, native/WASI/Windows inventories
and non-lint runner calls are mechanically compared before/after and unchanged.
Image dependencies, SDK consumers, optional unsupported-WASI image probes,
Windows native resource/discovery/Icon checks and actual program assertions
remain required as before. Contextual lint runs before runtime work; duplicate
direct-root lint calls are replaced by the complete seven-profile check.

For isolated source/lint verification without building or running programs:

```sh
python3 tests/portable-data/run.py --lint-only \
  --linter "$OWN_BUILD/debug/jailint" \
  --output-root "$OWN_CAPTURE/portable-data"
```

The new output option keeps local artifacts on the assigned external disk. CI
retains the existing `target/portable-data` default. Native libraries still
default to the selected output's `native` directory, with explicit
`--native-libs` and Windows PATH handling preserved. Lint-only does not require
compiler/formatter/native images. It requires the stdlib belonging to this
runner, and rejects a different selected library rather than crediting coverage
of unrelated source bytes.

The fixed source-built linter pin accepts the old direct-root command on this
Mac host, including its Windows source target. That does not reproduce or clear
the original Windows-native rejection. Actual public-context checks, complete
private-body reports and guard negatives pass independently. No source changes
or runtime results are projected onto newer moving compiler HEADs.

## HTTP App metadata coordination

The reviewed App/Client surface exists only outside WASM. Both
`extensions/http-dependency-consumer` and
`extensions/http-client-overload-lint-repro` must remain native runnable positives;
WASM selection is unavailable, never passed. Codec and explicit WASM termination
controls remain selected. A genuinely native-selected App failure still fails.

The producer's exported packet path was OS-denied once; it was not retried or
read through an alternate path. The safe shared review, module source and unique
three-method metadata regression were inspected. Both exact IDs were **already
present in the captured shared baseline**. The regression passes against actual
shared production metadata; no metadata edit or inherited hunk is included in
this runner patch. The attempted equality-line patch made no change because the
reviewed membership condition was already present. An earlier premature inbox
RED/timing statement was corrected with the actual receipt and baseline hash.

The producer's separately recorded ten source/lint controls remain peer evidence.
Eleven fresh focused source/lint controls using the existing compiler/linter pin
also pass here: six native-target source positives, two explicit WASM App
boundary rejections, two strict fixture contexts and a required WASM codec
positive. No App API, runtime fallback or target-specific compiler rule is added.

[The exact handoff](../status/foundations-portable-data-context.json) records
patch/source/tool hashes, all context reports, source guards, policy regressions
and preserved failures. The accepted storage/clock handoff remains separate and
unchanged. Integration alone stages and commits. Actual Windows-native CI and
the combined runtime gate remain required; this source/lint repair does not
replace the existing runtime proof or claim a new runtime replay.
