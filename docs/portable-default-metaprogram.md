# Portable default build workflow

Shared loader integration: custom requests and the correctly parameterized Check
request now pass to public Metaprogram_Plugins.init_plugins. The previous private
CLI-only static-import generator is removed; no separate factory/registration
context remains. Input option arrays stay borrowed through setup/lifecycle and
real factory pointers append directly to the mutable public plugins array.
Generic initializer status aggregates as reviewed; failure still logs/stops target
work through Default's exit0 path. Per-plugin early short-circuiting was not an
established Default contract and is not restored as a private convenience.

The linter's program context performs real empty initialization before checking
all original Default bodies. This satisfies the generic module's declared
deferred-definition import obligation; it does not fake a plugin, skip an assertion
or filter any failed body. Generated lint contexts are normalized and --check
verified. Real Default executions independently exercise nonempty factories and
native target outputs. Evidence target/default-shared-plugins-final.log.

Parent phase correction: build() now uses the reviewed set_build_options_dc with
do_output=false, preserving its parent's static output type/name/path and existing
dynamic write/extension settings. Parent debugger changes also use that dynamic
API. No late frozen Build_Options mutation remains. Both normal compiler invocation
and interpreter build-driver mode produce real native child artifacts through
Compiler workspace APIs; an existing target is deleted before the interpreter
case to prove it is recreated. Target O0/O2 is explicitly selected with reviewed
-very_debug/-od options; paths/callbacks retain native O0/O2 tests. No new compiler
semantic exception or CLI child-process bypass. Full workflow, parent-state
assertions and strict lint pass in target/default-dynamic-options-final.log.

Current2026-10-15 Check integration is RESOLVED: the NEW tools producer supplies
the reviewed persistent get_plugin factory and CHECK_BINDINGS module parameter.
Default imports the exact true/false instance lazily in its private factory, and
the runner stages the complete real Check engine/porting/binding dependency set.
Ordinary builds, both binding flags, default help/version, custom plugin ordering,
no_check/replay/option/error cases and full owned strict lint now pass. Earlier
missing-factory descriptions below are historical evidence, not active blockers.

Test correction, separate from production: argument-dependent fixture procedures
are invoked by ordinary `-add '#run,stallable run_build();'` compiler input. This
executes the same real D.build workspace workflow and all replay assertions;
neither target construction nor callbacks are bypassed. Lint checks callable
fixture bodies without executing an invalid zero-input build. Explicit empty-input
and no_check-only invocations still must exit1. No test/diagnostic suppression or
compiler source-name exception. Full command:
`python3 -B tools/check_portable_default_metaprogram.py`;
evidence target/default-metaprogram-check-integrated.log.

Remaining compiler execution limits: a .X64 backend request builds with the
single LLVM code generator, and the interactive debugger is unsupported; selected-workspace command-line readback has
the corrected generic reproducer. These are separate from the now-working normal
default CLI workflow and its passed source/lint gate. Native other OS/combined
baseline are coordinator gates, not claimed here.

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

Parser audit correction: plugin import generation must parse grouping without
performing user-facing actions. A new regression first observed duplicate release
warnings (target/default-deprecation-red.log). The private parser now separates
action reporting/global verbose mutation from its generation pass; each deprecated
alias warns once and invalid context sizes report only during the actual build.
The complete -no_check behavior gate reruns successfully; the strict lint stage
still fails exclusively on the missing Check factory. No test expectation was
weakened or compiler/module exception introduced.

Ownership replay correction: shutdown previously freed the plugin array by value
without clearing the public descriptor. The new build-twice fixture first failed
after shutdown because it retained freed storage (target/default-build-twice-red.log).
Cleanup now uses reviewed Basic.array_reset, so each actual build finishes with
an empty descriptor and a second workspace/plugin lifecycle runs safely. The full
no_check workflow/replay passes; full strict lint still has only the Check factory
dependency. No lifecycle registry, caller patch or new public API is introduced.

Public Example_Plugin is now implemented, including canonical My_Plugin, initial
some_state=0 / init=33, repeated option/value parsing, all lifecycle callbacks,
phase/typecheck/completion reporting and allocation ownership through shutdown.
Its state increments once per message, allowing finish to report the count without
extra public fields or an external address registry. Option values only print.
`python3 -B tools/check_portable_example_plugin.py` passes interpreter/native O0/O2
public behavior tests, real default-workspace +Example_Plugin builds/runs, and
strict lint. Format/--check passes both owned files. No byte-for-byte diagnostic
prose claim. Inventory120 missing rows after this complete ten-entry module.
