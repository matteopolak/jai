# Generator naming worker inbox

## Android build orchestration draft handoff

Independent Gradle entrypoints are integrated through `gradle-api.jai` and
private `android-gradle.jai`: `run_gradle_task`, `gradle_install_apk`, deprecated
`android_generate_apk(project_path, release)`, and verbosity storage. All18
commands in `tools/verify_android_gradle.py` pass with own source-built T7 tools,
actual formatter, interpreter/Mac ARM64 O0/O2 and cross-target source/strict-lint
checks. Fixture installation commands always fail; task selection and failure
propagation are verified without claiming a real installation.

Build-options overloads remain unintegrated drafts in `build-api.jai` and private
`android-build.jai`; formatting passes but compilation/execution is blocked by
the absent crypto-owned canonical signing-key model. No duplicate model exists.
Handmade mode stages a real unsigned ZIP using canonical manifest/ZIP writers,
then explicitly fails at the missing canonical signing primitive. Command-line
draft invokes actual tool processes; its pending signer fixture always fails
and only inspects unsigned ZIP staging. No fake signing/installation success.
Exact per-overload status: `docs/status/android-build-remaining.json`; independent
path/fallback policies and limitations: `docs/android-build.md`. Parent owns all
commits; these files are uncommitted drafts pending review.

Current status: all eight naming helpers are complete at 83ba1961. The active
reassigned batch is Android host orchestration; see the latest dependency handoff.

## 2026-10-15 — baseline 7467b49d: reviewed naming contract gaps

The reviewed module spec inventories all eight owned signatures but supplies no
naming algorithm, except the constructor paragraph saying Objective-C output
identifiers remove the colon suffix. `developer-tools-questions.md` item 14 also
identifies reserved/operator output mapping as unresolved.

Please provide a reviewed addendum with these caller-visible rules:

1. Exact keyword set and escape spelling for `avoid_cpp_keywords`; escape
   spelling for the published `RESERVED_NAMES`/optional `RESERVED_TYPE_NAMES`.
2. `make_valid_identifer(string)` has no result or pointer-to-string parameter:
   specify mutable-byte behavior, permitted bytes, first-byte and empty handling.
3. `replace_operator_name` input/output mapping and Jai-preservation subset.
4. Selector multi-component conversion and `print_objc_selector_identifier`
   spelling; whether colon suffix means the first colon onward or final colon.
5. `compute_enum_names` option precedence, delimiter/common-prefix rules,
   already_stripped semantics, fields mutated, omission/alias behavior,
   collision/empty/digit-leading handling; `get_enum_value_name` lookup misses
   and string ownership.

No canonical active generator/options context is declared in the current facade.
Please coordinate its owner if enum naming requires that context; this worker
will not introduce duplicate records or context storage.

Proposed integration: `#load "naming-helpers.jai";` in
`stdlib/Bindings_Generator/module.jai`. That helper owns its private helper load.
Facade integration is reserved to the coordinator. Tests explicitly load the
helper pending integration. No peer scaffolding is modified.

Independent work proceeds on the contract-backed selector subset, original
fixtures, source-built toolchain, formatting/lint, and native/interpreter checks.
Unreviewed public mappings will not be invented to mark names complete.

## Verification and handoff

The partial selector implementation and its independent private helper are ready
for review. The fixture imports the helper file as a module; facade loading is
still pending. All 18 commands in `tools/verify_generator_names.py` pass, including
interpreter and Mac arm64 native O0/O2 execution, actual formatting, and strict
lint/source checks for Mac arm64/x64, Linux x64 and Windows x64/arm64. Cross-target
checks are source-only. The exact per-name report is
`docs/status/implementation-remaining.json`; feature details and deviations are
in `docs/generator-names.md`. Seven names are missing and the selector is partial.


## Helper behavior review ready 2026-10-15 16:14 UTC

Refreshed bindings-generator. Naming/modifier/comment/cursor/alignment helper contracts now supplied, including shared CType copy-on-write, directive/omit/global movement policy, enum/selector/operator rules, spacing/last_location/comment fill. Read and implement all remaining assigned names; do not retain old resolved contract blockers. Unspecified ownership/edge cases permit safe independent policies documented honestly. Check factory is module-qualified get_plugin returning persistent Metaprogram_Plugin, not Check constructor; callbacks specified.

## 2026-10-15 — clean integrator: canonical active options and naming load

The facade now loads `active-options.jai` and `naming-helpers.jai` after the
canonical options declaration. `active-options.jai` declares the sole active
options context member, `context.bindings_generator_options`, using the existing
`Generate_Bindings_Options` record. Naming helpers read that member; callers can
assign it directly when using the helpers independently. The init/run lifecycle
owner must install the active supplied options before context-dependent helpers
run, including `run_generator` as required by the reviewed contract. This change
does not edit lifecycle/model scaffolding or duplicate any options record.

## Reviewed naming batch completion handoff

All eight assigned helpers now implement the reviewed rules, including every
operator mapping, enum suffix/prefix order and omitted-value handling, writable
identifier bytes, and both selector transformations. Public and private helper
files remain separate. Fixtures import the actual integrated Bindings_Generator
facade. All prior naming questions are resolved; no new contract blocker exists.

Canonical options access is context.bindings_generator_options, with no second
slot or options record. Lifecycle/tooling owners should use this field when
installing options before helper calls. Naming tests assign/restore it directly,
exercising configured behavior without modifying lifecycle scaffolding.

Verification covers both fixtures in interpreter and Mac arm64 native O0/O2,
repository formatting, and warnings-denied lint/source checks for Mac arm64/x64,
Linux x64 and Windows x64/arm64: 33 commands, with cross-target checks source-only.
Exact inventory is docs/status/implementation-remaining.json; independent edge
and ownership policies are documented in docs/generator-names.md. No stubs,
compiler hacks, warnings suppressed, or unresolved assigned names remain.


## Android project batch explicitly delegated 2026-10-15 16:24 UTC

Completed naming worker83ba1961 (role generator-names) now owns Android Toolchain project/config/manifest/SDK-NDK/build/install/helper orchestration, exact names in its docs/status/reassigned-scope.json. Portable owner relinquishes those names, retains signing/crypto/JKS and existing ZIP/ASN1/ADB primitive libraries. Shared signing key public types remain portable crypto ownership; no duplicate models/parsers. New worker may call these existing canonical dependencies and report real dependency gaps. Dedicated new private android-project/android-manifest/android-build files; integrator coordinates facade loads. Device execution unavailable must be explicit, not a reason to skip host functionality.

## Android project model/generation draft handoff

Project models and generation are draft in project-types.jai/project-api.jai and private android-project.jai; facade integrates project and manifest files. SDK_LEVEL default34/ENABLE_ARM_LSE true and SDK alias are declared. Android_Build_Options remains blocked only by absent crypto-owned Android_Signing_Key; no duplicate introduced. Project fixture passes interpreter and Mac arm64 O0/O2, formatting and warnings-denied lint; Windows/Linux x64 source checks pass. Android CLI target unsupported (explicit rejection), no SDK/Gradle/device execution claimed. Details docs/android-project.md.

## Android manifest subbatch handoff 2026-10-15

All 16 assigned manifest names are implemented in public manifest-types/api and
private android-manifest, android-manifest-writer and android-manifest-inflate.
Facade integration is in place. tools/verify_android_manifest.py passes all 16
checks: interpreter and Mac arm64 native O0/O2 execution, format, strict lint and
Mac/Linux/Windows source checks. Independent UTF16/Unicode and stored/deflated APK
fixtures plus exhaustive truncations pass. Existing canonical APK/ZIP parses
containers; system zlib handles raw DEFLATE. Exact draft inventory is
docs/status/android-manifest-remaining.json; feature and supported-subset limits
are docs/android-manifest.md. Parent owns commit. SDK/aapt2/device unavailable;
Windows requires zlib1 at runtime. No stubs, duplicate parser/model, suppressed
warnings or compiler hacks.


## User reinforced root-cause policy

Do not patch isolated cases merely to turn tests green. Compare interpreter/native behavior on identical cases, verify reviewed test contracts, identify the shared cause, and refactor compiler/library architecture when warranted. No name/path/test-specific exceptions, suppressed diagnostics or weakened assertions. Small fixes are fine when they completely repair the cause; document reasoning and meaningful regression evidence. Call out any workaround explicitly. Integration catalogue has12 identical failures in both modes and one interpreter-only JSON timeout; no native-only failures in that snapshot.

## Android canonical dependency request and integrated handoff

The disjoint host batch has implemented project generation, binary manifests,
SDK/NDK helpers, independent Gradle APIs, launcher compilation, and device helper
orchestration. 45 of 52 assigned names are integrated; android_generate_apk's
string overload is also complete, but its build-options overload remains partial.

Portable crypto owner: please provide the sole canonical Android_Signing_Key_Kind
and Android_Signing_Key declarations matching the reviewed public schema, plus
apk_sign/apk_sign2 implementations when ready. They are absent in this checkout.
No duplicate signing model or parser has been introduced. Concrete pending loads:
project-build-types.jai, build-api.jai, loader-api.jai. The exact Android_Build_Options
record and substantive build/loader implementations are preserved as unloaded
drafts; they have formatting evidence only, not compile/execution evidence.

The seven partial names are Android_Build_Options, android_generate_apk,
android_generate_apk_gradle, android_generate_apk_command_line_tools,
android_generate_apk_handmade, android_build_or_update_dynamic_loader,
android_build_and_install_loader_app. No other assigned implementation is missing.

Verification runs actual public imports, repository formatter and strict lint,
host interpreter/native O0/O2, and target source checks. Cross-target helper host
actions require unavailable foreign APIs; separate source checking verifies their
bodies without asserting cross-host execution. Actual helper compilation retains
host execution assertions. No SDK/device/signing success is simulated or claimed.
Controlled ADB/link/install/signer fixtures deliberately fail. Root-cause review
found dot-package traversal and unsafe launcher shell inputs; shared identifier
validation repairs both with failing-then-passing regressions.

Full documentation: docs/android-orchestration.md. Exact current inventory:
docs/status/implementation-remaining.json. Naming completion is retained separately.
