# Strings, Unicode and text files

## What it is

Byte-string utilities (`String`), UTF-8 scalar conversion (`Unicode`), Base64, a line-oriented loader (`Text_File_Handler`), ANSI console colors (`Print_Color`) and an expression printer (`Print_Vars`). Command-line parsing has its own page: [command-line](command-line.md).

## How it works

`String/module.jai` has the public API of the official `String` module and nothing more: `compare`/`equal` (plus `_nocase`), `begins_with`/`ends_with`, `contains*` (return `found, remainder`, with the remainder starting after the match), `find_index_*`, `split_from_*`, `split`, `trim*`, `wildcard_match` (`*`, `?`, `[abc]`, `[a-z]`), `path_*` helpers, `parse_token`/`parse_int`/`parse_float`/`parse_bool`/`parse_enum`, `scan`/`scan2`, `atof`, and the allocating `join`, `replace`, `to_lower_copy`/`to_upper_copy`, `normalize_line_endings`. Results of search, trim, slice and split borrow the input bytes. Case conversion is ASCII only.

Allocation follows the official module: `join`, `replace`, `to_*_copy`, `normalize_line_endings(string)` and the array from `split` come from `context.allocator`, so `free(result)` works; only `scan` (and `path_ensure_extension` when it appends) use temporary storage.

`String` does not export `String_Builder`, `sprint`/`tprint`, `copy_string`, `to_lower`/`to_upper`, `is_digit`/`is_alpha`/`is_space`, `string_to_int`/`string_to_float` or `to_string`; those belong to `Basic`, which `String` imports privately. `replace` is built on Basic's `String_Builder`, whose `builder_to_string` defaults to `context.allocator`.

`Unicode/utf8-core.jai` validates scalar values: overlong forms, surrogates and truncated input make `utf8_next_character` fail without advancing. `character_utf8_to_utf32` and `character_utf32_to_utf8` convert single characters, and `utf8_iter` is the iteration macro (`it` is the code point, `it_index` the character index, `-1` when reversed).

`Base64.jai` provides `base64_encode`, `base64_decode` (accepts whitespace and padded or unpadded input, rejects bad padding bits), `base64url_encode`/`base64url_decode` (no padding) and `_with_alphabet` variants. `base64_decode` takes an optional 256-entry decoder table.

`Text_File_Handler` reads CR, LF or CRLF lines with `start_file`/`start_from_memory` and `consume_next_line`, tracks line numbers, strips comments, can skip blank lines and reads an optional leading `[version]`. `file_to_array` and `file_to_table` copy each line, so callers own the strings.

`Print_Color` emits ANSI SGR sequences (`print_color`, `set_console_color`, `with_console_color`, `reset_console_color`). `Print_Vars` prints expression text, value and type using `Compiler` node inspection and `Program_Print`.

`scan2(text, format, ..pointers)` walks the format: literal bytes must match, `%%` matches one `%`, and each lone `%` parses text into the next argument (which must be a pointer; the pointee's type picks the parser through `Reflection.set_value_from_string`). It succeeds only if the format and all of `text` are consumed. `scan` is the older `%f`/`%d`/`%b`/`%s` variant that returns the parsed values as `[] Any` in temporary storage.

```jai
#import "Basic";
#import "String";

main :: () {
    ok, left, right := split_from_left("a,b", #char ",");
    print("% % %\n", ok, left, right);
}
```

## How to change it

- Every public name in `String/module.jai` must exist in the official module with the same signature, defaults and return order. Don't re-add helpers that live in `Basic`. `stdlib/String/tests/api-shape.jai` and `stdlib/tests/string-byte-core.jai` pin the shape.
- Extend UTF-8 handling together with `stdlib/tests/utf8-scalar.jai` and `tests/stdlib/unicode-utf8-tables.jai`. Do not weaken scalar validity; add a separate API for other encodings.
- New Base64 alphabets go through `base64_encode_with_alphabet`/`base64_decode_with_alphabet`, or pass a decoder table to `base64_decode`.
- Related regression programs: `tests/stdlib/string-scan.jai`, `string-scan2-and-path-helpers.jai`, `basic-string-parsing.jai`, `basic-formatters.jai`, `one-char-string-as-byte.jai`, `no-break-space.jai`.

## Configuration

`Text_File_Handler` exposes `comment_character`, `do_version_number`, `strip_comments_from_ends_of_lines` and `auto_skip_blank_lines`. `Print_Color` calls take `color`, `style` and `to_standard_error`; whether sequences render depends on the terminal.

## Dependencies

`Basic`; `File` and `Hash_Table` for `Text_File_Handler`; `Compiler` and `Program_Print` for `Print_Vars`.
