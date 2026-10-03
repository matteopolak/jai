use jai_modules::{GraphOptions, ModuleGraph, SourceOverlay};
use jai_sema::{PreparedLibrarySession, ResolveOptions, SourcePrefixReadiness};
use jai_source::{SourceSpan, Span};
use std::path::Path;

#[test]
fn no_progress_keeps_the_actual_cyclic_constant_demand_and_phase() {
    let source =
        "count::()->int #no_context{return Count;} Count::count(); Alias::#type [Count]u8;";
    let path = Path::new("/prepared-no-progress/main.jai");
    let mut provider = SourceOverlay::new();
    provider.insert(path, source.as_bytes().to_vec()).unwrap();
    let graph = ModuleGraph::load_with_provider(path, GraphOptions::default(), &provider).unwrap();
    let count = graph
        .declarations()
        .iter()
        .find(|declaration| graph.symbols().name(declaration.name()) == "Count")
        .unwrap();
    let alias = graph
        .declarations()
        .iter()
        .find(|declaration| graph.symbols().name(declaration.name()) == "Alias")
        .unwrap();
    let start = source.rfind("Count").unwrap();
    let location = SourceSpan {
        source: alias.location().source,
        span: Span::new(start, start + "Count".len()),
    };
    let mut session = PreparedLibrarySession::new(&graph, &ResolveOptions::default()).unwrap();
    let SourcePrefixReadiness::Failed(error) = session.drive_source_prefix(&mut jai_vm::NoEffects)
    else {
        panic!("a cyclic checked constant cannot publish a ready type")
    };
    assert_eq!(error.location, location);
    assert_eq!(error.location.span.text(source), "Count");
    assert!(error.message.contains("mode Types"), "{error}");
    assert!(
        error
            .message
            .contains(&format!("declaration: {:?}", count.id())),
        "{error}"
    );
    assert!(
        error.message.contains(&format!("location: {location:?}")),
        "{error}"
    );
    assert!(
        error.message.contains("selected constants ready false"),
        "{error}"
    );
    assert!(
        error.message.contains("field prerequisites ready true"),
        "{error}"
    );
    assert!(
        error.message.contains("record modifiers queued 0"),
        "{error}"
    );
    assert!(error.message.contains("selected layout None"), "{error}");
}
