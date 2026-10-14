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
