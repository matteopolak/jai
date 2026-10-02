// Independently normalized ABI contract. No reference procedure bodies or binaries.
#import "Adpcm" ;
#import "stb_vorbis" ;
#import "Basic" ;
Decoder_Type :: enum {
    OGG :: 0 ;
    ADPCM :: 1 ;
}
Cached_Decoder_Page :: struct {
    type : Decoder_Type ;
    owner : * Cached_Decoder ;
    start_address : s64 = - 1 ;
    end_address : s64 = - 1 ;
    page_index : s64 = - 1 ;
    data : * void ;
    buffer_length_in_bytes : s64 ;
    num_samples_contained : s64 ;
    marked := false ;
}
Cached_Decoder :: struct {
    type : Decoder_Type ;
    pages : [ .. ] * Cached_Decoder_Page ;
    issued_start_addresses : [ .. ] s64 ;
    page_size_in_samples : s64 = - 1 ;
    uncompressed_length_in_samples : s64 = 0 ;
    num_channels : s64 ;
    sampling_rate : s64 ;
    sound_data : * Sound_Data ;
    stream : * Sound_Stream ;
    do_not_queue := true ;
    deinit_proc : ( decoder : * Cached_Decoder ) -> ( ) ;
    add_decode_queue_item : ( page : * Cached_Decoder_Page ) -> ( ) ;
    recompute_page : ( decoder : * Cached_Decoder , page : * Cached_Decoder_Page ) -> ( ) ;
    make_page : ( decoder : * Cached_Decoder ) -> * Cached_Decoder_Page ;
}
Cached_Ogg_Decoder :: struct {
    using base : Cached_Decoder ;
    vorbis_file : * stb_vorbis ;
    seek_base : s64 ;
    opus_pre_skip : s64 ;
    bytes_per_mono_sample : s64 ;
    uncompressed_length_in_bytes : s64 ;
    bitrate_low : s64 ;
    bitrate_nominal : s64 ;
    bitrate_high : s64 ;
}
;
CACHED_OGG_DECODE_NUM_THREADS :: 1 ;
get_base_address :: ( decoder : * Cached_Decoder , play_cursor : s64 ) -> s64 {
    pages := play_cursor / decoder.page_size_in_samples;
    return pages * decoder.page_size_in_samples;
}
unmark_all_pages :: ( using decoder : * Cached_Decoder ) {
    index: s64 = 0;
    while index < decoder.pages.count {
        decoder.pages[index].marked = false;
        index += 1;
    }
}
mark_relevant_pages :: ( using decoder : * Cached_Decoder , start : s64 , end : s64 ) {
    if !decoder || decoder.page_size_in_samples <= 0 || end <= start return;
    start = max(start, 0);
    end = min(end, decoder.uncompressed_length_in_samples);
    address := get_base_address(decoder, start);
    while address < end {
        page := find_page_by_base_address(decoder, address);
        if page { page.marked = true; }
        else {
            issued := false;
            for pending: decoder.issued_start_addresses if pending == address { issued = true; break; }
            if !issued {
                page = decoder.make_page(decoder);
                if !page return;
                page.start_address = address;
                page.page_index = address / decoder.page_size_in_samples;
                page.marked = true;
                if decoder.do_not_queue || !decoder.add_decode_queue_item {
                    decoder.recompute_page(decoder, page);
                    array_add(*decoder.pages, page);
                } else {
                    array_add(*decoder.issued_start_addresses, address);
                    decoder.add_decode_queue_item(page);
                }
            }
        }
        address += decoder.page_size_in_samples;
    }
}
free_unmarked_pages :: ( using decoder : * Cached_Decoder ) {
    index: s64 = 0;
    while index < decoder.pages.count {
        page := decoder.pages[index];
        if page.marked { index += 1; continue; }
        free(page.data);
        free(page);
        array_unordered_remove_by_index(*decoder.pages, index);
    }
}
find_page_by_base_address :: ( using decoder : * Cached_Decoder , start_address : s64 ) -> * Cached_Decoder_Page {
    index: s64 = 0;
    while index < decoder.pages.count {
        page := decoder.pages[index];
        if page.start_address == start_address return page;
        index += 1;
    }
    return null;
}
find_page_containing_cursor :: ( using decoder : * Cached_Decoder , play_cursor : s64 ) -> ( found : bool , start_address : s64 , end_address : s64 , data : * void ) {
    index: s64 = 0;
    while index < decoder.pages.count {
        page := decoder.pages[index];
        if page.start_address <= play_cursor && play_cursor < page.end_address {
            return true, page.start_address, page.end_address, page.data;
        }
        index += 1;
    }
    return false, 0, 0, null;
}
deinit :: ( using decoder : * Cached_Decoder ) {
    if !decoder return;
    assert(decoder.issued_start_addresses.count == 0);
    for page: decoder.pages { free(page.data); free(page); }
    array_free(decoder.pages);
    array_free(decoder.issued_start_addresses);
    if decoder.deinit_proc decoder.deinit_proc(decoder);
    free(decoder);
}
create_ogg_decoder :: ( data : * Sound_Data , _page_size_in_samples : s64 ) -> * Cached_Decoder {
    if !data || _page_size_in_samples <= 0 return null;
    decoder := New(Cached_Ogg_Decoder);
    if !decoder return null;
    decoder.type = .OGG;
    decoder.sound_data = data;
    decoder.page_size_in_samples = min(_page_size_in_samples, 0x7fffffff / MAX_CHANNELS_PER_SOUND);
    decoder.deinit_proc = deinit_proc_ogg;
    decoder.make_page = make_page_ogg;
    decoder.recompute_page = recompute_page_ogg;
    if !start_vorbis_file(decoder) { free(decoder); return null; }
    return *decoder.base;
}
deinit_proc_ogg :: ( decoder : * Cached_Decoder ) {
    ogg := cast(*Cached_Ogg_Decoder) decoder;
    if ogg.vorbis_file stb_vorbis_close(ogg.vorbis_file);
    ogg.vorbis_file = null;
}
make_page_ogg :: ( using decoder : * Cached_Decoder ) -> * Cached_Decoder_Page {
    page := New(Cached_Decoder_Page);
    if !page return null;
    page.owner = decoder;
    page.type = decoder.type;
    page.buffer_length_in_bytes = decoder.page_size_in_samples * decoder.num_channels * 2;
    page.data = alloc(page.buffer_length_in_bytes);
    if !page.data { free(page); return null; }
    return page;
}
recompute_page_ogg :: ( using decoder : * Cached_Decoder , _page : * Cached_Decoder_Page ) {
    ogg := cast(*Cached_Ogg_Decoder) decoder;
    _page.end_address = _page.start_address;
    _page.num_samples_contained = 0;
    if !ogg.vorbis_file || _page.start_address < 0 || _page.start_address > 0xffffffff return;
    if stb_vorbis_seek(ogg.vorbis_file, cast(u32) _page.start_address) == 0 return;
    remaining := min(decoder.page_size_in_samples, decoder.uncompressed_length_in_samples-_page.start_address);
    frames: s64 = 0;
    while frames < remaining {
        count := stb_vorbis_get_samples_short_interleaved(ogg.vorbis_file, cast(s32) decoder.num_channels,
            cast(*s16) _page.data + frames*decoder.num_channels, cast(s32) ((remaining-frames)*decoder.num_channels));
        if count <= 0 break;
        frames += count;
    }
    _page.num_samples_contained = frames;
    _page.end_address = _page.start_address + frames;
}
start_vorbis_file :: ( using decoder : * Cached_Ogg_Decoder ) -> bool {
    error: s32;
    if decoder.sound_data.filename_to_stream_from.count > 0 {
        filename := to_c_string(decoder.sound_data.filename_to_stream_from);
        if !filename return false;
        decoder.vorbis_file = stb_vorbis_open_filename(filename, *error, null);
        free(filename);
    } else {
        bytes := decoder.sound_data.buffer;
        if bytes.count > 0x7fffffff return false;
        decoder.vorbis_file = stb_vorbis_open_memory(bytes.data, cast(s32) bytes.count, *error, null);
    }
    if !decoder.vorbis_file return false;
    info := stb_vorbis_get_info(decoder.vorbis_file);
    if info.channels < 1 || info.channels > MAX_CHANNELS_PER_SOUND || info.sample_rate == 0 {
        stb_vorbis_close(decoder.vorbis_file); decoder.vorbis_file = null; return false;
    }
    decoder.num_channels = info.channels;
    decoder.sampling_rate = info.sample_rate;
    decoder.uncompressed_length_in_samples = stb_vorbis_stream_length_in_samples(decoder.vorbis_file);
    decoder.bytes_per_mono_sample = 2;
    decoder.uncompressed_length_in_bytes = decoder.uncompressed_length_in_samples * decoder.num_channels * 2;
    return true;
}
get_compressed_rate_channels_and_size :: ( s : string ) -> ( num_samples : s64 , num_channels : s64 , sampling_rate : s64 ) {
    if s.count < 4 || s.count > 0x7fffffff return 0, 0, 0;
    error: s32;
    handle := stb_vorbis_open_memory(s.data, cast(s32) s.count, *error, null);
    if !handle return 0, 0, 0;
    defer stb_vorbis_close(handle);
    info := stb_vorbis_get_info(handle);
    return stb_vorbis_stream_length_in_samples(handle), info.channels, info.sample_rate;
}
ADPCM_BLOCKS_PER_PAGE :: 3 ;
Adpcm_Decoder :: struct {
    using base : Cached_Decoder ;
}
create_adpcm_decoder :: ( data : * Sound_Data ) -> * Adpcm_Decoder {
    if !data || data.nBlockAlign <= 0 || data.wSamplesPerBlock <= 0 || data.nchannels < 1 || data.nchannels > MAX_CHANNELS_PER_SOUND return null;
    decoder := New(Adpcm_Decoder);
    if !decoder return null;
    decoder.type = .ADPCM;
    decoder.sound_data = data;
    decoder.num_channels = data.nchannels;
    decoder.sampling_rate = data.sampling_rate;
    decoder.uncompressed_length_in_samples = data.nsamples_times_nchannels / data.nchannels;
    decoder.page_size_in_samples = ADPCM_BLOCKS_PER_PAGE * cast(s64) data.wSamplesPerBlock;
    decoder.make_page = make_page_adpcm;
    decoder.recompute_page = recompute_page_adpcm;
    return decoder;
}
make_page_adpcm :: ( using decoder : * Cached_Decoder ) -> * Cached_Decoder_Page {
    page := New(Cached_Decoder_Page);
    if !page return null;
    page.owner = decoder;
    page.type = decoder.type;
    page.buffer_length_in_bytes = decoder.page_size_in_samples * decoder.num_channels * 2;
    page.data = alloc(page.buffer_length_in_bytes);
    if !page.data { free(page); return null; }
    return page;
}
recompute_page_adpcm :: ( using decoder : * Cached_Decoder , page : * Cached_Decoder_Page ) {
    sound := decoder.sound_data;
    page.end_address = page.start_address;
    page.num_samples_contained = 0;
    if !sound || !sound.samples || page.start_address < 0 return;
    payload := cast(*u8) sound.samples;
    payload_offset := cast(s64) (payload - sound.buffer.data);
    if payload_offset < 0 || payload_offset > sound.buffer.count return;
    available := sound.buffer.count - payload_offset;
    block := page.start_address / sound.wSamplesPerBlock;
    cursor: s64 = 0;
    info: Adpcm_Info = .{nChannels=cast(s32) decoder.num_channels,
        nBlockAlign=sound.nBlockAlign, wSamplesPerBlock=sound.wSamplesPerBlock};
    for part: 0..ADPCM_BLOCKS_PER_PAGE-1 {
        position := (block+part)*sound.nBlockAlign;
        if position < 0 || position > available-sound.nBlockAlign break;
        input: []u8 = .{data=payload+position, count=sound.nBlockAlign};
        output: []u8 = .{data=cast(*u8) page.data+cursor, count=page.buffer_length_in_bytes-cursor};
        bytes := IMA_ADPCM_decode(info, input, output);
        if bytes <= 0 break;
        cursor += bytes;
    }
    frames := cursor / (2*decoder.num_channels);
    frames = min(frames, max(0, decoder.uncompressed_length_in_samples-page.start_address));
    page.num_samples_contained = frames;
    page.end_address = page.start_address+frames;
}
