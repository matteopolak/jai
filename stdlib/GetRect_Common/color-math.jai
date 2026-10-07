#scope_file
Color_Math :: #import "Math";

Vector3 :: Color_Math.Vector3;

#scope_export
linear_srgb_to_oklab :: (c: Vector3) -> Vector3 {
    response := left_transform3(c, .{ 0.4122214708, 0.5363325363, 0.0514459929 }, .{ 0.2119034982, 0.6806995451, 0.1073969566 }, .{ 0.0883024619, 0.2817188376, 0.6299787005 });
    response = .{ left_cuberoot(response.x), left_cuberoot(response.y), left_cuberoot(response.z) };
    return left_transform3(response, .{ 0.2104542553, 0.7936177850, -0.0040720468 }, .{ 1.9779984951, -2.4285922050, 0.4505937099 }, .{ 0.0259040371, 0.7827717662, -0.8086757660 });
}

oklab_to_linear_srgb :: (c: Vector3) -> Vector3 {
    response := left_transform3(c, .{ 1, 0.3963377774, 0.2158037573 }, .{ 1, -0.1055613458, -0.0638541728 }, .{ 1, -0.0894841775, -1.2914855480 });
    response = .{ response.x * response.x * response.x, response.y * response.y * response.y, response.z * response.z * response.z };
    return left_transform3(response, .{ 4.0767416621, -3.3077115913, 0.2309699292 }, .{ -1.2684380046, 2.6097574011, -0.3413193965 }, .{ -0.0041960863, -0.7034186147, 1.7076147010 });
}

#scope_module
left_transform3 :: (c: Vector3, a: Vector3, b: Vector3, d: Vector3) -> Vector3 {
    return .{ Color_Math.dot(c, a), Color_Math.dot(c, b), Color_Math.dot(c, d) };
}

left_cuberoot :: (value: float) -> float {
    if value < 0 return -cast(float) Color_Math.pow(-value, 1 / 3.0);
    return cast(float) Color_Math.pow(value, 1 / 3.0);
}

left_decode_channel :: (value: float) -> float {
    if value <= 0.04045 return value / 12.92;
    return cast(float) Color_Math.pow((value + 0.055) / 1.055, 2.4);
}

left_encode_channel :: (value: float) -> float {
    if value <= 0.0031308 return value * 12.92;
    return cast(float) (1.055 * Color_Math.pow(value, 1 / 2.4) - 0.055);
}
