# Aggregate and procedure syntax

## What it is

`jai-syntax` preserves unresolved type annotations, nominal declarations, procedure signatures, result lists, literals, and writable places in its per-file AST. Parsing establishes source structure; successful semantic checking, layout, and native lowering require their own compiler stages and acceptance tests.

## How it works

`parse_file` recognizes top-level `struct`, `union`, `enum`, `enum_flags`, and definite type aliases. Names remain interned source symbols rather than resolved `TypeId` values. Every file retains its own source identity and byte spans.

`TypeSyntax` represents builtin types, named/qualified types, introducing `$T` type variables, pointers, fixed arrays, slices, dynamic arrays, procedure types, inline records and enums, type applications, and `#type,distinct`/`#type,isa` variants. Fixed-array counts remain expressions, including introducing `$N` values. Type applications preserve a structural base type and ordered named/positional expression arguments, such as `Queue(User_Data)` or `Holder(u8,N=8)`. Builtin spellings become enum variants at the syntax boundary; semantic code should consume those tags. `as_scalar()` bridges integer and boolean types to the existing scalar AST.

```jai
Point :: struct {
    x, y: int;
    enabled: bool = true;
}

change :: (point: Point) -> Point {
    point.x += 2;
    return point;
}

main :: () -> int {
    point: Point = .{x=40};
    return change(point).x;
}
```

Records retain one authoritative ordered `members` list. `RecordMember` distinguishes fields, constants, aliases, nested records/enums, procedure definitions/prototypes, and insertion requests. `fields()` is a filtered iterator for consumers that have already validated or bound the other member categories; it must not be used to silently discard unsupported members. Plain grouped fields expand into individual entries, each retaining the declaration span. A shared typed default such as `width,height,depth:s32 = 1` is preserved on each expanded field with the same initializer source span. `FieldBinding::Explicit` stores type and optional default; `Inferred` stores the default expression. `using` remains a field annotation. `---` is recognized only in explicit declaration/field initializer positions, never as a general readable expression.

Parameterized record headers preserve ordered `RecordParameter` entries with either a typed binding and optional default or an inferred default. The optional `$` marker does not change record parameter semantics: both forms are baked, as documented in the supplied polymorphic structs tutorial. Parsing preserves arguments and templates; specialization determines canonical nominal identity and binds each instance's member scope.

Record and field metadata remain unresolved syntax: record `#align`, `#no_padding`, `#type_info_none`, field `#align`, and notes such as `@JsonName(context)`. Alignment is an expression, and a field alignment can be smaller than its natural alignment, as in the supplied Windows definitions. Prefix/postfix record attributes merge with duplicate diagnostics. `FieldDeclaration.conversion` distinguishes `#as` implicit conversion through a field from `using` member exposure, including both prefix orders. Neither qualifier implies the other. Inline records retain their own ordered fields; notes after an inline field attach to that field. See [declaration metadata](declaration-metadata.md) for the decoding boundary.

A variable annotated directly with an inline record, such as Focus's `settings_info: struct { ... }`, may end at the record body without a semicolon when it has no initializer. Global and local storage use the same declaration parser. An explicit initializer and ordinary or pointer annotations still require their declaration terminator; the inline body does not swallow the next declaration.

Anonymous type values also preserve their body as `ExpressionKind::Type`, for example `record_type := struct { x:int; y:int; }`. The same expression boundary accepts `union`, `enum`, and `enum_flags`. A direct anonymous type body can terminate its initializer declaration without a semicolon, as in the supplied anonymous-struct example; a pointer or ordinary type expression still needs a declaration terminator. Nominal identity and the resulting `Type` value belong to semantic binding, not the parser.

Enums retain optional representation types, `#specified`, implicit members, and explicit `::` initializer expressions. Value assignment, duplicate checking, representation validation, and enforcing `#specified` belong to semantic analysis.

Procedure parameters retain required/defaulted bindings, `using`, and typed `ParameterBaking` policy: ordinary names use `None`, `$name` requires baking, and `$$name` permits optional baking. This source policy stays distinct from an introducing type variable such as `value: $T`. `TypeSyntax::Restricted` additionally preserves `$T/Template` or `$T/interface Shape` with its exact introducing leaf span; matching those restrictions belongs to the canonical specialization binder. See [procedure overloads](procedure-overloads.md).

Aggregate annotations use `RequiredType`/`DefaultedType`; scalar variants remain an explicit compatibility bridge. Procedure `results` is the authoritative ordered result list. `ResultBinding::Typed` contains a type and optional default; `InferredDefault` contains an initializer. Each result also has `ResultUsage::Optional` or `Required`; a source `#must` marks that individual result, including intrinsic prototype results. Duplicate obligations produce a located error. Checking whether calls capture every required result belongs to semantic binding; parsing does not authorize silently discarding it. `scalar_return_type()` returns `None` for signatures outside the unnamed, non-defaulted, optional, zero-or-one scalar result bridge, so an aggregate result or obligation cannot silently become `void`.

`TypeSyntax::This` preserves a source `#this` annotation, including pointer and array fields. The record binder resolves it against the actual enclosing nominal reservation or specialization; it is forbidden in procedure headers and record parameter lists. See [record self types](record-self-types.md) for owner-context guards and executable verification.

```jai
split :: (value: int) -> (first: int = 1, second := 2, ready: bool) {
    return ready=true, second=value, first=3;
}

apply :: (callback: (value: int) -> int, value: int) -> int {
    return callback(value);
}
```

Unparenthesized and parenthesized result lists are supported. A comma after an inline callback's single result belongs to the enclosing parameter list; explicitly parenthesized callback result lists support multiple results. Procedure declarations/types preserve `#c_call` and `#no_context`, and typed variadic parameters preserve `..T`. Foreign/compiler/intrinsic prototypes have a separate bodyless declaration AST; they cannot be mistaken for a defined procedure with an empty body. Intrinsic prototypes preserve an optional backend tag, use no implicit context, and reject source bodies or `#expand`. Multiple/named return statements use `ReturnValues`; grouped declarations and assignments use `DeclareResults`/`AssignResults`. These are ordered result bindings, not a public tuple value/type.

`PlaceSyntax` tags names, qualified paths, member projections, array indexes, and pointer dereferences. Assignment statements preserve these operations instead of reducing their targets to a spelling. `array[0].x = 3`, `pointer.* = 4`, and comma-separated result assignments retain their source evaluation order for lowering. Parsing rejects targets that cannot denote places; mutability and valid storage roots are semantic decisions.

Named struct literals (`Point.{x=3}`, `.{x=3}`, and `.{}`) preserve optional nominal type names and field order. Positional literals (`Point.{1,2}`) have a separate ordered-value AST; mixing named and positional entries is rejected. Array literals (`int.[1,2]`, `.[1,2]`, `.[]`) preserve optional element `TypeSyntax` and ordered elements. Trailing commas are supported. Indexing, address-of `*value`, postfix dereference `pointer.*`, contextual enum/member names `.READY`, `null`, arbitrary procedure-valued call expressions, unresolved casts, and typed `size_of`/`type_of`/`initializer_of`/`type_info`/`code_of` queries have dedicated AST forms.

Procedure bodies preserve local record, enum, alias, procedure, and prototype declarations. Sequence loops preserve their value/index bindings, optional pointer binding, direction, and body separately from integer range loops. `push_context` stores an optional source context expression and a scoped block. Call syntax after `,,` retains named context field overrides separately from ordinary arguments; an unnamed override is the allocator shorthand. Each `CallArgument` also preserves a spread marker for `..args` descriptor forwarding, including when fixed arguments follow the spread. Ordinary spreads can retain their parameter name, as in `v=..array`; context overrides cannot be spread. The standalone `context` keyword has `ExpressionKind::Context`; leading `.NAME` has `InferredMember` for contextual enum/member inference. They are separate syntax forms.

`#add_context` emits `FileItem::ContextField` with either a variable declaration or a constant declaration. Context fields are separate from ordinary namespace declarations; module graph loading retains them for the context schema. The `#Context` and `Any` types have builtin source tags rather than named type spellings; semantic analysis supplies their canonical schemas.

Procedure and record `#modify` blocks retain a separate `ModifyDirective` with its own span and statement body. The subsequent declaration body is never merged with the modifier. Specialization must execute or reject the modifier before binding the runtime declaration; simply ignoring it would change accepted types and overload selection.

Bare dotted paths such as `point.x` remain `QualifiedName` because parsing cannot distinguish a record member from a namespace. Other bases, such as `change(point).x`, use `ExpressionKind::Member`. The resolver must inspect the resolved base, including for assignment places, rather than assume every dotted path denotes a module.

Definite aliases such as `Count :: int`, `Values :: [3] int`, and `Callback :: #type (...) -> int` use `TypeAliasDeclaration`. Ambiguous `Alias :: Point` and `Address :: *value` remain expressions: only semantic resolution knows whether their operand is a type or a value. Typed array constants such as `numbers :: int.[1,2]` remain constants rather than becoming aliases.

String literals store bytes, including non-UTF-8 `\xFF`, and decode documented escapes (`\e`, `\n`, `\r`, `\t`, `\"`, `\\`, `\0`, `\xAB`, `\d123`, `\uABCD`, `\UABCDEF12`). `FloatLiteral` preserves exact 32/64-bit `0h` patterns or an opaque validated `DecimalLiteral`. Decimal spelling is normalized by removing underscores; `round_f32()` and `round_f64()` round directly in the requested context and report range errors there. The parser does not first round every decimal through `f64`, which would incorrectly double-round some `f32` constants.

Here-strings retain decoded bytes and typed modifiers, with an optional terminal semicolon for a direct here-string declaration. `#char` currently accepts one decoded byte. See [literal syntax](literal-syntax.md) for supported escapes and explicit limits.

`#code` quotes a complete expression operator tree, block, or statement subtree. An expression quote stops at its enclosing comma, closing delimiter, or semicolon, so `consume(#code left + right * 2, 3)` retains two call arguments. A quoted statement and its enclosing declaration share the source's single semicolon. `#insert` retains its value and either captured or current (`#insert,scope()`) scope mode at file, statement, expression, and assignment-place positions. The short form `#insert -> Type { body }` preserves a typed `CompileTimeBody::Procedure`; it does not generate a source string. Compile-time procedure/block insertion permits an omitted terminal semicolon. Source `#run` expression statements with block/procedure bodies also permit the omitted semicolon. Defining scope capture, expansion, and insertion are semantic work, independent of this syntax representation.

The standalone `parse(&str)` API accepts local scalar procedures, including explicit `#no_context`, and retains its scalar executable boundary. It rejects aggregate definitions, non-scalar signatures/annotations, aggregate literals, result lists, and writable aggregate places. Source `#run` syntax is also recognized by that API through the separately owned compile-time execution component. Expanded syntax acceptance never substitutes for `check`, `build`, or native execution evidence.

`#add_context` preserves ordinary variable/constant additions and qualified field declarations. A prefixed `using` or `#as` addition stores its complete `FieldDeclaration`, including defaults, alignment, and notes. The same parser handles a file item and a quoted statement such as `FIRST_ADD_CONTEXT :: #code #add_context #as using base: Context_Base;`. Quoting retains the single shared semicolon. Registration of inserted context fields and defining the final context schema are separate compiler scheduling steps.

A bodyless named callback signature such as `Allocator_Proc :: (size: s64) -> *void;` is a `TypeAlias` containing `TypeSyntax::Procedure`, rather than a procedure definition or bound prototype. `callback_aliases.rs` performs delimiter-aware lookahead before nominal dispatch; explicit foreign/compiler/intrinsic bindings and source bodies retain their distinct declarations. Parenthesized value constants such as `(1 + 2)` retain their expression AST.

Builtin pointer aliases such as `marg_list :: *void;` also have an explicit type-alias AST. Named pointer expressions remain ambiguous until semantic declaration lookup. A sole callback `void` result is normalized to zero runtime results before canonical signature interning; see [source type aliases](type-aliases.md).

Check directives preserve lexical policy overrides. `Procedure.checks` stores procedure-body `#no_abc` and `#no_aoc` flags; `StatementKind::CheckScope` retains marked blocks, including loop and conditional bodies. An omitted flag remains `CheckPolicy::Inherited`, so an inner arithmetic override does not erase an outer array policy. Duplicates and bodyless prototype/type modifiers produce diagnostics. Semantic lowering resolves these flags onto typed arithmetic and index nodes, and the VM and LLVM backend consume that decision. See [scoped safety checks](safety-checks.md) for inheritance and retained validity guards. The supplied `Program_Print/module.jai` maps these exact spellings to the corresponding compiler block flags.

Source-scoped `#if` is distinct from runtime `if`: `StatementKind::CompileTimeIf` retains its condition and both branch statement lists, including nested `else #if` and quoted selections. Each statement retains its original span. Target-aware semantic selection determines which branch to bind, so inactive procedures or platform APIs need not resolve. The standalone scalar parser rejects this form because it lacks source target selection.

`ExpressionKind::CallerLocation` preserves `#caller_location` as a deferred expression, including its original directive range. Parameter defaults retain this marker instead of substituting the declaration's location. The semantic call binder determines the actual call's source provenance when it materializes the default; the standalone scalar parser rejects the marker because it cannot provide that binding.

Variable declarations retain `attributes` separately from their type and initializer. `DeclarationAttribute::Alignment` stores the source expression in an explicit local or global annotation, such as `data: [1024] u8 #align 64;`; inferred declarations currently have no source attribute syntax and retain an empty list. The semantic layout binder validates the requested storage alignment and applies it to actual storage. Field alignment remains a separate attribute because changing record field offsets differs from aligning a variable allocation.

## How to change it

Compiler prototypes retain `#no_context` before or after their `#compiler` marker, including a quoted compiler tag. Duplicate context directives are diagnosed across that marker boundary. This supports the supplied Runtime_Support declaration `compile_time_debug_break :: () #compiler #no_context;` without changing its binding or replacing it with an empty source procedure.

Local `#import` statements use `ScopedImportDeclaration`: the same module target, mode, arguments, namespace, and `using` grammar as file imports, with a real local `Span` rather than an invented file identity. The module graph attaches the defining file's source identity during dependency discovery, while lexical binding determines where the imported names are visible. A local import remains in its procedure/conditional statement list.

`#code,null` produces `CodeBody::Null`, distinct from `#code null`, which quotes a null expression. The null form has no captured source subtree or scope. Code registry/default binding and insertion diagnostics determine its semantics; the parser preserves the distinction.

Record-body `#assert` and `#if` directives retain their condition expressions and source ranges in the ordered `RecordMember` list. Conditional bodies support braces or one declaration, including nested `else #if`. The parser preserves both member branches. Specialization must select the same checked members during reservation and materialization, and prove assertions before publishing its shape; unsupported semantic conditions require a diagnostic rather than silently filtering members. `record_conditionals.rs` shares the canonical `record_member_group()` parser so grouped fields and nested declarations retain their order.

`xx` is a contextual cast with an inferred target type. `ExpressionKind::InferredCast` preserves its operand and `CastMode`: bare `xx` is checked, while `xx,no_check` explicitly disables range checking. The source Jai lexer identifies `xx` as an auto-cast, and supplied Reflection/Bit_Operations sources preserve the separate unchecked modifier. Calls, indexing, and other postfix operations remain inside the operand; ordinary binary operations remain outside unless parenthesized. The semantic binder must supply the target type from the enclosing assignment, argument, result, or other supported context; the parser does not invent one.

The operator table puts bitwise operations above equality and relational comparisons, while shifts and arithmetic remain above bitwise operations. This matches source flag tests such as `flags & .POINTER != 0`. The constant evaluator consumes this same parsed AST, so its operator grouping cannot drift into a separate precedence grammar.

`context_fields.rs` shares context additions between files and quoted statements. `declaration_attributes.rs` parses storage attributes, while `safety_checks.rs` parses lexical check policies and `statement_conditionals.rs` parses target selections. Keep those helpers structural: scope lookup, constant evaluation, policy inheritance, and storage layout belong to their semantic consumers. When changing a declaration attribute, adapt every exact destructuring pattern and keep the original attribute expression available for layout diagnostics.

`types.rs` owns unresolved types, nominal declarations, aliases, and struct literals. `record_members.rs` owns the canonical record body and field parsing; `record_parameters.rs` owns template headers and type application arguments. `procedures.rs` owns procedure declarations and type signatures. `expressions.rs` owns precedence parsing; `places.rs` converts expression forms into valid syntactic places; `literals.rs` owns numeric and byte-string decoding; `metadata.rs` owns attributes and notes. `modules.rs` connects top-level declarations/visibility; `statements.rs` owns declaration, control-flow, and place statement parsing. The common AST and parser primitives remain in `lib.rs`. Source `#run` bodies live in `compile_time.rs`; quoted source and insertion helpers live in `code_syntax.rs`.

Name interning and built-in type classification use canonical token spellings. [Padded identifiers](padded-identifiers.md) retain their complete source spans while removing backslashes and following ASCII spaces from symbol identity. [Record default overrides](record-default-overrides.md) retain plain record-body assignments as ordered source members, preserving structural targets for the owning record's default binder.

`type_annotations.rs` preserves `type_of(expression)` in a type position as `TypeSyntax::TypeOf`, including the original operand AST and span. A declared-field query such as the newer File_Async formal `code: type_of(Error.code)` must resolve through checked field/type metadata without evaluating the operand. Unsupported annotation expressions require a located semantic diagnostic rather than an invented type.

`casts.rs` shares target/value parsing between prefix `cast(T) expression` and function-style `cast(T, expression)`. Both produce the same checked or explicitly unchecked cast nodes; the function-style span includes its closing parenthesis and preserves nested calls/casts. Target binding and conversions remain semantic work. Source modifiers with different intent, such as `trunc`, must retain that intent through a checked conversion policy instead of being silently treated as `no_check`.

Update module declaration binding and every downstream AST match when adding a variant. Preserve literal precision and source order. Resolve names to canonical IDs only after module/file scope lookup. Extend common checked IR and backend support together when promoting a parsed form into executable support.

Array slicing, hexadecimal fractional floats, and grouped inferred field declarations remain outside this parser slice and produce diagnostics. Unknown lexer directives produce a specific located diagnostic instead of being silently accepted. Parsed record members and type applications still require supported semantic binding and lowering; a syntax success does not imply those compiler phases accept them.

Regression tests cover fields/defaults, unresolved shapes, enum members, signatures/result defaults, callback comma boundaries, baked/type-variable metadata, multi-result bindings, index/member/pointer places, literal/projection precedence, exact float rounding, string escapes, malformed input, and the scalar parser boundary. Run:

```sh
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --locked -j1
RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo clippy -p jai-syntax --all-targets --locked -j1 -- -D warnings
```

The source evidence is the supplied `reference/how_to/002_number_types.jai`, `004_arrays.jai`, `005_strings.jai`, `006_structs.jai`, `007_struct_literals.jai`, `010_calling_procedures.jai`, `013_enums.jai`, `015_array_literals.jai`, `042_using.jai`, and `110_polymorphic_arguments.jai`. Pinned jaison `typed.jai` (`Member_Offset`) and `module.jai` (`Special_Float_Handling`, `Ignore_Proc`) confirm recent record, flags, and procedure-type usage. Tests reproduce small shapes without requiring ignored corpus downloads. No original reference binary, library, or object executes.

## Configuration

No environment variables or parser feature flags enable aggregate execution. `parse_file` takes a shared `Symbols` interner and preserves source identity; `parse` uses its own interner and the scalar boundary. Source declarations/directives determine field defaults, type forms, calling convention, context mode, and file visibility.

## Dependencies

`jai-lexer` provides keyword/punctuation tags, `jai-source` provides symbols/source spans, and `jai-types` provides builtin scalar/float tags, record kind, calling convention, context mode, and shared operator domains. Semantic resolution, canonical IDs, layout, result binding, compile-time evaluation, and runtime lowering belong to later compiler stages.
