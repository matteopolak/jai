# SDL Python matrix prerequisites — 833

The reviewed worker inbox assigns two actual matrix setup failures: missing `SDL_FIXTURE_TEST_HELPER`/`SDL_SDK_TEST_HELPER` environment keys and roughly fourteen temporary-directory creations below absent `artifacts/sdl3/tmp`. These are test setup defects, not evidence of broken SDL ABI or missing GPU declarations. Compiler jobs at 833 were cancelled with recorded failures, not green. Sealed `c5db6625` MojoShader packet remains unchanged.

## Exact ownership and changes

Accepted producer snapshot `4bbbcb9672118f9bcf49e05ff0e1b247dc90adbb` was read from authorized `stdlib-shared` only. Integration alone modifies its tree/index. The new patch modifies only setup/import/path lines in five tests: `test_sdl3_coverage.py`, `test_sdl3_gen.py`, `test_sdl3_native.py`, `test_sdl_fixture_paths.py`, `test_sdl_sdk_headers.py`. New files are the scratch/source helper, preparation command and setup regressions. No production SDL/native builder, verifier API, workflow, fixture body, generated payload, coverage ledger, binding or API is changed. No whole-file replacements or assertion/skip changes.

`tools/sdl_test_support.py` requires an explicit absolute `SDL_TEST_TMPDIR`, creates that owned parent and routes every affected temporary directory below it. There is no system/internal temporary-directory fallback. Helper/fixture/builder defaults come from the canonical repository containing the tests; historical per-helper environment overrides remain strict, and a missing explicit override fails rather than silently falling back. `SDL_PYTHON_TEST_ROOT` permits an explicitly admitted source snapshot for isolated producer checks; ordinary full-checkout discovery needs no root override.

SDK configuration tests still require real official inputs. `tools/prepare_sdl_python_tests.py --scratch <absolute> --cache <absolute>` obtains the exact existing sdl2-compat 2.32.70 archive pin from `dependencies.json`, validates SHA256 before staging, and extracts only real `CMakeLists.txt`, `SDL_config_unix.h.cmake` and license members needed for these configuration tests. It does not configure/build an SDL runtime, stage another SDK, invent structures/macros or substitute installed headers. `--offline` requires the cache and rejects corrupt bytes; download hash mismatch is fatal before caching. Only regular exact archive members are accepted. A receipt records the source archive path/hash, and a regression rehashes that archive and compares each staged file byte for byte with the verified member.

The command emits exactly `SDL_TEST_TMPDIR` and `SDL_SDK_TEST_SOURCE` assignments for the caller environment. Header inputs/receipt are inside explicit scratch, cached archive inside explicit cache. Subsequent SDK tests generate only into their own temporary directories and retain original driver/configuration and byte assertions.

## Workflow prerequisite request — integration owner

Before `.github/workflows/ci.yml` Python unittest discovery and `.github/workflows/sdl3.yml` generator/build contract tests, integration should adopt:

```sh
python3 tools/prepare_sdl_python_tests.py \
  --scratch "$RUNNER_TEMP/sdl-python" \
  --cache "$RUNNER_TEMP/sdl-python-cache" >> "$GITHUB_ENV"
```

Restore/cache the exact archive as desired; the cache file is `sdl2-runtime-oracle-<archive-sha256>.tar.gz` and is always revalidated. Use `--offline` when provisioning guarantees the pin is already cached. Python >=3.9, CMake (existing script-mode test), and Git (existing fresh autocrlf-checkout test) must precede discovery. No MSVC installation, SDL binary, GUI or manual package install is needed by these Python unit tests. The owner was asked to reserve these workflow prerequisites; no workflow delta or adoption success is claimed here. Integration's broader native providers/LLVM/formatter/verifier API work remains separate.

Local commands must use `/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/sdl3/target/sdl-python-matrix/...` for scratch/cache/TMPDIR. No internal fallback was used. Preparation ran offline against our previously hash-verified official archive; no new network/native SDK execution occurred.

## Actual evidence and retained failures

Original source regression is retained as `before.log`. A combined first replay cleared all parent/helper-env failures, passed 56/59 checks, and exposed three genuine local exFAT/macOS fixture problems: AppleDouble `._*.h` metadata decoded as C text in synthetic coverage/notice fixtures, plus an AppleDouble removal race in the synthetic CMake-tree deletion test. `all-tests.log` retains these failures; they were not reclassified as passing.

Only those three synthetic setups now invoke `remove_fixture_metadata` before the affected operation. Cleanup is restricted to children of the explicit test scratch, recognizes the AppleDouble magic/version, requires a real sibling, and fails on unknown/orphan sidecars. It never runs on actual SDK/source inventories or production modules. Source fixture bytes and all original assertions remain unchanged. New positive/negative controls verify metadata removal preserves its real sibling and rejects an unrecognized `._subject.h`; no decode exception is caught or waived. This is a disclosed filesystem-specific test-input adapter, not production scanner leniency. The initial overly broad synthetic directory-inventory expectation also encountered automatic metadata sidecars; its meaningful input assertion now compares all three real files directly to the checksum-verified archive members. This is stronger provenance evidence than an incidental file listing, and does not change production package inventory checks.

Final result: **60 scoped SDL Python checks pass**, including eight new setup regressions, with all `SDL_FIXTURE_TEST_*`/`SDL_SDK_TEST_*` keys removed before discovery (SDK source resolves under explicit scratch). Existing strict LF/autocrlf and canonical hash tests, six-target core/95GPU inventories, native package/layout/relocation unit checks, canonical SDL fixture assertions/staging, and real CMake script-mode header generation all run. Git touches only the existing fresh synthetic checkout under owned T7; no source history access. Python compilation and exact fresh patch replay/output hashes pass. Ruff check and format pass for all three new Python files and the two edited fixture/SDK tests. Explicit Ruff on the three pre-existing compact SDL3 test files still reports 49 E701/E702 style findings, exactly identical by file/rule/message before and after this setup patch; baseline/final JSON remains captured. No blanket suppression or broad formatting replacement was introduced. A directory-wide Ruff attempt also encountered automatic AppleDouble sidecars; verification uses the explicit eight declared Python source paths, not metadata files. No whole-suite Python lint pass is claimed. No native compiler/SDK library/interpreter/GUI/fault program or benchmark ran. No new Jai was edited; no new Jai formatter/linter result is claimed.

Final dependency guard detected a concurrent integration/bindings-owner change to `verify.py` after the first capture. That earlier hash is retained in the receipt, with the final hash separately recorded. All60 checks were rerun against current accepted verifier bytes; all nine selected shared dependency hashes remained stable before/after that final run. Our patch never modifies the verifier, and the sealed packet/source hashes remain intact.

This proves the scoped Python setup on the local Mac/T7 filesystem, not actual Windows/Linux native behavior or a passing entire compiler matrix. Workflow adoption and ordinary CI remain pending. Release/publication/tag/dispatch/comment holds remain.

The admitted new-patch hash and [source/output/hash receipt](sdl-python-matrix-833-receipt.json) contain the narrow transport. Prior sealed MojoShader patch SHA256 remains `6846d8fbbb58b262a9c2cfd9504a6a3f7e30e8a1c3369cd7c712d458f5c052ce`.

Integration adoption: both normal workflows now prepare these hash-pinned inputs before discovery. SDL CI runs all 60 scoped tests rather than only the SDL3 name subset. Fresh integration execution on T7 passed all 60 checks; actual native SDK/runtime CI remains required.
