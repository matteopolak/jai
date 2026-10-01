//! Actual execution of newly generated code; never uses supplied native code.
use std::{
    fs,
    io::Write,
    path::PathBuf,
    process::{Command, Stdio},
    sync::atomic::{AtomicU64, Ordering},
    time::{Duration, Instant, SystemTime, UNIX_EPOCH},
};
struct Scratch(PathBuf);
static NEXT_SCRATCH: AtomicU64 = AtomicU64::new(0);
impl Drop for Scratch {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}
fn execute(source: &str) -> i32 {
    let module = jai_syntax::parse(source).unwrap();
    let program = jai_sema::resolve(&module).unwrap();
    let ir = jai_codegen::emit(&program).unwrap();
    let path = std::env::temp_dir().join(format!(
        "jai-rust-test-{}-{}-{}",
        std::process::id(),
        NEXT_SCRATCH.fetch_add(1, Ordering::Relaxed),
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_nanos()
    ));
    fs::create_dir(&path).unwrap();
    let scratch = Scratch(path);
    let executable = scratch.0.join("program");
    let mut compiler = Command::new("clang")
        .args(["-x", "ir", "-", "-o"])
        .arg(&executable)
        .stdin(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("native tests require independently installed clang");
    compiler
        .stdin
        .take()
        .unwrap()
        .write_all(ir.as_bytes())
        .unwrap();
    let result = compiler.wait_with_output().unwrap();
    assert!(
        result.status.success(),
        "LLVM failed: {}\n{ir}",
        String::from_utf8_lossy(&result.stderr)
    );
    let mut process = Command::new(&executable).spawn().unwrap();
    let deadline = Instant::now() + Duration::from_secs(5);
    loop {
        if let Some(status) = process.try_wait().unwrap() {
            return status.code().expect("test program terminated by a signal");
        }
        if Instant::now() >= deadline {
            process.kill().unwrap();
            process.wait().unwrap();
            panic!("generated program exceeded 5 seconds; possible control-flow regression");
        }
        std::thread::sleep(Duration::from_millis(5));
    }
}
#[test]
fn recursive_calls_and_early_return() {
    assert_eq!(
        execute(
            "fact :: (n:int)->int { if n <= 1 return 1; return n*fact(n-1); } main :: ()->int { return fact(4); }"
        ),
        24
    );
}
#[test]
fn mutable_loop_and_nested_scope() {
    assert_eq!(
        execute(
            "main :: ()->int { sum := 0; n := 0; while n < 7 { { n := 42; sum = sum + n; } n = n + 1; } return sum / 7; }"
        ),
        42
    );
}
#[test]
fn both_branches_terminate() {
    assert_eq!(
        execute(
            "pick :: (x:int)->int { if x > 0 return 17; else return 29; } main :: ()->int { return pick(-2); }"
        ),
        29
    );
}
#[test]
fn default_initialization_and_bitwise_values() {
    assert_eq!(
        execute("main :: ()->int { n: int; n = (0xff & 0b111111) ^ 0x15; return n; }"),
        42
    );
}

#[test]
fn boolean_arguments_returns_and_default() {
    assert_eq!(
        execute(
            "flip :: (b:bool)->bool { return !b; } main :: ()->int { b: bool; b = flip(b); if b == true return 42; else return 1; }"
        ),
        42
    );
}

#[test]
fn nested_short_circuit_skips_nonterminating_calls() {
    assert_eq!(
        execute(
            "forever :: ()->bool { while true {} return true; } main :: ()->int { if (false && forever()) || (true || forever()) return 42; else return 1; }"
        ),
        42
    );
}

#[test]
fn void_call_and_void_entry() {
    assert_eq!(
        execute("f :: (b:bool) { if b return; } main :: () { f(true); }"),
        0
    );
}

#[test]
fn integer_truthiness_is_explicit_in_lowering() {
    assert_eq!(
        execute("main :: ()->int { n := -7; if n && !0 && !!n return 42; else return 1; }"),
        42
    );
}

#[test]
fn explicit_scalar_casts_and_compound_assignment() {
    assert_eq!(
        execute(
            "main :: ()->int { n := cast(int) cast(bool) -9; n *= 21; n <<= 1; n |= 3; n ^= 3; return n; }"
        ),
        40
    );
}

#[test]
fn boolean_compound_assignments_short_circuit() {
    assert_eq!(
        execute(
            "forever :: ()->bool { while true {} return true; } main :: ()->int { b := false; b &&= forever(); b ||= true; return cast(int) b * 42; }"
        ),
        42
    );
}

#[test]
fn hexadecimal_subtraction_without_whitespace() {
    assert_eq!(execute("main :: ()->int { return 0xFE-212; }"), 42);
}
