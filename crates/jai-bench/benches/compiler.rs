use divan::{Bencher, counter::BytesCount};
use std::{fs, path::Path};

#[global_allocator]
static ALLOC: divan::AllocProfiler = divan::AllocProfiler::system();

fn main() {
    divan::main();
}
fn generated(procedures: usize) -> String {
    let mut source = String::new();
    for n in 0..procedures {
        use std::fmt::Write;
        writeln!(source, "f{n} :: (n:int, enabled:bool)->int {{ sum := 0; while n > 0 && enabled {{ sum = sum + n; n = n - 1; }} return sum; }}").unwrap();
    }
    source.push_str("main :: ()->int { return f0(9, true); }");
    source
}
#[divan::bench(args = [4, 64, 1024])]
fn lex(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| jai_lexer::lex(divan::black_box(&source)).unwrap());
}
#[divan::bench(args = [4, 64, 1024])]
fn parse(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| jai_syntax::parse(divan::black_box(&source)).unwrap());
}
#[divan::bench(args = [4, 64, 1024])]
fn resolve(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    let module = jai_syntax::parse(&source).unwrap();
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| jai_sema::resolve(divan::black_box(&module)).unwrap());
}
#[divan::bench(args = [4, 64, 1024])]
fn lower_llvm(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    let module = jai_syntax::parse(&source).unwrap();
    let program = jai_sema::resolve(&module).unwrap();
    let context = jai_codegen::Context::create();
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| jai_codegen::lower(&context, divan::black_box(&program)).unwrap());
}
#[divan::bench(args = [4, 64, 1024])]
fn emit_llvm(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    let module = jai_syntax::parse(&source).unwrap();
    let program = jai_sema::resolve(&module).unwrap();
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| jai_codegen::emit(divan::black_box(&program)).unwrap());
}
#[divan::bench(args = [4, 64, 1024])]
fn pipeline(bencher: Bencher, procedures: usize) {
    let source = generated(procedures);
    bencher
        .counter(BytesCount::new(source.len()))
        .bench_local(|| {
            let module = jai_syntax::parse(divan::black_box(&source)).unwrap();
            let program = jai_sema::resolve(&module).unwrap();
            jai_codegen::emit(&program).unwrap()
        });
}
fn corpus(path: &Path, out: &mut Vec<String>) {
    if !path.exists() {
        return;
    }
    let mut entries = fs::read_dir(path)
        .unwrap()
        .map(|e| e.unwrap())
        .collect::<Vec<_>>();
    entries.sort_by_key(|e| e.file_name());
    for entry in entries {
        let path = entry.path();
        let kind = entry.file_type().unwrap();
        if kind.is_dir() {
            corpus(&path, out);
        } else if kind.is_file() && path.extension().is_some_and(|e| e == "jai") {
            let bytes = fs::read(&path).unwrap();
            out.push(jai_lexer::decode_source(&bytes).unwrap().into_owned());
        }
    }
}
fn lex_corpus(bencher: Bencher, path: &Path) {
    let mut sources = Vec::new();
    corpus(path, &mut sources);
    assert!(
        !sources.is_empty(),
        "no corpus sources at {}",
        path.display()
    );
    let bytes = sources.iter().map(String::len).sum::<usize>();
    bencher.counter(BytesCount::new(bytes)).bench_local(|| {
        for source in &sources {
            divan::black_box(jai_lexer::lex(divan::black_box(source)).unwrap());
        }
    });
}
#[divan::bench(sample_count = 20, sample_size = 1)]
fn reference_lex(bencher: Bencher) {
    lex_corpus(
        bencher,
        &Path::new(env!("CARGO_MANIFEST_DIR")).join("../../reference"),
    );
}
#[divan::bench(sample_count = 20, sample_size = 1, ignore)]
fn upstream_lex(bencher: Bencher) {
    lex_corpus(
        bencher,
        &Path::new(env!("CARGO_MANIFEST_DIR")).join("../../corpus/upstream"),
    );
}
