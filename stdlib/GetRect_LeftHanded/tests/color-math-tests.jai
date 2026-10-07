#load "../../GetRect_Common/color-math.jai";
M :: #import "Math";

color_math_cases :: () -> bool {
    white := linear_srgb_to_oklab(M.Vector3.{ 1, 1, 1 });
    if M.abs(white.x - 1) > 0.0001 || M.abs(white.y) > 0.0001 || M.abs(white.z) > 0.0001 return false;
    for color: M.Vector3.[.{ 1, 0, 0 }, .{ 0, 1, 0 }, .{ 0, 0, 1 }, .{ 0.2, 0.4, 0.7 }] {
        restored := oklab_to_linear_srgb(linear_srgb_to_oklab(color));
        if M.abs(restored.x - color.x) > 0.0001 || M.abs(restored.y - color.y) > 0.0001 || M.abs(restored.z - color.z) > 0.0001 return false;
    }
    return true;
}

#assert #run color_math_cases();

main :: () {
    color_math_cases();
}
