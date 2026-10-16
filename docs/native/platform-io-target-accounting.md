# Platform-I/O target selection and separator oracle

The canonical full producer-suite path is `tools/check_stdlib_suites.py` → its
`platform` command → `tools/check_platform_io.py --native --cross-check --wasm`.
This selects every dedicated contract, unlike the current `ci.yml` WASM step,
which explicitly selects only `file-contract`. The general runtime matrix has a
second path: `tools/stdlib_runtime.py` → `stdlib_test_catalog.validated_entries`
→ `unavailable_reason` before dispatch. Correcting just the workflow would leave
both general all-case callers broken.

`tools/platform_io_capabilities.py` describes individual programs, not families
or compiler diagnostic strings. The dedicated Process, System, Thread and
Thread_Group contracts require native OS services. Their requested WASM check,
interpreter and O0/O2 execution modes now report `platform_unavailable` with
`passed: null` in `wasm-results.json`; no target compiler is invoked for these
unsupported positives. Native interpreter variants, O0/O2 builds/execution and
desktop cross-source checks remain scheduled. Unknown dedicated fixtures fail
selection until reviewed. File, runtime, layout, startup and crash-contract
WASM scheduling is unchanged.

The catalogue attaches unsupported WASM modes only to
`contracts/process-quoting-contracts` and
`contracts/thread-mutex-and-semaphore-contracts`. All native modes remain
eligible. Existing structured runtime reporting consumes this metadata through
`unavailable_reason`, so unsupported modes count as unavailable, never passed.
The public modules' actual unsupported-target assertions are unchanged. Current
source checks independently confirm all four dedicated WASM rejections at those
public guards; an unrelated compile failure is not accepted as availability.

The dedicated runner accepts `--compiler-build-root` and `--output-dir` for
explicitly source-built tools and isolated artifacts/captures. Existing checkout
defaults remain. The compiler must resolve beneath the selected build root;
the option does not discover or substitute another compiler. Command failures
remain fatal after independent checks finish. This report covers requested WASM
modes only; it does not fabricate structured native results.

## File_Utilities test correction

`tests/stdlib-contract/file-utils/main.jai` previously required
`../orchard/oak/` on every OS. The reviewed File_Utilities contract says path
separators vary by OS, and reviewed String specifies backslash on Windows.
Production `path_to_string` already follows that contract. The assertion now
requires `..\orchard\oak\` on Windows and keeps the original Unix expectation.
Component reduction/order, leading/trailing slash state, containment failures,
file ownership, truncation, zero termination, reads and deletion are unchanged.
This is a test oracle repair, with no production change.

## Verification and remaining gates

Fresh source-built compiler and jailint were built offline from accepted shared
sources. Evidence lives in the worker's T7 `platform-target-accounting` directory;
the ready manifest pins exact captures and tool hashes.

- Six new accounting tests cover the real runner call path with mocked execution,
  all nine dedicated fixture dispositions, null unavailable results, retained
  native checks and strict supported-mode failures. These are harness tests,
  not native OS proof. Six fault-protocol and twelve runtime-helper tests pass.
- File_Utilities fixture source checks and strict warnings-denied lint pass for
  Windows x64/ARM64, Linux x64/ARM64 and macOS ARM64.
- The corrected fixture passes actual macOS interpreter and native O0/O2; its
  WASM check/interpreter and actual WASI O0/O2 also pass. This does not establish
  Windows or Linux native execution of the changed oracle.
- The real dedicated runner, selecting layout only, passes its interpreter and
  WASM check/interpreter/WASI O0/O2 paths with explicit isolated output/tool roots.
- The changed Jai fixture is formatted by a freshly source-built WASM jaifmt and
  a second formatting pass is byte-identical. New Python files pass Ruff format;
  all four owned Python files pass Ruff lint.

Original File WASI O0/O2 execution remains RED at its unchanged hard-link
assertion, line 72. An independent actual host `os.link` on the same T7 directory
fails with errno 45, Operation not supported. This is measured filesystem
capability, not proof of a WASM provider defect. Interpreter success observes its
isolated filesystem, not host hard links. No test skip, copied-file substitute,
alternate scratch filesystem or production workaround was added. File remains
required on WASM and needs execution on a hard-link-capable CI filesystem.

The tour's File_Utilities filesystem dependency remains a reviewed API question:
see [exact dependency and reproducer](../specs/stdlib/platform-io-wasm-dependency-questions.md).
Thread lifecycle, WASM syscalls, console linker forwarding and resource producers
are unchanged. Earlier native Windows resource acceptance is still pending;
cross-link receipts are not Windows runtime proof.
