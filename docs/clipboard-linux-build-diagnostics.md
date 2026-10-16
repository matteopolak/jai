# Linux Clipboard native-build diagnostics

CI run 38937373866/job 117096152467 cleared the earlier Rust provisioning issue.
Coordinator-filtered results show real X11 C clients passed at O0/O2, but both
`linux-jai-build` commands failed. The exact compiler error was not included in
that summary, and no artifacts were uploaded. Package verification correctly
refused the failed prerequisite. C success is not Jai runtime or package success.

The required Jai build is in `tools/check_portable_clipboard.py`: the newly
source-built compiler builds `tests/portable-stdlib/clipboard-linux-roundtrip.jai`
at O0/O2 with the source-built native Clipboard directory in `JAIC_NATIVE_LIBS`
and `LD_LIBRARY_PATH`. Its complete argv, exit status, stdout and stderr already
go to private `commands.json`; formerly CI printed only a check name and FAIL.

Failed commands now emit a bounded compiler/linker headline summary on stderr.
Full output remains in the existing private receipt. A separate
`failure-diagnostics.json` contains only bounded headlines, check names and exit
statuses. It does not contain argv, environment or source-context bodies.
The filter removes terminal controls and credential-like assignments, includes
Clang/GNU/lld/LLVM headlines, and limits each diagnostic body to 4 KiB. Unknown
output is not dumped: the summary points to its preserved full capture instead.
This can truncate a long diagnostic; the full private receipt is authoritative.
Do not upload raw commands/summary receipts as public artifacts.

Stdout still ends with the same receipt path, preserving the workflow's package
handoff. Relocated-package prerequisite rejection prioritizes the failed native
Jai build diagnostics and remains fatal. Later package-command failures report
bounded headlines instead of dumping the entire raw result dictionary.
The requirement for a passing real Linux runtime receipt, source/compiler hashes,
relocation, actual interpreter/O0/O2 execution and missing-helper negative remains
unchanged. No native success, build status or expected output has been substituted.

Focused verification consists of seven diagnostic/package rejection unit tests,
the nine existing workflow/toolchain configuration tests, Ruff and whitespace
checks. Synthetic failed command metadata tests diagnostic policy only; it is
never presented as a successful native SDK or runtime proof. Local Jai/native,
GUI, fault and X11 execution were not run under root's held native lease.

No Clipboard production code changes are justified before the actual new build
error is captured. Integration owns patch adoption and CI dispatch. Rerun the
existing real Linux runtime/package job promptly with this diagnostic patch;
its failed build headers should now be visible without waiting for a broad CI
matrix. Any new production/compiler/dependency repair must follow those facts.
Please add the diagnostic module/test to workflow path filters and run the new
unit test alongside the existing toolchain test; the real runtime/package steps
need no change. Global docs indexing also belongs to integration.


The diagnostic test creates its assigned `TMPDIR` or `CARGO_TARGET_DIR` before allocating captures. CI runs these unit checks before build preparation, so that directory need not exist yet. It never selects an internal-disk fallback.
