# Bounded reference probes

## What it is

A separately dispatched, narrow execution experiment for the original compiler after static inspection and the user's authorization to run it in GitHub CI. It runs only version/help on a disposable native ARM64 macOS runner; original reference code is never executed on the development machine.

## How it works

The workflow requires a successful hosted static-analysis run, downloads the authorized release asset, then verifies its exact SHA-256 again. The helper rejects local, self-hosted, non-macOS and non-ARM64 environments. Environment checks prevent accidental local invocation; they are not cryptographic host attestation.

Apple's `sandbox-exec` denies operations by default. The profile allows executing only the original compiler, reading that binary and necessary system libraries, writing a temporary scratch directory, and basic system/Mach services. Network operations and additional executable launches remain denied. Mach lookup is permitted for system initialization, so this is not a claim of complete isolation from all OS services.

The child receives a minimal environment without GitHub tokens, a disposable home/current directory, no stdin, ten CPU seconds, fifteen wall seconds, restricted descriptors and capped output file sizes. Its return code, stdout/stderr, timeout state, sandbox profile and scratch-file list become retained evidence. A timeout or nonzero status fails the experiment rather than relaxing the sandbox automatically. These observations do not prove harmlessness or full compiler compatibility.

## How to change it

Change `tools/probe_reference.py` and `.github/workflows/reference-probe.yml` together. Keep command scope and binary digest explicit, and retain separate static and execution workflows. Additional source compilation, native library loading and compile-time execution require inspected inputs and a reviewed experiment. Do not convert hosted runner checks into a host-execution bypass.

## Configuration

Dispatch `gh workflow run reference-probe.yml --repo matteopolak/jai -f audit_run=36939979892`. The job has a five-minute limit, and evidence is retained for fourteen days. The release tag and compiler hash are fixed to the inspected 0.2.009 distribution.

## Dependencies

Python 3.14 standard library, Apple's native `sandbox-exec`, GitHub's ARM64 `macos-15` runner, official Actions, and the authorized reference compiler release asset. No personal tokens or repository secrets are supplied to the original program.
