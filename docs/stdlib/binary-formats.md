# Binary formats and checksums

## What it is

Readers and writers for a few small file formats: RIFF/WAVE (`Wav_File`), IMA/DVI ADPCM decoding (`Adpcm`), Windows icons (`Ico_File`), the ZIP central directory (`Zip_File_Directory`) and the MD5 digest (`md5`). Checksums and hashes (`Crc`, `xxHash`, `Hash`) are covered in [memory-and-allocators](memory-and-allocators.md). Bindings to image and audio codec libraries (`stb_image`, `stb_vorbis`, `lz4`, `pl_mpeg`, ...) are in [native-bindings](native-bindings.md).

## How it works

- `Wav_File`: `load_wav_file(buffer: string)` parses the RIFF header and `fmt`/`data` chunks into a `Wav_File`; returned sample data borrows the caller's byte storage. `get_wav_header` and `get_waveformatex_header` expose the raw headers. PCM (`WAVE_FORMAT_PCM`) and DVI ADPCM (`WAVE_FORMAT_DVI_ADPCM`) are recognized.
- `Adpcm`: `IMA_ADPCM_decode` decodes a block of ADPCM bytes into a destination buffer described by `Adpcm_Info` (up to `ADPCM_CHANNELS_MAX` = 9 channels); `Fill_IMA_ADPCM_block` decodes one 4-byte group for a channel using `ADPCM_State`.
- `Ico_File`: `create_ico_file(x, y, comp, image_data)` builds an `.ico` image string from raw bottom-up BGR/BGRA pixels, and `create_ico_file_from_bitmap_filename` reads a bitmap file first; `get_bytes_for_image` and `get_total_bytes_for_size` compute sizes.
- `Zip_File_Directory`: `load_zip_directory(path, ...)` opens the file with `File`, finds the end-of-central-directory record and fills `Zip_Directory.entries` (`filename`, `chunk_offset`, `position_in_file`, `chunk_len`, `compressed_len`, `bit_flag`). It reads the directory only; it does not decompress entries.
- `md5(input)` returns the lowercase hex digest as an allocator-owned string.

## How to change it

- Keep the little-endian helpers (`wav_u16`, `zip_u32`, ...) next to their module; each format has its own.
- Tests are in `stdlib/tests/`: `binary-wav.jai`, `binary-adpcm.jai`, `binary-md5.jai` run as is. `stdlib/tests/binary-mock-file/binary-zip.jai` and `binary-ico.jai` replace `File` (and `Basic`) with mocks from that directory's `modules/` folder, which `jaic` searches before the stdlib. The sweep's `modules` set runs them all.

- Without `-I` those two fail with "module 'File' has no exported member 'archive'", which is expected.

## Configuration

None.

## Dependencies

`Basic`, `File` (zip and ico), `String`.
