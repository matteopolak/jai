#[test]
fn authored_standard_allocator_runs_its_real_heap_ledger_without_stdio() {
    let workspace = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../..")
        .canonicalize()
        .unwrap();
    let roots = vec![workspace.join("stdlib")];
    let unit = CompilationUnit::load_with_bootstrap(
        &workspace.join("tests/stdlib/default-allocator.jai"),
        GraphOptions {
            import_dirs: roots.clone(),
        },
        BootstrapOptions {
            prelude: PreludeSource::File(workspace.join("stdlib/Preload.jai")),
            runtime_support: Some(RuntimeSupportOptions {
                source: RuntimeSupportSource::File(workspace.join("stdlib/Runtime_Support.jai")),
                parameters: RuntimeSupportParameters {
                    define_system_entry_point: false,
                    define_initialization: false,
                    enable_backtrace_on_crash: false,
                },
            }),
        },
        Some(target()),
    )
    .unwrap();
    let context =
        jai_sema::FileAbiBindingContext::allocator_from_graph(unit.graph(), &roots, target())
            .unwrap();
    assert!(context.includes_default_allocator());
    let program = unit.resolve_with_target(target()).unwrap();
    assert_eq!(answer(&program), 0);
}
