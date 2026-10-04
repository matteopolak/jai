//! `jaic` command line: `jaic <run|check|build> <file.jai> [-I dir]... [-o out]`.
use jaic::sema::{Compiler, NativeFs, Options};
use jaic_llvm::OptLevel;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

fn stdlib_dir() -> PathBuf {
    if let Some(dir) = std::env::var_os("JAIC_STDLIB") {
        return PathBuf::from(dir);
    }
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../stdlib")
}

fn usage() -> ExitCode {
    eprintln!("usage: jaic <run|check> <file.jai> [-I dir]...");
    eprintln!(
        "       jaic build <file.jai> [-I dir]... [-o output] [-O0|-O1|-O2|-O3] [--emit-ir file.ll]"
    );
    ExitCode::from(2)
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Command {
    Check,
    Run,
    Build,
}

/// Parsed command line.
struct Cli {
    command: Command,
    file: String,
    imports: Vec<PathBuf>,
    output: Option<PathBuf>,
    opt_level: OptLevel,
    emit_ir: Option<PathBuf>,
}

fn parse(args: &[String]) -> Option<Cli> {
    let command = match args.first()?.as_str() {
        "check" => Command::Check,
        "run" => Command::Run,
        "build" => Command::Build,
        _ => return None,
    };
    let mut cli = Cli {
        command,
        file: args.get(1)?.clone(),
        imports: Vec::new(),
        output: None,
        opt_level: OptLevel::O0,
        emit_ir: None,
    };
    let mut rest = args[2..].iter();
    while let Some(a) = rest.next() {
        match a.as_str() {
            "-I" => cli.imports.extend(rest.next().map(PathBuf::from)),
            "-o" if command == Command::Build => cli.output = Some(PathBuf::from(rest.next()?)),
            "--emit-ir" if command == Command::Build => {
                cli.emit_ir = Some(PathBuf::from(rest.next()?))
            }
            "-O0" if command == Command::Build => cli.opt_level = OptLevel::O0,
            "-O1" if command == Command::Build => cli.opt_level = OptLevel::O1,
            "-O2" if command == Command::Build => cli.opt_level = OptLevel::O2,
            "-O3" if command == Command::Build => cli.opt_level = OptLevel::O3,
            _ => return None,
        }
    }
    Some(cli)
}

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let Some(cli) = parse(&args) else {
        return usage();
    };
    // Deeply recursive programs and checking need a large stack.
    let worker = std::thread::Builder::new()
        .stack_size(1 << 30)
        .spawn(move || run(cli));
    match worker.map(|h| h.join()) {
        Ok(Ok(code)) => code,
        _ => ExitCode::from(101),
    }
}

fn run(cli: Cli) -> ExitCode {
    let stdlib = stdlib_dir();
    let mut options = Options::host();
    options.import_paths = cli.imports.clone();
    options.import_paths.push(stdlib.clone());
    options.preload = Some(stdlib.join("Preload.jai"));
    let mut compiler = Compiler::new(options, Box::new(NativeFs));
    let path = std::fs::canonicalize(&cli.file).unwrap_or_else(|_| PathBuf::from(&cli.file));
    if let Err(d) = compiler.compile_program(&path) {
        eprintln!("{}", compiler.render(&d));
        return ExitCode::from(1);
    }
    match cli.command {
        Command::Check => ExitCode::SUCCESS,
        Command::Run => match compiler.run_program() {
            Ok(code) => ExitCode::from(code as u8),
            Err(d) => {
                eprintln!("{}", compiler.render(&d));
                ExitCode::from(1)
            }
        },
        Command::Build => match build(&compiler, &cli, &path) {
            Ok(()) => ExitCode::SUCCESS,
            Err(message) => {
                eprintln!("error: {message}");
                ExitCode::from(1)
            }
        },
    }
}

/// Emit an object file for the compiled program and link it.
fn build(compiler: &Compiler, cli: &Cli, source: &Path) -> Result<(), String> {
    if compiler.exported_func("main").is_none() {
        return Err("no exported 'main' (is Runtime_Support loaded?)".into());
    }
    let output = cli
        .output
        .clone()
        .unwrap_or_else(|| PathBuf::from(source.file_stem().unwrap_or_default()));
    let object = {
        let mut name = output.clone().into_os_string();
        name.push(".o");
        PathBuf::from(name)
    };
    let options = jaic_llvm::Options {
        opt_level: cli.opt_level,
        target: None,
        emit_ir: cli.emit_ir.clone(),
    };
    jaic_llvm::emit_object(&compiler.program, &options, &object)?;
    let libraries = jaic_llvm::used_libraries(&compiler.program);
    let linked = jaic_llvm::link(std::slice::from_ref(&object), &libraries, &output);
    let _ = std::fs::remove_file(&object);
    linked
}
