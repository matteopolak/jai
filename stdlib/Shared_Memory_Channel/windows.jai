#load "../File/windows-encoding.jai";
Utf8 :: #import "Windows_Utf8";
HEADER_OS_MAGIC :: "ShmW";

reader_create_channel_os_specific :: (name: string, bytes: s64) -> (success: bool, channel: Read_Channel) {
    result: Read_Channel;
    size := bytes + OFFSET_TO_MESSAGE_DATA;
    mapping := Windows.CreateFileMappingW(cast(Windows.HANDLE) -1, null, 4, cast(u32) (size >> 32), cast(u32) size, os_utf8_to_wide(name));
    if !mapping return false, result;
    if cast(u32) Windows.GetLastError() == 183 {
        Windows.CloseHandle(mapping);
        return false, result;
    }
    memory := Windows.MapViewOfFile(mapping, 0xf001f, 0, 0, xx size);
    if !memory {
        Windows.CloseHandle(mapping);
        return false, result;
    }
    result.header = cast(*Header) memory;
    result.os_specific.mapping = mapping;
    return true, result;
}
reader_release_channel :: (channel: *Read_Channel) -> bool {
    if !channel || !channel.header return false;
    if A.atomic_read(*channel.header.reader_status) == .ACTIVELY_READING || A.atomic_read(*channel.header.writer_status) != .DISCONNECTED return false;
    A.atomic_write(*channel.header.reader_status, .DISCONNECTED);
    if A.atomic_read(*channel.header.writer_status) != .DISCONNECTED {
        A.atomic_write(*channel.header.reader_status, .PAUSED);
        return false;
    }
    success := Windows.UnmapViewOfFile(channel.header) != 0;
    success = Windows.CloseHandle(channel.os_specific.mapping) != 0 && success;
    channel.* = .{};
    return success;
}
writer_connect :: (name: string, name_not_found_is_quiet := false) -> (success: bool, channel: Write_Channel) {
    result: Write_Channel;
    mapping := Windows.OpenFileMappingW(0xf001f, 0, os_utf8_to_wide(name));
    if !mapping return false, result;
    stub := Windows.MapViewOfFile(mapping, 0xf001f, 0, 0, OFFSET_TO_MESSAGE_DATA);
    if !stub {
        Windows.CloseHandle(mapping);
        return false, result;
    }
    valid, size := get_size_of_full_mapping_from_stub_header(stub);
    Windows.UnmapViewOfFile(stub);
    if !valid {
        Windows.CloseHandle(mapping);
        return false, result;
    }
    memory := Windows.MapViewOfFile(mapping, 0xf001f, 0, 0, xx size);
    if !memory {
        Windows.CloseHandle(mapping);
        return false, result;
    }
    header := cast(*Header) memory;
    valid, actual := get_size_of_full_mapping_from_stub_header(memory);
    if !valid || actual != size || A.atomic_read(*header.reader_status) == .DISCONNECTED {
        Windows.UnmapViewOfFile(memory);
        Windows.CloseHandle(mapping);
        return false, result;
    }
    joined, previous := compare_and_swap(*header.writer_status, .DISCONNECTED, .PAUSED);
    if !joined {
        Windows.UnmapViewOfFile(memory);
        Windows.CloseHandle(mapping);
        return false, result;
    }
    if A.atomic_read(*header.reader_status) == .DISCONNECTED {
        A.atomic_write(*header.writer_status, .DISCONNECTED);
        Windows.UnmapViewOfFile(memory);
        Windows.CloseHandle(mapping);
        return false, result;
    }
    result.header = header;
    result.os_specific.mapping = mapping;
    return true, result;
}
writer_disconnect :: (channel: *Write_Channel) -> bool {
    if !channel || !channel.header || channel.reserved_offset >= 0 return false;
    A.atomic_write(*channel.header.writer_status, .DISCONNECTED);
    success := Windows.UnmapViewOfFile(channel.header) != 0;
    success = Windows.CloseHandle(channel.os_specific.mapping) != 0 && success;
    channel.* = .{};
    return success;
}

#scope_module
os_magic :: () -> u32 {
    value: u32;
    memcpy(*value, HEADER_OS_MAGIC.data, 4);
    return value;
}
