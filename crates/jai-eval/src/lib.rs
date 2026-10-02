//! Pure scalar constant evaluation with typed nodes and no host effects.
pub mod operators;
use jai_source::{Diagnostic, Span, Symbol};
use jai_syntax::{Expression, ExpressionKind, ScalarType, UnaryOp};
use operators::{Equality, IntOp, Operator, Relation};

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Value {
    Int(i64),
    Bool(bool),
}
impl Value {
    pub fn ty(self) -> ScalarType {
        match self {
            Self::Int(_) => ScalarType::Int,
            Self::Bool(_) => ScalarType::Bool,
        }
    }
    pub fn zero(ty: ScalarType) -> Self {
        match ty {
            ScalarType::Int => Self::Int(0),
            ScalarType::Bool => Self::Bool(false),
        }
    }
}
/// Bind the complete expression before execution, including skipped operands.
pub fn evaluate(
    expression: &Expression,
    mut lookup: impl FnMut(Symbol, Span) -> Result<Value, Diagnostic>,
) -> Result<Value, Diagnostic> {
    match bind(expression, &mut lookup)? {
        Expr::Int(e) => e.evaluate().map(Value::Int),
        Expr::Bool(e) => e.evaluate().map(Value::Bool),
    }
}
enum Expr {
    Int(IntExpr),
    Bool(BoolExpr),
}
impl Expr {
    fn int(self, span: Span) -> Result<IntExpr, Diagnostic> {
        match self {
            Self::Int(e) => Ok(e),
            _ => Err(Diagnostic::new(span, "expected int constant")),
        }
    }
    fn condition(self) -> BoolExpr {
        match self {
            Self::Bool(e) => e,
            Self::Int(e) => BoolExpr::FromInt(Box::new(e)),
        }
    }
}
enum IntExpr {
    Constant(i64),
    FromBool(Box<BoolExpr>),
    Negate(Box<IntExpr>),
    Complement(Box<IntExpr>),
    Binary(IntOp, Box<IntExpr>, Box<IntExpr>, Span),
    Conditional(Box<Conditional<IntExpr>>),
}
enum BoolExpr {
    Constant(bool),
    FromInt(Box<IntExpr>),
    Not(Box<BoolExpr>),
    CompareInts(Relation, Box<IntExpr>, Box<IntExpr>),
    CompareBools(Equality, Box<BoolExpr>, Box<BoolExpr>),
    And(Box<BoolExpr>, Box<BoolExpr>),
    Or(Box<BoolExpr>, Box<BoolExpr>),
    Conditional(Box<Conditional<BoolExpr>>),
}
struct Conditional<T> {
    condition: BoolExpr,
    then_value: T,
    else_value: T,
}
fn literal(value: Value) -> Expr {
    match value {
        Value::Int(n) => Expr::Int(IntExpr::Constant(n)),
        Value::Bool(b) => Expr::Bool(BoolExpr::Constant(b)),
    }
}
fn bind(
    expression: &Expression,
    lookup: &mut impl FnMut(Symbol, Span) -> Result<Value, Diagnostic>,
) -> Result<Expr, Diagnostic> {
    let span = expression.span;
    Ok(match &expression.kind {
        ExpressionKind::Integer(n) => literal(Value::Int(*n)),
        ExpressionKind::Bool(b) => literal(Value::Bool(*b)),
        ExpressionKind::Name(name) => literal(lookup(*name, span)?),
        ExpressionKind::Call(_, _) => {
            return Err(Diagnostic::new(
                span,
                "procedure calls in constant expressions are not implemented yet",
            ));
        }
        ExpressionKind::Conditional(e) => {
            let condition = bind(&e.condition, lookup)?.condition();
            let then_value = bind(&e.then_value, lookup)?;
            let else_value = e.else_value.as_ref().map(|e| bind(e, lookup)).transpose()?;
            match (then_value, else_value) {
                (Expr::Int(then_value), else_value) => {
                    // The false arm is default-initialized to the result type when omitted.
                    let else_value = match else_value {
                        Some(Expr::Int(e)) => e,
                        None => IntExpr::Constant(0),
                        _ => {
                            return Err(Diagnostic::new(
                                span,
                                "ifx branches require matching scalar types",
                            ));
                        }
                    };
                    Expr::Int(IntExpr::Conditional(Box::new(Conditional {
                        condition,
                        then_value,
                        else_value,
                    })))
                }
                (Expr::Bool(then_value), else_value) => {
                    let else_value = match else_value {
                        Some(Expr::Bool(e)) => e,
                        None => BoolExpr::Constant(false),
                        _ => {
                            return Err(Diagnostic::new(
                                span,
                                "ifx branches require matching scalar types",
                            ));
                        }
                    };
                    Expr::Bool(BoolExpr::Conditional(Box::new(Conditional {
                        condition,
                        then_value,
                        else_value,
                    })))
                }
            }
        }
        ExpressionKind::Cast(ty, operand) => {
            let value = bind(operand, lookup)?;
            match ty {
                ScalarType::Bool => Expr::Bool(value.condition()),
                ScalarType::Int => Expr::Int(match value {
                    Expr::Int(e) => e,
                    Expr::Bool(e) => IntExpr::FromBool(Box::new(e)),
                }),
            }
        }
        ExpressionKind::Unary(op, operand) => {
            let value = bind(operand, lookup)?;
            match op {
                UnaryOp::Positive => Expr::Int(value.int(span)?),
                UnaryOp::Negate => Expr::Int(IntExpr::Negate(Box::new(value.int(span)?))),
                UnaryOp::Complement => Expr::Int(IntExpr::Complement(Box::new(value.int(span)?))),
                UnaryOp::LogicalNot => Expr::Bool(BoolExpr::Not(Box::new(value.condition()))),
            }
        }
        ExpressionKind::Binary(op, lhs, rhs) => {
            let lhs = bind(lhs, lookup)?;
            let rhs = bind(rhs, lookup)?;
            match Operator::from(*op) {
                Operator::Integer(op) => Expr::Int(IntExpr::Binary(
                    op,
                    Box::new(lhs.int(span)?),
                    Box::new(rhs.int(span)?),
                    span,
                )),
                Operator::Relation(op) => Expr::Bool(BoolExpr::CompareInts(
                    op,
                    Box::new(lhs.int(span)?),
                    Box::new(rhs.int(span)?),
                )),
                Operator::Equality(op) => Expr::Bool(match (lhs, rhs) {
                    (Expr::Int(lhs), Expr::Int(rhs)) => BoolExpr::CompareInts(
                        match op {
                            Equality::Equal => Relation::Equal,
                            Equality::NotEqual => Relation::NotEqual,
                        },
                        Box::new(lhs),
                        Box::new(rhs),
                    ),
                    (Expr::Bool(lhs), Expr::Bool(rhs)) => {
                        BoolExpr::CompareBools(op, Box::new(lhs), Box::new(rhs))
                    }
                    _ => {
                        return Err(Diagnostic::new(
                            span,
                            "constant equality requires matching scalar types",
                        ));
                    }
                }),
                Operator::And => Expr::Bool(BoolExpr::And(
                    Box::new(lhs.condition()),
                    Box::new(rhs.condition()),
                )),
                Operator::Or => Expr::Bool(BoolExpr::Or(
                    Box::new(lhs.condition()),
                    Box::new(rhs.condition()),
                )),
            }
        }
    })
}
impl IntExpr {
    fn evaluate(&self) -> Result<i64, Diagnostic> {
        Ok(match self {
            Self::Constant(n) => *n,
            Self::FromBool(e) => i64::from(e.evaluate()?),
            Self::Negate(e) => e.evaluate()?.wrapping_neg(),
            Self::Complement(e) => !e.evaluate()?,
            Self::Conditional(e) => {
                if e.condition.evaluate()? {
                    e.then_value.evaluate()?
                } else {
                    e.else_value.evaluate()?
                }
            }
            Self::Binary(op, lhs, rhs, span) => {
                let lhs = lhs.evaluate()?;
                let rhs = rhs.evaluate()?;
                match op {
                    IntOp::Add => lhs.wrapping_add(rhs),
                    IntOp::Subtract => lhs.wrapping_sub(rhs),
                    IntOp::Multiply => lhs.wrapping_mul(rhs),
                    IntOp::BitAnd => lhs & rhs,
                    IntOp::BitOr => lhs | rhs,
                    IntOp::BitXor => lhs ^ rhs,
                    IntOp::Divide => lhs.checked_div(rhs).ok_or_else(|| {
                        Diagnostic::new(
                            *span,
                            "invalid constant division: zero divisor or signed overflow",
                        )
                    })?,
                    IntOp::Remainder => lhs.checked_rem(rhs).ok_or_else(|| {
                        Diagnostic::new(
                            *span,
                            "invalid constant remainder: zero divisor or signed overflow",
                        )
                    })?,
                    IntOp::ShiftLeft | IntOp::ShiftRight => {
                        let count =
                            u32::try_from(rhs).ok().filter(|n| *n < 64).ok_or_else(|| {
                                Diagnostic::new(
                                    *span,
                                    "constant shift count must be between 0 and 63",
                                )
                            })?;
                        match op {
                            IntOp::ShiftLeft => lhs.wrapping_shl(count),
                            IntOp::ShiftRight => lhs >> count,
                            _ => unreachable!(),
                        }
                    }
                }
            }
        })
    }
}
impl BoolExpr {
    fn evaluate(&self) -> Result<bool, Diagnostic> {
        Ok(match self {
            Self::Constant(b) => *b,
            Self::FromInt(e) => e.evaluate()? != 0,
            Self::Not(e) => !e.evaluate()?,
            Self::And(lhs, rhs) => lhs.evaluate()? && rhs.evaluate()?,
            Self::Or(lhs, rhs) => lhs.evaluate()? || rhs.evaluate()?,
            Self::Conditional(e) => {
                if e.condition.evaluate()? {
                    e.then_value.evaluate()?
                } else {
                    e.else_value.evaluate()?
                }
            }
            Self::CompareInts(op, lhs, rhs) => {
                let lhs = lhs.evaluate()?;
                let rhs = rhs.evaluate()?;
                match op {
                    Relation::Equal => lhs == rhs,
                    Relation::NotEqual => lhs != rhs,
                    Relation::Less => lhs < rhs,
                    Relation::LessEqual => lhs <= rhs,
                    Relation::Greater => lhs > rhs,
                    Relation::GreaterEqual => lhs >= rhs,
                }
            }
            Self::CompareBools(op, lhs, rhs) => {
                let lhs = lhs.evaluate()?;
                let rhs = rhs.evaluate()?;
                match op {
                    Equality::Equal => lhs == rhs,
                    Equality::NotEqual => lhs != rhs,
                }
            }
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn run(text: &str) -> Result<Value, Diagnostic> {
        let module = jai_syntax::parse(&format!("value :: {text}; main :: () {{}}")).unwrap();
        evaluate(&module.constants()[0].initializer, |_, span| {
            Err(Diagnostic::new(span, "unknown constant"))
        })
    }
    #[test]
    fn integer_operators_and_casts() {
        for (expression, expected) in [
            ("1 + 2 * 3", 7),
            ("42 / 7 + 9 % 4", 7),
            ("(0xff & 0x3f) ^ 0x15", 42),
            ("(3 << 4) >> 1", 24),
            ("-8 >> 2", -2),
            ("~0", -1),
            ("+42", 42),
            ("cast(int) cast(bool) -3", 1),
            ("9223372036854775807 + 1", i64::MIN),
        ] {
            assert_eq!(
                run(expression).unwrap(),
                Value::Int(expected),
                "{expression}"
            );
        }
    }
    #[test]
    fn predicates_and_truthiness() {
        for expression in [
            "1 < 2",
            "2 <= 2",
            "3 > 1",
            "3 >= 3",
            "4 == 4",
            "4 != 5",
            "true != false",
            "!0",
            "!!-3",
            "cast(bool) 7",
        ] {
            assert_eq!(run(expression).unwrap(), Value::Bool(true), "{expression}");
        }
    }
    #[test]
    fn skipped_operands_are_bound_but_not_executed() {
        assert_eq!(run("false && (1 / 0)").unwrap(), Value::Bool(false));
        assert_eq!(run("true || (1 << 64)").unwrap(), Value::Bool(true));
        for expression in ["false && missing", "true || (false + 2)", "false && f()"] {
            assert!(run(expression).is_err(), "{expression}");
        }
    }
    #[test]
    fn invalid_arithmetic_and_scalar_mismatches_are_diagnostics() {
        for expression in [
            "1 / 0",
            "1 % 0",
            "1 << -1",
            "1 >> 64",
            "(-9223372036854775807 - 1) / -1",
            "true + false",
            "1 == true",
            "false < true",
        ] {
            assert!(run(expression).is_err(), "{expression}");
        }
    }
    #[test]
    fn conditional_constants_bind_both_arms_and_execute_only_one() {
        for (source, expected) in [
            ("ifx true then 42 else 1 / 0", Value::Int(42)),
            ("ifx false 1 / 0 else 42", Value::Int(42)),
            ("ifx 0 then 42", Value::Int(0)),
            ("ifx true then true else false", Value::Bool(true)),
            ("ifx false then true", Value::Bool(false)),
            (
                "ifx true then ifx false then 1 else 42 else 0",
                Value::Int(42),
            ),
        ] {
            assert_eq!(run(source).unwrap(), expected, "{source}");
        }
        for source in [
            "ifx true then 42 else missing",
            "ifx false then true else 42",
            "ifx true then 42 else f()",
        ] {
            assert!(run(source).is_err(), "{source}");
        }
    }
}
