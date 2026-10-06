// Scalar sRGB transfer equations used by all aggregate wrappers.
// The curve (IEC 61966-2-1) is a straight segment near black and an offset power law with
// exponent 2.4 above it; the knee sits at 0.04045 encoded, which is 0.0031308 linear.
srgb_to_linear :: (x: float) -> float #must {
    if x > 0.04045 {
        shifted := (x + 0.055) / 1.055;
        return pow(shifted, 2.4);
    }
    return x / 12.92;
}
linear_to_srgb :: (x: float) -> float #must {
    if x > 0.0031308 {
        curved := pow(x, 1.0 / 2.4);
        return curved * 1.055 - 0.055;
    }
    return 12.92 * x;
}
// Fast entry points use the transfer equation until a separately verified
// approximation is introduced; callers retain the same value semantics.
srgb_to_linear_fast :: (x: float) -> float #must {
    return srgb_to_linear(x);
}
linear_to_srgb_fast :: (x: float) -> float #must {
    return linear_to_srgb(x);
}
