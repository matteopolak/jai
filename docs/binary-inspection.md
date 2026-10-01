# Static binary inspection

## What it is

A reproducible inspection workflow that reads supplied executable bytes without loading or running them. It produces evidence for a later, explicit execution decision; it does not certify safety.

## How it works

`python3 tools/audit_reference.py` hashes the six compiler/linker binaries, reads headers/imports, splits universal macOS binaries into temporary architecture slices, and streams all executable-section disassembly into call/branch tables. Temporary slices are data inputs to trusted LLVM tools, never subprocess executables. Indirect calls and undecoded instructions are counted explicitly. PE binaries can be stripped; their graph retains address-based targets rather than invented function names.

Reports go to `artifacts/audit/`. `report.json` contains hashes, counts, imported capability candidates and warnings. Headers and gzip-compressed call tables retain supporting evidence. The report's direct/indirect counts describe observed instructions, not a complete proven runtime call graph.

After the tables exist, `python3 tools/analyze_macos_calls.py` resolves ARM64 Mach-O import-stub addresses, records sensitive API call sites and finds direct static paths from `_main`. It verifies the original binary hash before using that graph. Missing paths do not establish unreachability through callbacks or worker scheduling. Undecoded-instruction counts can include embedded data and padding and are not evidence of maliciousness by themselves.

## How to change it

Extend format/architecture decoding and import resolution with fixtures. Trace startup paths and calls to process execution, filesystem mutation, native loading, networking and environment access before recommending VM execution. Imports alone do not establish whether a path is reachable or malicious. A report with unresolved indirect calls cannot claim that all possible calls have been cleared.

The user later authorized the supplied macOS compiler as a release asset for CI. The [GitHub inspection workflow](github-analysis.md) verifies its digest and repeats static analysis on a fresh ARM64 hosted VM; the source distribution remains local.

## Configuration

`--binary bin/jai-macos` limits inspection to a specific relative path and can be repeated. `--reference` selects the input tree; `--output` selects evidence storage outside that tree. No option executes the inspected file. Audit binary hashes must match the bytes later transferred into the guest.

## Dependencies

Python 3, independently installed `file`, LLVM `llvm-readobj`, `llvm-nm`, `llvm-objdump`, and macOS `lipo` for universal slices. Bundled third-party libraries and installers require separate inspection if execution is proposed; the preferred workflow rebuilds public third-party libraries from inspected sources instead.
