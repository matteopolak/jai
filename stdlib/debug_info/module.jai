// Independently authored bounded string reader; debug-record decoding is pending.
#scope_module

get_c_string_from_data :: (data: [] u8, offset: s64) -> result: string, success: bool {
    result: string;
    if offset < 0 || offset >= data.count return "", false;
    end := offset;
    while end < data.count {
        if data[end] == 0 {
            result.data = data.data + offset;
            result.count = end - offset;
            return result, true;
        }
        end += 1;
    }
    return "", false;
}
