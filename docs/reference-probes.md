# Bounded reference probes

## What it is

A separately dispatched, narrow execution experiment for the original compiler after static inspection and the user's authorization to run it in GitHub CI. It runs only version/help on a disposable native ARM64 macOS runner; original reference code is never executed on the development machine.

## How it works

The workflow requires a successful hosted static-analysis run, downloads the authorized release asset, then verifies its exact SHA-256 again. The helper rejects local, self-hosted, non-macOS and non-ARM64 environments. Environment checks prevent accidental local invocation; they are not cryptographic host attestation.

Apple's `sandbox-exec` denies operations by default. The profile allows executing only the original compiler, reading the root directory itself, that binary and necessary system libraries, writing a temporary scratch directory, and basic system/Mach services. Network operations and additional executable launches remain denied. Mach lookup is permitted for system initialization, so this is not a claim of complete isolation from all OS services.

A trusted `/usr/bin/printf` control must succeed under the same policy before reference execution. Captured output files live inside the allowed scratch directory. No system logs or crash reports are exported.

The child receives a minimal environment without GitHub tokens, a disposable home/current directory, no stdin, ten CPU seconds, fifteen wall seconds, restricted descriptors and capped output file sizes. Its return code, stdout/stderr, timeout state, sandbox profile and scratch-file list become retained evidence. A timeout or nonzero status fails the experiment rather than relaxing the sandbox automatically. These observations do not prove harmlessness or full compiler compatibility.

## How to change it

Change `tools/probe_reference.py` and `.github/workflows/reference-probe.yml` together. Keep command scope and binary digest explicit, and retain separate static and execution workflows. Additional source compilation, native library loading and compile-time execution require inspected inputs and a reviewed experiment. Do not convert hosted runner checks into a host-execution bypass.

The initial run [36940827475](https://github.com/matteopolak/jai/actions/runs/36940827475) aborted both probes with signal 6 and no output. Its harness mistakenly captured output outside the writable scratch directory; fixing that path does not relax the sandbox. The corrected run [36941278406](https://github.com/matteopolak/jai/actions/runs/36941278406) also aborted a trusted system control and refused reference execution, showing that the failure was not specific to Jai. Local controls using only Apple's `printf` then isolated a missing read rule for the root directory itself. Adding `(literal "/")` permits that directory only, without granting descendant-file contents. The control succeeded with this narrow rule; the hosted retry established that the original compiler starts. [Run 36941991158](https://github.com/matteopolak/jai/actions/runs/36941991158) passed the trusted control, then both Jai flags exited 1 because `reference/modules/Preload.jai` was absent. The compiler created only `.build/.added_strings_w1.jai` in the scratch directory. The missing bootstrap is an input limitation, not evidence of malicious behavior or a successful version/help result.

A separate trusted local `cat` control confirmed that the root-directory read rule still denies contents of an inert file outside the allowed scratch directory while permitting the file inside it. A separately compiled, independently written socket control connected to an inert localhost listener without the sandbox, then failed with `EPERM` under the same policy. This checks direct socket denial; it does not establish that every Mach service is unable to proxy network activity. These local controls used installed Apple commands and our own inert test program; no provided compiler or library ran locally.

The inspected bootstrap is `modules/Preload.jai`, 13,612 bytes, SHA-256 `1d00c2ecde58c5362c8e2edf978d57eb490a39076eb6ebf7d118a9811a851904`. It contains type declarations/compiler intrinsics, no imports, loads or `#run` directives. The user declined all uploads of original reference source. No bootstrap-source asset has been uploaded, and the hosted version/help experiment remains blocked by this missing input. Keep all original reference source local; existing public compiler-binary inspection remains separate.

## Configuration

Dispatch `gh workflow run reference-probe.yml --repo matteopolak/jai -f audit_run=36939979892`. The job has a five-minute limit, and evidence is retained for fourteen days. The release tag and compiler hash are fixed to the inspected 0.2.009 distribution.

## Dependencies

Python 3.14 standard library, Apple's native `sandbox-exec`, GitHub's ARM64 `macos-15` runner, official Actions, and the authorized reference compiler release asset. No personal tokens or repository secrets are supplied to the original program.
