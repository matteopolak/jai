// This compatibility helper does not generate a C header by itself.
avoid_reserved_names :: (name: string) -> string {
    if name == "signed" return "_signed";
    return name;
}
