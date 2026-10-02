# Newer-project requirements and ownership

## What it is

`tools/inventory_project_requirements.py` records source-backed requirements that exceed the small [feature matrix](corpus-feature-matrix.md). It scans the 1,440 pinned upstream Jai files, preserves exact source ID, revision, SHA-256 and line evidence, and routes sixteen integration groups to the currently assigned owners.

The priorities and owner mapping are engineering analysis. Occurrences identify work to assess, not unsupported constructs or successful compilation. Full requirements remain unverified even where a small handwritten contract passes.

## How it works

The scanner verifies source fingerprints, masks ordinary strings and nested comments, then gathers requirement patterns, directive spellings, `compiler_*` identifiers, import targets and native library target names. The local report `artifacts/project-requirements.json` includes 83 directive spellings, 40 compiler identifiers, 135 import targets and 61 library target strings in the 2026-10-02 inventory. These are metadata counts; custom here strings may cause false positives, and nominal `Vector4` or `Quaternion` names do not prove SIMD use.

The integration order separates foundational language/workspace work from runtime and platform integration. Counts below are upstream files with matching spellings, not acceptance counts. Owner names match the current implementation lanes; the snapshot date is retained in the report.

| Priority | Requirement | Files | Assigned owners |
| --- | --- | ---: | --- |
| 0 | Module parameters and target selection | 87 | Module parameters, generic records, frontend, native target |
| 0 | Compiler workspace and message lifecycle | 49 | Compiler intrinsics, source run, graph discovery, driver CLI |
| 0 | Build options and native output | 50 | Native target, driver CLI, foreign libraries |
| 0 | Source insertion and captured code scope | 216 | Reflection, source run, procedure modifiers, compile-time conditions |
| 0 | Reflection and runtime type metadata | 219 | Reflection, type runtime |
| 0 | Polymorphic and baked procedures | 181 | Polymorphism, generic records |
| 0 | Context and C callbacks | 190 | Procedure context, caller locations, foreign libraries |
| 0 | Void and typed pointer arithmetic | 17 | Pointers, runtime intrinsics |
| 1 | Locations, expansion and call policies | 84 | Caller locations, procedure modifiers, polymorphism, reflection, optimization hints |
| 1 | Foreign ABI and library selection | 104 | Foreign libraries, native target, native dependencies |
| 1 | SDK and platform binding requirements | 48 | Native target, foreign libraries; native dependency and SDK provenance |
| 1 | Packed and explicit record layout | 24 | Storage alignment, type runtime; completed record/C ABI proofs remain separate evidence |
| 1 | Dynamic memory and descriptor lifetimes | 254 | Sequences, pointers, runtime intrinsics, string equality, compile-time VM |
| 1 | File, process and thread effects | 104 | Record lane owns source module acceptance; OS library acceptance owns runtime behavior; compile-time I/O owns reviewed host effects |
| 1 | Atomics and hardware intrinsics | 10 | Runtime intrinsics, compiler intrinsics, type runtime |
| 2 | Vector/SIMD requirement candidates | 34 | LLVM types, inline types, type runtime; closed-block SIMD active; full byte-search/vector ABI contracts remain |

All sixteen groups now have assigned owners. The following runtime/platform subrequirements remain acceptance work after grammar and dependency resolution:

- **File and process behavior.** Focus `first.jai:5` queries a git revision with `run_command`; line 198 writes application metadata; line 387 invokes a custom link command. Jails `server/main.jai:83` reads a file, lines 158/163 locate executables, and line 265 writes metaprogram source. Source checking alone does not establish exit status, captured output, errors, resource lifetime or safe compile-time effect policy. Parent-assigned standard module acceptance owns source checking of File, Process and Thread, while `os_library_acceptance_high` owns actual host behavior and `compile_time_io_high` owns reviewed compile-time host effects. Those results remain unverified until their own fixtures run.
- **Thread and asynchronous I/O lifecycle.** Focus `modules/File_Async/thread_pool.jai:105` calls `pthread_create` with baked user data. Its `File_Async` module selects Linux io_uring, Windows completion ports and a macOS thread pool. The OS library acceptance lane owns real callback context, synchronization, completion, error and teardown behavior on the target OS.
- **Native dependencies and SDKs.** sgpu `modules/Vulkan_With_VMA/module.jai:91-139` selects platform Vulkan, VMA and C++ libraries. Other roots require SDL, ImGui, GLFW, Slang, AppKit/Foundation/Carbon, Win32 or Linux display bindings. A trusted linker and correct declaration layout do not prove those SDKs or libraries are present. The native dependency lane owns SDK configuration, trusted rebuilds and provenance. Supplied libraries and objects remain static inputs; rebuild dependencies from reviewed source with trusted toolchains before any native use. The dedicated [native dependency lane](native-project-dependencies.md) now records 120 source declarations and an independently built VMA archive receipt. That receipt retains `link_authority: false`; it does not establish graphics ABI or upstream execution. Actual hardware/SDK availability remains an external constraint.
- **Dedicated SIMD acceptance.** The optional `artifacts/simd-source-inventory.json` now distinguishes ordinary Math records from actual SIMD instructions and verifies every referenced source fingerprint. The active closed-block subset contains SSE/AVX/AVX2 loads and floating/byte additions. The LLVM owner verified four source tests and eight x86-64 objects at O0/O2 on the ARM host, alongside VM/proof/helper tests. These are source/object gates; no x86 SIMD execution on ARM is claimed. Remaining supplied String byte-search contracts include `pxor`, `movd`, `pshufb`, `pcmpeqb`, `pmovmskb`, `bsf` and cross-block registers; Focus MeowHash passes vector registers to foreign bindings. The LLVM types lane owns these extensions. Nominal vector spelling and private IR/VM helper tests do not prove full SIMD acceptance.

A concrete pointer gap has already been routed: Focus `modules/Simp/bitmap.jai:148` obtains `data_tmp` from `alloc`; supplied `Basic/module.jai:106` declares `alloc` returning `*void`. Focus then adds byte strides and subtracts pointers at lines 174 and 185. This requires void-pointer arithmetic assessment independently of the passing typed-pointer fixture. Exact hashes and revisions are preserved in the inventory and the handoff; source comments and conventional C behavior are not substituted for acceptance.

The latest immutable `43b1705d` 46-contract gate passes all 36 positive contracts through exact native behavior and all 10 intended negative diagnostics. Both earlier short-circuit and getter/setter regressions pass their unchanged expected results. Exact evidence is retained in `artifacts/feature-matrix-43b1705d.json`, independently of every full requirement group above. Additional pure contracts in `tests/corpus-proposals/manifest.json` remain unverified proposals; their fingerprints and the earlier 46-case audit are recorded separately.

Actual standard-library source failures are separately grouped in `artifacts/requirement-blockers-737a864b.json`: 64 profile/stage groups with verified source hashes, locations and assigned owners. Generic grammar gaps route to the frontend; attributes to procedure/debug owners; generic/variadic patterns to polymorphism/procedure owners; native declarations to foreign-library owners; typed bootstrap and target names to the parent, driver, Preload and graph owners; Runtime Support assembly to LLVM owners. Missing required module arguments or genuine project search roots are configuration failures, not successful negatives. The standard-library report remains the authority for profile and role counts, including bootstrap failures shared by multiple roots. Later owner tests have closed the reported bare/block short-lambda parser cases, but a fresh immutable compiler/root run is required before changing those recorded acceptance results.

The newer `artifacts/requirement-blockers-43b1705d.json` independently routes 60 parse and 197 check diagnostic groups from the latest pinned corpus reports, preserving verified diagnostic-source fingerprints, source revisions and locations. Its twenty-one form categories connect to the sixteen broader integration groups where applicable; core expression/declaration syntax and incomplete standalone binding context remain explicit separate categories. These are routing judgments, not successful acceptance or definitive claims that every unknown binding is a language gap. The recorded whole-source profile parses 1,506 of 2,142 sources and passes 88 actual-Preload checks plus one separately intended negative.

Two integration boundaries require exact semantics. `$T/interface Shape` uses structural member-name/type matching while retaining the inferred actual type; `$T/Template` uses genuine template origin or unique promoted ancestry. Polymorphism owns the canonical matcher and the frontend owns the restricted-type AST. Separate self-written positive and missing-member proposals record their fingerprints without changing the active native suite; a parser failure cannot satisfy the intended semantic negative. The supplied Compiler's `__runtime_info: Runtime_Info #elsewhere` is an external runtime table declaration. The Compiler owner confirms `get_runtime_info` remains unsupported and requires a genuine reflection table emitter plus an external-data provider. Parent coordination must assign that bridge across reflection, compiler intrinsics and foreign data, rather than substituting an empty global or ignoring `#elsewhere`.

Alternate implementations retain their own provenance. In particular, open-jai File/Process/Thread compatibility sources can contain fixed answers and no-op behavior; their source acceptance cannot establish genuine original standard-library OS behavior. Its pinned `modules/Machine_X64/module.jai` also has empty result-bearing CPU query bodies. The missing-return diagnostic at line 32 correctly rejects incomplete upstream source; it does not justify relaxing return checks or claiming a missing assembly implementation in that body.

No original executable, native object, library, installer or upstream build script is executed by the scanner. Import and library strings are recorded solely as metadata.

## How to change it

Update `REQUIREMENTS` for source-backed gaps and update `ACTIVE_OWNERS` when the parent reassigns implementation lanes. Keep all sixteen groups represented, and leave `UNOWNED` entries for subrequirements that no assigned lane actually verifies. Distinguish source module checking from native OS behavior, SDK readiness and full project execution.

Add representative self-written contracts to the feature matrix only after defining exact observable behavior. A fixture pass should narrow a requirement; it should not replace its complete upstream build gate. Corpus semantic sweeps and curated native results must retain their separate reports and compiler fingerprints.

## Configuration

```sh
python3 tools/inventory_project_requirements.py
python3 tools/inventory_project_requirements.py --report artifacts/project-requirements-current.json
python3 -m unittest discover -s tools -p test_project_requirements.py
```

The only flag is `--report`; the default is local `artifacts/project-requirements.json`. Reports cannot be written inside the supplied or upstream source roots. Source pins come from `corpus/reference-inputs.json` and `corpus/upstreams.json`. The scanner also records its own SHA-256 and the ownership snapshot date.

## Dependencies

Python standard library, the shared source inventory in `tools/check_corpus.py`, masking/decoding helpers from `tools/inventory_corpus_features.py`, and pinned upstream source files. No compiler binary, runtime, SDK, source upload or native dependency is needed to generate the inventory.
