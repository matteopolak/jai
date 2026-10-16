# Windows CRT environment acquisition — CI21667104 job117168189015

The supplied actual Windows clang/MSVC verdict is a genuine implementation defect:
`output.c:150` called deprecated `getenv` under `-Werror`. This newly reached build
failure is independent of the earlier Linux stderr/provider and Thread failures.
No original job logs or reference bodies were requested or read.

Production functions changed: `audio_output_preferred_channels()` and the native
builder's `build()`. Windows now uses the documented desktop UCRT `_dupenv_s`:
successful acquisition owns a copy, parsed then freed before any return; absence
or empty value retains device discovery; read/allocation error returns `-1`, as
does an invalid nonempty override. POSIX retains its immediate borrowed `getenv`
read. No environment pointer is retained in a device or callback. Configuration
changes must be serialized by the caller with reads; this adds no promise of
concurrent process-environment mutation safety. Windows incurs one short-lived
CRT allocation per override query. No real-time performance claim is made.

SDK authority: [Microsoft `_dupenv_s` ownership, errors and CRT environment](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/dupenv-s-wdupenv-s?view=msvc-170).
No diagnostic waiver, `_CRT_SECURE_NO_WARNINGS`, substitute device or relaxed
failure gate is used. Linux device selection, SDK routing, and genuine close-fault
tests are unchanged. The prior e2021dd5/7e914952 receipt/T7 patch stays separate.

NEW `tests/audio/native-environment.c` uses real CRT/POSIX mutation APIs and the
owned backend implementation. It checks unset/empty discovery, exact 2/6/8
overrides, malformed/unsupported values, and 8,000 repeated reads. Windows adds a
clearly controlled ENOMEM acquisition failure and recovery; every non-injected
read uses actual `_dupenv_s`. It never opens or fabricates a device. Checks remain
active with NDEBUG. These are producer backend/official SDK contract tests, not
new public Sound_Player declarations or inherited private compatibility gates;
independent review is requested.

`build()` compiles this test for every requested desktop target with existing
warnings-denied flags. Exact-host `--test-runtime` executes it and writes
`audio-environment-runtime.json`; nonzero exit, stderr or unexpected stdout still
fails through the existing strict receipt helper. Existing SDK/routing/close
receipt validation is unchanged. A test compilation failure fails the build.

## Evidence and integration request

All artifacts and child scratch were on assigned audio T7. The serialized SDK/
fault slot is released; no builds remain active; LSP retains priority. No local
target symlink, compiler/peer source, workflow, shared manifest or index was used
for changes. Integration owns application/commit and Windows CI.

Executed locally:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 tools/audio_build_native.py --out /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/audio/target/audio-windows-env-proof/macos-arm64 --test-runtime --require-device --check-windows
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests/audio -p test_provider_receipts.py
```

- Mac ARM64: warnings-denied build; actual silent SDK two-open/play/pause/resume/
  close/reopen proof, routing and NDEBUG close fault checks passed, empty stderr.
- Mac ARM64: environment test passed, also separately built/run with
  `-O1 -g -DNDEBUG -fsanitize=address,undefined -Wall -Wextra -Werror`, empty stderr.
  This executes the POSIX branch, not Windows CRT allocation/lifetime.
- Windows x64: MinGW public SDK owned static/shared libraries, environment test,
  native SDK and close-fault harnesses compiled/linked warnings denied. SDK ABI
  assertions compiled. None executed; this is not clang/MSVC deprecation proof.
- Six receipt unit tests passed; these are metadata/protocol tests, not native
  device execution. The opaque official decoder still reports one upstream C
  warning on each build, counted without suppression; owned C is warnings denied.

Required coordinator rerun: apply the NEW separate patch after the already-ready
receipt/T7 patch and rerun the actual Windows clang/MSVC provider build unchanged:

```sh
python3 tools/audio_build_native.py --test-runtime --require-device
```

Retain the job's actual MSVC-target driver/SDK setup. Surface `audio-build.json`
and all four `audio-*-runtime.json` receipts, including on failure. The new
environment receipt is no-device evidence; the SDK and close receipts remain
required for native provider proof. No workflow edit is supplied or needed for
the production compile fix; integration may extend its existing artifact glob.
Actual Windows compile/runtime and ENOMEM recovery remain pending. No Windows
pass or full-audio completion is claimed. The older Linux rerun remains open.

Patch: `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/audio/target/audio-windows-env-proof/audio-windows-env.patch`.
Exact source and local receipt hashes accompany it in
`docs/status/audio-windows-env-evidence.json`.
