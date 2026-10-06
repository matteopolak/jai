#load "../../Math/constants.jai";
#load "../../Math/scalar.jai";
#load "../transfer.jai";
color_transfer_cases :: () -> bool {
    if srgb_to_linear(0.0) != 0 || linear_to_srgb(0.0) != 0 return false;
    if abs(srgb_to_linear(1.0) - 1) > 0.000001 || abs(linear_to_srgb(1.0) - 1) > 0.000001 return false;
    if abs(srgb_to_linear(0.04045) - 0.0031308049535603713) > 0.0000001 return false;
    if abs(srgb_to_linear(0.5) - 0.21404114048223255) > 0.000001 return false;
    for i: 1..8 {
        channel := cast(float) i / 8;
        if abs(linear_to_srgb(srgb_to_linear(channel)) - channel) > 0.000001 return false;
        if srgb_to_linear_fast(channel) != srgb_to_linear(channel) return false;
        if linear_to_srgb_fast(channel) != linear_to_srgb(channel) return false;
    }
    return true;
}
#assert #run color_transfer_cases();
