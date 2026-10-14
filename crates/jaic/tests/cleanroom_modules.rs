//! Original regressions derived from docs/specs/jai and distribution policy.
use jaic::sema::{Compiler, Options, VirtualFs};
use std::path::Path;
use std::rc::Rc;

fn compiler(files: &[(&str, &str)], bootstrap: bool) -> Compiler {
    let mut fs = VirtualFs::default();
    for &(path, source) in files {
        fs.insert(path, source.as_bytes());
    }
    let mut options = Options::host();
    options.runtime_support = false;
    options.import_paths = vec!["/lib".into()];
    if bootstrap {
        options.preload = Some("/lib/prelude/module.jai".into());
    }
    Compiler::new(options, Rc::new(fs))
}

fn succeeds(c: &mut Compiler) {
    if let Err(error) = c.compile_program(Path::new("/app/main.jai")) {
        panic!("{}", error.render(&c.sources));
    }
}

fn rejects(c: &mut Compiler, name: &str) {
    let error = c
        .compile_program(Path::new("/app/main.jai"))
        .expect_err("source violating visibility must be rejected");
    assert!(error.message.contains(name), "{}", error.render(&c.sources));
}

#[test]
fn bootstrap_alias_preserves_types_and_storage() {
    let mut c = compiler(
        &[
            (
                "/lib/prelude/module.jai",
                "Record :: struct { n: int; } state: int;",
            ),
            (
                "/app/main.jai",
                "P :: #import \"Preload\"; #assert(P.Record == Record); #assert(*P.state == *state);",
            ),
        ],
        true,
    );
    succeeds(&mut c);
    assert_eq!(
        c.modules
            .iter()
            .filter(|m| m.path.as_deref() == Some(Path::new("/lib/prelude/module.jai")))
            .count(),
        1
    );
}

#[test]
fn selected_bootstrap_cannot_be_shadowed_by_local_preload() {
    let mut c = compiler(
        &[
            ("/lib/prelude/module.jai", "Record :: struct { n: int; }"),
            (
                "/app/modules/Preload/module.jai",
                "Record :: struct { n: int; }",
            ),
            (
                "/app/main.jai",
                "P :: #import \"Preload\"; #assert(P.Record == Record);",
            ),
        ],
        true,
    );
    succeeds(&mut c);
}

#[test]
fn bootstrap_discovery_uses_only_canonical_entry() {
    let mut fs = VirtualFs::default();
    fs.insert("/lib/module.jai", b"legacy".as_slice());
    assert_eq!(jaic::find_preload(&fs, Path::new("/lib")), None);
    fs.insert("/lib/prelude/module.jai", b"".as_slice());
    assert_eq!(
        jaic::find_preload(&fs, Path::new("/lib")),
        Some("/lib/prelude/module.jai".into())
    );
    assert_eq!(
        jaic::stdlib_root_from_preload(Path::new("/lib/prelude/module.jai")),
        Some(Path::new("/lib"))
    );
}

#[test]
fn module_private_declarations_are_not_qualified_exports() {
    let mut c = compiler(
        &[
            (
                "/lib/M/module.jai",
                "#scope_module hidden :: 11; #scope_export visible :: hidden + 2;",
            ),
            (
                "/app/main.jai",
                "M :: #import \"M\"; #assert(M.visible == 13); #assert(M.hidden == 11);",
            ),
        ],
        false,
    );
    rejects(&mut c, "hidden");
}

#[test]
fn private_imports_in_sibling_files_do_not_leak() {
    let mut c = compiler(
        &[
            ("/lib/Private/module.jai", "secret :: 17;"),
            (
                "/app/piece.jai",
                "#scope_file #import \"Private\"; #assert(secret == 17);",
            ),
            (
                "/app/main.jai",
                "#load \"piece.jai\"; #assert(secret == 17);",
            ),
        ],
        false,
    );
    rejects(&mut c, "secret");
}

#[test]
fn only_import_does_not_offer_filtered_out_names_as_fallback() {
    let mut c = compiler(
        &[
            ("/lib/M/module.jai", "shown :: 7; hidden :: 9;"),
            (
                "/app/main.jai",
                "using,only(shown) M :: #import \"M\"; #assert(shown == 7); #assert(M.hidden == 9); #assert(hidden == 9);",
            ),
        ],
        false,
    );
    rejects(&mut c, "hidden");
}

#[test]
fn loaded_file_has_independent_visibility_and_private_shadowing() {
    let mut c = compiler(
        &[
            (
                "/app/piece.jai",
                "shared :: 5; #scope_file shadow :: 19; #assert(shadow == 19); #assert(local == 23); #scope_module local :: 23;",
            ),
            (
                "/app/main.jai",
                "shadow :: 13; #scope_file #load \"piece.jai\"; #assert(shared == 5); #assert(shadow == 13); #assert(local == 23);",
            ),
        ],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn imported_module_cannot_look_into_importer_scope() {
    let mut c = compiler(
        &[
            ("/lib/M/module.jai", "value :: application_only;"),
            (
                "/app/main.jai",
                "application_only :: 41; M :: #import \"M\"; #assert(M.value == 41);",
            ),
        ],
        false,
    );
    rejects(&mut c, "application_only");
}

#[test]
fn applications_cannot_import_or_load_library_internals() {
    for source in [
        "#import \"internal/Hidden\"; #assert(secret == 31);",
        "H :: #import,file \"../lib/internal/Hidden/module.jai\"; #assert(H.secret == 31);",
        "H :: #import,dir \"../lib/internal/Hidden\"; #assert(H.secret == 31);",
        "#load \"../lib/internal/Hidden/module.jai\"; #assert(secret == 31);",
        "#load \"../lib/Public/../internal/Hidden/module.jai\"; #assert(secret == 31);",
    ] {
        let mut c = compiler(
            &[
                ("/lib/prelude/module.jai", ""),
                ("/lib/internal/Hidden/module.jai", "secret :: 31;"),
                ("/app/main.jai", source),
            ],
            true,
        );
        rejects(&mut c, "internal");
    }
}

#[test]
fn library_facades_can_use_private_internals_without_exporting_import_alias() {
    let mut c = compiler(
        &[
            ("/lib/prelude/module.jai", ""),
            (
                "/lib/internal/Hidden/module.jai",
                "Record :: struct { n: int; } secret :: 31;",
            ),
            (
                "/lib/Public/module.jai",
                "#scope_file Impl :: #import \"internal/Hidden\"; #scope_export Record :: Impl.Record; answer :: Impl.secret;",
            ),
            (
                "/app/main.jai",
                "P :: #import \"Public\"; #assert(P.answer == 31); #assert(size_of(P.Record) == 8);",
            ),
        ],
        true,
    );
    succeeds(&mut c);
}

#[test]
fn cached_internal_module_does_not_bypass_origin_check() {
    let mut c = compiler(
        &[
            ("/lib/prelude/module.jai", ""),
            ("/lib/internal/Hidden/module.jai", "secret :: 31;"),
            (
                "/lib/Public/module.jai",
                "#scope_file I :: #import \"internal/Hidden\"; #scope_export answer :: I.secret;",
            ),
            (
                "/app/main.jai",
                "P :: #import \"Public\"; #assert(P.answer == 31); H :: #import \"internal/Hidden\"; #assert(H.secret == 31);",
            ),
        ],
        true,
    );
    rejects(&mut c, "internal");
}

#[test]
fn application_cannot_use_internal_source_as_main() {
    let mut c = compiler(
        &[
            ("/lib/prelude/module.jai", ""),
            ("/lib/internal/Hidden/module.jai", "value :: 31;"),
        ],
        true,
    );
    let error = c
        .compile_program(Path::new("/lib/internal/Hidden/module.jai"))
        .expect_err("internal entry is private");
    assert!(error.message.contains("internal"));
}

#[test]
fn virtual_path_normalization_preserves_consecutive_parent_components() {
    use jaic::sema::FileSystem;
    let fs = VirtualFs::default();
    assert_eq!(
        fs.canonical(Path::new("../../lib/internal/Hidden/module.jai")),
        Path::new("../../lib/internal/Hidden/module.jai")
    );
    assert_eq!(
        fs.canonical(Path::new("../a/../../b")),
        Path::new("../../b")
    );
    assert_eq!(
        fs.canonical(Path::new("/../../lib/./internal/Hidden/module.jai")),
        Path::new("/lib/internal/Hidden/module.jai")
    );
}

#[cfg(unix)]
#[test]
fn native_symlink_cannot_expose_internal_source_as_public_module() {
    use std::os::unix::fs::symlink;
    let root = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../target/cleanroom-fixtures")
        .join(format!("internal-symlink-{}", std::process::id()));
    std::fs::create_dir_all(root.join("lib/internal/Hidden")).unwrap();
    std::fs::create_dir_all(root.join("lib/prelude")).unwrap();
    std::fs::create_dir_all(root.join("app/modules")).unwrap();
    std::fs::write(root.join("lib/prelude/module.jai"), "").unwrap();
    std::fs::write(root.join("lib/internal/Hidden/module.jai"), "secret :: 31;").unwrap();
    let alias = root.join("app/modules/Exposed.jai");
    if alias.symlink_metadata().is_ok() {
        std::fs::remove_file(&alias).unwrap();
    }
    symlink(root.join("lib/internal/Hidden/module.jai"), &alias).unwrap();
    for source in [
        "H :: #import \"Exposed\"; #assert(H.secret == 31);",
        "#load \"modules/Exposed.jai\"; #assert(secret == 31);",
    ] {
        std::fs::write(root.join("app/main.jai"), source).unwrap();
        let mut options = Options::host();
        options.runtime_support = false;
        options.preload = Some(root.join("lib/prelude/module.jai"));
        options.import_paths = vec![root.join("lib")];
        let mut c = Compiler::new(options, Rc::new(jaic::sema::NativeFs));
        let error = c
            .compile_program(&root.join("app/main.jai"))
            .expect_err("canonical internal path must be private");
        assert!(
            error.message.contains("internal"),
            "{}",
            error.render(&c.sources)
        );
    }
    std::fs::remove_dir_all(root).unwrap();
}

#[test]
fn named_filtered_reexport_preserves_qualified_alias_and_filter() {
    let mut c = compiler(
        &[
            ("/lib/Impl/module.jai", "shown :: 7; hidden :: 9;"),
            (
                "/lib/Facade/module.jai",
                "using,only(shown) Impl :: #import \"Impl\";",
            ),
            (
                "/app/main.jai",
                "F :: #import \"Facade\"; #assert(F.shown == 7); #assert(F.Impl.hidden == 9); #assert(F.hidden == 9);",
            ),
        ],
        false,
    );
    rejects(&mut c, "hidden");
}

#[test]
fn named_except_reexport_hides_excluded_name() {
    let mut c = compiler(
        &[
            ("/lib/Impl/module.jai", "shown :: 7; hidden :: 9;"),
            (
                "/lib/Facade/module.jai",
                "using,except(hidden, nonexistent) Impl :: #import \"Impl\";",
            ),
            (
                "/app/main.jai",
                "F :: #import \"Facade\"; #assert(F.shown == 7); #assert(F.hidden == 9);",
            ),
        ],
        false,
    );
    rejects(&mut c, "hidden");
}

#[test]
fn facade_procedure_alias_preserves_full_overload_set_and_defaults() {
    let mut c = compiler(
        &[
            (
                "/lib/Impl/module.jai",
                "choose :: (x: int, increment: int = 4) -> int #no_context { return x + increment; } choose :: (x: bool) -> int #no_context { if x return 11; return 13; }",
            ),
            (
                "/lib/Facade/module.jai",
                "#scope_file I :: #import \"Impl\"; #scope_export choose :: I.choose;",
            ),
            (
                "/app/main.jai",
                "F :: #import \"Facade\"; #assert(F.choose(3) == 7); #assert(F.choose(true) == 11); #assert(F.choose(3, increment=8) == 11);",
            ),
        ],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn unfiltered_reexport_preserves_mutable_storage() {
    let mut c = compiler(
        &[
            (
                "/lib/Impl/module.jai",
                "state: int; Record :: struct { value: int; }",
            ),
            ("/lib/Facade/module.jai", "using I :: #import \"Impl\";"),
            (
                "/app/main.jai",
                "I :: #import \"Impl\"; F :: #import \"Facade\"; #assert(*I.state == *F.state); #assert(I.Record == F.Record);",
            ),
        ],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn module_pointer_arguments_preserve_relocation_identity() {
    let mut c = compiler(
        &[
            (
                "/lib/M/module.jai",
                "#module_parameters(P: *int); state: int; pointer :: P;",
            ),
            (
                "/app/main.jai",
                "a: int; b: int; A :: #import \"M\"(P=*a); B :: #import \"M\"(P=*b); Again :: #import \"M\"(P=*a); #assert(A.pointer == *a); #assert(B.pointer == *b); #assert(*A.state != *B.state); #assert(*A.state == *Again.state);",
            ),
        ],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn module_argument_order_and_omitted_defaults_are_distinct() {
    let mut c = compiler(
        &[
            (
                "/lib/M/module.jai",
                "#module_parameters(A: int = 2, B: int = 3); state: int;",
            ),
            (
                "/app/main.jai",
                "Default :: #import \"M\"; Explicit :: #import \"M\"(A=2, B=3); Reordered :: #import \"M\"(B=3, A=2); Again :: #import \"M\"(A=2, B=3); #assert(*Default.state != *Explicit.state); #assert(*Reordered.state != *Explicit.state); #assert(*Again.state == *Explicit.state);",
            ),
        ],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn computed_import_filters_preserve_filter_kind() {
    for (filter, visible, hidden) in [
        ("only(.[\"a\", \"absent\"])", "a", "b"),
        ("except(.[\"a\", \"absent\"])", "b", "a"),
        ("only names", "a", "b"),
        ("except names", "b", "a"),
    ] {
        let source = format!(
            "names :: .[\"a\"]; using,{filter} M :: #import \"M\"; #assert({visible} > 0); #assert({hidden} > 0);"
        );
        let mut c = compiler(
            &[
                ("/lib/M/module.jai", "a :: 7; b :: 9;"),
                ("/app/main.jai", &source),
            ],
            false,
        );
        rejects(&mut c, hidden);
    }
}

#[test]
fn aggregate_mapper_changes_names_and_preserves_lvalues() {
    let mut c = compiler(
        &[(
            "/app/main.jai",
            "rename :: (names: [] string) #no_context { for *names { if it.* == \"x\" it.* = \"axis\"; if it.* == \"hidden\" it.* = \"\"; } } Point :: struct { x: int; y: int; hidden: int; } check :: () -> bool #no_context { point := Point.{1, 2, 3}; { using,map(rename) point; axis = 9; y = 11; } return point.x == 9 && point.y == 11 && point.hidden == 3; } #assert(check());",
        )],
        false,
    );
    succeeds(&mut c);
}

#[test]
fn aggregate_only_filter_hides_other_members() {
    let mut c = compiler(
        &[(
            "/app/main.jai",
            "Point :: struct { x: int; y: int; } check :: () #no_context { point: Point; using,only(x) point; x = 7; y = 9; } #run check();",
        )],
        false,
    );
    rejects(&mut c, "y");
}

#[test]
fn aggregate_using_declaration_keeps_filter() {
    let mut c = compiler(
        &[(
            "/app/main.jai",
            "Point :: struct { x: int; y: int; } check :: () #no_context { using,only(x) point: Point; x = 7; y = 9; } #run check();",
        )],
        false,
    );
    rejects(&mut c, "y");
}

#[test]
fn file_scope_aggregate_using_keeps_computed_filter() {
    let mut c = compiler(
        &[(
            "/app/main.jai",
            "Point :: struct { x: int; y: int; } point: Point; using,except(.[\"y\"]) point; #assert(*x == *point.x); #assert(*y == *point.y);",
        )],
        false,
    );
    rejects(&mut c, "y");
}

#[test]
fn mapper_omission_hides_original_short_name() {
    let mut c = compiler(
        &[(
            "/app/main.jai",
            "omit :: (names: [] string) #no_context { for *names if it.* == \"y\" it.* = \"\"; } Point :: struct { x: int; y: int; } check :: () #no_context { point: Point; using,map(omit) point; x = 7; y = 9; } #run check();",
        )],
        false,
    );
    rejects(&mut c, "y");
}

#[test]
fn invalid_computed_filter_is_an_error() {
    let mut c = compiler(
        &[
            ("/lib/M/module.jai", "a :: 7;"),
            (
                "/app/main.jai",
                "using,only(.[7, 9]) M :: #import \"M\"; #assert(a == 7);",
            ),
        ],
        false,
    );
    rejects(&mut c, "strings");
}
