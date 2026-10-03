//! Apply real declaration attributes to the same nominal record policy.
use jai_types::{RecordReflectionFlag, RecordReflectionPolicy, TypeError, TypeId, TypeRegistry};

/// Source attributes are fixed facts of this checked record definition. They
/// change descriptor metadata, while its physical fields and layout stay intact.
pub(crate) fn apply_source_record_attributes(
    types: &mut TypeRegistry,
    record: TypeId,
    attributes: &[jai_syntax::RecordAttribute],
) -> Result<(), TypeError> {
    if attributes
        .iter()
        .any(|attribute| matches!(attribute, jai_syntax::RecordAttribute::TypeInfoNone))
    {
        types.add_record_reflection_flags(
            record,
            RecordReflectionPolicy::from_flags([RecordReflectionFlag::NoTypeInfo]),
        )?;
    }
    Ok(())
}
