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
interpreter, native O0/O2 and actual WASM. Native corrective harness passed 17/17 checks (builds, native
execution, explicit unsupported-ABI diagnostics, and the reproduced compiler
blocker); diagnostic tests do not establish implementation of those facilities.
Evidence: artifacts/corrective-numerics-run.log, artifacts/numerics-verification,
artifacts/corrective-native-run.log and artifacts/numerics-corrective/results.json.

```sh
python3 tests/numerics/run.py --compiler artifacts/target/debug/jaic \
  --stdlib artifacts/stdlib-fresh
python3 tests/numerics/corrective.py
```

The tests still use clearly marked Input/Window_Type/Hash_Table fixtures. Fresh
peer Input and Window_Type are not available; canonical dependency checking must
fail normally until they arrive. Linux/WASM clipboard and native cursors remain
explicit unsupported integrations, not local substitutes. AppKit diagonal
cursors require macOS 15 or the documented caller callback. Font and Texture
spec questions remain in [questions](../specs/stdlib/numerics-questions.md).

## Formatting, lint and independent organization

Jailint built successfully from copied new compiler sources:

```sh
LLVM_SYS_231_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR="$PWD/artifacts/target" \
  cargo build --manifest-path artifacts/compiler-source/Cargo.toml -p jailint --locked
JAIC_STDLIB="$PWD/artifacts/stdlib-fresh" artifacts/target/debug/jailint \
  -D warnings --config jailint.toml -v -I "$PWD/tests/numerics/dependencies" \
  artifacts/stdlib-fresh/Math artifacts/stdlib-fresh/Sloppy_Math \
  artifacts/stdlib-fresh/Float16 artifacts/stdlib-fresh/Color_Interpolation \
  artifacts/stdlib-fresh/GetRect artifacts/stdlib-fresh/GetRect_LeftHanded \
  artifacts/stdlib-fresh/internal/numerics tests/numerics tools/numerics-format-driver.jai
```

Actual scoped jailint exits zero with no lint findings after replacing unused
test results with assertions. **It explicitly reports the augmented reproducer
does not compile, so that body is not linted.** Exit zero is not complete lint
coverage. No blanket suppression, rule disabling or generated-file exemption was
introduced. Evidence: artifacts/jailint-build.log and artifacts/corrective-lint.log.
Owned production files in staged paths are byte-identical copies of owned sources;
staged roots are necessary for the compiler's internal-import visibility policy.

Actual full jaifmt CLI build is still blocked:

```text
jaifmt/main.jai:70:27: error: unknown identifier is_directory
```

Fresh File_Utilities lacks the reviewed API. Earlier Basic tool dependencies were
staged with real implementations of reviewed tprint/exit and the documented
print-to-builder alias. No peer writes were made. The reproducible staging flags
are --compiler-library ../compiler/stdlib --formatter-bootstrap and
--repair-foundation-buffer-alias. These are tool bootstrap repairs, not canonical
production integration claims. Evidence: artifacts/jaifmt-build.log.

To execute actual formatting while that CLI is blocked,
tools/numerics-format-driver.jai wraps the **unaltered repository
Extensions/Jai_Format** engine with the root jaifmt.toml. It reads stdin, calls
parse_config/format_source, checks errors, and writes the result. All 52 owned Jai
files were formatted and `python3 tools/numerics_format.py --check` passes with
zero changes. This is an actual repository-engine check, **not** a claim that
jaifmt/main.jai or jaifmt --check passed. No Extensions were modified. Build it:

```sh
JAIC_STDLIB="$PWD/artifacts/stdlib-fresh" artifacts/target/debug/jaic \
  tools/numerics-format-driver.jai -O2 -exe "$PWD/artifacts/numerics-format-driver"
```

Both generators normalize emitted sources with this engine. Actual regeneration
and formatting are byte-idempotent. Math facade order follows our private
types/scalars/vectors/quaternions/matrices/geometry responsibilities; smaller
facades use independently specified responsibility/dependency orders. UI records
are ordered foundations, callbacks, dependent themes, then widget state; fields,
unions, explicit enum values and overload order are preserved. Spec listing order
only validates the required name set. Coordinator must rerun full jaifmt/jailint
when canonical dependencies and the generic semantic decision are available.
