use super::*;
use jai_types::{CallingConvention, ContextMode, IntegerType, TypeRegistry, Variadic};

#[test]
fn code_address_truth_and_incoming_values_revalidate_the_owning_ledger() {
    let mut types = TypeRegistry::new();
    let signature = types
        .procedure(ProcedureType {
            parameters: Box::new([]),
            results: Box::new([]),
            convention: CallingConvention::Jai,
            context: ContextMode::None,
            variadic: Variadic::None,
        })
        .unwrap();
    let opaque_pointer = types.pointer(types.void()).unwrap();
    let id = ProcedureId::new(0);
    let library = ProgramBuilder::new(types.freeze().unwrap())
        .procedures(vec![Procedure {
            id,
            signature,
            parameters: vec![],
            locals: vec![],
            body: Block {
                statements: vec![],
                flow: Flow::FallsThrough,
            },
            cleanups: vec![],
        }])
        .finish_library()
        .unwrap();
    let mut vm = Vm::new(&library, crate::NoEffects, Limits::default()).unwrap();
    let before = vm.memory.snapshot();
    let callable = Value::Procedure {
        signature,
        procedure: Some(id),
    };
    let cell = vm
        .memory
        .allocate(library.types(), signature, Some(callable))
        .unwrap();
    let view = vm
        .memory
        .cast_pointer(library.types(), &cell, opaque_pointer, CastMode::Checked)
        .unwrap();
    let pointer = vm
        .memory
        .load(library.types(), &view)
        .unwrap()
        .pointer()
        .unwrap()
        .clone();
    vm.memory.release(&cell).unwrap();
    let number = vm
        .memory
        .pointer_to_integer(
            library.types(),
            &pointer,
            IntegerType::U64,
            CastMode::Checked,
        )
        .unwrap();
    assert!(vm.pointer_truth(&pointer).unwrap());
    assert!(vm.number_truth(&number).unwrap());
    assert_eq!(vm.memory.allocation_count(), 0);
    vm.memory.restore(before);
    assert!(matches!(
        vm.pointer_truth(&pointer),
        Err(Halt::Failed(Error::DanglingPointer))
    ));
    assert!(matches!(
        vm.number_truth(&number),
        Err(Halt::Failed(Error::DanglingPointer))
    ));
    for value in [Value::Pointer(pointer), number.into_value()] {
        assert_eq!(
            vm.memory
                .validate_runtime_type_values(library.types(), &value),
            Err(Error::DanglingPointer)
        );
    }
}
