// Independent declaration normalization; behavior status: docs/stdlib/codec-native-bindings.md.
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

buffer_create_with_filename :: (filename: string) -> *Buffer #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_create_with_filename_1";

buffer_create_with_file :: (fh: File, close_when_done: bool) -> *Buffer #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_create_with_file_1";

buffer_create_with_memory :: (memory: [] u8, free_when_done: bool) -> *Buffer #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_create_with_memory_1";

buffer_create_with_capacity :: (capacity: s64) -> *Buffer #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_create_with_capacity_1";

create_for_appending :: (initial_capacity: s64) -> *Buffer #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_create_for_appending_1";

buffer_destroy :: (using buffer: *Buffer) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_destroy_1";

buffer_get_size :: (buffer: *Buffer) -> s64 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_get_size_1";

buffer_get_remaining :: (using buffer: *Buffer) -> s64 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_get_remaining_1";

buffer_write :: (using buffer: *Buffer, memory: [] u8) -> s64 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_write_1";

buffer_signal_end :: (buffer: *Buffer) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_signal_end_1";

buffer_set_load_callback :: (buffer: *Buffer, callback: Buffer_Load_Callback, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_set_load_callback_1";

buffer_rewind :: (buffer: *Buffer) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_rewind_1";

buffer_seek :: (buffer: *Buffer, pos: s64) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_seek_1";

buffer_tell :: (buffer: *Buffer) -> s64 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_tell_1";

buffer_discard_read_bytes :: (using buffer: *Buffer) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_discard_read_bytes_1";

buffer_load_file_callback :: (using buffer: *Buffer, user: *void) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_load_file_callback_1";

buffer_has :: (buffer: *Buffer, count: s64) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_has_1";

buffer_read :: (buffer: *Buffer, count: s64) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_read_1";

buffer_align :: (buffer: *Buffer) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_align_1";

buffer_skip :: (buffer: *Buffer, count: s64) #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_skip_1";

buffer_skip_bytes :: (buffer: *Buffer, v: u8) -> s32 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_skip_bytes_1";

buffer_next_start_code :: (buffer: *Buffer) -> Start_Code #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_next_start_code_1";

buffer_find_start_code :: (buffer: *Buffer, code: Start_Code) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_find_start_code_1";

buffer_has_start_code :: (buffer: *Buffer, code: Start_Code) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_has_start_code_1";

buffer_no_start_code :: (buffer: *Buffer) -> bool #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_no_start_code_1";

buffer_read_vlc :: (buffer: *Buffer, table: [] Vlc) -> s16 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_read_vlc_1";

buffer_read_vlc_uint :: (buffer: *Buffer, table: [] Vlc_Uint) -> u16 #foreign codec_adapter "jai_stdlib_pl_mpeg_buffer_buffer_read_vlc_uint_1";

#scope_file
codec_adapter :: #system_library "jai_pl_mpeg_adapter";
