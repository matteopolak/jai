Pair :: struct { first: s32; second: u8; }
main :: () -> int {
    info := type_info(Pair);
    if info.members.count != 2 return 1;
    if info.members[0].name[0] != #char "f" return 2;
    return info.members[1].offset_in_bytes + 38;
}
