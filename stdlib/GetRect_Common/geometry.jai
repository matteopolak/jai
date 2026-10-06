// Rectangle, hash and color helpers shared by GetRect and GetRect_LeftHanded (GETRECT_Y_UP selects the vertical axis).
Rect :: struct {
    x, y: float;
    w, h: float;
}
get_rect :: (x: float, y: float, w: float, h: float) -> Rect {
    return .{ x, y, w, h };
}
expand :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, amount, amount);
}
expand_x :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, amount, 0);
}
expand_y :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, 0, amount);
}
shrink :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, -amount, -amount);
}
shrink_x :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, -amount, 0);
}
shrink_y :: (rect: Rect, amount: float) -> Rect {
    return outset(rect, 0, -amount);
}
cut_left :: (rect: Rect, amount: float, margin := 0.0) -> (left: Rect, remainder: Rect) {
    return .{ rect.x, rect.y, amount, rect.h }, .{ rect.x + amount + margin, rect.y, rect.w - amount - margin, rect.h };
}
cut_right :: (rect: Rect, amount: float, margin := 0.0) -> (right: Rect, remainder: Rect) {
    return .{ rect.x + rect.w - amount, rect.y, amount, rect.h }, .{ rect.x, rect.y, rect.w - amount - margin, rect.h };
}
// The top edge has the largest y when y points up and the smallest when it points down.
cut_top :: (rect: Rect, amount: float, margin := 0.0) -> (top: Rect, remainder: Rect) {
    if GETRECT_Y_UP return .{ rect.x, rect.y + rect.h - amount, rect.w, amount }, .{ rect.x, rect.y, rect.w, rect.h - amount - margin };
    return .{ rect.x, rect.y, rect.w, amount }, .{ rect.x, rect.y + amount + margin, rect.w, rect.h - amount - margin };
}
cut_bottom :: (rect: Rect, amount: float, margin := 0.0) -> (bottom: Rect, remainder: Rect) {
    if GETRECT_Y_UP return .{ rect.x, rect.y, rect.w, amount }, .{ rect.x, rect.y + amount + margin, rect.w, rect.h - amount - margin };
    return .{ rect.x, rect.y + rect.h - amount, rect.w, amount }, .{ rect.x, rect.y, rect.w, rect.h - amount - margin };
}
is_inside :: (x: float, y: float, r: Rect) -> bool {
    return x >= r.x && y >= r.y && x < r.x + r.w && y < r.y + r.h;
}
intersect :: (a: Rect, b: Rect) -> Rect {
    x := Math.max(a.x, b.x);
    y := Math.max(a.y, b.y);
    right := Math.min(a.x + a.w, b.x + b.w);
    far := Math.min(a.y + a.h, b.y + b.h);
    return .{ x, y, Math.max(0.0, right - x), Math.max(0.0, far - y) };
}
bound :: (a: Rect, b: Rect) -> Rect {
    x := Math.min(a.x, b.x);
    y := Math.min(a.y, b.y);
    right := Math.max(a.x + a.w, b.x + b.w);
    far := Math.max(a.y + a.h, b.y + b.h);
    return .{ x, y, right - x, far - y };
}
get_quad :: (using r: Rect, snap_coordinates := false) -> (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) {
    x0 := x;
    x1 := x + w;
    y0 := y;
    y1 := y + h;
    if snap_coordinates {
        x0 = Math.round(x0);
        x1 = Math.round(x1);
        y0 = Math.round(y0);
        y1 = Math.round(y1);
    }
    return xy(cast(float) x0, cast(float) y0), xy(cast(float) x1, cast(float) y0), xy(cast(float) x1, cast(float) y1), xy(cast(float) x0, cast(float) y1);
}
KNUTH_GOLDEN_RATIO_64 :: 11400714819323198485;
combine_hashes :: (a: u64, b: u64) -> u64 #no_aoc {
    return (a ^ b) * KNUTH_GOLDEN_RATIO_64;
}
get_hash :: (loc: Source_Code_Location, identifier: s64) -> u64 {
    return rh_location_hash(loc, identifier);
}
#scope_module
// All six grow/shrink variants are one operation: move each edge outward by `dx`
// horizontally and `dy` vertically (negative values move the edges inward).
outset :: (rect: Rect, dx: float, dy: float) -> Rect {
    result := rect;
    result.x -= dx;
    result.y -= dy;
    result.w += dx + dx;
    result.h += dy + dy;
    return result;
}
rh_location_hash :: (loc: Source_Code_Location, identifier: s64) -> u64 #no_aoc {
    hash: u64 = 14695981039346656037;
    for byte: loc.fully_pathed_filename hash = (hash ^ byte) * 1099511628211;
    hash = combine_hashes(hash, cast(u64) loc.line_number);
    return combine_hashes(hash, cast, no_check(u64) identifier);
}

#scope_export
VBase3 :: struct {
    x, y, z: float;
}
darken :: (color: $T/interface VBase3, t: float) -> T {
    result := color;
    result.x *= 1 - t;
    result.y *= 1 - t;
    result.z *= 1 - t;
    return result;
}
whiten :: (color: $T/interface VBase3, t: float) -> T {
    result := color;
    result.x += (1 - result.x) * t;
    result.y += (1 - result.y) * t;
    result.z += (1 - result.z) * t;
    return result;
}
brighten :: (color: $T/interface VBase3, value: float) -> T {
    result := color;
    current: float = Math.max(color.x, color.y);
    current = Math.max(current, color.z);
    if current == 0 {
        result.x = value;
        result.y = value;
        result.z = value;
        return result;
    }
    multiplier := value / current;
    result.x *= multiplier;
    result.y *= multiplier;
    result.z *= multiplier;
    return result;
}
hsv_to_rgb :: (cx: float, cy: float, cz: float) -> (r: float, g: float, b: float) {
    sector := Math.frac(cx) * 6;
    whole := cast(int) Math.floor(sector);
    fraction := sector - cast(float) whole;
    low := cz * (1 - cy);
    falling := cz * (1 - cy * fraction);
    rising := cz * (1 - cy * (1 - fraction));
    if whole == 0 return cz, rising, low;
    if whole == 1 return falling, cz, low;
    if whole == 2 return low, cz, rising;
    if whole == 3 return low, falling, cz;
    if whole == 4 return rising, low, cz;
    return cz, low, falling;
}
rgb_to_hsv :: (r: float, g: float, b: float) -> (h: float, s: float, v: float) {
    maximum: float = Math.max(r, g);
    maximum = Math.max(maximum, b);
    minimum: float = Math.min(r, g);
    minimum = Math.min(minimum, b);
    delta := maximum - minimum;
    if delta == 0 || maximum == 0 return 0, 0, maximum;
    hue := 0.0;
    if maximum == r hue = (g - b) / delta;
    else if maximum == g hue = 2 + (b - r) / delta;
    else hue = 4 + (r - g) / delta;
    return Math.frac(hue / 6), delta / maximum, maximum;
}
