# Audio provider CI handoff — job117139967666

Audio owner claimed the serialized SDK/fault slot for this focused proof; it is
now released, with LSP priority. No active builds. All fresh build/capture output uses the
assigned `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/audio/target`; the existing
worktree target symlink points outside that assignment and is not being used.

The supplied job verdict is `native SDK harness failed: exit 0` because stderr
was nonempty. The old helper records its line count but discards the text. No
original Linux audio-runtime.json or helper stderr is surfaced here. Therefore
the exact diagnostic remains unclassified; do not call it harmless, a compiler
failure, or a successful native device proof. The later missing target/debug/jaic
is downstream of provider setup/build order, not an independent compiler verdict.

Integration owns ci.yml. Apply this shared job-level environment to **every Linux
job that actually consumes audio**, including sanitizer, before provider builds:

```yaml
env:
  ALSA_CONFIG_PATH: ${{ github.workspace }}/tests/audio/fixtures/alsa-null.conf
  JAI_AUDIO_ALSA_DEVICE: jai_audio_test
```

Use the tracked real ALSA null PCM configuration (explicit 2/6/8 channel maps),
not a fake handle or suppressed ALSA error callback. Debian/Ubuntu runners need
the real `libasound2-dev` package and `/usr/share/alsa/alsa.conf`. Keep this setup
in effect for the SDK harness, close-fault protocol, Jai interpreter/native tests
and any relocated package consumers. Add `--require-device` to the SDK proof:

```sh
python3 tools/audio_build_native.py --test-runtime --require-device
```

An actual Linux rerun is required before closure. Surface audio-runtime.json and
the routing/close runtime receipts from that run, including captured harness
stdout/stderr, even when the step fails. Also surface the original SDK stderr or
receipt if available; raw job logs/reference/vendor bodies are not requested.
Do not allow a failed provider build to become a misleading compiler verdict.
No ci.yml or peer source is changed by this worker.

The local sanitized ci.yml snapshot predates the newly reported provider step
(it contains no audio_build_native invocation). It cannot establish the failed
job's exact environment. Apply the scoped setup to the integration owner's
current workflow, not this stale snapshot. An equivalent Linux-only step, placed
before the first provider build in every consuming job, is:

```yaml
- name: Configure the real headless ALSA provider
  if: runner.os == 'Linux'
  run: |
    test -r /usr/share/alsa/alsa.conf
    test -r "$GITHUB_WORKSPACE/tests/audio/fixtures/alsa-null.conf"
    echo "ALSA_CONFIG_PATH=$GITHUB_WORKSPACE/tests/audio/fixtures/alsa-null.conf" >> "$GITHUB_ENV"
    echo "JAI_AUDIO_ALSA_DEVICE=jai_audio_test" >> "$GITHUB_ENV"
```

Do not limit those environment settings to a single build step. Keep the existing
CI dependency installation/build order and sanitizer error gates intact. The
builder's output/cache now follows CARGO_TARGET_DIR when set; point later native
library consumers at that actual audio-native directory if CI overrides it.
Upload all three runtime receipts with an `always() && !cancelled()` condition;
only a successful process plus passed SDK, routing and close receipts establishes
the complete native proof. Optional unavailability is not a native pass.

The integration owner can also prevent the known downstream missing-binary
misdiagnosis by giving the compiler build an id and requiring its success before
the always-run O2 sweep. Preserve O2 execution after an O0 test failure; gate only
on whether the required compiler was actually built:

```yaml
- name: Build jaic
  id: build-jaic
  run: cargo build --locked -p jaic-cli
# Existing O0 sweep remains unchanged.
- name: Corpus, stdlib and module tests under ASan and UBSan (-O2)
  if: ${{ always() && !cancelled() && steps.build-jaic.outcome == 'success' }}
  # Keep the existing O2 command and genuine sanitizer failure policy.
```

A provider/build failure must still fail the job; dependent sweeps are blocked,
not native passes or independent compiler verdicts. Apply this only to the
integration owner's current workflow, which may have different step names.

Producer evidence: six receipt/protocol unit tests pass; these use metadata
fixtures only and do not provide Linux/device evidence. A fresh exact-host macOS
ARM64 SDK build/run on assigned T7 passed: two real acquisitions, required-device
protocol completed, empty stderr, controlled routing and NDEBUG close injection
passed. Linux original diagnostic classification and an actual configured Linux
rerun remain required. No remote credentials/CI execution are available to this
worker, and no /Users/matthew/projects/jai-reference/vendor application source or raw job log was accessed.

The local SDK/fault slot is now released; LSP priority remains. There are no active
local or T7 builds. Exact source/receipt hashes and concise measured evidence are
in audio-ci-provider-evidence.json. Full helper captures remain in the assigned
T7 audio-provider-proof/macos-arm64-configured directory. Compiler and runtime
child-process TMPDIR/TMP/TEMP are explicitly assigned audio-native/tmp on T7.
The first output-only proof inherited host compiler scratch; its refresh fixes
that storage omission and preserves the earlier captures. These are Mac proofs,
not Linux. The SDK/fault slot is again released after the refreshed proof.
