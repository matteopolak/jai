//! Original mixed scalar/spread normalization regressions.
use jaic::sema::{Compiler, Options, ProgramSource, VirtualFs};
use std::rc::Rc;

#[path = "support/variadic_source.rs"]
mod source;
use source::SOURCE;

#[test]
fn baked_mixed_packs_preserve_values_and_order() {
    let mut options = Options::host();
    options.runtime_support = false;
    let mut c = Compiler::new(options, Rc::new(VirtualFs::default()));
    let source = r#"
    encode :: ($items: ..int) -> int { result:int; for items result=result*10+it; return result; }
    forward :: ($items: ..int) -> int { return encode(1,..items,4); }
    #assert(forward(2,3)==1234);
    main :: () {}
    "#;
    if let Err(e) = c.compile_sources(&[ProgramSource::String(source.into())]) {
        panic!("{}", e.render(&c.sources));
    }
}

#[test]
fn scalar_prefix_is_not_discarded_by_a_following_spread() {
    let mut options = Options::host();
    options.runtime_support = false;
    let mut c = Compiler::new(options, Rc::new(VirtualFs::default()));
    if let Err(e)=c.compile_sources(&[ProgramSource::String("encode :: (items: ..int) -> int { result: int; for items result=result*10+it; return result; } test :: () -> int { tail: [2]int = .[2,3]; return encode(1,..tail); } #assert(test()==123);".into())]) {
        panic!("{}",e.render(&c.sources));
    }
}

#[test]
fn mixed_segments_preserve_values_order_defaults_and_polymorphism() {
    let mut options = Options::host();
    options.runtime_support = false;
    let mut c = Compiler::new(options, Rc::new(VirtualFs::default()));
    if let Err(e) = c.compile_sources(&[ProgramSource::String(format!(
        "{SOURCE}\n#assert(check()==0);"
    ))]) {
        panic!("{}", e.render(&c.sources));
    }
}
