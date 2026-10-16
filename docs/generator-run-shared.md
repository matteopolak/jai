# Canonical generator runner

Owner: portable-asn1-socket. This batch transfers `run_generator` and
`handle_toplevel_cursors`; tools retains the existing driver and printers.

The implementation uses the existing Generator, model constructors and Session.
Native parse input must be retained exactly in that Session, including original
argument order and any generated unsaved aggregate input. The public deinit
boundary owns token/TU/index disposal. No parse arguments can be reconstructed
from an unrelated supplied translation unit.

Implementation sequence:

1. Independently test the native top-level callback: supplied Context restoration,
   linkage/unexposed recursion, native system-header exemptions, omission counts,
   canonical identity, function equivalence, equal/differing macro redefinitions.
2. Capture actual run inputs with the canonical allocation ledger, install stable
   options and construct the native translation unit and canonical declarations.
3. Reconcile reviewed run stage ordering and failure behavior with tools/model.
   Exercise configured macro evaluation through the public runner, lifetime,
   malformed options, multiple source files and native diagnostics.
4. Validate fresh immutable current-source snapshots with the source-built
   compiler, interpreter, Mac native O0/O2, formatter and strict lint. Android and
   other native platforms retain their separate unverified gates.

Integration alone adds `#load "generator-run.jai";` once in the public module,
after the existing macro facade. No existing driver/model/provider is replaced.

The callback body now restores the supplied captured Context, traverses
linkage/unexposed containers, uses native system classification with direct
name/path exemptions, passes ignored status into canonical constructor intake,
and marks/counts the retained ignored declarations. Ignored namespaces inherit
type-only intake; a nested name alone cannot exempt its enclosing namespace.
Record members retain their ordinary construction contract. Pointer-identical declarations are not inserted
twice. Distinct equivalent functions are omitted; equal macro definitions are
not duplicated; differing definitions replace the prior global entry with a
warning. No essential operation occurs inside optional assertions.

The original SDK reduction established that functions inside `extern "C"`
have a linkage semantic parent, requiring transparent-parent traversal before
canonical construction. It also established that repeated prototypes share
canonical identity, while pointer/reference overloads have distinct native
cursors. The reviewed model deliberately treats the latter parameter types as
equivalent. SDK predefined constants can be system declarations. The reviewed
filter suppresses those macro cursors at intake; earlier callback receipts that
retained all of them did not prove this subsequently clarified obligation.

The real public `run_generator` body uses `gr_parse_input` and `gr_parse` to
retain actual ordered arguments and primary unsaved input in the existing
ledger, construct multi-header aggregate input without temporary physical
headers, reject replacing live native resources, and report native errors.
The aggregate preserves the first source's suffix for native language inference;
explicit `-x` arguments retain their ordinary precedence. This avoids changing
an otherwise valid `.hpp` input into C when multiple sources are supplied.
It loads ordinary libraries before system libraries, preserves successes after
a failed load, prepares canonical declarations, validates macros, groups accepted
macros, and runs the data visitor before the plain visitor. Redundant
omission, namespace emptiness and the final view occur afterward. Primitive
initialization, output emission and native/model teardown remain separate.

Prefix enum names trim all trailing underscores. Configured macro unwraps set
both `should_unwrap` and `OMIT_FROM_OUTPUT`, retain the macro for lookup, and
remain eligible for grouping. Enum entries retain source expression/location/
comment metadata. Visible namespace merging preserves original native ancestry
for C++ qualification. A visitor may clear a configured namespace's `FLATTEN`
flag; the final view respects that edit. That view has stable, independent
storage in the same ledger, so a later printing/tooling queue reallocation does
not retire it.

Direct run consumes only canonical library/path collections. Deprecated
library/path collections are left untranslated; callers needing them use the
tools-owned normalizer before running. A fresh macro enum has no inferred
underlying CType, including equal-width groups. Converted members use the
canonical enum identifier type. Existing enum underlying types remain unchanged;
accepted source expressions retain their original identity. No automatic
integer-width/signedness join, lossless widening, noninteger enum emission or
broader literal/ABI support follows from a successful run.

The retained active options record is ledger-owned; option collections,
callbacks and callback data remain caller-owned. The native evaluation receipt
owns copies of actual parse strings/primary bytes. Input revalidation tests
change caller argument bytes after run to distinguish these lifetimes. External
library handles/records remain tooling/caller ownership and are retained for
disposal before public deinit.

Focused verification uses [check_generator_run_shared.py](../tools/check_generator_run_shared.py).
It builds the current clean compiler/linter into fresh assigned T7 output,
executes focused public callback/pipeline/error/library/ownership fixtures in
the interpreter and native Mac O0/O2, compiles/runs independent official SDK
and C++ source-identity oracles at O0/O2, performs strict lint and formatting,
and checks six Mac/Linux/Windows source configurations for every fixture.
Source/fixture hashes and canonical installed/staged SDK receipts are guarded
before and after execution. Android's empty-program CLI rejection is a blocked
gate. Source checks establish no native Windows/Linux/device result.

Historical stable receipt `generator-run-verify-at3zz138` has **105 passing commands,
zero failures and one Android block**. It includes 24 Jai executions, 16 Jai
native builds, four SDK/C++ oracle executions, 48 desktop source gates and ten
complete strict-lint contexts. All 1,345 source hashes, 22 SDK/header/receipt
hashes and three generated native dependency/fixture hashes remain unchanged.
Both native library consumers identify the actual fresh helper image they link.
The public pipeline covers explicit and inferred C++ language, multi-header
inputs, mutable caller argv bytes versus retained receipts, macro grouping and
unwrap substitution, ordered visitors, source qualification, visitor-renamed
omission and visitor-controlled flattening. Runner Python ruff checks pass;
its final formatting has separately recorded identical AST before/after.

The model owner repaired the three independently reduced dependencies:
retained record intake, canonical unwrap text and constructor diagnostic
isolation. Semantic rejection uses the same Session's diagnostic serial and
canonical cache invalidation; native/input invalidity uses sticky failure.
Owned native/input guards call the supplied `gm_input_error`, including three
old macro-helper input preconditions. No failure flag is cleared and no
alternate provider exists. The original producer/consumer assertions remain.

Earlier `generator-run-verify-a4_9p1kk` was invalidated by concurrent emitter
source drift and recorded incomplete native helper search inputs. The runner
now source-builds the shared canonical helper directly in fresh owned output,
uses existing `JAIC_NATIVE_LIBS` and standard `LIBRARY_PATH` verification inputs,
preserves prior overrides, and checks the actual native link dependency path.
This proves development host behavior, not installed-distribution closure.
Historical `generator-run-verify-vsdzgp2f` remains the genuine 85-pass/9-fail
dependency measurement, not rewritten green. The all-runtime-green
`generator-run-verify-wj315flp` was invalidated by five concurrent model/bridge
edits. Source-stable `generator-run-verify-5kwupi87` preceded the final stronger
C++ aggregate-language case; its red/green evidence is retained in
`generator-run-red-r5r7cmnd/cpp-aggregate-language-*`. Historical 19-pass
callback-only receipts precede the clarified intake domain.
The retained `generator-run-verify-mzbcy9id` contains the owned log-before-Context
compile failure and an early zero-system-count assertion. That assertion was
temporarily weakened while classification was under review; the final reviewed
intake contract restores the correct zero count for the fully exempt case.
`generator-run-red-r5r7cmnd` retains the incorrect semantic-parent SDK premise,
the moving-allocator view retirement and namespace-source-parent failures, and
the exact canonical dependency reducers. These failures were corrected without
peer edits, compiler workarounds, duplicate providers or changed public native
declarations.

Owned new paths for integration are the two production files above,
`stdlib/Bindings_Generator/tests/generator-run-{toplevel,macro-print}.jai`,
`tests/developer-tools/generator-run-*`,
the verification tool and this document. The existing scoped
[API inventory](status/generator-macro-shared-audit.json) distinguishes the
seven accepted macro APIs, the host-verified callback and the host-verified
ordinary runner domain. The approved answers to the former configuration
questions are recorded in [generator-run.md](specs/questions/generator-run.md).
Legacy translation remains the normalizer's responsibility; numeric joins are
outside the reviewed run contract. Android source/device and native Linux/Windows/translated Mac
remain separate gates. Integration alone owns the facade load,
Git index/commits and README index. No peer production file was edited here.


Approved configuration reconciliation now passes fresh immutable receipt `generator-run-verify-v676gxqb`: **105 passes, zero failures, one Android block** (exit 2). It includes 24 Jai interpreter/native Mac O0/O2 executions, 16 native builds, 4 SDK/C++ oracle executions, 48 desktop source gates and 10 complete strict-lint contexts; formatter and Python ruff checks pass. All 1,349 checked source inputs, 22 SDK/header/receipt inputs and 6 generated native images remain unchanged. Exact newly built helper image identities pass. Capture `generator-run-current-snapshot-ewue56zm` records 1,766 current shared files with identical before/copy/after hashes, without old overlays. It excludes only the generated platform-helper image so verification source-builds that dependency. All owned inputs match the verified capture at handoff; unrelated rpmalloc files changed afterward, listed in `shared-post-verification-comparison.json`. This is evidence for the recorded immutable dependency snapshot.

Expanded pipeline regressions execute all three existing input modes. They verify ignored nonexistent legacy library/path collections; null underlying CType for fresh callback-selected/equal-width/prefix/mixed-width groups; canonical enum-typed converted members; preserved existing enum CType identity; retained source-expression/location/comment identity and member counts. The runner no longer selects the first native scalar type or repeats scalar-only evaluation when grouping accepted expressions. Existing canonical `gm_enum_identifier_type` supplies member types in the same Session. No legacy adapter or numeric join was added.

Earlier stable 105 (`at3zz138`) and 59 (`uw9o66ne`) remain historical evidence. Reconciliation red `r2ckppkw` preserves genuine interpreter/O0/O2 scalar-member failures, with its full receipt invalidated by unrelated source drift. Snapshot `dbsnfzks` passed functional/lint/format/source gates but failed exact helper identity because a copied generated image retained its shared-tree install name; that failed receipt is preserved. Recapture corrected verification inputs, without changing production loading or compiler behavior. The two former configuration questions are resolved; scoped inventory now has 9 verified-host APIs and 0 missing/partial APIs. Android source selection remains blocked; device, native Linux/Windows/translated Mac and installed-distribution helper closure remain unverified. Integration alone owns README/index and Git operations.
