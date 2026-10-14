# WAV byte-view parser

Wav_File exposes packed canonical Waveformatex metadata, Wave_Extra_Info, the two
reviewed format tags and get_wav_header. Private code lives in internal/audio.
The reader uses explicit little-endian byte assembly, including unaligned input,
and bounds reads by the smaller of the actual input and RIFF-declared length.
Chunk stepping honors even-byte padding, skips unknown chunks, and returns a
borrowed view of the first data chunk. PCM and IMA/DVI ADPCM metadata are accepted;
ADPCM samples-per-block and fact sample count are captured. No samples are decoded.

Tests cover PCM, ADPCM extensions/fact, odd unknown chunks, oversized RIFF/data
lengths, packed metadata size, truncated headers, invalid magic and unsupported
format tags. Interpreter/native execution, Linux/x64 and Windows/x64 checking,
and source-built jailint -D warnings pass for this scope. Repository formatter
engine formatting/check passes through the file-only frontend; the original
jaifmt CLI is still blocked at its File_Utilities.is_directory dependency.

The compiler currently narrows byte casts inside combined bitwise expressions:
pending/widened-bitwise.jai reproduces the failure. The byte reader uses explicit
widened locals so each shift operates on its intended width. This reproducer is
not counted as passing functionality and requires a compiler semantic fix.

Duplicate fmt/fact chunks and extensible WAV formats are not specified. The first
fmt/data chunks and last readable fact chunk are selected; extensible formats are
rejected. These choices remain subject to contract review. Sample views retain
the input lifetime and carry no ownership transfer.
