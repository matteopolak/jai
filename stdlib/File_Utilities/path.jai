Path :: struct {
    header_string: string;
    number_of_leading_slashes: int;
    trailing_slash: bool;
    words: [..] string;
}

parse_path :: (_s: string, reduce := true) -> Path {
    result: Path;
    result.words.allocator = temp;
    cursor: int;
    // A colon before the first separator identifies a drive or scheme prefix.
    for i: 0.._s.count-1 {
        if path_separator(_s[i]) break;
        if _s[i] == #char ":" { result.header_string = Strings.slice(_s, 0, i + 1); cursor = i + 1; break; }
    }
    while cursor < _s.count && path_separator(_s[cursor]) {
        result.number_of_leading_slashes += 1;
        cursor += 1;
    }
    result.trailing_slash = _s.count > 0 && path_separator(_s[_s.count - 1]);
    while cursor < _s.count {
        start := cursor;
        while cursor < _s.count && !path_separator(_s[cursor]) cursor += 1;
        if cursor > start array_add(*result.words, Strings.slice(_s, start, cursor - start));
        while cursor < _s.count && path_separator(_s[cursor]) cursor += 1;
    }
    if reduce return reduce_path(result);
    return result;
}

reduce_path :: (path: Path) -> Path {
    result := path;
    result.words = .{};
    result.words.allocator = temp;
    for word: path.words {
        if word == "." || !word continue;
        if word == ".." {
            if result.words.count > 0 && result.words[result.words.count - 1] != ".." {
                result.words.count -= 1;
                continue;
            }
            if path.number_of_leading_slashes > 0 continue;
        }
        array_add(*result.words, word);
    }
    return result;
}

path_contains :: (path: Path, words: [] string) -> (contains: bool, position: s32) {
    if words.count == 0 return true, 0;
    if words.count > path.words.count return false, -1;
    for start: 0..path.words.count - words.count {
        equal := true;
        for offset: 0..words.count-1 {
            if path.words[start + offset] != words[offset] { equal = false; break; }
        }
        if equal return true, cast(s32) start;
    }
    return false, -1;
}

path_to_string :: (path: Path, max_words := -1) -> string {
    builder: String_Builder;
    init_string_builder(*builder);
    defer free_buffers(*builder);
    append(*builder, path.header_string);
    for i: 0..path.number_of_leading_slashes-1 append(*builder, "/");
    count := path.words.count;
    if max_words >= 0 count = min(count, max_words);
    for i: 0..count-1 {
        if i > 0 append(*builder, "/");
        append(*builder, path.words[i]);
    }
    if path.trailing_slash && count > 0 append(*builder, "/");
    return builder_to_string(*builder);
}

how_much_of_path_exists_on_the_local_filesystem :: (path: Path) -> (fully_exists: bool, how_much_exists: s32) {
    existing: s32;
    for i: 1..path.words.count {
        if !file_exists(path_to_string(path, i)) return false, existing;
        existing = cast(s32) i;
    }
    if path.words.count == 0 return file_exists(path_to_string(path)), 0;
    return true, existing;
}

copy_to_permanent :: (path: Path) -> Path {
    result := path;
    result.header_string = copy_string(path.header_string);
    result.words = .{};
    for word: path.words array_add(*result.words, copy_string(word));
    return result;
}

free_permanent :: (using path: Path) {
    free(header_string);
    for word: words free(word);
    array_free(words);
}

#scope_file
path_separator :: (byte: u8) -> bool {
    return byte == #char "/" || byte == #char "\\";
}
