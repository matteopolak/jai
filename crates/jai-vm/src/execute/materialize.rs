use super::*;

impl<P: ProcedureProvider + ?Sized, E: CompilerEffects> Vm<'_, P, E> {
    /// Copy virtual string views into owned bytes for compiler effects and publication.
    /// Pointer, array and slice identities otherwise remain unchanged.
    pub fn materialize_value(&self, value: &Value) -> std::result::Result<Value, Error> {
        let mut budget = MaterializationBudget::new(self.limits);
        self.materialize_inner(value, 0, &mut budget)
    }

    /// Materialize effect arguments under one output and traversal budget.
    pub fn materialize_values(&self, values: &[Value]) -> std::result::Result<Vec<Value>, Error> {
        let mut budget = MaterializationBudget::new(self.limits);
        values
            .iter()
            .map(|value| self.materialize_inner(value, 0, &mut budget))
            .collect()
    }

    fn materialize_inner(
        &self,
        value: &Value,
        depth: usize,
        budget: &mut MaterializationBudget,
    ) -> std::result::Result<Value, Error> {
        if depth > self.limits.evaluation_depth.min(256) {
            return Err(Error::Limit(LimitKind::EvaluationDepth));
        }
        budget.reserve(1)?;
        Ok(match value {
            Value::StoredAggregate(snapshot) => {
                budget.reserve(snapshot.storage_cells())?;
                if let Some(semantic) = snapshot.decoded_semantic() {
                    budget.charge_work(semantic.cells(self.limits.value_cells)?)?;
                }
                let semantic = snapshot
                    .publication_semantic(self.provider.types(), self.limits.value_cells)?;
                self.materialize_inner(semantic, depth + 1, budget)?
            }
            Value::Type {
                descriptor: Some(pointer),
            } => {
                budget.reserve(pointer.metadata_cells())?;
                self.runtime_type_identity(value)?;
                value.clone()
            }
            Value::Pointer(pointer) | Value::Slice { pointer, .. } => {
                budget.reserve(pointer.metadata_cells())?;
                value.clone()
            }
            Value::DynamicArray {
                ty,
                pointer,
                count,
                allocated,
                allocator,
            } => {
                budget.reserve(pointer.metadata_cells())?;
                Value::DynamicArray {
                    ty: *ty,
                    pointer: pointer.clone(),
                    count: *count,
                    allocated: *allocated,
                    allocator: allocator
                        .as_deref()
                        .map(|value| {
                            self.materialize_inner(value, depth + 1, budget)
                                .map(Box::new)
                        })
                        .transpose()?,
                }
            }
            Value::AddressInteger(_) => {
                return Err(Error::UnsupportedPointerOperation(
                    "address-derived integer cannot be published as a native constant",
                ));
            }
            Value::String(bytes) => {
                budget.reserve(bytes.len())?;
                Value::String(bytes.clone())
            }
            Value::StringView { pointer, count } => {
                let count = crate::checked_sequence_count(*count)?;
                budget.reserve(count)?;
                budget.charge_work(
                    count
                        .checked_mul(pointer.metadata_cells())
                        .ok_or(Error::Limit(LimitKind::Fuel))?,
                )?;
                if count != 0 {
                    let (work, result) = self.memory.prepare_pointer_layouts(
                        self.provider.types(),
                        pointer,
                        true,
                        usize::try_from(budget.work).unwrap_or(usize::MAX),
                    );
                    budget.charge_work(work)?;
                    result?;
                }
                self.memory
                    .validate_slice(self.provider.types(), pointer, count)?;
                let mut bytes = Vec::with_capacity(count);
                for index in 0..count {
                    let offset = isize::try_from(index).map_err(|_| Error::CheckedCast)?;
                    let byte_pointer =
                        self.memory.offset(self.provider.types(), pointer, offset)?;
                    budget.charge_work(
                        self.memory
                            .load_work_cost(self.provider.types(), &byte_pointer)?,
                    )?;
                    let byte = self
                        .memory
                        .load(self.provider.types(), &byte_pointer)?
                        .number()?;
                    if byte.provenance().is_some() {
                        return Err(Error::UnsupportedPointerOperation(
                            "address-derived bytes cannot be published as native string data",
                        ));
                    }
                    if byte.ty() != jai_types::IntegerType::U8 {
                        return Err(Error::InvalidIr("string view has non-byte backing"));
                    }
                    bytes.push(u8::try_from(byte.value()).map_err(|_| Error::CheckedCast)?);
                }
                Value::String(bytes)
            }
            Value::Record { ty, fields } => Value::Record {
                ty: *ty,
                fields: fields
                    .iter()
                    .map(|field| self.materialize_inner(field, depth + 1, budget))
                    .collect::<std::result::Result<_, _>>()?,
            },
            Value::Array { ty, elements } => Value::Array {
                ty: *ty,
                elements: elements
                    .iter()
                    .map(|element| self.materialize_inner(element, depth + 1, budget))
                    .collect::<std::result::Result<_, _>>()?,
            },
            Value::Distinct { ty, value } => Value::Distinct {
                ty: *ty,
                value: Box::new(self.materialize_inner(value, depth + 1, budget)?),
            },
            Value::Union { ty, field, value } => Value::Union {
                ty: *ty,
                field: *field,
                value: Box::new(self.materialize_inner(value, depth + 1, budget)?),
            },
            value => value.clone(),
        })
    }
}

struct MaterializationBudget {
    cells: usize,
    work: u64,
}
impl MaterializationBudget {
    fn new(limits: Limits) -> Self {
        Self {
            cells: limits.value_cells,
            work: limits.fuel,
        }
    }
    fn reserve(&mut self, cells: usize) -> std::result::Result<(), Error> {
        self.cells = self
            .cells
            .checked_sub(cells)
            .ok_or(Error::Limit(LimitKind::ValueCells))?;
        self.charge_work(cells)
    }
    fn charge_work(&mut self, cells: usize) -> std::result::Result<(), Error> {
        self.work = self
            .work
            .checked_sub(u64::try_from(cells).map_err(|_| Error::Limit(LimitKind::Fuel))?)
            .ok_or(Error::Limit(LimitKind::Fuel))?;
        Ok(())
    }
}
