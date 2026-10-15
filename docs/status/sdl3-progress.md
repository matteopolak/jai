# SDL3 progress — 2026-10-15

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
