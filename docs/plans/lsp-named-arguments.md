# Named argument completions

Goal: offer genuine callable parameter names at argument-name positions while
retaining ordinary expression/member completion. Implement autonomously in the
owned producer; no peer edits, compiler lookup exceptions or approval pause.

Use compiler lexer/parser punctuation rules for nested argument boundaries,
comments, strings, spreads and context overrides. Query current semantic callee
references/actual selected calls. When the unfinished call is omitted by IDE
recovery, analyze its original callee expression with its argument-list region
removed in a position-preserving IDE query view. This supplies real declarations,
not guessed names, synthesized signatures or placeholder argument values.

Read actual procedure headers/signatures. The audit rejected shared procedure-type
metadata: distinct same-shaped callbacks leak each other's names. Request
declaration/value-bound metadata from compiler ownership; indirect named-call
completion is explicitly unavailable until that prerequisite lands.
Union/deduplicate structurally applicable unresolved overload candidates; prefer
a recorded unambiguous selected overload when available. Simulate real argument
slot placement with each suggested name, excluding names already supplied and
positional slots, including arguments after the cursor. Keep defaults available,
respect variadics. Never invent
implicit receiver or context parameters. No suggestions for unknown callables or
procedure types whose parameter-name metadata is unavailable.

Insert `name = ` with a whole-word replacement. Keep an existing `=`; normalize
an already typed colon/colon-assignment separator in the accepted edit rather
than duplicating it. Suppress name suggestions inside values/member access,
comments, strings, nested aggregate/grouping expressions and context overrides.
Reuse normal completion resource limits and UTF-16 range conversion.

- [x] Add original unit/API and native stdio regression cases; observe missing
  named completions before implementation.
- [x] Add one focused owned module and a narrow completion merge hook; avoid
  compiler changes and retain cf7dd80/5214e9c prerequisites.
- [x] Validate defaults, positional/named ordering, overload deduplication,
  variadics, nesting, methods and callback no-leak boundaries, privacy, UTF-16 edits and accepted edits.
- [x] Run focused checks against a fresh safe shared compiler snapshot and real
  production Basic through native LSP requests. All scratch/captures/targets T7.
- [x] Update feature docs/index and progress/deviations, review and commit with
  a conventional issue-free message. Record final merged verification needs.

Alternatives rejected: source-name scans could expose private or unrelated
parameters; hardcoded library completions would bypass resolution; replacing
ordinary completion would hide valid argument expressions. Broad corpus/scanner
changes belong to the assigned compiler owner and are outside this batch.
