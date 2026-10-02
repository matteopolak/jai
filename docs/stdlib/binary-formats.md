# Binary formats and hashing

## What it is

These repository-authored Jai modules parse WAV headers, inspect ZIP directory records, decode IMA ADPCM audio, generate ICO files, and calculate MD5 digests. They preserve the relevant public record fields and procedure contracts without loading supplied compiler binaries or using supplied native image libraries.

## Public contracts

| Import | Procedures and records | Coverage |
| --- | --- | --- |
| `Wav_File` | `Wav_Format`, `Wav_Extra`, `Wav_File`, `get_wav_header`, `load_wav_file` | Newer maintained-source interface; actual RIFF parsing replaces the corpus implementation's assumed PCM defaults. |
| `legacy/Wav_File` | `Waveformatex`, `Wave_Extra_Info`, `get_wav_header` | Explicit supplied-distribution return contract. |
| `Adpcm` | `Adpcm_Info`, `ADPCM_State`, `IMA_ADPCM_decode`, `IMA_ADPCM_nibble`, `Fill_IMA_ADPCM_block`, public quantizer tables | IMA/DVI WAVE blocks; no encoder. |
| `Ico_File` | `create_ico_file`, `create_ico_file_from_bitmap_filename`, sizing helpers | BGR/BGRA source pixels; filename loading supports uncompressed 24/32-bit BMP. |
| `Zip_File_Directory` | `Zip_Entry`, `Zip_Directory`, `load_zip_directory`, `deinit` | Classic single-disk central directories, archive comments, local payload offsets. |
| `md5` | `md5` | RFC 1321 digest returned as 32 lowercase hexadecimal bytes. |

`Wav_File.get_wav_header` cannot preserve both WAV interfaces under one name: the same `string` input has incompatible return records. The default follows `corpus/upstream/withlang-dev--open-jai/modules/Wav_File/module.jai`; old callers can import `legacy/Wav_File`. The default also exports `get_waveformatex_header` and the full older records when callers need their additional fields.

## How it works

The WAV reader checks the `RIFF`/`WAVE` envelope, walks chunks including odd-length padding, and retains the first `data` slice. The `fmt ` chunk supplies PCM or IMA ADPCM fields; `fact` supplies the sample count. Data may precede the format chunk. The outer RIFF length is bounded by available bytes, while a truncated inner chunk fails. Both a valid format and a data chunk are required. Returned sample bytes borrow the input buffer and remain valid only while it is alive.

The ADPCM reader validates channel counts, block dimensions, output capacity, and all initial quantizer indices before writing. Each channel begins with a signed little-endian predictor and a step index. Four-byte packets produce eight low-nibble-first samples and are interleaved into signed little-endian 16-bit PCM. A trailing block containing only complete four-byte channel headers is supported. Malformed layouts return `0`; no output bytes are written during validation failures. The direct packet helper requires enough output room and otherwise returns without writing. The old `#no_alias` optimization annotation is omitted because the frozen source parser does not recognize it; the parameter and behavior contract is retained.

The ICO writer samples each source image into 256, 128, 48, 32, and 16 pixel entries, writes little-endian DIB headers and bottom-up BGR/BGRA rows, and marks zero-alpha BGRA pixels in the AND mask. Sampling uses nearest neighbors. It retains the supplied sizing helpers' spare-capacity arithmetic and the output's trailing spare header capacity; those bytes are zero. Raw input pixels use the supplied API's bottom-up BGR/BGRA convention. The BMP filename reader normalizes either BMP row orientation, removes row padding, and expands to BGRA before calling the writer. A 32-bit `BI_RGB` BMP with all zero fourth bytes is treated as opaque XRGB. Returned ICO bytes are allocator-owned. PNG/JPEG/GIF input loading, compressed BMP, palette BMP, and reference image-resizer filtering are unsupported; filename creation returns `""` for such files.

The ZIP reader searches backward across the maximum archive-comment window for an end record whose declared comment ends at EOF. It checks central records and reads each local header to calculate `chunk_offset`, including that header's actual filename and extra-field lengths. This avoids assuming central and local extra fields have equal lengths. Entry filenames borrow `dir.memory_block`. Compressed entries and entries with data descriptors can be inspected because their sizes come from the directory; extraction and decompression are outside this API. Multi-disk archives, ZIP64 sentinel sizes/counts/offsets, corrupt/truncated records, and unsupported directory envelopes return `false` with an empty directory.

`load_zip_directory` retains `close_file := true`. On success with `close_file = false`, the caller owns `dir.file` and must close it. `deinit` frees names, directory storage, and entry storage and can safely be called again; it deliberately does not close the file. Failure closes the opened file and frees partial allocations. The writable existing-file open mode is retained for callers that edit directory attributes after loading.

MD5 processes full 64-byte blocks directly, pads a final stack block with the original bit length, and formats the final four words in little-endian byte order. Arithmetic explicitly truncates additions to 32 bits. Only the returned digest allocates; callers release it with `Basic.free`.

## How to change it

Keep the byte readers and writers explicit: mapped structs and pointer casts would reintroduce alignment and host-endian assumptions. Extend WAV format tags only with corresponding format validation, and keep the modern-to-legacy adapters together. Add other ICO file decoders before `create_ico_file`, while keeping its documented BGR/BGRA orientation. Change resampling in its pixel loop if smoother scaling is required.

For ZIP64 support, add the locator/extended end-record flow and parse per-entry ZIP64 extra fields before converting offsets to the current `u32` `chunk_offset`; that public field cannot represent arbitrary ZIP64 payload positions. Add independent MD5 vectors at padding boundaries when changing its compressor. `stdlib/.coverage/binary-formats.json` records API sources, supported cases, and current validation limits.

## Configuration

There are no module parameters or environment variables specific to these algorithms. `ADPCM_CHANNELS_MAX` remains `9`; the ADPCM byte-count return is `s32`, so input/output beyond its bounded range are rejected. ICO source components must be `3` or `4` and source addressing must fit the bounded size checks. Memory allocation follows `context.allocator` through `Basic`.

To select these sources for source checks, set `JAI_RS_MODULE_PATH` to the repository's `stdlib` directory, `JAI_RS_PRELOAD` to `prelude/Preload.jai`, and `JAI_RS_RUNTIME_SUPPORT=off`. The frozen CLI's `parse` validates syntax; `check-library` resolves and checks source and evaluates the authored compile-time assertion witnesses. Native file operations additionally require the authored `File` module's platform SDK boundary.

## Dependencies and validation

WAV and ADPCM have no module dependencies. MD5 uses `Basic` allocation. ICO and ZIP use `Basic` and `File`; filename operations inherit the `File` module's platform requirements. No supplied native image codec or resizer is linked.

The six sources, including the legacy wrapper, passed the frozen parser. WAV, its legacy wrapper, and ADPCM passed normal `check-library`. Their committed compile-time witnesses are `stdlib/tests/binary-wav.jai` and `binary-adpcm.jai`: odd unknown WAV chunk padding, data-before-format, parsed PCM fields and samples, invalid/truncated WAV input, ADPCM nibble evolution and saturation, a complete silent mono block, and invalid step-index rejection before output mutation. A deliberately incorrect WAV sample-rate expectation failed, confirming that the witness assertions executed.

MD5, ICO, and ZIP also pass source checking with the explicitly isolated fixture dependencies in `stdlib/tests/binary-format-fixtures`. Its `Basic` provides a bounded 512-byte test arena, and its `File` provides a seekable memory stream. These fixtures are test dependencies only and are excluded from production implementation coverage. Use `JAI_RS_MODULE_PATH=$PWD/stdlib/tests/binary-format-fixtures:$PWD/stdlib` with the same preload/runtime settings to reproduce `binary-md5.jai`, `binary-ico.jai`, and `binary-zip.jai`.

The MD5 witness passes all seven RFC 1321 vectors plus independent 55/56/63/64-byte padding-boundary vectors. The ZIP witness passes a handcrafted archive with a comment, a data descriptor, a local extra field absent from the central record, metadata and payload-offset checks, explicit retained-file lifetime, directory cleanup, and multidisk rejection returning empty storage. ICO witnesses check exact sizing-helper values, bounded overflow rejection, invalid raw inputs, and unsupported filename input rejection. They do not render a complete icon.

Normal MD5/ICO/ZIP dependency-graph checks remain blocked in the frozen snapshot by shared `Basic/String_Builder.jai` typed constant evaluation and `File/module.jai` target `OS` resolution. Isolated algorithm checks do not establish those shared-module checks or native file interoperability. Complete ICO pixel output, BMP conversion output, and native ZIP file I/O remain unverified.

Format references: [MD5 RFC 1321](https://www.rfc-editor.org/rfc/rfc1321), [Microsoft RIFF documentation](https://learn.microsoft.com/en-us/windows/win32/xaudio2/resource-interchange-file-format--riff-), [Microsoft icon documentation](https://learn.microsoft.com/en-us/windows/win32/menurc/icons), and the [PKWARE ZIP specification](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT).
