use jai_eval::{CheckMode, DomainInference, Integer, IntegerType, ScalarDomain, Value};
use jai_source::{Diagnostic, Span, Symbols};
use jai_types::{FloatType, FloatValue};

fn expression(text: &str) -> jai_syntax::Expression {
    let mut sources = jai_source::SourceMap::default();
    let source = sources.insert("domains.jai".into(), format!("VALUE :: {text};"));
    let file =
        jai_syntax::parse_file(sources.get(source).unwrap(), &mut Symbols::default()).unwrap();
    let jai_syntax::FileItem::Declaration(declaration) = &file.items()[0] else {
        panic!()
    };
    let jai_syntax::FileDeclarationKind::Constant(constant) = &declaration.kind else {
        panic!()
    };
    constant.initializer.clone()
}
fn unknown(_: &jai_syntax::NamePath, span: Span) -> Result<ScalarDomain, Diagnostic> {
    Err(Diagnostic::new(span, "unknown binding"))
}
#[test]
fn inactive_typed_bindings_contribute_domains_without_reading_values() {
    let expression = expression("ifx true then cast(u8) 250 else unavailable");
    let inferred = DomainInference::infer(&expression, |_, _| {
        Ok(ScalarDomain::Integer(IntegerType::U16))
    })
    .unwrap();
    assert_eq!(inferred.domain(), ScalarDomain::Integer(IntegerType::U16));
    let value = inferred
        .evaluate_paths(CheckMode::Enabled, |_, _| panic!("inactive value read"))
        .unwrap();
    assert_eq!(value, Value::Int(Integer::wrapping(IntegerType::U16, 250)));
}
#[test]
fn incompatible_inactive_domains_and_unknown_bindings_still_fail() {
    let expression = expression("ifx true then cast(s64) 1 else unavailable");
    assert!(
        DomainInference::infer(&expression, |_, _| Ok(ScalarDomain::Integer(
            IntegerType::U64
        )))
        .unwrap_err()
        .message
        .contains("incompatible ranges")
    );
    assert!(
        DomainInference::infer(&expression, unknown)
            .unwrap_err()
            .message
            .contains("unknown binding")
    );
}
#[test]
fn short_circuit_reads_only_selected_values_but_checks_both_domains() {
    for text in ["false && unavailable", "true || unavailable"] {
        let input = expression(text);
        let inferred = DomainInference::infer(&input, |_, _| Ok(ScalarDomain::Bool)).unwrap();
        assert!(matches!(
            inferred
                .evaluate_paths(CheckMode::Enabled, |_, _| panic!("inactive value read"))
                .unwrap(),
            Value::Bool(_)
        ));
    }
    let input = expression("false && (unavailable + true)");
    assert!(
        DomainInference::infer(&input, |_, _| Ok(ScalarDomain::Integer(IntegerType::S32))).is_err()
    );
}
#[test]
fn selected_arithmetic_keeps_common_width_and_overflow_policy() {
    let input = expression("(ifx true then cast(u8) 250 else unavailable) + 6");
    let inferred =
        DomainInference::infer(&input, |_, _| Ok(ScalarDomain::Integer(IntegerType::U16))).unwrap();
    assert_eq!(
        inferred
            .evaluate_paths(CheckMode::Enabled, |_, _| panic!())
            .unwrap(),
        Value::Int(Integer::wrapping(IntegerType::U16, 256))
    );
    let input = expression("ifx true then cast(u8) 250 + 6 else cast(u16) 0");
    let inferred = DomainInference::infer(&input, unknown).unwrap();
    assert!(
        inferred
            .evaluate_paths(CheckMode::Enabled, |_, _| panic!())
            .unwrap_err()
            .message
            .contains("overflow")
    );
    assert_eq!(
        inferred
            .evaluate_paths(CheckMode::Disabled, |_, _| panic!())
            .unwrap(),
        Value::Int(Integer::wrapping(IntegerType::U16, 0))
    );
}
#[test]
fn selected_binding_values_must_match_inferred_binding_facts() {
    let input = expression("available");
    let inferred =
        DomainInference::infer(&input, |_, _| Ok(ScalarDomain::Integer(IntegerType::U16))).unwrap();
    assert!(
        inferred
            .evaluate_paths(CheckMode::Enabled, |_, _| Ok(Value::Int(
                Integer::wrapping(IntegerType::U8, 1)
            )))
            .unwrap_err()
            .message
            .contains("inferred domain")
    );
}
#[test]
fn inactive_float_domains_preserve_common_width_and_exact_rounding() {
    let input = expression("ifx true then 1.0000000596046448 else unavailable");
    let inferred =
        DomainInference::infer(&input, |_, _| Ok(ScalarDomain::WeakFloat(FloatType::F64))).unwrap();
    assert_eq!(
        inferred
            .evaluate_float_paths(FloatType::F32, CheckMode::Enabled, |_, _| panic!())
            .unwrap(),
        FloatValue::F32(1.0_f32.to_bits() + 1)
    );
    let input = expression("ifx true then cast(float32) (16777216.0 + 1.0) else unavailable");
    let inferred =
        DomainInference::infer(&input, |_, _| Ok(ScalarDomain::Float(FloatType::F64))).unwrap();
    assert_eq!(
        inferred
            .evaluate_paths(CheckMode::Enabled, |_, _| panic!())
            .unwrap(),
        Value::Float(FloatValue::from_f64(16777216.0))
    );
    assert!(
        inferred
            .evaluate_float_paths(FloatType::F32, CheckMode::Enabled, |_, _| panic!())
            .unwrap_err()
            .message
            .contains("source width")
    );
}
#[test]
fn inactive_weak_decimal_defaults_remain_part_of_exact_identity() {
    let input = expression("ifx true then 1.0 else unavailable");
    let make = |default| {
        let inferred =
            DomainInference::infer(&input, |_, _| Ok(ScalarDomain::WeakFloat(default))).unwrap();
        let Value::WeakFloat(value) = inferred
            .evaluate_paths(CheckMode::Enabled, |_, _| panic!())
            .unwrap()
        else {
            panic!()
        };
        value
    };
    let narrow = make(FloatType::F32);
    let wide = make(FloatType::F64);
    assert_eq!(wide.default_type(), FloatType::F64);
    assert_ne!(narrow.request_key(), wide.request_key());
    assert_ne!(
        narrow.request_key().canonical_bytes(100, 1000).unwrap(),
        wide.request_key().canonical_bytes(100, 1000).unwrap()
    );
    assert_eq!(
        wide.round(FloatType::F32, Span::default()).unwrap(),
        FloatValue::from_f32(1.0)
    );
}
