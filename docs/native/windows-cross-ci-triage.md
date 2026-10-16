# Windows cross-runner CI triage

This companion fixes runner selection and accounting from the current normal CI
failures. It does not make Windows target libraries executable on Linux, change
production backends, or claim native Windows acceptance.

`tools/windows_cross.py` now consumes the catalogue's existing OS requirements
before either negative checks or executable builds. Every unavailable selection
is recorded in `build-report.json`, with `passed: null` and a reason, separately
from built executables, compile-time-only programs, failed builds, stale fixture contracts and validated
expected-negative checks. An expected rejection is never a native runtime pass.
Required failures remain fatal, including with the retained `--keep-going`
spelling; the runner already attempts independent builds regardless of failure.

Exact fixture requirements, rather than error-message waivers, apply:

| Fixture | Requirement and retained coverage |
| --- | --- |
| `compiler/socket-select-canonical-timeval` | Existing Unix requirement; the canonical POSIX timeval assertion remains unchanged. |
| `extensions/io-uring-dependency-repro` | Existing Linux requirement; its uninitialized-ring source-only reduction must not become a Windows executable. |
| `contracts/program-print-plugin-file-output` | Windows build host for ordinary target `#run` File calls; native Windows builds remain required. |
| `compiler/rules-compile-time-execution` | Windows build host for ordinary target `#run` File/Process calls; native Windows builds remain required. |
| `compiler/lang-asm` | Architectural CPUID/PAUSE/fences require x64; ARM64 reports unavailable. On x64 its stale zero-CPUID oracle is explicitly `stale_fixture_contract`, with null pass result and separate count, only while the exact fixture SHA matches. A corrected fixture becomes required. No official reference rejection verdict was supplied; this category reports a stale local fixture contract only. |
| `native/imgui-headless-frames` | The existing pinned `imgui` profile explicitly excludes both MinGW targets: Windows declarations use MSVC C++ ABI. Native Windows MSVC coverage remains required. No general ImGui/Windows exclusion or `-lffi` waiver is added. |

The [reviewed execution boundary](../specs/jai/polymorphism-and-metaprogramming.md#cross-target-compile-time-execution)
does not promise host remapping of arbitrary target native calls. Host native
libraries are provisioned through the existing host helper, separately from
`JAIC_CROSS_LIBS`, which receives only the requested target's artifacts. Missing
providers remain real failures. The required bcrypt phase problem below is not
classified unavailable merely because it appears in a cross check.

A missing-main diagnostic can no longer conceal other errors: an independent
`-check` must succeed before that failed link is classified compile-time-only.
Runtime manifests retain catalogue stdout/stderr assertions and fixture input
metadata. Arguments and real scratch/font inputs are prepared on the Windows
runner, rather than embedding Linux build-host paths. Missing inputs fail; there
is no fabricated font/provider or source mutation.

## Actual focused evidence and open failures

Nine new accounting tests and six existing rejection-stream tests pass. They use
mocked compiler/program dispatch and prove harness policy, not Windows native
functionality. The controls retain genuine compile/link errors, timeouts,
positive-baseline errors, stderr mismatches and nonzero runner status. Ruff lint
and formatter checks cover the owned runner and tests.

The exact integration tool path was denied by isolation before any execution.
No alternate access was attempted. A fresh locked, offline build of accepted
current shared compiler sources in the worker's own T7 cache completed in
10.78 seconds; no crate/Cargo/toolchain source diff was present. Its SHA256 is
`e2c1a7569844675facca7134327b13f21b02521b58d158ddc93244b30a98b29b`,
which independently matches the reviewed f1 receipt. Current shared production
stdlib and system host libraries were used; no integration native assets or
old tool fallback were borrowed.

Actual Windows-target `-check` on this Mac host reproduces these four failures
on **both** x64 and ARM64; all eight remain RED and required by the runner:

| Independent existing reducer | Actual diagnostic / next owner |
| --- | --- |
| `tests/compiler-regressions/proc-type-defaults-ifx.jai` | Inferred `h("x", "y")` expects three arguments. Explicitly typed calls precede it. The inferred-default contract remains the [reviewed question](../specs/stdlib/compiler-questions.md); compiler/reviewer must resolve it. |
| `tests/compiler-regressions/static-switch-add-context.jai` | `Switch_Context/backend/context.jai:5`: context extension after compile-time layout. All OS branches load the same independent context file; no Windows exclusion is justified. Compiler owner. |
| `tests/extensions/io-configured-production.jai` | Child remapped Basic sets `ENABLE_ASSERT=false` after another value was used. Original `message.kind != .ERROR` assertion also fails and remains intact. Compiler module-parameter ordering owner. |
| `tests/extensions/json-windows-host-provider-repro.jai` | `generate_freer` reaches host allocation through `allocator_call`, then eagerly requires target bcrypt. Preserve required initialization and resolve the [provider phase question](../specs/stdlib/http-tls-target-questions.md#required-library-phase-question-compilerprovider-owners); no fake bcrypt or JSON rewrite. |

Commands use the new own source-built compiler and the actual source directory:

```
JAIC_STDLIB=<shared>/stdlib <own-jaic> <independent-source> -os windows -cpu x64 -check
JAIC_STDLIB=<shared>/stdlib <own-jaic> <independent-source> -os windows -cpu arm64 -check
```

`tests/extensions/tls-windows-target.jai` passes those two source checks. This
does not establish linking or execution. Actual ARM64 CI's `inet_pton` link
failure remains open pending its precise link command/import-library identity.
[Microsoft's SDK documentation](https://learn.microsoft.com/en-us/windows/win32/api/ws2tcpip/nf-ws2tcpip-inet_pton)
and the [official MinGW header](https://github.com/mingw-w64/mingw-w64/blob/master/mingw-w64-headers/include/ws2tcpip.h)
define `InetPtonA` as the macro `inet_pton`; the
[official common import definition](https://github.com/mingw-w64/mingw-w64/blob/master/mingw-w64-crt/lib-common/ws2_32.def.in)
includes `inet_pton`. The initial suggestion to rename the foreign symbol was
withdrawn before any edit. A new independent C control compiled and linked with
the installed x64 MinGW SDK: its object references `__imp_inet_pton`; its AMD64
PE imports `WS2_32.dll!inet_pton`. It was never executed. No ARM64 tool/archive
proof is claimed and the production socket binding is unchanged.

The independent control is tracked at `tests/native/windows/inet-pton-sdk.c`.
When the real TLS Windows case is selected, the runner also builds this C control
using the selected CPU's real SDK compiler and `ws2_32`, then includes it in the
normal Windows executable run manifest. It checks IPv4/IPv6 bytes and invalid
text without opening a network connection. A missing SDK, link failure, missing
executable or runtime mismatch remains fatal. It supplements the actual TLS
case and never replaces it or satisfies its failure. Local evidence is x64
cross compile/link only; native execution awaits the coordinator's Windows job.

Own T7 evidence directory is `platform-io/target/windows-cross-ci`:
`selection-red.txt` retains the original six policy failures; `source-build.log`
records the new source build; `source-triage.json` retains all ten source-check
commands/outputs, including eight genuine failures. Native/GUI/fault execution
count is zero; the root full-workspace native lease remains respected. Native
Windows CI and broader fixture acceptance belong to the coordinator. No
benchmarks, publication, workflow dispatch, history edits or remote operations.

## Latest ifx fixture classification

The exact original overloaded proc-type-defaults-ifx source (SHAe2aaa5f6...) has a root-supplied official rejection verdict and is excluded as an invalid positive fixture. Windows-cross, the runtime catalogue and sweep report it separately as reference_rejected with null pass; raw local acceptance cannot make it a reference-positive success. Changed fixture bytes and independently authored supported ifx controls remain required. The architectural CPUID case retains its separate stale_fixture_contract classification and has no official rejection claim. One accounting test verifies zero compiler dispatch, no positive/platform count and a distinct rejection count; existing42 cross/runtime/runner policy checks pass.
