// General compiler gap: reviewed bootstrap atomic intrinsics are declared but
// not recognized by the current source compiler. Do not replace these aliases
// with separately named wrapper procedures or count them as verified support.
#import "Basic";

main :: () {
    value: u32;
    atomic_store(*value, 9);
    assert(atomic_load(*value) == 9);
    assert(atomic_exchange(*value, 4) == 9 && value == 4);
}
