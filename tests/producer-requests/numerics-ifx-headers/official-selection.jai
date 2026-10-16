#import "Basic";

f :: (x := 3) -> s64 {
    return x;
}

g :: (x := 4) -> s64 {
    return x;
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

main :: () {}

#run {
    print("ORACLE choose % % reverse % % mutate % %\n", choose(true), choose(false), reverse(true), reverse(false), mutate(true), mutate(false));
}
