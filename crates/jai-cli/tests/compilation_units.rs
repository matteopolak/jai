//! End-to-end native compilation of our own source fixtures.
use std::{fs, process::Command};
#[test]
fn native_loaded_procedure() {
    let root = std::env::temp_dir().join(format!("jai-native-load-{}", std::process::id()));
    fs::create_dir_all(&root).unwrap();
    fs::write(
        root.join("main.jai"),
        "#load \"answer.jai\"; main :: () -> int { return answer(); }",
    )
    .unwrap();
    fs::write(
        root.join("answer.jai"),
        "answer :: () -> int { return 37; }",
    )
    .unwrap();
    let output = root.join("program");
    let result = Command::new(env!("CARGO_BIN_EXE_jai-rs"))
        .arg("build")
        .arg(root.join("main.jai"))
        .arg(&output)
        .output()
        .unwrap();
    assert!(
        result.status.success(),
        "{}",
        String::from_utf8_lossy(&result.stderr)
    );
    assert_eq!(Command::new(&output).status().unwrap().code(), Some(37));
    fs::remove_dir_all(root).unwrap();
}
