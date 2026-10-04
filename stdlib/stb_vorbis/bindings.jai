// Independent declaration normalization; see docs/stdlib/native-bindings.md.
STB_VORBIS_MAX_CHANNELS :: 16;

STB_VORBIS_PUSHDATA_CRC_COUNT :: 4;

STB_VORBIS_FAST_HUFFMAN_LENGTH :: 10;

STB_VORBIS_ENDIAN :: 0;

MAX_BLOCKSIZE_LOG :: 13;
MAX_BLOCKSIZE :: 1 << MAX_BLOCKSIZE_LOG;

TRUE :: 1;
FALSE :: 0;

FAST_HUFFMAN_TABLE_SIZE :: 1 << STB_VORBIS_FAST_HUFFMAN_LENGTH;
FAST_HUFFMAN_TABLE_MASK :: FAST_HUFFMAN_TABLE_SIZE - 1;

CRC32_POLY :: 0x04c11db7;

NO_CODE :: 255;

PAGEFLAG_continued_packet :: 1;
PAGEFLAG_first_page :: 2;
PAGEFLAG_last_page :: 4;

EOP :: -1;
INVALID_BITS :: -1;

LIBVORBIS_MDCT :: 0;

SAMPLE_unknown :: 0xffffffff;

PLAYBACK_MONO :: 1;
PLAYBACK_LEFT :: 2;
PLAYBACK_RIGHT :: 4;

L :: PLAYBACK_LEFT | PLAYBACK_MONO;
C :: PLAYBACK_LEFT | PLAYBACK_RIGHT | PLAYBACK_MONO;
R :: PLAYBACK_RIGHT | PLAYBACK_MONO;

STB_BUFFER_SIZE :: 32;

stb_vorbis_alloc :: struct {
    alloc_buffer:                 *u8;
    alloc_buffer_length_in_bytes: s32;
}

stb_vorbis_info :: struct {
    sample_rate:                u32;
    channels:                   s32;

    setup_memory_required:      u32;
    setup_temp_memory_required: u32;
    temp_memory_required:       u32;

    max_frame_size:             s32;
}

stb_vorbis_comment :: struct {
    vendor:              *u8;

    comment_list_length: s32;
    comment_list:        **u8;
}

stb_vorbis_get_info :: (f: *stb_vorbis) -> stb_vorbis_info #foreign lib_stb_vorbis;

stb_vorbis_get_comment :: (f: *stb_vorbis) -> stb_vorbis_comment #foreign lib_stb_vorbis;

stb_vorbis_get_error :: (f: *stb_vorbis) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_close :: (f: *stb_vorbis) -> void #foreign lib_stb_vorbis;

stb_vorbis_get_sample_offset :: (f: *stb_vorbis) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_file_offset :: (f: *stb_vorbis) -> u32 #foreign lib_stb_vorbis;

stb_vorbis_open_pushdata :: (datablock: *u8, datablock_length_in_bytes: s32, datablock_memory_consumed_in_bytes: *s32, error: *s32, alloc_buffer: *stb_vorbis_alloc) -> *stb_vorbis #foreign lib_stb_vorbis;

stb_vorbis_decode_frame_pushdata :: (f: *stb_vorbis, datablock: *u8, datablock_length_in_bytes: s32, channels: *s32, output: ***float, samples: *s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_flush_pushdata :: (f: *stb_vorbis) -> void #foreign lib_stb_vorbis;

stb_vorbis_decode_filename :: (filename: *u8, channels: *s32, sample_rate: *s32, output: **s16) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_decode_memory :: (mem: *u8, len: s32, channels: *s32, sample_rate: *s32, output: **s16) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_open_memory :: (data: *u8, len: s32, error: *s32, alloc_buffer: *stb_vorbis_alloc) -> *stb_vorbis #foreign lib_stb_vorbis;

stb_vorbis_open_filename :: (filename: *u8, error: *s32, alloc_buffer: *stb_vorbis_alloc) -> *stb_vorbis #foreign lib_stb_vorbis;

stb_vorbis_open_file :: (f: *FILE, close_handle_on_close: s32, error: *s32, alloc_buffer: *stb_vorbis_alloc) -> *stb_vorbis #foreign lib_stb_vorbis;

stb_vorbis_open_file_section :: (f: *FILE, close_handle_on_close: s32, error: *s32, alloc_buffer: *stb_vorbis_alloc, len: u32) -> *stb_vorbis #foreign lib_stb_vorbis;

stb_vorbis_seek_frame :: (f: *stb_vorbis, sample_number: u32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_seek :: (f: *stb_vorbis, sample_number: u32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_seek_start :: (f: *stb_vorbis) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_stream_length_in_samples :: (f: *stb_vorbis) -> u32 #foreign lib_stb_vorbis;

stb_vorbis_stream_length_in_seconds :: (f: *stb_vorbis) -> float #foreign lib_stb_vorbis;

stb_vorbis_get_frame_float :: (f: *stb_vorbis, channels: *s32, output: ***float) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_frame_short_interleaved :: (f: *stb_vorbis, num_c: s32, buffer: *s16, num_shorts: s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_frame_short :: (f: *stb_vorbis, num_c: s32, buffer: **s16, num_samples: s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_samples_float_interleaved :: (f: *stb_vorbis, channels: s32, buffer: *float, num_floats: s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_samples_float :: (f: *stb_vorbis, channels: s32, buffer: **float, num_samples: s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_samples_short_interleaved :: (f: *stb_vorbis, channels: s32, buffer: *s16, num_shorts: s32) -> s32 #foreign lib_stb_vorbis;

stb_vorbis_get_samples_short :: (f: *stb_vorbis, channels: s32, buffer: **s16, num_samples: s32) -> s32 #foreign lib_stb_vorbis;

STBVorbisError :: enum u32 {
    no_error                         :: 0;

    need_more_data                   :: 1;

    invalid_api_mixing               :: 2;
    outofmem                         :: 3;
    feature_not_supported            :: 4;
    too_many_channels                :: 5;
    file_open_failure                :: 6;
    seek_without_length              :: 7;

    unexpected_eof                   :: 10;
    seek_invalid                     :: 11;

    invalid_setup                    :: 20;
    invalid_stream                   :: 21;

    missing_capture_pattern          :: 30;
    invalid_stream_structure_version :: 31;
    continued_packet_flag_invalid    :: 32;
    incorrect_stream_serial_number   :: 33;
    invalid_first_page               :: 34;
    bad_packet_type                  :: 35;
    cant_find_last_page              :: 36;
    seek_failed                      :: 37;
    ogg_skeleton_not_supported       :: 38;

    VORBIS__no_error                        :: no_error;

    VORBIS_need_more_data                   :: need_more_data;

    VORBIS_invalid_api_mixing               :: invalid_api_mixing;
    VORBIS_outofmem                         :: outofmem;
    VORBIS_feature_not_supported            :: feature_not_supported;
    VORBIS_too_many_channels                :: too_many_channels;
    VORBIS_file_open_failure                :: file_open_failure;
    VORBIS_seek_without_length              :: seek_without_length;

    VORBIS_unexpected_eof                   :: unexpected_eof;
    VORBIS_seek_invalid                     :: seek_invalid;

    VORBIS_invalid_setup                    :: invalid_setup;
    VORBIS_invalid_stream                   :: invalid_stream;

    VORBIS_missing_capture_pattern          :: missing_capture_pattern;
    VORBIS_invalid_stream_structure_version :: invalid_stream_structure_version;
    VORBIS_continued_packet_flag_invalid    :: continued_packet_flag_invalid;
    VORBIS_incorrect_stream_serial_number   :: incorrect_stream_serial_number;
    VORBIS_invalid_first_page               :: invalid_first_page;
    VORBIS_bad_packet_type                  :: bad_packet_type;
    VORBIS_cant_find_last_page              :: cant_find_last_page;
    VORBIS_seek_failed                      :: seek_failed;
    VORBIS_ogg_skeleton_not_supported       :: ogg_skeleton_not_supported;
}

uint8 :: u8;
int8 :: s8;
uint16 :: u16;
int16 :: s16;
uint32 :: u32;
int32 :: s32;

codetype :: float;

Codebook :: struct {
    dimensions:       s32;
    entries:          s32;
    codeword_lengths: *uint8;
    minimum_value:    float;
    delta_value:      float;
    value_bits:       uint8;
    lookup_type:      uint8;
    sequence_p:       uint8;
    sparse:           uint8;
    lookup_values:    uint32;
    multiplicands:    *codetype;
    codewords:        *uint32;

    fast_huffman:     [1024] int16;

    sorted_codewords: *uint32;
    sorted_values:    *s32;
    sorted_entries:   s32;
}

Floor0 :: struct {
    order:            uint8;
    rate:             uint16;
    bark_map_size:    uint16;
    amplitude_bits:   uint8;
    amplitude_offset: uint8;
    number_of_books:  uint8;
    book_list:        [16] uint8;
}

Floor1 :: struct {
    partitions:           uint8;
    partition_class_list: [32] uint8;
    class_dimensions:     [16] uint8;
    class_subclasses:     [16] uint8;
    class_masterbooks:    [16] uint8;
    subclass_books:       [16] [8] int16;
    Xlist:                [250] uint16;
    sorted_order:         [250] uint8;
    neighbors:            [250] [2] uint8;
    floor1_multiplier:    uint8;
    rangebits:            uint8;
    values:               s32;
}

Floor :: union {
    floor0: Floor0;
    floor1: Floor1;
}

Residue :: struct {
    begin:           uint32;
    end:             uint32;
    part_size:       uint32;
    classifications: uint8;
    classbook:       uint8;
    classdata:       **uint8;
    residue_books:   *[8] int16;
}

MappingChannel :: struct {
    magnitude: uint8;
    angle:     uint8;
    mux:       uint8;
}

Mapping :: struct {
    coupling_steps: uint16;
    chan:           *MappingChannel;
    submaps:        uint8;
    submap_floor:   [15] uint8;
    submap_residue: [15] uint8;
}

Mode :: struct {
    blockflag:     uint8;
    mapping:       uint8;
    windowtype:    uint16;
    transformtype: uint16;
}

CRCscan :: struct {
    goal_crc:   uint32;
    bytes_left: s32;
    crc_so_far: uint32;
    bytes_done: s32;
    sample_loc: uint32;
}

ProbedPage :: struct {
    page_start:          uint32;
    page_end:            uint32;
    last_decoded_sample: uint32;
}

stb_vorbis :: struct {

    sample_rate:                u32;
    channels:                   s32;

    setup_memory_required:      u32;
    temp_memory_required:       u32;
    setup_temp_memory_required: u32;

    vendor:                     *u8;
    comment_list_length:        s32;
    comment_list:               **u8;

    f:                          *FILE;
    f_start:                    uint32;
    close_on_free:              s32;

    stream:                     *uint8;
    stream_start:               *uint8;
    stream_end:                 *uint8;

    stream_len:                 uint32;

    push_mode:                  uint8;

    first_audio_page_offset:    uint32;

    p_first:                    ProbedPage;

    p_last:                     ProbedPage;

    alloc:                      stb_vorbis_alloc;
    setup_offset:               s32;
    temp_offset:                s32;

    eof:                        s32;
    error:                      STBVorbisError;

    blocksize:                  [2] s32;
    blocksize_0:                s32;
    blocksize_1:                s32;
    codebook_count:             s32;
    codebooks:                  *Codebook;
    floor_count:                s32;
    floor_types:                [64] uint16;
    floor_config:               *Floor;
    residue_count:              s32;
    residue_types:              [64] uint16;
    residue_config:             *Residue;
    mapping_count:              s32;
    mapping:                    *Mapping;
    mode_count:                 s32;
    mode_config:                [64] Mode;

    total_samples:              uint32;

    channel_buffers:            [16] *float;
    outputs:                    [16] *float;

    previous_window:            [16] *float;
    previous_length:            s32;

    finalY:                     [16] *int16;

    current_loc:                uint32;
    current_loc_valid:          s32;

    A:                          [2] *float;

    B:                          [2] *float;

    C:                          [2] *float;
    window:                     [2] *float;
    bit_reverse:                [2] *uint16;

    serial:                     uint32;
    last_page:                  s32;
    segment_count:              s32;
    segments:                   [255] uint8;
    page_flag:                  uint8;
    bytes_in_seg:               uint8;
    first_decode:               uint8;
    next_seg:                   s32;
    last_seg:                   s32;
    last_seg_which:             s32;
    acc:                        uint32;
    valid_bits:                 s32;
    packet_bytes:               s32;
    end_seg_with_known_loc:     s32;
    known_loc_for_packet:       uint32;
    discard_samples_deferred:   s32;
    samples_output:             uint32;

    page_crc_tests:             s32;

    scan:                       [4] CRCscan;

    channel_buffer_start:       s32;
    channel_buffer_end:         s32;
}

vorb :: stb_vorbis;

stbv__floor_ordering :: struct {
    x:  uint16;
    id: uint16;
}

VORBIS_packet :: enum u32 {
    id      :: 1;
    comment :: 3;
    setup   :: 5;

    VORBIS_packet_id      :: id;
    VORBIS_packet_comment :: comment;
    VORBIS_packet_setup   :: setup;
}

YTYPE :: int16;

float_conv :: union {
    f: float;
    i: s32;
}

stb_vorbis_float_size_test :: [1] u8;

#scope_file

#if OS == .WINDOWS {
    lib_stb_vorbis :: #system_library "stb_vorbis";
} else #if OS == .LINUX {
    lib_stb_vorbis :: #system_library "stb_vorbis";
} else #if OS == .MACOS {
    lib_stb_vorbis :: #system_library "stb_vorbis";
} else #if OS == .ANDROID {
    #if CPU == .X64 {
        lib_stb_vorbis :: #system_library "stb_vorbis";
    } else #if CPU == .ARM64 {
        lib_stb_vorbis :: #system_library "stb_vorbis";
    }
} else #if OS == .PS5 {
    lib_stb_vorbis :: #system_library "stb_vorbis";
} else {
    #assert false;
}
