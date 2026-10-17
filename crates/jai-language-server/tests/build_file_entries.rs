//! A `jai.toml` that lists the project's `build.jai` among `build_files` must not change how
//! `src/main.jai` (the program that metaprogram builds) is checked and answered.
use jai_language_server::{DiagnosticCode, DocumentUri, Environment, Limits, Position, Session};
use std::path::{Path, PathBuf};

fn environment() -> Environment {
    let stdlib = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../stdlib");
    Environment {
        fs: std::rc::Rc::new(jaic::sema::NativeFs),
        options: Box::new(move |_| {
            let mut options = jaic::sema::Options::host();
            options.import_paths = vec![stdlib.clone()];
            options.preload = Some(stdlib.join(jaic::PRELOAD_ENTRY));
            options
        }),
    }
}

fn project(name: &str, files: &[(&str, &str)]) -> PathBuf {
    let dir = std::env::temp_dir().join(format!("jailsp-buildfile-{name}-{}", std::process::id()));
    let _ = std::fs::remove_dir_all(&dir);
    for (path, text) in files {
        let path = dir.join(path);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(path, text).unwrap();
    }
    dir.canonicalize().unwrap()
}

fn open(folder: &Path, file: &str) -> (Session, DocumentUri, String) {
    let mut s = Session::with_environment(Limits::default(), environment());
    s.set_workspace_folders(vec![folder.to_path_buf()]);
    let path = folder.join(file);
    let uri = DocumentUri::parse(&format!("file://{}", path.display())).unwrap();
    let text = std::fs::read_to_string(&path).unwrap();
    s.open(uri.clone(), 1, text.clone()).unwrap();
    (s, uri, text)
}

fn position(text: &str, marker: &str) -> Position {
    let byte = text.find(marker).unwrap();
    let prefix = &text[..byte];
    Position {
        line: prefix.matches('\n').count() as u32,
        character: prefix.rsplit('\n').next().unwrap().len() as u32,
    }
}

const BUILD: &str = "#import \"Basic\";\n#import \"Compiler\";\n#run build();\nbuild :: () {\n    \
    set_build_options_dc(.{do_output = false});\n    w := compiler_create_workspace(\"app\");\n    \
    options := get_build_options(w);\n    options.output_type = .NO_OUTPUT;\n    \
    set_build_options(options, w);\n    add_build_file(\"src/main.jai\", w);\n}\n";

const MAIN: &str = "#import \"Basic\";\nhelper :: (x: int) -> int { return x * 2; }\n\
    main :: () {\n    answer := helper(21);\n    print(\"%\\n\", answer);\n}\n";

fn check(name: &str, toml: Option<&str>) {
    let mut files = vec![("build.jai", BUILD), ("src/main.jai", MAIN)];
    if let Some(toml) = toml {
        files.push(("jai.toml", toml));
    }
    let dir = project(name, &files);
    let (s, uri, text) = open(&dir, "src/main.jai");
    let errors: Vec<_> = s
        .diagnostics(&uri)
        .unwrap()
        .into_iter()
        .filter(|d| d.code == DiagnosticCode::Check)
        .map(|d| d.message)
        .collect();
    assert_eq!(errors, Vec::<String>::new(), "{name}");
    let hover = s
        .hover(&uri, position(&text, "answer :="))
        .unwrap()
        .unwrap_or_else(|| panic!("{name}: no hover"))
        .contents
        .value;
    assert!(hover.contains("answer: s64"), "{name}: {hover}");
    let def = s
        .definition(&uri, position(&text, "helper(21)"))
        .unwrap_or_else(|e| panic!("{name}: {e:?}"));
    assert!(format!("{def:?}").contains("main.jai"), "{name}: {def:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn without_a_toml() {
    check("none", None);
}

#[test]
fn toml_without_the_build_file() {
    check("main-only", Some("build_files = [\"src/main.jai\"]\n"));
}

#[test]
fn toml_with_only_the_build_file() {
    check("build-only", Some("build_files = [\"build.jai\"]\n"));
}

#[test]
fn toml_with_the_build_file_and_main() {
    check(
        "both",
        Some("build_files = [\"build.jai\", \"src/main.jai\"]\n"),
    );
}

#[test]
fn toml_with_main_then_the_build_file() {
    check(
        "both-reversed",
        Some("build_files = [\"src/main.jai\", \"build.jai\"]\n"),
    );
}
