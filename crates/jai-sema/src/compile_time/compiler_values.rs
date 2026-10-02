//! Private staging for native captures selected by a compiler-only Code plan.
//! The caller invokes this while the plan's sole publication journal is open.
use super::{
    CompilerEffects, ConstantValue, Limits, ProcedureProvider, TypeId, TypeView, Value, Vm,
};

pub(crate) fn materialize_compiler_capture<P, E>(
    vm: &Vm<'_, P, E>,
    types: &dyn TypeView,
    ty: TypeId,
    value: &Value,
    limits: Limits,
) -> Result<ConstantValue, jai_vm::Error>
where
    P: ProcedureProvider + ?Sized,
    E: CompilerEffects,
{
    super::materializable_type(types, ty, limits.evaluation_depth)?;
    // This verifies stored aggregate images and address provenance and copies
    // sequence views into owned values while VM memory remains available.
    let value = vm.materialize_value(value)?;
    super::materialize_with_runtime_types(types, value, ty, limits.evaluation_depth, &mut |value| {
        vm.runtime_type_constant_value(value)
    })
}
