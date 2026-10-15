// Reviewed #type,isa is accepted where the underlying type is accepted.
using #import "Basic";

Counter :: struct {
    value: s64;
}

Stamp :: #type,isa Counter;
calls: s64;

operator + :: (a: Counter, b: Counter) -> Counter {
    calls += 1;
    return .{ value = a.value + b.value };
}

main :: () {
    a: Stamp = .{ value = 7 };
    b: Stamp = .{ value = 5 };
    result := a + b;

    assert(calls == 1);
    assert(result.value == 12);
    print("ok\n");
}
