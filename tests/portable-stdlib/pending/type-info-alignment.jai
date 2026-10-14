#import "Basic";

Record :: struct {
    value: u64;
}

main :: () {
    info := cast(*Type_Info_Struct) type_info(Record);
    print("alignment %; expected %\n", info.alignment, align_of(Record));
    assert(info.alignment == align_of(Record));
}
