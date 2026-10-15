# Windows compiler CRT selection

Filtered actual CI 7350b86 passed the missing-KernelBase-library boundary but
failed MSVC executable linking on x64 and ARM64 with duplicate UCRT definitions
(LNK2005, ending LNK1169). Subsequent runtime steps did not execute meaningfully.
This is a compiler-build defect; it does not justify changing thread assertions.

The new scheduler entry declared #[link(name = "ucrt")]. That forces the DLL
UCRT import library even when Rust and the native LLVM archive select the static
CRT. The own Windows native/release workflows already set +crt-static for their
explicit MSVC targets, matching their static LLVM archive. The repair removes
only the forced CRT library attribute. _beginthreadex and _get_doserrno remain
real C ABI declarations and resolve through Rust std's selected CRT. Their
calling conventions, result/error handling and worker ownership are unchanged.
No runtime DLL substitution, /FORCE, /NODEFAULTLIB, CRT configuration change,
extra library alias or ignored linker error is introduced. KernelBase runtime
resolution from 049e997 is retained unchanged.

Rust documents CRT selection via target_feature="crt-static". Microsoft specifies
libucrt for static /MT, ucrt as the DLL /MD import library, and libcmt/msvcrt as
the respective CRT startup libraries. _beginthreadex requires the multithreaded
CRT, rather than an independently selected DLL implementation:

- [Rust CRT linkage](https://doc.rust-lang.org/reference/linkage.html#static-and-dynamic-c-runtimes)
- [Microsoft CRT libraries](https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features)
- [Microsoft thread entry contract](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/beginthread-beginthreadex)

## Narrow regression and next native gate

`python3 tools/check_windows_crt_linkage.py` builds the actual own jaic Rust core
as a static library for both MSVC CPUs, with both explicit CRT selections, and
checks rustc --print=native-static-libs. This is dependency metadata verification,
not an SDK executable link or runtime claim. The original source produces a red
extra-UCRT-dependency result (target/windows-crt-metadata-red.log). The retained
static before-report in target/windows-crt-static-before.log contains:

    /defaultlib:libcmt kernel32.lib ucrt.lib

After repair all four cases pass (target/windows-crt-metadata-green.log), with
Rust's respective libcmt/msvcrt selection and no direct ucrt/libucrt request.
Per-target reports are target/windows-crt-{target}-{static,dynamic}.log. The green
run replaces these per-case outputs; the separate original static report and red
runner failure retain the original evidence.

On each native Windows CI host, with the existing configured target, Rust flags,
LLVM prefix and SDK environment, run:

```sh
python tools/check_windows_thread_sdk.py --build-only
python tools/check_windows_thread_sdk.py
```

The first command builds and links BOTH jaic (jaic-cli) and jailint, defaulting
to the workflow's static-LLVM feature. The second additionally links and executes
the scheduler/thread/name/alias tests. Both inherit the existing CRT configuration
without overriding target flags. --llvm-linkage dynamic is available for a
separately configured dynamic-LLVM environment; it does not alter CRT selection.
The build-only mode reports no runtime coverage. The gate rejects non-Windows
hosts; target/windows-crt-native-gate.log retains that explicit limitation here.

This worker can verify Windows source/clippy and dependency metadata, but cannot
run MSVC executable linking or Windows threads on its macOS host. Native CI is
required before claiming the actual duplicate-symbol failure resolved in a
linked executable. Prior full core/backend evidence remains 307 passing cases;
no redundant broad rerun is claimed for this narrow Windows link repair.

Executed scoped checks: x64/ARM64 core all-target clippy with +crt-static and
warnings denied; host core/CLI/jailint all-target clippy; host builds of both tool
binaries; six scheduler units and six callback/Win32 API cases. Logs:
target/windows-crt-{x64,arm64,host}-clippy.log,
target/windows-crt-host-tools.log and target/windows-crt-host-{threads,api}.log.
Owned Rust formatting/item spacing, Python ruff format/check, and the comment-only
Jai fixture's formatter/check plus rebuilt strict jailint all pass. The metadata
regression intentionally parses the pinned rustc dependency report and fails if
that report changes or is absent; it never counts absent metadata as success.

No peer writes, raw CI logs, vendor Jai bodies, old/quarantined source or history
were used. The reviewed prefix-cast grouping update is reflected separately in
cast-shift-widths.md; narrow shift promotion remains unspecified, with no fake fix.
