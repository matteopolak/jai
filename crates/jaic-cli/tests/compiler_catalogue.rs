//! Original public compiler capability diagnostics retained during fixture migration.
use std::{path::PathBuf, process::Command};

#[test]
fn unavailable_debugger_is_a_required_diagnostic() {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let output = Command::new(env!("CARGO_BIN_EXE_jaic"))
        .env("JAIC_STDLIB", root.join("stdlib"))
        .arg(root.join("tests/compiler-semantics/compiler-debugger-unavailable.jai"))
        .arg("-check")
        .output()
        .unwrap();
    assert!(!output.status.success());
    assert!(
        String::from_utf8_lossy(&output.stderr)
            .contains("developer_debug requires compiler debugger support")
    );
}
