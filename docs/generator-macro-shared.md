# Shared generator macro and expression completion

The ASN1/Socket worker owns exactly seven newly transferred public names:
`check_macro_value`, `raw_string_from_macro_tokens`, `string_from_macro_value`,
`get_scoped_token_string`, `expect_tokens`, `parse_call_expression`, and
`convert_children_to_expression`. Production belongs in the new
`Bindings_Generator/macro-expressions.jai` facade and
`internal/developer-tools/generator-macro-expressions.jai` algorithms. Integration
alone adds loads/exports and stages or commits. Existing parser, native C,
model, lifecycle and context files remain with their current owners.

## Canonical dependencies

`Generator`, `Declaration`, `Macro_Value` and all expression records already
exist in the shared public model. A macro is a `Declaration` whose
`macro_value_result` starts at `NEEDS_CHECKING`; its token-backed literal carries
`Macro_Value.tokens`. There is no separate public Macro record to create.
`Generator.translation_unit` and `tokens_to_free` own the native token lifetime.
The model owner already supplies `gm_token_unit`, token-view validation,
`gm_current_session`, `gm_build_expression`, `gm_native_literal`, and the shared
`generator-session` allocation protocol. Native children are captured with the
active Jai Context restored in the callback.

Thin public wrappers and private algorithms loaded into the existing module
will reuse these definitions. Independent imports, caches, copied Generator
state, allocator/context replacements and a second native parser/provider are
excluded. Session-owned expression/string/array allocations must use the
existing ledger; public return-string lifetime awaits the reviewed contract.
Essential native queries, allocations and cursor/state changes execute outside
optional assertions. A completed validation must genuinely evaluate supported
native input before selecting KEEP/DISCARD; pending state cannot be rejected as
if validation had occurred.

## Reviewed behavior and shared handoffs

Root released the source hold and supplied the reviewed **Shared emission and
parser helper contracts**. All seven bodies are now in the assigned files and
loaded once by integration. They pass actual interpreter and Mac ARM64 native
O0/O2 public regressions, strict complete-context lint and formatting.

* Scoped spelling borrows its native string for the caller's expansion scope,
  with disposal in that scope. It is not permanent owned storage.
* Raw rendering copies token spellings with one space between each. Checked
  rendering instead preserves adjacency from source extents, converts supported
  literals/replacements, resolves output names despite later omission, qualifies
  cross-enum values, normalizes comment line endings, and removes one fully
  enclosing parenthesis pair.
* Expected-token matching compares consecutive spellings and returns false when
  insufficient tokens remain. Negative starts are outside the reviewed domain;
  the independent safety policy diagnoses them without native out-of-bounds
  access.
* Call conversion represents supported constructor/aggregate initializers, not
  arbitrary runtime calls. It consumes an initial TypeRef, supports the reviewed
  null/sizeof cases, and rejects unsupported children. Final-child conversion
  uses the final native child, including returning null for a final declaration.
* Pending macro validation genuinely invokes the native evaluator before KEEP.
  The reviewed unsupported token forms, unresolved/self names and unsupported
  literal conversions lead to DISCARD. Unsupported diagnostics follow active
  `log_unsupported`. Validation retains the token expression and pre-existing
  public type; the established public mutation is its state decision.

Tools supplied real `maybe_append_cast` and
`binding_open_evaluation_probe(input, expression) -> TU, cursor, available,
supported`. Model supplied `gm_evaluate_macro_declaration` with the same two
result distinctions and canonical Literal/CType outputs. Missing exact inputs
leave validation pending with a diagnosis; evaluated unsupported values can be
discarded. The evaluator copies bounded payloads into the existing session
before disposing native evaluation/probe resources. Probe cursors are not
registered as canonical declarations.

The private `Parse_Input`/`Source_Overlay` receipt is borrowed by the existing
Session. It records the actual original parse filename, arguments and unsaved
overlays, whose bytes must remain alive through validation. An arbitrary external
TU's argument vector cannot be reconstructed from libclang. Tools still owns
production `run_generator` input capture; this batch's library-unit regression
supplies its exact original SDK inputs through that agreed private protocol,
with no alternate provider or context.

Independent SDK O0/O2 probes confirm null evaluation on MacroDefinition cursors,
correct scalar use evaluations, UTF-8 byte extent, embedded-NUL truncation and
wide code-unit width. They use the same official SDK image identified by the
canonical runtime receipt. This evidence is not a successful Jai API test.

## Implementation and validation sequence

1. Contract update, source release and exact private handoffs are captured.
2. Write unique public-API regressions. Confirm the missing symbol or supported
   behavior failure against the current shared library before adding bodies.
3. Final-child conversion and token comparison/rendering bodies are present with
   native spelling disposal and the reviewed ownership policy.
4. Supported call conversion uses canonical expression constructors; pending
   macro validation uses the exact owner adapter. Test pending
   lookup through `find_and_check_macro_identifier` rather than only the helper.
5. Source-build compiler/linter/formatter into this worker's unique T7 target.
   Use current shared production dependencies and source/SDK input hashes.
   Independent C/C++ SDK reductions establish token spellings, expression
   cursors/evaluations and string extents; they do not serve as reference Jai
   behavior.
6. Run actual interpreter and Mac ARM64 native O0/O2 public regressions, strict
   lint and formatting. Include malformed input, unsupported cursor forms,
   UTF-8/byte extent, embedded-NUL/wide-string handling, token/TU ownership,
   repeated validation, nested context and captured allocator lifetime. Supported
   token outputs must remain usable for precisely their promised lifetime.
7. Publish each of the seven rows independently as missing, partial or verified
   in `status/generator-macro-shared-audit.json`, with exact wiring and remaining
   platform dependencies. No native Linux/Windows/device inference; Android
   source selection remains blocked until a supporting clean compiler exists.

Broad GUI/native suites and shared PDB/CIE fixtures remain integration-owned.
All generated SDK vectors, probe translation units, native outputs and receipts
belong under the assigned ASN1/Socket worker T7 scratch namespace.

## Verified handoff

Final evidence is
`/Volumes/T7/codex-builds/jai-cleanroom-01a137eb/portable-asn1-socket/shared-target/generator-macro-verify-fmxjw5z3`.
Its receipt has 59 passing commands, zero failures and one blocked Android
command. Fifteen actual executions comprise five fixtures in interpreter and
native Mac ARM64 O0/O2. Thirty source checks cover those fixtures on macOS,
Linux and Windows x64/ARM64. All six lint contexts are complete; incomplete and
unvisited lists are empty. The source-built formatter passes. All 1,320 recorded
source inputs and the immutable physical header remained unchanged.

The state fixture checks ten supported macro decisions and twelve discarded
forms, plus unavailable exact-input handling. A separate consumer compiles and
executes the exact strings asserted by that fixture, including the truncating
cast, renamed enum/member, alias, UTF-8 and integer expressions. This checks Jai
syntax/meaning in addition to text comparison. Official SDK C/C++ reductions
at O0/O2 independently establish native scalar, string extent and AST facts.
The installed SDK is LLVM/libclang 23.1.2, matching the canonical runtime receipt;
the public reviewed `LIBCLANG_VERSION = 21` constant is unchanged and this is
not certification of every SDK version.

Run `python3 -B tools/check_generator_macro_shared.py` with this worker's
assigned absolute T7 `CARGO_TARGET_DIR` and source-build LLVM prefix configured.
The runner builds fresh compiler/linter/formatter tools, reads current shared
production directly, never edits facade wiring, and rejects source drift. It
exits 2 when only the required Android gate is blocked. Native other platforms
remain separate; source checks are not execution proof.

Integration alone stages/commits these owned new paths:

* `stdlib/Bindings_Generator/macro-expressions.jai`
* `stdlib/internal/developer-tools/generator-macro-expressions.jai`
* `stdlib/Bindings_Generator/tests/generator-macro-shared-state.jai`
* `tests/developer-tools/generator-macro-shared-{tokens,calls,invalid,state,consumer}.jai`
* `tests/developer-tools/generator-macro-shared-state.h`
* `tools/check_generator_macro_shared.py`
* This document and `docs/status/generator-macro-shared-audit.json`

The existing `Bindings_Generator/module.jai` load was integration's change.
Canonical model/session/evaluator files remain model-owned; the native probe and
cast helper remain tools-owned. No peer production file or git index was edited
by this worker. Suggested checkpoint subject:
`feat(stdlib): complete shared generator macro expression helpers`.

The [scoped API inventory](status/generator-macro-shared-audit.json) transfers
exactly seven verified-host names; it does not alter global totals or claim
whole-generator completion. Tools still owns canonical `run_generator`
parse-input capture and its broader missing workflows. An arbitrary externally
supplied TU without its exact receipt remains pending with a diagnosis, rather
than guessed configuration or a fake conversion decision. Native Linux/Windows,
translated Mac x64 and Android/device execution remain unverified; Android
source selection is still compiler-blocked.

## Preserved failures and invalidated measurements

`generator-macro-verify-gu09_d07` preserves the initial early spelling disposal,
wrong array-free argument and nonexistent logger failures. Caller-scope
escaping defer and the existing Basic APIs fixed those owned defects. The
fixture's missing String import is separately preserved; privacy failures were
resolved by a legitimate library-unit fixture, without changing visibility.

`macro-prefix-red-2z5einf5` independently shows native-valid
`1 && &outside` incorrectly kept when the operand is a canonical declared
constant. General operand tracking now rejects that prefix while preserving
binary `7 & 3`; a recognized cast followed by address-of also rejects. The
interpreter green reduction and final three-mode fixture cover the correction.

Two all-supported-gates-passing runs were still invalidated by real peer source
changes: `generator-macro-verify-bnyusqyc` (native probe helper) and
`generator-macro-verify-22slylg5` (expression normalization). They are retained
and never substituted for the final stable receipt. The earlier
`generator-macro-verify-ku0b6db0` is a stable four-fixture checkpoint superseded
by the final consumer-inclusive run.

An initial complex failing assertion showed differing interpreter/native line
numbers. Two independent pure-macro reductions agree at their actual lines
11/13; no general compiler defect was reproduced or claimed. No production
workaround was introduced.
