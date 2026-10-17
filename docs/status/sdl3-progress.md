# SDL3 progress — 2026-10-15

## Current SDK packaging correction: a6371ec

Coordinator reports Linux/macOS both CPUs pass; both Windows jobs fail post-install packaging at assumed Unix `lib/cmake/SDL3`. The pinned SDL install rules actually default MSVC exports to `cmake`. The builder now discovers/validates the real directory from `install_manifest.txt` and preserves the complete official SDK prefix under `sdl3/sdk`, retaining library/import/runtime identities, headers, export-relative layout and licenses. Every SDK file is hashed/audited. Four C/C++ static/shared consumers build and run against a separately relocated SDK through actual installed CMake targets, rejecting source-stage/system paths. [Full actual versus fixture evidence and SDK usage](../extensions/sdl3-sdk.md).

Actual local verification: 38 Python tests (Windows/Unix/custom layout and relocation fixtures plus all strict byte/GPU checks); macOS arm64 offline and integrated native builds with original producer smoke and all four relocated native consumers; audit of 87 installed SDK files, all compiler-facing/native SDK artifact identities, 1,329 exports/95 GPU symbols and licenses/hashes; all four linked Jai fixtures; all-six-target strict regeneration and Python compilation. No generated API/metadata/coverage changes. Corrected Windows packaging and new native consumers on other platforms remain coordinator ordinary CI pending; fixture success is not Windows execution. Release hold preserved, no dispatch/comments/tags/publication.

## Earlier narrow correction: e223538 checkout bytes

Coordinator reports ordinary native CI `e223538` passes Linux and macOS both CPUs. Windows both CPUs fail the generator/build-contract gate on the ledger byte hash. Converting the unchanged LF payload to CRLF reproduces the exact digest pair (`ae2a4818…198829` versus `3339502c…3f230f`); no metadata/API change is involved. Root attributes now keep only owned SDL3 module/generated native/ABI assets as LF. Generation writes/checks explicit UTF-8 bytes; CRLF remains a stale-file error, and stored hashes are unchanged. Packaged SDL3 notices follow the same byte/encoding/path-order contract. [Exact scope, hashes, regressions and commands](../extensions/sdl3-generated-bytes.md) are documented.

Actual verification: 35 Python tests, including a real fresh Git `core.autocrlf=true` checkout and proof that SDL2 defaults are untouched; all-six-target exact-byte regeneration with wrapper compilation; Python compilation; local macOS arm64 static/shared C smoke and export/license/hash audit. No generated source, Jai test, ledger, inventory, public API or GPU coverage changed. Windows artifact success is **not established**: the failing test gate precedes native build stages in the inspected workflow. Coordinator ordinary CI rerun remains necessary. Release hold and no-dispatch/no-issue-comment restrictions are preserved.

## Earlier correction: clean CI candidate 7350b86

Candidate `7350b86` gets past installed VS discovery. Coordinator reports native macOS both CPUs and Linux arm64 pass, Windows both CPUs fail shared linking on Clang-only builtin overflow helpers, and Linux x64 fails stale canonical ledger regeneration. Both are genuine generator defects. [The full repair report](../extensions/sdl3-ci-repairs.md) records exact approved clean input URLs/hashes, canonical output hashes, header conditions and test provenance.

Windows extraction now selects MSVC compiler branches with SDL's official builtin-availability switch. Only the two compiler-conditional `_builtin` helpers absent from those headers are removed on Windows; portable overflow helpers, all desktop core APIs and all 95 GPU procedures remain. Every emitted wrapper is compiled during generation; native MSVC rejects implicit function declarations. Both native C smoke modes test the packaged portable overflow wrappers on success and overflow. One shared `stable_c_type` now canonicalizes ledger and test inputs; the previous opposite-form function is removed. The macOS x64 ledger matches approved candidate hash `ae2a481830a8c42a5936ec79b37532ecd27f07fa2789ff395dd7c35173198829` exactly. Inventory includes all six canonical payload digests.

Actual verification: 32 Python tests; byte-exact all-six-target regeneration with both Clang 23.1.2 and Apple Clang 21 (including wrapper compile checks); all four Jai fixtures type/layout-checked on all six targets; macOS arm64 native static/shared C smoke with overflow checks; all four local linked Jai fixtures and audit of 1,329 runtime/95 GPU exports; strict own-source `jailint -D warnings` across owned code and all six target sets. Fresh real formatter build still fails at missing POSIX facade, precisely documented. No formatter pass or Windows native pass is claimed.

Coordinator should integrate this corrective own-branch checkpoint and rerun ordinary native CI; Windows SDK/native execution and Linux CI regeneration remain pending. No workflow dispatch, publishing, issue replies or version changes were performed. Release hold remains in force. The Windows commands below still apply; the ordinary Linux x64 regeneration gate remains strict.

## Earlier installed-VS discovery checkpoint

Windows checkpoint `7c5f37d` corrects the actual Windows native artifact failure reported by the coordinator for clean candidate `9d87e76`. That run passed Linux x64/arm64 and macOS x64/arm64; Windows `windows-2025` and `windows-11-arm` failed because the builder requested an absent VS 2022 installation. This is a genuine build-tool selection defect, not an SDL API/test-oracle issue. No CI logs, coordinator checkout or reference inputs were needed or accessed.

`tools/sdl3_native.py` now discovers component-qualified stable installed MSVC instances with Microsoft's vswhere, matches numeric versions to the running CMake's supported generators, selects an exact installed instance, and sets native target and host architecture explicitly. Environment selections are validated, incompatible generated CMake trees are reset, and missing tools fail with actionable diagnostics. CMake verifies MSVC, architecture, pointer width and distinct static/shared target types. Package routing retains static `SDL3.lib`, separate `SDL3-import.lib` and runtime `SDL3.dll`; build metadata and runtime audit check their identities. The shared builder's existing SDL3 delegation remains intact; other native libraries are unchanged. No SDL3 declarations, header coverage or GPU exports changed.

Actual local verification:

- `python3 -m unittest discover -s tools -p 'test_sdl3*.py'`: 28 tests pass, including simulated VS 17/18 installations, missing/incomplete installations, older CMake, native x64/ARM64 selection, explicit/conflicting environment overrides, component query arguments, cache transitions and distinct artifact copy routing. Test artifact sentinel bytes only exercise routing; they are not native Windows evidence.
- `python3 -m py_compile tools/sdl3_native.py tools/test_sdl3_native.py tools/test_sdl3.py tools/sdl3_gen.py tools/test_sdl3_gen.py`: passes.
- `python3 tools/sdl3_native.py --offline --jobs 2`: local macOS arm64 build passes with both real static/shared C headless executables, version 3004018, real SDK layout checks, installed-header audit and backend/dependency checks. Log: `artifacts/sdl3/windows-discovery-host-recheck.log`.
- `python3 tools/test_sdl3.py --audit-only --platform macos-arm64 --native artifacts/native-libs/macos-arm64`: passes, 1,329 runtime exports including 95 GPU symbols, licenses and artifact hashes. No GPU hardware execution.
- `python3 tools/sdl3_gen.py --source artifacts/sdl3/SDL3-3.4.18 --check` failed on unchanged `contracts-macos-x64.jsonl`. Clang 23.1.2 prints `union (unnamed at ...)` where the ledger records `union (unnamed union at ...)`. This is a metadata reproducibility defect across Clang versions, not an ABI change. Original failure: `artifacts/sdl3/windows-discovery-regen.log`. A separate correction now normalizes only that diagnostic wording while preserving kind and source location. The same full six-target command subsequently passed with Clang 23.1.2, with zero generated binding/ledger changes; corrected log: `artifacts/sdl3/windows-discovery-regen-corrected.log`. The regression covers old/new spellings and relative/absolute source paths. Jai files are unchanged in this correction; prior formatter dependency blocker and lint evidence remain explicit in [formatting questions](../specs/questions/sdl3-formatting.md).

- `python3 tools/test_sdl3.py --jaic ../compiler/target/debug/jaic --stdlib artifacts/sdl3/test-stdlib --native artifacts/native-libs/macos-arm64`: all four linked Jai ABI/headless/callback/entry-point tests pass; log `artifacts/sdl3/windows-discovery-jai-smoke.log`. This is own-source staged dependency verification, not final packaged release integration.
- `python3 tools/sdl3_lint.py --jailint artifacts/sdl3/review-tools/debug/jailint --stdlib artifacts/sdl3/test-stdlib`: strict `-D warnings` lint passes on owned files and all six source-identical target sets; log `artifacts/sdl3/windows-discovery-lint.log`. Real jaifmt remains blocked as documented above; no formatting success claimed.

Coordinator rerun: ordinary `.github/workflows/sdl3.yml`, **not** release workflow dispatch. On each native Windows runner the workflow now prints CMake version and actual discovered arguments, runs all Python tests, builds both linkage modes with real headless execution, rebuilds offline, and audits every runtime/GPU export. Equivalent PowerShell commands (set the target to the runner's actual CPU):

```powershell
$target = 'windows-x64' # windows-2025; use windows-arm64 on windows-11-arm
New-Item -ItemType Directory -Force artifacts/sdl3/tmp | Out-Null
cmake --version
python tools/sdl3_native.py --platform $target --show-toolchain
python -m unittest discover -s tools -p 'test_sdl3*.py'
python tools/build_native_libs.py SDL3 --platform $target
python tools/sdl3_native.py --platform $target --offline --jobs 2
python tools/test_sdl3.py --audit-only --platform $target --native "artifacts/native-libs/$target"
```

Requires installed CMake supporting the actual VS release (VS 18/2026: CMake >=4.2), stable Visual Studio/Build Tools with MSBuild, target VC tools and Windows SDK. No developer prompt initialization or manual SDL installation is required. Windows execution of this correction remains CI pending. No Windows pass is claimed from simulations or macOS tests. Release/publication hold remains in force; no workflow dispatch, issue reply, push, tag, release or version change was performed. The coordinator integrates this own-branch checkpoint and reruns ordinary native CI.

SDL Python matrix833:60 local source/configuration checks PASS with missing helper keys removed; new explicit scratch/canonical defaults/pinned-header prerequisite packet ready. Integration owns workflow adoption; native/ordinary matrix not claimed. Sealed c5db6625 packet unchanged. See [scope/evidence](sdl-python-matrix-833.md).

ae6Windows repair: exact2 CI failures reproduced under committed verifier/policy controls;15focused/63scoped checks PASS with13stable sourceguards. Newthree-file patch fixes native ledger test lookup and explicit CMake LF output, preserving original fixture/template assertions and sealed a1/c5 packets. Shared cleanup-API WIP remains integration-owned. See [scope/evidence](sdl-windows-policy-ae6.md).
