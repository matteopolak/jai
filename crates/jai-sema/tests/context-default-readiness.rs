use jai_modules::{GraphOptions, ModuleGraph, SourceOverlay};
use std::path::Path;

fn resolve(source: &str) -> Result<jai_ir::Program, jai_source::LocatedDiagnostic> {
    let mut overlay = SourceOverlay::new();
    let path = Path::new("/jai-context-default-readiness/main.jai");
    overlay.insert(path, source.as_bytes().to_vec()).unwrap();
    let graph = ModuleGraph::load_with_provider(path, GraphOptions::default(), &overlay).unwrap();
    jai_sema::resolve_graph(&graph)
}

#[test]
fn explicit_record_field_context_defaults_reuse_the_completed_schema() {
    let program = resolve("adjust::(value:int)->int{return value+2;} #add_context marker:int=40; #add_context callback:(value:int)->int=adjust; Holder::struct{saved:#Context=.{};} snapshot:Holder; main::()->int{return snapshot.saved.callback(snapshot.saved.marker);}").unwrap();
    let context = program.context().unwrap();
    let jai_ir::GlobalInitializer::Value(initializer) =
        program.library().globals()[0].initializer()
    else {
        panic!("holder global must have a value initializer");
    };
    let jai_ir::ConstantKind::Record(holder) = &initializer.kind else {
        panic!("holder global must have a record default");
    };
    assert_eq!(&holder[0], &context.default);
    assert!(
        matches!(jai_vm::execute(&program, jai_vm::Limits::default()).outcome,
        jai_vm::Outcome::Complete(values) if matches!(values.as_slice(), [jai_vm::Value::Int(value)] if value.value()==42))
    );
}

#[test]
fn context_record_default_cycles_remain_source_errors() {
    let error =
        resolve("Holder::struct{saved:#Context=.{};} #add_context holder:Holder; main::(){}")
            .unwrap_err();
    assert_eq!(
        error
            .location
            .span
            .text("Holder::struct{saved:#Context=.{};} #add_context holder:Holder; main::(){}"),
        ".{}"
    );
    assert!(
        error.message.contains("record")
            || error.message.contains("context")
            || error.message.contains("cycle"),
        "{error}"
    );
}
