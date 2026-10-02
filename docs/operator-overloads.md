# User-defined operators

## What it is

Operator declarations are ordinary source procedures with a typed `OperatorKind` and a preserved declaration identity. Nominal records such as Math's `Vector2`, `Vector3`, `Vector4`, and `Quaternion` retain their record representation when their arithmetic invokes an operator procedure.

## How it works

`operator + :: (a: Vector, b: Vector) -> Vector { ... }` parses through the procedure signature and body parser. The operator's kind occupies a separate namespace from procedure names. The diagnostic label `operator +` never supplies declaration identity or name lookup.

`operator- :: Library.operator-;` declares a typed namespace edge. It publishes the target's original exported unary and binary `-` declarations under the alias's own visibility, preserving their bodies, formal names, defaults, and generic specialization origins. The alias itself is noncallable and creates no procedure wrapper. This spelling occurs in the unchanged Thread module at line 69. Aliases require a file namespace and preserve their target token; changing the token or placing an alias in a procedure or record reports a source diagnostic.

Alias target validation runs when source discovery reaches a complete graph, after imports and checked `using` publications are ready. Unknown namespaces, private namespace members, empty exported token groups, and cyclic alias edges report the original alias location. Only active source declarations participate, so inactive conditional aliases do not require their targets.

The source-backed spelling is present in `corpus/upstream/withlang-dev--open-jai/modules/Math/module.jai` at lines 119–136. Its scalar multiplication declarations use `#symmetric`, which permits reversed operand types. Reversed binding retains source evaluation order while selecting the original formal parameter destinations.

Module lookup gathers visible operator declaration identities, preserving file-private and module-private visibility and exported imports. Anonymous imports and `using` namespace imports expose operators to unqualified lookup; an ordinary named namespace import keeps its operators inside that namespace. Scoped imports publish operator-only modules even when they export no ordinary names. Local callables capture the preceding scoped imports at their declaration's source position; later imports do not become visible retroactively.

Checked top-level `using` publications contribute their exact selected operator declaration identities. Lookup applies the publication's own visibility and exports only exported publications; it does not expose every operator from the source namespace. Publications owned by a callable stay in that callable's lexical environment.

Lexical `using` captures those selected identities in the current frame and in subsequently declared callables. Its operator group participates in the nearest token scope; filtering or excluding a token does not expose the unselected operators from the imported module.

Lexical lookup uses the nearest visible operator-token scope, following the reference tutorial's procedure-name lookup rule. Inner declarations select their own overload group; leaving the block restores the outer group. Unary and binary `+` or `-` share a token namespace while retaining distinct typed declaration kinds.

An explicit `!=` overload is preferred; otherwise inequality calls `==` and negates its boolean result. This fallback, documented in the reference tutorial, preserves a single evaluation of each operand. Equality does not search for `!=`.

Argument descriptions and generic inference use the same pure matcher as named procedure overloads. Each file candidate's checked `#modify` result is applied before conversion ranking; pending modifier work postpones selection. The selected match retains that checked substitution for preview, specialization, and binding without repeating inference. Only the selected declaration lowers operands and reserves its generic specialization.

Local inferred operators use `ProcedureTemplate<LocalDeclarationId>` and a separate lexical specialization cache. The key contains the genuine local declaration and its typed substitution, including executable callable policies. The local declaration's enclosing procedure identity distinguishes the same source text inside different outer specializations. Templates capture definition-time imports, selected operators, source identity, checks, and the outer substitution; a later caller cannot change those bindings. Chosen bodies use the shared procedure allocator and the existing local body binder. A signature is published before its body so recursive calls reuse the reserved procedure, and result previews allocate no procedure.

Callback result-use obligations are checked source facts. Strengthening `#must` keeps the existing executable specialization key, signature, and procedure identity. Selected arguments publish their contracts before a body-cache lookup; the local readiness ledger invalidates the old body and accepts a rechecked body only if that procedure's contract revision stayed unchanged during binding. Cached compile-time values wait for the new proof and retain their previously committed effects.

A shared lexical body uses a conservative union of its callback contracts. Each lexical call derives its returned callback policy separately from its own original operands and checked runtime argument destinations. The binder retains source order and records actual `ParameterId` destinations, including symmetric reversal; the result adapter validates those destinations before reading source annotations. An Optional callback result therefore stays Optional when another call on the same procedure identity returns Required.

File operator results retain the selected named source arguments through the ordinary call binder. The generic contract adapter pairs those original formals with the checked call and substitution, including a baked callback whose runtime slot is absent. If the result contains a callback contract, lowering publishes that per-call proof under a genuine `ExpressionBindingId` and wraps the actual call in the ordinary `Bind`/`Bound` capture. Later projections read that proof instead of re-deriving it from an erased runtime argument or the shared body's merged contract. The capture executes the selected call once and preserves symmetric source evaluation order.

Pure specialization rejects a nested overloaded expression whose returned callback policy is not yet available from checked source facts. The diagnostic is `nested operator callback policies require a checked source result preview`; matching does not reserve a body or execute operands to fill that gap. Assigning the result first retains its checked per-call contract for subsequent policy selection.

Lexical `#modify` uses the same source-derived slot plan and checked executor as file templates. Each auxiliary body has a real procedure identity and runs in the captured definition environment with `NoEffects`. Accepted bindings are cached under the original local declaration and initial substitution, then checked against the original operands before ranking. Rejected bodies do not reach runtime lowering; pending auxiliary dependencies postpone selection. Callable policies are collected before execution and again after accepted type changes.

`NoEffects` isolates the auxiliary VM from compiler effects and runtime global state. An ordinary global assignment can execute inside that isolated VM; its value does not commit to the runtime program. Operand type descriptors currently report a precise unsupported diagnostic when their record namespace contains constant, type, procedure, or inserted members whose reflection payload is not ready. The selected-procedure demand fixture therefore tests `#run` independently of that reflection boundary.

Record prerequisites request selected bodies by their actual specialized procedure identity. An enclosing record's type-only phase remains authoritative: it reserves types without evaluating defaults or lowering bodies. When that phase advances, a cached type-only specialization completes its defaults on the same identity. Missing requested bodies publish an actual procedure dependency for the next demand pass.

For example, a block can declare `operator + :: (a: $T, b: T) -> T { return .{value=a.value+b.value}; }` and specialize it independently for two nominal records. A header such as `Library.Box($T)` records the imported template's original declaration at the source application span; a caller's later `Library` binding cannot retarget it. Record-body operator declarations retain their operator group when ordinary methods capture that record's namespace.

Compound updates capture a target place before reading its old value or evaluating its right operand. A pointer-taking compound operator such as `operator *= :: (obj: *Obj, scalar: int) { ... }` invokes an actual void call through that captured place. A value-taking compound overload or an ordinary binary fallback produces the value stored through the same place.

Fixed operands may be followed by ordinary default parameters, as in the reference tutorial's `operator += :: (x: *Complex, y: Complex, loc := #caller_location)`. Symmetric binding reverses the operand destinations while leaving trailing defaults in place. Captured mutation calls materialize omitted defaults after their supplied operands; caller locations begin at the original assignment target.

Lexical template defaults retain checked runtime-read recipes for definition-site globals and context fields. Candidate previews use only ready binding and storage metadata; they never complete a pending constant initializer. The selected signature later prepares the original default in that same environment. A global default therefore observes the value after the supplied operands execute, while a caller's shadowing import cannot change its storage identity.

Operator formals currently require ordinary evaluation. A `#discard` formal reports a diagnostic at its actual parameter span because captured operator calls do not yet have a shared source-to-runtime slot binder for that policy.

Baked operands retain their source positions for operator arity and type-contract checks. File operators use the selected match's existing baked-argument projection when binding ordinary unary, binary, or indexed-read calls. For example, `operator << :: (a: S128, $$x: u8) -> S128` has two source operands; a constant `x` produces one runtime parameter, while a runtime `x` produces two. The unchanged Int128 source declares both signed and unsigned shifts this way. Contract validation materializes the genuine candidate's source formal types and checks the actual selected result signature, without constructing another callable signature.

Captured compound and getter/setter updates currently report `baked operator operands require source-aware captured argument projection` before lowering captured operands. Extend the shared captured binding path before allowing that projection; removing the guard alone would confuse source operand positions with compact runtime slots. Local templates likewise retain their explicit baked-formal boundary until their body and argument binders share that projection.

Deprecated operators warn for the selected original procedure after its arguments, defaults, and context bind successfully. Captured mutation calls follow that same rule; matching a rejected candidate does not emit a warning.

`operator []= :: (obj: *Obj, i: int, item: int) { ... }` implements indexed assignment with a void call. `operator *[] :: (obj: *Obj, i: int) -> *int { ... }` supplies the pointer for `*obj[i]` and addressable indexed storage. Both retain source evaluation order. The prefix `<<pointer` dereferences that pointer through the existing typed-place path and binds more tightly than arithmetic. These spellings and pointer contracts are present in the unchanged source `examples/24/24.2_overloading_object.jai`, lines 11–23 and 37–39; tests extract those definitions directly.

The reference `094_array_operators` tutorial also requires indexed compound updates through a `[]` getter and a `[]=` setter. Their capture helper in `operator_overloads/index_updates.rs` captures real storage and index locals, snapshots a value receiver before index effects, reads through the chosen getter, and invokes the setter with the computed value. Reads prefer `[]` and writes prefer `[]=`, with `*[]` supplying addressable storage when those handlers are absent. The authored `operator-index-updates.jai` fixture records receiver, index, getter, operand, and setter order as `12345`.

The getter/setter path first checks the receiver's nominal type. Built-in arrays keep their existing typed-place update path, including a mutating operator on a nominal array element. This avoids previewing an unrelated getter/setter calculation before the ordinary place update can select its compound operator. Unused local operator templates remain registered and are resolved only when a nominal operation selects their group.

## How to change it

Add token-to-kind support in `jai-syntax::operator_declarations`; keep operator declaration metadata on `Procedure`. Extend the typed graph namespace in `jai-modules::operator_scopes`, and extend candidate selection and expression lowering in `jai-sema::operator_overloads`. Avoid mapping record layout or record names to primitive SIMD types.

Alias syntax lives in `jai-syntax::operator_aliases`; graph expansion and validation live in `jai-modules::operator_scopes` and `operator_aliases`. Extend those edges while retaining the target declaration identity. A new alias form must update the file declaration schema and every parser consumer, including explicit rejection in lexical and record contexts that lack file namespace resolution.

Lexical templates live in `jai-sema::local_declarations::generic_procedures`. Keep their local origin separate from the graph declaration arena, and preserve the captured source environment when changing candidate preparation, result preview, or body binding. The pure template builder accepts either origin type; nominal record applications retain their actual graph origins. Specialization keys must keep callable policies as well as types and values.

Required-result obligations such as `#must` belong to checked source contracts, not executable specialization keys. When those obligations strengthen for an already selected procedure, retain its identity and header and recheck its body. Keep the local callback readiness ledger and compile-time cached-result receipts in step so a failed proof cannot expose an old ready body or repeat previously committed effects.

`procedure_values/contracts/expression_bindings.rs` registers `selected_call_producers.rs` as its private child. Use this checked producer API when retaining a selected operator result: it validates the actual call signature, the single result's canonical type, and the expression binding owner before publication. Keep the original named source arguments available until the per-call contract is derived; compact runtime slots alone cannot reconstruct baked argument annotations. Root operator discard checks follow transparent `Bind` captures to the actual call and its source result usage.

Lexical modifier caches live in its `modifiers` child. Extend `procedure_modifier_source` and `evaluate_checked_modifier_parts` when changing the shared modifier contract, rather than creating a graph declaration for a lexical body. Preserve the external-global snapshot, runtime provider maps, and graph job completion wrapper. Selected-body preparation must check the actual signature identity and retained record phase; bypassing that demand check can execute defaults during type reservation.

Lexical header applications use `parameterized::procedure_application_patterns` with a snapshot of genuine type and constant bindings and imported template identities. Its private type resolver retains structured preparation failures until the explicit diagnostic boundary. Template parameter annotations still resolve in the template's defining file; caller bindings must not leak into that phase.

Preserve argument vectors in source order. A symmetric operator changes formal parameter names or parameter destinations, never the evaluation order. Mutation operators lower to the existing `CallVoid` and captured typed-place contracts; do not manufacture a value result for them. Add VM and newly generated native execution cases when extending operator behavior, including a case that observes operand effects.

Getter/setter updates resolve through `operator_overloads::index_updates` before `pointers::update_place` requires an addressable place. Extend its captured call binding when adding operand forms. Do not construct a synthetic place for a getter result; its setter represents the write contract.

## Configuration

Operators have no feature flag or environment variable. `#symmetric` annotates a binary operator declaration. Source visibility uses the existing `#scope_file`, `#scope_module`, and `#scope_export` rules.

Focused checks use `RUSTC_WRAPPER= CARGO_PROFILE_DEV_DEBUG=0 CARGO_PROFILE_TEST_DEBUG=0 CARGO_INCREMENTAL=0 LLVM_SYS_221_PREFIX=/opt/homebrew/opt/llvm CARGO_TARGET_DIR=target cargo test --offline --locked -j1 -p jai-sema --test operator-overloads`. The profile settings keep the shared workspace's build footprint bounded. Corpus sources are read-only semantic evidence; checks execute this repository's Rust compiler and its newly generated code.

The `jai-codegen --test operator_overloads` runner compares the VM result with the same generated LLVM IR compiled by installed Clang at explicit `-O0` and `-O2`. Each execution has a five-second deadline. With `-- --nocapture`, it reports the optimization, result, and a non-cryptographic FNV-1a64 fingerprint of the newly generated executable bytes.

Authored operator fixtures are required in every checkout. The additional original Math and object gates read `corpus/upstream/withlang-dev--open-jai` at runtime, report `SKIP optional original-source operator gate` when the local source is absent, and fail on other read errors. They neither embed nor upload the original source. Run with `-- --nocapture` to see absent-source reports.

The optional Thread parser gate reads `reference/modules/Thread/module.jai` at runtime and uses the same absent-source reporting rule. It checks the whole root file and the alias's original line; it does not claim that Thread's imported modules or runtime compile. `jai-sema --test operator-using` checks exact lexical selection, source-position capture, and alias targets supplied by checked publications independently of the original corpus. Discovery publishes ready selections before retrying requests that depend on them.

The optional Int128 parser gate reads the whole unchanged `reference/modules/Basic/Int128.jai` and checks the four original `$$` shift headers. Authored source and native gates assert both one-parameter and two-parameter runtime specializations, constant detection, and the exact operand/body trace `13123`. They do not execute an original compiler or binary.

Modifier fixtures explicitly configure an LP64 target layout so runtime type descriptors have a real storage policy. Their auxiliary execution uses `NoEffects`, independent of the later VM or generated-native runtime check.

After building the current `jai-cli`, run `python3 tools/check_feature_matrix.py --select operator-index-updates --select operator-record-floats --through run --report artifacts/operator-feature-matrix.json` for the pinned authored fixtures. This checks their source fingerprints, generates fresh LLVM and native artifacts, and asserts exact exits `11` and `24` with empty output.

## Dependencies

The callback proof bridge also uses `jai-sema::procedure_values::contracts`, the local declaration readiness ledger, and compile-time result receipts.

The implementation uses `jai-syntax` for typed operator identities, `jai-modules` for source scopes and declaration identities, `jai-types` for nominal type descriptors, `jai-sema::overloads` and `jai-sema::polymorphism` for candidate selection and specialization, and `jai-ir`, `jai-vm`, and the LLVM backend for shared call execution. It introduces no external dependency.
