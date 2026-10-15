# Metaprogram_Plugins public contract and compiler handoff

RESOLVED: general compiler89560db9 adopted from the NEW independent producer,
active initializer and real computed-name/aggregate/empty/privacy/error workflows
pass with full context-aware strict lint. See portable-metaprogram-plugins.md and
target/metaprogram-plugins-active.log. Earlier dependency/draft text below is
retained historical failure evidence, not active requirements or completion gaps.

CURRENT reviewed capability: #placeholder Generated_Name; a typed procedure with
#insert Generated_Name has an available signature/value while its body waits.
Scoped add_build_string in the same workspace supplies its string declaration;
INDIRECT compile-time invocation then waits/resumes for that body. No undeclared
callee, message interception/pump/yield or exported macro attribute is involved.
The new independent compiler-plugin-evaluation producer probe was confirmed by
the filtered reference oracle. Only its NEW source was read, not reference logs.

Independent proper initializer is pending/metaprogram-plugins-deferred-init.jai;
run tools/check_portable_metaprogram_plugins.py --deferred-candidate. Current own
compiler reports Generated_Initialization placeholder never defined, matching the
confirmed peer probe failure. New worker reports local capability fix passes,
checkpoint not yet committed/integrated. Keep init_plugins pending until actual
computed-name factory/options/workspace and mismatch tests execute with the proper
compiler and full context-aware lint. Parser remains verified. The old direct-call
draft below remains rejected; no request to relax ordinary unknown/duplicate errors.

CORRECTION17:45: filtered coordinator oracle confirms the continuation probe also
fails official Jai0.2.030 with undeclared continuation. The timing probe is invalid
because it mutates build options after the workspace starts. The proposed
prefix-execute/resolve-callee suspension request is WITHDRAWN; it is not a required
compiler behavior and must not be implemented to satisfy the draft. Earlier claims
of a proven compiler gap below are superseded. No raw reference output or source
was read by this clean worker.

The reviewed dynamic-name public API remains required; dirty reviewer is refining
its valid evaluation boundary. Real parser support remains verified. Draft
pending/metaprogram-plugins-init.jai is explicitly REJECTED as an architecture,
retained for evidence outside active stdlib. The independently authored public
dynamic.jai fixture now avoids root build-option mutation and supplies a normal
main entry, so it can be used with the eventual proper initializer (pass an owned
-exe path when compiling). Do not treat --dynamic-candidate as an acceptance gate
or its unresolved call as a compiler regression. No CLI-only substitute added.

UPDATED17:24 review resolves the broad questions below. Dynamic names formed
during compile-time execution ARE required, and the parser/grouping/borrowing/
terminator/name-list consistency rules are now supplied. No CLI-only restriction
is acceptable. Historical requests below should not be cited as unresolved.

Real public parser and canonical record now pass interpreter/native O0/O2 and
strict lint. Supported invalid-index policy is false/original input; review does
not establish that edge outside the valid range. One narrow clarification remains:
when starting_index>0 AND plugins occur, are earlier args[0..starting_index)
retained? The independent implementation scans/retains from starting_index, while
the specified no-plugin path always returns the original slice. Current behavior
is documented, not claimed as reference evidence for the unclear prefix edge.

Compiler owner concrete positive tests:

- tests/portable-stdlib/pending/dynamic-build-source-continuation.jai: a stallable
  run adds a function, then must execute that function. Current compile fails
  'unknown identifier continuation' before the known prefix can add source.
- tests/portable-stdlib/metaprogram-plugins/dynamic.jai forms a name with String.join
  inside #run, requests module parameters, checks real init/options/workspace and
  rejects a changed parameterized name list. Independent Dynamic_Probe producer
  is under the adjacent modules/ directory; no application/vendor source used.

Initializer candidate pending/metaprogram-plugins-init.jai generates ordinary
qualified imports and a typed function, including all name/order consistency
checks, factory calls, result append/workspace assignment and aggregated init
success/no-init-option rejection. It uses real Compiler.add_build_string with
module Code scope, then calls that new function. The required general suspension/
source-processing/resumption mechanism belongs to the compiler; do not special-case
this function, path, module or test. At present the call fails before any factory
executes. No private source generation shim or fabricated record is a substitute.

Reproduce: python3 -B tools/check_portable_metaprogram_plugins.py --dynamic-candidate.
Parser tests pass, then the overall command correctly FAILS the positive dynamic
test with unknown initialize_imported_plugins. Evidence
target/metaprogram-plugin-dynamic.log. The ordinary runner without that switch
only claims parser support and says explicitly that init_plugins is incomplete.
Candidate has formatting/--check; strict lint cannot complete while that general
unresolved-call boundary fails. It is retained outside active stdlib until the
real dynamic initializer passes. The successful default CLI importer is not a
replacement for this broader API.

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
