# Named call parameter completion

At an argument-name position, jailsp offers parameters of the resolved procedure:
for example `print("hello", to_sta` offers `to_standard_error` from the reviewed
public Basic signature. Ordinary expression and member completions remain available.
Accepting a name inserts `name = `, replaces the complete word (including the tail
after the cursor), preserves an existing `=`, and normalizes an already typed `:`
or `:=`. A colon is not accepted Jai named-argument syntax.

## Implementation and contracts

`src/named_arguments.rs` uses compiler lexer tokens to find the innermost call and
its top-level argument boundaries. Strings/comments are opaque; grouping, nested
aggregate expressions, member access, argument values and `,,` context overrides
do not offer parameter names. UTF-16 positions use the ordinary document index.

Actual compiler `IdeCall.chosen` metadata takes precedence when the current call
resolved unambiguously. Otherwise current callee references provide real candidates;
when those are unavailable a position-preserving IDE query keeps the real
callee and enclosing scope, masks the argument contents, and retains matched call
parentheses. An unfinished call becomes a terminated callee expression. Normal
compiler lookup supplies its actual `IdeWhat::Procs` overload set. The query does
not supply dummy values, infer declarations from spelling, publish diagnostics,
or change CLI compilation. Its names come exclusively from real procedure headers.

Each candidate name is checked against every supplied argument, before and after
the cursor, using the compiler's direct-call slot placement rules. Named arguments
advance the positional cursor; variadic lists retain it until a spread advances it.
Occupied parameters are excluded, including named variadics. Defaults stay available.
Unresolved overload sets are unioned and deduplicated by parameter name. Parameters
of a resolved overload use that selected header. No implicit receiver/context name
is invented. The ordinary completion result cap remains effective.

For supplied arguments with current, nonconflicting scalar expression facts, the
compiler's `implicit_cost` rejects proven type-incompatible candidates. It never
uses type IDs across compiler instances. Missing/conflicting/context-dependent
facts remain unknown; source text is not assigned dummy types. Invalid non-generic
headers produce no parameter items and retain their real diagnostics.

Original fixture contracts derive from the supplied compiler's parser and
`sema/calls.rs::assign_slots`; the production check uses
[reviewed Basic signatures](../specs/stdlib/modules/basic.md).

## Explicit limits and compiler-owner prerequisite

- For an incomplete call with no selected overload, structural argument placement
  and proven scalar incompatibility filter the real candidate set. Full overload
  ranking remains the compiler's job. Operand flags/values are absent from IDE type
  facts, so quotation, pointer auto-dereference, procedure values, aggregates,
  polymorphic constraints and contextual conversions remain conservatively unknown.
  Even constants need care: untyped arithmetic and one-byte string conversion are
  value-dependent. Original regressions preserve Code quotation, pointer-to-struct
  arguments and byte literals. Compiler ownership should expose operand-aware
  incomplete-call compatibility rather than duplicate conversion semantics here.
  Named polymorphic binders outside the header parameter list currently prevent
  named suggestions; those names are not invented as public header parameters.
- Calls through procedure values are **not supported for named completion yet**.
  The current compiler's structural `TypeId`-keyed `proc_type_params` map can contain
  a different declaration's names/defaults. An independent two-callback regression
  returned `private_option` for a callback declaring `public_option`. The unsafe
  attempted path was removed; negative regressions ensure those names cannot leak.
  This is an implementation dependency, not an unspecified public API or a passed
  callback feature. Compiler ownership must bind callable metadata to the selected
  declaration/value and expose it to IDE queries before this can be enabled.
- Callees ending in a subscript or another call have no supported procedure-identity
  association here. Named procedures, imports, aliases and structure-associated
  procedures use real identities. Ordinary completion still operates in other cases.
- Fresh malformed opaque lexical regions without a verified closing boundary may
  preclude call-context recognition. Existing ordinary completion/recovery is retained.
- Context discovery scans current lexer tokens. An unresolved call may require an
  additional compiler query view. No performance benchmark was run in this batch.
  Future optimization should cache version-bound tokens and expose incomplete-call
  facts directly; never reuse stale semantic facts.

Minimal compiler-owner reproducer (analyze only; no execution needed):

```jai
Holder :: struct { callback: (public_option := false) -> int; }
Other :: struct { callback: (private_option := false) -> int; }
main :: () { h: Holder; other: Other; h.callback(); }
```

The missing-argument diagnostic is expected. The defect is that the resolved
`h.callback` type's shared metadata contains `private_option`. Original failure:
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/scratch/named-arguments-20261016/metadata-audit.log`.
The initial callback fixture assumed a source declaration guaranteed unique type
metadata. That test oracle was disproved by this reduction; callback support is
reported unavailable rather than counted as a successful production implementation.

## Verification and reproduction

All new outputs are under
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/`; no internal-disk fallback.
The authorized `integration-clean` normalized source snapshot fingerprint is
`54e154044d20746ac1d12a98c485bbf966d2a09f7208e3efe6e263591f74ca27`.
The initial copier receipt also hashed T7 AppleDouble metadata, producing
`6b22bdece46c37c484c2370d2b2827f4da0d964bcca08a698b16aa46d4456c09`;
normalization excludes `._` metadata files, not source. The effective staged
compiler/LSP/test fingerprint is
`3bd1be15d2c9e3f671dca2e356fab8c7f896c01d354a40538027c9281c248616`.
The final shared-source audit found no input change since the snapshot.
The source-copy workflow is `tools/lsp_basic_resolution.py::snapshot`, which copies
only explicit compiler/lint/LSP sources and independent Jai stdlib sources. Candidate
sources required earlier handoffs `cf7dd80` and `5214e9c`; both were applied to the
private dependency snapshot. No peer source or bootstrap was modified. Feature
overlays contain only the new LSP module, module registration and completion hook.

Use a separate `CARGO_TARGET_DIR` for this snapshot to prevent same-package artifacts
from mixing with older worker compiler builds. With `candidate` below pointing to
the staged source root and `CARGO_TARGET_DIR` set to the assigned T7 target:

```sh
cargo test --manifest-path "$candidate/Cargo.toml" -p jai-language-server \
  --lib --bins --test named_arguments --test partial_edits
cargo clippy --manifest-path "$candidate/Cargo.toml" -p jai-language-server \
  --lib --bin jailsp --test named_arguments --test partial_edits --no-deps -- -D warnings
cargo build --manifest-path "$candidate/Cargo.toml" -p jai-language-server --bin jailsp
PYTHONDONTWRITEBYTECODE=1 python3 tools/lsp_named_arguments.py \
  --binary "$CARGO_TARGET_DIR/debug/jailsp" --stdlib "$candidate/stdlib" \
  --output /Volumes/T7/codex-builds/jai-cleanroom-01a137eb/lsp/scratch/named-native-new
```

Native requests cover imported and qualified production Basic, overload union,
defaults, positional/named filtering, nested calls, associated procedures, private
imports, the callback no-leak boundary, accepted edits with existing separators,
hover/definition after acceptance, and ranged UTF-16 edits changing/restoring the
callee. Two fresh processes distinguish cold-server behavior from cached results.
No Jai program or `exit` call is executed. Transport `exit` only closes the server.
Failure captures remain on T7; no failed assertion is ignored.

Final executed results (2026-10-16): 25 library unit tests, ten new API regressions
and 20 existing partial-edit/navigation regressions passed (55 total); the binary
test target contains zero tests. Scoped Rust formatting and Clippy `-D warnings`
passed, as did Python syntax validation. The rebuilt native server passed 18
document phases on two fresh servers: 20 completion, six hover and six definition
requests, with six accepted-edit checks and two UTF-16 incremental callee changes.
Receipts: `scratch/named-arguments-20261016/{focused-final.log,clippy-final.log,
build-final.log,native-reviewed-final/report.json}` under the assigned T7 root.
No repository Jai file or stdlib source was modified; malformed Jai documents
are embedded test/protocol payloads, not formatter input or executable programs.

Harness corrections are separate from production work: an empty argument between
two commas was incorrectly expected to be a procedure parameter position, whereas
the parser treats `,,` as context overrides; the corrected fixture types a real
name prefix. A local module fixture initially omitted the documented `modules/`
search directory. Server reopen versions now remain monotonic so the diagnostics
helper cannot select an earlier publication with the same URI/version. The original
failed captures remain at `native-first`, `native-second` and their `.log` files;
those runs are excluded from passing evidence. The metadata audit's failed positive
callback assertion is retained separately; final tests assert no fabricated/leaked
names while recording callback completion as unavailable.
`typed-overloads-red.log` independently records the unselected scalar-overload gap
before the expression-fact filter. `clippy-typed-failure.log` preserves the ensuing
question-mark style finding; it was fixed without suppressing the lint.

Final merged verification must repeat these actual requests with the integrated
compiler, production stdlib, LSP and both navigation prerequisites, then the
coordinator's complete corpus/editor gates. This worker candidate is not merged,
release, native Windows, full-corpus or callback-metadata acceptance evidence.

## Shared integration review

The shared compiler already contains equivalent cf7dd80/5214e9c entity-span prerequisites; no duplicate semantic patch was applied. Safe filtered b064be58 feature source is integrated without its staging overlay. A fresh integration target passes 59 focused tests (25 library, 10 named argument, 20 partial edit, 4 qualified value). The native request tool now accepts explicit output paths and rejects overlap with stdlib instead of hardcoding another worker namespace. Its transport import preserves bytecode prevention without an E402 suppression. Production candidate native requests remain a separate gate; original corpus scale tests remain coordinator-owned.
