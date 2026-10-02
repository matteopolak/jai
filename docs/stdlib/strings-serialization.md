# Strings, Unicode, and text files

## What it is

These modules provide independently authored byte-string operations, UTF-8 scalar conversion, Base64, string builders, line-oriented text loading, and console formatting. The newer maintained OpenJai declarations define the default `String`, `Unicode`, and Base64 surfaces; supplied older declarations define modules without a newer equivalent.

## How it works

`String/byte-core.jai` contains operations that only read or update byte views: comparisons, searches, trimming, wildcard matching, path components, and numeric recognition. `String/module.jai` adds allocation, joining, replacement, splitting, and the newer contiguous `String_Builder` with `data`, `count`, and `allocated` fields. Core functions are loaded by the real module and directly by allocation-free behavior fixtures.

Search, trim, slice, path, and token results borrow input bytes. `slice` returns an empty view for invalid bounds. Case conversion is ASCII. Wildcards recognize `*` and `?`; they do not interpret bracket classes or filesystem rules. Integer parsing checks signed 64-bit bounds before conversion. Decimal float parsing accepts a sign, decimal point, and decimal exponent and rejects trailing garbage; it is not a general locale or hexadecimal parser.

The newer builder grows a contiguous heap allocation geometrically. `append` and `print_to_builder` report allocation failure. `builder_to_string(builder, allocator := Basic.temp)` copies without resetting. `free_buffers` frees the heap and clears the record. Its result uses the requested allocator, so callers must follow that allocator's lifetime.

`Basic/String_Builder.jai` implements the distinct supplied builder contract: an inline first segment, linked spill segments, captured allocator, `failed` flag, and direct ensured-space writes. `builder_to_string` allocates a heap result and resets by default. `append_and_steal_buffers` transfers content by re-appending, then resets the source; it preserves allocator ownership rather than re-linking foreign allocations. `write_builder` reports bytes submitted to the runtime sink; the sink itself does not expose a native short-write count.

`Unicode/utf8-core.jai` validates Unicode scalar values, UTF-8 continuation bytes, minimum encoding lengths, surrogates, truncation, and output capacity. Invalid or exhausted input does not advance `utf8_next_character`. The unbounded pointer-only `unicode_next_character` helper requires the caller to provide accessible complete input. The heap encoder and iteration macro live in `Unicode.jai`.

Base64 packs three bytes into four symbols. Decoding accepts ASCII whitespace and padded or unpadded input, checks terminal padding and unused low bits, and rejects unknown symbols. `base64url_encode` omits padding. The alphabet APIs require 64 distinct symbols. The decoder-table constants are generated from the RFC 4648 alphabets, with explicit whitespace, padding, and invalid markers.

`Text_File_Handler` consumes CR, LF, and CRLF lines; tracks physical line numbers; strips configured comments; optionally skips blank lines; and reads a leading `[version]`. Its failure flag is sticky across starts. In-memory input is borrowed; file input is owned until `deinit`. `file_to_array` copies each retained line so the array survives handler teardown. `file_to_table` retains those copied keys; callers own their eventual cleanup.

`Print_Color` emits ANSI SGR sequences through the runtime output sink. Color constants retain their specified values. It does not use the older Windows console-attribute path. `Print_Vars` evaluates each supplied code expression once, formats aligned names/values/types, and uses Compiler node inspection plus Program_Print for expression names.

## How to change it

Keep allocation-free algorithms in the core files and add focused vectors to `stdlib/tests/string-byte-core.jai` or `stdlib/tests/utf8-scalar.jai`. Preserve borrowed versus owned results when adding helpers. Builder changes must preserve each version's distinct layout and return/default contracts; callers importing both modules should qualify the builder type and helpers with `Basic.` or `String.`.

Extend UTF-8 checks together with the malformed-sequence fixture. Add a separate conversion API for other encodings rather than weakening scalar validity. Base64 alphabet extensions should use `base64_encode_with_alphabet`, `base64_decode_with_alphabet`, or `base64_decode_with_table`; keep validation of padding and discarded bits.

The supplied richer String API is available under `stdlib/legacy/String/module.jai`; legacy Base64 decoder parameters and Unicode's baked `strict` parameter/void encoder are under `stdlib/legacy`. This is a selected compatibility surface, not full behavioral parity: legacy String's `scan`/`scan2` and its old test procedure are absent, and the legacy Unicode decoder always enforces scalar validity. Use an explicit version path or module search configuration. Do not load conflicting String modules into the same namespace. Legacy String uses the supplied `Basic.String_Builder` contract.

## Configuration

- `Basic.temp` is the newer builder-to-string default allocator; Basic's supplied builder captures `context.allocator`.
- `STRING_BUILDER_BUFFER_SIZE` derives from the supplied buffer header. `ENABLE_ASSERT` controls its `ensured_count` field and bounds checks; `buffer_size` controls spill capacity.
- Text handlers expose `comment_character`, `do_version_number`, `strip_comments_from_ends_of_lines`, and `auto_skip_blank_lines`. `file_to_array`/`file_to_table` also expose trimming, blank-line, and memory-input options.
- Console APIs expose `color`, `style`, and `to_standard_error`. ANSI support depends on the receiving terminal.

## Dependencies and verification

Allocation, arrays, formatting, and output rely on the authored Basic module. File-backed text loading uses the authored File module; table conversion uses Hash_Table. Print_Vars requires Compiler and Program_Print. No supplied implementation, compiler binary, or native library is used as an implementation dependency.

The frozen repository compiler at `target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs` parses all these source files except Print_Vars, where it rejects the retained baked variadic `Code` contract. Print_Vars passes lexing. Default source-body checks stop in Basic's `size_of(String_Builder.Buffer)` constant; this does not establish allocation, output, file access, iteration-macro, or reflection behavior.

The actual String byte core and UTF-8 scalar core pass executable compile-time vectors with the authored preload and runtime support disabled. Each suite was also checked with an intentionally incorrect expected value and produced `compile-time assertion failed`. These prove the tested pure algorithms, not full module integration or native execution. Reproduce the positive checks with:

```sh
JAI_RS_MODULE_PATH="$PWD/stdlib" \
JAI_RS_PRELOAD="$PWD/prelude/Preload.jai" \
JAI_RS_RUNTIME_SUPPORT=off \
target/standard-library-snapshots/b1b820444e2a6585cda11d8efc2bf2186c5a6623cf54312552ba403d4e64fd13/jai-rs \
check-library stdlib/tests/string-byte-core.jai
```

Use the same command with `stdlib/tests/utf8-scalar.jai` for Unicode. Machine-readable evidence and outstanding gaps are in `stdlib/.coverage/strings-serialization.json`. [Binary formats](binary-formats.md) and [command-line parsing](command-line.md) have separate manifests and fixtures.
