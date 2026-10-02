//! Construct and verify LLVM modules from immutable checked programs.
pub use inkwell::context::Context;
use inkwell::{
    IntPredicate,
    basic_block::BasicBlock,
    builder::{Builder, BuilderError},
    module::Module,
    support::LLVMString,
    types::{BasicMetadataTypeEnum, IntType},
    values::{
        BasicMetadataValueEnum, BasicValueEnum, CallSiteValue, FunctionValue, IntValue,
        PointerValue,
    },
};
use jai_sema::{
    Block, BoolExpr, Call, EntryPoint, Equality, Flow, IntExpr, IntLocal, IntOp, Local,
    LoopCondition, LoopId, Program, RangeLoop, Relation, Statement, ValueExpr,
};
use jai_sema::{BoolPlace, CleanupId, Conditional, Exit, Global, IntPlace, Transfer};
use jai_syntax::{Direction, ReturnType, ScalarType};
use std::fmt;

#[derive(Debug)]
pub enum Error {
    Build(BuilderError),
    Verification(LLVMString),
    Invariant,
}
impl From<BuilderError> for Error {
    fn from(e: BuilderError) -> Self {
        Self::Build(e)
    }
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Build(e) => write!(f, "LLVM instruction construction failed: {e}"),
            Self::Verification(e) => write!(f, "LLVM module verification failed: {e}"),
            Self::Invariant => f.write_str("internal LLVM lowering invariant failed"),
        }
    }
}
impl std::error::Error for Error {}
/// LLVM performs instruction construction and text serialization.
pub fn emit(program: &Program) -> Result<String, Error> {
    let context = Context::create();
    Ok(lower(&context, program)?.print_to_string().to_string())
}
/// Build a verified module without serialization. The context owns its lifetime.
pub fn lower<'ctx>(context: &'ctx Context, program: &Program) -> Result<Module<'ctx>, Error> {
    let module = context.create_module("jai");
    let word = context.i64_type();
    let bit = context.bool_type();
    let globals: Vec<_> = program
        .globals()
        .iter()
        .enumerate()
        .map(|(index, global)| match global {
            Global::Int { initializer, .. } => {
                let value = module.add_global(word, None, &format!("jai.g{index}"));
                value.set_initializer(&word.const_int(*initializer as u64, true));
                Slot::Int(IntSlot(value.as_pointer_value()))
            }
            Global::Bool { initializer, .. } => {
                let value = module.add_global(bit, None, &format!("jai.g{index}"));
                value.set_initializer(&bit.const_int(u64::from(*initializer), false));
                Slot::Bool(BoolSlot(value.as_pointer_value()))
            }
        })
        .collect();
    // Declare signatures before bodies to support forward and recursive calls.
    let functions: Vec<_> = program
        .procedures()
        .iter()
        .map(|p| {
            let parameters: Vec<BasicMetadataTypeEnum<'ctx>> = p
                .parameters
                .iter()
                .map(|local| match local {
                    Local::Int(_) => word.into(),
                    Local::Bool(_) => bit.into(),
                })
                .collect();
            let signature = match p.return_type {
                ReturnType::Void => context.void_type().fn_type(&parameters, false),
                ReturnType::Value(ScalarType::Int) => word.fn_type(&parameters, false),
                ReturnType::Value(ScalarType::Bool) => bit.fn_type(&parameters, false),
            };
            module.add_function(&format!("jai.p{}", p.id.index()), signature, None)
        })
        .collect();
    for p in program.procedures() {
        let function = functions[p.id.index()];
        let builder = context.create_builder();
        builder.position_at_end(context.append_basic_block(function, "entry"));
        let mut slots = Vec::with_capacity(p.locals.len());
        for local in &p.locals {
            slots.push(match local {
                Local::Int(_) => Slot::Int(IntSlot(builder.build_alloca(word, "local")?)),
                Local::Bool(_) => Slot::Bool(BoolSlot(builder.build_alloca(bit, "local")?)),
            });
        }
        for (parameter, local) in function.get_param_iter().zip(&p.parameters) {
            let pointer = match slots[local_index(*local)] {
                Slot::Int(slot) => slot.0,
                Slot::Bool(slot) => slot.0,
            };
            builder.build_store(pointer, parameter)?;
        }
        let mut g = Generator {
            context,
            builder,
            function,
            functions: &functions,
            slots,
            globals: &globals,
            word,
            bit,
            loops: Vec::new(),
            cleanups: &p.cleanups,
        };
        g.block(&p.body)?;
        if p.body.flow == Flow::FallsThrough {
            g.builder.build_return(None)?;
        }
    }
    let main = module.add_function("main", context.i32_type().fn_type(&[], false), None);
    let builder = context.create_builder();
    builder.position_at_end(context.append_basic_block(main, "entry"));
    let status = match program.entry() {
        EntryPoint::Void(id) => {
            builder.build_call(functions[id.index()], &[], "")?;
            context.i32_type().const_zero()
        }
        EntryPoint::Int(id) => {
            let call = builder.build_call(functions[id.index()], &[], "result")?;
            builder.build_int_truncate(call_int(call)?, context.i32_type(), "status")?
        }
    };
    builder.build_return(Some(&status))?;
    module.verify().map_err(Error::Verification)?;
    Ok(module)
}
#[derive(Clone, Copy)]
struct LoopBlocks<'ctx> {
    id: LoopId,
    next: BasicBlock<'ctx>,
    end: BasicBlock<'ctx>,
}
// LLVM uses IntValue for both i64 and i1; keep language widths distinct.
#[derive(Clone, Copy)]
struct Word<'ctx>(IntValue<'ctx>);
#[derive(Clone, Copy)]
struct Bit<'ctx>(IntValue<'ctx>);
#[derive(Clone, Copy)]
struct IntSlot<'ctx>(PointerValue<'ctx>);
#[derive(Clone, Copy)]
struct BoolSlot<'ctx>(PointerValue<'ctx>);
#[derive(Clone, Copy)]
enum Slot<'ctx> {
    Int(IntSlot<'ctx>),
    Bool(BoolSlot<'ctx>),
}
enum Destination<'ctx> {
    ReturnVoid,
    ReturnInt(Word<'ctx>),
    ReturnBool(Bit<'ctx>),
    Branch(BasicBlock<'ctx>),
}
enum Logical {
    And,
    Or,
}
fn local_index(local: Local) -> usize {
    match local {
        Local::Int(id) => id.index(),
        Local::Bool(id) => id.index(),
    }
}
fn int_value(value: BasicValueEnum<'_>) -> Result<IntValue<'_>, Error> {
    match value {
        BasicValueEnum::IntValue(value) => Ok(value),
        _ => Err(Error::Invariant),
    }
}
fn call_int(call: CallSiteValue<'_>) -> Result<IntValue<'_>, Error> {
    int_value(call.try_as_basic_value().basic().ok_or(Error::Invariant)?)
}
struct Generator<'ctx, 'functions> {
    context: &'ctx Context,
    builder: Builder<'ctx>,
    function: FunctionValue<'ctx>,
    functions: &'functions [FunctionValue<'ctx>],
    slots: Vec<Slot<'ctx>>,
    word: IntType<'ctx>,
    bit: IntType<'ctx>,
    loops: Vec<LoopBlocks<'ctx>>,
    cleanups: &'functions [Block],
    globals: &'functions [Slot<'ctx>],
}
impl<'ctx> Generator<'ctx, '_> {
    fn label(&self, name: &str) -> BasicBlock<'ctx> {
        self.context.append_basic_block(self.function, name)
    }
    fn int_slot(&self, id: IntLocal) -> Result<IntSlot<'ctx>, Error> {
        self.int_place(IntPlace::Local(id))
    }
    fn int_place(&self, place: IntPlace) -> Result<IntSlot<'ctx>, Error> {
        let slot = match place {
            IntPlace::Local(id) => self.slots.get(id.index()),
            IntPlace::Global(id) => self.globals.get(id.index()),
        };
        match slot {
            Some(Slot::Int(slot)) => Ok(*slot),
            _ => Err(Error::Invariant),
        }
    }
    fn bool_slot(&self, id: jai_sema::BoolLocal) -> Result<BoolSlot<'ctx>, Error> {
        self.bool_place(BoolPlace::Local(id))
    }
    fn bool_place(&self, place: BoolPlace) -> Result<BoolSlot<'ctx>, Error> {
        let slot = match place {
            BoolPlace::Local(id) => self.slots.get(id.index()),
            BoolPlace::Global(id) => self.globals.get(id.index()),
        };
        match slot {
            Some(Slot::Bool(slot)) => Ok(*slot),
            _ => Err(Error::Invariant),
        }
    }
    fn block(&mut self, block: &Block) -> Result<(), Error> {
        for statement in &block.statements {
            match statement {
                Statement::StoreInt(id, e) => {
                    let v = self.int(e)?;
                    self.builder.build_store(self.int_place(*id)?.0, v.0)?;
                }
                Statement::StoreBool(id, e) => {
                    let v = self.boolean(e)?;
                    self.builder.build_store(self.bool_place(*id)?.0, v.0)?;
                }
                Statement::Exit(exit) => self.exit(exit)?,
                Statement::Cleanup(id) => self.cleanup(*id)?,
                Statement::DiscardInt(e) => {
                    self.int(e)?;
                }
                Statement::DiscardBool(e) => {
                    self.boolean(e)?;
                }
                Statement::CallVoid(call) => {
                    self.call(call)?;
                }
                Statement::Block(block) => self.block(block)?,
                Statement::If(condition, yes, no) => {
                    let c = self.boolean(condition)?;
                    let y = self.label("if.yes");
                    let n = self.label("if.no");
                    // Both terminating arms need no join block.
                    let join = (yes.flow == Flow::FallsThrough || no.flow == Flow::FallsThrough)
                        .then(|| self.label("if.end"));
                    self.builder.build_conditional_branch(c.0, y, n)?;
                    for (label, block) in [(y, yes), (n, no)] {
                        self.builder.position_at_end(label);
                        self.block(block)?;
                        if block.flow == Flow::FallsThrough {
                            self.builder
                                .build_unconditional_branch(join.ok_or(Error::Invariant)?)?;
                        }
                    }
                    if let Some(join) = join {
                        self.builder.position_at_end(join);
                    }
                }
                Statement::Range(range) => self.range(range)?,
                Statement::While {
                    id,
                    condition,
                    body,
                } => {
                    let test = self.label("while.test");
                    let inside = self.label("while.body");
                    let end = self.label("while.end");
                    self.builder.build_unconditional_branch(test)?;
                    self.builder.position_at_end(test);
                    let c = self.loop_condition(condition)?;
                    self.builder.build_conditional_branch(c.0, inside, end)?;
                    self.builder.position_at_end(inside);
                    self.loops.push(LoopBlocks {
                        id: *id,
                        next: test,
                        end,
                    });
                    self.block(body)?;
                    self.loops.pop();
                    if body.flow == Flow::FallsThrough {
                        self.builder.build_unconditional_branch(test)?;
                    }
                    self.builder.position_at_end(end);
                }
            }
        }
        Ok(())
    }
    fn cleanup(&mut self, id: CleanupId) -> Result<(), Error> {
        let block = self.cleanups.get(id.index()).ok_or(Error::Invariant)?;
        self.block(block)
    }
    fn exit(&mut self, exit: &Exit) -> Result<(), Error> {
        // Snapshot the return value before cleanup can mutate its source locals.
        let destination = match &exit.transfer {
            Transfer::ReturnVoid => Destination::ReturnVoid,
            Transfer::ReturnInt(e) => Destination::ReturnInt(self.int(e)?),
            Transfer::ReturnBool(e) => Destination::ReturnBool(self.boolean(e)?),
            Transfer::Break(id) | Transfer::Continue(id) => {
                let target = self
                    .loops
                    .iter()
                    .rev()
                    .find(|l| l.id == *id)
                    .ok_or(Error::Invariant)?;
                Destination::Branch(match exit.transfer {
                    Transfer::Break(_) => target.end,
                    Transfer::Continue(_) => target.next,
                    _ => return Err(Error::Invariant),
                })
            }
        };
        for id in &exit.cleanups {
            self.cleanup(*id)?;
        }
        match destination {
            Destination::ReturnVoid => {
                self.builder.build_return(None)?;
            }
            Destination::ReturnInt(value) => {
                self.builder.build_return(Some(&value.0))?;
            }
            Destination::ReturnBool(value) => {
                self.builder.build_return(Some(&value.0))?;
            }
            Destination::Branch(block) => {
                self.builder.build_unconditional_branch(block)?;
            }
        }
        Ok(())
    }
    fn loop_condition(&mut self, condition: &LoopCondition) -> Result<Bit<'ctx>, Error> {
        match condition {
            LoopCondition::Value(e) => self.boolean(e),
            LoopCondition::BoundInt(id, e) => {
                let value = self.int(e)?;
                self.builder.build_store(self.int_slot(*id)?.0, value.0)?;
                Ok(Bit(self.builder.build_int_compare(
                    IntPredicate::NE,
                    value.0,
                    self.word.const_zero(),
                    "while.truth",
                )?))
            }
            LoopCondition::BoundBool(id, e) => {
                let value = self.boolean(e)?;
                self.builder.build_store(self.bool_slot(*id)?.0, value.0)?;
                Ok(value)
            }
        }
    }
    fn range(&mut self, range: &RangeLoop) -> Result<(), Error> {
        let start = self.int(&range.start)?.0;
        let end = self.int(&range.end)?.0;
        let slot = self.int_slot(range.iterator)?.0;
        let (first, last, done_predicate) = match range.direction {
            Direction::Forward => (start, end, IntPredicate::SGE),
            Direction::Reverse => (end, start, IntPredicate::SLE),
        };
        let inside = self.label("range.body");
        let step = self.label("range.step");
        let advance = self.label("range.advance");
        let after = self.label("range.end");
        self.builder.build_store(slot, first)?;
        let nonempty =
            self.builder
                .build_int_compare(IntPredicate::SLE, start, end, "range.nonempty")?;
        self.builder
            .build_conditional_branch(nonempty, inside, after)?;
        self.builder.position_at_end(inside);
        self.loops.push(LoopBlocks {
            id: range.id,
            next: step,
            end: after,
        });
        self.block(&range.body)?;
        self.loops.pop();
        if range.body.flow == Flow::FallsThrough {
            self.builder.build_unconditional_branch(step)?;
        }
        self.builder.position_at_end(step);
        let current = int_value(self.builder.build_load(self.word, slot, "range.current")?)?;
        // Test before advancing: inclusive MAX/MIN endpoints cannot wrap the iterator.
        let done = self
            .builder
            .build_int_compare(done_predicate, current, last, "range.done")?;
        self.builder
            .build_conditional_branch(done, after, advance)?;
        self.builder.position_at_end(advance);
        let one = self.word.const_int(1, false);
        let next = match range.direction {
            Direction::Forward => self.builder.build_int_add(current, one, "range.next")?,
            Direction::Reverse => self.builder.build_int_sub(current, one, "range.next")?,
        };
        self.builder.build_store(slot, next)?;
        self.builder.build_unconditional_branch(inside)?;
        self.builder.position_at_end(after);
        Ok(())
    }
    fn call(&mut self, call: &Call) -> Result<CallSiteValue<'ctx>, Error> {
        let mut args: Vec<BasicMetadataValueEnum<'ctx>> = Vec::with_capacity(call.arguments.len());
        for argument in &call.arguments {
            args.push(match argument {
                ValueExpr::Int(e) => self.int(e)?.0.into(),
                ValueExpr::Bool(e) => self.boolean(e)?.0.into(),
            });
        }
        let f = self.functions[call.procedure.index()];
        let name = if f.get_type().get_return_type().is_some() {
            "call"
        } else {
            ""
        };
        Ok(self.builder.build_call(f, &args, name)?)
    }
    fn int(&mut self, e: &IntExpr) -> Result<Word<'ctx>, Error> {
        Ok(Word(match e {
            IntExpr::Constant(n) => self.word.const_int(*n as u64, true),
            IntExpr::FromBool(e) => {
                let v = self.boolean(e)?;
                self.builder
                    .build_int_z_extend(v.0, self.word, "cast.int")?
            }
            IntExpr::Load(id) => int_value(self.builder.build_load(
                self.word,
                self.int_place(*id)?.0,
                "load.int",
            )?)?,
            IntExpr::Call(call) => call_int(self.call(call)?)?,
            IntExpr::Conditional(e) => {
                let [(yes, yes_end), (no, no_end)] = self.conditional_values(e, Self::int)?;
                let phi = self.builder.build_phi(self.word, "ifx.int")?;
                phi.add_incoming(&[(&yes.0, yes_end), (&no.0, no_end)]);
                int_value(phi.as_basic_value())?
            }
            IntExpr::Negate(e) => {
                let v = self.int(e)?;
                self.builder.build_int_neg(v.0, "negate")?
            }
            IntExpr::Complement(e) => {
                let v = self.int(e)?;
                self.builder.build_not(v.0, "complement")?
            }
            IntExpr::Binary(op, lhs, rhs) => {
                let lhs = self.int(lhs)?.0;
                let rhs = self.int(rhs)?.0;
                match op {
                    IntOp::Add => self.builder.build_int_add(lhs, rhs, "add")?,
                    IntOp::Subtract => self.builder.build_int_sub(lhs, rhs, "subtract")?,
                    IntOp::Multiply => self.builder.build_int_mul(lhs, rhs, "multiply")?,
                    IntOp::Divide => self.builder.build_int_signed_div(lhs, rhs, "divide")?,
                    IntOp::Remainder => self.builder.build_int_signed_rem(lhs, rhs, "remainder")?,
                    IntOp::BitAnd => self.builder.build_and(lhs, rhs, "and")?,
                    IntOp::BitOr => self.builder.build_or(lhs, rhs, "or")?,
                    IntOp::BitXor => self.builder.build_xor(lhs, rhs, "xor")?,
                    IntOp::ShiftLeft => self.builder.build_left_shift(lhs, rhs, "shift.left")?,
                    IntOp::ShiftRight => {
                        self.builder
                            .build_right_shift(lhs, rhs, true, "shift.right")?
                    }
                }
            }
        }))
    }
    fn boolean(&mut self, e: &BoolExpr) -> Result<Bit<'ctx>, Error> {
        Ok(Bit(match e {
            BoolExpr::Constant(b) => self.bit.const_int(u64::from(*b), false),
            BoolExpr::FromInt(e) => {
                let v = self.int(e)?;
                self.builder.build_int_compare(
                    IntPredicate::NE,
                    v.0,
                    self.word.const_zero(),
                    "truthiness",
                )?
            }
            BoolExpr::Load(id) => int_value(self.builder.build_load(
                self.bit,
                self.bool_place(*id)?.0,
                "load.bool",
            )?)?,
            BoolExpr::Call(call) => call_int(self.call(call)?)?,
            BoolExpr::Conditional(e) => {
                let [(yes, yes_end), (no, no_end)] = self.conditional_values(e, Self::boolean)?;
                let phi = self.builder.build_phi(self.bit, "ifx.bool")?;
                phi.add_incoming(&[(&yes.0, yes_end), (&no.0, no_end)]);
                int_value(phi.as_basic_value())?
            }
            BoolExpr::Not(e) => {
                let v = self.boolean(e)?;
                self.builder.build_not(v.0, "not")?
            }
            BoolExpr::CompareInts(op, lhs, rhs) => {
                let lhs = self.int(lhs)?.0;
                let rhs = self.int(rhs)?.0;
                let pred = match op {
                    Relation::Equal => IntPredicate::EQ,
                    Relation::NotEqual => IntPredicate::NE,
                    Relation::Less => IntPredicate::SLT,
                    Relation::LessEqual => IntPredicate::SLE,
                    Relation::Greater => IntPredicate::SGT,
                    Relation::GreaterEqual => IntPredicate::SGE,
                };
                self.builder
                    .build_int_compare(pred, lhs, rhs, "compare.int")?
            }
            BoolExpr::CompareBools(op, lhs, rhs) => {
                let lhs = self.boolean(lhs)?.0;
                let rhs = self.boolean(rhs)?.0;
                let pred = match op {
                    Equality::Equal => IntPredicate::EQ,
                    Equality::NotEqual => IntPredicate::NE,
                };
                self.builder
                    .build_int_compare(pred, lhs, rhs, "compare.bool")?
            }
            BoolExpr::And(lhs, rhs) => self.short_circuit(lhs, rhs, Logical::And)?.0,
            BoolExpr::Or(lhs, rhs) => self.short_circuit(lhs, rhs, Logical::Or)?.0,
        }))
    }
    fn conditional_values<T, V>(
        &mut self,
        expression: &Conditional<T>,
        emit: fn(&mut Self, &T) -> Result<V, Error>,
    ) -> Result<[(V, BasicBlock<'ctx>); 2], Error> {
        let condition = self.boolean(&expression.condition)?;
        let yes = self.label("ifx.then");
        let no = self.label("ifx.else");
        let join = self.label("ifx.end");
        self.builder
            .build_conditional_branch(condition.0, yes, no)?;
        self.builder.position_at_end(yes);
        let then_value = emit(self, &expression.then_value)?;
        let then_end = self.builder.get_insert_block().ok_or(Error::Invariant)?;
        self.builder.build_unconditional_branch(join)?;
        self.builder.position_at_end(no);
        let else_value = emit(self, &expression.else_value)?;
        let else_end = self.builder.get_insert_block().ok_or(Error::Invariant)?;
        self.builder.build_unconditional_branch(join)?;
        self.builder.position_at_end(join);
        Ok([(then_value, then_end), (else_value, else_end)])
    }
    fn short_circuit(
        &mut self,
        lhs: &BoolExpr,
        rhs: &BoolExpr,
        op: Logical,
    ) -> Result<Bit<'ctx>, Error> {
        let lhs = self.boolean(lhs)?;
        let left_end = self.builder.get_insert_block().ok_or(Error::Invariant)?;
        let right = self.label("logical.rhs");
        let join = self.label("logical.end");
        let (yes, no, bypass) = match op {
            Logical::And => (right, join, false),
            Logical::Or => (join, right, true),
        };
        self.builder.build_conditional_branch(lhs.0, yes, no)?;
        self.builder.position_at_end(right);
        let rhs = self.boolean(rhs)?;
        let right_end = self.builder.get_insert_block().ok_or(Error::Invariant)?;
        self.builder.build_unconditional_branch(join)?;
        self.builder.position_at_end(join);
        let phi = self.builder.build_phi(self.bit, "logical.value")?;
        let bypass = self.bit.const_int(u64::from(bypass), false);
        phi.add_incoming(&[(&bypass, left_end), (&rhs.0, right_end)]);
        Ok(Bit(int_value(phi.as_basic_value())?))
    }
}
