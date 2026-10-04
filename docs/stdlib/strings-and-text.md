# Strings, Unicode and text files

## What it is

Byte-string utilities (`String`), UTF-8 scalar conversion (`Unicode`), Base64, a line-oriented loader (`Text_File_Handler`), ANSI console colors (`Print_Color`) and an expression printer (`Print_Vars`). Command-line parsing has its own page: [command-line](command-line.md).

## How it works

`String/byte-core.jai` holds the allocation-free operations on byte views: `equal`/`compare` (plus `_nocase`), `begins_with`, `ends_with`, `contains`, `find_index_from_left/right`, `split_from_left/right`, `trim*`, `wildcard_match`, `path_*` helpers, `to_lower`/`to_upper`, `is_alpha`/`is_digit`/`is_space`, `string_to_int`/`string_to_float`. Results of search, trim, slice and split borrow the input bytes. Case conversion is ASCII only, and `wildcard_match` understands `*` and `?` only.

`String/module.jai` adds the allocating operations (`join`, `replace`, `split`, `copy_string`, `to_lower_copy`, `normalize_line_endings`), the `parse_int`/`parse_float`/`parse_enum` family that consumes from a `*string`, `scan`/`scan2`, `atof`, and its own contiguous `String_Builder` (`init_string_builder`, `append`, `print_to_builder`, `builder_to_string(builder, allocator := Basic.temp)`, `free_buffers`). `Basic` has a separate `String_Builder` with a different layout; qualify the type (`Basic.String_Builder`) when both modules are imported.

`Unicode/utf8-core.jai` validates scalar values: overlong forms, surrogates and truncated input make `utf8_next_character` fail without advancing. `character_utf8_to_utf32` and `character_utf32_to_utf8` convert single characters, and `utf8_iter` is the iteration macro.

`Base64.jai` provides `base64_encode`, `base64_decode` (accepts whitespace, padded or unpadded input, rejects bad padding bits) and `base64url_encode`/`base64url_decode` (no padding), plus `_with_alphabet` variants; `base64_decode` takes an optional 256-entry decoder table.

`Text_File_Handler` reads CR, LF or CRLF lines with `start_file`/`start_from_memory` and `consume_next_line`, tracks line numbers, strips comments, can skip blank lines and reads an optional leading `[version]`. `file_to_array` and `file_to_table` copy each line, so callers own the strings. `Print_Color` emits ANSI SGR sequences (`print_color`, `set_console_color`, `with_console_color`, `reset_console_color`). `Print_Vars` prints expression text, value and type using `Compiler` node inspection and `Program_Print`.

```jai
#import "Basic";
#import "String";

main :: () {
    ok, left, right := split_from_left("a,b", #char ",");
    print("% % %\n", ok, left, right);
}
```

## How to change it

- Keep allocation-free logic in `byte-core.jai` (it is also loaded directly by `stdlib/tests/string-byte-core.jai`); allocating helpers go in `String/module.jai`.
- Extend UTF-8 handling together with `stdlib/tests/utf8-scalar.jai` and `tests/stdlib/unicode-utf8-tables.jai`. Do not weaken scalar validity; add a separate API for other encodings.
- New Base64 alphabets go through `base64_encode_with_alphabet`/`base64_decode_with_alphabet`, or pass a decoder table to `base64_decode`.
- Related regression programs: `tests/stdlib/string-scan.jai`, `basic-string-parsing.jai`, `basic-formatters.jai`, `one-char-string-as-byte.jai`, `no-break-space.jai`.

## Configuration

`Text_File_Handler` exposes `comment_character`, `do_version_number`, `strip_comments_from_ends_of_lines` and `auto_skip_blank_lines`. `Print_Color` calls take `color`, `style` and `to_standard_error`; whether sequences render depends on the terminal. `Basic.temp` is the default allocator for `builder_to_string`.

## Dependencies

`Basic`; `File` and `Hash_Table` for `Text_File_Handler`; `Compiler` and `Program_Print` for `Print_Vars`.
