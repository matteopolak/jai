# Portable data/resource progress

Stable earlier checkpoints: a8f982b package wire/ICO primitives, 4dc5881 subtitles,
75e1e55 checked resource backend. The detailed review batch has now been applied.

All reviewed exports across Ico_File, Icon, Windows_Resources, Subtitles and
Simple_Package are present with real bodies. Five-frame ICO uses actual native
stb resizing and exact padded wire fields; filename conversion is bottom-up BGR.
LLVM RC consumes five-frame output, private groups match its bytes, lld-link
creates a real PE, and ImageIO decodes the 256x256 frame. Gradient decoding is
compared with an independently invoked native SDK resize.

Packages preserve duplicate entries with first-match lookup, and TOC names/payloads
can borrow distinct buffers; the initialized header bounds payloads. Subtitles
now uses zero-based public CSV counters with display offset 262, suppresses rows
without spoken text, and omits event end times when begin is negative.

Windows APIs include real Unicode transactions, copied/aligned frame payloads,
manifest construction, registry Kits roots, numeric SDK selection, Setup COM
enumeration/registry fallback and compile-time console flags. Icon has real
callbacks, borrowed options and post-write dispatch. A Windows compiler host is
required for mutation. Console arguments remain alive for compiler process
lifetime because the current Compiler API borrows their slice.

Current native host is macOS ARM64. Original native Windows SDK readback/public
API tests are prepared and target-checked, not executed. Positive native Icon
attachment/discovery remains a Windows gate. The portable suite retains genuine
Subtitles/Simple_Package WASI evidence; unsupported image probes report missing
native imports rather than replacing them. See current API ledger and deviations.
