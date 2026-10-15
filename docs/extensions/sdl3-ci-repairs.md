# SDL3 native CI repairs for clean candidate 7350b86

The coordinator reported that candidate `7350b86` passes native macOS x64/arm64 and Linux arm64. Both Windows CPUs now get past Visual Studio discovery but fail shared linking on unresolved `SDL_size_mul_check_overflow_builtin` and `SDL_size_add_check_overflow_builtin`. Linux x64 reaches regeneration and fails on stale `contracts-macos-x64.jsonl`. These are genuine generator defects, separately classified below; no inherited/reference API expectation is involved.

## Windows public-header feature profile

The SHA256-verified SDL 3.4.18 `SDL_stdinc.h` defines documented portable inline helpers at lines 6095 and 6134. The extra `_builtin` helpers at lines 6109 and 6147 exist only under `SDL_HAS_BUILTIN(__builtin_mul_overflow)` and `SDL_HAS_BUILTIN(__builtin_add_overflow)`. `SDL_begin_code.h` allows callers to supply `SDL_HAS_BUILTIN`; otherwise it uses `__has_builtin` when available and zero when unavailable. Clang's Windows ABI target exposes Clang builtins, while our native release packages use MSVC. Extracting those Clang-only declarations produced invalid MSVC wrapper calls and the actual LNK2019 failures.

Windows generation now retains Clang's MSVC target ABI and parsing support, clears its Clang/GNU compiler-selection macros, and sets the official `SDL_HAS_BUILTIN(x)` feature switch to zero. Native C compilation still uses the actual unmodified SDK/header compiler conditions; no helper implementation, guessed overflow arithmetic, synthetic external symbol or fallback alias is supplied. This profile selects SDL's real portable helpers. Those helpers and their exact Jai signatures/calling conventions remain. The two absent `_builtin` declarations/wrappers and their generated pointer-resolution assertions are removed **only on Windows**. They remain on the four Clang/GNU profiles where the pinned headers provide them. This corrects previously invalid Windows exposure; no documented desktop core or GPU function is removed.

The MSVC ARM64 header branch includes `arm64intr.h`. Generation reads the installed Clang frontend's actual public intrinsic header through its resource directory, rather than inventing barrier constants or bodies. Minimal ISO declaration headers remain AST-only inputs, not production SDK replacements. Native builds continue using real platform SDKs. Header-profile flags are recorded in each inventory entry. The pinned-header ledger retains the exact builtin conditions and marks Windows as inactive for those compiler-only helpers, with zero unexplained missing declarations.

Every generation now compiles all emitted inline-wrapper calls against the same target/header profile with implicit-function and incompatible-pointer diagnostics as errors. Native MSVC additionally treats C4013 (undeclared function assumed external) as an error for both SDL targets. The real static/shared C smoke executables call the packaged portable overflow wrappers for zero, maximum valid results and actual overflow. Tests check output only on success, matching SDL's documented contract; builtin and portable implementations may write different outputs on failure.

## One canonical declaration ledger

Only these explicitly approved clean candidate files were fetched, using exact public raw URLs under `https://raw.githubusercontent.com/matteopolak/jai/7350b86/`; no checkout, Git history, vendor Jai, reference sources, credentials or transcripts were accessed:

| Candidate file | Actual SHA256 |
|---|---|
| `tools/sdl3_gen.py` | `f1ca9d9ea9071e53545a894e3cb919ef5b0084d33ce97c132d9fba846d82b41b` |
| `tools/test_sdl3_gen.py` | `d6c264ffa0ca76fcff9249c27e0ca71c06aa66004c864abcbbfeac36b43c1ae4` |
| `stdlib/Extensions/SDL3/contracts-macos-x64.jsonl` | `ae2a481830a8c42a5936ec79b37532ecd27f07fa2789ff395dd7c35173198829` |

The candidate contains opposite normalizers: `stable_c_type` removes repeated anonymous record keywords (unit tests use it), while `stable_contract_type` adds them (the actual ledger path uses it). Its checked-in macOS ledger uses the shorter spelling. The worker's preceding checkpoint also used the longer spelling. This explains the Linux stale-file check; changing slash normalization alone cannot resolve it.

There is now exactly one canonical function, `stable_c_type`, used by both generation and regressions. It normalizes native backslashes to forward slashes, strips absolute/relative source roots and removes only the redundant inner `struct`/`union` keyword in anonymous diagnostic type names. The enclosing record kind, source location, declaration types/parameters/fields and all ABI assertions remain. Regeneration creates one payload for each target independent of the build host; each inventory entry records that payload's SHA256. Unit tests verify every stored digest, and `--check` still demands exact file equality. No platform-dependent ledger or ignored stale file is accepted.

Final canonical payload hashes (also machine-readable as `contracts_sha256` in `inventory.json`):

| Profile | SHA256 |
|---|---|
| macos-x64 | `ae2a481830a8c42a5936ec79b37532ecd27f07fa2789ff395dd7c35173198829` |
| macos-arm64 | `d1cb7ee61b343ddaab606f8dbbfcb8b8e00dd026634994070ef37a2003c85654` |
| linux-x64 | `00267ebd22d0ad88f87b04ee3d769ec2b2b6058fa1e9a563af9897bb06782ed5` |
| linux-arm64 | `742cd53d7a3359f57639585ca9a9d46350517cf4aa71e5a5d5bea85d683a3fab` |
| windows-x64 | `930fd44a43e1065987dbf7dfe4a02bf353f98675bbc78e661093b8a0fe462f4d` |
| windows-arm64 | `244eb37935adc453926c99d2715d7667926e4e3b25ffccb9dc5b805539245b60` |

The repaired macOS x64 payload matches the approved candidate's exact hash. The Windows ledger additionally corrects compiler-conditioned assertion annotation/calling-convention metadata and removes the two unavailable builtin helper entries; generated canonical API signatures and aggregate layouts are unchanged. Integration must retain only this normalizer and replace the earlier opposite-form normalization tests, rather than combine both implementations again. Final repaired source hashes: `tools/sdl3_gen.py` = `e88dd57631e89394fbc6f454d9ee2710ca4b8a29517ce892837caadcb37a7f8e`; `tools/test_sdl3_gen.py` = `5b64fc758cd04b2f7a0dec3c38f287e1ba97b28991651f586f0b3459ebd101c2`.

## Actual verification and rerun

Actual local commands and durable logs under `artifacts/sdl3/ci-7350b86/`:

- `python3 -m unittest discover -s tools -p 'test_sdl3*.py'`: 32 tests pass (`unit-final.log`), including native/backslash source paths, both anonymous-record spellings, MSVC feature selection, wrapper absence/presence, all six canonical digests and all 95 desktop GPU procedures on every profile. Original failing regressions remain in `regressions-before.log`.
- `python3 tools/sdl3_gen.py --source artifacts/sdl3/SDL3-3.4.18 --check`: passes with Homebrew Clang 23.1.2 (`check-clang23.log`). The same command with `--clang /usr/bin/clang` passes with Apple Clang 21 (`check-clang21.log`). Each checks all six targets, compiles all emitted wrapper calls, and retains 1,486 layouts per macOS/Linux profile and 1,488 per Windows profile.
- Own source-built jaic `-check -os <os> -cpu <cpu>` passes all four ABI/headless/callback/entry fixtures on all six targets (`jai-cross-layout.log`). This is type/layout checking, not foreign native execution.
- `python3 tools/sdl3_native.py --offline --jobs 2`: passes on local macOS arm64 with real static/shared C linkage and overflow-wrapper/headless tests, installed-header audit and backend/dependency checks (`native-macos-arm64.log`).
- `python3 tools/test_sdl3.py --jaic ../compiler/target/debug/jaic --stdlib artifacts/sdl3/test-stdlib --native artifacts/native-libs/macos-arm64`: passes all four linked Jai fixtures, 1,329 runtime exports, all 95 GPU symbols, licenses and hashes (`jai-smoke-final.log`). Staging uses only authorized new sources, not a final release package.
- `python3 tools/sdl3_lint.py --jailint artifacts/sdl3/review-tools/debug/jailint --stdlib artifacts/sdl3/test-stdlib`: strict `-D warnings` passes on owned files and all six byte-identical target sets (`lint-final.log`). Python compilation also passes.
- A fresh real formatter build fails at `jaifmt/main.jai:348`, missing new POSIX facade (`formatter-retry.log`); scoped jaifmt success remains unestablished. See [exact formatting dependency report](../specs/questions/sdl3-formatting.md). No substitute formatter, suppressed rule or dummy POSIX implementation was introduced.

Coordinator rerun: ordinary six-runner `.github/workflows/sdl3.yml`, with the Windows discovery/build/offline/audit commands in [progress](../status/sdl3-progress.md). Linux x64 must run the exact full `--check` command above; both Windows jobs must build and execute both real native linkage modes. Corrected Windows SDK/native execution and Linux CI regeneration remain pending coordinator rerun. Local macOS or Clang parsing is not a substitute. No GPU hardware/device/oldest-OS behavior is claimed. No workflows were dispatched, no issue comments posted, and release/publication remains held.
