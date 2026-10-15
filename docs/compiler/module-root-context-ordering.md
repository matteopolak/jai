# Module-root lint and context registration

The independent Context_Probe originally executed successfully as a program but
failed strict module-root lint with `#add_context after the Context type was laid
out`. Module-root lint completed a synthetic empty program before loading the
requested module. Bootstrap export lowering could therefore finalize Context
before the module registered its fields. Bootstrap `#run` queries could cause the
same ordering problem even without that export lowering.

The compiler now exposes its existing source-loading phase as the Rust method
`prepare_sources`. Ordinary `begin_sources` still loads and settles immediately,
and ordinary `compile_sources` still finishes afterward. No public Jai API or
bootstrap parameters change.

Module-root lint uses this sequence:

1. Prepare bootstrap and the synthetic root's declarations, including configured
   supplemental source strings.
2. Expand imports so bootstrap/configured module instances are known, retaining
   their actual parameter bindings.
3. If the requested module is absent, add the existing synthetic module-root
   import from its normal lexical location.
4. Settle top-level code and finish once, after context registration.

The existing canonical-path test identifies an already configured root; it does
not introduce a second instance or guess parameters. Import privacy and source
visibility use the existing resolver. Requested bodies still undergo the normal
lint audit and failures remain errors. Compile-time evaluation required by
ordinary import arguments/expansion is unchanged; Context cannot be extended
after its layout has actually been used.

Original regressions cover the integrated producer, bootstrap Context queries,
configured private imports, supplemental configured imports, one registered bool
field (size1), invalid requested bodies, and application rejection of private
imports. A core regression explicitly finalizes Context and confirms that a later
add_context is still rejected.

Verification on Mac ARM64: the producer passes strict lint as both module and
program, interpreted execution, and actual native O0/O2 execution. Scoped Rust
tests pass:165 core library,11 layout,9 reflection,2 catalogue CLI,10 library-root
lint,11 target-aware lint,4 overload-audit tests, plus11 jailint library tests.
Rust/Jai formatting, item spacing and warnings-denied all-target clippy pass.
Evidence remains in artifacts/compiler-mac-repairs/context-*.log and the native
producer executables. This is independent compiler/tooling verification, not a
claim that full generator/profiler integration or other catalogue prerequisites
have been rerun. Their owner can consume this checkpoint without exclusions.

Generator-platform integration provenance: only the compiler-owned general
source/test hunks of clean commit e9affab7 were applied here, not the overlapping
model-worker fix. The local older Options test constructor was adapted to its
existing target_os/target_cpu/add_sources fields. Local replay passes all ten
cleanroom_library_roots tests, the specific late-context rejection regression,
strict module-root lint of both the minimal original pointer-context module and
Bindings_Generator, and interpreter/native O0/O2 of both original context producers.
This paragraph records local integration evidence; the larger preceding test
counts are the compiler owner's checkpoint report.
