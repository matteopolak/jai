// Regression: String exports only its own API and allocates from context.allocator.
#import "Basic";
#import "String";

main :: () {
    // join returns heap memory that can be freed (it used to come from temporary storage).
    parts := string.["a", "b", "c"];
    joined := join(..parts, separator = ", ");
    assert(joined == "a, b, c", "join: %", joined);
    free(joined);

    framed := join("x", "y", separator = "|", before_first = true, after_last = true);
    assert(framed == "|x|y|", "join framed: %", framed);
    free(framed);
    assert(join() == "" && join("") == "", "join of nothing");

    // replace allocates from context.allocator and reports the occurrence count.
    replaced, count := replace("one two one", "one", "1");
    assert(replaced == "1 two 1" && count == 2, "replace: % %", replaced, count);
    free(replaced);

    // Case copies are heap strings as well.
    lower := to_lower_copy("MiXed");
    assert(lower == "mixed");
    free(lower);

    // split keeps a trailing empty piece so it inverts join.
    pieces := split("a,b,", #char ",");
    assert(pieces.count == 3 && pieces[2] == "", "split count %", pieces.count);
    array_free(pieces);

    // contains returns the text after the match.
    found, rest := contains("key=value", "=");
    assert(found && rest == "value", "contains: %", rest);
    found, rest = contains("key=value", #char "=");
    assert(found && rest == "value");
    assert(find_index_from_left("abc", "") == -1, "an empty needle is never found");

    // Signatures: found/left/right order, two-value replace, parse_int default type.
    ok, left, right := split_from_left("a::b", "::");
    assert(ok && left == "a" && right == "b");
    line := "42 rest";
    number, parsed := parse_int(*line);
    assert(parsed && number == 42 && line == " rest");

    // Wildcards support sets and ranges.
    assert(wildcard_match("file7.txt", "file[0-9].txt"));
    assert(!wildcard_match("fileX.txt", "file[0-9].txt"));

    // A lone carriage return survives normalisation.
    text := normalize_line_endings("a\r\nb\rc");
    assert(text == "a\nb\rc", "normalize: %", text);
    free(text);

    // String_Builder is Basic's: the default result is a heap string.
    builder: String_Builder;
    append(*builder, "built");
    built := builder_to_string(*builder);
    assert(built == "built");
    free(built);

    print("string api ok\n");
}
