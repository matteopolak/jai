#import "Basic";

f :: (x := 3) -> s64 {
    return 100 + x;
}

g :: (x := 4) -> s64 {
    return 200 + x;
}

choose :: (flag: bool) -> s64 {
    h := ifx flag then f else g;
    return h();
}

reverse :: (flag: bool) -> s64 {
    h := ifx flag then g else f;
    return h();
}

mutate :: (flag: bool) -> s64 {
    h := ifx flag then f else g;
    flag = !flag;
    return h();
}

named :: (flag: bool) -> s64 {
    h := ifx flag then f else g;
    return h(x = 9);
}

typed :: (flag: bool) -> s64 {
    Callback :: (value := 11) -> s64;
    h: Callback = ifx flag then f else g;
    return h();
}

main :: () {
    assert(choose(true) == 104 && choose(false) == 204);
    assert(reverse(true) == 203 && reverse(false) == 103);
    assert(mutate(true) == 104 && mutate(false) == 204);
    assert(named(true) == 109 && named(false) == 209);
    assert(typed(true) == 111 && typed(false) == 211);
    direct := f;

    assert(direct() == 103);
    print("ok\n");
}
