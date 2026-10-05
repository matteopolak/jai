// Independently authored String module: byte-view algorithms plus the allocating helpers
// (join, replace, split, case copies). Allocation uses context.allocator unless noted.
#scope_file
Basic :: #import "Basic";
using Basic;
Reflection :: #import "Reflection";
#scope_export

#if OS == .WINDOWS { PATH_SEPARATOR :: #char "\\"; } else { PATH_SEPARATOR :: #char "/"; }
DEFAULT_SPACES :: " \t\r\n";
DEFAULT_DELIMITERS :: ";=()";

is_any :: (c: u8, chars: string) -> bool {
    for i: 0..chars.count-1 if chars.data[i] == c return true;
    return false;
}

slice :: inline (s: string, index: s64, count: s64) -> string {
    assert(index >= 0, "index = %", index);
    assert(count >= 0, "count = %", count);
    if index >= s.count return "";
    n := count;
    if index + n > s.count n = s.count - index;
    return .{count = n, data = s.data + index};
}

compare :: (a: string, b: string) -> int {
    n := min(a.count, b.count);
    for i: 0..n-1 {
        if a.data[i] > b.data[i] return 1;
        if a.data[i] < b.data[i] return -1;
    }
    if a.count > b.count return 1;
    if a.count < b.count return -1;
    return 0;
}

compare_nocase :: (a: string, b: string) -> int {
    n := min(a.count, b.count);
    for i: 0..n-1 {
        x := to_lower(a.data[i]); y := to_lower(b.data[i]);
        if x > y return 1;
        if x < y return -1;
    }
    if a.count > b.count return 1;
    if a.count < b.count return -1;
    return 0;
}

equal :: (a: string, b: string) -> bool { return a == b; }

equal_nocase :: (a: string, b: string) -> bool {
    if a.count != b.count return false;
    for i: 0..a.count-1 if to_lower(a.data[i]) != to_lower(b.data[i]) return false;
    return true;
}

begins_with :: (s: string, prefix: string) -> bool {
    return s.count >= prefix.count && slice(s, 0, prefix.count) == prefix;
}
ends_with :: (s: string, suffix: string) -> bool {
    return s.count >= suffix.count && slice(s, s.count-suffix.count, suffix.count) == suffix;
}
begins_with_nocase :: (s: string, prefix: string) -> bool {
    return s.count >= prefix.count && equal_nocase(slice(s, 0, prefix.count), prefix);
}
ends_with_nocase :: (s: string, suffix: string) -> bool {
    return s.count >= suffix.count && equal_nocase(slice(s, s.count-suffix.count, suffix.count), suffix);
}
starts_with :: begins_with;

find_index_from_left :: (s: string, byte: u8, start_index := 0) -> s64 {
    i := start_index;
    if i < 0 i = 0;
    while i < s.count { if s.data[i] == byte return i; i += 1; }
    return -1;
}
find_index_from_right :: (s: string, byte: u8) -> s64 {
    i := s.count - 1;
    while i >= 0 { if s.data[i] == byte return i; i -= 1; }
    return -1;
}
find_index_from_left :: (s: string, substring: string, start_index := 0) -> s64 {
    if substring.count == 0 return -1;
    i := start_index;
    if i < 0 i = 0;
    while i + substring.count <= s.count {
        if slice(s, i, substring.count) == substring return i;
        i += 1;
    }
    return -1;
}
find_index_from_right :: (s: string, substring: string) -> s64 {
    if substring.count == 0 return -1;
    i := s.count - substring.count;
    while i >= 0 {
        if slice(s, i, substring.count) == substring return i;
        i -= 1;
    }
    return -1;
}
find_index_of_any_from_left :: (s: string, bytes: string, start_index := 0) -> s64 {
    i := start_index;
    if i < 0 i = 0;
    while i < s.count { if is_any(s.data[i], bytes) return i; i += 1; }
    return -1;
}
find_index_of_any_from_right :: (s: string, bytes: string) -> s64 {
    i := s.count - 1;
    while i >= 0 { if is_any(s.data[i], bytes) return i; i -= 1; }
    return -1;
}
index_of_string_nocase :: (s: string, substring: string) -> int, found: bool {
    if s.count < substring.count return -1, false;
    for i: 0..s.count-substring.count {
        if equal_nocase(slice(s, i, substring.count), substring) return i, true;
    }
    return -1, false;
}

contains :: (s: string, substring: string) -> found: bool, remainder: string {
    i := find_index_from_left(s, substring);
    if i == -1 return false, "";
    return true, advance(s, i + substring.count);
}
contains_nocase :: (s: string, substring: string) -> found: bool, remainder: string {
    i := index_of_string_nocase(s, substring);
    if i == -1 return false, "";
    return true, advance(s, i + substring.count);
}
contains :: (s: string, char: u8) -> found: bool, remainder: string {
    i := find_index_from_left(s, char);
    if i == -1 return false, "";
    return true, advance(s, i + 1);
}
contains_any_character :: (s: string, chars: string) -> found: bool, remainder: string {
    i := find_index_of_any_from_left(s, chars);
    if i == -1 return false, "";
    return true, advance(s, i + 1);
}
contains_any_string :: (s: string, substrings: .. string) -> found: bool, remainder: string {
    for needle: substrings {
        found, remainder := contains(s, needle);
        if found return true, remainder;
    }
    return false, "";
}

replace_chars :: (s: string, chars: string, replacement: u8) {
    for i: 0..s.count-1 if is_any(s.data[i], chars) s.data[i] = replacement;
}

split_from_left :: (s: string, byte: u8) -> found: bool, left: string, right: string {
    i := find_index_from_left(s, byte);
    if i == -1 return false, s, "";
    return true, slice(s, 0, i), slice(s, i+1, s.count-i-1);
}
split_from_right :: (s: string, byte: u8) -> found: bool, left: string, right: string {
    i := find_index_from_right(s, byte);
    if i == -1 return false, "", s;
    return true, slice(s, 0, i), slice(s, i+1, s.count-i-1);
}
split_from_left :: (s: string, separator: string) -> found: bool, left: string, right: string {
    i := find_index_from_left(s, separator);
    if i == -1 return false, s, "";
    return true, slice(s, 0, i), slice(s, i+separator.count, s.count-i-separator.count);
}
split_from_right :: (s: string, separator: string) -> found: bool, left: string, right: string {
    i := find_index_from_right(s, separator);
    if i == -1 return false, "", s;
    return true, slice(s, 0, i), slice(s, i+separator.count, s.count-i-separator.count);
}
split_from_left_by_any :: (s: string, bytes: string) -> found: bool, left: string, right: string {
    i := find_index_of_any_from_left(s, bytes);
    if i == -1 return false, s, "";
    return true, slice(s, 0, i), slice(s, i+1, s.count-i-1);
}
split_from_right_by_any :: (s: string, bytes: string) -> found: bool, left: string, right: string {
    i := find_index_of_any_from_right(s, bytes);
    if i == -1 return false, "", s;
    return true, slice(s, 0, i), slice(s, i+1, s.count-i-1);
}

// The result array lives in context.allocator; the pieces borrow `s`.
// A match at the very end yields a trailing empty string, which makes split the inverse of join.
split :: (s: string, separator: $T) -> [] string {
    #assert (T == u8) || (T == string);
    results: [..] string;
    remainder := s;
    while remainder.count > 0 {
        found, left, right := split_from_left(remainder, separator);
        if !found { array_add(*results, remainder); break; }
        array_add(*results, left);
        remainder = right;
    }
    if remainder.count == 0 array_add(*results, "");
    return results;
}

trim_left :: (s: string, chars := DEFAULT_SPACES) -> string {
    n := 0;
    while n < s.count && is_any(s.data[n], chars) n += 1;
    return slice(s, n, s.count-n);
}
trim_right :: (s: string, chars := DEFAULT_SPACES) -> string {
    n := s.count;
    while n > 0 && is_any(s.data[n-1], chars) n -= 1;
    return slice(s, 0, n);
}
trim :: (s: string, chars := DEFAULT_SPACES) -> string { return trim_right(trim_left(s, chars), chars); }

stop_at_any :: (s: string, bytes: string) -> string {
    i := find_index_of_any_from_left(s, bytes);
    if i == -1 return s;
    return slice(s, 0, i);
}
eat_trailing_spaces :: (_s: string) -> string {
    s := _s;
    while s.count > 0 && (s.data[s.count-1] == #char " " || s.data[s.count-1] == 9) s.count -= 1;
    return s;
}
eat_until_space :: (_s: string) -> string {
    s := _s;
    while s.count > 0 && s.data[0] != #char " " && s.data[0] != 9 { s.data += 1; s.count -= 1; }
    return s;
}

// Case conversion is ASCII only. The in-place forms reject constant strings (read-only memory).
to_lower_in_place :: ($$ s: string) {
    #if is_constant(s) #assert false "You cannot call to_lower_in_place on constant strings, as they are stored in read-only memory. They must be copied if you want to change them.";
    for i: 0..s.count-1 s.data[i] = to_lower(s.data[i]);
}
to_upper_in_place :: ($$ s: string) {
    #if is_constant(s) #assert false "You cannot call to_upper_in_place on constant strings, as they are stored in read-only memory. They must be copied if you want to change them.";
    for i: 0..s.count-1 s.data[i] = to_upper(s.data[i]);
}
to_lower_copy :: (s: string) -> string {
    t := alloc_string(s.count);
    for i: 0..t.count-1 t.data[i] = to_lower(s.data[i]);
    return t;
}
to_upper_copy :: (s: string) -> string {
    t := alloc_string(s.count);
    for i: 0..t.count-1 t.data[i] = to_upper(s.data[i]);
    return t;
}
to_lower_copy_new :: (s: string) -> string #deprecated "Just call to_lower_copy() now, as it's been updated." { return to_lower_copy(s); }
to_upper_copy_new :: (s: string) -> string #deprecated "Just call to_upper_copy() now, as it's been updated." { return to_upper_copy(s); }

// Joins into one context.allocator block the caller owns. An empty total yields "".
join :: (inputs: .. string, separator := "", before_first := false, after_last := false) -> string {
    if inputs.count == 0 return "";
    total := separator.count * (inputs.count - 1);
    for part: inputs total += part.count;
    if before_first total += separator.count;
    if after_last total += separator.count;
    if total == 0 return "";
    data := cast(*u8) alloc(total);
    if !data return "";
    at := 0;
    if before_first { memcpy(data, separator.data, separator.count); at += separator.count; }
    for part, i: inputs {
        memcpy(data + at, part.data, part.count); at += part.count;
        if i < inputs.count - 1 || after_last { memcpy(data + at, separator.data, separator.count); at += separator.count; }
    }
    return .{count = total, data = data};
}

// The result is allocated by the caller's allocator; the second value is the match count.
replace :: (s: string, old: string, new: string) -> string, ocurrences: int {
    if old.count == 0 return copy_string(s), 0;
    builder: String_Builder;
    cursor := 0; count := 0;
    while true {
        i := find_index_from_left(s, old, cursor);
        if i == -1 break;
        append(*builder, slice(s, cursor, i - cursor));
        append(*builder, new);
        cursor = i + old.count; count += 1;
    }
    append(*builder, slice(s, cursor, s.count - cursor));
    return builder_to_string(*builder), count;
}

// Converts \r\n into \n; a lone \r is kept.
// Rewrites CRLF pairs as LF in place, shrinking the string; a CR on its own is kept.
normalize_line_endings :: (s: *string) {
    kept := 0;
    for i: 0..s.count-1 {
        byte := s.data[i];
        if byte == #char "\r" && i + 1 < s.count && s.data[i+1] == #char "\n"  continue;
        s.data[kept] = byte;
        kept += 1;
    }
    s.count = kept;
}
normalize_line_endings :: (s: string) -> string #must {
    copy := copy_string(s);
    normalize_line_endings(*copy);
    return copy;
}

// Path helpers accept both separators.
decomp_filename :: path_decomp;
path_decomp :: (name: string) -> path: string, basename: string, extension: string, basename_with_extension: string {
    path := path_strip_filename(name);
    full := advance(name, path.count);
    extension := path_extension(full);
    base := full;
    base.count -= extension.count;
    if extension.count > 0 || (base.count > 0 && base.data[base.count-1] == #char ".") base.count -= 1;
    return path, base, extension, full;
}
path_filename :: (path: string) -> string {
    i := find_index_of_any_from_right(path, "\\/");
    if i == -1 return path;
    return slice(path, i+1, path.count-i-1);
}
path_extension :: (path: string) -> extension: string, found_extension: bool {
    i := find_index_of_any_from_right(path, ".\\/");
    if i <= 0 || path.data[i] != #char "." return "", false;
    before := path.data[i-1];
    if before == #char "\\" || before == #char "/" return "", false;
    if before == #char "." {
        if i == 1 return "", false;
        two := path.data[i-2];
        if two == #char "\\" || two == #char "/" return "", false;
    }
    return slice(path, i+1, path.count-i-1), true;
}
path_strip_filename :: (path: string) -> string {
    i := find_index_of_any_from_right(path, "\\/");
    if i < 0 return "";
    return slice(path, 0, i+1);
}
path_strip_extension :: (path: string) -> string {
    ext, has_ext := path_extension(path);
    if has_ext  return slice(path, 0, path.count - ext.count - 1);  // the dot goes too
    return path;
}
path_overwrite_separators :: (path: string, separator: u8 = PATH_SEPARATOR) {
    for i: 0..path.count-1 if path.data[i] == #char "\\" || path.data[i] == #char "/" path.data[i] = separator;
}
basename :: (s: string) -> string { return path_strip_extension(path_filename(s)); }
path_basename :: basename;
// No allocation when `path` already ends in the extension; otherwise a tprint result.
path_ensure_extension :: (path: string, extension: string) -> string {
    if path_extension(path) == extension return path;
    return tprint("%.%", path, extension);
}
is_absolute_path :: (path: string) -> bool {
    if OS != .WINDOWS  return begins_with(path, "/");
    // Windows: only drive-rooted forms such as "C:\\dir" or "C:/dir" count.
    return path.count >= 3 && path[1] == #char ":" && is_any(path[2], "/\\");
}

// Supports `*`, `?`, `[abc]` and `[a-z]`.
wildcard_match :: (s: string, pat: string) -> bool {
    si := 0; pi := 0;
    while true {
        if pi >= pat.count return si >= s.count;
        c := pat.data[pi];
        if c == #char "*" {
            pi += 1;
            if pi >= pat.count return true;
            rest := slice(pat, pi, pat.count - pi);
            while true {
                if wildcard_match(slice(s, si, s.count - si), rest) return true;
                if si >= s.count return false;
                si += 1;
            }
        }
        if si >= s.count return false;
        if c == #char "?" { pi += 1; si += 1; continue; }
        if c == #char "[" {
            pi += 1; matched := false;
            while pi < pat.count && pat.data[pi] != #char "]" {
                lo := pat.data[pi];
                if pi + 2 < pat.count && pat.data[pi+1] == #char "-" && pat.data[pi+2] != #char "]" {
                    hi := pat.data[pi+2];
                    if (lo <= s.data[si] && s.data[si] <= hi) || (hi <= s.data[si] && s.data[si] <= lo) matched = true;
                    pi += 3;
                } else {
                    if lo == s.data[si] matched = true;
                    pi += 1;
                }
            }
            if !matched return false;
            pi += 1; si += 1;
            continue;
        }
        if c != s.data[si] return false;
        pi += 1; si += 1;
    }
    return false;
}

// parse_token restores `line` when it fails; the other parse_* consume the token they read.
parse_token :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    assert(line != null);
    backup := line.*;
    line.* = trim_left(line.*, spaces);
    if line.count == 0 { rest := line.*; line.* = backup; return rest, false; }
    n := 0;
    if is_any(line.data[0], delimiters) {
        n = 1;
    } else {
        while n < line.count && !is_any(line.data[n], spaces) && !is_any(line.data[n], delimiters) n += 1;
    }
    token := slice(line.*, 0, n);
    line.* = slice(line.*, n, line.count - n);
    return token, true;
}
match_token :: (line: *string, match: string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    token, ok := parse_token(line, delimiters, spaces);
    return token, ok && token == match;
}
match_token_nocase :: (line: *string, match: string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    token, ok := parse_token(line, delimiters, spaces);
    return token, ok && equal_nocase(token, match);
}
parse_bool :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: bool, success: bool {
    token, ok := parse_token(line, delimiters, spaces);
    if !ok return false, false;
    if equal_nocase(token, "true") return true, true;
    if equal_nocase(token, "false") return false, true;
    return false, false;
}
parse_enum :: (line: *string, $T: Type, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: T, success: bool {
    word, have_word := parse_token(line, delimiters, spaces);
    if have_word {
        member, known := Reflection.enum_name_to_value(T, word);
        if known  return member, true;
    }
    nothing: T;
    return nothing, false;
}
parse_float :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: float, success: bool {
    word, have_word := parse_token(line, delimiters, spaces);
    if !have_word  return 0, false;
    number, parsed := string_to_float(word);
    return number, parsed;
}
parse_int :: (line: *string, $T: Type = int, spaces := " \t", delimiters := DEFAULT_DELIMITERS) -> value: T, success: bool {
    word, have_word := parse_token(line, delimiters, spaces);
    if !have_word  return 0, false;
    number, parsed := string_to_int(word);
    return cast(T) number, parsed;
}

// libc's atof, exported for callers that want C's lenient string-to-double.
#scope_file
string_crt :: #system_library "libc";
#scope_export
atof :: (s: *u8) -> float64 #foreign string_crt;

// Supports %f (float), %d/%i (int), %b (true/false), %s (double-quoted string, no escapes) and %% (literal %).
// The returned array and the copied values live in temporary storage.
scan :: (format: string, text: string) -> bool, [] Any {
    result: [..] Any;
    result.allocator = Basic.temp;
    format_cursor := format;
    text_cursor := text;
    // Both strings empty is a trivial match; one empty and not the other is a mismatch.
    if format_cursor.count == 0 && text_cursor.count == 0 return true, result;
    if format_cursor.count == 0 || text_cursor.count == 0 return false, result;
    while true {
        if format_cursor[0] == #char "%" {
            if format_cursor.count == 1 return false, result;
            success := false;
            value: Any;
            kind := format_cursor[1];
            if kind == #char "f" {
                number, ok, rest := Basic.string_to_float(text_cursor);
                success = ok; text_cursor = rest;
                if ok value = scan_copy_any(number);
            } else if kind == #char "d" || kind == #char "i" {
                number, ok, rest := Basic.string_to_int(text_cursor);
                success = ok; text_cursor = rest;
                if ok value = scan_copy_any(number);
            } else if kind == #char "b" {
                if begins_with(text_cursor, "true") { success = true; text_cursor = slice(text_cursor, 4, text_cursor.count - 4); value = scan_copy_any(true); }
                else if begins_with(text_cursor, "false") { success = true; text_cursor = slice(text_cursor, 5, text_cursor.count - 5); value = scan_copy_any(false); }
            } else if kind == #char "s" {
                if text_cursor[0] == #char "\"" {
                    i := 1;
                    while i < text_cursor.count && text_cursor[i] != #char "\"" i += 1;
                    if i < text_cursor.count {
                        success = true;
                        value = scan_copy_any(slice(text_cursor, 1, i - 1));
                        text_cursor = slice(text_cursor, i + 1, text_cursor.count - i - 1);
                    }
                }
            } else if kind == #char "%" {
                if text_cursor[0] != #char "%" return false, result;
                success = true;
                text_cursor = slice(text_cursor, 1, text_cursor.count - 1);
            }
            if !success return false, result;
            if kind != #char "%" Basic.array_add(*result, value);
            format_cursor = slice(format_cursor, 2, format_cursor.count - 2);
        } else {
            if text_cursor[0] != format_cursor[0] return false, result;
            format_cursor = slice(format_cursor, 1, format_cursor.count - 1);
            text_cursor = slice(text_cursor, 1, text_cursor.count - 1);
        }
        if format_cursor.count == 0 && text_cursor.count == 0 return true, result;
        if format_cursor.count == 0 || text_cursor.count == 0 return false, result;
    }
    return false, result;
}

// Pattern-driven parse into typed pointers: scan2("(1 2)", "(% %)", *a, *b). Every lone
// `%` reads text into the next argument, parsed according to its pointee type; `%%`
// stands for one literal percent sign. All of `text` must be consumed.
scan2 :: (text: string, format: string, args: ..Any) -> bool {
    pending := text;
    used_args := 0;
    f := 0;
    while f < format.count {
        expected := format[f];
        f += 1;

        is_slot := expected == #char "%" && !(f < format.count && format[f] == #char "%");
        if is_slot {
            if used_args == args.count  return false;
            target := args[used_args];
            used_args += 1;
            if target.type.type != .POINTER  return false;

            pointee: Any;
            pointee.type          = (cast(*Type_Info_Pointer) target.type).pointer_to;
            pointee.value_pointer = (cast(**void) target.value_pointer).*;
            if !Reflection.set_value_from_string(pointee, *pending)  return false;
            continue;
        }

        if expected == #char "%"  f += 1;   // skip the second half of "%%"
        if pending.count == 0 || pending[0] != expected  return false;
        pending = advance(pending, 1);
    }
    return pending.count == 0;
}

#scope_file
// Copies a value into temporary storage and returns an Any that points at the copy.
scan_copy_any :: (value: $T) -> Any {
    holder := cast(*T) Basic.temporary_alloc(size_of(T));
    holder.* = value;
    any: Any;
    any.type = type_info(T);
    any.value_pointer = holder;
    return any;
}
#scope_export
