//! Allocator-only source receipts authorize virtual storage without host I/O.
use jai_driver::CompilationUnit;
use jai_modules::{BootstrapOptions, GraphOptions};
use jai_types::{Architecture, BuildTarget, ByteOrder, LayoutPolicy, OperatingSystem};
use std::{fs, path::PathBuf};

struct Fixture(PathBuf);
impl Fixture {
    fn new(allocator: &str, main: &str) -> Self {
        let root = std::env::temp_dir().join(format!(
            "jai-heap-source-{}-{:?}",
            std::process::id(),
            jai_vm::host_effects::HostRequestKey::allocate()
        ));
        fs::create_dir_all(root.join("modules/Default_Allocator")).unwrap();
        fs::write(root.join("modules/Default_Allocator/module.jai"), allocator).unwrap();
        fs::write(root.join("main.jai"), main).unwrap();
        Self(root)
    }
    fn modules(&self) -> PathBuf {
        self.0.join("modules")
    }
    fn unit(&self) -> CompilationUnit {
        CompilationUnit::load_with_bootstrap(
            &self.0.join("main.jai"),
            GraphOptions {
                import_dirs: vec![self.modules()],
            },
            BootstrapOptions::disabled(),
            Some(target()),
        )
        .unwrap()
    }
}
impl Drop for Fixture {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}
fn target() -> BuildTarget {
    BuildTarget {
        operating_system: OperatingSystem::MacOS,
        architecture: Architecture::Arm64,
        layout: LayoutPolicy::lp64(),
        byte_order: ByteOrder::Little,
    }
}
const ALLOCATOR: &str = r#"
c_malloc::(size:u64)->*void #foreign crt "malloc";
c_realloc::(memory:*void,size:u64)->*void #foreign crt "realloc";
c_free::(memory:*void) #foreign crt "free";
crt::#system_library "libc";
"#;
const MAIN: &str = r#"
#import "Default_Allocator";
measure::()->s64 #no_context {
    memory:=cast(*u8) c_malloc(4);
    memory[0]=40;
    memory[1]=2;
    replacement:=cast(*u8) c_realloc(memory,8);
    result:=cast(s64) replacement[0]+cast(s64) replacement[1];
    c_free(replacement);
    return result;
}
measured::#run measure();
main::()->s64 #no_context {return measured;}
"#;
fn options(unit: &CompilationUnit, roots: &[PathBuf]) -> jai_sema::ResolveOptions {
    jai_sema::ResolveOptions {
        target: Some(target()),
        file_abi: jai_sema::FileAbiBindingContext::from_graph(unit.graph(), roots, target()),
        ..Default::default()
    }
}
fn resolve(
    unit: &CompilationUnit,
    options: &jai_sema::ResolveOptions,
) -> Result<jai_sema::Program, jai_source::LocatedDiagnostic> {
    jai_sema::resolve_graph_with_options(unit.graph(), options, &mut jai_vm::NoEffects)
}
fn answer(program: &jai_sema::Program) -> i128 {
    match jai_vm::execute(program, Default::default()).outcome {
        jai_vm::Outcome::Complete(values) => values[0].integer().unwrap().value(),
        outcome => panic!("{outcome:?}"),
    }
}
#[test]
fn allocator_only_checked_source_allocates_resizes_preserves_and_frees_in_run() {
    let fixture = Fixture::new(ALLOCATOR, MAIN);
    let unit = fixture.unit();
    assert!(!unit.graph().modules().iter().any(|module| {
        unit.graph()
            .sources()
            .get(unit.graph().file(module.entry()).unwrap().source())
            .unwrap()
            .path()
            .ends_with("POSIX/module.jai")
    }));
    let options = options(&unit, &[fixture.modules()]);
    assert!(
        options
            .file_abi
            .as_ref()
            .unwrap()
            .includes_default_allocator()
    );
    assert_eq!(answer(&resolve(&unit, &options).unwrap()), 42);
}
#[test]
fn allocator_names_without_selected_configured_role_grant_no_authority() {
    let fixture = Fixture::new(ALLOCATOR, MAIN);
    let unit = fixture.unit();
    let options = options(&unit, &[]);
    assert!(options.file_abi.is_none());
    let error = resolve(&unit, &options).unwrap_err();
    assert!(error.to_string().contains("foreign procedure"), "{error}");
}
#[test]
fn allocator_receipt_is_bound_to_its_original_graph_unit_and_target() {
    let fixture = Fixture::new(ALLOCATOR, MAIN);
    let unit = fixture.unit();
    let options = options(&unit, &[fixture.modules()]);
    let reloaded = fixture.unit();
    let error = resolve(&reloaded, &options).unwrap_err();
    assert!(error.to_string().contains("receipt differs"), "{error}");
    let mut changed = options.clone();
    changed.target.as_mut().unwrap().architecture = Architecture::X86_64;
    assert!(
        jai_sema::FileAbiBindingContext::allocator_from_graph(
            unit.graph(),
            &[fixture.modules()],
            changed.target.clone().unwrap(),
        )
        .is_none()
    );
    let error = resolve(&unit, &changed).unwrap_err();
    assert!(error.to_string().contains("receipt differs"), "{error}");
}
#[test]
fn selected_allocator_still_requires_exact_foreign_library_symbol_and_c_abi() {
    for malformed in [
        ALLOCATOR.replace("size:u64", "size:u32"),
        ALLOCATOR.replace("\"malloc\"", "\"not_malloc\""),
        ALLOCATOR.replace("#system_library \"libc\"", "#system_library \"libm\""),
    ] {
        let fixture = Fixture::new(&malformed, MAIN);
        let unit = fixture.unit();
        let options = options(&unit, &[fixture.modules()]);
        let error = resolve(&unit, &options).unwrap_err();
        assert!(error.to_string().contains("heap ABI binding"), "{error}");
    }
}
#[test]
fn same_symbol_outside_selected_allocator_source_is_not_an_authorized_procedure() {
    let main = r#"
#import "Default_Allocator";
other_malloc::(size:u64)->*void #foreign other_crt "malloc";
other_crt::#system_library "libc";
measure::()->s64 #no_context {
    pointer:=other_malloc(4);
    return 42;
}
measured::#run measure();
main::()->s64 #no_context {return measured;}
"#;
    let fixture = Fixture::new(ALLOCATOR, main);
    let unit = fixture.unit();
    let options = options(&unit, &[fixture.modules()]);
    let error = resolve(&unit, &options).unwrap_err();
    assert!(error.to_string().contains("foreign procedure"), "{error}");
}
#[test]
fn independently_selected_allocator_instances_keep_their_own_foreign_identities() {
    let allocator = format!("#module_parameters(Instance:s64=1);{}", ALLOCATOR);
    let main = r#"
A::#import "Default_Allocator"(Instance=1);
B::#import "Default_Allocator"(Instance=2);
measure::()->s64 #no_context {
    first:=cast(*u8) A.c_malloc(4);
    second:=cast(*u8) B.c_malloc(4);
    first[0]=20;
    second[0]=22;
    result:=cast(s64) first[0]+cast(s64) second[0];
    A.c_free(first);
    B.c_free(second);
    return result;
}
measured::#run measure();
main::()->s64 #no_context {return measured;}
"#;
    let fixture = Fixture::new(&allocator, main);
    let unit = fixture.unit();
    let program = unit.resolve_with_target(target()).unwrap();
    let identities = program
        .library()
        .prototypes()
        .iter()
        .map(|prototype| prototype.id)
        .collect::<std::collections::HashSet<_>>();
    assert_eq!(identities.len(), 6);
    assert_eq!(answer(&program), 42);
}
