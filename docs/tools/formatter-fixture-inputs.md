# Formatter fixture transport and readonly capability

Repository formatter acceptance still copies every discovered Jai source outside
the existing deliberately malformed `tests/corpus` exclusion, formats the copy,
and requires a second `--check` pass to succeed. Its protected source must retain
its original bytes and observed permissions. No complete test is skipped by this
repair, and no source or golden under `stdlib/Extensions` changes.

The own T7 probe accepted a readonly permission request (mode `0100500`) but
reported mode `0100700` afterward. The test now checks this capability immediately
after setting permissions. On an incapable local filesystem it reports that
specific limitation and runs all copying, formatting, idempotence and original
preservation checks. In any `CI` or `GITHUB_ACTIONS` environment, lack of readonly
capability is a failure: normal CI must retain actual readonly acceptance. This
qualifies only the protection premise, not formatter correctness.

Both Rust repository discovery and Node golden discovery exclude a file only if
its name starts with `._` and its bytes contain the AppleDouble v2 magic/version,
complete 26-byte header, complete counted 12-byte entry table, and in-bounds
nonempty payloads beyond the table. Empty entries follow the same rule as the
bindings worker's independently authored `objc_selectors.rs` predicate. That peer
file was read only; narrow equivalents avoid changing its ownership or discovery
contract. Ordinary `._` sources, malformed headers, truncated tables and missing
or overlapping payloads remain visible. There is no blanket filename exclusion.

Node now decodes inputs, expected outputs, configs and actual formatter output
with fatal UTF-8 decoding, preserving a leading BOM. Only `ENOENT` makes an
optional config absent; decoding and other I/O failures propagate. Existing exact
golden equality, negative configuration/input checks, native comparison, large
file equality and repeated-formatting assertions remain in place. Recognizing
metadata adds one small input read per golden discovery candidate; Rust reads
only sidecar-named candidates. There are no production or public API changes.

## Focused evidence

Own scratch is
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/stdlib-tools/shared-target/cli-fixtures-l295zq1s`.
`premise.json` records the readonly probe. `focused-checks.json` records the six
successful commands: three Node tests, warnings-denied compilation and execution
of four standalone Rust tests, Rust format check and two Node syntax checks.
The Node suite validates all 24 current real golden inputs/outputs/configs, copies
their inputs into own scratch, adds a valid binary sidecar to each, and requires
the discovered case names to remain identical. The reported `._blank-lines`
sidecar is absent from this current snapshot; synthetic fixtures reproduce the
transport condition without altering the golden directory.

`cargo test --locked --offline -p jaic-cli --test native --no-run` passed using the
own T7 `CARGO_TARGET_DIR`, compiling the modified real integration target. This is
build evidence, not formatter runtime acceptance. Root's native/timing lease is
held, so this batch did not execute native jaifmt or the WASM timing harness.
Integration must run the two exact filtered tests below using its matching
source-built compiler/helpers and a capable filesystem for normal CI:

```text
cargo test -p jaic-cli --test native jaifmt_is_idempotent_on_the_repository -- --exact --nocapture
cargo test -p jaic-cli --test native wasm_target::jaifmt_wasm_formats_the_golden_cases -- --exact --nocapture
```

Initial focused failures are classified in the status receipt: the first newly
authored malformed-metadata test accidentally used valid UTF-8; the fixture now
contains an independently chosen invalid byte as well as a missing payload.
An initial format invocation used edition 2021 on this edition-2024 target; the
correct edition format and check passed. Neither failure justified weakening
production behavior or existing test assertions. Runtime acceptance remains
explicitly pending, including readonly behavior on a capable CI filesystem.
