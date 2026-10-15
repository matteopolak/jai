# Reassigned generator emission helpers

Ownership is the ten names in `status/reassigned-scope.json`, independently
organized in `Bindings_Generator/emission-helpers.jai` and
`internal/developer-tools/generator-emission.jai`. Prior platform helpers and
their verified completion checkpoint remain intact. The authorized clean
candidate `7467b49d` supplies model dependencies when needed; the already adopted
canonical Generator/Comment/Location/Declaration records are sufficient for the
first batch, so no peer source is replaced.

The design uses the existing unparameterized context slot for indentation and
owner-provided options access for preservation/spacing. It introduces no records,
singleton storage, parameterized Context fields, or compiler exceptions.

Work proceeds in three verified batches: pure string/alignment/indentation
effects; libclang cursor/comment effects with original native SDK oracles;
options-dependent spacing and fill policy. Tests cover caller-visible output,
mutation, lifetimes and malformed inputs in interpreter and Mac native O0/O2.
Formatting and strict lint run on the dedicated files and module facade.

## Independent policy pending review

The supplied reviewed page currently specifies signatures without the formatting
and selection details asked in `specs/questions/generator-emission.md`. Until a
reviewed answer arrives, the first batch uses these explicit independent choices:

- Prepending nonempty text inserts a newline before nonempty existing text;
  empty text leaves the comment unchanged. The combined text is a fresh owned
  allocation; existing input storage is borrowed and is never freed implicitly.
- Raw trailing Doxygen markers `///<`, `//!<`, `/**<`, `/*!<` distinguish postfix
  comments. Prefix emission preserves bytes, optionally indents each line, and
  appends a newline only when absent. Postfix emission preserves bytes and inserts
  one preceding space; it does not terminate the declaration's line.
- Alignment uses the maximum byte count of `output_name`, falling back to `name`,
  excludes omitted declarations unless `ignore_flags`, and adds no padding.
- Indentation repeats TAB_STRING `Generator.tab_depth` times; negative depth and
  missing active Generator are diagnosed by assertions before output mutation.
- Cursor names are fresh owned copies of libclang spelling, including empty
  spelling. Debug printing is an explicit diagnostic operation on one cursor,
  showing kind, spelling and spelling-location line/column without recursion.

These policies are not claims of reference equivalence. Names remain partially
implemented in the inventory until reviewed behavior and actual checks agree.

## Verified checkpoint

`python3 tools/check_generator_emission.py` passes actual public behavior in Mac
interpreter/native O0/O2, official SDK C cursor oracles at O0/O2, six desktop
source checks, jaifmt and warnings-denied module-root/fixture lint. The fixture
imports two configured generator instances and exercises each through the one
shared Context field, including zero indentation. No duplicate field exception
is used. Native cursor names are copied before disposing their CXString and two
independent returned names are checked for mutable aliasing.

Seven names have working implementations under documented independent policies:
`prepend_comment`, `append_prefix_comment`, `append_postfix_comment`,
`get_name_alignment` (both overloads), `append_indentation`,
`get_name_for_cursor` (one implementation across configured branches), and
`debug_print_cursor`. Reviewed-contract confirmation is still outstanding for
these names, so they remain partial rather than complete in the matrix.

Three names are not implemented yet: `maybe_add_spacing` (two overloads),
`fill_comment`, and `fill_location_and_comment_if_needed`. Their exact unanswered
contracts are questions 4, 6 and 7; their common dependency is the tooling owner's
single active-options access protocol. No substitute options singleton or public
no-op body is installed. See `status/generator-emission-progress.json`.

The complete prior platform suite also passes with the new facade loaded.
Runtime evidence is Mac only; other desktop targets are source checks.

The native fixture also verifies raw-comment CXString and comment-range ABI
against the original C oracle: the leading comment starts at 1:1, trailing
comment at 3:11, and the uncommented variable has an empty string/null range.
These are observed official SDK facts for the original fixture, not a decision
about the unresolved `fill_comment` policy. Both SDK O0/O2 and Jai
interpreter/native O0/O2 agree.

The combined `tools/check_developer_tools.py` replay after `e91f33f6` passes the
private bindings pipeline, prior platform suite, C++ callbacks, configured SDK,
Debug lifecycle, native ABI and profiler setup stages. It then fails at the
unchanged `bindings-macros.jai:43` gate, matching the independently reduced lost
string-macro diagnostic in `generator-platform-macro-cause.md`. The proper owner
was notified through the mailbox. This checkpoint does not claim a green combined
suite or alter its gate.
