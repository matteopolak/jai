# Reference inspection results

## What it is

Observed static evidence for the supplied Jai 0.2.009 macOS compiler, recorded on 2026-10-01. The analysis does not certify that the compiler is harmless or reconstruct its complete runtime call graph.

## How it works

The local audit inspected six supplied compiler/linker files and eight architecture slices. [Hosted run 36939979892](https://github.com/matteopolak/jai/actions/runs/36939979892) repeated the macOS compiler inspection on a fresh ARM64 macOS VM and matched the local instruction counts. The uploaded compiler's SHA-256 is `a76ba6e153838a81e3ed4edbcc4ec42ad86c333cdeaf4053fdc592ed0b61600e`.

| Compiler slice | Observed direct calls | Unresolved indirect calls | Undecoded instructions |
| --- | ---: | ---: | ---: |
| ARM64 | 510,883 | 37,137 | 0 |
| x86-64 | 505,758 | 46,664 | 326,855 |

Undecoded x86 instructions can include embedded data/padding and are not evidence of maliciousness. Named symbols and executable-section disassembly still leave callbacks, indirect dispatch, dynamically loaded code and generated code unresolved.

Observed capabilities include process launch (`system`, `execv`, `execve`, `posix_spawn`), native loading (`dlopen`), environment access, and file creation/modification/removal. A direct static path reaches `dlopen` through the bytecode runner's foreign-symbol resolution. Another reaches `unlink` through LLVM interruption cleanup. `system` has a call site in a command-running wrapper, but the direct graph does not prove a path from `main`; absence of a direct path does not prove unreachability.

These uses are consistent with compiler infrastructure as an inference from symbol names and call paths, not a safety conclusion. No ordinary socket/connect/send/receive import matched the inspected Mach-O import table; dynamically loaded code can still use networking. Ad-hoc code signing does not authenticate the public author's identity. Native libraries, objects and installers require their own inspection before proposed execution.

## How to change it

Repeat the hash and static workflow when input bytes or inspection tools change. Preserve unresolved-call counts and report uncertainty explicitly. Extend actual target resolution instead of labeling an import table a complete call graph. Bounded version/help experiments are recorded separately in [reference probes](reference-probes.md).

## Configuration

The static workflow inspects both slices of the universal macOS file using LLVM 22. Reports and call tables are retained for fourteen days as GitHub artifacts and locally under `artifacts/audit/github-36939979892/`. Earlier full-distribution reports remain under `artifacts/audit/`.

## Dependencies

The supplied compiler bytes as data, independently installed LLVM/file/lipo/otool, the [inspection tools](binary-inspection.md), and GitHub's hosted VM. Runtime observations cannot replace these static limitations or establish a guarantee of safety.
