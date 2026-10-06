HEADER_OS_MAGIC :: "ShmP";

reader_create_channel_os_specific :: (name: string, bytes: s64) -> (success: bool, channel: Read_Channel) {
    result: Read_Channel;
    c_name := temp_c_string(name);
    descriptor := P.shm_open(c_name, P.O_CREAT | P.O_EXCL | P.O_RDWR, 384);
    if descriptor < 0 return false, result;
    size := bytes + OFFSET_TO_MESSAGE_DATA;
    if P.ftruncate(descriptor, size) != 0 {
        P.close(descriptor);
        P.shm_unlink(c_name);
        return false, result;
    }
    memory := P.mmap(null, xx size, 1 | 2, 1, descriptor, 0);
    if memory == cast(*void) -1 {
        P.close(descriptor);
        P.shm_unlink(c_name);
        return false, result;
    }
    result.header = cast(*Header) memory;
    result.os_specific.shm = descriptor;
    result.owned_name = copy_string(name);
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
    success := P.munmap(channel.header, xx channel.header.full_memory_region_size_in_bytes) == 0;
    success = P.close(channel.os_specific.shm) == 0 && success;
    success = P.shm_unlink(temp_c_string(channel.owned_name)) == 0 && success;
    free(channel.owned_name);
    channel.* = .{};
    return success;
}
writer_connect :: (name: string, name_not_found_is_quiet := false) -> (success: bool, channel: Write_Channel) {
    result: Write_Channel;
    descriptor := P.shm_open(temp_c_string(name), P.O_RDWR, 0);
    if descriptor < 0 return false, result;
    stats: P.stat_t;
    if P.fstat(descriptor, *stats) != 0 || stats.st_size < OFFSET_TO_MESSAGE_DATA + 32 {
        P.close(descriptor);
        return false, result;
    }
    memory := P.mmap(null, xx stats.st_size, 1 | 2, 1, descriptor, 0);
    if memory == cast(*void) -1 {
        P.close(descriptor);
        return false, result;
    }
    valid, size := get_size_of_full_mapping_from_stub_header(memory);
    header := cast(*Header) memory;
    if !valid || size != stats.st_size || A.atomic_read(*header.reader_status) == .DISCONNECTED {
        P.munmap(memory, xx stats.st_size);
        P.close(descriptor);
        return false, result;
    }
    joined := compare_and_swap(*header.writer_status, .DISCONNECTED, .PAUSED);
    if !joined {
        P.munmap(memory, xx stats.st_size);
        P.close(descriptor);
        return false, result;
    }
    if A.atomic_read(*header.reader_status) == .DISCONNECTED {
        A.atomic_write(*header.writer_status, .DISCONNECTED);
        P.munmap(memory, xx stats.st_size);
        P.close(descriptor);
        return false, result;
    }
    result.header = header;
    result.os_specific.shm = descriptor;
    return true, result;
}
writer_disconnect :: (channel: *Write_Channel) -> bool {
    if !channel || !channel.header || channel.reserved_offset >= 0 return false;
    A.atomic_write(*channel.header.writer_status, .DISCONNECTED);
    size := channel.header.full_memory_region_size_in_bytes;
    success := P.munmap(channel.header, xx size) == 0;
    success = P.close(channel.os_specific.shm) == 0 && success;
    channel.* = .{};
    return success;
}

#scope_module
os_magic :: () -> u32 {
    value: u32;
    memcpy(*value, HEADER_OS_MAGIC.data, 4);
    return value;
}
