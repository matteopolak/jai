#module_parameters(VERBOSE := true)();

#import "Basic";

Remap_Context :: () #expand {
    `push_context, defer_pop remap_context();
}

remap_context :: () -> (result: #Context) {
    if context.context_info == type_info(#Context) return context;
    return remap_context(*context, context.context_info);
}

remap_context :: (foreign_context: *void, foreign_type: *Type_Info_Struct) -> (result: #Context) {
    assert(foreign_context != null && foreign_type != null, "invalid foreign context");
    #if VERBOSE write_string("Remap_Context: matching context fields\n");
    result: #Context;
    remap_fields(*result, type_info(#Context), foreign_context, foreign_type);
    result.context_info = type_info(#Context);
    return result;
}

#scope_module
remap_fields :: (destination: *void, target: *Type_Info_Struct, source: *void, foreign: *Type_Info_Struct) {
    for wanted: target.members {
        if wanted.offset_in_bytes < 0 continue;
        for candidate: foreign.members {
            if candidate.offset_in_bytes < 0 || candidate.name != wanted.name continue;
            dst := destination + wanted.offset_in_bytes;
            src := source + candidate.offset_in_bytes;
            if wanted.name == "base" && wanted.type.type == .STRUCT && candidate.type.type == .STRUCT {
                remap_fields(dst, cast(*Type_Info_Struct) wanted.type, src, cast(*Type_Info_Struct) candidate.type);
            } else if wanted.type.runtime_size == candidate.type.runtime_size && wanted.type.runtime_size >= 0 {
                memcpy(dst, src, wanted.type.runtime_size);
            }
            break;
        }
    }
}
