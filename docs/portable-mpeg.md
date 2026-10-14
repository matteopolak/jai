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

Program-stream demux, audio/video decoding and Plm lifecycle remain unfinished.
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
