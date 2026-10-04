//! Syntax tree. Types are ordinary expressions (as in Jai), so `*T`, `[]T`,
//! `struct {..}` and procedure headers all live in `ExprKind`. Semantic
//! analysis decides whether an expression denotes a type or a value.
//!
//! The tree is immutable after parsing. Declarations that sema needs to
//! identify (procedures, structs, enums, declarations) carry an `AstId`,
//! unique across the whole compilation, so per-instance results can be kept in
//! side tables (polymorphic procedures are checked once per instantiation).
use crate::intern::Sym;
use crate::source::Span;
use std::cell::Cell;
use std::rc::Rc;

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct AstId(pub u32);

thread_local! {
    static NEXT_AST_ID: Cell<u32> = const { Cell::new(0) };
}
impl AstId {
    pub fn fresh() -> AstId {
        NEXT_AST_ID.with(|n| {
            let id = n.get();
            n.set(id + 1);
            AstId(id)
        })
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Ident {
    pub name: Sym,
    pub span: Span,
}

#[derive(Clone, Debug, PartialEq)]
pub struct Note {
    pub text: Rc<str>,
    pub span: Span,
}

// ---------------------------------------------------------------------------
// Expressions
// ---------------------------------------------------------------------------

#[derive(Clone, Debug)]
pub struct Expr {
    pub kind: ExprKind,
    pub span: Span,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    Rem,
    BitAnd,
    BitOr,
    BitXor,
    Shl,
    Shr,
    Rotl,
    Rotr,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum UnOp {
    Neg,
    /// Unary plus (accepted and ignored).
    Plus,
    Not,
    BitNot,
    /// `*x`: address-of in value position, pointer type in type position.
    Star,
    /// `<< x` or `x.*`: dereference.
    Deref,
}

#[derive(Clone, Debug)]
pub struct Arg {
    /// `name = value` named argument / struct literal field.
    pub name: Option<Ident>,
    /// `..value` spreads an array into variadic arguments.
    pub spread: bool,
    pub value: Expr,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct CastFlags {
    pub no_check: bool,
    pub truncate: bool,
    pub force: bool,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CallHint {
    None,
    Inline,
    NoInline,
}

#[derive(Clone, Debug)]
pub enum ArraySize {
    /// `[N] T` (N may be a `$N` polymorphic variable).
    Fixed(Box<Expr>),
    /// `[] T`
    View,
    /// `[..] T`
    Resizable,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TypeModifier {
    /// `#type T`
    Plain,
    /// `#type,distinct T`
    Distinct,
    /// `#type,isa T`
    Isa,
}

#[derive(Clone, Debug)]
pub enum ExprKind {
    Ident(Sym),
    /// `$T` introduces a polymorphic variable; `$$x` is a baked argument
    /// (`baked` = true when `$$`).
    PolyVar { name: Sym, baked: bool },
    /// `$T/Interface` or `$T/interface Interface` restriction.
    PolyRestricted { name: Sym, restriction: Box<Expr>, interface: bool },
    Int(u128),
    Float(f64),
    Str(Rc<[u8]>),
    Bool(bool),
    Null,
    /// `---`
    Uninit,
    Context,
    Binary(BinOp, Box<Expr>, Box<Expr>),
    Unary(UnOp, Box<Expr>),
    Call {
        callee: Box<Expr>,
        args: Vec<Arg>,
        hint: CallHint,
    },
    /// `a.b`
    Member(Box<Expr>, Ident),
    /// `.FOO`: enum member whose type comes from context.
    InferredMember(Ident),
    Index(Box<Expr>, Box<Expr>),
    /// `cast(T) x`, `cast,no_check(T) x`. `ty == None` is `xx x`.
    Cast { ty: Option<Box<Expr>>, value: Box<Expr>, flags: CastFlags },
    /// `ifx c then a else b`; `then_value == None` means the condition value is reused.
    Ifx { cond: Box<Expr>, then_value: Option<Box<Expr>>, else_value: Box<Expr> },
    /// `T.{...}` / `.{...}`
    StructLit { ty: Option<Box<Expr>>, fields: Vec<Arg> },
    /// `T.[...]` / `.[...]`
    ArrayLit { ty: Option<Box<Expr>>, elems: Vec<Expr> },
    ArrayType { size: ArraySize, elem: Box<Expr> },
    /// A procedure header without a body (a procedure type).
    ProcType(Rc<ProcHeader>),
    /// A procedure literal (header + body, or a foreign/compiler declaration).
    Proc(Rc<ProcLit>),
    Struct(Rc<StructLit>),
    Enum(Rc<EnumLit>),
    TypeDirective { modifier: TypeModifier, ty: Box<Expr> },
    /// `#run expr` or `#run { ... }`.
    Run { body: Rc<RunBody>, flags: Vec<Ident> },
    /// `#code expr`, `#code { ... }`.
    Code(Rc<CodeBody>),
    /// `#insert expr` in expression position.
    Insert { value: Box<Expr>, flags: Vec<Ident> },
    /// `#char "x"`
    Char(u32),
    /// `#location(expr)` (`None` = location of the directive itself).
    Location(Option<Box<Expr>>),
    CallerLocation,
    CallerCode,
    File,
    Line,
    Filepath,
    ProcedureName(Option<Box<Expr>>),
    This,
    CompileTime,
    /// `#bake_arguments f(a = 1)` / `#bake_constants`.
    Bake { callee: Box<Expr>, args: Vec<Arg>, constants: bool },
    /// `#procedure_of_call f(x)`
    ProcedureOfCall(Box<Expr>),
    /// `#exists(name)`
    Exists(Box<Expr>),
    /// `#bytes "..."` or `#bytes .[...]`
    Bytes(Box<Expr>),
    /// `#placeholder`-style or unrecognized directive with an optional operand.
    UnknownDirective { name: Ident, operand: Option<Box<Expr>> },
    /// `` `x ``: refer to the macro caller's scope.
    Backtick(Box<Expr>),
    /// `#asm { ... }`: kept as raw tokens' source span; unsupported semantically.
    Asm,
}

#[derive(Clone, Debug)]
pub enum RunBody {
    Expr(Expr),
    Block(Block),
}

#[derive(Clone, Debug)]
pub enum CodeBody {
    Expr(Expr),
    Block(Block),
}

// ---------------------------------------------------------------------------
// Procedures
// ---------------------------------------------------------------------------

#[derive(Clone, Debug)]
pub struct Param {
    pub name: Option<Ident>,
    /// `$name: T` (the parameter's value must be a compile-time constant).
    pub baked: bool,
    pub using: bool,
    /// `..` variadic: `args: ..Any` (or `..$T`).
    pub variadic: bool,
    pub ty: Option<Expr>,
    pub default: Option<Expr>,
    pub notes: Vec<Note>,
    pub span: Span,
}

#[derive(Clone, Debug)]
pub struct Return {
    pub name: Option<Ident>,
    pub ty: Expr,
    pub default: Option<Expr>,
    /// `#must`
    pub must: bool,
    pub span: Span,
}

#[derive(Clone, Debug)]
pub enum ForeignName {
    /// `#foreign lib` — symbol is the declaration's name.
    Default,
    Named(Rc<str>),
}

#[derive(Clone, Debug, Default)]
pub struct ProcFlags {
    pub c_call: bool,
    pub no_context: bool,
    pub expand: bool,
    pub compiler: bool,
    pub intrinsic: bool,
    pub elsewhere: Option<Option<Ident>>,
    pub symmetric: bool,
    pub inline: CallHintFlag,
    pub cpp_method: bool,
    pub cpp_return_type_is_non_pod: bool,
    pub runtime_support: bool,
    pub no_debug: bool,
    pub no_abc: bool,
    pub no_aoc: bool,
    pub deprecated: Option<Option<Rc<[u8]>>>,
    pub program_export: Option<Option<Rc<[u8]>>>,
    pub no_call: bool,
    pub type_info_none: bool,
    pub library_proc: bool,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum CallHintFlag {
    #[default]
    None,
    Inline,
    NoInline,
}

#[derive(Clone, Debug)]
pub struct ProcHeader {
    pub id: AstId,
    pub params: Vec<Param>,
    pub returns: Vec<Return>,
    pub flags: ProcFlags,
    /// `#foreign library_name ["symbol"]`
    pub foreign: Option<(Ident, ForeignName)>,
    /// `#modify { ... }` block that may rewrite polymorphic bindings.
    pub modify: Option<Block>,
    pub notes: Vec<Note>,
    pub span: Span,
    /// `operator +` style declarations: the operator text.
    pub operator: Option<Rc<str>>,
}

#[derive(Clone, Debug)]
pub struct ProcLit {
    pub header: Rc<ProcHeader>,
    /// `None` for foreign, `#compiler`, `#intrinsic` and `#elsewhere` declarations.
    pub body: Option<Block>,
}

// ---------------------------------------------------------------------------
// Aggregates
// ---------------------------------------------------------------------------

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum StructKind {
    Struct,
    Union,
}

#[derive(Clone, Debug, Default)]
pub struct StructFlags {
    pub type_info_none: bool,
    pub type_info_procedures_are_void_pointers: bool,
    pub type_info_no_size_complaint: bool,
    pub no_padding: bool,
    pub align: Option<Expr>,
}

#[derive(Clone, Debug)]
pub struct StructLit {
    pub id: AstId,
    pub kind: StructKind,
    /// `struct (T: Type, N := 4)`
    pub params: Vec<Param>,
    /// Body statements: declarations, `using`, `#if`, `#place`, `#as`, nested anonymous struct/union.
    pub body: Vec<Stmt>,
    pub flags: StructFlags,
    /// `#modify { ... }`
    pub modify: Option<Block>,
    pub notes: Vec<Note>,
    pub span: Span,
}

#[derive(Clone, Debug)]
pub struct EnumMember {
    pub name: Ident,
    pub value: Option<Expr>,
    pub notes: Vec<Note>,
}

#[derive(Clone, Debug)]
pub enum EnumItem {
    Member(EnumMember),
    /// `#if` inside an enum body.
    If { cond: Expr, then_items: Vec<EnumItem>, else_items: Vec<EnumItem> },
}

#[derive(Clone, Debug)]
pub struct EnumLit {
    pub id: AstId,
    pub flags_enum: bool,
    pub base: Option<Expr>,
    pub items: Vec<EnumItem>,
    pub specified: bool,
    pub complete: bool,
    pub notes: Vec<Note>,
    pub span: Span,
}

// ---------------------------------------------------------------------------
// Statements and declarations
// ---------------------------------------------------------------------------

#[derive(Clone, Debug, Default)]
pub struct Block {
    pub stmts: Vec<Stmt>,
    pub span: Span,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DeclKind {
    /// `x: T = v` / `x := v` / `x: T`
    Var,
    /// `x :: v` / `x: T : v`
    Const,
}

#[derive(Clone, Debug)]
pub struct Decl {
    pub id: AstId,
    pub names: Vec<Ident>,
    pub kind: DeclKind,
    pub ty: Option<Expr>,
    /// `None` = default-initialize. `Some(Uninit)` = `---`.
    pub value: Option<Expr>,
    pub using: bool,
    /// `#as using` / `#as x: T` in struct bodies.
    pub as_: bool,
    /// `` `x := ... `` declares into the macro caller's scope.
    pub backtick: bool,
    /// `#align N`
    pub align: Option<Expr>,
    /// `#elsewhere` / `#no_reset` / other trailing flags, kept by name.
    pub flags: Vec<Ident>,
    pub notes: Vec<Note>,
    pub span: Span,
}

#[derive(Clone, Debug)]
pub struct Case {
    /// Empty = default case (`case;`).
    pub values: Vec<Expr>,
    pub body: Vec<Stmt>,
    /// Body ends in `#through;`
    pub through: bool,
    pub span: Span,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AssignOp {
    Assign,
    Op(BinOp),
}

#[derive(Clone, Debug)]
pub struct For {
    /// `for x, i: range` names (iterator and index).
    pub it: Option<Ident>,
    pub index: Option<Ident>,
    /// `for *x: ...` iterates by pointer.
    pub by_pointer: bool,
    /// `for < ...` iterates in reverse.
    pub reverse: bool,
    /// `for:name ...` custom iterator modifier.
    pub iterator: Option<Ident>,
    /// `for a..b` (range) or `for collection`.
    pub over: ForOver,
    pub body: Box<Stmt>,
    pub flags: Vec<Ident>,
}

#[derive(Clone, Debug)]
pub enum ForOver {
    Range(Expr, Expr),
    Collection(Expr),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScopeKind {
    File,
    Export,
    Module,
}

#[derive(Clone, Debug)]
pub enum ImportSource {
    /// `#import "Basic"`
    Module(Rc<str>),
    /// `#import,file "x.jai"`
    File(Rc<str>),
    /// `#import,dir "path"`
    Dir(Rc<str>),
    /// `#import,string "source"`
    String(Rc<str>),
}

#[derive(Clone, Debug)]
pub struct Import {
    pub source: ImportSource,
    /// `#import "X"(PARAM=1)`
    pub params: Vec<Arg>,
    /// `Name :: #import "X"` binds a namespace instead of importing names.
    pub name: Option<Ident>,
    /// `using,only(...)` / `#import,except` style filters, kept raw.
    pub flags: Vec<Ident>,
    pub span: Span,
}

#[derive(Clone, Debug)]
pub enum UsingFilter {
    None,
    Only(Vec<Ident>),
    Except(Vec<Ident>),
    Map(Vec<(Ident, Ident)>),
}

#[derive(Clone, Debug)]
pub enum StmtKind {
    Decl(Rc<Decl>),
    Expr(Expr),
    Assign { op: AssignOp, lhs: Vec<Expr>, rhs: Vec<Expr> },
    Block(Block),
    If { cond: Expr, then_branch: Box<Stmt>, else_branch: Option<Box<Stmt>> },
    /// `if x == { case ...; }`
    Switch { value: Expr, cases: Vec<Case>, complete: bool },
    While { label: Option<Ident>, cond: Expr, body: Box<Stmt> },
    For(Box<For>),
    Break(Option<Ident>),
    Continue(Option<Ident>),
    /// `remove;` / `remove it;` in for loops.
    Remove(Option<Ident>),
    Return { values: Vec<Arg>, backtick: bool },
    Defer { body: Box<Stmt>, backtick: bool },
    /// `using expr;` (filters: `using,only(a,b) x;`)
    Using { value: Expr, filter: UsingFilter },
    PushContext { context: Expr, body: Box<Stmt> },
    /// `#if cond { } else { }`, also at file and struct scope.
    StaticIf { cond: Expr, then_branch: Vec<Stmt>, else_branch: Vec<Stmt> },
    /// `#insert expr;` (flags e.g. `,scope(x)`).
    Insert { value: Expr, flags: Vec<Ident> },
    /// `#assert cond "message";`
    Assert { cond: Expr, message: Option<Expr> },
    /// Top-level `#run expr;`
    Run(Expr),
    Import(Rc<Import>),
    /// `#load "file.jai";`
    Load { path: Rc<str>, span: Span },
    Scope(ScopeKind),
    /// `#add_context name: T = v;`
    AddContext(Rc<Decl>),
    /// `#module_parameters (A := 1) (B := 2);` second list = parameters visible to importers' runtime.
    ModuleParameters { params: Vec<Param>, runtime_params: Vec<Param>, body: Option<Block> },
    /// `#placeholder name;`
    Placeholder(Vec<Ident>),
    /// `#place field;` inside struct bodies.
    Place(Expr),
    /// `#through;` (normally folded into `Case::through`).
    Through,
    /// `#program_export`-style top-level directives we keep for completeness.
    Directive { name: Ident, args: Vec<Expr> },
    /// Empty statement (`;`).
    Empty,
}

#[derive(Clone, Debug)]
pub struct Stmt {
    pub kind: StmtKind,
    pub span: Span,
    pub notes: Vec<Note>,
}

/// A parsed file.
#[derive(Clone, Debug)]
pub struct File {
    pub file: crate::source::FileId,
    pub stmts: Vec<Stmt>,
}
