# MPEG implementation

The portable worker implements the reviewed `pl_mpeg` interface incrementally
under `stdlib/internal/media/mpeg`. The facade loads public definitions; file-local
helpers remain private. No reference Jai implementation was used. Licensed public
C algorithm input and its unmodified source digest are documented in
[third_party/pl_mpeg](../third_party/pl_mpeg/README.md).

Implemented scope: fixed, growing, append and file buffers; callbacks, end signals,
bit reads, seeking, start-code scans/lookahead and bounded signed/unsigned VLC
decoding. The canonical public `Buffer` name and layout are retained. Invalid bit
counts, malformed VLC tables and truncated VLC input assert rather than fabricate
decoded values. File operations check errors. Allocation failure returns null or
zero according to the operation; callers must retain the active allocator through
destruction. Ring seeks only accept rewind. File buffers own the handle only when
requested. Callback and borrowed memory lifetimes remain the caller's responsibility.

All reviewed public video/audio tables are immutable declarations generated from
the specifications, grouped by scan/reconstruction, entropy, framing and synthesis.
`tools/generate_mpeg_tables.py` uses the source-built repository formatter.
The appendix's complete synthesis and DCT data is used without substitution.

Plane/frame types, clamping, slice classification, six baked RGB layout aliases
and integer BT.601 conversion are implemented. Conversion checks nonnegative,
even visible dimensions, plane dimensions and output stride. It writes only the
three named color channels, preserving alpha and padding bytes. Plane strides may
differ. Raw pointer API cannot establish the actual allocated output extent.
Odd dimensions and alpha policy require contract review; neither is claimed as
resolved reference behavior.

The separable integer IDCT adapts the licensed C transform. Widened intermediates
and checked s32 stores reject coefficient overflow; zero, positive/negative DC and
horizontal AC behavior have independent regressions. Input uses the decoder's
premultiplied coefficient scale, not an arbitrary normalized floating-point DCT.

Video lifecycle, transactional sequence headers/custom matrices, frame storage,
motion vectors, half-pixel compensation, entropy decoding, dequantization, slices,
I/P/B reconstruction and delayed reference-frame ordering are implemented.
Coverage includes independent constant intra blocks and all ten red I/P frames
from the authorized synthetic fixture's elementary payload, twice with rewind.
Forward/backward prediction is tested directly; complete B-picture streams and
nonconstant AC reconstruction still need additional integration fixtures. The
tested fixture extraction is explicit test setup, not program-stream demux.
Truncated fields, bad runs/addresses and incomplete pictures assert. Legitimate
final slices with fewer than 23 remaining bits use bounded lookahead, so their
remaining macroblock is decoded instead of silently omitted. Fixed/append buffers
are not compacted by the decoder, preserving borrowed input and rewindability.

Repeated sequence headers update matrices while preserving pending references.
Midstream dimension/rate changes assert explicitly and remain unsupported. Invalid
D-picture types and motion regions are also rejected. Default frame storage is
zero-initialized, not returned as fabricated decoded data. Allocation-failure retry
and all sequence-test allocations are verified with a tracking allocator. Time
updates use checked s32 frame counts. IDCT currently runs even for DC-only blocks;
this trades performance for one verified reconstruction path. Per-picture byte
coverage checks reject missing and overlapping slice regions; reaching the final
macroblock address alone does not establish a completely decoded frame. That
check adds a temporary allocation and linear pass per picture. Missing reference
pictures are rejected instead of predicting from initialized placeholder storage.

Layer II audio lifecycle, sync/header parsing, quantizer allocation, grouped/direct
sample reconstruction, scalefactors, synthesis and interleaved output are implemented
for unprotected MPEG-1 Layer II frames. A valid zero-allocation frame reconstructs
silence. The authorized fixture's two explicitly extracted PES payloads yield sixteen
mono frames (18,432 samples), with real amplitude, channel equality, frequency and
rewind checks. Frequency uses the steady interior; diagnostics showed extra
low-amplitude zero crossings in the padded final frame. Range/channel/count checks
still cover every output sample. Invalid quantizer codes assert. Ancillary frame
bits are consumed according to the header's computed frame size.

Synthesis uses a private immutable precomputed 64x32 cosine matrix with delegated
Math.cos/PI64 and f64 accumulation. This is slower and can round differently than
the licensed C factorization. `python3 -B tools/check_portable_mpeg_matrix.py` builds
only the permitted public C input and compares all 2,048 basis results with the
direct mathematical matrix (observed maximum absolute difference below 9.5e-7).
It is algorithm verification, not a Jai API oracle. No supplied binary is used.
CRC-protected frames and changing bitrate/sample-rate/mode assert explicitly and
remain unsupported. Stereo/joint-stereo branches need independent stream fixtures.

Taking `*QUANT_TAB` before dynamic indexing uses the canonical aggregate's static
storage; quantizer return pointers are checked against that same public table.
The direct indexed-address compiler path returns a temporary; its original pending
regression fails after another call in both modes, including the rebuilt compiler.
Qualified window/quantizer stores also unexpectedly compile, unlike unqualified
constant-array and exported typed-scalar stores. These are reported compiler gaps;
the declarations remain canonical constants and no mutable table copy is substituted.

Program-stream demux and Plm lifecycle remain unfinished.
`buffer_no_start_code`, `BLOCK_SET` and `PUT_PIXEL` lack sufficiently specified
contracts and are not replaced with guessed exports. The ledger does not count
this module as complete. No decoded frames/audio results have been fabricated.

The original `pending/constructor-type-scope` regression records a general compiler
failure when a module defining `Buffer` uses a plain Basic import. Its public
constructor signature resolves incorrectly even when the body simply returns
null. Qualified imports compile and preserve the canonical type; no renamed
surrogate or manual allocation shortcut was used. Exact compiler root cause is
not yet established.

Windows target checking reaches the existing Unix-only File guard, even for a
pixel-only import, because the canonical Buffer contains a File field. Windows
MPEG validation is pending the separately owned File implementation. The runner
records that exclusion explicitly; it is not a Windows compatibility pass.
