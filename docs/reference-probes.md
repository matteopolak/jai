# Bounded reference probes

## What it is

A separately dispatched, narrow execution experiment for the original compiler after static inspection and the user's authorization to run it in GitHub CI. It now runs only the statically identified developer-help command (`-- help`) on a disposable native ARM64 macOS runner; original reference code is never executed on the development machine.

## How it works

The workflow requires a successful hosted static-analysis run, downloads the authorized release asset, then stages the explicitly authorized vendored bootstrap and verifies both exact SHA-256 values again. The helper rejects local, self-hosted, non-macOS and non-ARM64 environments. Environment checks prevent accidental local invocation; they are not cryptographic host attestation.

Apple's `sandbox-exec` denies operations by default. The profile allows executing only the original compiler, reading the root directory itself, that binary, the single staged `Preload.jai` file and necessary system libraries, writing a temporary scratch directory, and basic system/Mach services. Network operations and additional executable launches remain denied. Mach lookup is permitted for system initialization, so this is not a claim of complete isolation from all OS services.

A trusted `/usr/bin/printf` control must succeed under the same policy before reference execution. Captured output files live inside the allowed scratch directory. No system logs or crash reports are exported.

The child receives a minimal environment without GitHub tokens, a disposable home/current directory, no stdin, ten CPU seconds, fifteen wall seconds, restricted descriptors and capped output file sizes. Its return code, stdout/stderr, timeout state, sandbox profile and scratch-file list become retained evidence. A timeout, unexpected status or output fails the experiment rather than relaxing the sandbox automatically. This exact build prints the identified developer-help text and exits 1: the check requires that status, the exact help stdout, empty stderr and no timeout. Other status-1 errors do not pass. These observations do not prove harmlessness or full compiler compatibility.

## How to change it

Change `tools/probe_reference.py` and `.github/workflows/reference-probe.yml` together. Keep command scope and binary/bootstrap digests explicit, and retain separate static and execution workflows. Additional source compilation, native library loading and compile-time execution require inspected inputs and a reviewed experiment. Do not convert hosted runner checks into a host-execution bypass.

The initial run [36940827475](https://github.com/matteopolak/jai/actions/runs/36940827475) aborted both probes with signal 6 and no output. Its harness mistakenly captured output outside the writable scratch directory; fixing that path does not relax the sandbox. The corrected run [36941278406](https://github.com/matteopolak/jai/actions/runs/36941278406) also aborted a trusted system control and refused reference execution, showing that the failure was not specific to Jai. Local controls using only Apple's `printf` then isolated a missing read rule for the root directory itself. Adding `(literal "/")` permits that directory only, without granting descendant-file contents. The control succeeded with this narrow rule; the hosted retry established that the original compiler starts. [Run 36941991158](https://github.com/matteopolak/jai/actions/runs/36941991158) passed the trusted control, then both Jai flags exited 1 because `reference/modules/Preload.jai` was absent. The compiler created only `.build/.added_strings_w1.jai` in the scratch directory. The missing bootstrap is an input limitation, not evidence of malicious behavior or a successful version/help result.

A separate trusted local `cat` control confirmed that the root-directory read rule still denies contents of an inert file outside the allowed scratch directory while permitting the file inside it. A separately compiled, independently written socket control connected to an inert localhost listener without the sandbox, then failed with `EPERM` under the same policy. This checks direct socket denial; it does not establish that every Mach service is unable to proxy network activity. These local controls used installed Apple commands and our own inert test program; no provided compiler or library ran locally.

The inspected bootstrap is `modules/Preload.jai`, 13,612 bytes, SHA-256 `1d00c2ecde58c5362c8e2edf978d57eb490a39076eb6ebf7d118a9811a851904`. It contains type declarations/compiler intrinsics, no imports, loads or `#run` directives. The user subsequently authorized uploading this file into a vendor folder. It is preserved byte for byte at `vendor/jai-0.2.009/modules/Preload.jai`, with origin and hash in `vendor/README.md`. The workflow stages it at the original compiler's expected `reference/modules/Preload.jai` path, and the helper allows read access to that exact file only. Other reference source remains local. The initial vendored retry [36947152030](https://github.com/matteopolak/jai/actions/runs/36947152030) verified both hashes and passed the trusted control. Both provisional flags still exited 1, now requesting the implicit `Runtime_Support` module. Static strings identify `-- help` as the actual developer-help command; the next probe uses only that command. The corrected [run 36947390075](https://github.com/matteopolak/jai/actions/runs/36947390075) printed the exact developer-help text, exited 1, produced no stderr and created no scratch files. Its workflow initially classified all nonzero statuses as failure; the helper now checks this exact observed command result. A final workflow retry is pending. There is no verified standalone version flag. No additional reference source has been uploaded.

## Configuration

Dispatch `gh workflow run reference-probe.yml --repo matteopolak/jai -f audit_run=36939979892`. The job has a five-minute limit, and evidence is retained for fourteen days. The release tag and compiler/bootstrap hashes are fixed to the inspected 0.2.009 distribution. `.gitattributes` disables line-ending normalization for the vendored bootstrap so hosted bytes match the inspected file.

## Dependencies

Python 3.14 standard library, Apple's native `sandbox-exec`, GitHub's ARM64 `macos-15` runner, official Actions, and the authorized reference compiler release asset. No personal tokens or repository secrets are supplied to the original program.
