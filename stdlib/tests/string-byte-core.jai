#import "String";
#import "Basic";
string_byte_vectors :: () -> bool {
    if compare("abc", "abd") >= 0 || compare("abc", "abc") != 0 return false;
    if compare_nocase("aBc", "AbC") != 0 return false;
    if !contains("abracadabra", "cada") || contains("abc", "abcd") return false;
    if find_index_from_left("ababa", "ba") != 1 || find_index_from_right("ababa", "ba") != 3 return false;
    if find_index_from_left("abc", "", start_index=3) != -1 return false;
    if trim(" \tword\r\n") != "word" || trim_left("..name", ".") != "name" return false;
    found, left, right := split_from_left("a::b::c", "::");
    if !found || left != "a" || right != "b::c" return false;
    if !wildcard_match("src/file.jai", "s*/*.jai") || wildcard_match("abc", "a?d") return false;
    path, base, extension, full := path_decomp("a/b/report.txt");
    if path != "a/b/" || base != "report" || extension != "txt" || full != "report.txt" return false;
    if !is_absolute_path("/dir/file") || is_absolute_path("dir/file") return false;
    number, valid := string_to_int("-9223372036854775808");
    if !valid || number != -0x7fff_ffff_ffff_ffff-1 return false;
    overflow, overflow_valid := string_to_int("9223372036854775808");
    if overflow_valid return false;
    decimal, decimal_valid := string_to_float("-12.5e1");
    if !decimal_valid || decimal != -125 return false;
    remaining := " \ttrue;rest";
    boolean, boolean_valid := parse_bool(*remaining);
    if !boolean_valid || !boolean || remaining != ";rest" return false;
    return true;
}
#assert(string_byte_vectors());
