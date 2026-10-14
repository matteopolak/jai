# Corrective numerics review

The prior handoff is not complete. Fixture tests prove isolated algorithms and
mechanisms, not native or canonical integration.

1. Replace the module-local clipboard with native synchronization, propagate
   backend failures explicitly, and test a private named native pasteboard so
   verification never reads or overwrites the user's clipboard.
2. Remove fabricated font metrics. Use known caller-requested font sizes where
   available and diagnose unavailable concrete metrics. Ask the spec reviewer
   for the defining Font/Texture ABIs and ownership contract in the questions doc.
3. Produce a minimal language-only reproducer for augmented keyframe generic
   matching and document the semantic decision required from the compiler owner.
4. Organize facade declarations by independent algorithm/lifecycle categories,
   preserve aggregate/enum ordering, and make generation plus formatting stable.
5. Build repository jaifmt and jailint from new sources, format all owned Jai
   sources/tests, run scoped checks, fix findings, and record unresolved tool
   dependencies with exact diagnostics.
6. Retry canonical dependency integration and run focused/native/WASM tests;
   keep accepted behavior and remaining gaps distinct in the status document.

## Delivered corrective behavior

- macOS native clipboard uses public CoreFoundation/Pasteboard C APIs. Empty,
  multiline and non-ASCII/emoji text round-trip through two independently opened
  native handles on an isolated named pasteboard. A second write is observed by
  the already-open reader, exercising synchronization. All references and copied
  buffers are released. Native O0 and O2 pass. No user clipboard is accessed.
- Windows backend implements CF_UNICODETEXT with strict UTF-8/UTF-16 conversion,
  movable global allocation, bounded reads, transfer of ownership on success,
  cleanup on failure and explicit native error propagation. Requires caller HWND
  for writes. Target checks pass; Windows runtime behavior is not verified here.
- Native AppKit cursor creation/retain/release passes O0/O2 lifecycle tests.
  Windows uses shared LoadCursorW handles, never destroys them. A caller cursor
  callback takes precedence. Repeated init_pointers releases previously owned
  macOS references. Native creation does not change the visible test cursor.
  Public init_pointers is also called repeatedly in both UI variants, and the
  caller cursor callback is verified to take precedence, without setting a
  visible system cursor. This UI test uses the marked dependency fixtures.
- Invented 16-pixel metrics and local clipboard storage were removed. Caller
  prepare_text width and explicit finite theme baseline now drive tested draw
  coordinates/rounding and prepare-before-draw sequencing in both UI variants.
  Missing Font metrics emit an explicit diagnostic and trap. Shared contextual
  Font/Texture/Font_Effects identities are identical between variants; external
  defining-module/ABI integration is still missing.
- Unsafe Texture identity-token allocation was removed. require_texture reports
  the absent concrete ABI/ownership contract and traps, rather than letting a
  renderer write into undersized storage. Missing-ABI diagnostics are tested O0/O2
  separately from supported functionality. This facility is not complete.
- The [generic restriction reproducer](numerics-compiler-handoff.md) fails with
  the exact documented compiler diagnostic. No compiler ownership boundary was
  crossed and no public #as annotation was invented.

## Actual verification and limitations

Corrected suite passed 93/93 checks including the focused renderer test in the
interpreter, native O0/O2 and actual WASM. Native corrective harness passed
21/21 checks (builds, native
execution, explicit unsupported-ABI diagnostics, and the reproduced compiler
blocker); diagnostic tests do not establish implementation of those facilities.
Evidence: artifacts/corrective-numerics-run.log, artifacts/numerics-verification,
artifacts/corrective-native-run.log and artifacts/numerics-corrective/results.json.

```sh
python3 tools/stage_numerics.py --destination artifacts/stdlib-verification \
  --compiler-library ../compiler/stdlib --repair-foundation-buffer-alias \
  --manifest artifacts/numerics-production-staging.json
python3 tests/numerics/run.py --compiler artifacts/target/debug/jaic \
  --stdlib artifacts/stdlib-verification
python3 tests/numerics/corrective.py --stdlib artifacts/stdlib-verification
```

The tests still use clearly marked Input/Window_Type/Hash_Table fixtures. Fresh
peer Input and Window_Type are not available; canonical dependency checking must
fail normally until they arrive. Linux/WASM clipboard and native cursors remain
explicit unsupported integrations, not local substitutes. AppKit diagonal
cursors require macOS 15 or the documented caller callback. Font and Texture
spec questions remain in [questions](../specs/stdlib/numerics-questions.md).
Canonical checking was retried against the newly staged production library:
artifacts/canonical-ui-check.log reports missing Input. With only Input and
Window_Type fixtures, artifacts/canonical-hash-check.log proves the remaining
canonical Hash_Table failure is absent get_hash(u64), not a numerics workaround.

## Formatting, lint and independent organization

Jailint built successfully from copied new compiler sources:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR="$PWD/artifacts/target" \
  cargo build --manifest-path artifacts/compiler-source/Cargo.toml -p jailint --locked
JAIC_STDLIB="$PWD/artifacts/stdlib-verification" artifacts/target/debug/jailint \
  -D warnings --config jailint.toml -v -I "$PWD/tests/numerics/dependencies" \
  artifacts/stdlib-verification/Math artifacts/stdlib-verification/Sloppy_Math \
  artifacts/stdlib-verification/Float16 artifacts/stdlib-verification/Color_Interpolation \
  artifacts/stdlib-verification/GetRect artifacts/stdlib-verification/GetRect_LeftHanded \
  artifacts/stdlib-verification/internal/numerics tests/numerics
JAIC_STDLIB="$PWD/artifacts/stdlib-format-repro" artifacts/target/debug/jailint \
  -D warnings --config jailint.toml -v tools/numerics-format-driver.jai \
  tools/numerics-formatter-files.jai tools/numerics-formatter-basic.jai
```

Actual scoped jailint exits zero with no lint findings after replacing unused
test results with assertions. **It explicitly reports the augmented reproducer
does not compile, so that body is not linted.** Exit zero is not complete lint
coverage. No blanket suppression, rule disabling or generated-file exemption was
introduced. Evidence: artifacts/jailint-build.log, artifacts/corrective-lint.log,
and artifacts/corrective-tool-lint.log. The latter checks all three tool helpers
with their necessary host-tool dependencies and has no partial-compilation note.
Owned production files in staged paths are byte-identical copies of owned sources;
staged roots are necessary for the compiler's internal-import visibility policy.

The initial full jaifmt build failed at the missing reviewed File_Utilities
is_directory API. It subsequently also needed visit_files and Basic working
directory/argument support. **This tool blocker is now closed locally.** No peer
checkout was changed. Actual fresh staging plus full CLI build/check succeeds:

```sh
python3 tools/stage_numerics.py --destination artifacts/stdlib-format-repro \
  --compiler-library ../compiler/stdlib --formatter-bootstrap \
  --repair-foundation-buffer-alias \
  --manifest artifacts/numerics-formatter-staging.json
JAIC_STDLIB="$PWD/artifacts/stdlib-format-repro" artifacts/target/debug/jaic \
  jaifmt/main.jai -O2 -exe "$PWD/artifacts/jaifmt-repro"
artifacts/jaifmt-repro --check --config jaifmt.toml --verbose \
  stdlib/Math stdlib/Sloppy_Math stdlib/Float16 stdlib/Color_Interpolation \
  stdlib/GetRect stdlib/GetRect_LeftHanded stdlib/internal/numerics tests/numerics \
  tools/numerics-format-driver.jai tools/numerics-formatter-files.jai \
  tools/numerics-formatter-basic.jai
```

Actual result: **55 files checked, zero would change, zero ignored, zero errors**.
The formatter reports 253 advisory lines exceeding max_width; it does not wrap
those expressions and they are not check failures. No lint rule was suppressed.
Evidence: artifacts/jaifmt-repro-build.log, artifacts/jaifmt-check.log,
artifacts/formatter-staging.log and artifacts/numerics-formatter-staging.json.

tools/numerics-formatter-basic.jai supplies real macOS tool-bootstrap working
directory lookup (grow-on-ERANGE with explicit failures), temporary formatting and
native exit. tools/numerics-formatter-files.jai supplies stat-based directory
queries and recursive native traversal with metadata, visitor pruning, symlink
controls, cycle detection and explicit error return/closedir checks. The reviewed
Basic print-to-builder alias is added only in tool staging. The newly available
peer Basic argument API is used canonically. These are host-only tool bootstrap
repairs, **not** canonical production integration claims; production test staging
does not include them and remains suitable for cross-target verification.

Before the CLI was available, tools/numerics-format-driver.jai executed the
unaltered repository Extensions/Jai_Format engine with root config. That driver
remains a fallback; normalization now prefers the actual full CLI with explicit
root config. No Extensions were modified.

Both generators normalize emitted sources with the repository formatter. Actual regeneration
and formatting are byte-idempotent. Math facade order follows our private
types/scalars/vectors/quaternions/matrices/geometry responsibilities; smaller
facades use independently specified responsibility/dependency orders. UI records
are ordered foundations, callbacks, dependent themes, then widget state; fields,
unions, explicit enum values and overload order are preserved. Spec listing order
only validates the required name set. Coordinator must rerun full jaifmt/jailint
when canonical dependencies and the generic semantic decision are available.
