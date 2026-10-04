// Independent declaration normalization; see docs/stdlib/native-bindings.md.
Buffer_Mode :: enum {
	FILE;
	FIXED_MEM;
	RING;
	APPEND;
}

Buffer :: struct {
	bit_index:  s64;
	capacity:   s64;
	length:     s64;
	total_size: s64;

	discard_read_bytes := false;

	has_ended       := false;
	free_when_done  := false;
	close_when_done := false;
    file_initted    := false;

    fh: File;

	load_callback: Buffer_Load_Callback;
	load_callback_user_data: *void;

	bytes: *u8;

    mode: Buffer_Mode;
}

Vlc :: struct {
	index: s16;
	value: s16;
}

Vlc_Uint :: struct {
	index: s16;
	value: u16;
}

buffer_create_with_filename :: (filename: string) -> *Buffer {
    fh, opened := file_open(filename);
    if !opened return null;
    result := buffer_create_with_file(fh, true);
    if !result file_close(*fh);
    return result;
}

buffer_create_with_file :: (fh: File, close_when_done: bool) -> *Buffer {
    length, measured := file_length_checked(fh);
    if !measured || length < 0 return null;
    entry := new(Buffer_State);
    entry.public = new(Buffer);
    entry.creator = context;
    entry.callback_context = context;
    entry.own_native = true;
    entry.public.fh = fh;
    entry.public.file_initted = true;
    entry.public.close_when_done = close_when_done;
    entry.public.load_callback = buffer_load_file_callback;
    entry.public.total_size = length;
    entry.public.mode = .FILE;
    entry.next = buffer_states;
    buffer_states = entry;
    entry.native = raw_plm_buffer_create_with_callbacks(file_load_callback, file_seek_callback,
                                                        file_tell_callback, cast(u64) length, entry);
    if !entry.native { forget_buffer(entry.public); return null; }
    pull_buffer(entry);
    return entry.public;
}

buffer_create_with_memory :: (memory: [] u8, free_when_done: bool) -> *Buffer {
    if memory.count < 0 return null;
    native := raw_plm_buffer_create_with_memory(memory.data, cast(u64) memory.count, 0);
    result := wrap_buffer(native);
    if result {
        entry := buffer_state(result);
        entry.own_native = true;
        entry.backing = memory.data;
        result.free_when_done = free_when_done;
    }
    return result;
}

buffer_create_with_capacity :: (capacity: s64) -> *Buffer {
    assert(capacity >= 0);
    result := wrap_buffer(raw_plm_buffer_create_with_capacity(cast(u64) capacity));
    if result buffer_state(result).own_native = true;
    return result;
}

create_for_appending :: (initial_capacity: s64) -> *Buffer {
    assert(initial_capacity >= 0);
    result := wrap_buffer(raw_plm_buffer_create_for_appending(cast(u64) initial_capacity));
    if result buffer_state(result).own_native = true;
    return result;
}

buffer_destroy :: (using buffer: *Buffer) {
    entry := buffer_state(buffer);
    assert(entry.own_native, "A borrowed decoder buffer is owned by its decoder");
    raw_plm_buffer_destroy(entry.native);
    if buffer.close_when_done && buffer.file_initted file_close(*buffer.fh);
    if entry.backing && buffer.free_when_done free(entry.backing, entry.creator.allocator);
    forget_buffer(buffer);
}

buffer_get_size :: (buffer: *Buffer) -> s64 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_get_size(entry.native);
    pull_buffer(entry);
    return cast(s64) result;
}

buffer_get_remaining :: (using buffer: *Buffer) -> s64 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_get_remaining(entry.native);
    pull_buffer(entry);
    return cast(s64) result;
}

buffer_write :: (using buffer: *Buffer, memory: [] u8) -> s64 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_write(entry.native, memory.data, cast(u64) memory.count);
    pull_buffer(entry);
    return cast(s64) result;
}

buffer_signal_end :: (buffer: *Buffer) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_signal_end(entry.native);
    pull_buffer(entry);
}

buffer_set_load_callback :: (buffer: *Buffer, callback: Buffer_Load_Callback, user: *void) {
    entry := buffer_state(buffer);
    entry.callback_context = context;
    buffer.load_callback = callback;
    buffer.load_callback_user_data = user;
    if callback raw_plm_buffer_set_load_callback(entry.native, native_load_callback, entry);
    else raw_plm_buffer_set_load_callback(entry.native, null, null);
}

buffer_rewind :: (buffer: *Buffer) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_rewind(entry.native);
    pull_buffer(entry);
}

buffer_seek :: (buffer: *Buffer, pos: s64) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_seek(entry.native, cast(u64) pos);
    pull_buffer(entry);
}

buffer_tell :: (buffer: *Buffer) -> s64 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_tell(entry.native);
    pull_buffer(entry);
    return cast(s64) result;
}

buffer_discard_read_bytes :: (using buffer: *Buffer) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_discard_read_bytes(entry.native);
    pull_buffer(entry);
}

buffer_load_file_callback :: (using buffer: *Buffer, user: *void) {
    entry := buffer_state(buffer);
    file_load_callback(entry.native, entry);
}

buffer_has :: (buffer: *Buffer, count: s64) -> bool {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_has(entry.native, cast(u64) count);
    pull_buffer(entry);
    return result != 0;
}

buffer_read :: (buffer: *Buffer, count: s64) -> s32 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    assert(count >= 0 && count <= 32);
    result := raw_plm_buffer_read(entry.native, cast(s32) count);
    pull_buffer(entry);
    return result;
}

buffer_align :: (buffer: *Buffer) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_align(entry.native);
    pull_buffer(entry);
}

buffer_skip :: (buffer: *Buffer, count: s64) {
    entry := buffer_state(buffer);
    push_buffer(entry);
    raw_plm_buffer_skip(entry.native, cast(u64) count);
    pull_buffer(entry);
}

buffer_skip_bytes :: (buffer: *Buffer, v: u8) -> s32 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_skip_bytes(entry.native, v);
    pull_buffer(entry);
    return result;
}

buffer_next_start_code :: (buffer: *Buffer) -> Start_Code {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_next_start_code(entry.native);
    pull_buffer(entry);
    return cast,no_check(Start_Code) result;
}

buffer_find_start_code :: (buffer: *Buffer, code: Start_Code) -> bool {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_find_start_code(entry.native, cast(s32) code);
    pull_buffer(entry);
    return result >= 0;
}

buffer_has_start_code :: (buffer: *Buffer, code: Start_Code) -> bool {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_has_start_code(entry.native, cast(s32) code);
    pull_buffer(entry);
    return result >= 0;
}

buffer_no_start_code :: (buffer: *Buffer) -> bool {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_no_start_code(entry.native);
    pull_buffer(entry);
    return result != 0;
}

buffer_read_vlc :: (buffer: *Buffer, table: [] Vlc) -> s16 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_read_vlc(entry.native, table.data);
    pull_buffer(entry);
    return result;
}

buffer_read_vlc_uint :: (buffer: *Buffer, table: [] Vlc_Uint) -> u16 {
    entry := buffer_state(buffer);
    push_buffer(entry);
    result := raw_plm_buffer_read_vlc_uint(entry.native, table.data);
    pull_buffer(entry);
    return cast(u16) result;
}
