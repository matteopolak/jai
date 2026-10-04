//! `#bake_arguments f(a = 1)`: a new procedure (or polymorphic struct) with
//! some parameters fixed to compile-time values.
//!
//! The baked parameters are removed from a copy of the header and declared
//! as constants in a scope between the original defining scope and the new
//! procedure, so the body and the remaining parameter types see them by name.
use super::lower::Operand;
use super::*;

impl Compiler {
    pub fn check_bake(
        &mut self,
        scope: ScopeId,
        callee: &ast::Expr,
        args: &[ast::Arg],
        span: Span,
    ) -> Result<Operand> {
        match self.eval_const(scope, callee, None)? {
            Operand::Procs(procs) if procs.len() == 1 => {
                let proc = procs[0];
                let (name, lit, def_scope) = {
                    let p = self.proc(proc);
                    (p.name, p.lit.clone(), p.bindings.unwrap_or(p.scope))
                };
                let params = lit.header.params.clone();
                let (kept, consts) = self.bake_params(scope, def_scope, &params, args, span)?;
                let mut header = (*lit.header).clone();
                header.params = kept;
                // The copy is a new procedure, not another export of the original.
                header.flags.program_export = None;
                let lit = Rc::new(ast::ProcLit {
                    header: Rc::new(header),
                    body: lit.body.clone(),
                });
                let baked_scope = self.const_scope(def_scope, consts, span);
                Ok(Operand::Procs(vec![self.new_proc(
                    name,
                    lit,
                    baked_scope,
                    span,
                )]))
            }
            Operand::PolyStruct(ps) => {
                let (name, lit, def_scope) = {
                    let p = &self.poly_structs[ps.0 as usize];
                    (p.name, p.lit.clone(), p.scope)
                };
                let (kept, consts) = self.bake_params(scope, def_scope, &lit.params, args, span)?;
                let baked_scope = self.const_scope(def_scope, consts, span);
                let mut lit = (*lit).clone();
                lit.params = kept;
                if lit.params.is_empty() {
                    let lit = Rc::new(lit);
                    let ty = self.new_struct_type(name, lit, baked_scope, Vec::new(), None);
                    return Ok(Operand::Type(ty));
                }
                Ok(Operand::PolyStruct(self.new_poly_struct(
                    name,
                    Rc::new(lit),
                    baked_scope,
                )))
            }
            _ => err(
                callee.span,
                "#bake_arguments needs a single procedure or a polymorphic struct",
            ),
        }
    }

    /// Split `params` into those left open and `(name, value, type)` constants
    /// for the baked ones. Arguments are named, or positional from the start.
    fn bake_params(
        &mut self,
        scope: ScopeId,
        def_scope: ScopeId,
        params: &[ast::Param],
        args: &[ast::Arg],
        span: Span,
    ) -> Result<(Vec<ast::Param>, Vec<(Sym, Value, TypeId)>)> {
        let mut baked: Vec<Option<&ast::Arg>> = vec![None; params.len()];
        for (i, arg) in args.iter().enumerate() {
            let index = match arg.name {
                Some(n) => params
                    .iter()
                    .position(|p| p.name.map(|pn| pn.name) == Some(n.name))
                    .ok_or_else(|| {
                        Box::new(Diagnostic::error(
                            n.span,
                            format!("no parameter named '{}' to bake", n.name),
                        ))
                    })?,
                None if i < params.len() => i,
                None => return err(arg.value.span, "too many arguments to #bake_arguments"),
            };
            baked[index] = Some(arg);
        }
        let mut kept = Vec::new();
        let mut consts = Vec::new();
        for (param, arg) in params.iter().zip(baked) {
            let Some(arg) = arg else {
                kept.push(param.clone());
                continue;
            };
            let Some(name) = param.name else {
                return err(span, "cannot bake an unnamed parameter");
            };
            let declared = match &param.ty {
                Some(t) if !procs::has_poly(t) => Some(self.eval_type(def_scope, t)?),
                _ => None,
            };
            let (value, ty) = match declared {
                Some(TypeId::TYPE) | None => match self.eval_const(scope, &arg.value, declared)? {
                    Operand::Type(t) => (Value::Type(t), TypeId::TYPE),
                    Operand::Procs(p) if p.len() == 1 => {
                        let v = Value::Proc(p[0]);
                        let ty = self.type_of_value(&v);
                        (v, ty)
                    }
                    Operand::Const {
                        value,
                        ty,
                        untyped,
                    } => {
                        let ty = if untyped {
                            self.default_untyped(ty, &value)
                        } else {
                            ty
                        };
                        (value, ty)
                    }
                    _ => {
                        return err(
                            arg.value.span,
                            "baked argument must be a compile-time constant",
                        );
                    }
                },
                Some(t) => (self.const_value_of_type(scope, &arg.value, t)?, t),
            };
            consts.push((name.name, value, ty));
        }
        Ok((kept, consts))
    }

    pub(super) fn const_scope(
        &mut self,
        parent: ScopeId,
        consts: Vec<(Sym, Value, TypeId)>,
        span: Span,
    ) -> ScopeId {
        let module = self.scope(parent).module;
        let scope = self.new_scope(scope::ScopeKind::Block, Some(parent), module, None);
        for (name, value, ty) in consts {
            self.add_const(scope, name, span, value, ty);
        }
        scope
    }
}
