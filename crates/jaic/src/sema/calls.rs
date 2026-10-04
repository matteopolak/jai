//! Calls: overload resolution, polymorphic inference, argument lowering,
//! builtin procedures, macro expansion and operator overloading.
use super::convert;
use super::lower::{FnCtx, MacroFrame, Operand};
use super::procs::{ProcTarget, Signature};
use super::scope::{BuiltinProc, EntityKind, ScopeKind};
use super::*;
use crate::ast::ExprKind as E;
use crate::ir::Ty;
use crate::types::{ArrayKind, TypeKind};

/// A call argument: either already checked, or deferred until the parameter
/// type is known (`.MEMBER`, `.{...}`, `xx value`...).
#[derive(Clone)]
pub struct CallArg {
    pub name: Option<Sym>,
    pub spread: bool,
    pub expr: Option<ast::Expr>,
    pub op: Option<Operand>,
    pub span: Span,
    pub scope: ScopeId,
}

/// How a parameter receives its value.
#[derive(Clone, Debug)]
enum Slot {
    Arg(usize),
    Variadic(Vec<usize>),
    Spread(usize),
    Default,
}

struct Candidate {
    proc: ProcId,
    slots: Vec<Slot>,
    cost: u32,
}

fn is_deferred(expr: &ast::Expr) -> bool {
    matches!(
        &expr.kind,
        E::InferredMember(_)
            | E::StructLit {
                ty: None,
                ..
            }
            | E::ArrayLit {
                ty: None,
                ..
            }
            | E::Cast {
                ty: None,
                ..
            }
            | E::Ifx { .. }
    )
}

impl Compiler {
    pub fn check_call(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        callee: &ast::Expr,
        args: &[ast::Arg],
        expected: Option<TypeId>,
        span: Span,
    ) -> Result<Operand> {
        if args.iter().any(|a| a.context) {
            // `f(x,, allocator = temp)`: call with a modified copy of the context.
            let (overrides, plain): (Vec<ast::Arg>, Vec<ast::Arg>) =
                args.iter().cloned().partition(|a| a.context);
            let ctx = self.context_with_overrides(f, scope, &overrides, span)?;
            let saved = f.context.replace(ctx);
            let result = self.check_call(f, scope, callee, &plain, expected, span);
            f.context = saved;
            return result;
        }
        let callee_op = self.check_expr(f, scope, callee, None)?;
        match callee_op {
            Operand::Builtin(b) => self.check_builtin(f, scope, b, args, expected, span),
            Operand::PolyStruct(ps) => {
                let mut values = Vec::new();
                for a in args {
                    values.push((
                        a.name.map(|n| n.name),
                        self.eval_const_value(scope, &a.value)?,
                    ));
                }
                Ok(Operand::Type(self.instantiate_struct(ps, values, span)?))
            }
            Operand::Procs(procs) => {
                let call_args = self.precheck_args(f, scope, args)?;
                self.call_procs(f, scope, &procs, call_args, expected, span)
            }
            Operand::Type(t) => {
                // `Type(x)` is not Jai; but `T.{}` etc are handled elsewhere.
                err(span, format!("cannot call type {}", self.types.name(t)))
            }
            other => {
                let (ty, v) = self.rvalue(f, other, span)?;
                let call_args = self.precheck_args(f, scope, args)?;
                self.call_indirect(f, ty, v, call_args, span)
            }
        }
    }

    /// A copy of the current context with fields replaced; an unnamed
    /// override sets the allocator.
    fn context_with_overrides(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        overrides: &[ast::Arg],
        span: Span,
    ) -> Result<ir::Val> {
        let Some(current) = f.context else {
            return err(
                span,
                "',,' context arguments need a context (not in #c_call code)",
            );
        };
        let ctx_ty = self.context_type(span)?;
        let copy = self.spill(f, ctx_ty, current, span)?;
        for o in overrides {
            let name = o.name.map_or_else(|| Sym::intern("allocator"), |n| n.name);
            let Some((path, fty)) = self.find_member(ctx_ty, name, o.value.span)? else {
                return err(o.value.span, format!("Context has no member '{name}'"));
            };
            let op = self.check_expr(f, scope, &o.value, Some(fty))?;
            let op = self.convert(f, op, fty, o.value.span)?;
            let (_, v) = self.rvalue(f, op, o.value.span)?;
            let addr = self.apply_path(f, copy, &path);
            self.store_value(f, fty, addr, v, o.value.span)?;
        }
        Ok(copy)
    }

    pub(super) fn precheck_args(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        args: &[ast::Arg],
    ) -> Result<Vec<CallArg>> {
        let mut out = Vec::new();
        for a in args {
            let op = if is_deferred(&a.value) {
                None
            } else {
                Some(self.check_expr(f, scope, &a.value, None)?)
            };
            out.push(CallArg {
                name: a.name.map(|n| n.name),
                spread: a.spread,
                expr: Some(a.value.clone()),
                op,
                span: a.value.span,
                scope,
            });
        }
        Ok(out)
    }

    /// Resolve and emit a call to one of `procs`.
    pub fn call_procs(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        procs: &[ProcId],
        mut args: Vec<CallArg>,
        expected: Option<TypeId>,
        span: Span,
    ) -> Result<Operand> {
        let _ = expected;
        // Multi-value call results expand into several arguments.
        if args.len() == 1
            && let Some(Operand::Multi(values)) = &args[0].op
        {
            let a = args[0].clone();
            args = values
                .iter()
                .map(|&(ty, val)| CallArg {
                    name: None,
                    spread: false,
                    expr: None,
                    op: Some(Operand::Value {
                        ty,
                        val,
                    }),
                    span: a.span,
                    scope: a.scope,
                })
                .collect();
        }
        let mut best: Vec<Candidate> = Vec::new();
        let mut errors: Vec<String> = Vec::new();
        for &proc in procs {
            match self.match_candidate(f, proc, &args, span) {
                Ok(c) => {
                    if best.first().is_none_or(|b| c.cost < b.cost) {
                        best = vec![c];
                    } else if best[0].cost == c.cost {
                        best.push(c);
                    }
                }
                Err(e) => errors.push(e.message.clone()),
            }
        }
        if best.is_empty() {
            let name = procs
                .first()
                .map(|&p| self.proc(p).name.to_string())
                .unwrap_or_default();
            if procs.len() == 1 {
                return err(span, format!("in call to '{name}': {}", errors.join("; ")));
            }
            let mut d = Diagnostic::error(
                span,
                format!("no overload of '{name}' matches these arguments"),
            );
            for (i, &p) in procs.iter().enumerate().take(8) {
                d = d.with_note(
                    self.proc(p).span,
                    errors.get(i).cloned().unwrap_or_default(),
                );
            }
            return Err(Box::new(d));
        }
        if best.len() > 1 {
            // Prefer non-polymorphic and more specific candidates; otherwise take the first.
            best.sort_by_key(|c| self.proc(c.proc).bindings.is_some() as u32);
        }
        let chosen = best.swap_remove(0);
        self.emit_call(f, scope, chosen, args, span)
    }

    /// Check whether `proc` accepts `args`, instantiating polymorphic procedures.
    fn match_candidate(
        &mut self,
        f: &mut FnCtx,
        proc: ProcId,
        args: &[CallArg],
        span: Span,
    ) -> Result<Candidate> {
        let header = self.proc(proc).lit.header.clone();
        self.refresh_implicit_poly(proc)?;
        let poly_vars = if self.proc(proc).is_poly {
            header_poly_names(&header)
        } else {
            Vec::new()
        };
        let slots = assign_slots(&header.params, args, &poly_vars, span)?;
        let mut proc_id = proc;
        let mut extra = 0;
        if self.proc(proc).is_poly {
            let bindings = self.infer_bindings(f, proc, &header, &slots, args, span)?;
            proc_id = self.instantiate(proc, bindings, span)?;
            extra = 1;
        }
        let sig = self.signature(proc_id, span)?;
        let runtime_params: Vec<usize> = (0..header.params.len())
            .filter(|&i| !header.params[i].baked)
            .collect();
        if runtime_params.len() != sig.params.len() {
            return err(span, "internal: signature/parameter mismatch");
        }
        let mut cost = extra;
        for (k, &i) in runtime_params.iter().enumerate() {
            let param = &sig.params[k];
            match &slots[i] {
                Slot::Default => {
                    if param.default.is_none() && !param.variadic {
                        let name = param.name.map(|n| n.to_string()).unwrap_or_default();
                        return err(span, format!("missing argument for parameter '{name}'"));
                    }
                }
                Slot::Arg(a) => cost += self.arg_cost(&args[*a], param.ty)?,
                Slot::Spread(a) => cost += self.arg_cost(&args[*a], param.ty)?,
                Slot::Variadic(list) => {
                    let elem = match self.types.kind(param.ty) {
                        TypeKind::Array {
                            elem, ..
                        } => *elem,
                        _ => param.ty,
                    };
                    for &a in list {
                        if sig.c_varargs {
                            continue;
                        }
                        cost += self.arg_cost(&args[a], elem)?;
                    }
                }
            }
        }
        Ok(Candidate {
            proc: proc_id,
            slots,
            cost,
        })
    }

    /// A `*Struct` argument passed to a by-value `Struct` parameter is dereferenced.
    fn auto_deref_arg(&self, from: TypeId, param: TypeId) -> bool {
        self.types.pointee(from) == Some(param) && self.types.as_struct(param).is_some()
    }

    fn arg_cost(&mut self, arg: &CallArg, param: TypeId) -> Result<u32> {
        let Some(op) = &arg.op else {
            // Deferred arguments fit any plausible target; prefer exact-looking ones.
            let scalar = matches!(
                self.types.kind(self.types.repr_struct(param)),
                TypeKind::Bool
                    | TypeKind::Int { .. }
                    | TypeKind::Float { .. }
                    | TypeKind::String
                    | TypeKind::Type
            );
            let enum_ = matches!(self.types.kind(param), TypeKind::Enum(_));
            let fits = match arg.expr.as_ref().map(|e| &e.kind) {
                // `.{...}` and `.[...]` build aggregates, `.NAME` picks an enum member.
                Some(
                    E::StructLit {
                        ..
                    }
                    | E::ArrayLit {
                        ..
                    },
                ) => !scalar,
                Some(E::InferredMember(_)) => !scalar || enum_,
                _ => true,
            };
            if !fits {
                return err(
                    arg.span,
                    format!(
                        "argument cannot be inferred as parameter type {}",
                        self.types.name(param)
                    ),
                );
            }
            return Ok(convert::LITERAL);
        };
        let untyped = matches!(
            op,
            Operand::Const {
                untyped: true,
                ..
            }
        );
        match op {
            Operand::Type(_) if param == TypeId::TYPE => return Ok(convert::EXACT),
            Operand::Type(_) if param == TypeId::ANY => return Ok(convert::TO_ANY),
            Operand::Procs(procs) => {
                if let TypeKind::Proc(_) = self.types.kind(param) {
                    for &p in procs.clone().iter() {
                        if !self.proc(p).is_poly && self.proc_type(p, arg.span)? == param {
                            return Ok(convert::EXACT);
                        }
                    }
                    if procs.len() == 1 && !self.proc(procs[0]).is_poly {
                        let pt = self.proc_type(procs[0], arg.span)?;
                        if let (TypeKind::Proc(a), TypeKind::Proc(b)) =
                            (self.types.kind(pt), self.types.kind(param))
                            && a.params == b.params
                            && a.returns == b.returns
                        {
                            return Ok(convert::WIDEN);
                        }
                    }
                    return err(
                        arg.span,
                        format!(
                            "procedure does not match parameter type {}",
                            self.types.name(param)
                        ),
                    );
                }
                if param == TypeId::VOID_PTR || param == TypeId::ANY {
                    return Ok(convert::POINTER);
                }
            }
            Operand::Const {
                value: Value::Int(v),
                untyped: true,
                ..
            } if self.types.is_integer(param) => {
                let (bits, signed) = self.types.int_info(param).unwrap();
                if !convert::int_fits(*v, bits, signed) {
                    return err(
                        arg.span,
                        format!("constant {v} does not fit in {}", self.types.name(param)),
                    );
                }
                if matches!(self.types.kind(param), TypeKind::Enum(_))
                    && !self.types.is_loose_enum(param)
                {
                    return err(
                        arg.span,
                        format!("an integer cannot be passed as {}", self.types.name(param)),
                    );
                }
                return Ok(if param == TypeId::S64 {
                    convert::EXACT
                } else {
                    convert::LITERAL
                });
            }
            // A string literal is NUL-terminated, so it converts to a C string.
            Operand::Const {
                value: Value::String(_),
                ..
            } if self.types.pointee(param) == Some(TypeId::U8) => return Ok(convert::POINTER),
            _ => {}
        }
        let from = op.ty();
        if from == TypeId::F32 && untyped && param == TypeId::F32 {
            return Ok(convert::EXACT);
        }
        if self.auto_deref_arg(from, param) {
            return Ok(convert::SUBTYPE);
        }
        self.implicit_cost(from, untyped, param).ok_or_else(|| {
            Box::new(Diagnostic::error(
                arg.span,
                format!(
                    "argument of type {} does not match parameter type {}",
                    self.types.name(from),
                    self.types.name(param)
                ),
            ))
        })
    }

    /// Infer `$T` bindings of a polymorphic procedure from its arguments.
    fn infer_bindings(
        &mut self,
        f: &mut FnCtx,
        proc: ProcId,
        header: &ast::ProcHeader,
        slots: &[Slot],
        args: &[CallArg],
        span: Span,
    ) -> Result<Vec<(Sym, Value, TypeId)>> {
        let mut bindings: Vec<(Sym, Value, TypeId)> = Vec::new();
        let def_scope = self.proc(proc).scope;
        let poly_vars = header_poly_names(header);
        for arg in args {
            if !is_poly_var_arg(&header.params, arg, &poly_vars) {
                continue;
            }
            let name = arg.name.unwrap();
            let op = match (&arg.op, &arg.expr) {
                (Some(op), _) => op.clone(),
                (None, Some(e)) => self.eval_const(arg.scope, e, None)?,
                (None, None) => return err(arg.span, "missing value"),
            };
            let Operand::Type(t) = op else {
                return err(arg.span, format!("'${name}' must be given a type"));
            };
            bindings.push((name, Value::Type(t), TypeId::TYPE));
        }
        for (i, param) in header.params.iter().enumerate() {
            let arg_ops: Vec<&CallArg> = match &slots[i] {
                Slot::Arg(a) | Slot::Spread(a) => vec![&args[*a]],
                Slot::Variadic(list) => list.iter().map(|&a| &args[a]).collect(),
                Slot::Default => Vec::new(),
            };
            if param.baked {
                let name = param.name.map(|n| n.name).unwrap();
                let Some(arg) = arg_ops.first() else {
                    if let Some(d) = &param.default {
                        let v = self.eval_const_value(def_scope, d)?;
                        let ty = self.type_of_value(&v);
                        bindings.push((name, v, ty));
                        continue;
                    }
                    return err(
                        span,
                        format!("missing argument for baked parameter '{name}'"),
                    );
                };
                let op = match arg.op.clone() {
                    Some(op) => op,
                    None => {
                        // `.{...}` / `.X` for a baked parameter: check against its declared type.
                        let declared = match &param.ty {
                            Some(t) if !procs::has_poly(t) => Some(self.eval_type(def_scope, t)?),
                            _ => None,
                        };
                        let expr = arg.expr.clone().unwrap();
                        let op = self.eval_const(arg.scope, &expr, declared)?;
                        match declared {
                            Some(t) => {
                                let value = self.const_value_of_type(arg.scope, &expr, t)?;
                                Operand::Const {
                                    ty: t,
                                    value,
                                    untyped: false,
                                }
                            }
                            None => op,
                        }
                    }
                };
                let value = match op {
                    Operand::Type(t) => Value::Type(t),
                    Operand::Const {
                        value, ..
                    } => value,
                    Operand::Procs(p) if p.len() == 1 => Value::Proc(p[0]),
                    _ => {
                        return err(
                            arg.span,
                            format!("argument for '${name}' must be a compile-time constant"),
                        );
                    }
                };
                // The declared type may itself be polymorphic (`$T: Type`).
                let ty = match &param.ty {
                    Some(t) if !procs::has_poly(t) => self.eval_type(def_scope, t)?,
                    _ => self.type_of_value(&value),
                };
                if let Some(t) = &param.ty
                    && procs::has_poly(t)
                {
                    let vt = self.type_of_value(&value);
                    self.match_pattern(t, vt, &mut bindings, def_scope)?;
                }
                bindings.push((name, value, ty));
                continue;
            }
            let Some(pattern) = &param.ty else {
                continue;
            };
            let implicit =
                !procs::has_poly(pattern) && self.mentions_poly_struct(def_scope, pattern)?;
            if !procs::has_poly(pattern) && !implicit {
                continue;
            }
            for (k, arg) in arg_ops.iter().enumerate() {
                let Some(op) = &arg.op else {
                    continue;
                };
                let mut ty = match op {
                    Operand::Const {
                        ty,
                        value,
                        untyped: true,
                    } => self.default_untyped(*ty, value),
                    Operand::Type(_) => TypeId::TYPE,
                    Operand::Procs(p) if p.len() == 1 && !self.proc(p[0]).is_poly => {
                        self.proc_type(p[0], arg.span)?
                    }
                    other => other.ty(),
                };
                if param.variadic && matches!(slots[i], Slot::Spread(_)) {
                    if let TypeKind::Array {
                        elem, ..
                    } = self.types.kind(ty)
                    {
                        ty = *elem;
                    }
                }
                if k > 0 && param.variadic {
                    // Later variadic elements must match the first binding.
                    let mut probe = bindings.clone();
                    if self
                        .match_pattern(pattern, ty, &mut probe, def_scope)
                        .is_err()
                    {
                        continue;
                    }
                }
                self.match_pattern(pattern, ty, &mut bindings, def_scope)?;
                // Later parameter types may use this one's instance (`item: array.type`).
                if implicit
                    && k == 0
                    && let Some(n) = param.name
                    && !bindings.iter().any(|(b, _, _)| *b == n.name)
                {
                    bindings.push((n.name, Value::Type(ty), TypeId::TYPE));
                }
            }
        }
        // Defaults of the form `$T` without arguments are an error unless bound elsewhere.
        for param in &header.params {
            if let Some(t) = &param.ty {
                for name in poly_names(t) {
                    if !bindings.iter().any(|(n, _, _)| *n == name) {
                        return err(span, format!("could not infer polymorphic type '${name}'"));
                    }
                }
            }
        }
        // `#modify` blocks could adjust bindings; not supported yet (accept as-is).
        let _ = f;
        Ok(bindings)
    }

    /// Match a polymorphic type pattern against a concrete type, adding bindings.
    pub fn match_pattern(
        &mut self,
        pattern: &ast::Expr,
        ty: TypeId,
        bindings: &mut Vec<(Sym, Value, TypeId)>,
        scope: ScopeId,
    ) -> Result<()> {
        let span = pattern.span;
        let bind = |c: &mut Compiler,
                    bindings: &mut Vec<(Sym, Value, TypeId)>,
                    name: Sym,
                    value: Value,
                    vty: TypeId|
         -> Result<()> {
            if let Some((_, existing, _)) = bindings.iter().find(|(n, _, _)| *n == name) {
                if *existing != value {
                    return err(
                        span,
                        format!(
                            "conflicting types for '${name}': {} and {}",
                            existing.render(&c.types),
                            value.render(&c.types)
                        ),
                    );
                }
                return Ok(());
            }
            bindings.push((name, value, vty));
            Ok(())
        };
        match &pattern.kind {
            E::PolyVar {
                name, ..
            } => bind(self, bindings, *name, Value::Type(ty), TypeId::TYPE),
            // A bare polymorphic struct matches any of its instances; binding its
            // name makes the instance signature name the instance.
            E::Ident(name) => match self.ident_poly_struct(scope, *name)? {
                Some(ps)
                    if self.poly_structs[ps.0 as usize]
                        .instances
                        .values()
                        .any(|&t| t == ty) =>
                {
                    bind(self, bindings, *name, Value::Type(ty), TypeId::TYPE)
                }
                Some(_) => err(
                    span,
                    format!("{} is not an instance of '{name}'", self.types.name(ty)),
                ),
                None => Ok(()),
            },
            E::PolyRestricted {
                name, ..
            } => bind(self, bindings, *name, Value::Type(ty), TypeId::TYPE),
            E::Unary(ast::UnOp::Star, inner) => match self.types.kind(ty).clone() {
                TypeKind::Pointer(p) => self.match_pattern(inner, p, bindings, scope),
                _ => err(
                    span,
                    format!("expected a pointer, found {}", self.types.name(ty)),
                ),
            },
            E::ArrayType {
                size,
                elem,
            } => {
                let TypeKind::Array {
                    elem: actual,
                    kind,
                } = self.types.kind(ty).clone()
                else {
                    return err(
                        span,
                        format!("expected an array, found {}", self.types.name(ty)),
                    );
                };
                match (size, kind) {
                    (ast::ArraySize::View, _) => {}
                    (ast::ArraySize::Resizable, ArrayKind::Resizable) => {}
                    (ast::ArraySize::Fixed(n), ArrayKind::Fixed(count)) => {
                        if let E::PolyVar {
                            name, ..
                        } = &n.kind
                        {
                            bind(
                                self,
                                bindings,
                                *name,
                                Value::Int(count as i128),
                                TypeId::S64,
                            )?;
                        }
                    }
                    _ => {
                        return err(
                            span,
                            format!("array kind mismatch with {}", self.types.name(ty)),
                        );
                    }
                }
                self.match_pattern(elem, actual, bindings, scope)
            }
            E::Call {
                callee,
                args,
                ..
            } => {
                // `Table($K, $V)` against an instance of the same polymorphic struct.
                let Some(s) = self.types.as_struct(ty) else {
                    return err(
                        span,
                        format!("expected a struct instance, found {}", self.types.name(ty)),
                    );
                };
                let info = self.types.struct_info(s).clone();
                let callee_ok = match &callee.kind {
                    E::Ident(name) => {
                        let ids = self.lookup(scope, *name)?;
                        match ids.first() {
                            Some(&e) => {
                                matches!(self.resolve_entity(e)?, scope::Resolved::PolyStruct(ps) if self.poly_structs[ps.0 as usize].instances.values().any(|&t| t == ty))
                            }
                            None => false,
                        }
                    }
                    _ => true,
                };
                if !callee_ok {
                    return err(
                        span,
                        format!("{} is not an instance of this struct", self.types.name(ty)),
                    );
                }
                for (i, a) in args.iter().enumerate() {
                    let Some(value) = info.poly_args.get(i) else {
                        break;
                    };
                    match &a.value.kind {
                        E::PolyVar {
                            name, ..
                        } => {
                            let vty = self.type_of_value(value);
                            bind(self, bindings, *name, value.clone(), vty)?;
                        }
                        _ if procs::has_poly(&a.value) => {
                            if let Value::Type(t) = value {
                                self.match_pattern(&a.value, *t, bindings, scope)?;
                            }
                        }
                        _ => {}
                    }
                }
                Ok(())
            }
            E::ProcType(header) => {
                let TypeKind::Proc(pt) = self.types.kind(ty).clone() else {
                    return err(
                        span,
                        format!("expected a procedure, found {}", self.types.name(ty)),
                    );
                };
                for (p, &actual) in header.params.iter().zip(&pt.params) {
                    if let Some(t) = &p.ty {
                        self.match_pattern(t, actual, bindings, scope)?;
                    }
                }
                for (r, &actual) in header.returns.iter().zip(&pt.returns) {
                    if let Some(t) = &r.ty {
                        self.match_pattern(t, actual, bindings, scope)?;
                    }
                }
                Ok(())
            }
            _ => Ok(()),
        }
    }

    /// Emit a resolved call.
    fn emit_call(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        c: Candidate,
        args: Vec<CallArg>,
        span: Span,
    ) -> Result<Operand> {
        let proc = c.proc;
        if self.proc(proc).is_macro {
            return self.expand_macro(f, scope, proc, &c.slots, args, span);
        }
        let header = self.proc(proc).lit.header.clone();
        let sig = self.signature(proc, span)?;
        // Intrinsics expand inline.
        if header.flags.intrinsic && self.proc(proc).lit.body.is_none() {
            return self.emit_intrinsic(f, proc, &sig, &c.slots, &header, args, span);
        }
        let mut values = Vec::new();
        if sig.has_context {
            let Some(ctx) = f.context else {
                return err(
                    span,
                    format!(
                        "cannot call '{}' without a context (use push_context in #c_call code)",
                        self.proc(proc).name
                    ),
                );
            };
            values.push(ctx);
        }
        let mut k = 0;
        let mut c_vararg_values = Vec::new();
        for (i, slot) in c.slots.iter().enumerate() {
            if header.params[i].baked {
                continue;
            }
            let param = sig.params[k].clone();
            k += 1;
            if sig.c_varargs && param.variadic {
                if let Slot::Variadic(list) = slot {
                    for &a in list {
                        let op = self.arg_operand(f, &args[a], None)?;
                        let op = self.settle_untyped(op, None);
                        let op = c_vararg_promote(self, f, op, span)?;
                        let (_, v) = self.rvalue(f, op, span)?;
                        c_vararg_values.push(v);
                    }
                }
                continue;
            }
            let v = self.param_value(f, &sig, &param, slot, &args, span)?;
            values.push(v);
        }
        values.extend(c_vararg_values.iter().copied());
        // Out-pointers for memory-class results.
        let mut outs = Vec::new();
        for &rt in &sig.returns {
            if self.is_memory_type(rt) {
                let size = self.size_of(rt, span)?;
                let align = self.align_of(rt, span)?;
                let out = f.b.alloca(size, align);
                values.push(out);
                outs.push(Some(out));
            } else {
                outs.push(None);
            }
        }
        let target = self.proc_func(proc, span)?;
        let mut ir_sig = self.ir_sig(sig.ty, span)?;
        let callee = match target {
            ProcTarget::Func(id) => ir::Callee::Func(id),
            ProcTarget::Foreign(id) => {
                if sig.c_varargs {
                    // Record the actual argument classes for this variadic call site.
                    for &v in &c_vararg_values {
                        ir_sig.params.push(f.b.val_ty(v));
                    }
                    let fp = f.b.foreign_addr(id);
                    ir::Callee::Indirect(fp, ir_sig.clone())
                } else {
                    ir::Callee::Foreign(id)
                }
            }
        };
        if sig.c_varargs && !matches!(callee, ir::Callee::Indirect(..)) {
            ir_sig
                .params
                .extend(c_vararg_values.iter().map(|&v| f.b.val_ty(v)));
        }
        let results = f.b.call(callee, values, &ir_sig.returns.clone());
        Ok(self.call_results(&sig.returns, results, outs))
    }

    fn call_results(
        &mut self,
        returns: &[TypeId],
        results: Vec<ir::Val>,
        outs: Vec<Option<ir::Val>>,
    ) -> Operand {
        let mut values = Vec::new();
        let mut regs = results.into_iter();
        for (i, &rt) in returns.iter().enumerate() {
            let v = match outs[i] {
                Some(out) => out,
                None => regs.next().unwrap(),
            };
            values.push((rt, v));
        }
        match values.len() {
            0 => Operand::Void,
            1 => Operand::Value {
                ty: values[0].0,
                val: values[0].1,
            },
            _ => Operand::Multi(values),
        }
    }

    /// Check (if deferred) and convert an argument for a parameter of type `ty`.
    fn arg_operand(&mut self, f: &mut FnCtx, arg: &CallArg, ty: Option<TypeId>) -> Result<Operand> {
        match &arg.op {
            Some(op) => Ok(op.clone()),
            None => {
                let expr = arg.expr.as_ref().unwrap();
                self.check_expr(f, arg.scope, expr, ty)
            }
        }
    }

    /// Produce the lowered value passed for one parameter.
    fn param_value(
        &mut self,
        f: &mut FnCtx,
        sig: &Signature,
        param: &procs::ParamInfo,
        slot: &Slot,
        args: &[CallArg],
        span: Span,
    ) -> Result<ir::Val> {
        let op = match slot {
            Slot::Arg(a) | Slot::Spread(a) => {
                let op = self.arg_operand(f, &args[*a], Some(param.ty))?;
                if self.auto_deref_arg(op.ty(), param.ty) {
                    let (_, p) = self.rvalue(f, op, args[*a].span)?;
                    Operand::Place {
                        ty: param.ty,
                        addr: p,
                    }
                } else {
                    self.convert(f, op, param.ty, args[*a].span)?
                }
            }
            Slot::Default => {
                if param.variadic && param.default.is_none() {
                    // Empty variadic: a zero view.
                    let view = f.b.alloca(16, 8);
                    f.b.zero(view, 16);
                    return Ok(view);
                }
                let d = param.default.clone().unwrap();
                let op = match &d.kind {
                    E::CallerLocation => self.location_operand(f, span)?,
                    _ => self.check_expr(f, sig.scope, &d, Some(param.ty))?,
                };
                self.convert(f, op, param.ty, d.span)?
            }
            Slot::Variadic(list) => {
                let TypeKind::Array {
                    elem, ..
                } = self.types.kind(param.ty).clone()
                else {
                    unreachable!()
                };
                let size = self.size_of(elem, span)?;
                let align = self.align_of(elem, span)?;
                let n = list.len() as u64;
                let base = f.b.alloca((size * n).max(1), align);
                for (i, &a) in list.iter().enumerate() {
                    let op = self.arg_operand(f, &args[a], Some(elem))?;
                    let op = self.convert(f, op, elem, args[a].span)?;
                    let (_, v) = self.rvalue(f, op, span)?;
                    let at = f.b.ptr_offset(base, size * i as u64);
                    self.store_value(f, elem, at, v, span)?;
                }
                let view = f.b.alloca(16, 8);
                let count = f.b.iconst(Ty::I64, n);
                f.b.store(Ty::I64, view, count);
                let dp = f.b.ptr_offset(view, 8);
                f.b.store(Ty::Ptr, dp, base);
                return Ok(view);
            }
        };
        if self.is_memory_type(param.ty) {
            let (_, addr) = self.address_of(f, op, span)?;
            Ok(addr)
        } else {
            let (_, v) = self.rvalue(f, op, span)?;
            Ok(v)
        }
    }

    fn call_indirect(
        &mut self,
        f: &mut FnCtx,
        ty: TypeId,
        callee: ir::Val,
        args: Vec<CallArg>,
        span: Span,
    ) -> Result<Operand> {
        let TypeKind::Proc(pt) = self.types.kind(ty).clone() else {
            return err(
                span,
                format!("cannot call a value of type {}", self.types.name(ty)),
            );
        };
        if args.len() < pt.params.len()
            || (!pt.c_varargs && !pt.variadic && args.len() > pt.params.len())
        {
            return err(
                span,
                format!(
                    "expected {} arguments, found {}",
                    pt.params.len(),
                    args.len()
                ),
            );
        }
        let mut values = Vec::new();
        if !pt.no_context {
            // Without a context (e.g. inside #c_call code) the callee receives null.
            let ctx = match f.context {
                Some(c) => c,
                None => f.b.iconst(Ty::Ptr, 0),
            };
            values.push(ctx);
        }
        for (i, &param_ty) in pt.params.iter().enumerate() {
            let op = self.arg_operand(f, &args[i], Some(param_ty))?;
            let op = self.convert(f, op, param_ty, args[i].span)?;
            if self.is_memory_type(param_ty) {
                let (_, a) = self.address_of(f, op, span)?;
                values.push(a);
            } else {
                let (_, v) = self.rvalue(f, op, span)?;
                values.push(v);
            }
        }
        let mut sig = self.ir_sig(ty, span)?;
        for arg in &args[pt.params.len()..] {
            let op = self.arg_operand(f, arg, None)?;
            let op = self.settle_untyped(op, None);
            let op = c_vararg_promote(self, f, op, span)?;
            let (_, v) = self.rvalue(f, op, span)?;
            sig.params.push(f.b.val_ty(v));
            values.push(v);
        }
        let mut outs = Vec::new();
        for &rt in &pt.returns {
            if self.is_memory_type(rt) {
                let size = self.size_of(rt, span)?;
                let align = self.align_of(rt, span)?;
                let out = f.b.alloca(size, align);
                values.push(out);
                outs.push(Some(out));
            } else {
                outs.push(None);
            }
        }
        let returns = sig.returns.clone();
        let results =
            f.b.call(ir::Callee::Indirect(callee, sig), values, &returns);
        Ok(self.call_results(&pt.returns, results, outs))
    }

    /// Intrinsic procedures declared in Preload (`memcpy`, `compare_and_swap`...).
    #[allow(clippy::too_many_arguments)]
    fn emit_intrinsic(
        &mut self,
        f: &mut FnCtx,
        proc: ProcId,
        sig: &Signature,
        slots: &[Slot],
        header: &ast::ProcHeader,
        args: Vec<CallArg>,
        span: Span,
    ) -> Result<Operand> {
        let name = self.proc(proc).name;
        let mut values = Vec::new();
        let mut k = 0;
        for (i, slot) in slots.iter().enumerate() {
            if header.params[i].baked {
                continue;
            }
            let param = sig.params[k].clone();
            k += 1;
            values.push(self.param_value(f, sig, &param, slot, &args, span)?);
        }
        let op = match name.as_str() {
            "memcpy" => ir::Intrinsic::Memcpy,
            "memset" => ir::Intrinsic::Memset,
            "memcmp" => ir::Intrinsic::Memcmp,
            "compare_and_swap" => ir::Intrinsic::CompareAndSwap,
            "debug_break" => ir::Intrinsic::DebugBreak,
            "sqrt" => ir::Intrinsic::Sqrt,
            "sin" => ir::Intrinsic::Sin,
            "cos" => ir::Intrinsic::Cos,
            "floor" => ir::Intrinsic::Floor,
            "ceil" => ir::Intrinsic::Ceil,
            "round" => ir::Intrinsic::Round,
            "trunc" => ir::Intrinsic::Trunc,
            "abs" | "fabs" => ir::Intrinsic::Fabs,
            "rdtsc" | "get_cpu_cycle_count" => ir::Intrinsic::CycleCounter,
            "pause" | "mm_pause" => ir::Intrinsic::Pause,
            other => return err(span, format!("unknown intrinsic '{other}'")),
        };
        let returns: Vec<Ty> = sig
            .returns
            .iter()
            .map(|&t| self.ir_ty(t).unwrap_or(Ty::Ptr))
            .collect();
        let results = f.b.intrinsic(op, values, &returns);
        let outs = vec![None; sig.returns.len()];
        Ok(self.call_results(&sig.returns, results, outs))
    }

    // -----------------------------------------------------------------------
    // Builtins
    // -----------------------------------------------------------------------

    fn check_builtin(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        b: BuiltinProc,
        args: &[ast::Arg],
        expected: Option<TypeId>,
        span: Span,
    ) -> Result<Operand> {
        let _ = expected;
        let Some(arg) = args.first() else {
            return err(span, "builtin needs an argument");
        };
        match b {
            BuiltinProc::SizeOf | BuiltinProc::AlignOf => {
                let op = match self.type_field_type(scope, &arg.value)? {
                    Some(t) => Operand::Type(t),
                    None => self.check_expr_no_emit(scope, &arg.value)?,
                };
                let ty = match op {
                    Operand::Type(t) => t,
                    other => other.ty(),
                };
                let v = if b == BuiltinProc::SizeOf {
                    self.size_of(ty, span)?
                } else {
                    self.align_of(ty, span)?
                };
                Ok(Operand::Const {
                    ty: TypeId::S64,
                    value: Value::Int(v as i128),
                    untyped: true,
                })
            }
            BuiltinProc::TypeOf => {
                if let Some(t) = self.type_field_type(scope, &arg.value)? {
                    return Ok(Operand::Type(t));
                }
                let op = self.check_expr_no_emit(scope, &arg.value)?;
                let ty = match op {
                    Operand::Type(_) => TypeId::TYPE,
                    Operand::Const {
                        ty,
                        value,
                        untyped: true,
                    } => self.default_untyped(ty, &value),
                    Operand::Procs(p) if p.len() == 1 => self.proc_type(p[0], span)?,
                    other => other.ty(),
                };
                Ok(Operand::Type(ty))
            }
            BuiltinProc::TypeInfo => {
                let op = self.check_expr(f, scope, &arg.value, Some(TypeId::TYPE))?;
                if matches!(
                    op,
                    Operand::Value {
                        ty: TypeId::TYPE,
                        ..
                    } | Operand::Place {
                        ty: TypeId::TYPE,
                        ..
                    }
                ) {
                    // A runtime `Type` is already a `*Type_Info`.
                    let (_, v) = self.rvalue(f, op, span)?;
                    let info = self.preload_type("Type_Info", span)?;
                    return Ok(Operand::Value {
                        ty: self.types.pointer(info),
                        val: v,
                    });
                }
                let ty = self.operand_as_type(op, arg.value.span)?;
                let info_ty = self.type_info_struct_type(ty, span)?;
                let ptr = self.types.pointer(info_ty);
                let global = self.type_info_global(ty, span)?;
                let v = f.b.global_addr(global);
                Ok(Operand::Value {
                    ty: ptr,
                    val: v,
                })
            }
            BuiltinProc::IsConstant => {
                let op = self.check_expr_no_emit(scope, &arg.value)?;
                Ok(Operand::bool(
                    op.is_const() || matches!(op, Operand::Procs(_)),
                ))
            }
            BuiltinProc::InitializerOf => {
                let ty = self.eval_type_in(f, scope, &arg.value)?;
                let proc = self.initializer_proc(ty, span)?;
                Ok(Operand::Value {
                    ty: proc.1,
                    val: f.b.func_addr(proc.0),
                })
            }
            BuiltinProc::OffsetOf => err(span, "offset_of is not supported yet"),
            BuiltinProc::IsValueType => err(span, "unsupported builtin"),
        }
    }

    /// Check an expression only for its type; any IR it emits is discarded.
    /// Argument of `type_of`/`size_of`: `Struct.field` names the field's type
    /// there, without a value.
    fn type_field_type(&mut self, scope: ScopeId, expr: &ast::Expr) -> Result<Option<TypeId>> {
        if let E::Member(base, field) = &expr.kind
            && let Ok(Operand::Type(t)) = self.check_expr_no_emit(scope, base)
            && self.types.as_struct(self.types.repr_struct(t)).is_some()
            && self.struct_constant(t, field.name)?.is_none()
            && let Some((_, fty)) = self.find_member(t, field.name, expr.span)?
        {
            return Ok(Some(fty));
        }
        Ok(None)
    }

    pub fn check_expr_no_emit(&mut self, scope: ScopeId, expr: &ast::Expr) -> Result<Operand> {
        let file = self.scope_file(scope);
        let mut scratch = FnCtx::new(
            "typeof".into(),
            ir::Sig {
                params: vec![Ty::Ptr],
                returns: vec![],
                conv: ir::Conv::Jai,
                c_varargs: false,
                c_abi: None,
            },
            file,
        );
        scratch.context = Some(scratch.b.param(0));
        self.check_expr(&mut scratch, scope, expr, None)
    }

    pub fn check_procedure_of_call(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        call: &ast::Expr,
    ) -> Result<Operand> {
        let E::Call {
            callee,
            args,
            ..
        } = &call.kind
        else {
            return err(call.span, "#procedure_of_call needs a call expression");
        };
        let callee_op = self.check_expr(f, scope, callee, None)?;
        let Operand::Procs(procs) = callee_op else {
            return err(call.span, "#procedure_of_call needs a procedure call");
        };
        let call_args = self.precheck_args(f, scope, args)?;
        for &p in &procs {
            if let Ok(c) = self.match_candidate(f, p, &call_args, call.span) {
                return Ok(Operand::Procs(vec![c.proc]));
            }
        }
        err(call.span, "no procedure matches this call")
    }

    // -----------------------------------------------------------------------
    // Macros
    // -----------------------------------------------------------------------

    fn expand_macro(
        &mut self,
        f: &mut FnCtx,
        caller: ScopeId,
        proc: ProcId,
        slots: &[Slot],
        args: Vec<CallArg>,
        span: Span,
    ) -> Result<Operand> {
        let sig = self.signature(proc, span)?;
        let header = self.proc(proc).lit.header.clone();
        let Some(body) = self.proc(proc).lit.body.clone() else {
            return err(span, "macro has no body");
        };
        if f.macros.len() > 64 {
            return err(span, "macro expansion is too deeply nested");
        }
        let module = self.scope(sig.scope).module;
        let mscope = self.new_scope(ScopeKind::Macro, Some(sig.scope), module, None);
        // Locals of the macro belong to the caller's procedure.
        self.scopes[mscope.0 as usize].proc_depth = self.scope(caller).proc_depth;
        let mut k = 0;
        for (i, slot) in slots.iter().enumerate() {
            if header.params[i].baked {
                continue;
            }
            let param = sig.params[k].clone();
            k += 1;
            let Some(name) = param.name else {
                continue;
            };
            if param.ty == TypeId::CODE {
                // Code arguments are passed unevaluated, bound to the caller's scope.
                let code = match slot {
                    Slot::Arg(a)
                        if let Some(Operand::Const {
                            value: Value::Code(code),
                            ..
                        }) = &args[*a].op =>
                    {
                        *code
                    }
                    Slot::Arg(a) => {
                        let Some(expr) = args[*a].expr.clone() else {
                            return err(args[*a].span, "Code parameter needs a code argument");
                        };
                        let id = value::CodeId(self.codes.len() as u32);
                        match &expr.kind {
                            E::Code(c) => self.codes.push(c.clone()),
                            _ => self.codes.push(Rc::new(ast::CodeBody::Expr(expr))),
                        }
                        self.code_scopes.push(caller);
                        id
                    }
                    _ => return err(span, "Code parameter needs an argument"),
                };
                self.add_const(mscope, name, param.span, Value::Code(code), TypeId::CODE);
                continue;
            }
            // A for_expansion's `flags` is a compile-time constant (`#assert(flags == 0)`).
            if let Slot::Arg(a) = slot
                && let Some(Operand::Const {
                    value: value @ Value::Int(_),
                    ..
                }) = &args[*a].op
                && self.preload_type("For_Flags", span).ok() == Some(param.ty)
            {
                self.add_const(mscope, name, param.span, value.clone(), param.ty);
                continue;
            }
            let v = self.param_value(f, &sig, &param, slot, &args, span)?;
            let addr = if self.is_memory_type(param.ty) {
                v
            } else {
                self.spill(f, param.ty, v, span)?
            };
            let depth = self.scope(mscope).proc_depth;
            let e = self.add_entity(
                mscope,
                name,
                param.span,
                EntityKind::Local {
                    ty: param.ty,
                    addr,
                    depth,
                },
                false,
            );
            if param.using {
                self.scope_mut(mscope)
                    .usings
                    .push(scope::UsingEntry::Place {
                        ty: param.ty,
                        entity: e,
                    });
            }
        }
        let exit = f.b.new_block();
        let mut result_slots = Vec::new();
        for &rt in &sig.returns {
            let size = self.size_of(rt, span)?;
            let align = self.align_of(rt, span)?;
            result_slots.push((rt, f.b.alloca(size.max(1), align)));
        }
        f.macros.push(MacroFrame {
            caller_scope: caller,
            exit_block: exit,
            result_slots: result_slots.clone(),
            defer_depth: f.defers.len(),
            loop_depth: f.loops.len(),
            caller_macro_depth: f.macros.len(),
            for_body: f.pending_for_body.take(),
        });
        let result = self.check_block_stmts(f, mscope, &body.stmts);
        let frame = f.macros.pop().unwrap();
        result?;
        if !f.b.is_terminated() {
            self.emit_defers(f, frame.defer_depth, span)?;
            f.b.jump(exit);
        }
        f.defers.truncate(frame.defer_depth);
        f.b.switch_to(exit);
        let mut values = Vec::new();
        for (rt, addr) in result_slots {
            let v = match self.ir_ty(rt) {
                Some(t) => f.b.load(t, addr),
                None => addr,
            };
            values.push((rt, v));
        }
        Ok(match values.len() {
            0 => Operand::Void,
            1 => Operand::Value {
                ty: values[0].0,
                val: values[0].1,
            },
            _ => Operand::Multi(values),
        })
    }

    // -----------------------------------------------------------------------
    // Operator overloading
    // -----------------------------------------------------------------------

    /// Scope a struct (or pointer to one) was declared in, for names that
    /// travel with the type: operator overloads and `for_expansion`.
    pub fn struct_home_scope(&self, t: TypeId) -> Option<ScopeId> {
        let t = self.types.pointee(t).unwrap_or(t);
        let s = self.types.as_struct(self.types.repr_struct(t))?;
        self.struct_asts.get(&s).map(|src| src.scope)
    }

    /// Operator overloads visible from the use site, plus those visible where
    /// the operand struct types were declared (`Bit_Array` brings its `operator []`).
    pub(super) fn operator_candidates(
        &mut self,
        scope: ScopeId,
        text: &str,
        operands: &[TypeId],
    ) -> Result<Vec<ProcId>> {
        let name = Sym::intern(&format!("operator{text}"));
        let mut scopes = vec![scope];
        for &t in operands {
            if let Some(home) = self.struct_home_scope(t)
                && !scopes.contains(&home)
            {
                scopes.push(home);
            }
        }
        let mut procs = Vec::new();
        for sc in scopes {
            let r = self.lookup(sc, name);
            for id in r.unwrap_or_default() {
                let p = match self.resolve_entity(id)? {
                    scope::Resolved::Proc(p)
                    | scope::Resolved::Const {
                        value: Value::Proc(p),
                        ..
                    } => p,
                    _ => continue,
                };
                if !procs.contains(&p) {
                    procs.push(p);
                }
            }
        }
        Ok(procs)
    }

    fn overloadable(&self, ty: TypeId) -> bool {
        matches!(
            self.types.kind(ty),
            TypeKind::Struct(_)
                | TypeKind::Array { .. }
                | TypeKind::Pointer(_)
                | TypeKind::Enum(_)
                | TypeKind::Distinct(_)
        )
    }

    pub fn try_binary_operator_overload(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        op: ast::BinOp,
        lhs: &Operand,
        rhs: &Operand,
        span: Span,
    ) -> Result<Option<Operand>> {
        let (lt, rt) = (lhs.ty(), rhs.ty());
        if !(self.overloadable(lt) || self.overloadable(rt)) || matches!(lhs, Operand::Type(_)) {
            return Ok(None);
        }
        if (self.types.is_pointer(lt) || matches!(self.types.kind(lt), TypeKind::Enum(_)))
            && !matches!(self.types.kind(rt), TypeKind::Struct(_))
        {
            return Ok(None);
        }
        let text = binop_text(op);
        let procs = self.operator_candidates(scope, text, &[lt, rt])?;
        if procs.is_empty() {
            return Ok(None);
        }
        let args = vec![
            CallArg {
                name: None,
                spread: false,
                expr: None,
                op: Some(lhs.clone()),
                span,
                scope,
            },
            CallArg {
                name: None,
                spread: false,
                expr: None,
                op: Some(rhs.clone()),
                span,
                scope,
            },
        ];
        if let Ok(r) = self.try_call(f, scope, &procs, args.clone(), span) {
            return Ok(Some(r));
        }
        // #symmetric operators accept swapped operands.
        let symmetric: Vec<ProcId> = procs
            .iter()
            .copied()
            .filter(|&p| self.proc(p).lit.header.flags.symmetric)
            .collect();
        if !symmetric.is_empty() {
            let swapped = vec![args[1].clone(), args[0].clone()];
            if let Ok(r) = self.try_call(f, scope, &symmetric, swapped, span) {
                return Ok(Some(r));
            }
        }
        if matches!(self.types.kind(lt), TypeKind::Struct(_))
            || matches!(self.types.kind(rt), TypeKind::Struct(_))
        {
            // Report the overload failure for struct operands.
            self.call_procs(f, scope, &procs, args, None, span)
                .map(Some)
        } else {
            Ok(None)
        }
    }

    pub(super) fn try_call(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        procs: &[ProcId],
        args: Vec<CallArg>,
        span: Span,
    ) -> Result<Operand> {
        let mut best: Option<Candidate> = None;
        for &p in procs {
            if let Ok(c) = self.match_candidate(f, p, &args, span)
                && best.as_ref().is_none_or(|b| c.cost < b.cost)
            {
                best = Some(c);
            }
        }
        match best {
            Some(c) => self.emit_call(f, scope, c, args, span),
            None => err(span, "no operator overload matches"),
        }
    }

    pub fn try_unary_operator_overload(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        op: ast::UnOp,
        operand: &Operand,
        span: Span,
    ) -> Result<Option<Operand>> {
        if !matches!(self.types.kind(operand.ty()), TypeKind::Struct(_)) {
            return Ok(None);
        }
        let text = match op {
            ast::UnOp::Neg => "-",
            ast::UnOp::Not => "!",
            ast::UnOp::BitNot => "~",
            _ => return Ok(None),
        };
        let procs = self.operator_candidates(scope, text, &[operand.ty()])?;
        if procs.is_empty() {
            return Ok(None);
        }
        let args = vec![CallArg {
            name: None,
            spread: false,
            expr: None,
            op: Some(operand.clone()),
            span,
            scope,
        }];
        self.call_procs(f, scope, &procs, args, None, span)
            .map(Some)
    }

    pub fn try_index_operator_overload(
        &mut self,
        f: &mut FnCtx,
        scope: ScopeId,
        base: &Operand,
        index: &Operand,
        span: Span,
    ) -> Result<Option<Operand>> {
        let bt = base.ty();
        let target = self.types.pointee(bt).unwrap_or(bt);
        if !matches!(self.types.kind(target), TypeKind::Struct(_)) {
            return Ok(None);
        }
        let procs = self.operator_candidates(scope, "[]", &[bt])?;
        if procs.is_empty() {
            return Ok(None);
        }
        let args = vec![
            CallArg {
                name: None,
                spread: false,
                expr: None,
                op: Some(base.clone()),
                span,
                scope,
            },
            CallArg {
                name: None,
                spread: false,
                expr: None,
                op: Some(index.clone()),
                span,
                scope,
            },
        ];
        let r = self.call_procs(f, scope, &procs, args, None, span)?;
        // `operator []` returning a pointer is an lvalue.
        Ok(Some(match r {
            Operand::Value {
                ty,
                val,
            } if self.types.pointee(ty).is_some_and(|p| p != TypeId::VOID)
                && self.types.pointee(ty) != Some(target) =>
            {
                let _ = val;
                Operand::Value {
                    ty,
                    val,
                }
            }
            other => other,
        }))
    }
}

pub fn binop_text(op: ast::BinOp) -> &'static str {
    use ast::BinOp::*;
    match op {
        Add => "+",
        Sub => "-",
        Mul => "*",
        Div => "/",
        Rem => "%",
        BitAnd => "&",
        BitOr => "|",
        BitXor => "^",
        Shl => "<<",
        Shr => ">>",
        Rotl => "<<<",
        Rotr => ">>>",
        Eq => "==",
        Ne => "!=",
        Lt => "<",
        Le => "<=",
        Gt => ">",
        Ge => ">=",
        And => "&&",
        Or => "||",
    }
}

/// C default argument promotions for variadic arguments.
fn c_vararg_promote(c: &mut Compiler, f: &mut FnCtx, op: Operand, span: Span) -> Result<Operand> {
    let ty = op.ty();
    if ty == TypeId::F32 {
        return c.convert(f, op, TypeId::F64, span);
    }
    if let Some((bits, signed)) = c.types.int_info(ty)
        && bits < 32
    {
        let target = if signed {
            TypeId::S32
        } else {
            TypeId::U32
        };
        return c.explicit_cast(f, op, target, ast::CastFlags::default(), span);
    }
    if ty == TypeId::BOOL {
        return c.explicit_cast(f, op, TypeId::S32, ast::CastFlags::default(), span);
    }
    Ok(op)
}

/// Polymorphic names introduced by a type pattern.
fn poly_names(expr: &ast::Expr) -> Vec<Sym> {
    let mut out = Vec::new();
    fn walk(e: &ast::Expr, out: &mut Vec<Sym>) {
        match &e.kind {
            E::PolyVar {
                name, ..
            }
            | E::PolyRestricted {
                name, ..
            } => out.push(*name),
            E::Unary(_, x) => walk(x, out),
            E::ArrayType {
                size,
                elem,
            } => {
                if let ast::ArraySize::Fixed(n) = size {
                    walk(n, out);
                }
                walk(elem, out);
            }
            E::Call {
                args, ..
            } => args.iter().for_each(|a| walk(&a.value, out)),
            E::ProcType(h) => {
                h.params
                    .iter()
                    .filter_map(|p| p.ty.as_ref())
                    .for_each(|t| walk(t, out));
                h.returns
                    .iter()
                    .filter_map(|r| r.ty.as_ref())
                    .for_each(|t| walk(t, out));
            }
            _ => {}
        }
    }
    walk(expr, &mut out);
    out
}

/// Map call arguments onto declared parameters.
/// Every `$T` binder in a header's parameter and result types.
fn header_poly_names(header: &ast::ProcHeader) -> Vec<Sym> {
    let mut names = Vec::new();
    for t in header
        .params
        .iter()
        .filter_map(|p| p.ty.as_ref())
        .chain(header.returns.iter().filter_map(|r| r.ty.as_ref()))
    {
        names.extend(poly_names(t));
    }
    names
}

/// A named argument binding a polymorphic variable (`f(x, T = float64)`).
fn is_poly_var_arg(params: &[ast::Param], arg: &CallArg, poly_vars: &[Sym]) -> bool {
    arg.name.is_some_and(|name| {
        poly_vars.contains(&name) && !params.iter().any(|p| p.name.map(|n| n.name) == Some(name))
    })
}

fn assign_slots(
    params: &[ast::Param],
    args: &[CallArg],
    poly_vars: &[Sym],
    span: Span,
) -> Result<Vec<Slot>> {
    let mut slots: Vec<Option<Slot>> = vec![None; params.len()];
    let variadic_index = params.iter().position(|p| p.variadic);
    let mut positional = 0usize;
    for (i, arg) in args.iter().enumerate() {
        if is_poly_var_arg(params, arg, poly_vars) {
            continue;
        }
        if let Some(name) = arg.name {
            let Some(p) = params
                .iter()
                .position(|p| p.name.map(|n| n.name) == Some(name))
            else {
                return err(arg.span, format!("no parameter named '{name}'"));
            };
            if slots[p].is_some() {
                return err(arg.span, format!("parameter '{name}' given twice"));
            }
            slots[p] = Some(if arg.spread {
                Slot::Spread(i)
            } else {
                Slot::Arg(i)
            });
            // Positional arguments after a named one continue from the next parameter.
            if Some(p) != variadic_index {
                positional = p + 1;
            }
            continue;
        }
        while positional < params.len()
            && slots[positional].is_some()
            && Some(positional) != variadic_index
        {
            positional += 1;
        }
        if positional >= params.len() {
            return err(
                arg.span,
                format!("too many arguments (expected at most {})", params.len()),
            );
        }
        if Some(positional) == variadic_index {
            if arg.spread {
                slots[positional] = Some(Slot::Spread(i));
                positional += 1;
                continue;
            }
            match &mut slots[positional] {
                Some(Slot::Variadic(list)) => list.push(i),
                None => slots[positional] = Some(Slot::Variadic(vec![i])),
                _ => return err(arg.span, "variadic parameter already given"),
            }
            continue;
        }
        slots[positional] = Some(if arg.spread {
            Slot::Spread(i)
        } else {
            Slot::Arg(i)
        });
        positional += 1;
    }
    let _ = span;
    Ok(slots
        .into_iter()
        .map(|s| s.unwrap_or(Slot::Default))
        .collect())
}
