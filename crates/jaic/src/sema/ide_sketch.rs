//! Editor facts for polymorphic procedures nothing calls. Such a procedure is never
//! instantiated, so its body is never checked and has no hover or go to definition. For an
//! editor, each one is checked once more as a sketch: an instance whose `$T`s are stand-in
//! types named after them (an empty struct `T`), whose `$N` array sizes are 1 and whose other
//! baked parameters take their default or a zero. The sketch records facts like any instance up
//! to its first error (a stand-in has no members, so `x.name` on a `T` stops it), and is then
//! forgotten: its errors are dropped and nothing can call it.
use super::procs::BodyState;
use super::value::ProcId;
use super::*;
use crate::types::TypeKind;

impl Compiler {
    /// Check a sketch of every polymorphic procedure of the recorded files that has no
    /// instance. Call after `ide_check_all`, only for an editor: the facts name stand-in types,
    /// which a linter should not see.
    pub fn ide_sketch_polymorphs(&mut self) {
        let (entities, procs) = (self.entities.len(), self.procs.len());
        let Some(ide) = self.ide.as_mut() else {
            return;
        };
        ide.sketch_from.get_or_insert(super::ide::SketchMark {
            refs: ide.refs.len(),
            entities,
            procs,
        });
        // Nor do the lint-only facts (expression types, casts, uses) get the stand-ins.
        let lint = std::mem::replace(&mut ide.lint, false);
        let mut i = 0;
        let count = self.procs.len();
        while i < count {
            let id = ProcId(i as u32);
            i += 1;
            let p = self.proc(id);
            let (file, scope) = (p.span.file, p.scope);
            if !p.is_poly
                || p.is_macro
                || p.bindings.is_some()
                || !p.instances.is_empty()
                || p.lit.body.is_none()
                || self.inside_instance(scope)
                || !self.ide_wants_pub(file)
            {
                continue;
            }
            // A sketch is ordinary checking, but with types nothing was written for: should it
            // trip an assumption, lose the sketch, not the editor's other facts.
            let sketched =
                std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| self.ide_sketch(id)));
            if sketched.is_err() {
                break;
            }
        }
        if let Some(ide) = self.ide.as_mut() {
            ide.lint = lint;
        }
    }

    fn ide_sketch(&mut self, id: ProcId) {
        let errors = self.ide.as_ref().map_or(0, |ide| ide.errors.len());
        let (warnings, deferred) = (self.warnings.len(), self.deferred_errors.len());
        let first_new = self.procs.len();
        if let Some(bindings) = self.ide_sketch_bindings(id) {
            let span = self.proc(id).span;
            if let Ok(inst) = self.instantiate(id, bindings, span) {
                self.procs[id.0 as usize]
                    .instances
                    .retain(|_, &mut i| i != inst);
                if self.proc_func(inst, span).is_ok() {
                    let _ = self.drain_bodies_lenient();
                }
            }
        }
        // Forget the sketch: what it queued, its errors, and the bodies that failed.
        let sketch = |p: &ProcId| (p.0 as usize) >= first_new;
        self.body_queue.retain(|p| !sketch(p));
        self.parked_bodies.retain(|p| !sketch(p));
        self.lenient_failures.retain(|p, _| !sketch(p));
        for p in &mut self.procs[first_new..] {
            if p.body_state == BodyState::Queued {
                p.body_state = BodyState::NotNeeded;
            }
        }
        if let Some(ide) = self.ide.as_mut() {
            ide.errors.truncate(errors);
        }
        self.warnings.truncate(warnings);
        self.deferred_errors.truncate(deferred);
    }

    /// Bindings for a sketch of `id`, or `None` when a baked parameter has no value to stand in
    /// for it (a `Code`, a struct, a variadic pack).
    fn ide_sketch_bindings(&mut self, id: ProcId) -> Option<Vec<(Sym, Value, TypeId)>> {
        let header = self.proc(id).lit.header.clone();
        let scope = self.proc(id).scope;
        let mut sizes: Vec<Sym> = Vec::new();
        super::ide::for_header_types(&header, &mut |e| {
            if let ast::ExprKind::ArrayType {
                size: ast::ArraySize::Fixed(n),
                ..
            } = &e.kind
                && let ast::ExprKind::PolyVar {
                    name, ..
                } = &n.kind
            {
                sizes.push(*name);
            }
        });
        let binders = self.poly_binders(&header);
        let mut out: Vec<(Sym, Value, TypeId)> = Vec::new();
        for (name, at) in binders {
            if sizes.contains(&name) {
                out.push((name, Value::Int(1), TypeId::S64));
            } else {
                let t = self.ide_stand_in(name, at, scope);
                out.push((name, Value::Type(t), TypeId::TYPE));
            }
        }
        for param in &header.params {
            let Some(name) = param.name.filter(|_| param.baked) else {
                continue;
            };
            if param.variadic {
                return None;
            }
            if out.iter().any(|(n, ..)| *n == name.name) {
                continue;
            }
            if let Some(d) = &param.default
                && let Ok((v, t)) = self.baked_default(scope, param, d, &out, name.span)
            {
                out.push((name.name, v, t));
                continue;
            }
            let ty = self.eval_type(scope, param.ty.as_ref()?).ok()?;
            let value = match self.types.kind(self.types.repr(ty)) {
                TypeKind::Type => Value::Type(self.ide_stand_in(name.name, name.span, scope)),
                TypeKind::Int {
                    ..
                }
                | TypeKind::Enum(_) => Value::Int(0),
                TypeKind::Float {
                    ..
                } => Value::Float(0.0),
                TypeKind::Bool => Value::Bool(false),
                TypeKind::String => Value::String(Rc::from(&b""[..])),
                _ => return None,
            };
            out.push((name.name, value, ty));
        }
        Some(out)
    }

    /// An empty struct named `name`, standing in for whatever type a call would bind.
    fn ide_stand_in(&mut self, name: Sym, span: Span, scope: ScopeId) -> TypeId {
        let lit = Rc::new(ast::StructLit {
            id: ast::AstId::fresh(),
            kind: ast::StructKind::Struct,
            params: Vec::new(),
            body: Vec::new(),
            flags: Default::default(),
            tag: None,
            modify: None,
            notes: Vec::new(),
            span,
        });
        self.new_struct_type(name, lit, scope, Vec::new(), None)
    }
}
