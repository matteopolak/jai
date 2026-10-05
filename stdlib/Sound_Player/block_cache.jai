// Compressed sounds are never decoded whole. Each stream owns a Block_Cache holding decoded
// blocks of frames around its play cursor (and around the loop start when a repeat is close).
// Blocks are requested during updates; with the worker thread running they are decoded there,
// otherwise on the spot.
//
// Ownership: a block's pcm is written only while it is not `ready` (by whoever decodes it) and read
// only once it is `ready` (by the mixer). `ready`, the block lists and the queue change only under
// player.lock, so the decoder itself runs unlocked.

#scope_module
#import "stb_vorbis";
#import "Adpcm";

Block_Codec :: enum u8 { VORBIS; IMA_ADPCM; }

Decoded_Block :: struct {
    owner:  *Block_Cache;
    first:  s64;    // First frame of the block.
    frames: s64;    // Frames actually decoded; valid once ready.
    pcm:    *s16;   // Interleaved, owner.channels values per frame.
    ready:  bool;
    wanted: bool;   // Scratch flag for keep_blocks_near_cursor.
}

Block_Cache :: struct {
    codec:        Block_Codec;
    sound:        *Sound_Data;
    channels:     s64;
    rate:         s64;
    length:       s64;   // Frames in the whole sound.
    block_frames: s64;

    blocks:   [..] *Decoded_Block;
    last_hit: *Decoded_Block;   // The mixer usually reads the same block many times in a row.

    in_flight:     s32;            // Blocks queued on the worker that are not ready yet.
    parked_stream: *Sound_Stream;  // Stopped stream waiting for in_flight to reach zero.

    vorbis: *stb_vorbis;
}

VORBIS_BLOCK_FRAMES     :: 8192;
ADPCM_PACKETS_PER_BLOCK :: 4;
// Decoded audio kept ahead of the cursor. Shorter would stutter when the game runs below ~3 fps.
SECONDS_KEPT_DECODED    :: 0.4;

decode_queue: [..] *Decoded_Block;

open_vorbis_cache :: (data: *Sound_Data) -> *Block_Cache {
    handle := open_vorbis_handle(data);
    if !handle return null;
    info := stb_vorbis_get_info(handle);
    if info.channels < 1 || info.channels > MAX_CHANNELS_PER_SOUND || info.sample_rate == 0 {
        stb_vorbis_close(handle);
        return null;
    }
    cache := New(Block_Cache);
    cache.codec        = .VORBIS;
    cache.sound        = data;
    cache.vorbis       = handle;
    cache.channels     = info.channels;
    cache.rate         = info.sample_rate;
    cache.length       = stb_vorbis_stream_length_in_samples(handle);
    cache.block_frames = VORBIS_BLOCK_FRAMES;
    return cache;
}

open_adpcm_cache :: (data: *Sound_Data) -> *Block_Cache {
    if !data.samples || data.nBlockAlign <= 0 || data.wSamplesPerBlock <= 0 return null;
    if data.nchannels < 1 || data.nchannels > MAX_CHANNELS_PER_SOUND return null;
    cache := New(Block_Cache);
    cache.codec        = .IMA_ADPCM;
    cache.sound        = data;
    cache.channels     = data.nchannels;
    cache.rate         = data.sampling_rate;
    cache.length       = data.nsamples_times_nchannels / data.nchannels;
    cache.block_frames = ADPCM_PACKETS_PER_BLOCK * cast(s64) data.wSamplesPerBlock;
    return cache;
}

close_block_cache :: (cache: *Block_Cache) {
    for cache.blocks drop_block(it);
    array_free(cache.blocks);
    if cache.vorbis stb_vorbis_close(cache.vorbis);
    free(cache);
}

// Marks the blocks the stream will need soon, requests the missing ones and frees decoded blocks
// that fell out of range. Lock held.
keep_blocks_near_cursor :: (stream: *Sound_Stream) {
    cache := stream.voice.cache;
    for cache.blocks it.wanted = false;

    reach := cast(s64) (max(SECONDS_KEPT_DECODED, player.config.seconds_to_fill_ahead) * cache.rate) + 1;
    loop_start, loop_end := loop_region(stream);
    cursor := cast(s64) stream.play_cursor;
    if cursor < 0 cursor = loop_start;   // In the pause before a repeat.

    want_frames(cache, cursor, cursor + reach);
    if (stream.user_flags & .REPEATING) && cursor + reach >= loop_end want_frames(cache, loop_start, loop_start + reach);

    // Blocks still being decoded stay; they are dropped on a later pass if still unwanted.
    index := 0;
    while index < cache.blocks.count {
        block := cache.blocks[index];
        if block.wanted || !block.ready {
            index += 1;
            continue;
        }
        if cache.last_hit == block cache.last_hit = null;
        drop_block(block);
        array_unordered_remove_by_index(*cache.blocks, index);
    }
}

// The ready block that contains `frame`, or null. Lock held.
block_holding :: (cache: *Block_Cache, frame: s64) -> *Decoded_Block {
    hit := cache.last_hit;
    if hit && frame >= hit.first && frame < hit.first + hit.frames return hit;
    for cache.blocks {
        if it.ready && frame >= it.first && frame < it.first + it.frames {
            cache.last_hit = it;
            return it;
        }
    }
    return null;
}

// Worker side: decodes the oldest queued block. Returns false when the queue was empty.
decode_one_queued_block :: () -> bool {
    lock(*player.lock);
    if !decode_queue.count {
        unlock(*player.lock);
        return false;
    }
    block := decode_queue[0];
    array_ordered_remove_by_index(*decode_queue, 0);
    abandoned := block.owner.parked_stream != null;
    unlock(*player.lock);

    if !abandoned fill_block(block);

    lock(*player.lock);
    land_block(block);
    unlock(*player.lock);
    return true;
}

// Used at shutdown, after the worker stopped: queued blocks will never be decoded. Lock held.
cancel_queued_decodes :: () {
    for decode_queue land_block(it);
    array_reset(*decode_queue);
}

#scope_file

open_vorbis_handle :: (data: *Sound_Data) -> *stb_vorbis {
    status: s32;
    if data.filename_to_stream_from.count > 0 {
        path := temp_c_string(data.filename_to_stream_from);
        return stb_vorbis_open_filename(path, *status, null);
    }
    if data.buffer.count == 0 || data.buffer.count > S32_MAX return null;
    return stb_vorbis_open_memory(data.buffer.data, cast(s32) data.buffer.count, *status, null);
}

want_frames :: (cache: *Block_Cache, from: s64, to: s64) {
    to = min(to, cache.length);
    first := (max(from, 0) / cache.block_frames) * cache.block_frames;
    while first < to {
        block: *Decoded_Block;
        for cache.blocks if it.first == first { block = it; break; }
        if !block block = request_block(cache, first);
        block.wanted = true;
        first += cache.block_frames;
    }
}

request_block :: (cache: *Block_Cache, first: s64) -> *Decoded_Block {
    block := New(Decoded_Block);
    block.owner = cache;
    block.first = first;
    block.pcm   = cast(*s16) alloc(cache.block_frames * cache.channels * size_of(s16));
    array_add(*cache.blocks, block);

    if CACHED_OGG_DECODE_THREADED && player.worker_running {
        cache.in_flight += 1;
        array_add(*decode_queue, block);
        signal(*player.worker_wake);
    } else {
        fill_block(block);
        block.ready = true;
    }
    return block;
}

// A queued block finished (or was cancelled). Frees a parked stream once its last block lands.
land_block :: (block: *Decoded_Block) {
    cache := block.owner;
    block.ready = true;
    cache.in_flight -= 1;
    if cache.in_flight > 0 || !cache.parked_stream return;
    stream := cache.parked_stream;
    close_block_cache(cache);
    streams_waiting_on_decodes -= 1;
    give_back(stream);
}

drop_block :: (block: *Decoded_Block) {
    free(block.pcm);
    free(block);
}

fill_block :: (block: *Decoded_Block) {
    cache := block.owner;
    block.frames = 0;
    if cache.codec == {
        case .VORBIS;    block.frames = decode_vorbis_range(cache, block.first, block.pcm);
        case .IMA_ADPCM; block.frames = decode_adpcm_range(cache, block.first, block.pcm);
    }
}

decode_vorbis_range :: (cache: *Block_Cache, first: s64, out: *s16) -> s64 {
    wanted := min(cache.block_frames, cache.length - first);
    if wanted <= 0 || first > U32_MAX return 0;
    if !stb_vorbis_seek(cache.vorbis, cast(u32) first) return 0;
    got := 0;
    while got < wanted {
        values_left := (wanted - got) * cache.channels;
        count := stb_vorbis_get_samples_short_interleaved(cache.vorbis, cast(s32) cache.channels, out + got * cache.channels, cast(s32) values_left);
        if count <= 0 break;
        got += count;
    }
    return got;
}

decode_adpcm_range :: (cache: *Block_Cache, first: s64, out: *s16) -> s64 {
    sound := cache.sound;
    packet_bytes  := cast(s64) sound.nBlockAlign;
    packet_frames := cast(s64) sound.wSamplesPerBlock;
    payload := cast(*u8) sound.samples;

    // The packets normally live inside `buffer`; when they do, never read past its end.
    packet_count := (cache.length + packet_frames - 1) / packet_frames;
    payload_bytes := packet_count * packet_bytes;
    buffer_end := sound.buffer.data + sound.buffer.count;
    if payload >= sound.buffer.data && payload < buffer_end payload_bytes = min(payload_bytes, buffer_end - payload);

    info: Adpcm_Info;
    info.nChannels        = cast(s32) cache.channels;
    info.nBlockAlign      = sound.nBlockAlign;
    info.wSamplesPerBlock = sound.wSamplesPerBlock;

    capacity := cache.block_frames * cache.channels * size_of(s16);
    written := 0;
    packet := first / packet_frames;
    for 0..ADPCM_PACKETS_PER_BLOCK-1 {
        offset := (packet + it) * packet_bytes;
        if offset + packet_bytes > payload_bytes break;
        source: [] u8;
        source.data  = payload + offset;
        source.count = packet_bytes;
        target: [] u8;
        target.data  = cast(*u8) out + written;
        target.count = capacity - written;
        produced := IMA_ADPCM_decode(info, source, target);
        if produced <= 0 break;
        written += produced;
    }
    frames := written / (cache.channels * size_of(s16));
    return min(frames, max(0, cache.length - first));
}
