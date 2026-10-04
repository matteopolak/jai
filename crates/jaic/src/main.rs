//! `jaic` command line: `jaic run <file.jai>` / `jaic check <file.jai>`.
use jaic::sema::{Compiler, NativeFs, Options};
use std::path::PathBuf;
use std::process::ExitCode;

fn stdlib_dir() -> PathBuf {
    if let Some(dir) = std::env::var_os("JAIC_STDLIB") {
        return PathBuf::from(dir);
    }
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../stdlib")
}

fn usage() -> ExitCode {
    eprintln!("usage: jaic <run|check> <file.jai> [-I dir]...");
    ExitCode::from(2)
}

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let (Some(command), Some(file)) = (args.first().cloned(), args.get(1).cloned()) else {
        return usage();
    };
    let mut imports = Vec::new();
    let mut rest = args[2..].iter();
    while let Some(a) = rest.next() {
        match a.as_str() {
            "-I" => imports.extend(rest.next().map(PathBuf::from)),
            _ => return usage(),
        }
    }
    // Deeply recursive programs and checking need a large stack.
    let worker = std::thread::Builder::new()
        .stack_size(1 << 30)
        .spawn(move || run(&command, &file, imports));
    match worker.map(|h| h.join()) {
        Ok(Ok(code)) => code,
        _ => ExitCode::from(101),
    }
}

fn run(command: &str, file: &str, imports: Vec<PathBuf>) -> ExitCode {
    let stdlib = stdlib_dir();
    let mut options = Options::host();
    options.import_paths = imports;
    options.import_paths.push(stdlib.clone());
    options.preload = Some(stdlib.join("Preload.jai"));
    let mut compiler = Compiler::new(options, Box::new(NativeFs));
    let path = std::fs::canonicalize(file).unwrap_or_else(|_| PathBuf::from(file));
    if let Err(d) = compiler.compile_program(&path) {
        eprintln!("{}", compiler.render(&d));
        return ExitCode::from(1);
    }
    match command {
        "check" => ExitCode::SUCCESS,
        "run" => match compiler.run_program() {
            Ok(code) => ExitCode::from(code as u8),
            Err(d) => {
                eprintln!("{}", compiler.render(&d));
                ExitCode::from(1)
            }
        },
        _ => usage(),
    }
}
