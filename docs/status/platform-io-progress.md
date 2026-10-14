# Platform I/O worker progress

## Refreshed-contract continuation

Coordinator-filtered CI feedback confirms candidate `159ca65` passed File
interpreter/native O0/native O2 on **real Windows x64 and ARM64**. This evidence
belongs to that candidate; it does not establish native results for later changes
or for System/Thread/Process/runtime. No raw vendor/corpus CI logs were accessed.

The refreshed Process Windows records are implemented in a canonical private type
module and re-exported unchanged by the public facade. The native engine now uses
those records directly, retains all PROCESS_INFORMATION fields including the real
primary thread handle, and allocates stable OVERLAPPED state with its owning allocator.
Public create/read/write/wait/kill/deinit and named-pipe initialization are wired to
the engine; run_command uses the shared portable orchestration. Unix code is retained.

Removed the temporary test-only Process module and internal entry fixture. The
same ownership/capture/timeout/parent-exit tests now import the public Process facade,
with added public record-size, native process-info and standalone pipe assertions.
The new original common Process contract first failed on the old Unix-only facade
guard, then passed both Windows architecture source checks and host interpreter/O0/O2.
The complete Windows public suite and helper cross-link at x64 O0/O2. Executed:
`python3 tools/check_platform_io.py --jaic target/debug/jaic --stdlib
target/platform-io-stdlib --cross-check --native --windows-process --windows-build x64`.
These new Windows behaviors still require native CI.

Public Process checkpoint: `700f07e`.

The reviewed public x64 crash facade is now implemented, including mutable globals,
record layouts, section queries, exception callback and backtrace. The private SDK
backend checks native size/offsets and copies byte-shaped contexts to aligned native
storage. DbgHelp is serialized; interrupted symbol work produces an explicit
stack-unavailable diagnostic. Runtime installs the public handler from system entry
only; the superseded startup wrapper and private crash module were removed.
The runner passes ARM64 initialization-only checking and the expected enabled-handler
rejection. x64 enabled-startup fault and public crash ABI fixtures cross-link at O0/O2;
actual exception execution remains pending native CI.

General strict-lint repairs implement target selection, library-owned virtual roots,
bootstrap-instance reuse, loaded-file facts/manifests, and failure for incomplete
checking. Application privacy remains enforced by an original regression. IDE record
constants now establish their containing layout before resolution, matching ordinary
compiler checking; this fixes the real Thread INFO_SIZE lint failure. Library-call
rules follow canonical exported aliases. All 23 jailint Rust tests pass (11 unit,
5 CLI, 7 rule cases), as does scoped clippy with warnings denied.

`tools/format_platform_io.py --lint --jailint target/debug/jailint --stdlib
target/platform-io-stdlib` passed all four target configurations and verified manifest
coverage for all 41 owned Jai files. Staged owned files were compared byte-for-byte;
this remains independent dependency staging, not coordinator production integration.
The previous quiet/incomplete lint evidence below is historical and superseded.

The expanded common runner now passes eight contract fixtures plus argument handling
in host interpreter/native O0/O2, four-target -no_dce checks, and Windows x64 O0/O2
cross-linking. The new Thread_Group case runs both stealing modes, checks unique
completion pointers/results and worker context, then joins and verifies teardown.
The public Process/crash fixtures also check canonical reflected names. Executed:
`python3 tools/check_platform_io.py --jaic target/debug/jaic --stdlib
target/platform-io-stdlib --cross-check --native --windows-process --windows-crash
--windows-build x64`. Enabled x64 fault startup cross-builds; no Windows native pass
is inferred. The standalone IDE Rust regression was confirmed failing with only
the new ordering step removed, then passing when restored.

Tool checkpoint: `27b719c`. Remaining integration requirements: Windows native CI,
compiler suspended-CRT-thread/event/callback lifetime support, public Machine_X64
dependency, reviewed Thread DEBUG configuration, and existing File contract questions.

Durable producer commits: `eb5d83d` (File), `339a16e` (System/Thread/runtime),
`fe44299` (private Process engine, native exception diagnostics, SDK checks and
strict lint/handoff). Work remains at the explicit integration gates below;
this is not a full native Windows/corpus completion claim.

## File checkpoint (2026-10-14)

Implemented Win32 File handles, binary reads/writes, 64-bit size/seek, flush,
Unicode paths, links/moves/deletion, directories, absolute/canonical paths,
known folders, real read-only mapping and ownership cleanup. Shared convenience
operations use the selected backend. Unix operations retain their implementation.

Evidence executed locally:

- Original `tests/platform-io/file-contract.jai` first failed Windows checking on
  the existing OS_IS_UNIX assertion.
- Windows x64/arm64 `-check -no_dce` now pass with the source-built compiler.
- Host macOS interpreter and native O0/O2 each print `ok`.
- Windows x64 O0 executable cross-links with the installed MinGW-w64 toolchain.
- Source-built `target/platform-io-tests/jaifmt` formatted the six owned Jai paths;
  source-built `target/debug/jailint -D warnings` exited zero on the same scope.
  The later verbose audit below supersedes any complete semantic-lint interpretation.

Compiler/tool staging: copied permitted independent `../compiler/crates` plus
Cargo manifests into `target/platform-io-toolchain`, then built with
`cargo build --locked --manifest-path target/platform-io-toolchain/Cargo.toml -p
jaic-cli -p jailint`. Cargo's target directory is this checkout's `target`.
The first source build caught an in-flight Option<Sym> compiler error; retrying
with the producer's corrected interfaces.rs passed. A copied permitted producer
binary was used only for early checks while that source build was repaired.

Dependency staging: copied local stdlib plus independent bindings POSIX/Windows/
internal bindings, foundations Basic/String/Hash/File_Utilities and their private
dependencies, and compiler Compiler/Jai_Lexer/private dependencies, into
`target/platform-io-stdlib`. No staged source is claimed as a production merge.
The formatter was built from `jaifmt/main.jai -O2` against that tree.

Committed File checkpoint: `eb5d83d`.

## System, Thread and runtime checkpoint

Implemented Windows account/profile queries, machine/executable paths, native
error descriptions and topology-based physical/logical/performance counts.
Added Windows critical sections, condition variables, semaphores, suspended CRT
thread creation, completion and allocator/context cleanup. Unix paths remain
selected unchanged. Runtime Windows output now calls WriteFile, avoiding CRT text
conversion; native entry converts the actual Windows command line to UTF-8 and
releases its storage after runtime teardown. Windows debug_break uses DebugBreak.

The original System/Thread fixtures first failed on their Unix-only assertions.
The expanded File allocation-failure test first failed in alloc_string's assertion;
read_entire_file now returns failure when allocation fails, with overflow checked
before reserving the terminator. Other File coverage now includes recursive Unicode
directories, null/negative writes, empty native mappings and borrowed-wrapper cleanup.

Executed `python3 tools/check_platform_io.py --jaic target/debug/jaic --stdlib
target/platform-io-stdlib --cross-check --native`: all four original contract fixtures
pass Windows x64/arm64, macOS arm64 and Linux x64 `-check -no_dce`, host interpreter,
native O0 and O2; Unicode/empty/quoted argument fixture passes host interpreter/O0/O2.
Windows x64 File/System/Thread/runtime fixtures cross-link. PE imports confirm native
runtime uses WriteFile/GetCommandLineW/CommandLineToArgvW instead of CRT `_write`.
The runner now compares bytes, so CRLF translation cannot be hidden by Python decoding.

Source-built jaifmt formatted the owned paths; jailint `-D warnings` exited zero after
removing an unused test import. A later verbose audit found incomplete private-root
and Windows semantic coverage; see the explicit tool blocker below. These lint exits
must not be read as the complete required semantic gate.

Next: prepare real private Windows Process mechanisms without inventing missing
public Windows aggregate layouts; record remaining runtime/crash ABI questions.
Native Windows execution, interpreter CRT suspension support and full public corpus
remain coordinator/compiler work. No Windows runtime pass is claimed here.

Committed System/Thread/runtime checkpoint: `339a16e`.

## Private Windows Process engine checkpoint

Implemented a separate real Win32 engine without guessing the absent public
Windows Process/Pipe layouts. Uses CreateProcessW, CRT-compatible quoting from the
existing independent argument helper, explicit inherited-handle lists, overlapped
named pipes/events, simultaneous stdout/stderr reads, synchronous completion of
input writes, bounded timeouts, cancellation/draining before caller buffers return,
native exit status/termination, and kill-on-parent-exit job objects assigned before
the suspended child is resumed. Cleanup handles all partial-launch states.

The original private-engine fixture initially failed because its module was absent.
Direct internal entry compilation is intentionally forbidden by the compiler's
library privacy policy. The runner supplies and then removes an explicitly test-only
staged module for white-box verification; this is NOT a public Process integration.
Native fixtures cover Unicode/quote/backslash arguments, binary stdin, separate
capture, large dual-stream output, read/wait timeouts, termination, parent-exit job
cleanup and its explicit opt-out. Native Windows execution is still outstanding.

Public SDK C layout probe compiled with
`x86_64-w64-mingw32-gcc -std=c11 -Wall -Wextra -Werror -c
tests/platform-io/windows-sdk-layout.c -o target/platform-io-tests/windows-sdk-layout.o`.
This validates handle/GUID/file-position, OVERLAPPED, startup/process/security/job
records and processor affinity offsets against installed public native headers.
The same probe also compiled with Clang targeting aarch64-w64-windows-gnu against
the installed public MinGW headers. Both target layouts pass the assertions;
neither compilation establishes native runtime passes.

## Windows native exception diagnostics and tool audit

Added SDK-based private exception diagnostics for the core runtime's enabled
backtrace startup path. This uses the actual SDK CONTEXT for each CPU and does not
reuse the incomplete public x64-only crash record. The native DLL installs a real
unhandled-exception filter, emits exception code/address and bounded native stack
frames through WriteFile, resolves available symbols with DbgHelp and preserves
OS termination. Initialization errors propagate; no fabricated backtrace frames.

Executed `python3 tools/build_platform_io_runtime.py --stdlib
target/platform-io-stdlib --cpu x64` with -Wall/-Wextra/-Werror. Clang also compiled
runtime-windows.c to an arm64 Windows object against installed public SDK headers.
`--windows-crash` runner source-checks enabled startup for both CPUs and cross-builds
the original access-violation fixture through the existing independent Compiler
workspace test. PE imports show platform_io_windows_crash.dll/init. Native execution
is outstanding; the runner has a real Windows exception-code/stderr assertion.

**Lint blocker discovered by verbose audit:** source-built jailint's quiet exit-zero
results omit failed private module roots, and host selection does not cover Windows
branches. All owned files are included, with no suppressions; full Windows/internal
semantic lint is not satisfied. Exact evidence and required generic fixes are in
[compiler/tool handoff](../platform-io-compiler-handoff.md), together with suspended
CRT-thread and native event/OVERLAPPED interpreter interoperation requirements.

Remaining integration gates: reviewed public Windows Process record shapes and
public crash-handler ARM64 contract; generic compiler/interpreter/linter fixes;
native Windows x64/arm64 execution; integrated corpus/normal native CI. No publication,
push, tag, workflow dispatch, peer checkout edit or Extensions change was performed.

## Final verification scope

The single owned Jai path list is in `tools/format_platform_io.py`. Executed format
and idempotence checks use `--jaifmt target/platform-io-tests/jaifmt` and `--check`.
The strict `--jailint target/debug/jailint --stdlib target/platform-io-stdlib --lint`
gate exits **1**, preserving the nine incomplete-root diagnostics in
`target/platform-io-tests/strict-lint.log`; no complete semantic lint pass is claimed.

Executed combined fixture command:

```
python3 tools/check_platform_io.py --jaic target/debug/jaic \
  --stdlib target/platform-io-stdlib --cross-check --native \
  --private-process --windows-build x64 --windows-crash
```

All supported host tests and target/cross-build checks pass. Real Windows execution
is not performed on this host. Windows ABI sizes are asserted in Jai and cross-checked
against public C SDK headers on x64 and arm64. Pipe EOF status is classified as EOF;
overlapped transfer counts come from GetOverlappedResult even for immediate completion,
and zero-byte native pipe writes are not mistaken for EOF. The native fixture retains
a focused zero-byte-write-then-data case for Windows execution.

Existing Unix preservation tests `file`, `filesystem`, `system`, `thread-condition`,
`thread-lifetime`, `thread-groups`, `thread-shutdown`, `process` and `process-io` each
passed host interpreter, native O0 and native O2 with exact expected output and no
stderr. Source-built tools used permitted independent producer staging only; full
corpus, Focus/window/font dependencies and integrated native CI remain coordinator
verification. `git diff --check` passed and Extensions has no changes.
