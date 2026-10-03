use super::*;

#[test]
fn file_census_visits_nested_source_defaults_and_spare_capacity() {
    let mut sources = jai_source::SourceMap::default();
    let id = sources.insert(
        "metadata.jai".into(),
        "f :: (value: string = \"abc\") { local :: #code { return \"inside\"; }; }".into(),
    );
    let file = parse_file(sources.get(id).unwrap(), &mut Symbols::default()).unwrap();
    let mut bytes = 0;
    file.visit_retained_metadata(&mut |_, value| {
        bytes += value;
        Ok::<_, ()>(())
    })
    .unwrap();
    assert!(bytes >= file.retained_items().capacity() * size_of::<FileItem>() + 9);
    let mut cloned = file.items()[0].clone();
    if let FileItem::Declaration(declaration) = &mut cloned {
        if let FileDeclarationKind::Procedure(procedure) = &mut declaration.kind {
            procedure.body.reserve(100);
        }
    }
    let mut clone_bytes = 0;
    cloned
        .visit_retained_metadata(&mut |_, value| {
            clone_bytes += value;
            Ok::<_, ()>(())
        })
        .unwrap();
    assert!(
        clone_bytes > bytes,
        "a distinct cloned AST owns its actual spare statement capacity"
    );
}

#[test]
fn file_container_denial_stops_before_traversing_any_item() {
    let mut sources = jai_source::SourceMap::default();
    let id = sources.insert("empty.jai".into(), String::new());
    let file = ParsedFile::from_items(id, Vec::with_capacity(100));
    let mut calls = 0;
    assert_eq!(
        file.visit_retained_metadata(&mut |_, _| {
            calls += 1;
            Err("denied")
        }),
        Err(SourceMetadataError::Admission("denied"))
    );
    assert_eq!(calls, 1);
}

#[test]
fn source_metadata_nesting_has_a_typed_boundary() {
    let mut expression = Expression {
        kind: ExpressionKind::Bool(true),
        span: Span::default(),
    };
    for _ in 0..=MAX_SOURCE_METADATA_DEPTH {
        expression = Expression {
            kind: ExpressionKind::AddressOf(Box::new(expression)),
            span: Span::default(),
        };
    }
    assert_eq!(
        expression.visit_retained_metadata(&mut |_, _| Ok::<_, ()>(())),
        Err(SourceMetadataError::ExcessiveNesting)
    );
}
