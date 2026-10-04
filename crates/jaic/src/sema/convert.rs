//! Implicit conversions (with overload costs) and explicit casts.
use super::lower::{FnCtx, Operand};
use super::*;
use crate::ir::{ConvOp, Ty};
use crate::types::{ArrayKind, TypeKind};

/// Conversion costs used to rank overloads. Lower is better.
pub const EXACT: u32 = 0;
pub const LITERAL: u32 = 1;
pub const WIDEN: u32 = 2;
pub const POINTER: u32 = 3;
pub const SUBTYPE: u32 = 4;
pub const TO_ANY: u32 = 6;

impl Compiler {
    /// Cost of implicitly converting a value of `from` to `to`, if allowed.
    /// `untyped` marks literals, which convert between numeric types freely.
    pub fn implicit_cost(&mut self, from: TypeId, untyped: bool, to: TypeId) -> Option<u32> {
        if from == to {
            return Some(EXACT);
        }
        if to == TypeId::ANY && from != TypeId::VOID && from != TypeId::COMPILE_TIME {
            return Some(TO_ANY);
        }
        let fk = self.types.kind(from).clone();
        let tk = self.types.kind(to).clone();
        if untyped {
            let tr = self.types.repr(to);
            if from == TypeId::NULL {
                return matches!(
                    self.types.kind(tr),
                    TypeKind::Pointer(_) | TypeKind::Proc(_) | TypeKind::Type
                )
                .then_some(LITERAL);
            }
            if self.types.is_integer(from) {
                if self.types.is_integer(to) || self.types.is_float(to) {
                    return Some(LITERAL);
                }
                return None;
            }
            if self.types.is_float(from) {
                return self.types.is_float(to).then_some(LITERAL);
            }
        }
        match (&fk, &tk) {
            (
                TypeKind::Int {
                    bits: fb,
                    signed: fs,
                },
                TypeKind::Int {
                    bits: tb,
                    signed: ts,
                },
            ) => {
                if (fs == ts && tb >= fb) || (!fs && *ts && tb > fb) {
                    Some(WIDEN)
                } else {
                    None
                }
            }
            (
                TypeKind::Float {
                    bits: 32,
                },
                TypeKind::Float {
                    bits: 64,
                },
            ) => Some(WIDEN),
            (TypeKind::Pointer(_), TypeKind::Pointer(t)) if *t == TypeId::VOID => Some(POINTER),
            (TypeKind::Pointer(f), TypeKind::Pointer(_)) if *f == TypeId::VOID => Some(POINTER),
            (TypeKind::Pointer(f), TypeKind::Pointer(t)) => {
                // *Derived → *Base through `#as` members.
                self.as_offset(*f, *t).map(|_| SUBTYPE)
            }
            (TypeKind::Null, TypeKind::Pointer(_) | TypeKind::Proc(_)) => Some(LITERAL),
            (
                TypeKind::Array {
                    elem: fe,
                    kind: ArrayKind::Fixed(_) | ArrayKind::Resizable,
                },
                TypeKind::Array {
                    elem: te,
                    kind: ArrayKind::View,
                },
            ) if fe == te => Some(POINTER),
            (TypeKind::Distinct(d), _) if self.types.distincts[d.0 as usize].isa => {
                let base = self.types.distincts[d.0 as usize].base;
                self.implicit_cost(base, false, to).map(|c| c + 1)
            }
            (TypeKind::Struct(_), _) => self.as_offset(from, to).map(|_| SUBTYPE),
            (TypeKind::Proc(a), TypeKind::Proc(b)) => (a == b).then_some(EXACT),
            _ => None,
        }
    }

    /// Offset of a `#as` member of type `to` inside struct `from` (searching recursively).
    pub fn as_offset(&mut self, from: TypeId, to: TypeId) -> Option<u64> {
        let s = self.types.as_struct(from)?;
        if self.layout_struct(s, Span::default()).is_err() {
            return None;
        }
        let fields = self.types.struct_info(s).fields.clone();
        for field in fields {
            if field.as_ {
                if field.ty == to {
                    return Some(field.offset);
                }
                if let Some(inner) = self.as_offset(field.ty, to) {
                    return Some(field.offset + inner);
                }
            }
        }
        None
    }

    /// Implicitly convert `op` to `to`, or fail with a type mismatch.
    pub fn convert(
        &mut self,
        f: &mut FnCtx,
        op: Operand,
        to: TypeId,
        span: Span,
    ) -> Result<Operand> {
        let from = op.ty();
        if from == to
            && !matches!(
                op,
                Operand::Const {
                    untyped: true,
                    ..
                }
            )
        {
            return Ok(op);
        }
        match op {
            Operand::Type(t) if to == TypeId::TYPE => return Ok(Operand::Type(t)),
            Operand::Type(t) if to == TypeId::ANY => {
                return self.box_any(f, Operand::Type(t), span);
            }
            Operand::Procs(ref procs) => {
                if let TypeKind::Proc(_) = self.types.kind(to) {
                    for &p in procs {
                        if self.proc(p).is_poly {
                            continue;
                        }
                        let pt = self.proc_type(p, span)?;
                        if pt == to || self.proc_types_compatible(pt, to) {
                            return Ok(Operand::Procs(vec![p]));
                        }
                    }
                    return err(
                        span,
                        format!("no overload matches procedure type {}", self.types.name(to)),
                    );
                }
                if to == TypeId::VOID_PTR || (self.types.is_pointer(to) && procs.len() == 1) {
                    let (_, v) = self.rvalue(f, op, span)?;
                    return Ok(Operand::Value {
                        ty: to,
                        val: v,
                    });
                }
                if to == TypeId::ANY {
                    return self.box_any(f, op, span);
                }
            }
            Operand::Const {
                ty,
                ref value,
                untyped,
            } => {
                if let Some(c) = self.convert_const(ty, value, untyped, to, span)? {
                    return Ok(c);
                }
            }
            _ => {}
        }
        let untyped = matches!(
            op,
            Operand::Const {
                untyped: true,
                ..
            }
        );
        if self.implicit_cost(from, untyped, to).is_none() {
            return err(
                span,
                format!(
                    "type mismatch: expected {}, found {}",
                    self.types.name(to),
                    self.types.name(from)
                ),
            );
        }
        self.coerce(f, op, to, span)
    }

    /// Structurally identical procedure types (ignoring parameter names).
    fn proc_types_compatible(&self, a: TypeId, b: TypeId) -> bool {
        match (self.types.kind(a), self.types.kind(b)) {
            (TypeKind::Proc(x), TypeKind::Proc(y)) => {
                x.params == y.params && x.returns == y.returns && x.c_call == y.c_call
            }
            _ => false,
        }
    }

    /// Constant-to-constant conversions (returns None when a runtime conversion is needed).
    fn convert_const(
        &mut self,
        ty: TypeId,
        value: &Value,
        untyped: bool,
        to: TypeId,
        span: Span,
    ) -> Result<Option<Operand>> {
        let tr = self.types.repr(to);
        let result = match value {
            Value::Int(i)
                if self.types.is_integer(tr)
                    && (untyped || self.implicit_cost(ty, false, to).is_some()) =>
            {
                let (bits, signed) = self.types.int_info(tr).unwrap();
                if untyped && !int_fits(*i, bits, signed) {
                    return err(
                        span,
                        format!("constant {i} does not fit in {}", self.types.name(to)),
                    );
                }
                if matches!(self.types.kind(to), TypeKind::Enum(_)) && untyped {
                    return Ok(None);
                }
                Value::Int(*i)
            }
            Value::Int(i) if self.types.is_float(tr) && untyped => Value::Float(*i as f64),
            Value::Float(x)
                if self.types.is_float(tr)
                    && (untyped || self.implicit_cost(ty, false, to).is_some()) =>
            {
                if tr == TypeId::F32 {
                    Value::Float(*x as f32 as f64)
                } else {
                    Value::Float(*x)
                }
            }
            Value::Null
                if matches!(
                    self.types.kind(tr),
                    TypeKind::Pointer(_) | TypeKind::Proc(_) | TypeKind::Type
                ) =>
            {
                Value::Null
            }
            Value::Bool(b) if tr == TypeId::BOOL => Value::Bool(*b),
            Value::String(s) if tr == TypeId::STRING => Value::String(s.clone()),
            Value::Type(t) if to == TypeId::TYPE => Value::Type(*t),
            Value::Proc(p) if self.implicit_cost(ty, false, to).is_some() => Value::Proc(*p),
            _ => return Ok(None),
        };
        Ok(Some(Operand::Const {
            ty: to,
            value: result,
            untyped: false,
        }))
    }

    /// Perform an allowed conversion at runtime.
    fn coerce(&mut self, f: &mut FnCtx, op: Operand, to: TypeId, span: Span) -> Result<Operand> {
        let from = op.ty();
        if to == TypeId::ANY {
            return self.box_any(f, op, span);
        }
        let op = if matches!(
            op,
            Operand::Const {
                untyped: true,
                ..
            }
        ) {
            self.settle_untyped(op, Some(to))
        } else {
            op
        };
        let from = if op.ty() == from {
            from
        } else {
            op.ty()
        };
        let fk = self.types.kind(from).clone();
        let tk = self.types.kind(to).clone();
        match (&fk, &tk) {
            (
                TypeKind::Array {
                    kind: ArrayKind::Fixed(n),
                    ..
                },
                TypeKind::Array {
                    kind: ArrayKind::View,
                    ..
                },
            ) => {
                let n = *n;
                let (_, addr) = self.address_of(f, op, span)?;
                let view = f.b.alloca(16, 8);
                let count = f.b.iconst(Ty::I64, n);
                f.b.store(Ty::I64, view, count);
                let data = f.b.ptr_offset(view, 8);
                f.b.store(Ty::Ptr, data, addr);
                Ok(Operand::Value {
                    ty: to,
                    val: view,
                })
            }
            (
                TypeKind::Array {
                    kind: ArrayKind::Resizable,
                    ..
                },
                TypeKind::Array {
                    kind: ArrayKind::View,
                    ..
                },
            ) => {
                // A resizable array starts with (count, data): reuse its prefix.
                let (_, addr) = self.address_of(f, op, span)?;
                Ok(Operand::Value {
                    ty: to,
                    val: addr,
                })
            }
            (TypeKind::Struct(_), _) => {
                let offset = self.as_offset(from, to).unwrap();
                let (_, addr) = self.address_of(f, op, span)?;
                let field = f.b.ptr_offset(addr, offset);
                Ok(Operand::Place {
                    ty: to,
                    addr: field,
                })
            }
            (TypeKind::Pointer(inner), TypeKind::Pointer(target))
                if *target != TypeId::VOID && *inner != TypeId::VOID =>
            {
                let offset = self.as_offset(*inner, *target).unwrap_or(0);
                let (_, v) = self.rvalue(f, op, span)?;
                Ok(Operand::Value {
                    ty: to,
                    val: f.b.ptr_offset(v, offset),
                })
            }
            _ => self.scalar_convert(f, op, to, span),
        }
    }

    /// Numeric/pointer conversion between scalar register classes.
    fn scalar_convert(
        &mut self,
        f: &mut FnCtx,
        op: Operand,
        to: TypeId,
        span: Span,
    ) -> Result<Operand> {
        let from = op.ty();
        let (_, v) = self.rvalue(f, op, span)?;
        let (Some(ft), Some(tt)) = (self.ir_ty(from), self.ir_ty(to)) else {
            if self.types.repr(from) == self.types.repr(to) {
                return Ok(Operand::Value {
                    ty: to,
                    val: v,
                });
            }
            return err(
                span,
                format!(
                    "cannot convert {} to {}",
                    self.types.name(from),
                    self.types.name(to)
                ),
            );
        };
        let fsigned =
            self.types.int_info(from).is_some_and(|(_, s)| s) || from == TypeId::BOOL && false;
        let tsigned = self.types.int_info(to).is_some_and(|(_, s)| s);
        let val = numeric_conv(f, v, ft, tt, fsigned, tsigned);
        Ok(Operand::Value {
            ty: to,
            val,
        })
    }

    /// `cast(T) x` / `xx x`.
    pub fn explicit_cast(
        &mut self,
        f: &mut FnCtx,
        op: Operand,
        to: TypeId,
        flags: ast::CastFlags,
        span: Span,
    ) -> Result<Operand> {
        let from = op.ty();
        if from == to
            && !matches!(
                op,
                Operand::Const {
                    untyped: true,
                    ..
                }
            )
        {
            return Ok(op);
        }
        // Constant folding of numeric casts.
        if let Operand::Const {
            value, ..
        } = &op
        {
            let tr = self.types.repr(to);
            let folded = match value {
                Value::Int(i) if self.types.is_integer(tr) => {
                    let (bits, signed) = self.types.int_info(tr).unwrap();
                    Some(Value::Int(expr::wrap_int(*i, bits, signed)))
                }
                Value::Int(i) if self.types.is_float(tr) => Some(Value::Float(*i as f64)),
                Value::Float(x) if self.types.is_float(tr) => {
                    Some(Value::Float(if tr == TypeId::F32 {
                        *x as f32 as f64
                    } else {
                        *x
                    }))
                }
                Value::Float(x) if self.types.is_integer(tr) => {
                    let (bits, signed) = self.types.int_info(tr).unwrap();
                    Some(Value::Int(expr::wrap_int(*x as i128, bits, signed)))
                }
                Value::Bool(b) if self.types.is_integer(tr) => Some(Value::Int(*b as i128)),
                Value::Int(i) if tr == TypeId::BOOL => Some(Value::Bool(*i != 0)),
                Value::Null if self.ir_ty(tr) == Some(Ty::Ptr) => Some(Value::Null),
                Value::Int(0) if self.ir_ty(tr) == Some(Ty::Ptr) && self.types.is_pointer(tr) => {
                    Some(Value::Null)
                }
                _ => None,
            };
            if let Some(value) = folded {
                return Ok(Operand::Const {
                    ty: to,
                    value,
                    untyped: false,
                });
            }
        }
        if let Operand::Type(t) = op {
            if to == TypeId::TYPE {
                return Ok(Operand::Type(t));
            }
            // cast(*Type_Info) T: the descriptor address.
            let v = self.materialize(f, &Value::Type(t), TypeId::TYPE, span)?;
            return Ok(Operand::Value {
                ty: to,
                val: v,
            });
        }
        let untyped = matches!(
            op,
            Operand::Const {
                untyped: true,
                ..
            }
        );
        if self.implicit_cost(from, untyped, to).is_some()
            && !self.types.is_integer(to)
            && !self.types.is_float(to)
        {
            return self.convert(f, op, to, span);
        }
        let _ = flags;
        // Same-representation reinterpretations (distinct/enum/struct-of-same-size are not allowed except via pointer).
        let fr = self.types.repr(from);
        let tr = self.types.repr(to);
        if self.ir_ty(fr).is_some() && self.ir_ty(tr).is_some() {
            let op = self.settle_untyped(op, Some(to));
            return self.scalar_convert(f, op, to, span);
        }
        if fr == tr {
            let (_, v) = self.rvalue(f, op, span)?;
            return Ok(Operand::Value {
                ty: to,
                val: v,
            });
        }
        // Array conversions.
        if let (
            TypeKind::Array {
                ..
            },
            TypeKind::Array {
                kind: ArrayKind::View,
                ..
            },
        ) = (self.types.kind(fr).clone(), self.types.kind(tr).clone())
        {
            let (_, addr) = self.address_of(f, op, span)?;
            return Ok(Operand::Value {
                ty: to,
                val: addr,
            });
        }
        if self.implicit_cost(from, untyped, to).is_some() {
            return self.convert(f, op, to, span);
        }
        err(
            span,
            format!(
                "cannot cast {} to {}",
                self.types.name(from),
                self.types.name(to)
            ),
        )
    }

    /// Box a value into an `Any` (type info pointer + pointer to a copy).
    pub fn box_any(&mut self, f: &mut FnCtx, op: Operand, span: Span) -> Result<Operand> {
        if op.ty() == TypeId::ANY {
            return Ok(op);
        }
        let (ty, addr) = match op {
            Operand::Type(t) => {
                let v = self.materialize(f, &Value::Type(t), TypeId::TYPE, span)?;
                (TypeId::TYPE, self.spill(f, TypeId::TYPE, v, span)?)
            }
            Operand::Place {
                ty,
                addr,
            } => (ty, addr),
            other => {
                let other = self.settle_untyped(other, None);
                let (ty, v) = self.rvalue(f, other, span)?;
                (ty, self.spill(f, ty, v, span)?)
            }
        };
        let info = self.type_info_global(ty, span)?;
        let any = f.b.alloca(16, 8);
        let ti = f.b.global_addr(info);
        f.b.store(Ty::Ptr, any, ti);
        let vp = f.b.ptr_offset(any, 8);
        f.b.store(Ty::Ptr, vp, addr);
        Ok(Operand::Value {
            ty: TypeId::ANY,
            val: any,
        })
    }
}

pub fn int_fits(v: i128, bits: u8, signed: bool) -> bool {
    if bits >= 64 {
        // Accept both the signed and unsigned spelling of 64-bit constants.
        return v >= i64::MIN as i128 && v <= u64::MAX as i128;
    }
    if signed {
        let max = (1i128 << (bits - 1)) - 1;
        // Also accept bit patterns written as unsigned literals (e.g. 0xFFFF_FFFF for s32).
        v >= -max - 1 && v <= ((1i128 << bits) - 1)
    } else {
        v >= -(1i128 << (bits - 1)) && v <= (1i128 << bits) - 1
    }
}

/// Convert a scalar register between classes.
pub fn numeric_conv(
    f: &mut FnCtx,
    v: ir::Val,
    ft: Ty,
    tt: Ty,
    fsigned: bool,
    tsigned: bool,
) -> ir::Val {
    let _ = tsigned;
    if ft == tt {
        return v;
    }
    match (ft.is_float(), tt.is_float()) {
        (true, true) => f.b.conv(
            if tt.size() > ft.size() {
                ConvOp::FExt
            } else {
                ConvOp::FTrunc
            },
            ft,
            tt,
            v,
        ),
        (true, false) => {
            if tt == Ty::Ptr {
                let i = f.b.conv(ConvOp::FToS, ft, Ty::I64, v);
                return f.b.conv(ConvOp::Bitcast, Ty::I64, Ty::Ptr, i);
            }
            f.b.conv(
                if tsigned {
                    ConvOp::FToS
                } else {
                    ConvOp::FToU
                },
                ft,
                tt,
                v,
            )
        }
        (false, true) => {
            let v = if ft == Ty::Ptr {
                f.b.conv(ConvOp::Bitcast, Ty::Ptr, Ty::I64, v)
            } else {
                v
            };
            let ft = if ft == Ty::Ptr {
                Ty::I64
            } else {
                ft
            };
            f.b.conv(
                if fsigned {
                    ConvOp::SToF
                } else {
                    ConvOp::UToF
                },
                ft,
                tt,
                v,
            )
        }
        (false, false) => {
            if ft == Ty::Ptr || tt == Ty::Ptr {
                // Pointers are 64-bit: widen/narrow through I64.
                let (v, ft) = if ft == Ty::Ptr {
                    (f.b.conv(ConvOp::Bitcast, Ty::Ptr, Ty::I64, v), Ty::I64)
                } else {
                    (v, ft)
                };
                let v = numeric_conv(
                    f,
                    v,
                    ft,
                    if tt == Ty::Ptr {
                        Ty::I64
                    } else {
                        tt
                    },
                    fsigned,
                    tsigned,
                );
                return if tt == Ty::Ptr {
                    f.b.conv(ConvOp::Bitcast, Ty::I64, Ty::Ptr, v)
                } else {
                    v
                };
            }
            if tt.size() < ft.size() {
                f.b.conv(ConvOp::Trunc, ft, tt, v)
            } else if fsigned {
                f.b.conv(ConvOp::SExt, ft, tt, v)
            } else {
                f.b.conv(ConvOp::ZExt, ft, tt, v)
            }
        }
    }
}
