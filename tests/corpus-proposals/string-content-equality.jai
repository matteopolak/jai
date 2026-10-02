main :: () -> int {
    a := "a\0b";
    b := "a\0b";
    c := "a";
    if a == b && a != c return 22;
    return 1;
}
