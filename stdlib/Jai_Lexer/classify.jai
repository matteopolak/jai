// Scalar classification shared by the scanner and direct source probes.
#scope_export
starts_identifier :: inline (c: u8) -> bool {
    return c == #char "_" || (c >= #char "a" && c <= #char "z") || (c >= #char "A" && c <= #char "Z");
}

continues_identifier :: (c: s32) -> bool {
    return (c >= 0 && c <= 255 && starts_identifier(cast(u8) c)) || starts_number(c);
}

starts_number :: (c: s32) -> bool {
    return c >= #char "0" && c <= #char "9";
}

has_a_big_exponent :: inline (value: float64) -> bool {
    return value != value || value > 3.402823466e38 || value < -3.402823466e38 || value != 0 && value > -1.175494351e-38 && value < 1.175494351e-38;
}

#scope_module
digit_value :: (byte: s32) -> s32 {
    if byte >= #char "0" && byte <= #char "9" return byte - #char "0";
    if byte >= #char "a" && byte <= #char "f" return byte - #char "a" + 10;
    if byte >= #char "A" && byte <= #char "F" return byte - #char "A" + 10;
    return -1;
}
