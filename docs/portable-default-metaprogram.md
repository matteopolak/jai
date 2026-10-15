# Portable default build workflow

The reviewed Default_Metaprogram contract is the API oracle. The implementation
separates command-line classification, compiler option projection and intercepted
workspace execution. Plugin imports are generated as ordinary Jai declarations
at compile time, preserving module parameters and the compiler's module resolver.
There is no alternate compiler CLI path and no synthetic completion event.

Verification will exercise the public build entry in a stallable run directive,
actual target executables and independently authored plugins which observe option
state and callback ordering. Invalid flags, missing inputs, plugin initialization
failure and target compilation failure are distinct outcomes.

Dependency audit: the newly owned Check producer currently exposes only Windows
checking routines and no get_plugin factory on Mac. This does not satisfy the
reviewed default plugin workflow. Its repair belongs to stdlib-tools; explicit
`-no_check` tests can verify the remaining workflow but cannot establish default
Check integration. Compiler option forwarding is independently verified rather
than inferred from fields stored by its public wrapper.

Executed `python3 -B tools/check_portable_default_metaprogram.py` against the
corrected source-built compiler on the assigned T7 target. Path tests pass in
interpreter and native Mac O0/O2. Actual executable generation, inferred/explicit
destinations, source-relative import directories, added/run input, option
projection, parameterized two-plugin imports, callback ordering, help/version,
invalid options/missing input, failed init (exit 0) and invalid target (exit 1)
pass. Target O2 is exercised by the reviewed `-o` option.

The same command intentionally remains nonzero at its full strict-lint gate:
Check.get_plugin is absent. All newly owned Jai files pass repository jaifmt
formatting and --check. The negative target fixture is compiler input whose
unknown-name diagnostic is required, not a lint-positive program; positive lint
inputs are listed explicitly. No blanket rule suppression or assertion reduction.
The source-built tools adopted compiler corrective checkpoint 1929d5a; the original
constant-alias assignment probe now rejects correctly. Prior acceptance evidence
is retained. The general target-command-line reproducer still fails its genuine
assertion. See [dependency request](default-metaprogram-dependency-request.md).

Remaining: ordinary default Check integration, binding-check configuration,
compiler execution of stored-only option fields, real X64-backend/debugger
support, combined baseline rerun, native Windows/Linux. No combined Mac failure
reduction is claimed from these staged runs. Stable coordinator baseline remains
822 passed / 7 failed until rerun. Inventory credits five public entries; build
is retained as incomplete among 130 missing rows.
