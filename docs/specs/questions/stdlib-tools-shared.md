# Reviewer answers: narrowed public generator contracts

These answers are from static inspection of the public model and printer declarations/behavior. No reference compiler, generated binary, or runtime oracle was executed. The matching reviewed contract is in `docs/specs/stdlib/modules/bindings-generator.md` under “Narrow helper contracts: literals, virtual calls, templates, and token text.”

- **128-bit values:** the canonical 16-byte signed/unsigned `CType` names are `S128` and `U128`; their public types are limb structs. `Literal` stores only `s64`/`u64` evaluated payloads; lossless evaluated values beyond 64 bits are not established. For an ordinary signed literal targeted at `S128`, the source-selected decimal path prints the represented signed payload directly (for example, `-42`), without a scalar `cast(S128)` or explicit limb-aggregate construction. This is source-derived output selection, not an execution result or a guarantee that every consumer accepts such text in every context. The integer hex helpers support 1/2/4/8-byte targets only; no 128-bit hex format is specified, and the source helper reaches an assertion for that size. Do not invent a high/low output format or claim successful 128-bit literal round-tripping.
- **Raw C++ literal tokens:** for `RAW_CPP_TOKENS`, `Literal.raw_value` is authoritative; `string_value` is the separate ordinary-string union arm. The printer appends raw_value unchanged without parsing or Jai validation, so the caller must supply valid output text.
- **Virtual linkage and vtables:** a direct virtual declaration is named `virtual_<output_name>` (plus `_CFormat` when applicable) and uses its represented foreign library/symbol. A typed vtable record holds ordered slots; when the class owns the table, its pointer is inserted at the initial storage position, while a child with an inherited vtable does not add a second pointer. Slot placeholders preserve subsequent slot positions. Optional generated wrappers call `obj.vtable.slot(obj, ...)`, and the optional `vtable(obj)` helper returns the typed table pointer. This does not resolve unsupported multiple/virtual inheritance ABI cases.
- **Objective-C method calls:** emission uses a typed generated wrapper, not a special Jai intrinsic. It declares a selector symbol and casts `objc_msgSend`, `objc_msgSend_stret` (struct return), or `objc_msgSend_fpret` (floating return) to the method's represented function-pointer ABI, then calls with receiver, selector, and method arguments. This reports the emitted source form and is not an executed or universal Apple ABI certification.
- **Generic struct parameters/layout:** `Struct.template_type_params` are emitted in order as the Jai generic parameter list, with represented names/types and printable defaults. A generated raw-layout variant, when selected, carries the same parameters and passes references through its using member. Ordinary field-offset checks are disabled for templates; not every specialization's size/alignment/offset is validated, and source comments leave some generic padding/inheritance cases incomplete.
- **Raw cursor token text:** `raw_tokens_string_from_cursor` concatenates token spellings without adding whitespace. It does not preserve spaces/comments/source formatting. If range tokenization fails, its fallback can return the token at the cursor location (including preprocessed spelling); if that also fails, it returns empty text. Treat it as token text, not a source slice.

The pointer-recovery and operator-bridge questions are resolved below; the statements above are static source review, not execution evidence.

# Remaining generator emission contract questions

Approved shared emission/parser clarifications resolve the former naming,
traversal, grouping, callback-mode, array and logging questions. Implementations
consume canonical records. Seven macro APIs and run_generator/
handle_toplevel_cursors belong to ASN; this owner does not replace their provider.

These precise public behavior questions remain; supported work continues.

- **Virtual linkage and vtable placement — resolved by static source review:**
  `print_function` emits the `virtual_` prefixed represented function declaration
  through ordinary foreign-linkage printing. If no library is available, the
  linkage helper reports an error and emits `__UnknownLib`; this does not prove
  that a callable implementation exists. Vtable slots are separate ordered
  function-pointer fields in the generated vtable record. Optional C-style
  wrappers dispatch through the receiver's vtable pointer and corresponding
  slot. No generated output or target ABI was executed.
- **Objective-C calls and receiver assumption — resolved by static source
  review:** the wrapper uses the first represented `Function_Type` argument as
  receiver, followed by selector and remaining arguments. Instance and class
  methods use the same rule; the generator does not synthesize a class
  receiver. `create_function_type` explicitly inserts `this` for C++ methods,
  but has no analogous Objective-C insertion and instead collects cursor
  `ParmDecl`s. A canonical Objective-C argument list without a receiver is not
  handled correctly by this print path; whether a given libclang cursor supplies
  an implicit receiver child is not established. The selector is a foreign
  `SEL_<declaration-name>` symbol. No compiler intrinsic is required. Universal
  Apple ABI correctness remains unverified.
- **RAW_CPP_TOKENS to Jai and 128-bit evaluated literals:** emitted raw text is
  caller-provided and unchanged; valid Jai syntax is the caller's responsibility.
  Evaluated literal storage remains limited to s64/u64; a lossless wider
  evaluated-value representation is not established. See the module contract.
- **Pointer recovery eligibility — resolved by static source review:** the
  declaration-construction path calls this only for function arguments. The
  helper checks for a non-null pointer type and a final-child expression that
  is a positive signed or unsigned integer literal. There is no `.INSERTED`
  exclusion and no pointer-to-array exclusion; the recovered element type is
  the immediate pointee. It returns a separate array `CType`, leaving the
  input pointer object unchanged. Cursor-shape behavior was not executed.
- **Cursor raw tokens — resolved by static source review:** token spellings are
  concatenated without preserving source whitespace/comments; fallback may
  return a preprocessed token spelling or empty text. No source slice guarantee
  is established.
- **Operator bridge names — resolved by static source review:** the bridge
  collector skips declarations classified as C++ operators, so no operator
  bridge symbol is emitted by that workflow. `append_cpp_wrapper` composes the
  current `Function.output_name` with visible parent prefixes and does not
  normalize it through `replace_operator_name`. Separate declaration-name
  collision handling can call `replace_operator_name` in keep-Jai-operators
  mode; that is not a bridge naming rule. No generated bridge was executed.
  Conversion-operator handling is consequently outside the emitted bridge
  contract unless a different public workflow is established.

SDK resource/sysroot packaging and other native platforms are integration
dependencies. See [per-function audit](../../status/stdlib-tools-shared-audit.json).

## Top-level driver maintenance

Resolved by the reviewed **Option normalization and public generation workflows**
section: both high-level workflows now use canonical normalize/init/run/deinit.
The old Native_Model parser is outside their call tree. Selected mutable-array
copies, legacy warnings/reset, zero/multiple libraries, callback defaults,
output ordering, result-report defaults and failure domains have an explicit
contract. Library_Info.full_path is a logical extensionless emitted spelling;
physical native loading paths remain provider-owned. Shared output omits no_dll;
static output adds it. There is no promised shared modifier or automatic mapping
registry between separate bridge/Jai generation calls.

The initial Public behavior details already requires a C++ linkage name for
high-level bridge selection. The formerly raised unchanged-global-C question is
therefore resolved for ordinary supported SDK symbols: the driver excludes
missing/unmangled native names rather than emitting a self-interposing body.
Mixed C/C++ native tests preserve direct C calls alongside generated C++ adapters.
Explicit assembly labels and other unsupported ABI name categories have no
additional classification guarantee; no prefix whitelist or runtime lookup was
invented. The SDK mangling and native declaration spelling remain distinct from
the visitor-modifiable public output name.

One further precise output question remains:

- **Dependent template records:** what should print_struct emit for a generic
  Struct.template_type_params with SDK size/alignment -1 and dependent members?
  Specify public generic parameter syntax, whether incomplete layout checks are
  omitted, and the relationship to canonical specializations. Concrete template
  argument/type emission is independently supported; a printed unspecialized
  native layout is not established by that evidence.

## Remaining narrow output decisions after implemented token/type refinements

- Vtable helper option combinations — resolved by static source review: the typed vtable record is always emitted; `generate_c_style_api_for_vtable` controls `<Record>_<slot>` wrappers and `generate_vtable_helpers` independently controls the typed `vtable(obj)` accessor. Wrapper names use the generated vtable member's `output_name`. Variadic slot wrappers are diagnosed and skipped. No reference-generated output was executed.
- Objective-C receiver rule — resolved with an explicit source limitation above; receiver synthesis from a class/interface is not promised.
- Canonical template<typename T = int, int count = 3> input currently reports formal template default lacks a convertible native expression in model construction. Minimal original header and high-level producer fixture are bindings-generic-record.hpp and bindings-generic-driver.jai. Model owner requested. Manual canonical model printer with identical ordered defaults now generates runnable generic output; no fabricated native metadata.

## Wide target decimal construction: source-reviewed contract

Static review resolves the printer choice: for a signed decimal payload with a 16-byte signed target, the source takes the ordinary signed-decimal branch and emits the payload text (e.g. `-42`), not `cast(S128)(-42)` and not a limb aggregate. `Basic.S128` is a public limb struct (`low: u64`, `high: s64`); `U128` is (`low: u64`, `high: u64`). This does not prove target-context acceptance in the independent compiler or values wider than the model's `s64`/`u64` payload. No reference executable was run. The root and shared module pages now state this boundary.

## Implementation disposition after reviewer/model deliveries

Ordered generic printing, typed vtable placement/options/slot naming, raw text,128names/hex limits and reviewed decimal payload path are implemented. Canonical builtin formal defaults and canonical128slot names have now been supplied by the model owner and consumed in actual generated C++ specialization interop. Earlier builtin-default RED is resolved, not an outstandingblock. Objective-C supplied-first-receiver typed wrappers execute scalar class/instance calls; no receiver synthesis is promised. Forced-body float/struct runtime selection is source-checked only. Current outstanding limits are target-context acceptance of wide decimal payloads,128by-value ABI, general Objective-C ABI/implicit receiver, general raw/template/inheritance layout construction, other native OS execution and SDKdistribution closure; these are independent verification/accepted-domain limits, not unanswered printer spelling or absent ordinary bodies. See own auditJSON for precise evidence and capture guards.
