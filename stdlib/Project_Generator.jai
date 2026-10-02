// Independently authored path grouping helper. Project-file generation is pending.
get_folder_for_path :: (file_path: string) -> string {
    separator: int = -1;
    for byte, index: file_path {
        if byte == #char "/" || byte == #char "\\" separator = index;
    }
    path := file_path;
    path.count = separator + 1;
    while path.count > 0 {
        last := path[path.count - 1];
        if last != #char "/" && last != #char "\\" break;
        path.count -= 1;
    }
    modules_index := find_fragment(path, "modules");
    if modules_index >= 0 {
        path.data += modules_index;
        path.count -= modules_index;
    }
    doc_index := find_fragment(path, "doc");
    if doc_index >= 0 {
        path.data += doc_index;
        path.count -= doc_index;
    }
    if find_fragment(path, "..") >= 0 return "";
    return path;
}

#scope_file
find_fragment :: (text: string, fragment: string) -> int {
    candidate: int = 0;
    while candidate <= text.count - fragment.count {
        matches := true;
        for byte, index: fragment {
            if text[candidate + index] != byte { matches = false; break; }
        }
        if matches return candidate;
        candidate += 1;
    }
    return -1;
}
