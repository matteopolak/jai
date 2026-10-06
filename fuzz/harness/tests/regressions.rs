//! Replays every saved crash input in `fuzz/regressions/<target>/` through the same harness
//! function its libFuzzer target calls, so fixed crashes stay fixed without a sanitizer build.
use std::path::Path;

fn replay(target: &str, run: fn(&[u8])) {
    let dir = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../regressions")
        .join(target);
    let Ok(entries) = std::fs::read_dir(&dir) else {
        return;
    };
    let mut paths: Vec<_> = entries.filter_map(Result::ok).map(|e| e.path()).collect();
    paths.sort();
    for path in paths {
        if path
            .file_name()
            .is_some_and(|n| n.to_string_lossy().starts_with('.'))
        {
            continue;
        }
        let data = std::fs::read(&path).expect("read regression input");
        eprintln!("replaying {}", path.display());
        run(&data);
    }
}

#[test]
fn lexer() {
    replay("lexer", jai_fuzz_harness::lexer);
}

#[test]
fn parser() {
    replay("parser", jai_fuzz_harness::parser);
}

#[test]
fn check() {
    replay("check", jai_fuzz_harness::check);
}

#[test]
fn interp() {
    replay("interp", jai_fuzz_harness::interp);
}

#[test]
fn generated() {
    replay("generated", jai_fuzz_harness::generated);
}

#[test]
fn lsp() {
    replay("lsp", jai_fuzz_harness::lsp);
}

#[test]
fn lsp_json() {
    replay("lsp_json", jai_fuzz_harness::lsp_json);
}
