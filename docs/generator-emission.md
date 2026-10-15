# Reviewed generator emission helpers

All ten names reassigned in `status/reassigned-scope.json` are implemented in
`Bindings_Generator/emission-helpers.jai` and independently organized private
`internal/developer-tools/generator-emission.jai`. Both alignment and spacing
overloads are implemented, with one cursor-name implementation across configured
targets. The prior platform scope remains complete and its code is preserved.

The reviewed behavior is in `specs/stdlib/modules/bindings-generator.md`, public
behavior details. The 16:14 review resolves the earlier emission questions; the
initial provisional policies are superseded. No assigned API remains blocked.

- Comment prepending uses one space, preserves location, and borrows the input
  when there was no previous text. Combining two nonempty strings allocates new
  storage; the caller retains responsibility for its previous input storage.
- Prefix comments have a recorded line or an embedded LF. Prefix emission trims
  spaces/tabs/CR from each split line, emits a newline and then optional current
  indentation. It does not insert initial indentation. Postfix comments are
  nonempty non-prefix comments, emitted with one preceding space and normalized
  CRLF/CR line endings.
- Alignment uses output-name byte counts for declaration/typedef/macro/bitfield
  members, excludes extern members, and adds qualifier widths unless ignored.
  Functions and all other categories are ineligible, so function-global-movement
  options do not affect these eligible categories. It does not fall back to source
  names or treat OMIT_FROM_OUTPUT as a qualifier. Null members are diagnosed.
- Both spacing overloads always store the new location. Ordinary entries get
  one newline; mimicked source gaps/file changes add one more. NO_SPACING removes
  the ordinary newline. The category overload intersects the active options.
  Line arithmetic avoids wrapping at the u32 boundary.
- Native comment filling trims raw text, copies nonempty text, and records the
  expansion location only when it precedes the declaration. An absent comment
  preserves both existing fields. Conditional filling refreshes unset metadata
  or the cursor's definition, preserving existing comments when no new one exists.
- Cursor names are owned copies; names containing ` at ` normalize to empty.
  Debug printing logs descendants through the caller's logging context, with
  nesting indentation and no log for the supplied root. Traversal uses libclang.

## Canonical state and integration

`internal/developer-tools/generator-session/module.jai` is the sole unparameterized
owner of `context.generator: *void` and `context._bindings_generator_options: *void`.
`gp_current_generator()` and `gp_current_options()` privately recover the
consuming module instance's canonical types. No duplicate Context fields,
canonical records, options copies, generator registries or compiler exceptions
are introduced. The run owner installs pointers to its canonical records; callers
retain lifetime and nested context/restoration responsibility. A null active
options pointer is diagnosed by the category-spacing overload. The plain boolean
overload needs no options. Comment filling follows the reviewed native contract
and does not invent a preservation-option gate.

The integrator/tooling/model owners were notified in `worker-inbox.md` of the
exact access protocol and the single `#load "emission-helpers.jai"`. The facade is
loaded locally for actual public-import verification. Shared orchestration stays
with its owner; integrate `tools/check_generator_emission.py` once.

## Unspecified edge policies

Empty prepend input leaves existing text unchanged. A terminal LF produces a
final empty split line; every split line is emitted. When both qualifier flags
are present, using takes precedence over as. Unset locations have a null file;
definition identity uses `clang_getCursorDefinition`, including a later definition
following an earlier forward declaration. Non-leading comment replacements leave
an existing comment location unchanged. Replaced owned strings are not implicitly
freed because inputs can be borrowed. These safe choices concern edges and
ownership left unspecified by the review, not claims of additional reference
behavior.

## Verification and boundaries

`python3 tools/check_generator_emission.py` checks actual public imports in Mac
interpreter/native O0/O2, official SDK C oracles at O0/O2, six desktop source
checks, jaifmt and warnings-denied module-root/fixture lint. The fixtures cover
output, ownership, alignment eligibility, both spacing overloads, overflow bounds,
two configured instances, nested shared options, native leading/trailing/absent
comments, forward declarations versus definitions, anonymous names and descendant
logging with original SDK traversal counts/depth. The original header, native
facts and execution boundaries are recorded in `native/generator-emission-evidence.json`.
Missing active options and negative indentation are checked for real assertion
diagnostics in interpreter/native O0/O2; no empty success result substitutes for
those invalid calls.

The SDK oracle distinguishes tentative C declarations from an initialized
definition; the fixture uses an actual initialized definition to verify metadata
refresh. No compiler relaxation or special case was needed.

Runtime evidence is macOS arm64 only; other desktop targets are source checks.
The fresh combined replay for completion checkpoint `368f544a` still fails the unchanged `bindings-macros.jai:43`
callback diagnostic gate described in `generator-platform-macro-cause.md`, after
passing the prior platform/SDK setup stages. That proper-owner issue is independent
of the assigned helper implementation and is not suppressed here.
