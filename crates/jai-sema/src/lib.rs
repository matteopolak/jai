//! Resolve names and construct a typed program before code generation.
mod cleanup;
mod declarations;
mod loops;
use jai_eval::Value as ConstantValue;
use jai_eval::operators::Operator;
pub use jai_eval::operators::{Equality, IntOp, Relation};
use jai_source::{Diagnostic, Span, Symbol, Symbols};
use jai_syntax::{self as syntax, BinaryOp, ReturnType, ScalarType, UnaryOp};
use std::collections::HashMap;

macro_rules! id {
    ($name:ident) => {
        #[derive(Clone, Copy, Debug, PartialEq, Eq)]
        pub struct $name(usize);
        impl $name {
            pub fn index(self) -> usize {
                self.0
            }
        }
    };
}
id!(ProcedureId);
id!(IntLocal);
id!(BoolLocal);
id!(LoopId);
id!(CleanupId);
id!(IntGlobal);
id!(BoolGlobal);
#[derive(Clone, Copy, Debug)]
pub enum Local {
    Int(IntLocal),
    Bool(BoolLocal),
}
#[derive(Clone, Copy, Debug)]
pub enum IntPlace {
    Local(IntLocal),
    Global(IntGlobal),
}
#[derive(Clone, Copy, Debug)]
pub enum BoolPlace {
    Local(BoolLocal),
    Global(BoolGlobal),
}
#[derive(Clone, Copy, Debug)]
pub enum Storage {
    Int(IntPlace),
    Bool(BoolPlace),
}
impl From<Local> for Storage {
    fn from(local: Local) -> Self {
        match local {
            Local::Int(id) => Self::Int(IntPlace::Local(id)),
            Local::Bool(id) => Self::Bool(BoolPlace::Local(id)),
        }
    }
}
#[derive(Clone, Copy, Debug)]
enum Binding {
    Storage(Storage),
    Constant(ConstantValue),
}
#[derive(Clone, Copy, Debug)]
pub enum Global {
    Int { id: IntGlobal, initializer: i64 },
    Bool { id: BoolGlobal, initializer: bool },
}
#[derive(Clone, Copy, Debug)]
pub enum EntryPoint {
    Void(ProcedureId),
    Int(ProcedureId),
}
#[derive(Debug)]
pub struct Program {
    procedures: Vec<Procedure>,
    entry: EntryPoint,
    globals: Vec<Global>,
}
impl Program {
    pub fn procedures(&self) -> &[Procedure] {
        &self.procedures
    }
    pub fn globals(&self) -> &[Global] {
        &self.globals
    }
    pub fn entry(&self) -> EntryPoint {
        self.entry
    }
}
#[derive(Debug)]
pub struct Procedure {
    pub id: ProcedureId,
    pub parameters: Vec<Local>,
    pub locals: Vec<Local>,
    pub return_type: ReturnType,
    pub body: Block,
    pub cleanups: Vec<Block>,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Flow {
    FallsThrough,
    Terminates,
}
#[derive(Debug)]
pub struct Block {
    pub statements: Vec<Statement>,
    pub flow: Flow,
}
#[derive(Debug)]
pub enum Statement {
    StoreInt(IntPlace, IntExpr),
    StoreBool(BoolPlace, BoolExpr),
    Exit(Exit),
    Cleanup(CleanupId),
    DiscardInt(IntExpr),
    DiscardBool(BoolExpr),
    CallVoid(Call),
    If(BoolExpr, Block, Block),
    While {
        id: LoopId,
        condition: LoopCondition,
        body: Block,
    },
    Range(RangeLoop),
    Block(Block),
}
#[derive(Debug)]
pub struct Exit {
    pub cleanups: Vec<CleanupId>,
    pub transfer: Transfer,
}
#[derive(Debug)]
pub enum Transfer {
    ReturnVoid,
    ReturnInt(IntExpr),
    ReturnBool(BoolExpr),
    Break(LoopId),
    Continue(LoopId),
}
#[derive(Debug)]
pub enum LoopCondition {
    Value(BoolExpr),
    BoundInt(IntLocal, IntExpr),
    BoundBool(BoolLocal, BoolExpr),
}
#[derive(Debug)]
pub struct RangeLoop {
    pub id: LoopId,
    pub iterator: IntLocal,
    pub start: IntExpr,
    pub end: IntExpr,
    pub direction: syntax::Direction,
    pub body: Block,
}
#[derive(Debug)]
pub enum IntExpr {
    Constant(i64),
    FromBool(Box<BoolExpr>),
    Load(IntPlace),
    Call(Call),
    Negate(Box<IntExpr>),
    Complement(Box<IntExpr>),
    Binary(IntOp, Box<IntExpr>, Box<IntExpr>),
    Conditional(Box<Conditional<IntExpr>>),
}
#[derive(Debug)]
pub enum BoolExpr {
    Constant(bool),
    FromInt(Box<IntExpr>),
    Load(BoolPlace),
    Call(Call),
    Not(Box<BoolExpr>),
    CompareInts(Relation, Box<IntExpr>, Box<IntExpr>),
    CompareBools(Equality, Box<BoolExpr>, Box<BoolExpr>),
    And(Box<BoolExpr>, Box<BoolExpr>),
    Or(Box<BoolExpr>, Box<BoolExpr>),
    Conditional(Box<Conditional<BoolExpr>>),
}
#[derive(Debug)]
pub struct Conditional<T> {
    pub condition: BoolExpr,
    pub then_value: T,
    pub else_value: T,
}
#[derive(Debug)]
pub enum ValueExpr {
    Int(IntExpr),
    Bool(BoolExpr),
}
#[derive(Debug)]
pub struct Call {
    pub procedure: ProcedureId,
    pub arguments: Vec<ValueExpr>,
}

struct Signature {
    id: ProcedureId,
    parameters: Vec<ScalarType>,
    result: ReturnType,
}
enum Expr {
    Int(IntExpr),
    Bool(BoolExpr),
    Void(Call),
}
impl Expr {
    fn int(self, span: Span) -> Result<IntExpr, Diagnostic> {
        match self {
            Self::Int(e) => Ok(e),
            _ => Err(Diagnostic::new(span, "expected int value")),
        }
    }
    fn bool(self, span: Span) -> Result<BoolExpr, Diagnostic> {
        match self {
            Self::Bool(e) => Ok(e),
            _ => Err(Diagnostic::new(span, "expected bool value")),
        }
    }
    fn value(self, span: Span) -> Result<ValueExpr, Diagnostic> {
        match self {
            Self::Int(e) => Ok(ValueExpr::Int(e)),
            Self::Bool(e) => Ok(ValueExpr::Bool(e)),
            Self::Void(_) => Err(Diagnostic::new(span, "void call cannot supply a value")),
        }
    }
    fn condition(self, span: Span) -> Result<BoolExpr, Diagnostic> {
        match self {
            Self::Bool(e) => Ok(e),
            Self::Int(e) => Ok(BoolExpr::FromInt(Box::new(e))),
            Self::Void(_) => Err(Diagnostic::new(span, "void call cannot supply a condition")),
        }
    }
}

pub fn resolve(module: &syntax::Module) -> Result<Program, Diagnostic> {
    declarations::check_top_level_names(module)?;
    let (globals, global_bindings) = declarations::resolve_globals(module)?;
    let mut signatures = HashMap::new();
    for (index, p) in module.procedures().iter().enumerate() {
        let signature = Signature {
            id: ProcedureId(index),
            parameters: p.parameters.iter().map(|p| p.ty).collect(),
            result: p.return_type,
        };
        if signatures.insert(p.name, signature).is_some() {
            return Err(Diagnostic::new(
                p.span,
                format!("duplicate procedure '{}'", module.symbols().name(p.name)),
            ));
        }
    }
    let main = module
        .symbols()
        .find("main")
        .and_then(|s| signatures.get(&s))
        .ok_or_else(|| Diagnostic::new(Span::default(), "no main procedure"))?;
    if !main.parameters.is_empty() {
        return Err(Diagnostic::new(
            Span::default(),
            "main cannot take parameters in this compiler stage",
        ));
    }
    let entry = match main.result {
        ReturnType::Void => EntryPoint::Void(main.id),
        ReturnType::Value(ScalarType::Int) => EntryPoint::Int(main.id),
        ReturnType::Value(ScalarType::Bool) => {
            return Err(Diagnostic::new(
                Span::default(),
                "main must return int or void",
            ));
        }
    };
    let mut procedures = Vec::new();
    for (index, p) in module.procedures().iter().enumerate() {
        let mut r = Resolver {
            signatures: &signatures,
            symbols: module.symbols(),
            globals: &global_bindings,
            scopes: vec![HashMap::new()],
            locals: Vec::new(),
            span: p.span,
            result: p.return_type,
            loops: Vec::new(),
            next_loop: 0,
            cleanups: Vec::new(),
            deferred_scopes: Vec::new(),
            cleanup_context: None,
        };
        let mut parameters = Vec::new();
        for param in &p.parameters {
            parameters.push(r.declare(param.name, param.ty)?);
        }
        let body = r.block(&p.body, false)?;
        if p.return_type != ReturnType::Void && body.flow != Flow::Terminates {
            return Err(Diagnostic::new(
                p.span,
                "value-returning procedure may reach its end",
            ));
        }
        procedures.push(Procedure {
            id: ProcedureId(index),
            parameters,
            locals: r.locals,
            cleanups: r.cleanups,
            return_type: p.return_type,
            body,
        });
    }
    Ok(Program {
        procedures,
        entry,
        globals,
    })
}
struct LoopBinding {
    id: LoopId,
    name: Option<Symbol>,
    cleanup_depth: usize,
}
#[derive(Clone, Copy)]
struct CleanupContext {
    loop_depth: usize,
}
struct Resolver<'a> {
    signatures: &'a HashMap<Symbol, Signature>,
    symbols: &'a Symbols,
    scopes: Vec<HashMap<Symbol, Binding>>,
    globals: &'a HashMap<Symbol, Binding>,
    locals: Vec<Local>,
    span: Span,
    result: ReturnType,
    loops: Vec<LoopBinding>,
    next_loop: usize,
    cleanups: Vec<Block>,
    deferred_scopes: Vec<Vec<CleanupId>>,
    cleanup_context: Option<CleanupContext>,
}
impl Resolver<'_> {
    fn error(&self, text: impl Into<String>) -> Diagnostic {
        Diagnostic::new(self.span, text)
    }
    fn lookup_optional(&self, name: Symbol) -> Option<Binding> {
        self.scopes
            .iter()
            .rev()
            .find_map(|s| s.get(&name))
            .or_else(|| self.globals.get(&name))
            .copied()
    }
    fn lookup(&self, name: Symbol) -> Result<Binding, Diagnostic> {
        self.lookup_optional(name)
            .ok_or_else(|| self.error(format!("unknown variable '{}'", self.symbols.name(name))))
    }
    fn storage(&self, name: Symbol) -> Result<Storage, Diagnostic> {
        match self.lookup(name)? {
            Binding::Storage(storage) => Ok(storage),
            Binding::Constant(_) => Err(self.error("cannot assign to a constant")),
        }
    }
    fn bind_name(&mut self, name: Symbol, binding: Binding) -> Result<(), Diagnostic> {
        let scope = self.scopes.last_mut().expect("resolver always has a scope");
        if scope.contains_key(&name) {
            return Err(self.error(format!("duplicate variable '{}'", self.symbols.name(name))));
        }
        scope.insert(name, binding);
        Ok(())
    }
    fn bind(&mut self, name: Symbol, local: Local) -> Result<(), Diagnostic> {
        self.bind_name(name, Binding::Storage(Storage::from(local)))?;
        self.locals.push(local);
        Ok(())
    }
    fn declare_int(&mut self, name: Symbol) -> Result<IntLocal, Diagnostic> {
        let id = IntLocal(self.locals.len());
        self.bind(name, Local::Int(id))?;
        Ok(id)
    }
    fn declare_bool(&mut self, name: Symbol) -> Result<BoolLocal, Diagnostic> {
        let id = BoolLocal(self.locals.len());
        self.bind(name, Local::Bool(id))?;
        Ok(id)
    }
    fn declare(&mut self, name: Symbol, ty: ScalarType) -> Result<Local, Diagnostic> {
        match ty {
            ScalarType::Int => self.declare_int(name).map(Local::Int),
            ScalarType::Bool => self.declare_bool(name).map(Local::Bool),
        }
    }
    fn store(&self, local: Storage, value: Expr) -> Result<Statement, Diagnostic> {
        Ok(match local {
            Storage::Int(id) => Statement::StoreInt(id, value.int(self.span)?),
            Storage::Bool(id) => Statement::StoreBool(id, value.bool(self.span)?),
        })
    }
    fn block(
        &mut self,
        statements: &[syntax::Statement],
        scoped: bool,
    ) -> Result<Block, Diagnostic> {
        if scoped {
            self.scopes.push(HashMap::new());
        }
        self.bind_block_constants(statements)?;
        self.deferred_scopes.push(Vec::new());
        let mut out = Vec::new();
        let mut flow = Flow::FallsThrough;
        for statement in statements {
            if matches!(statement, syntax::Statement::Constant(_)) {
                continue;
            }
            if flow == Flow::Terminates {
                return Err(self.error("unreachable statement"));
            }
            if let syntax::Statement::Defer(body) = statement {
                self.register_defer(body)?;
                continue;
            }
            let s = self.statement(statement)?;
            flow = match &s {
                Statement::Exit(_) => Flow::Terminates,
                Statement::If(_, yes, no)
                    if yes.flow == Flow::Terminates && no.flow == Flow::Terminates =>
                {
                    Flow::Terminates
                }
                Statement::Block(b) => b.flow,
                _ => Flow::FallsThrough,
            };
            out.push(s);
        }
        let pending = self
            .deferred_scopes
            .pop()
            .expect("each block has a cleanup scope");
        if flow == Flow::FallsThrough {
            out.extend(pending.into_iter().rev().map(Statement::Cleanup));
        }
        if scoped {
            self.scopes.pop();
        }
        Ok(Block {
            statements: out,
            flow,
        })
    }
    fn statement(&mut self, statement: &syntax::Statement) -> Result<Statement, Diagnostic> {
        Ok(match statement {
            syntax::Statement::Declare(decl) => {
                let (name, ty, value) = match decl {
                    syntax::Declaration::Inferred { name, initializer } => {
                        let value = self.expr(initializer)?.value(initializer.span)?;
                        let (ty, value) = match value {
                            ValueExpr::Int(e) => (ScalarType::Int, Expr::Int(e)),
                            ValueExpr::Bool(e) => (ScalarType::Bool, Expr::Bool(e)),
                        };
                        (*name, ty, value)
                    }
                    syntax::Declaration::Explicit {
                        name,
                        ty,
                        initializer,
                    } => {
                        let value = match initializer {
                            Some(e) => self.expr(e)?,
                            None => match ty {
                                ScalarType::Int => Expr::Int(IntExpr::Constant(0)),
                                ScalarType::Bool => Expr::Bool(BoolExpr::Constant(false)),
                            },
                        };
                        (*name, *ty, value)
                    }
                };
                let local = self.declare(name, ty)?;
                self.store(Storage::from(local), value)?
            }
            syntax::Statement::Assign(name, e) => {
                let local = self.storage(*name)?;
                let value = self.expr(e)?;
                self.store(local, value)?
            }
            syntax::Statement::Update(name, op, e) => {
                let local = self.storage(*name)?;
                let lhs = match local {
                    Storage::Int(id) => Expr::Int(IntExpr::Load(id)),
                    Storage::Bool(id) => Expr::Bool(BoolExpr::Load(id)),
                };
                let value = self.binary(*op, lhs, self.expr(e)?, e.span)?;
                self.store(local, value)?
            }
            syntax::Statement::Return(e) => self.resolve_return(e.as_ref())?,
            syntax::Statement::Defer(_) | syntax::Statement::Constant(_) => {
                unreachable!("declarations are handled by block resolution")
            }
            syntax::Statement::Expression(e) => match self.expr(e)? {
                Expr::Int(e) => Statement::DiscardInt(e),
                Expr::Bool(e) => Statement::DiscardBool(e),
                Expr::Void(c) => Statement::CallVoid(c),
            },
            syntax::Statement::If(cond, yes, no) => Statement::If(
                self.expr(cond)?.condition(cond.span)?,
                self.block(yes, true)?,
                self.block(no, true)?,
            ),
            syntax::Statement::While(condition, body) => self.resolve_while(condition, body)?,
            syntax::Statement::Range(range) => self.resolve_range(range)?,
            syntax::Statement::Jump { kind, target, span } => {
                self.resolve_jump(*kind, *target, *span)?
            }
            syntax::Statement::Block(body) => Statement::Block(self.block(body, true)?),
        })
    }
    fn expr(&self, expr: &syntax::Expression) -> Result<Expr, Diagnostic> {
        let span = expr.span;
        Ok(match &expr.kind {
            syntax::ExpressionKind::Integer(n) => Expr::Int(IntExpr::Constant(*n)),
            syntax::ExpressionKind::Bool(b) => Expr::Bool(BoolExpr::Constant(*b)),
            syntax::ExpressionKind::Name(name) => match self.lookup(*name)? {
                Binding::Storage(Storage::Int(id)) => Expr::Int(IntExpr::Load(id)),
                Binding::Storage(Storage::Bool(id)) => Expr::Bool(BoolExpr::Load(id)),
                Binding::Constant(ConstantValue::Int(n)) => Expr::Int(IntExpr::Constant(n)),
                Binding::Constant(ConstantValue::Bool(b)) => Expr::Bool(BoolExpr::Constant(b)),
            },
            syntax::ExpressionKind::Call(name, args) => {
                if self.lookup_optional(*name).is_some() {
                    return Err(Diagnostic::new(span, "scalar value is not a procedure"));
                }
                let signature = self.signatures.get(name).ok_or_else(|| {
                    Diagnostic::new(
                        span,
                        format!("unknown procedure '{}'", self.symbols.name(*name)),
                    )
                })?;
                if args.len() != signature.parameters.len() {
                    return Err(Diagnostic::new(span, "wrong argument count"));
                }
                let arguments = args
                    .iter()
                    .zip(&signature.parameters)
                    .map(|(e, ty)| {
                        let e = self.expr(e)?;
                        Ok(match ty {
                            ScalarType::Int => ValueExpr::Int(e.int(span)?),
                            ScalarType::Bool => ValueExpr::Bool(e.bool(span)?),
                        })
                    })
                    .collect::<Result<_, Diagnostic>>()?;
                let call = Call {
                    procedure: signature.id,
                    arguments,
                };
                match signature.result {
                    ReturnType::Void => Expr::Void(call),
                    ReturnType::Value(ScalarType::Int) => Expr::Int(IntExpr::Call(call)),
                    ReturnType::Value(ScalarType::Bool) => Expr::Bool(BoolExpr::Call(call)),
                }
            }
            syntax::ExpressionKind::Conditional(e) => {
                let condition = self.expr(&e.condition)?.condition(e.condition.span)?;
                let then_value = self.expr(&e.then_value)?;
                let else_value = e.else_value.as_ref().map(|e| self.expr(e)).transpose()?;
                match then_value {
                    Expr::Int(then_value) => {
                        let else_value = match else_value {
                            Some(e) => e.int(span)?,
                            None => IntExpr::Constant(0),
                        };
                        Expr::Int(IntExpr::Conditional(Box::new(Conditional {
                            condition,
                            then_value,
                            else_value,
                        })))
                    }
                    Expr::Bool(then_value) => {
                        let else_value = match else_value {
                            Some(e) => e.bool(span)?,
                            None => BoolExpr::Constant(false),
                        };
                        Expr::Bool(BoolExpr::Conditional(Box::new(Conditional {
                            condition,
                            then_value,
                            else_value,
                        })))
                    }
                    Expr::Void(_) => {
                        return Err(Diagnostic::new(
                            span,
                            "void call cannot supply an ifx result",
                        ));
                    }
                }
            }
            syntax::ExpressionKind::Unary(op, operand) => {
                let value = self.expr(operand)?;
                match op {
                    UnaryOp::Positive => Expr::Int(value.int(span)?),
                    UnaryOp::Negate => Expr::Int(IntExpr::Negate(Box::new(value.int(span)?))),
                    UnaryOp::Complement => {
                        Expr::Int(IntExpr::Complement(Box::new(value.int(span)?)))
                    }
                    UnaryOp::LogicalNot => {
                        Expr::Bool(BoolExpr::Not(Box::new(value.condition(span)?)))
                    }
                }
            }
            syntax::ExpressionKind::Cast(ty, operand) => {
                let value = self.expr(operand)?;
                match ty {
                    ScalarType::Bool => Expr::Bool(value.condition(span)?),
                    ScalarType::Int => match value {
                        Expr::Int(e) => Expr::Int(e),
                        Expr::Bool(e) => Expr::Int(IntExpr::FromBool(Box::new(e))),
                        Expr::Void(_) => {
                            return Err(Diagnostic::new(span, "void call cannot be cast to int"));
                        }
                    },
                }
            }
            syntax::ExpressionKind::Binary(op, lhs, rhs) => {
                let lhs = self.expr(lhs)?;
                let rhs = self.expr(rhs)?;
                self.binary(*op, lhs, rhs, span)?
            }
        })
    }
    fn binary(&self, op: BinaryOp, lhs: Expr, rhs: Expr, span: Span) -> Result<Expr, Diagnostic> {
        Ok(match Operator::from(op) {
            Operator::Integer(op) => Expr::Int(IntExpr::Binary(
                op,
                Box::new(lhs.int(span)?),
                Box::new(rhs.int(span)?),
            )),
            Operator::Relation(op) => Expr::Bool(BoolExpr::CompareInts(
                op,
                Box::new(lhs.int(span)?),
                Box::new(rhs.int(span)?),
            )),
            Operator::Equality(op) => Expr::Bool(match (lhs, rhs) {
                (Expr::Int(l), Expr::Int(r)) => BoolExpr::CompareInts(
                    match op {
                        Equality::Equal => Relation::Equal,
                        Equality::NotEqual => Relation::NotEqual,
                    },
                    Box::new(l),
                    Box::new(r),
                ),
                (Expr::Bool(l), Expr::Bool(r)) => {
                    BoolExpr::CompareBools(op, Box::new(l), Box::new(r))
                }
                _ => {
                    return Err(Diagnostic::new(
                        span,
                        "equality requires two values of the same type",
                    ));
                }
            }),
            Operator::And => Expr::Bool(BoolExpr::And(
                Box::new(lhs.condition(span)?),
                Box::new(rhs.condition(span)?),
            )),
            Operator::Or => Expr::Bool(BoolExpr::Or(
                Box::new(lhs.condition(span)?),
                Box::new(rhs.condition(span)?),
            )),
        })
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn check(source: &str) -> Result<Program, Diagnostic> {
        resolve(&syntax::parse(source).unwrap())
    }
    #[test]
    fn conditional_results_require_matching_non_void_types() {
        for source in [
            "main :: ()->int { return ifx true then 1 else false; }",
            "main :: ()->bool { return ifx false then false else 1; }",
            "f :: () {} main :: ()->int { return ifx true then f() else 1; }",
            "f :: () {} main :: ()->int { return ifx false then 1 else f(); }",
            "f :: () {} main :: ()->int { return ifx f() then 1 else 2; }",
            "main :: ()->int { return ifx true then 1 else missing; }",
            "N :: ifx true then 1 else M; M :: N; main :: ()->int { return N; }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
        assert!(
            check("N :: ifx true then M else 1 / 0; M :: 42; main :: ()->int { return N; }")
                .is_ok()
        );
    }
    #[test]
    fn reject_unresolved_names_and_arity() {
        for src in [
            "main :: () { x = 1; }",
            "main :: () { missing(); }",
            "f :: (x:int) {} main :: () { f(); }",
        ] {
            assert!(check(src).is_err(), "{src}");
        }
    }
    #[test]
    fn preserve_scalar_types() {
        for src in [
            "main :: () { x: int = true; }",
            "main :: () { x: bool = 1; }",
            "main :: ()->int { return true; }",
            "f :: (b:bool) {} main :: () { f(1); }",
            "main :: () { x := true + false; }",
        ] {
            assert!(check(src).is_err(), "{src}");
        }
    }
    #[test]
    fn void_values_cannot_escape() {
        assert!(check("f :: () {} main :: () { f(); }").is_ok());
        assert!(check("f :: () {} main :: () { x := f(); }").is_err());
    }
    #[test]
    fn return_flow_and_scope() {
        for src in [
            "main :: ()->int {}",
            "main :: () { return; x := 1; }",
            "main :: () { { x := 1; } x = 2; }",
            "main :: () { x := 1; x := 2; }",
        ] {
            assert!(check(src).is_err(), "{src}");
        }
        assert!(check("main :: ()->int { if true return 1; else return 2; }").is_ok());
    }
    #[test]
    fn jumps_require_active_loop_targets_and_reachable_code() {
        for source in [
            "main :: () { break; }",
            "main :: () { continue; }",
            "main :: () { x := 1; while true { break x; } }",
            "main :: () { for i: 1..3 {} break i; }",
            "main :: () { while true { break; x := 1; } }",
            "main :: () { while true { if true continue; else break; x := 1; } }",
            "main :: ()->int { while true { break; } }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
    }
    #[test]
    fn iterator_and_while_bindings_are_scoped_and_typed() {
        for source in [
            "main :: () { for true..4 {} }",
            "main :: () { for 1..false {} }",
            "main :: () { for i: 1..3 {} i = 4; }",
            "main :: () { while value := true {} value = false; }",
            "main :: () { while value := true { value = 1; } }",
            "f :: () {} main :: () { while value := f() {} }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
        assert!(check("main :: () { for i: 1..3 { for i: 1..3 break i; continue i; } }").is_ok());
    }
    #[test]
    fn cleanup_cannot_escape_to_its_enclosing_procedure_or_loop() {
        for source in [
            "main :: () { defer return; }",
            "main :: () { for i: 1..3 { defer break i; } }",
            "main :: () { while true { defer continue; } }",
            "main :: () { defer x = 1; x := 0; }",
            "main :: () { defer { x := 1; } x = 2; }",
            "main :: () { return; defer {} }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
        assert!(check("main :: () { defer { for i: 1..3 { if i == 2 break i; } } }").is_ok());
    }
    #[test]
    fn constants_are_immutable_and_dependencies_must_be_acyclic() {
        for source in [
            "A :: B; B :: A; main :: () {}",
            "A :: A; main :: () {}",
            "A :: 1; main :: () { A = 2; }",
            "main :: () { A :: 1; A += 2; }",
            "main :: (x:int) { A :: x; }",
            "main :: () { x := 1; { A :: x; } }",
            "A :: missing; main :: () {}",
            "A :: 1 / 0; main :: () {}",
            "A : bool : 1; main :: () {}",
            "A :: 1; A := 2; main :: () {}",
            "main :: () { A :: 1; A :: 2; }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
    }
    #[test]
    fn global_initializers_and_scalar_calls_are_checked() {
        for source in [
            "x : bool = 1; main :: () {}",
            "x : int = true; main :: () {}",
            "x := y; y := 3; main :: () {}",
            "f :: ()->int { return 1; } x := f(); main :: () {}",
            "main :: () {} main := 0;",
            "f :: () {} main :: () { f := 2; f(); }",
        ] {
            assert!(check(source).is_err(), "{source}");
        }
    }
    #[test]
    fn deep_constant_dependency_chains_use_a_worklist() {
        use std::fmt::Write;
        let mut source = String::new();
        for n in 0..20_000 {
            writeln!(source, "C{n} :: C{} + 1;", n + 1).unwrap();
        }
        source.push_str("C20000 :: 0; main :: ()->int { return C0; }");
        assert!(check(&source).is_ok());
    }
    #[test]
    fn entry_point_and_parameter_invariants() {
        for src in [
            "f :: () {}",
            "main :: (x:int) {}",
            "main :: ()->bool { return true; }",
            "f :: (x:int,x:bool) {} main :: () {}",
        ] {
            assert!(check(src).is_err(), "{src}");
        }
    }
}
