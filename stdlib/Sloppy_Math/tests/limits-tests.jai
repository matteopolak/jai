#import "Sloppy_Math";

limits_cases :: () -> bool {
    if max_of_type(u8) != 255 || max_of_type(s16) != 32767 return false;
    if min_of_type(u16) != 0 || min_of_type(s32) != -2147483648 return false;
    if !is_approximately_zero(0.00001) || is_approximately_zero(0.01) return false;
    if !values_are_close(1.0, 1.00001) || values_are_close(1.0, 1.01) return false;
    return true;
}

#assert #run limits_cases();
