# Declaration metadata

`jai-syntax` preserves declaration notes and supported layout/reflection attributes as unresolved syntax. This lets later compiler stages inspect source metadata without treating a note word as an executable variable or applying layout rules during parsing.

## How it works

`Parser::notes()` consumes successive note tokens and returns ordered `NoteSyntax` values. Each note stores an interned name, ordered arguments, and the complete source span, including its argument parentheses.

```jai
dirty: bool; @JsonIgnore
label: string; @JsonName(context)
opened: bool; @Serialize(1)
```

Argument values distinguish `NoteValue::Word(Symbol)` from `NoteValue::Expression(Expression)`. A bare identifier or keyword followed by `,` or `)` is a word. In particular, `context` in `@JsonName(context)` is preserved as metadata instead of becoming a context expression. Numeric, string, and compound expression arguments use the regular expression parser. The argument schema reserves `name: Option<Symbol>` for future support; named note arguments currently produce an explicit unsupported diagnostic because the inspected Jai sources do not establish that form.

`Parser::record_attributes()` consumes a contiguous batch of supported record attributes:

- `#align expression` becomes `RecordAttribute::Alignment(Expression)`.
- `#no_padding` becomes `RecordAttribute::NoPadding`.
- `#type_info_none` becomes `RecordAttribute::TypeInfoNone`.

The source uses `struct #type_info_none { ... }` and `{ ... } #no_padding`. Alignment uses a bare expression, for example `{ ... } #align 4`; no extra directive-specific parentheses or equals sign are required. The surrounding declaration parser attaches prefix and postfix batches to the record and calls `merge_record_attributes` to reject a repeated attribute across those batches. Each batch also rejects repeated attributes.

Fields use a separate `FieldAttribute::Alignment(Expression)` through `Parser::field_attributes()`, matching `ThreadId: DWORD #align 4;` in the supplied Windows module. Field attributes do not silently inherit record-only options. Repeated field alignment is a located diagnostic.

Explicit local and global variable declarations preserve storage alignment as `DeclarationAttribute::Alignment(Expression)` through `declaration_attributes.rs`. The attribute list remains separate from the type and initializer; inferred declarations currently retain an empty list. Storage alignment affects the allocated address rather than record field offsets, so it has its own semantic validation and lowering path. See [storage alignment](storage-alignment.md) for constant evaluation, layout rules, and executable verification.

Attribute expressions remain unresolved. Parsing `#align 4` preserves the expression; it does not establish an effective alignment, byte offsets, packing, or runtime reflection behavior. Unsupported directives are left for the surrounding parser to reject. This implementation does not invent a custom packed attribute.

## How to change it

Add metadata variants and decoder logic in `crates/jai-syntax/src/metadata.rs`, then update the declaration parser hooks and any later consumers that interpret them. Keep bare reserved words out of runtime expression handling. Preserve source order and note spans, and add source-backed tests for new argument forms or directives.

Record parsing must merge prefix and postfix attributes through the duplicate-checking helper before attaching them. The helper validates the suffix against the prefix before changing the prefix vector, so an error cannot leave a partially appended attribute list.

The focused tests cover note names and spans, reserved-word arguments, expression arguments, malformed and unsupported argument forms, field/record distinctions, duplicate attributes, and actual note tokens in the pinned Jaison example. Run `RUSTC_WRAPPER= CARGO_TARGET_DIR=target cargo test -p jai-syntax --locked -j1 metadata::tests`.

## Configuration

No environment variables or configuration files affect metadata parsing. Source notes and directives supply the metadata. No metadata interpretation or layout calculation runs in this parser.

## Dependencies and evidence

Metadata parsing uses `jai-lexer` for tokens, `jai-source` for interned symbols and diagnostics, and the internal expression parser for expression arguments. It adds no external dependencies.

`reference/how_to/935_type_info_reduction.jai` demonstrates prefix `#type_info_none`; `reference/modules/Windows.jai` demonstrates field `#align` and postfix `#no_padding`; and `reference/modules/Socket/generated_macos.jai` demonstrates postfix record `#align`. Pinned corpus examples include `corpus/upstream/rluba--jaison/examples/example.jai` for `@JsonIgnore` and `@JsonName(context)`, `corpus/upstream/SogoCZE--Jails/server/lsp_interface.jai` for identifier-valued notes, and `corpus/upstream/ostef--Vk-Engine/Source/Editor/gizmo.jai` for `@Serialize(1)`. The source revisions are recorded in `corpus/upstreams.json`. Validation reads these sources and exercises this Rust parser without executing supplied compiler binaries, libraries, or objects.
