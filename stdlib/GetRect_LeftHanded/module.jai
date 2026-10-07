// Left-handed (y-down) GetRect: same API as GetRect with a downward-positive vertical axis.
// Shared implementation lives in ../GetRect_Common; see docs/stdlib/getrect.md.
#module_parameters ()(Type_Indicator: Type = void);

Math :: #import "Math";

using Math;

Basic :: #import "Basic";

#scope_module
GETRECT_Y_UP :: false;

#scope_export
#load "../GetRect_Common/ui.jai";
#load "../GetRect_Common/geometry.jai";

// Exported here (unlike GetRect, where geometry-helpers.jai keeps them module-private).
move_toward :: (a: float, b: float, amount_increasing: float, amount_decreasing := -1.0) -> float {
    falling := amount_decreasing;
    if falling < 0 falling = amount_increasing;
    if b > a return Math.min(b, a + amount_increasing);
    return Math.max(b, a - falling);
}

move_toward :: (a_pointer: *float, target: float, dt: float, rate_up: float, rate_down: float = -1.0) {
    falling := rate_down;
    if falling < 0 falling = rate_up;
    a_pointer.* = move_toward(a_pointer.*, target, dt * rate_up, dt * falling);
}

v2 :: xy;
v3 :: xyz;
v4 :: xyzw;

fract :: inline (x: float) -> float {
    return Math.frac(x);
}
