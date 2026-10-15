# SDL3 pinned-header coverage audit

Issue linkage: **#2 (SDL3)**. No issue comments, replies, workflow dispatch or publishing were performed.

The API oracle remains the official SDL **3.4.18** public headers, with the exact archive URL/SHA256 in `tools/native-libs.json`. [coverage.json](../../stdlib/Extensions/SDL3/coverage.json) is an automatically reproduced ledger of **all 86 public source headers**, including inactive preprocessor branches. This is a superset of the **75 installed headers** in the configured core build; the remaining eleven are the disabled `SDL3_test` auxiliary library. Independently released SDL_image/mixer/ttf/net are outside this core binding.

The ledger's discovery pass is independent of the Clang declaration pass: it removes comments, retains macro continuations and preprocessor conditions, distinguishes record fields from callback typedefs, and finds exported SDL/SDLTest/foreign-graphics prototypes, typedefs, named records, enumerators, variables and macros. It reconciles candidates with the actual generated declaration names for every active release profile. An unexplained core declaration or inactive core macro is fatal. New macros cannot simply be labeled nonruntime by a catch-all. Compiler/entrypoint vocabulary, platform-only APIs, the separate test framework and non-SDL graphics/intrinsic definitions have explicit classifications and reasons.

Each header has its pinned SHA256 and a shared `condition_groups` table. Each candidate records its spelling, source line, condition reference, generated equivalent/profile group or exclusion classification. `reason_ref` keys resolve in the ledger's top-level `reasons` table. Equivalent paths use `{profile}` for the listed profiles. An absent profile has a recorded preprocessor-availability explanation. `unexplained` must remain empty; generation fails before producing an accepted ledger otherwise.

[Per-target inventory](../../stdlib/Extensions/SDL3/inventory.json) lists translated and excluded names. Its `contracts` files are JSON Lines: Clang declaration kinds, canonical C type spellings, procedure parameters, record fields and the C/Jai layout expressions with expected values. Each entry occupies one line so these large machine-readable contracts can be inspected independently without duplicating the entire type graph into the summary inventory. Source-directory paths are normalized, so relative and absolute cache paths produce identical outputs. Public callback names/calling conventions and aggregate layouts remain those of the pinned headers.

## GPU coverage

| Surface in SDL_gpu.h | Coverage |
|---|---|
| Procedures | 95 desktop procedures generated and symbol-audited; two GDK/Xbox-only procedures explicitly excluded on the six desktop profiles |
| Record/handle declarations | 49 in the Clang contract: 36 complete records and 13 opaque handles |
| Typedefs | 77, comprising the records/handles, 24 enums and four flag aliases |
| Enum members | 230, with explicit materialized C values |
| Flags, property strings and other macros | Reconciled individually; the header guard is compiler vocabulary |
| Layout/ABI | GPU records/enums/aliases are included in every generated C/Jai layout suite; all GPU procedure signatures are forced to type-check |

The two explicitly unavailable functions are `SDL_GDKSuspendGPU` and `SDL_GDKResumeGPU`, guarded by `SDL_PLATFORM_GDK`. They are not advertised as Windows desktop DLL exports. All other discovered GPU procedures must have generated equivalents. `tools/test_sdl3.py` independently resolves the 95 desktop GPU names from the ledger in the packaged runtime. This validates symbols and signatures/layouts, **not graphics hardware execution**.

One other important nonruntime classification is `SDL_joystick_lock`: its public header explicitly states that the declaration is only for Clang thread-safety analysis and is not an exported symbol. No fake foreign variable was added. The obsolete 32-bit ARM kernel-barrier callback and pre-VS2010 ISO integer fallback typedefs are also classified precisely. Seven `va_list` procedures retain their exact limitations; the corresponding real variadic APIs are available. See the [binding limitations](sdl3.md).

## Independent organization

The generator deliberately orders independent declarations by our responsibilities: foundation, lifecycle, resources/concurrency, interaction, presentation, GPU, then audio. Each responsibility places enums/aliases/records/callbacks before procedures and constants. Procedures are ordered by opening/creation, configuration, queries/work and shutdown. Macro wrappers use the same responsibility/lifecycle scheme. This is not the header include sequence or a spec inventory template.

Aggregate/union fields, overlays, callback parameter order and enum member order remain unchanged. Enum values are materialized explicitly. The three `SDL_INIT_INTERFACE` overloads retain their established relative order. The source reorganization changes neither public C names nor signatures, storage/identity, visibility or calling conventions.

## Reproduce and verify

```sh
python3 tools/sdl3_gen.py --source artifacts/sdl3/SDL3-3.4.18
python3 tools/sdl3_gen.py --source "$PWD/artifacts/sdl3/SDL3-3.4.18" --check
python3 -m unittest discover -s tools -p 'test_sdl3*.py'
python3 tools/sdl3_native.py --offline
python3 tools/test_sdl3.py --jaic ../compiler/target/debug/jaic --stdlib artifacts/sdl3/test-stdlib --native artifacts/native-libs/macos-arm64
python3 tools/sdl3_lint.py --jailint artifacts/sdl3/review-tools/debug/jailint --stdlib artifacts/sdl3/test-stdlib
```

The native builder verifies the installed header set against the ledger and copies evidence to `sdl3/installed-headers.json`. Installed headers must match the pinned source bytes; only generated `SDL_revision.h` build metadata may differ, and both hashes/status are recorded. The C smoke tests also compile the generated layout assertions against the real SDK headers.

`jailint -D warnings` passed on owned files and all six source-identical target declaration/ABI sets. Ordinary module linting only loads the host `#if` branch; the review runner makes the other exact generated files visible in isolated lint roots. It rejects jailint's “did not compile completely” fallback, even when jailint returns zero. No lint rules or warnings were suppressed.

**Formatting remains blocked, not passed.** The actual repository `jaifmt` cannot yet build on the new Basic/POSIX dependencies. The exact commands, diagnostics, minimal reproducer, retry and required owner corrections are in [the formatter integration question](../specs/questions/sdl3-formatting.md). The generator accepts `--jaifmt <real-source-built-CLI>` to normalize every generated Jai file with repository config and require formatting idempotence once that tool builds. Release packaging now gates on the actual scoped formatter check, normalized regeneration and strict lint runner; these gates are CI/integration-pending, not reported as executed successes.

Local runtime evidence remains **macOS arm64 only**: 1,329 runtime symbols (including the 95 GPU exports), actual static/shared C smoke programs, real-SDK/Jai layout assertions, and linked headless/callback/entry-point tests passed. Main integration tests exercise both `SDL_RunApp` and `SDL_EnterAppMainCallbacks` with real C callbacks and an immediate successful initialization. Coordinator-reported ordinary native CI candidate `9d87e76` passed macOS x64/arm64 and Linux x64/arm64; Windows x64/arm64 failed on the former fixed VS 2022 generator. Corrected Windows discovery still needs native CI execution; see [current status](../status/sdl3-progress.md). No GPU hardware execution or oldest-deployment-OS execution is claimed.
