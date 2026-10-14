#import "Basic";
H :: #import "Hash";
HT :: #import "Hash_Table";

Signed :: enum s8 {
    LOW :: -1;
    HIGH :: 42;
}

main :: () {
    assert(H.get_hash(cast(u64) 0) == 2752616464);
    assert(H.get_hash(cast(u64) 1) == 98180695);
    assert(H.get_hash(cast(u64) 42) == 2569769087);
    assert(H.get_hash(cast(s64) -1) == 3182882357);
    assert(H.get_hash(cast(s8) -1) == H.get_hash(cast(s64) -1));
    assert(H.get_hash(cast(s32) -1) == H.get_hash(cast(s64) -1));
    assert(H.get_hash(false) == H.get_hash(cast(u64) 0));
    assert(H.get_hash(true) == H.get_hash(cast(u64) 1));
    assert(H.get_hash(Signed.LOW) == H.get_hash(cast(s64) -1));
    assert(H.get_hash(Signed.HIGH) == H.get_hash(cast(u64) 42));
    pointer := cast(*void) 0x1234;

    assert(H.get_hash(pointer) == H.get_hash(cast(u64) 0x1234));
    assert(H.get_hash(cast(u64) 0, 0) == 0);
    assert(H.get_hash(cast(u64) 1, 0) == 2654435769);
    assert(H.get_hash(cast(u64) 42, 7) == 3485492635);
    table: HT.Table(s64, string);

    defer HT.table_reset(*table);
    for i: -128..128 HT.table_add(*table, i, "value");

    for i: -128..128 {
        found, value := HT.table_find(*table, i);
        assert(found && value == "value");
    }

    for i: -128..0 {
        removed, value := HT.table_remove(*table, i);
        assert(removed && value == "value");
        assert(!HT.table_contains(*table, i));
    }

    for i: 1..128 assert(HT.table_contains(*table, i));

    assert(table.count == 128);
    print("ok\n");
}
