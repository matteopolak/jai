//! Original standalone IDE fixtures, independent of any library implementation.
use jai_language_server::{DocumentUri, Environment, Limits, Position, Session};

fn session() -> Session {
    Session::with_environment(
        Limits::default(),
        Environment {
            fs: std::rc::Rc::new(jaic::sema::NativeFs),
            options: Box::new(|_| {
                let mut options = jaic::sema::Options::host();
                options.runtime_support = false;
                options.stack_trace = false;
                options
            }),
        },
    )
}

fn uri() -> DocumentUri {
    DocumentUri::parse("file:///partial-edits/main.jai").unwrap()
}

fn at(text: &str, needle: &str) -> Position {
    position(text, text.find(needle).unwrap())
}

fn position(text: &str, byte: usize) -> Position {
    let prefix = &text[..byte];
    Position {
        line: prefix.matches('\n').count() as u32,
        character: prefix.rsplit('\n').next().unwrap().encode_utf16().count() as u32,
    }
}

#[test]
fn custom_for_keyword_uses_selected_overload_without_changing_operand_reference() {
    let text = r#"For_Flags :: u8;
Bag :: struct { count: int; }
Other :: struct { count: int; }
for_expansion :: (b: Other, body: Code, flags: For_Flags) #expand {
    for 0..b.count { `it := 1; #insert body; }
}
for_expansion :: (b: *Bag, body: Code, flags: For_Flags) #expand {
    for 0..b.count { `it := 2; #insert body; }
}
main :: () {
    collection: Bag;
    for item: collection { result := item; }
    for n: 0..3 { result := n; }
    array: [3] int;
    for value: array { result := value; }
}
"#;
    let mut s = session();
    s.open(uri(), 1, text.into()).unwrap();
    assert!(
        s.diagnostics(&uri())
            .unwrap()
            .iter()
            .all(|d| d.severity != jai_language_server::DiagnosticSeverity::Error),
        "{:?}",
        s.diagnostics(&uri())
    );
    let defs = s.definition(&uri(), at(text, "for item")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}");
    assert_eq!(defs[0].range.start, at(text, "for_expansion :: (b: *Bag"));
    let defs = s.definition(&uri(), at(text, "collection {")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}");
    assert_eq!(defs[0].range.start, at(text, "collection: Bag"));
    for needle in ["for n:", "for value:"] {
        assert!(s.definition(&uri(), at(text, needle)).unwrap().is_empty());
    }
}

#[test]
fn partial_statement_preserves_syntax_and_semantics_after_it() {
    let text = "Record :: struct { field: int; }\nmain :: () {\n    before := 10;\n    broken := (\n    after: Record;\n    answer := before + after.field;\n}\nlast :: () {}\n";
    assert!(jaic::parser::parse_file(jaic::source::FileId(0), text).is_err());
    let mut s = session();
    s.open(uri(), 1, text.into()).unwrap();
    let symbols = s.document_symbols(&uri()).unwrap();
    assert!(symbols.iter().any(|sym| sym.name == "last"), "{symbols:?}");
    let hover = s
        .hover(&uri(), at(text, "after.field"))
        .unwrap()
        .expect("typed after");
    assert!(
        hover.contents.value.starts_with("after: Record"),
        "{hover:?}"
    );
    let defs = s.definition(&uri(), at(text, "before +")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}");
    assert_eq!(defs[0].range.start, at(text, "before :="));
    let items = s
        .completion(
            &uri(),
            position(text, text.find("after.field").unwrap() + 6),
        )
        .unwrap();
    assert!(items.items.iter().any(|i| i.label == "field"), "{items:?}");
    let diagnostics = s.diagnostics(&uri()).unwrap();
    assert!(!diagnostics.is_empty());
    assert!(
        diagnostics
            .iter()
            .all(|d| (3..=4).contains(&d.range.start.line)),
        "{diagnostics:?}"
    );
}

#[test]
fn named_generic_aliased_and_explicit_custom_iterations_resolve_actual_procedures() {
    for (declaration, extra, loop_header) in [
        (
            "walk :: (b: Bag, body: Code, flags: For_Flags)",
            "",
            "for :walk item: collection",
        ),
        (
            "walk :: (b: *Bag, body: Code, flags: For_Flags)",
            "",
            "for :walk item: collection",
        ),
        (
            "walk :: (b: $T, body: Code, flags: For_Flags)",
            "",
            "for :walk item: collection",
        ),
        (
            "walk :: (b: Bag, body: Code, flags: For_Flags)",
            "alias :: walk;",
            "for :alias item: collection",
        ),
        (
            "walk :: (b: Bag, body: Code, flags: For_Flags)",
            "for_expansion :: walk;",
            "for item: collection",
        ),
        (
            "walk :: (b: Bag, body: Code, flags: For_Flags)",
            "",
            "for item: walk(collection)",
        ),
        (
            "walk :: (b: *$T, body: Code, flags: For_Flags)",
            "",
            "for :walk item: collection",
        ),
    ] {
        let text = format!(
            "For_Flags :: u8;\nBag :: struct {{ count: int; }}\n{declaration} #expand {{\n    for 0..b.count {{ `it := 7; #insert body; }}\n}}\n{extra}\nmain :: () {{\n    collection: Bag;\n    {loop_header} {{ result := item; }}\n}}\n"
        );
        let mut s = session();
        s.open(uri(), 1, text.clone()).unwrap();
        let errors: Vec<_> = s
            .diagnostics(&uri())
            .unwrap()
            .into_iter()
            .filter(|d| d.severity == jai_language_server::DiagnosticSeverity::Error)
            .collect();
        assert!(errors.is_empty(), "{loop_header}: {errors:?}");
        let defs = s.definition(&uri(), at(&text, loop_header)).unwrap();
        assert_eq!(defs.len(), 1, "{loop_header}: {defs:?}");
        assert_eq!(defs[0].range.start, at(&text, declaration), "{loop_header}");
    }
}

#[test]
fn imported_custom_iteration_navigates_to_its_source() {
    let imported = DocumentUri::parse("file:///partial-edits/iterator.jai").unwrap();
    let library = "Bag :: struct { count: int; }\nFor_Flags :: u8;\nfor_expansion :: (b: Bag, body: Code, flags: For_Flags) #expand {\n    for 0..b.count { `it := 7; #insert body; }\n}\n";
    let text = "#import,file \"iterator.jai\";\nmain :: () {\n    collection: Bag;\n    for item: collection { result := item; }\n}\n";
    let mut s = session();
    s.open(imported.clone(), 1, library.into()).unwrap();
    s.open(uri(), 1, text.into()).unwrap();
    let defs = s.definition(&uri(), at(text, "for item")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}; {:?}", s.diagnostics(&uri()));
    assert_eq!(defs[0].uri, imported.as_str());
    assert_eq!(defs[0].range.start, at(library, "for_expansion"));
}

#[test]
fn semantic_error_keeps_later_independent_locals_and_reports_both_errors() {
    let text = "main :: () {\n    broken := missing_name;\n    healthy := 42;\n    result := healthy + 1;\n    another := other_missing;\n}\n";
    let mut s = session();
    s.open(uri(), 1, text.into()).unwrap();
    let hover = s
        .hover(&uri(), at(text, "healthy +"))
        .unwrap()
        .expect("healthy hover");
    assert_eq!(hover.contents.value, "healthy: s64");
    let defs = s.definition(&uri(), at(text, "healthy +")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}");
    assert_eq!(defs[0].range.start, at(text, "healthy :="));
    let errors: Vec<_> = s
        .diagnostics(&uri())
        .unwrap()
        .into_iter()
        .filter(|d| d.severity == jai_language_server::DiagnosticSeverity::Error)
        .collect();
    assert_eq!(errors.len(), 2, "{errors:?}");
    assert!(errors.iter().any(|d| d.message.contains("missing_name")));
    assert!(errors.iter().any(|d| d.message.contains("other_missing")));
}

#[test]
fn missing_close_brace_keeps_procedure_locals_and_next_global_separate() {
    let text = "main :: () {\n    local := 42;\n    result := local + 1;\nnext :: () {\n    local := false;\n    result := local;\n}\n";
    let mut s = session();
    s.open(uri(), 1, text.into()).unwrap();
    let symbols = s.document_symbols(&uri()).unwrap();
    assert!(symbols.iter().any(|sym| sym.name == "next"), "{symbols:?}");
    let hover = s
        .hover(&uri(), at(text, "local +"))
        .unwrap()
        .expect("local hover");
    assert_eq!(hover.contents.value, "local: s64");
    let defs = s.definition(&uri(), at(text, "local;\n}")).unwrap();
    assert_eq!(defs.len(), 1, "{defs:?}");
    assert_eq!(defs[0].range.start, at(text, "local := false"));
}
