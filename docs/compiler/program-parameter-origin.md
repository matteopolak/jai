# Program parameter origin

PROGRAM arguments in an import's second list belong to the main program of the
relevant compiler workspace. An imported module cannot configure them. Root's
sanitized official Jai 0.2.030 verdict rejects the independent non-main provider
controls and accepts the child-root-only configuration. No reference bodies,
raw reference logs or binaries were accessed by this worker.

Previously the import parser flattened both lists and discarded their boundary.
The module loader consequently accepted second-list arguments from imported
modules and recorded their named settings for speculative binding.

`Import.program_params_start` now retains the second-list offset while keeping
the existing argument representation for consumers. Import declaration and
resolution validate origin before recording or evaluating arguments. The rule
compares the importing scope's module with `Compiler.main_module`; filenames,
module names, visibility and whether an import has a namespace do not grant
privileges. Speculative program-setting collection is limited to main ownership.

Files loaded into main, additional main source strings and generated main inputs
retain main ownership. Imported files, anonymous string imports, loaded files
inside imported modules and generated module-scoped inputs remain non-main.
Each workspace compiler owns its own main module. Ordinary module arguments in
the first list remain available to imported modules. Existing typed header
contracts, argument binding, nominal instance identity and conflicting-setting
checks are unchanged; this patch does not introduce early configuration
discovery, configuration overwrites or type unification.

## Verification

[The exact receipt](../status/compiler-program-parameter-origin.json) pins the
accepted `bfbc8b9a` source, changed inputs, tools and captures. Two independent
origin tests fail before the repair. Afterward, seven new origin tests and 94
existing module, typed-program configuration and callable-metadata tests pass.
One parser boundary test, scoped Rustfmt and Clippy with warnings denied pass.

The stdlib owner's independently authored negative fixtures were copied without
byte changes into the worker's T7 test directory. Source-matched CLI checks now
reject the non-main Basic setting with the main-program diagnostic and retain
the competing-main conflict diagnostic. Independent Basic main and loaded-main
positives compile successfully. No stdlib or application source was changed.

## Proof boundaries and coordination

Independent compiler instances test workspace ownership and generated input
separation. Actual public NO_OUTPUT child-workspace protocol replay remains a
root/numerics integration check; root's official child-root acceptance supplies
the reviewed contract, not a claim that this worker executed that protocol.
No native executable, GUI, deliberate fault or benchmark program was run.

At the initial checkpoint, the flat argument binding representation remained unchanged. That repair
validates second-list origin and preserves existing duplicate/mixed-binding
rejections; it does not claim a complete new argument-list category checker.
Code export/source printing belongs to another owner. That owner has been
notified to preserve the new boundary marker during its round-trip work; no
exporter or printer functions were modified at that checkpoint. The
[import argument-group follow-up](import-argument-groups.md) now supplies the
owned export/printing propagation and declared-slot checks. IDE discovery memoization,
linker options, pthread routing, default-Type initialization and Any boxing are
unchanged from the accepted base.
