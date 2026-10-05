// Small math helpers, private to the module.
// GetRect_LeftHanded has always exported these, so its module.jai carries an exported copy.
#scope_module
move_toward :: (a: float, b: float, amount_increasing: float, amount_decreasing := -1.0) -> float {
    falling:=amount_decreasing;
    if falling<0 falling=amount_increasing;
    if b>a return Math.min(b,a+amount_increasing);
    return Math.max(b,a-falling);
}
move_toward :: (a_pointer: *float, target: float, dt: float, rate_up: float, rate_down: float = -1.0) {
    falling:=rate_down; if falling<0 falling=rate_up;
    a_pointer.*=move_toward(a_pointer.*,target,dt*rate_up,dt*falling);
}
v2 :: xy;
v3 :: xyz;
v4 :: xyzw;
fract :: inline (x: float) -> float { return Math.frac(x); }
