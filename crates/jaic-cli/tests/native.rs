//! Native backend acceptance: every corpus case with a runtime expectation
//! that passes under `jaic run` must also pass when built with `jaic build`
//! and executed as a native program.
use std::path::{Path, PathBuf};
use std::process::Command;

const JAIC: &str = env!("CARGO_BIN_EXE_jaic");

fn repo_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")
}

struct Case {
    id: String,
    source: PathBuf,
    exit_code: i32,
    stdout: String,
}

fn corpus_cases() -> Vec<Case> {
    let corpus = repo_root().join("tests/corpus");
    let manifest: serde_json::Value =
        serde_json::from_slice(&std::fs::read(corpus.join("manifest.json")).unwrap()).unwrap();
    manifest["cases"]
        .as_array()
        .unwrap()
        .iter()
        .filter_map(|c| {
            let runtime = c.get("runtime")?;
            Some(Case {
                id: c["id"].as_str()?.to_string(),
                source: corpus.join(c["source"].as_str()?),
                exit_code: runtime["exit_code"].as_i64().unwrap_or(0) as i32,
                stdout: runtime["stdout"].as_str().unwrap_or("").to_string(),
            })
        })
        .collect()
}

fn matches(case: &Case, output: &std::process::Output) -> bool {
    output.status.code() == Some(case.exit_code)
        && String::from_utf8_lossy(&output.stdout) == case.stdout
}

/// Build `source` natively into `dir` and run it.
fn build_and_run(source: &Path, dir: &Path, name: &str) -> Result<std::process::Output, String> {
    let exe = dir.join(name);
    let build = Command::new(JAIC)
        .arg("build")
        .arg(source)
        .arg("-o")
        .arg(&exe)
        .current_dir(source.parent().unwrap())
        .output()
        .map_err(|e| e.to_string())?;
    if !build.status.success() {
        return Err(format!(
            "build failed: {}",
            String::from_utf8_lossy(&build.stderr)
        ));
    }
    Command::new(&exe).output().map_err(|e| e.to_string())
}

#[test]
fn corpus_runs_natively_like_the_interpreter() {
    let dir = Path::new(env!("CARGO_TARGET_TMPDIR")).join("native-corpus");
    std::fs::create_dir_all(&dir).unwrap();
    let (mut checked, mut failures) = (0, Vec::new());
    for case in corpus_cases() {
        // Only cases the interpreter already passes are meaningful for the backend.
        let interp = Command::new(JAIC)
            .arg("run")
            .arg(&case.source)
            .current_dir(case.source.parent().unwrap())
            .output()
            .unwrap();
        if !matches(&case, &interp) {
            continue;
        }
        checked += 1;
        match build_and_run(&case.source, &dir, &case.id) {
            Ok(native) if matches(&case, &native) => {}
            Ok(native) => failures.push(format!(
                "{}: native exit {:?}, stdout {:?} (expected exit {}, stdout {:?})",
                case.id,
                native.status.code(),
                String::from_utf8_lossy(&native.stdout),
                case.exit_code,
                case.stdout
            )),
            Err(e) => failures.push(format!("{}: {e}", case.id)),
        }
    }
    assert!(checked > 0, "no corpus case passes under the interpreter");
    assert!(
        failures.is_empty(),
        "{} of {checked} cases differ natively:\n{}",
        failures.len(),
        failures.join("\n")
    );
}

#[test]
fn hello_world_builds_and_prints() {
    let dir = Path::new(env!("CARGO_TARGET_TMPDIR")).join("native-hello");
    std::fs::create_dir_all(&dir).unwrap();
    let source = dir.join("hello.jai");
    std::fs::write(
        &source,
        "#import \"Basic\";\nmain :: () { print(\"hello %!\\n\", 42); }\n",
    )
    .unwrap();
    let output = build_and_run(&source, &dir, "hello").unwrap();
    assert_eq!(String::from_utf8_lossy(&output.stdout), "hello 42!\n");
    assert_eq!(output.status.code(), Some(0));
}

/// C structs by value across the C ABI: foreign calls from the interpreter and from native code, and
/// native `#c_call` definitions called back from C. Skipped when no C compiler is installed.
#[test]
fn c_structs_by_value() {
    let fixture = repo_root().join("tests/native/c-structs-by-value");
    let dir = Path::new(env!("CARGO_TARGET_TMPDIR")).join("native-c-structs");
    std::fs::create_dir_all(&dir).unwrap();
    for name in [
        "structs.c",
        "types.jai",
        "foreign_calls.jai",
        "callbacks.jai",
    ] {
        std::fs::copy(fixture.join(name), dir.join(name)).unwrap();
    }
    let lib = if cfg!(target_os = "macos") {
        "libstructs.dylib"
    } else {
        "libstructs.so"
    };
    let mut cc = Command::new("cc");
    cc.args(["-shared", "-fPIC", "-o", lib, "structs.c"]);
    if cfg!(target_os = "macos") {
        // Found through the executable's rpath rather than relative to the working directory.
        cc.arg("-Wl,-install_name,@rpath/libstructs.dylib");
    }
    let Ok(cc) = cc.current_dir(&dir).output() else {
        eprintln!("skipping: no C compiler");
        return;
    };
    assert!(
        cc.status.success(),
        "{}",
        String::from_utf8_lossy(&cc.stderr)
    );
    let calls = "{11, 22} {2, 4, 6} {5, 6, 7, 8} 10 {-7, 9} {99, 2.5} {11, 22, 33}\n";
    let interp = Command::new(JAIC)
        .args(["run", "foreign_calls.jai"])
        .current_dir(&dir)
        .output()
        .unwrap();
    assert_eq!(
        String::from_utf8_lossy(&interp.stdout),
        calls,
        "{}",
        String::from_utf8_lossy(&interp.stderr)
    );
    let run_native = |name: &str| {
        let output = build_and_run(&dir.join(format!("{name}.jai")), &dir, name).unwrap();
        String::from_utf8_lossy(&output.stdout).into_owned()
    };
    assert_eq!(run_native("foreign_calls"), calls);
    assert_eq!(
        run_native("callbacks"),
        "{111, 47} {10, 20, 30, 40} {8, 4}\n"
    );
}

/// C variadic foreign calls in a native build (Apple arm64 passes variadic arguments on the stack).
#[test]
fn c_variadic_calls() {
    let dir = Path::new(env!("CARGO_TARGET_TMPDIR")).join("native-varargs");
    std::fs::create_dir_all(&dir).unwrap();
    let source = repo_root().join("tests/stdlib/c-variadic-foreign-calls.jai");
    let output = build_and_run(&source, &dir, "varargs").unwrap();
    assert_eq!(
        String::from_utf8_lossy(&output.stdout),
        "ok\n",
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
}
