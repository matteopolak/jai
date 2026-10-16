#import "Basic";

f :: (x := 3) -> s64 {
    return x;
}

g :: (x := 3) -> s64 {
    return x;
}

main :: () {}

#run {
    flag := false;
    h := ifx flag then f else g;
    assert(h() == 3);
}
