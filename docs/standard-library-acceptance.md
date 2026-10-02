# Standard library source acceptance

## What it is

`tools/check_standard_libraries.py` inventories pinned library entrypoints and checks their actual source bodies with the integrated Rust CLI. It distinguishes a supplied standard module from project support, example libraries, compatibility stubs, and reviewed negative cases; it does not turn every source file into an application.

## How it works

The inventory reads the existing source manifests and verifies every Jai source hash. Conventional `module.jai` entrypoints, direct files under `reference/modules/`, and named files directly within project module-search directories become cases in `corpus/standard-library-acceptance.json`. The current inventory has 253 candidates: 138 supplied module roots, five supplied example-library roots, and 110 upstream roots. These comprise 242 library or example-library entrypoints and 11 test module fixtures. Fixture checks remain a separate role and use `support-file` cases; passing one cannot count as an ordinary library or application build. Other files remain visible with their role and evidence basis.

Reviewed negative outcomes require an explicit diagnostic from `corpus/acceptance.json`. Upstream `expect_compile_failure` calls also identify intended negative fixtures, but those observations do not provide reviewed diagnostic contracts or successful expected rejections. Missing referenced fixtures remain visible and unattempted. Missing features, platform exclusions, crashes, and timeouts cannot become successful negative tests. Filename spelling alone never designates a negative.

Import, load, native-library, module-parameter/default, compile-time execution, and platform observations retain source identity and line numbers without copying source excerpts. The scanner excludes comments, quoted examples, and custom here-string bodies from directive matching. These remain lexical observations, including inactive branches; they are not a resolved dependency graph. Of the selected roots, 48 declare module parameters and 42 declare native libraries; those observations do not establish selected-host argument requirements or linkage. File, Process, and Thread retain declared local-load closures, including missing inactive PS5 loads, without pretending those are selected-host failures.

Each selected root first runs `parse`, then `check-library` if parsing succeeds. A library check needs no `main`. Its real nearby module search directories precede the supplied standard library, including the book's actual `my_modules` directory. No substitute module, renamed binding, SDK stub, generated application, or native corpus artifact is supplied. The CLI checks using its compiler-effects policy; this does not establish native OS behavior or successful metaprogram effects. It also does not enumerate every possible generic specialization or module parameter combination.

Three profiles make bootstrap evidence explicit:

| Profile | Preload | Runtime Support | Meaning |
| --- | --- | --- | --- |
| `diagnostic` | disabled | disabled | Isolates source/type gaps; cannot establish complete standard-library acceptance |
| `preload` | actual supplied search | disabled | Checks genuine shared Preload declarations and dependent module bodies |
| `runtime-library` | actual supplied search | actual supplied search | Selects initialization, disables system entrypoint and crash backtraces for a library configuration |

Search follows the recorded real module directories, so a project's Runtime Support source override can precede the supplied fallback. The report retains predicted bootstrap source paths and hashes from that configured search; those predictions do not replace measured graph diagnostics.

The runner clears inherited `JAI_RS_*` settings before applying the recorded profile. Checks select the immutable CLI's host target; other platform branches and SDKs remain unverified. Required module arguments outside automatic Runtime Support are not fabricated, so missing argument configuration remains an explicit diagnostic.

OpenJai's pinned File, Process, and Thread roots are labeled `upstream-compatibility-stub`: their fixed answers and simplified thread state cannot establish the supplied OS module's behavior. Even a successful source check of a genuine File, Process, or Thread module establishes body checking only. OS effect lifecycle, scheduling, async I/O, native foreign linkage, and full project builds require separate acceptance.

Before checking, the runner snapshots the selected integrated CLI atomically under `target/standard-library-snapshots/SHA256/jai-rs` and verifies its bytes. Reports record exact commands and environment, pinned source/revision identities, manifest hashes, compiler binary hash before and after checking, and independently observed Rust-source fingerprints. Failure groups retain verified loaded-dependency locations and root counts separately: many roots failing at one Preload declaration represent one located blocker. A changed compiler snapshot invalidates the run. The binary hash does not prove it was built from the separately observed current sources.

The earlier October 2, 2026 checkpoint uses immutable integrated CLI SHA256 `8a52b33b52753562e987b37ec8274548e019aa62b7b611d5c432c0f5c3e00489` on Darwin ARM64. The local report is `artifacts/standard-library-8a52b33b.json`, with its separate generated manifest at `artifacts/standard-library-8a52b33b-manifest.json`. All 2,142 pinned source hashes and the compiler's unchanged bytes were verified. All three profiles attempted 253 roots without crashes or timeouts:

| Profile | Root parse passed / failed | Library checks passed / failed / not run | Fixture checks passed / failed |
| --- | --- | --- | --- |
| Diagnostic, no bootstrap | 158 / 95 | 24 / 123 / 95 | 6 / 5 |
| Actual Preload | 158 / 95 | 30 / 117 / 95 | 6 / 5 |
| Runtime library | 158 / 95 | 0 / 147 / 95 | 0 / 11 |

Two of the 30 passing library checks are labeled OpenJai compatibility stubs, File and Process. Its Thread stub parses but fails in the loaded OpenJai Basic module. Within the 138 supplied module roots, actual Preload checking passes seven (`Hash`, `Preload`, `Protocol_For_Memory_Visualization`, `Sort`, `lz4`, `meshoptimizer`, and `stb_image_resize`), fails 67 during checking, and leaves 64 unchecked after parsing fails. These are source-body outcomes; foreign declarations passing here do not establish native linkage or execution.

The report contains 116 profile/stage/diagnostic groups and 149 distinct verified first-failure source locations, including loaded dependencies. All 158 runtime-library checks stop at the same supplied `Default_Allocator/module.jai:83:42` dependency location containing `#location()`. Within the actual Preload module-root checks, supplied `Basic/module.jai:181:6` caller-deferred statements block 37 roots and OpenJai `Basic/module.jai:119:1` context declarations block 19. The larger full-corpus shared-root counts are different measurements and must not be substituted for this 253-root sweep.

Genuine File now parses, then stops at a typed constant in `Objective_C/module.jai:81:13`; Process parses, then stops at `String/module.jai:783:23` constrained-formal syntax; Thread still stops during parsing at the operator alias in `Thread/module.jai:69:14`. Those root checks remain separate from [focused OS runtime fixtures](os-library-acceptance.md), which supply test declarations and exercise a limited source subset. Later diagnostics remain unknown until these first blockers are fixed. Missing required module arguments and unresolved project modules remain configuration diagnostics, not successful negative cases.

The earlier immutable `737a864b…` source checkpoint remains available in `artifacts/standard-library-737a864b.json` as historical evidence. The newer report does not assert that its binary contains changes currently being made in the shared Rust tree; rerun against a newly built immutable CLI after its owners publish a coherent marker.

The latest immutable source-only sweep uses CLI SHA256 `43b1705dd388ff63d71089ea0d542ac713da9e2bf547b86908d94d81ea66be64`, recorded in `artifacts/standard-library-43b1705d.json`. It attempts the same 253 roots in the two default profiles; it does not rerun the diagnostic profile.

| Profile | Root parse passed / failed | Library and example-library checks passed / failed / not run | Fixture checks passed / failed |
| --- | --- | --- | --- |
| Actual Preload | 168 / 85 | 32 / 125 / 85 | 6 / 5 |
| Runtime library | 168 / 85 | 0 / 157 / 85 | 0 / 11 |

The 38 Preload successes comprise 30 ordinary library roots, two example-library roots and six fixtures. Runtime-enabled checking still has zero successes. These are source checks, not linked library or application outputs. The report retains 75 failure groups. Subsequent shared-tree changes, including the startup target-enum panic fix and declaration-style `using`, are not contained in this frozen binary and require a fresh snapshot before changing these counts.

The corrected runner repeated this exact snapshot in `artifacts/standard-library-43b1705d-classified.json`, preserving the same totals. Of the 168 failed runtime checks, **164 are compiler panics at one Rust bounds-error site**, `crates/jai-modules/src/enum_parameters.rs:473:69`; they are not source rejections or 164 independently located module defects. The four ordinary source failures occur at supplied `Runtime_Support.jai:382:43` (three roots, missing `TEMPORARY_STORAGE_SIZE`) and `Basic/String_Builder.jai:296:18` (one root, declaration syntax). The snapshot stayed unchanged, and all ordinary source diagnostic locations were verified. No panic, signal, or timeout occurred in its Preload profile.

Each stage now preserves the first nonempty stderr line and reports `failure_kind` for a compiler panic, signal, timeout, or invocation error. `compiler_failures` gives per-profile counts. Panic groups retain the canonical Rust panic site and detail rather than a varying process/thread identifier, and never manufacture a verified Jai source location. The initial 43b report lost the panic text because Rust emitted a leading blank line; retain it as historical evidence and use the classified report for failure accounting.

## How to change it

Change entrypoint conventions and lexical metadata in `library_source_inventory.py`, and actual source configuration in `check_standard_libraries.py::profile_environment`. Add a selection regression when changing classification. Keep negative contracts explicit, preserve provenance and purpose labels (bootstrap, compiler interface, metaprogram/plugin, generator, ordinary library), and never replace required original sources to improve acceptance totals.

The generated acceptance manifest uses the ordinary corpus acceptance schema, so it can also be consumed by `tools/check_corpus.py`. Regenerate it from the pinned manifests rather than editing hashes. Source upgrades require updating the existing pinned input manifests first. Tests cover selection, review-based negatives, directive masking, environment isolation, source-only commands, runtime library policy, and canonical dependency diagnostic grouping.

## Configuration

```sh
python3 tools/check_standard_libraries.py --inventory-only --report artifacts/standard-library-inventory.json
RUSTC_WRAPPER= LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm cargo build -p jai-cli --locked -j1
python3 tools/check_standard_libraries.py --compiler target/debug/jai-rs --profile preload --profile runtime-library
python3 tools/check_standard_libraries.py --compiler target/standard-library-snapshots/8a52b33b52753562e987b37ec8274548e019aa62b7b611d5c432c0f5c3e00489/jai-rs --profile diagnostic --profile preload --profile runtime-library --manifest artifacts/standard-library-8a52b33b-manifest.json --report artifacts/standard-library-8a52b33b.json
python3 tools/check_standard_libraries.py --compiler target/debug/jai-rs --profile diagnostic --select 'reference:modules/File/module.jai'
python3 -m unittest discover -s tools -p test_check_standard_libraries.py
```

`--select` repeats exact inventoried candidate IDs; omitting it checks all candidates with fixture roles retained separately. `--profile` repeats and defaults to actual Preload plus runtime-library profiles. `--timeout` bounds each command in seconds, default ten. `--manifest` and `--report` select local outputs outside the read-only corpus. Select a repository-built integrated CLI under `target/`; the tool freezes it before executing commands and rejects the syntax-only frontend adapter. An existing corpus snapshot can also be selected. The runner emits no LLVM, object, linked program, or native execution.

The runtime-library environment is `JAI_RS_RUNTIME_ENTRY=0`, `JAI_RS_RUNTIME_INITIALIZATION=1`, and `JAI_RS_RUNTIME_BACKTRACE=0`, with both source selections set to `search` and `JAI_RS_STDLIB` pointing to `reference/modules`. This is an explicit library configuration, not full application startup evidence.

## Dependencies

Python's standard library, `library_source_inventory.py`, the existing `check_corpus.py` inventory/fingerprint/search helpers, the shared source decoder, the pinned corpus manifests, and our integrated Rust CLI. Genuine Preload and Runtime Support follow the recorded actual module search paths, including project source overrides. No original compiler, library, object, project script, external SDK, or upstream executable is executed or loaded. All reports remain local.
