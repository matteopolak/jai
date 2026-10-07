#import "Math";
#load "Srgb/transfer.jai";

srgb_to_linear :: (c: Vector3) -> Vector3 #must {
    return rgb(srgb_to_linear(c.x), srgb_to_linear(c.y), srgb_to_linear(c.z));
}

srgb_to_linear :: (c: Vector4) -> Vector4 #must {
    return rgba(srgb_to_linear(xyz(c.x, c.y, c.z)), c.w);
}

srgb_to_linear_fast :: (c: Vector3) -> Vector3 #must {
    return rgb(srgb_to_linear_fast(c.x), srgb_to_linear_fast(c.y), srgb_to_linear_fast(c.z));
}

srgb_to_linear_fast :: (c: Vector4) -> Vector4 #must {
    return rgba(srgb_to_linear_fast(xyz(c.x, c.y, c.z)), c.w);
}

linear_to_srgb :: (c: Vector3) -> Vector3 #must {
    return rgb(linear_to_srgb(c.x), linear_to_srgb(c.y), linear_to_srgb(c.z));
}

linear_to_srgb :: (c: Vector4) -> Vector4 #must {
    return rgba(linear_to_srgb(xyz(c.x, c.y, c.z)), c.w);
}

linear_to_srgb_fast :: (c: Vector3) -> Vector3 #must {
    return rgb(linear_to_srgb_fast(c.x), linear_to_srgb_fast(c.y), linear_to_srgb_fast(c.z));
}

linear_to_srgb_fast :: (c: Vector4) -> Vector4 #must {
    return rgba(linear_to_srgb_fast(xyz(c.x, c.y, c.z)), c.w);
}

srgb_to_linear_pow2 :: (c: Vector3) -> Vector3 #must {
    return c * c;
}

srgb_to_linear_pow2 :: (c: Vector4) -> Vector4 #must {
    return rgba(srgb_to_linear_pow2(xyz(c.x, c.y, c.z)), c.w);
}

linear_to_srgb_sqrt :: (c: Vector3) -> Vector3 #must {
    return rgb(sqrt(c.x), sqrt(c.y), sqrt(c.z));
}

linear_to_srgb_sqrt :: (c: Vector4) -> Vector4 #must {
    return rgba(linear_to_srgb_sqrt(xyz(c.x, c.y, c.z)), c.w);
}
