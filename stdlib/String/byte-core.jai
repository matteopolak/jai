// Pure byte views, matching, numeric token recognition and path components.
PATH_SEPARATOR :: #char "/";

DEFAULT_SPACES :: " \t\r\n";

DEFAULT_DELIMITERS :: ";=()";

is_any :: (c: int, set: string) -> bool {
    for b: set if b == c return true;
    return false;
}

to_lower :: (c: int) -> int {
    if c >= 65 && c <= 90 return c + 32;
    return c;
}

to_upper :: (c: int) -> int {
    if c >= 97 && c <= 122 return c - 32;
    return c;
}

is_digit :: (c: int) -> bool { return c >= 48 && c <= 57; }

is_alpha :: (c: int) -> bool { x := to_lower(c); return x >= 97 && x <= 122; }

is_alnum :: (c: int) -> bool { return is_alpha(c) || is_digit(c); }

is_space :: (c: int) -> bool { return is_any(c, DEFAULT_SPACES); }

slice :: inline (value: string, start: s64, count: s64) -> string {
    if start < 0 || count < 0 || start > value.count || count > value.count-start return "";
    return .{count = count, data = value.data + start};
}

compare :: (a: string, b: string) -> int {
    n := a.count; if b.count < n n = b.count;
    for i: 0..n-1 if a[i] != b[i] return cast(int) a[i] - cast(int) b[i];
    if a.count < b.count return -1;
    if a.count > b.count return 1;
    return 0;
}

compare_nocase :: (a: string, b: string) -> int {
    n := a.count; if b.count < n n = b.count;
    for i: 0..n-1 {
        x := to_lower(a[i]); y := to_lower(b[i]);
        if x != y return x - y;
    }
    if a.count < b.count return -1;
    if a.count > b.count return 1;
    return 0;
}

equal :: (a: string, b: string) -> bool { return compare(a, b) == 0; }

equal_nocase :: (a: string, b: string) -> bool { return compare_nocase(a, b) == 0; }

begins_with :: (haystack: string, prefix: string) -> bool {
    return haystack.count >= prefix.count && equal(slice(haystack, 0, prefix.count), prefix);
}

ends_with :: (haystack: string, suffix: string) -> bool {
    return haystack.count >= suffix.count && equal(slice(haystack, haystack.count - suffix.count, suffix.count), suffix);
}

begins_with_nocase :: (s: string, prefix: string) -> bool {
    return s.count >= prefix.count && equal_nocase(slice(s, 0, prefix.count), prefix);
}

ends_with_nocase :: (s: string, suffix: string) -> bool {
    return s.count >= suffix.count && equal_nocase(slice(s, s.count - suffix.count, suffix.count), suffix);
}

find_index_from_left :: (s: string, byte: u8, start_index := 0) -> s64 {
    if start_index < 0 return -1;
    for i: start_index..s.count-1 if s[i] == byte return i;
    return -1;
}

find_index_from_right :: (s: string, byte: u8) -> s64 {
    i := s.count;
    while i > 0 { i -= 1; if s[i] == byte return i; }
    return -1;
}

find_index_from_left :: (haystack: string, needle: string, start_index := 0) -> s64 {
    if start_index < 0 || start_index > haystack.count return -1;
    for i: start_index..haystack.count-needle.count {
        if equal(slice(haystack, i, needle.count), needle) return i;
    }
    return -1;
}

find_index_from_right :: (haystack: string, needle: string) -> s64 {
    if needle.count > haystack.count return -1;
    i := haystack.count - needle.count;
    while i >= 0 { if equal(slice(haystack, i, needle.count), needle) return i; i -= 1; }
    return -1;
}

find_index_of_any_from_left :: (s: string, bytes: string, start_index := 0) -> s64 {
    if start_index < 0 return -1;
    for i: start_index..s.count-1 if is_any(s[i], bytes) return i;
    return -1;
}

find_index_of_any_from_right :: (s: string, bytes: string) -> s64 {
    i := s.count;
    while i > 0 { i -= 1; if is_any(s[i], bytes) return i; }
    return -1;
}

index_of_string_nocase :: (s: string, substring: string) -> int, found: bool {
    for i: 0..s.count-substring.count {
        if equal_nocase(slice(s, i, substring.count), substring) return i, true;
    }
    return -1, false;
}

contains :: (haystack: string, needle: string) -> bool { return find_index_from_left(haystack, needle) >= 0; }

contains :: (s: string, char: u8) -> found: bool, remainder: string {
    i := find_index_from_left(s, char);
    if i < 0 return false, "";
    return true, slice(s, i, s.count - i);
}

contains_nocase :: (s: string, substring: string) -> found: bool, remainder: string {
    i, found := index_of_string_nocase(s, substring);
    if !found return false, "";
    return true, slice(s, i, s.count - i);
}

contains_any_character :: (s: string, chars: string) -> found: bool, remainder: string {
    i := find_index_of_any_from_left(s, chars);
    if i < 0 return false, "";
    return true, slice(s, i, s.count - i);
}

contains_any_string :: (s: string, substrings: .. string) -> found: bool, remainder: string {
    best := s.count + 1;
    for needle: substrings { i := find_index_from_left(s, needle); if i >= 0 && i < best best = i; }
    if best > s.count return false, "";
    return true, slice(s, best, s.count - best);
}

split_at :: (s: string, index: s64, width: s64) -> bool, string, string {
    if index < 0 return false, s, "";
    return true, slice(s, 0, index), slice(s, index + width, s.count - index - width);
}

split_from_left :: (s: string, byte: u8) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_from_left(s, byte), 1); return found, left, right;
}

split_from_right :: (s: string, byte: u8) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_from_right(s, byte), 1); return found, left, right;
}

split_from_left :: (s: string, separator: string) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_from_left(s, separator), separator.count); return found, left, right;
}

split_from_right :: (s: string, separator: string) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_from_right(s, separator), separator.count); return found, left, right;
}

split_from_left_by_any :: (s: string, bytes: string) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_of_any_from_left(s, bytes), 1); return found, left, right;
}

split_from_right_by_any :: (s: string, bytes: string) -> found: bool, left: string, right: string {
    found, left, right := split_at(s, find_index_of_any_from_right(s, bytes), 1); return found, left, right;
}

trim_left :: (value: string, cutset := DEFAULT_SPACES) -> string {
    n := 0; while n < value.count && is_any(value[n], cutset) n += 1;
    return slice(value, n, value.count - n);
}

trim_right :: (value: string, cutset := DEFAULT_SPACES) -> string {
    n := value.count; while n > 0 && is_any(value[n-1], cutset) n -= 1;
    return slice(value, 0, n);
}

trim :: (value: string, cutset := DEFAULT_SPACES) -> string { return trim_right(trim_left(value, cutset), cutset); }

stop_at_any :: (s: string, bytes: string) -> string {
    i := find_index_of_any_from_left(s, bytes); if i < 0 return s;
    return slice(s, 0, i);
}

eat_trailing_spaces :: (_s: string) -> string { return trim_right(_s); }

eat_until_space :: (_s: string) -> string {
    i := find_index_of_any_from_left(_s, DEFAULT_SPACES); if i < 0 return "";
    return slice(_s, i, _s.count - i);
}

replace_chars :: (s: string, chars: string, replacement: u8) {
    for i: 0..s.count-1 if is_any(s[i], chars) s.data[i] = replacement;
}

to_lower_in_place :: ($$ value: string) { for i: 0..value.count-1 value.data[i] = cast(u8) to_lower(value[i]); }

to_upper_in_place :: ($$ value: string) { for i: 0..value.count-1 value.data[i] = cast(u8) to_upper(value[i]); }

path_separator :: (c: u8) -> bool { return c == 47 || c == 92; }

path_filename :: (path: string) -> string {
    i := path.count; while i > 0 && !path_separator(path[i-1]) i -= 1;
    return slice(path, i, path.count-i);
}

path_strip_filename :: (path: string) -> string {
    name := path_filename(path); return slice(path, 0, path.count-name.count);
}

path_extension :: (path: string) -> extension: string, found_extension: bool {
    name := path_filename(path); i := find_index_from_right(name, cast(u8) 46);
    if i <= 0 return "", false;
    return slice(name, i+1, name.count-i-1), true;
}

path_strip_extension :: (path: string) -> string {
    ext, found := path_extension(path); if !found return path;
    return slice(path, 0, path.count-ext.count-1);
}

path_decomp :: (name: string) -> path: string, basename: string, extension: string, basename_with_extension: string {
    file := path_filename(name); ext, found := path_extension(file);
    base := file; if found base = slice(file, 0, file.count-ext.count-1);
    return path_strip_filename(name), base, ext, file;
}

basename :: (s: string) -> string { return path_strip_extension(path_filename(s)); }

path_overwrite_separators :: (path: string, separator: u8 = PATH_SEPARATOR) {
    for i: 0..path.count-1 if path_separator(path[i]) path.data[i] = separator;
}

is_absolute_path :: (path: string) -> bool {
    if path.count == 0 return false;
    if path_separator(path[0]) return true;
    return path.count >= 3 && is_alpha(path[0]) && path[1] == 58 && path_separator(path[2]);
}

wildcard_match :: (s: string, pat: string) -> bool {
    si := 0; pi := 0; star := -1; retry := 0;
    while si < s.count {
        if pi < pat.count && (pat[pi] == 63 || pat[pi] == s[si]) { si += 1; pi += 1; }
        else if pi < pat.count && pat[pi] == 42 { star = pi; pi += 1; retry = si; }
        else if star >= 0 { retry += 1; si = retry; pi = star + 1; }
        else return false;
    }
    while pi < pat.count && pat[pi] == 42 pi += 1;
    return pi == pat.count;
}

parse_token :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    remaining := trim_left(line.*, spaces);
    if remaining.count == 0 return "", false;
    n := 0;
    while n < remaining.count && !is_any(remaining[n], spaces) && !is_any(remaining[n], delimiters) n += 1;
    if n == 0 return "", false;
    token := slice(remaining, 0, n); line.* = slice(remaining, n, remaining.count-n);
    return token, true;
}

match_token :: (line: *string, match: string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok || !equal(token, match) return token, false;
    line.* = cursor; return token, true;
}

match_token_nocase :: (line: *string, match: string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: string, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok || !equal_nocase(token, match) return token, false;
    line.* = cursor; return token, true;
}

parse_bool :: (line: *string, delimiters := DEFAULT_DELIMITERS, spaces := DEFAULT_SPACES) -> value: bool, success: bool {
    cursor := line.*; token, ok := parse_token(*cursor, delimiters, spaces);
    if !ok return false, false;
    if equal_nocase(token, "true") || equal(token, "1") { line.* = cursor; return true, true; }
    if equal_nocase(token, "false") || equal(token, "0") { line.* = cursor; return false, true; }
    return false, false;
}

string_to_int :: (value: string) -> int, bool {
    if value.count == 0 return 0, false;
    i := 0; negative := false;
    if value[0] == 45 || value[0] == 43 { negative = value[0] == 45; i += 1; }
    if i == value.count return 0, false;
    magnitude: u64 = 0; limit: u64 = 0x7fff_ffff_ffff_ffff;
    if negative limit += 1;
    while i < value.count {
        c := value[i]; if !is_digit(c) return 0, false;
        digit := cast(u64) (c-48);
        if magnitude > (limit-digit)/10 return 0, false;
        magnitude = magnitude*10+digit; i += 1;
    }
    if negative {
        if magnitude == 0x8000_0000_0000_0000 return -0x7fff_ffff_ffff_ffff-1, true;
        return -cast(s64) magnitude, true;
    }
    return cast(s64) magnitude, true;
}

to_integer :: (value: string) -> int, bool, int {
    n := 0;
    if value.count > 0 && (value[0] == 45 || value[0] == 43) n += 1;
    start := n; while n < value.count && is_digit(value[n]) n += 1;
    if n == start return 0, false, 0;
    result, ok := string_to_int(slice(value, 0, n)); return result, ok, n;
}

string_to_float :: (value: string) -> float64, bool {
    if value.count == 0 return 0, false;
    i := 0; negative := false;
    if value[0] == 45 || value[0] == 43 { negative = value[0] == 45; i += 1; }
    result: float64 = 0; digits := 0;
    while i < value.count && is_digit(value[i]) { result = result*10+cast(float64)(value[i]-48); i += 1; digits += 1; }
    if i < value.count && value[i] == 46 {
        i += 1; scale: float64 = 0.1;
        while i < value.count && is_digit(value[i]) { result += cast(float64)(value[i]-48)*scale; scale *= 0.1; i += 1; digits += 1; }
    }
    if digits == 0 return 0, false;
    if i < value.count && (value[i] == 69 || value[i] == 101) {
        i += 1; exponent_negative := false;
        if i < value.count && (value[i] == 45 || value[i] == 43) { exponent_negative = value[i] == 45; i += 1; }
        start := i; exponent := 0;
        while i < value.count && is_digit(value[i]) { exponent = exponent*10+(value[i]-48); if exponent > 308 return 0, false; i += 1; }
        if i == start return 0, false;
        for j: 0..exponent-1 { if exponent_negative result *= 0.1; else result *= 10; }
    }
    if i != value.count return 0, false;
    if negative result = -result;
    return result, true;
}



starts_with :: begins_with;

decomp_filename :: path_decomp;

path_basename :: basename;
