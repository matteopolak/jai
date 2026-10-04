# Enum bodies and source file items

## What it is

Enums retain an ordered tree of members, `#if` branches and `#insert` requests. File syntax also retains unnamed libraries, `#poke_name`, conditional direct calls, record imports and literal here-string module sources.

## How it works

`EnumDeclaration.members` and `EnumTypeSyntax.members` contain `EnumBodyItem` values. A checked producer walks the tree with `EnumMemberCursor`, evaluates each guard in the current scalar scope, and admits only the selected members. Conditions can use previously admitted enum values. Automatic values, flags progression, duplicate checks and specified-value requirements apply in selected source order. The original declaration owns the nominal identity; selecting a branch does not create another enum. Reflection records the selected names alongside their values, avoiding a zip against inactive source members.

Local, module, nested and anonymous enum producers share the selection cursor. The dependency graph uses it for nominal enum arguments. Source tooling uses the separate `EnumMemberSyntax` iterator to inspect both branches without pretending to evaluate them. Retained metadata and compiler quotation admission count both branches and generator operands before cloning source syntax.

Nominal and member notes stay attached to their original source nodes, including members in inactive branches. The ordered member parser accepts extra separators without creating members. Metadata and quotation visitors charge each member's notes alongside its initializer; selection does not discard source storage or grant notes a new runtime interpretation.

`#import,string #string END ... END;` decodes the genuine here-string bytes and sends the resulting UTF-8 source through the existing closed string-module loader. Other import modes still require a quoted path. An unnamed library has its own metadata AST and never receives a fabricated binding name. `#poke_name` keeps its namespace and named/operator selection. Conditional direct calls remain distinct executable items, and record imports keep the existing scoped import syntax.

Parsing these operations does not establish semantic support. Selected enum `#insert` requests currently require an enum-member expansion producer. Active unnamed libraries, `#poke_name`, file calls and record imports have explicit located diagnostics for their separately missing metadata, publication, execution and namespace producers. Inactive branches retain these requests without loading or executing them. No native library is opened by this syntax work.

## How to change it

Extend `enum_body_items.rs` for enum grammar and selection, then update every enum value producer, source lookup, reflection ordering and retained/quotation visitor. Replace the generated-member refusal only when a real bounded producer can retain expansion origins and member order; never flatten both conditional branches or silently ignore an insertion.

Extend `source_file_items.rs` for file-only syntax. Pair a new semantic producer with module graph source identity and admission before removing its located refusal. Record imports belong to the record's source namespace and must not be promoted to global file imports. Declaration-list and statement-termination lanes have separate additive parser hooks; preserve their shared-file changes during integration.

## Configuration

No new environment variables or default VM limits are introduced. Enum conditional parsing is limited to 64 nested branches. Checked selection limits are 128 levels and 65,536 visited items, independently of the existing source metadata and quotation limits. All semantic evaluation remains in the existing target, lexical and scalar constant scopes.

The private candidate's authored source-to-VM checks use `NoEffects`, a closed `SourceOverlay`, runtime execution phase and the existing default VM limits. They remain unrun until the integration owner grants a Cargo lease; parser formatting alone is not acceptance evidence.

## Dependencies

The feature uses `jai-lexer` tokens, `jai-source` spans/interner, `jai-syntax` retained trees, `jai-eval` pure scalar evaluation, `jai-modules` closed graph loading, `jai-sema` nominal type/reflection producers and `jai-vm` for the authored execution checks. The language server visits syntax without executing `#run` or enum generators. No registry dependencies, supplied native artifacts or external services are added.
