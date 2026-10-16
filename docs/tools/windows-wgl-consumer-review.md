# Windows WGL consumer companion review

Integration reviewed the user-supplied new-only patch
`windows-wgl-consumer-449.patch`, SHA256
`14642ec676c37616468117a7324625ec66fb10331527eb0441110ee4f2cad372`,
against shared `d36e7005`. Adoption is held until its producer ready receipt
matches the transported patch and exact source/test hashes. The first receipt
named `55cde940...`; a later producer update names `5af35db7...`. Neither
matches the authorized transported patch. No shared WGL tool/workflow source
change has been made on the strength of these inconsistent receipts.

The two proposed workflow changes add `--consumer-dir native-exes` to the
existing x64 and ARM64 WGL commands. Exact hunks pass `git apply --check` over
the current workflow. They preserve the e50 provider helper builds, source and
artifact hashes, normal DLL PATH setup and real loader/export/file-identity
checks. The workflow must not be replaced with the older producer version.

The deployment helper requires both Mesa frontend and backend DLLs, rejects
duplicate case-insensitive names, nonregular/symlink inputs and mismatched PE
CPU types, and validates all inputs before copying. It copies the same curated
DLL set beside the compiler, WGL diagnostic executables and separate wheel
consumer executables, then checks every copied byte hash. This addresses a
distinct executable-directory loader boundary; merely setting the interpreter's
foreign-library search path does not establish native consumer loading.
PE headers and copy hashes establish configuration/integrity, not runnable
driver validity or complete transitive dependency discovery. Real Windows
loader/WGL tests remain required.

The proposed lint inputs select the eight owned public module entry files,
existing private implementation entries and all four WGL/render fixture roots.
Loaded implementation lint remains in its target module context, with
`-D warnings` unchanged. Recursive discovery of unrelated Cocoa test programs
does not constitute Windows product-root coverage. The broader test suites and
Mac coverage remain required; none of their old failures is reclassified as a
pass.

Source review confirms the existing driver, public-events, public-renderer and
lifecycle interpreter/native O0/O2 paths remain. Driver capability/version and
loaded-file identity checks, fatal subprocess/lint/timeout outcomes, the direct
signed-wheel regression and separate public wheel O0/O2 steps remain intact.
There is no GL version override, fake driver, guard removal or assertion waiver.
The independently authored COFF-header fixtures and mocked process results in
the new unit tests are configuration evidence only and are never executed as
DLLs or counted as Windows runtime successes.

Costs and limitations: each consumer receives a full driver DLL copy plus hash
reads; a copy failure may leave partial output files, while remaining fatal.
No rollback or generalized dependency resolver is supplied. A failed WGL step
keeps the workflow failed even if later independent steps execute. Real x64
driver/render successes reported by root for CI449 remain historical evidence;
its separate wheel-output-directory context failure and Cocoa lint discovery
failure remain preserved. This companion has no new Windows runtime evidence.

The immutable product stays `e0e287ea`. No compiler, library, native asset or
tool rebuild is required for this CI-only change. The main constant/runtime
repair and typed-module-contract/scheduler repair need separate stable coherent
handoffs and combined replay before the next product candidate.
