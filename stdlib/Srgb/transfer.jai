// Scalar sRGB transfer equations used by all aggregate wrappers.
srgb_to_linear :: (x: float) -> float #must {
    if x<=0.04045 return x/12.92;
    return pow((x+0.055)/1.055,2.4);
}
linear_to_srgb :: (x: float) -> float #must {
    if x<=0.0031308 return x*12.92;
    return 1.055*pow(x,1.0/2.4)-0.055;
}
// Fast entry points use the transfer equation until a separately verified
// approximation is introduced; callers retain the same value semantics.
srgb_to_linear_fast :: (x: float) -> float #must { return srgb_to_linear(x); }
linear_to_srgb_fast :: (x: float) -> float #must { return linear_to_srgb(x); }
