// Current reviewed Basic operators, including use through Apollo_Time isa S128.
using #import "Basic";

main :: () {
    a: S128 = .{ low = 0xffffffffffffffff, high = 0 };
    b: S128 = .{ low = 1, high = 0 };
    sum := a + b;

    assert(sum.low == 0 && sum.high == 1);
    negative := b - sum;

    assert(negative.low == 1 && negative.high == -1);
    u: U128 = .{ low = 0, high = 1 };
    v: U128 = .{ low = 1, high = 0 };
    difference := u - v;

    assert(difference.low == 0xffffffffffffffff && difference.high == 0);
    earlier := seconds_to_apollo(1);
    later := seconds_to_apollo(3);
    elapsed := later - earlier;
    seconds, valid := to_seconds(elapsed);

    assert(valid && seconds == 2);
    restored := earlier + elapsed;

    assert(compare_apollo_times(restored, later) == 0);
    print("ok\n");
}
