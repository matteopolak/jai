# Metaprogram_Plugins public contract and compiler handoff

Portable worker, 2026-10-15. Priority: the filtered coordinator catalogue names
this module as Focus's first missing dependency. No application/vendor bodies or
raw corpus logs were inspected. The reviewed page currently specifies only three
declarations, Plugin_To_Create fields, named imports/factories and lifecycle.

Please synchronize the public parsing contract: whether arguments before the
first +Name are retained or rejected, how starting_index affects remaining_args,
whether '-' is consumed, module parameter suffix handling, invalid-index/name
failure behavior, and ownership of returned name/options/remaining slices. The
Default_Metaprogram page establishes its own CLI grouping; it does not establish
every observable contract of this independently callable helper.

The more consequential loader question is whether init_plugins accepts arbitrary
runtime-created requests during compile-time execution, or only names from the
top-level compiler command line known before type checking. Its declared inputs
contain no factory callbacks or Code values. A CLI-only static dispatch table
would leave arbitrary requested modules unsupported; I have not installed that
restriction or counted such a table as a complete implementation.

The real Default loader already proves ordinary generated imports and qualified
factories work. It generates those declarations before executing build(). That
strategy cannot by itself resolve module names first supplied inside an ordinary
init_plugins call. Please clarify the required public evaluation boundary rather
than supply any original private implementation.

General independent compiler probe:
tests/portable-stdlib/pending/dynamic-build-source-call.jai
adds a scoped #run during a stallable #run, then calls compiler_wait_for_message.
Actual output is 'before 0', 'after 0, message false', then 'added 41'. Thus added
code executes after the active caller returns; this probe does not establish an
API guarantee of reentrant evaluation and is NOT by itself a proven compiler bug.
No fabricated plugin, pointer-address serialization, source/module-name compiler
exception, or CLI bypass has been used. If general synchronous/reentrant added
code evaluation is the intended language contract, compiler owner must supply the
proper reusable mechanism and regression. If imports are required to be statically
known, review should establish that input constraint explicitly before the helper
is implemented around it.
