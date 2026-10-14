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
