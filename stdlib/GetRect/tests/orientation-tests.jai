// Loads actual production math without constructing a renderer or native window.
Math :: #import "Math";
#import "Math";
// GetRect's own setting: the shared files test it in procedures this program also checks.
GETRECT_Y_UP :: true;
#load "../../GetRect_Common/geometry.jai";
#load "../../GetRect_Common/orientation.jai";
right_orientation_cases :: () -> bool {
    r := get_rect(10, 20, 100, 80);
    top, divider, bottom := right_divider_rects(r, false, 0.25, 8);
    if top.y != 82 || top.h != 18 || divider.y != 74 || divider.h != 8 || bottom.y != 20 || bottom.h != 54 return false;
    left, vertical, right := right_divider_rects(r, true, 0.25, 8);
    if left.x != 10 || left.w != 23 || vertical.x != 33 || right.x != 41 || right.w != 69 return false;
    all, thin, none := right_divider_rects(r, false, 1, 800);
    if all.h != 0 || thin.h != 80 || thin.y != 20 || none.h != 0 return false;
    bar := get_rect(110, 20, 10, 80);
    first := right_scroll_nib(bar, true, 80, 320, 0, 1);
    last := right_scroll_nib(bar, true, 80, 320, 240, 1);
    middle := right_scroll_nib(bar, true, 80, 320, 120, 1);
    if first.y != 80 || first.h != 20 || last.y != 20 || middle.y != 50 return false;
    if right_scroll_fraction(bar, true, 20, 90) != 0 || right_scroll_fraction(bar, true, 20, 30) != 1 || right_scroll_fraction(bar, true, 20, 60) != 0.5 return false;
    title, content := right_subwindow_rects(r, 20, 5, 4);
    if title.y != 80 || title.h != 20 || content.y != 24 || content.h != 52 || content.x != 15 || content.w != 90 return false;
    resized := right_resize_edges(r, xy(0, 15), false, false, false, true, 20, 10);
    if resized.y != 35 || resized.h != 65 || resized.y + resized.h != 100 return false;
    clamped := right_resize_edges(r, xy(200, 200), true, false, false, true, 20, 10);
    if clamped.x != 90 || clamped.w != 20 || clamped.y != 90 || clamped.h != 10 return false;
    extended := right_resize_edges(r, xy(0, 15), false, false, true, false, 20, 10);
    if extended.y != 20 || extended.h != 95 return false;
    fitted := right_content_bottom(r, 44, 4, 20);
    if fitted.y != 40 || fitted.h != 60 || fitted.y + fitted.h != 100 return false;
    if right_flow_line_y(r, 0, 10, 0) != 90 || right_flow_line_y(r, 0, 10, 7) != 20 || right_flow_line_y(r, 5, 10, 0) != 95 return false;
    if right_flow_line_index(r, 0, 10, 95, 8) != 0 || right_flow_line_index(r, 0, 10, 25, 8) != 7 || right_flow_line_index(r, 5, 10, 95, 8) != 1 return false;
    plane := get_rect(10, 20, 80, 40);
    low := right_sv_point(plane, xy(-1, 1), false);
    high := right_sv_point(plane, xy(1, -1), false);
    if low.x != 10 || low.y != 20 || high.x != 90 || high.y != 60 return false;
    normalized := right_sv_normalized(plane, xy(70, 50), false);
    if abs(normalized.x - 0.5) > 0.00001 || abs(normalized.y + 0.5) > 0.00001 return false;
    warped := right_sv_point(plane, xy(0.5, -0.5), true);
    back := right_sv_normalized(plane, warped, true);
    if warped.x != 60 || warped.y != 50 || abs(back.x - 0.5) > 0.00001 || abs(back.y + 0.5) > 0.00001 return false;
    return true;
}
#assert #run right_orientation_cases();
// Growing and shrinking move opposite edges by the same amount, on one axis or both.
grow_shrink_cases :: () -> bool {
    r := get_rect(10, 20, 100, 80);
    e := expand(r, 4);
    if e.x != 6 || e.y != 16 || e.w != 108 || e.h != 88 return false;
    ex := expand_x(r, 4);
    if ex.x != 6 || ex.y != 20 || ex.w != 108 || ex.h != 80 return false;
    ey := expand_y(r, 4);
    if ey.x != 10 || ey.y != 16 || ey.w != 100 || ey.h != 88 return false;
    s := shrink(r, 5);
    if s.x != 15 || s.y != 25 || s.w != 90 || s.h != 70 return false;
    sx := shrink_x(r, 5);
    if sx.x != 15 || sx.y != 20 || sx.w != 90 || sx.h != 80 return false;
    sy := shrink_y(r, 5);
    if sy.x != 10 || sy.y != 25 || sy.w != 100 || sy.h != 70 return false;
    return true;
}
#assert #run grow_shrink_cases();
