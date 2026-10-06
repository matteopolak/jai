# Binary formats

## What it is

Readers and writers for small file formats: RIFF/WAVE (`Wav_File`), IMA/DVI ADPCM decoding (`Adpcm`), Windows icons (`Ico_File`), the ZIP central directory (`Zip_File_Directory`) and MD5 (`md5`). Checksums and hashes (`Crc`, `xxHash`, `Hash`) are in [memory and allocators](memory-and-allocators.md); codec library bindings (`stb_image`, `stb_vorbis`, `lz4`, `pl_mpeg`, ...) in [native bindings](native-bindings.md).

## How it works

- `Wav_File`: `load_wav_file(buffer)` parses the RIFF header and the `fmt` and `data` chunks. Sample data borrows the caller's buffer. `get_wav_header` and `get_waveformatex_header` expose the raw headers. PCM and DVI ADPCM are recognised.
- `Adpcm`: `IMA_ADPCM_decode` decodes a block into a buffer described by `Adpcm_Info` (up to `ADPCM_CHANNELS_MAX` = 9 channels); `Fill_IMA_ADPCM_block` decodes one 4-byte group for a channel.
- `Ico_File`: `create_ico_file(x, y, comp, image_data)` builds an `.ico` from bottom-up BGR/BGRA pixels; `create_ico_file_from_bitmap_filename` reads a bitmap first.
- `Zip_File_Directory`: `load_zip_directory(path, ...)` finds the end-of-central-directory record and fills `Zip_Directory.entries`. It reads the directory only and does not decompress.
- `md5(input)` returns the lowercase hex digest, allocated.

## How to change it

Each format keeps its own little-endian helpers (`wav_u16`, `zip_u32`, ...).

Tests are in `stdlib/tests/`: `binary-wav.jai`, `binary-adpcm.jai`, `binary-md5.jai`. `binary-mock-file/binary-zip.jai` and `binary-ico.jai` replace `File` and `Basic` with mocks from that directory's `modules/`, which `jaic` searches before the stdlib. The sweep's `modules` set runs them; run directly without the right `-I`, they fail with "module 'File' has no exported member 'archive'".

## Dependencies

`Basic`, `File` (zip and ico), `String`.
