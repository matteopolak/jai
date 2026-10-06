#import "Basic";
A :: #import "Atomics";

Header :: struct {
    magic: u32;
    version: u32;
    reader_status: enum s32 {
        DISCONNECTED :: 0;
        PAUSED :: 1;
        ACTIVELY_READING :: 2;
    };
    writer_status: enum s32 {
        DISCONNECTED :: 0;
        PAUSED :: 1;
        ACTIVELY_WRITING :: 2;
    };
    offset_to_os_specific_header: u32;
    offset_to_message_queue_header: u32;
    offset_to_message_data: u32;
    full_memory_region_size_in_bytes: s64;
    data_size_in_bytes: s64;
}
Header_Os_Specific :: struct {
    magic: u32;
}
#if OS == .WINDOWS {
    Windows :: #import "Windows";
    Read_Channel_Os_Specific :: struct {
        mapping: Windows.HANDLE;
    }
    Write_Channel_Os_Specific :: struct {
        mapping: Windows.HANDLE;
    }
    #load "windows.jai";
} else {
    P :: #import "POSIX";
    Read_Channel_Os_Specific :: struct {
        shm: s32 = -1;
    }
    Write_Channel_Os_Specific :: struct {
        shm: s32 = -1;
    }
    #load "posix.jai";
}
Read_Channel :: struct {
    header: *Header;
    os_specific: Read_Channel_Os_Specific;
    owned_name: string;
    active_offset: s64 = -1;
    active_bytes: s64;
}
Write_Channel :: struct {
    header: *Header;
    os_specific: Write_Channel_Os_Specific;
    reserved_offset: s64 = -1;
    prior_write_cursor: s64;
    reserved_bytes: s64;
}
Message_Queue_Header :: struct {
    read_cursor: s64;
    pad: [56] u8 = ---;
    write_cursor: s64;
}
Reserved_Message :: struct {
    channel: *Write_Channel;
    offset: s64;
    total_bytes: s64;
    user_write_pointer: *u8;
}
Read_Message :: struct {
    channel: *Read_Channel;
    offset: s64;
    total_bytes: s64;
    user_read_pointer: *u8;
    user_read_bytes: s64;
}
OFFSET_TO_HEADER_OS_SPECIFIC :: 64;
OFFSET_TO_MESSAGE_QUEUE_HEADER :: 128;
OFFSET_TO_MESSAGE_DATA :: 256;
PER_MESSAGE_OVERHEAD_SIZE :: 16;
WRAPPING_SENTINEL :: 0xcafebabef00dface;
PROTOCOL_VERSION :: 1;
CHANNEL_MAGIC :: "ShmC";
MESSAGE_MAGIC :: "ShmM2022";

reader_create_channel :: (name: string, bytes: s64) -> (success: bool, channel: Read_Channel) {
    if bytes < 2 * PER_MESSAGE_OVERHEAD_SIZE || bytes > 0x7fff_ffff_ffff_ffff - OFFSET_TO_MESSAGE_DATA return false, .{};
    success, result := reader_create_channel_os_specific(name, bytes);
    if !success return false, .{};
    header := result.header;
    memset(header, 0, bytes + OFFSET_TO_MESSAGE_DATA);
    header.version = PROTOCOL_VERSION;
    header.offset_to_os_specific_header = OFFSET_TO_HEADER_OS_SPECIFIC;
    header.offset_to_message_queue_header = OFFSET_TO_MESSAGE_QUEUE_HEADER;
    header.offset_to_message_data = OFFSET_TO_MESSAGE_DATA;
    header.full_memory_region_size_in_bytes = bytes + OFFSET_TO_MESSAGE_DATA;
    header.data_size_in_bytes = bytes;
    queue := get_message_queue_header(header);
    queue.read_cursor = OFFSET_TO_MESSAGE_DATA;
    queue.write_cursor = OFFSET_TO_MESSAGE_DATA;
    os_header := cast(*Header_Os_Specific) (cast(*u8) header + OFFSET_TO_HEADER_OS_SPECIFIC);
    os_header.magic = os_magic();
    header.reader_status = .PAUSED;
    A.atomic_write(*header.magic, channel_magic());
    return true, result;
}

get_message_queue_header :: inline (header: *Header) -> *Message_Queue_Header {
    return cast(*Message_Queue_Header) (cast(*u8) header + header.offset_to_message_queue_header);
}
get_data_area :: inline (header: *Header) -> *u8 {
    return cast(*u8) header + header.offset_to_message_data;
}
get_size_of_full_mapping_from_stub_header :: (pointer: *void) -> (success: bool, actual_bytes: s64) {
    if !pointer return false, 0;
    header := cast(*Header) pointer;
    if A.atomic_read(*header.magic) != channel_magic() || header.version != PROTOCOL_VERSION return false, 0;
    if header.offset_to_os_specific_header != OFFSET_TO_HEADER_OS_SPECIFIC || header.offset_to_message_queue_header != OFFSET_TO_MESSAGE_QUEUE_HEADER || header.offset_to_message_data != OFFSET_TO_MESSAGE_DATA return false, 0;
    if header.data_size_in_bytes < 32 || header.data_size_in_bytes > 0x7fff_ffff_ffff_ffff - OFFSET_TO_MESSAGE_DATA return false, 0;
    if header.full_memory_region_size_in_bytes != header.data_size_in_bytes + OFFSET_TO_MESSAGE_DATA return false, 0;
    return true, header.full_memory_region_size_in_bytes;
}

writer_reserve_message :: (channel: *Write_Channel, data_bytes: s64) -> (success: bool, reserved: Reserved_Message) {
    if !channel || !channel.header || data_bytes < 0 return false, .{};
    header := channel.header;
    if data_bytes > header.data_size_in_bytes - PER_MESSAGE_OVERHEAD_SIZE - 1 return false, .{};
    if channel.reserved_offset >= 0 || A.atomic_read(*header.writer_status) != .PAUSED || A.atomic_read(*header.reader_status) == .DISCONNECTED return false, .{};
    queue := get_message_queue_header(header);
    read := A.atomic_read(*queue.read_cursor);
    write := A.atomic_read(*queue.write_cursor);
    begin := cast(s64) header.offset_to_message_data;
    end := header.full_memory_region_size_in_bytes;
    if read < begin || read >= end || write < begin || write >= end return false, .{};
    needed := data_bytes + PER_MESSAGE_OVERHEAD_SIZE;
    available := read - write - 1;
    if write >= read available = end - write + read - begin - 1;
    if needed > available return false, .{};
    offset := write;
    if needed > end - write {
        if needed >= read - begin return false, .{};
        offset = begin;
    } else if write < read && needed >= read - write {
        return false, .{};
    }
    channel.reserved_offset = offset;
    channel.reserved_bytes = needed;
    channel.prior_write_cursor = write;
    A.atomic_write(*header.writer_status, .ACTIVELY_WRITING);
    return true, .{ channel, offset, needed, cast(*u8) header + offset + PER_MESSAGE_OVERHEAD_SIZE };
}

writer_commit_message :: (channel: *Write_Channel, message: Reserved_Message) -> success: bool {
    if !channel || !channel.header || message.channel != channel || channel.reserved_offset != message.offset || message.total_bytes != channel.reserved_bytes || message.total_bytes < PER_MESSAGE_OVERHEAD_SIZE return false;
    header := channel.header;
    if A.atomic_read(*header.writer_status) != .ACTIVELY_WRITING || message.offset + message.total_bytes > header.full_memory_region_size_in_bytes return false;
    if message.user_write_pointer != cast(*u8) header + message.offset + PER_MESSAGE_OVERHEAD_SIZE return false;
    if channel.prior_write_cursor != message.offset && header.full_memory_region_size_in_bytes - channel.prior_write_cursor >= PER_MESSAGE_OVERHEAD_SIZE {
        write_stamp(header, channel.prior_write_cursor, cast,no_check(s64) WRAPPING_SENTINEL);
    }
    write_stamp(header, message.offset, message.total_bytes - PER_MESSAGE_OVERHEAD_SIZE);
    next := message.offset + message.total_bytes;
    if next == header.full_memory_region_size_in_bytes next = header.offset_to_message_data;
    A.atomic_write(*get_message_queue_header(header).write_cursor, next);
    channel.reserved_offset = -1;
    channel.reserved_bytes = 0;
    A.atomic_write(*header.writer_status, .PAUSED);
    return true;
}

reader_poll_for_message :: (channel: *Read_Channel) -> (found: bool, fatal_error: bool, message: Read_Message) {
    if !channel || !channel.header return false, true, .{};
    header := channel.header;
    if A.atomic_read(*header.reader_status) != .PAUSED return false, true, .{};
    queue := get_message_queue_header(header);
    offset := A.atomic_read(*queue.read_cursor);
    write := A.atomic_read(*queue.write_cursor);
    if offset == write return false, false, .{};
    begin := cast(s64) header.offset_to_message_data;
    end := header.full_memory_region_size_in_bytes;
    if offset < begin || offset >= end || write < begin || write >= end return false, true, .{};
    if end - offset < PER_MESSAGE_OVERHEAD_SIZE offset = begin;
    length, valid := read_stamp(header, offset);
    if valid && cast,no_check(u64) length == WRAPPING_SENTINEL {
        offset = begin;
        length, valid = read_stamp(header, offset);
    }
    if !valid || length < 0 || length > end - offset - PER_MESSAGE_OVERHEAD_SIZE return false, true, .{};
    total := length + PER_MESSAGE_OVERHEAD_SIZE;
    if offset < write && total > write - offset return false, true, .{};
    A.atomic_write(*header.reader_status, .ACTIVELY_READING);
    channel.active_offset = offset;
    channel.active_bytes = total;
    return true, false, .{ channel, offset, total, cast(*u8) header + offset + PER_MESSAGE_OVERHEAD_SIZE, length };
}

reader_done_with_message :: (message: *Read_Message) -> bool {
    if !message || !message.channel || !message.channel.header return false;
    header := message.channel.header;
    if message.offset != message.channel.active_offset || message.total_bytes != message.channel.active_bytes return false;
    if A.atomic_read(*header.reader_status) != .ACTIVELY_READING || message.total_bytes != message.user_read_bytes + PER_MESSAGE_OVERHEAD_SIZE return false;
    if message.user_read_pointer != cast(*u8) header + message.offset + PER_MESSAGE_OVERHEAD_SIZE || message.offset + message.total_bytes > header.full_memory_region_size_in_bytes return false;
    next := message.offset + message.total_bytes;
    if next == header.full_memory_region_size_in_bytes next = header.offset_to_message_data;
    A.atomic_write(*get_message_queue_header(header).read_cursor, next);
    A.atomic_write(*header.reader_status, .PAUSED);
    message.channel.active_offset = -1;
    message.channel.active_bytes = 0;
    message.* = .{};
    return true;
}

#scope_module
channel_magic :: () -> u32 {
    value: u32;
    memcpy(*value, CHANNEL_MAGIC.data, 4);
    return value;
}
message_magic :: () -> u64 {
    value: u64;
    memcpy(*value, MESSAGE_MAGIC.data, 8);
    return value;
}
write_stamp :: (header: *Header, offset: s64, length: s64) {
    pointer := cast(*u8) header + offset;
    magic := message_magic();
    memcpy(pointer, *magic, 8);
    memcpy(pointer + 8, *length, 8);
}
read_stamp :: (header: *Header, offset: s64) -> s64, bool {
    magic: u64;
    length: s64;
    pointer := cast(*u8) header + offset;
    memcpy(*magic, pointer, 8);
    memcpy(*length, pointer + 8, 8);
    return length, magic == message_magic();
}
