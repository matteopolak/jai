// Jai #c_call procedures taking and returning C structs by value, called from C (native only).
#import "Basic";
structs :: #library "libstructs";
#load "types.jai";

combine :: (v: V2, b: Big, s: Small) -> V2 #c_call {
    return .{v.x + xx b.a + xx s.a, v.y + xx b.d + xx s.b};
}
scale :: (b: Big, k: s32) -> Big #c_call {
    return .{b.a * k, b.b * k, b.c * k, b.d * k};
}
bump :: (s: Small) -> Small #c_call {
    return .{s.a + 1, s.b + 1};
}

main :: () {
    print("% % %\n", apply(combine, .{1, 2}, .{10, 20, 30, 40}, .{100, 5}), apply_big(scale), apply_small(bump));
}
