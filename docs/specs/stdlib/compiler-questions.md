# Compiler compatibility questions

## Callable headers after structural type erasure

Declared callback headers now retain independent parameter names/defaults through
fields, locals, aliases, parameters/macros and declared factory results without
changing structural type identity. Clarify which header supplies names/defaults
after a fully computed procedure-type expression or a generic type binding has
retained only a structural TypeId, and after pointer/array element access without
a selected lexical header. The compiler must not borrow an unrelated equal type's
names/defaults. Current missing-provenance calls preserve positional arity/type
checks and reject named arguments; this limitation is not counted as complete.

## Resolved: Mac catalogue decimal literal inference refinement

Reviewed core-syntax-and-types.md now explicitly establishes compiler fractional
digit metadata independently of runtime lexer modes. Integer-side digits do not
count; trailing fractional zeroes are ignored. The first three queried literals
default to float32; 0.123456789 requires float64. PI_LONG cannot implicitly narrow.
The corrected positive oracles and two negative narrowing regressions retain
this distinction. No inference implementation change was required.

For public Code_Directive_Run, clarify the procedure/body representation of a
source #assert condition/message and #run expression. The reviewed record exposes
procedure, flags and assertion_string; it has no public expression/message fields.
Those private record fields are not used to invent exports. Compiler-owned AST
attributes now preserve assertion/run operands for semantic reconstruction;
independent assertion/run round trips pass. Caller-created records lacking those
operands still cannot establish a source assertion. Non-null
Code_Directive_Exists.sync_expression syntax needs review before reconstruction.

## Opaque compile-time pointer lifetime beyond scalar handles

Reviewed immutable Registry handles are raw values and need no readable pointee
extent. That defect is repaired generally. For #run returning a non-global opaque
pointer to real compiler-host/temporary storage, clarify the intended native-output
lifetime/relocation policy: raw bits cannot supply portable storage ownership.
Known globals still relocate; this batch invents no allocation/bounds/lifetime
guarantee. Existing general non-low raw interpreter access fault containment also
remains separate runtime work. See compiler/raw-pointer-constants.md in docs.

## Continuing-handlers default generic pointer reduction disposition

User supplied the exact NEW path ../stdlib/pending/default-generic-pointer-constraint.jai
and the description in portable-file-watcher.md. The exact source path is absent
in this snapshot; no alternate peer tree search was performed. An independently
authored reduction reproduces the identical nominal-instance error and exposes
inconsistent default pointer identity. General pointer construction/default
binding is repaired with positive/negative tests. Producer should restore/rerun
its exact original fixture and watcher suite; no such integration pass is claimed.
See ../../compiler/default-generic-pointers.md for cause, scope and bounds.

This document records unresolved contracts and implementation limitations. The
reviewed module specifications remain the public API oracle. A baseline compiler
feature or a legacy test does not settle a compatibility question.

## Bootstrap and internal source provenance

- The distribution policy reserves `stdlib/internal` for library-owned imports.
  The loader enforces canonical provenance, including cache hits and symlinks.
  Code/FILE scoped build strings now retain known lexical provenance. Unscoped
  generated imports/build strings remain synthetic and cannot import internal
  helpers directly. The policy is not a metaprogram security boundary; further
  generated-source ownership guarantees need review.
- The guide does not establish parameterized explicit imports of the reserved
  implicit `Runtime_Support` module. The baseline keeps one runtime instance and
  ignores explicit instance arguments there; this is a bounded compiler behavior,
  not evidence of the general language module identity contract.

## Remaining compiler-owned scope

Compiler remaining diagnostic APIs and performance records are still pending; interception,
procedure modification and running-workspace scoped source insertion are now
covered by original interpreter/native fixtures.
The independent runtime Jai_Lexer now passes focused interpreter/native fixtures;
see `docs/compiler/runtime-jai-lexer.md` for its supported behavior and limits.
Public compiler records, helpers and explicit Code_Visit/Program_Print algorithms
are being implemented and verified as described in `docs/compiler/compiler-facades.md`.
No declaration-only facade,
fabricated message, unsupported backend success or ignored error counts as completed
functionality. Library-dependent focused acceptance now runs against a test-only
overlay of the independently implemented foundation and native bindings.

`compiler_report_errors_for_unresolved_identifiers` and
`compiler_report_errors_for_untyped_declarations_with_these_notes` have reviewed
signatures but no reviewed selection/timing contract. Filename resolution, note
matching and the treatment of other deferred errors require clarification before
claiming those reporting entry points. Ordinary compilation diagnostics continue
to report real errors; they are not counted as an implementation of these APIs.

Module-import `map` and merging procedures from separate filtered reexports are
explicitly unresolved by the language guide. Aggregate member `map` and original
names preserved by `only`/`except` now work for standalone aggregate using and
local using declarations. Procedure and macro parameter signatures now preserve
their filters, and embedded computed filters resolve during field layout. Focused
regressions cover static/computed only/except and mapped parameter storage.
Computed maps involving an incomplete self-referential target still require
coverage; the current completeness check diagnoses those cases.

## Literal precision and report records

- Prefix cast grouping and bottom-up operand typing are resolved by the reviewed
  core language page: cast(u32) byte << 2 means cast(u32)(byte << 2), and the cast
  does not retype an already typed operand. Narrow shift result promotion alone
  remains unspecified. Independent
  tests/compiler/semantics/cast-shift-widths.jai reproduces the mailbox's missing
  control byte: for group:u8=0x66, cast(u32) group << 8 yields zero in the current
  interpreter and native O0/O2, while (cast(u32) group) << 8 yields 0x6600.
  Does a shift whose left operand is u8 preserve that width or promote its result?
  Current reviewed examples do not settle that numeric rule. Please review the
  minimal language expression, not library implementation bodies. Current
  grouping agrees with the reviewed contract and is not a compiler defect.
  Explicit widening passes constant/runtime/native/WASM tests; no grouping or
  inward-conversion rule was invented. See docs/compiler/cast-shift-widths.md.

- The compiler retains the documented lexer precision metadata through untyped
  constants, aliases, unary/binary folding and module arguments. Required
  float64 precision blocks implicit float32 narrowing and filters overloads;
  explicit casts permit rounding. Exactly-eight-digit defaults remain contextual.
  Original Rust tests cover these paths. Exhaustive numeric-expression and
  alternate floating-format behavior still needs broader coverage.
- Resolved on 2026-10-14: the updated reviewed Compiler page specifies the run
  record shape (callee, stall count, elapsed seconds). The public aggregate and
  performance message now use that shape with measured compiler values. Native
  tests cover real records and unrequested blank sections. Actual wasm32 hosts
  diagnose unavailable timing until a host monotonic clock is provided. Does a
  run thunk without a source procedure use a null callee header? Current exporter
  does so; no procedure header is fabricated.

## Visitor and helper details

- Code_Using preserves every filter category and the actual expression for
  computed only/except/map filters, including parameter usings. The reviewed
  record page does not establish the `filter_expression` shape of static name
  lists/maps. Those records retain a non-NONE category with a null expression;
  Program_Print returns false rather than dropping the filter during Code
  reconstruction. Exact static-filter serialization requires further review.

- The Code_Visit page specifies `visit_pre_and_postorder(node, code)` but does not
  establish which variables the macro introduces into the caller's code. Old local
  tests are not an API oracle. The macro is omitted until reviewed bindings are
  available; `get_values` supplies explicit node/preorder event records.
- Exact visitation multiplicity for shared nodes/cycles and the exhaustive selected
  child list are not documented. The independent traversal preserves ordinary child
  order, includes the root in recursive walks and terminates on revisited pointers.
  Only specified child relationships are compatibility claims.
- `is_subclass_of`'s `first_call` parameter and filename-splitting edge semantics
  need reviewed behavior. The current independent helpers follow first-AS-member
  aggregate ancestry and return a path prefix including its separator; these
  choices are not established as exact reference behavior. A nondefault
  `first_call=false` is diagnosed explicitly rather than silently ignored.

## Current workspace adapter limits

- Non-null Code scope selection now works in the running workspace. FILE selection
  retains the file's lexical scope, while IMPORT selection retains its module.
  A fixture verifies private names and relative source loads. Cross-workspace Code
  selection is rejected according to the reviewed precondition.
- Alternate X64 backend selection, interactive bytecode debugging, raw LLVM
  command-line passthrough, function-sections and disabling mem2reg are rejected
  explicitly by the adapter. Known typed options are forwarded; detailed semantics
  of additional options still require implementation and focused tests.
- The public memory-breakpoint and developer-debugger entry points retain their
  signatures but diagnose unavailable compiler debugger support. No debugger
  action or successful breakpoint installation is claimed.

## Runtime lexer edges

The public lexer page leaves initial coordinate bases, exact line-counter updates,
some note syntax, malformed recovery and the input spellings of parser-stage
disambiguation tokens incomplete. This implementation uses one-based byte
coordinates and ASCII identifiers, emits ordinary SHIFT_LEFT for `<<`, and keeps
documented rotate operator token values distinct. These choices need further
review before claiming exhaustive lexer compatibility.

## Global-data limits

The reviewed contract leaves WRITABLE_NO_RESET reset behavior, nonzero BSS/ZEROED
input, and version-stamp changes unspecified. Those registration variants are
diagnosed rather than assigned invented semantics. Version stamps remain zero.
Cross-workspace registrations and compile-time global-data snapshots require
additional ownership/lifetime implementation and currently produce diagnostics.
The backend cannot promise arbitrary named sections and truthfully returns false
from `add_data_segment` while preserving usable aligned data and exact handles.

## Generic default metadata encoding (2026-10-14)

Basic default-elision behavior is reviewed. Prelude declares parameters, specified_parameters, constant_storage and polymorph_source_struct but does not define dependent-default encoding. Shared source identity prevents storing a single concrete value for a default depending on a required argument. Current independent contract: source parameters stores resolvable declared defaults; unbound defaults have offset -1 and unresolved types are null. Instance parameters stores defaults evaluated using preceding actual arguments, while specified_parameters stores actual values. Does this existing-field representation match the intended public reflection contract? No new exports/fields were invented. Foundations should use instance parameters for dependent comparisons. Evaluation effects of compile-time default expressions during reflection also remain unspecified; no no-effect guarantee is claimed.

## Bare context push AST representation

Code_Push_Context exposes to_push, block and backtick/defer-pop flags, but the reviewed page does not specify how an implicit copied context differs from an explicit context expression. Runtime AST retains the bare/copy distinction correctly. Public export currently represents the implicit expression as Code_Context; Program_Print still returns false for push-context nodes rather than emit a potentially different lifetime/storage operation. What is the intended public representation of bare push_context and bare push_context,defer_pop? No additional public flag or field was invented.

## Interface and register binding boundaries

Reviewed Basic contracts establish structural static hook validation. Current
general checking compares required fields, constants, overload procedure types
(including ABI/context/variadic bits) and macro category; extra members are allowed.
Must procedure parameter names/defaults also match? Generic required declarations
and dependent nested interface contracts need review; no permissive fallback is
counted as support. Runtime Type values cannot establish a concrete binding-time
interface and diagnose explicitly, including later variadic arguments.

Canonical __reg is a distinct source type and a SIMD operand marker. Expanded
parameters alias the caller register, including generic forwarding; 32/64-bit
lane extraction and mutation execute on interpreter/native/WASM. Standalone
storage, runtime procedure ABI and scalar coercion diagnose unsupported use.
Wider register-marker contracts are not established by the reviewed 128-bit
Meow_Hash contract. No Code alias or scalar-u16 operand substitute is used.

## Temporary storage configuration and Runtime_Support

The reviewed Runtime_Support header has three boolean parameters. The compiler
used to pass an extra TEMPORARY_STORAGE_SIZE while a legacy system-module
exception ignored unknown arguments. Both mechanisms are removed. The compiler
now supplies a private runtime getter backed by finalized target data; no public
parameter/export is added. The staged NEW runtime adapter uses that value for
actual allocation, with interpreter/native allocation regressions. Exact producer
adoption is in docs/compiler/runtime-configuration.md; an older runtime still
diagnoses nondefault requests rather than silently allocating the default.

The initial storage diagnostic was too broad for NO_OUTPUT workspaces. It now
checks actual target-runtime requests, including setters made while compiling.
NO_OUTPUT option metadata round-trips and the unchanged 65536 workspace fixture
passes. Actual allocation is now verified in the staged candidate (late root
65536 and independent native child sizes 0/131072), with production adoption still
pending. One narrow contract question remains: if a metaprogram changes the size
after its host compile-time context already exists, must that existing host
scratch storage be resized, or does the setting govern newly initialized target
contexts only? Existing host scratch is retained; final interpreter entry contexts
and native startup use the settled target setting.
Configuration is refreshed before execution/emission, including later child-to-root
setters. The exact setter cutoff after emitted object/custom-link phases is not
established by the reviewed contract; existing objects are not automatically
rewritten when options change after emission. Which fields, if any, must remain
mutable at those later phases?


## Procedure variants under reduced type information

The reviewed member marker establishes direct procedure fields hidden as void
pointers. Does PROCEDURES_ARE_VOID_POINTERS also unwrap a distinct/isa procedure
variant, or retain its VARIANT descriptor and canonical nominal identity? Current
source classification handles direct procedure types, including ordinary aliases;
no unreviewed variant rewrite was introduced. A proposed test using
`Callback :: #type,distinct (int) -> int;` as a hidden struct field required
Type_Info_Variant in the deliberately scoped bootstrap, so that result did not
establish a marker bug. The following candidate expectation is retained here for
review, not counted as completed functionality:

```jai
Callback :: #type,distinct (int) -> int;
Record :: struct #type_info_procedures_are_void_pointers { callback: Callback; }
// Review whether this must be a void-pointer descriptor with marker 8,
// or a canonical Callback variant descriptor.
info :: type_info(Record);
```

## Resolved host/target distinction (2026-10-14)

The explicit compiler task and reviewed Basic cross-compilation early-return
contract are implemented using BUILD_OS/BUILD_CPU for the compiler-binary host
and OS/CPU for the selected output. Canonical bootstrap enum identity is
preserved, including wasm32-host/WASM-CUSTOM checks and cross child workspaces.
No extra Basic predicate or public parameter is required. Evidence and remaining
platform/dependency limits are in ../../compiler/host-target-constants.md.

## Conditional field selection and forward type queries

Forward overlay/type/layout dependencies now resolve known direct declarations
and selected conditional/inserted fields without reordering. Specify whether a
conditional whose selection requires the type of a field declared only inside
that same conditional is always a cycle, or has a defined fixed-point rule.
Current code diagnoses unknown/cyclic dependencies; it does not guess a branch.
Native D3D member order versus the reviewed shapes remains bindings/spec-owned;
exact SDK/dependency evidence is in compiler/forward-overlay-layout.md.


## Constant aggregate data-storage contract

Reviewed disposition: updated jai/core-syntax-and-types.md explicitly establishes
fixed-array values/types but no canonical .data/address sharing, storage lifetime,
mutation or equal-constant deduplication guarantee. The retained NEW tooling
reproducer is an observation with an invalid compatibility equality oracle, not
a proven general compiler defect. No shared writable storage should be invented.
Code retaining a stable writable pointer must provide a mutable object with a
suitable lifetime. Values and nominal type identity remain separately required.

Original staged failure remains at
target/tooling-metadata/producer/compiler-requests/constant-array-address.jai and
constant-address-before.log. The cause is ordinary temporary address materialization;
no semantics were changed. Stronger identity/lifetime/mutation guarantees require
a future explicit reviewed refinement, not inference from that assertion.

For checked Code_Node.type, clarify expansion identity/nullability for a generic
source template, unchecked/discarded syntax and a macro source span expanded to
multiple incompatible types inside one concrete procedure. Real checked concrete
results now retain their original instance types; ambiguous spans remain null
rather than fabricate one expansion/default type.

## Enum structural dependencies

Forward explicit member values now resolve independently of declaration order.
Please clarify whether structural selection must solve values whose own implicit
predecessor depends on that selection, or inspect not-yet-selected member names.
Minimal ambiguous case: `E :: enum {#if LAST==xx 1 {FIRST;} LAST;}`. No guessed
branch/fixed-point value is implemented. Also clarify whether provably empty
generated text must permit a future implicit dependency: `E :: enum {FIRST;
#if LAST==xx 1 {#insert "";} LAST;}`. The latter currently diagnoses the unestablished
declaration-order dependency; syntactically empty conditionals already work.
Normal selected inserts/conditions and forward direct values have independent
positive/negative regressions. See compiler/enum-dependencies.md.

- Inferred procedure values selected through runtime ifx: whether common defaults/names from selected branch declarations survive inference is not established. Existing independent proc-type-defaults-ifx.jai fails only the inferred h omission after explicitly typed g calls pass. Request a reviewed minimal control; do not reintroduce structural TypeId header sharing or live alias refresh.
- A constant binding initialized by cast(Callback) target: should named/default arguments use the explicit cast type header or canonical target declaration header? New exploratory assertion declared_flag was rejected after constant evaluation was repaired. This premise is not counted supported or fixed; failed receipt callable-sentinel-green-r2.log retained. Existing canonical aliases and explicit typed variable/field contracts remain the established controls.


## Runtime configuration: Focus causal evidence still open (2026-10-16)
Approved e0 private runtime directly reads the compiler size and uses it for
temporary storage extent. Independent 1 MB root/child checks and actual canonical
allocation pass. A separate general retained-startup callback graph defect is
reproduced and repaired, with overwritten-reader rejection retained. Do not
attribute Focus to it without matching-current filtered diagnostic facts.
Root owns the excluded Focus Runtime body and full candidate replay. A useful
configuration error note now reports actual workspace/size/entry/init/export count
and lowered-reader state; no default substitution or public parameter added.

Focus causal clarification: root matching e0 diagnostic reports workspace3, size1048576,4exports and no lowered private reader. Sanitized application contract consumes reviewed public compiler TEMPORARY_STORAGE_SIZE in static array extent. Excluded custom Runtime source remains unread. Constant-binding target dependency and late-size conflict validation are now the required next fix; retained callbacks were an independently confirmed side finding.


## Runtime constant dependency boundary (2026-10-16)
Reviewed public TEMPORARY_STORAGE_SIZE static extents and scalar/alias/layout
uses now authorize reached custom-runtime consumers, with stale captured/final
size diagnostics. Arbitrary compile-time procedure-result dependency propagation
remains unverified and conservative; no guessed public transport API is added.
Root's qualified Focus check passes; unmodified build/execution and custom Basic
replacement-interface behavior are separate integration gates.


## Windows import providers (2026-10-16)
General interpreter provider selection now follows short/GNU/long COFF import
metadata with host-machine validation and shared native-linker SDK discovery.
Static, multi-provider and unsupported BigObj/path-provider archives reject
explicitly. Import-symbol renaming is not introduced. Actual Windows SDK loading
and WebGPU interpreter/native proof remain root CI obligations; metadata tests
are not runtime success. No d3dcompiler/Extensions name exception is used.


## WASM smoke provider boundary (2026-10-16)
Window_Type/Process/POSIX target guards are preserved. Exact current tour
statically imports Input/Window_Type before probing GPU. Root review must choose
a real private canvas/WebGPU consumer with approved independent type/callback
bindings or explicit required portable-positive/unsupported-graphics-negative
obligations. Existing full smoke remains red. Human Process report still needs
its entry/flags/direct importer chain; direct import rejection alone cannot
classify that consumer. No public WASM native-handle/process API is invented.


## Cross-source phase frontier afterc0c (2026-10-16)
The integrated supported repairs select plain conditional branches once and isolate unrelated target-required libraries from cross-target compile-time host lookups. Same-target required initialization and explicit foreign lookup remain required. No broad early import discovery is adopted.

Unresolved: exact late named-configurator/child Basic program-setting ordering and non-overloaded ifx callable-default transport. Independent producer request fixtures remain RED; no guessed join-header rule, global TypeId default table or setting-after-use guard removal is authorized by this handoff. The original overloaded proc fixture has a separate root-supplied official rejection verdict, not a positive API oracle.
