// Value storage with an explicit compiler-owned Type identity tag.
#module_parameters(DEBUG := false);
Tagged_Union :: struct(value_types: ..Type) {
    tag: Type;
    bytes: [NUM_VALUE_BYTES] u8;
    NUM_VALUE_BYTES: s64 : #run get_biggest_size(value_types);
}
set :: (using u: *Tagged_Union, value: $T) {
    #if DEBUG {
        #run {
            permitted := false;
            for candidate: value_types if candidate == T permitted = true;
            assert(permitted);
        }
    }
    destination := cast(*T) u.bytes.data;
    destination.* = value;
    u.tag = T;
}
isa :: (using u: Tagged_Union, $T: Type) -> *T {
    if u.tag != T return null;
    return cast(*T) u.bytes.data;
}
#scope_file
#import "Basic";
get_biggest_size :: (types: [] Type) -> s64 {
    required: s64;
    for candidate: types {
        descriptor := cast(*Type_Info) candidate;
        if descriptor.runtime_size > required required = descriptor.runtime_size;
    }
    return required;
}
