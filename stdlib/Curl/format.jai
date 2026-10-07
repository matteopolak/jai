// The C-format exports retain libcurl's native variadic ABI. These overloads
// allocate a temporary terminator for Jai's counted format byte strings.
curl_mprintf :: (format: string, __args: ..Any) -> s32 {
    return curl_mprintf_CFormat(Curl_Basic.temp_c_string(format), ..__args);
}

curl_mfprintf :: (fd: *FILE, format: string, __args: ..Any) -> s32 {
    return curl_mfprintf_CFormat(fd, Curl_Basic.temp_c_string(format), ..__args);
}

curl_msprintf :: (buffer: *u8, format: string, __args: ..Any) -> s32 {
    return curl_msprintf_CFormat(buffer, Curl_Basic.temp_c_string(format), ..__args);
}

curl_msnprintf :: (buffer: *u8, maxlength: u64, format: string, __args: ..Any) -> s32 {
    return curl_msnprintf_CFormat(buffer, maxlength, Curl_Basic.temp_c_string(format), ..__args);
}

curl_maprintf :: (format: string, __args: ..Any) -> *u8 {
    return curl_maprintf_CFormat(Curl_Basic.temp_c_string(format), ..__args);
}

#scope_file
Curl_Basic :: #import "Basic";
