#import "Basic";
B :: #import "Bindings_Generator";
Other :: #import "Bindings_Generator"(TARGET_OS = .LINUX);

extract :: (builder: *String_Builder) -> string {
    return builder_to_string(builder);
}

decl_from_field :: (field: *B.Declaration) -> *B.Declaration {
    return field;
}

main :: () {
    comment: B.Comment;
    comment.text = "// old";
    comment.location.line = 17;
    B.prepend_comment(*comment, "// first");
    assert(comment.text == "// first\n// old" && comment.location.line == 17);
    allocation := comment.text;

    B.prepend_comment(*comment, "");
    assert(comment.text.data == allocation.data);
    free(allocation);

    generator: B.Generator;
    generator.tab_depth = 2;
    builder: String_Builder;

    defer free_buffers(*builder);

    push_context {
        context.generator = *generator;
        B.append_indentation(*builder);
        text := extract(*builder);

        assert(text == "  ");
        free(text);
        B.append_prefix_comment(*builder, .{ text = "// alpha\n// beta" }, true);
        text = extract(*builder);
        assert(text == "  // alpha\n  // beta\n");
        free(text);
    }

    other: Other.Generator;
    other.tab_depth = 3;

    push_context {
        context.generator = *other;
        Other.append_indentation(*builder);
        text := extract(*builder);

        assert(text == "   ");
        free(text);
        other.tab_depth = 0;
        Other.append_indentation(*builder);
        text = extract(*builder);
        assert(text == "");
        free(text);
    }

    B.append_postfix_comment(*builder, .{ text = "///< value" });
    text := extract(*builder);

    assert(text == " ///< value");
    free(text);
    B.append_prefix_comment(*builder, .{ text = "///< value" }, false);
    B.append_postfix_comment(*builder, .{ text = "// prefix" });
    text = extract(*builder);
    assert(text == "");
    free(text);

    first, omitted, renamed: B.Declaration;
    first.name = "long";
    omitted.name = "excluded_longest";
    omitted.decl_flags = .OMIT_FROM_OUTPUT;
    renamed.name = "source_name";
    renamed.output_name = "x";
    fields: [] *B.Declaration = .[*first, *omitted, *renamed];

    assert(B.get_name_alignment(fields) == 4);
    assert(B.get_name_alignment(fields, decl_from_field) == 4);
    assert(B.get_name_alignment(fields, decl_from_field, true) == 16);
    empty: [] *B.Declaration;

    assert(B.get_name_alignment(empty) == 0);
    print("ok\n");
}
