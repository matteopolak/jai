Pair :: struct { number: int; }
main :: () -> int {
    p: Pair;
    p.number = 19;
    { using p; number += 3; }
    return p.number;
}
