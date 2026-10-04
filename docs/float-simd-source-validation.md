# Float and SIMD validation

## What it is

This checkpoint validates the rewritten compiler's scalar domain API and actual native Float/SIMD helpers independently of the integration build. Separate source-only checks record current acceptance boundaries for unchanged supplied and pinned upstream modules.

## How it works

[Scalar checkpoint](../artifacts/component-checkpoints/scalar-domains-20261002/validation.json) records source hashes for a private five-crate dependency closure. Its pinned nightly runs pass 40 evaluator tests and strict all-targets Clippy. The captured source includes the final diagnostic parity correction and eight new domain regressions; the live integration branch may be one activation step behind that snapshot.

[Native checkpoint](../artifacts/component-checkpoints/float-simd-native-20261002/validation.json) contains the actual copied `native_simd.rs` and float constant helper with real `jai-ir`, `jai-types`, and `jai-source` dependencies. Five tests validate raw IEEE payload bitcasts, unaligned vector accesses and reinterpretation, actual Linux SIMD object instructions at O0/O2, ARM64 breakpoint instruction bytes at O0/O2, and rejection of wrong architectures or disabled SSE2/AVX/AVX2. Generated objects are inspected without linking or executing them. Helper-only strict Clippy passes with `--no-deps`; dependency-inclusive strict Clippy encounters 47 existing large-error/enum warnings in the captured `jai-ir` closure.

The [original-source receipt](../artifacts/component-checkpoints/scalar-domains-20261002/original-source-checks.json) freezes the rewritten CLI by SHA-256 and checks genuine unmodified modules with genuine search paths and Preload. Upstream Math parses and passes `check-library`. Supplied Float16 and Math encounter parser diagnostics in that CLI snapshot. The SIMD example parses but fails checking in its Basic dependency at missing `Calendar`; the standalone upstream SIMD test parses but requires its actual `expect_program_output` harness binding. These failures remain failures; neither synthetic modules nor replacement harness declarations establish acceptance.

The [refreshed original-source receipt](../artifacts/source-checks/float-simd-20261002T1756/original-source-checks.json) repeats those five genuine source checks against the rewritten CLI rebuilt at 17:56. It confirms the same boundaries after the modular checkpoint: the canonical record-member route still lacks `#place` dispatch, and local anonymous union storage still fails statement parsing. Those remaining grammar gaps are assigned to the record and frontend owners.

These are component and source-only results. They do not establish integrated workspace acceptance, reference compiler parity, full original-library specialization, or x86 execution on an ARM host.

## How to change it

A production change requires a fresh snapshot and input hashes. Do not modify the captured source and retain its old validation receipt. Re-run the source-only checks with a freshly built rewritten CLI after parser/dependency changes, recording its immutable fingerprint and original source hashes. Preserve the actual module dependency graph and report missing harness context separately from ordinary application compilation.

## Configuration

Checks use `nightly-2026-08-29`, `--offline --locked -j1`, `RUSTC_WRAPPER=`, `CARGO_INCREMENTAL=0`, and a private Cargo target directory. Native tests use `LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm`. All 18 external native-helper package versions and checksums match the repository's approved lockfile. Source checks select the genuine module paths, `JAI_RS_PRELOAD=search`, and `JAI_RS_RUNTIME_SUPPORT=off`.

## Dependencies

The scalar component needs `jai-source`, `jai-types`, `jai-lexer`, `jai-syntax`, and `jai-eval`. Native proofs need `jai-ir`, Inkwell, and trusted LLVM 22. Original source checks use only the rewritten `jai-rs` CLI and read-only Jai sources. No original executable, native object, native library, or upstream test command is loaded or executed.
