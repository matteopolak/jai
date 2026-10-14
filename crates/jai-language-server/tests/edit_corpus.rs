#[path = "../examples/support/edit_coverage.rs"]
mod edit_coverage;

#[test]
fn every_line_suffix_in_original_fixtures_preserves_independent_features() {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../tests/lsp/partial");
    for name in [
        "standalone.jai",
        "custom_iteration.jai",
        "opaque.jai",
        "lists.jai",
    ] {
        let file = root.join(name);
        let source = std::fs::read_to_string(&file).unwrap();
        let report = edit_coverage::check(&file, &source, None, 0);
        assert!(report.edits > 40, "{report:?}");
        assert!(report.failures.is_empty(), "{report:#?}");
    }
}
