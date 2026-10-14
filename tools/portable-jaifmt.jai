// File-only frontend for the repository's unchanged Jai_Format engine.
// Explicit config and file paths keep this worker independent of directory-walk
// APIs that are still being implemented. Does not replace the jaifmt CLI check.
#import "Basic";
F :: #import "File";
Format :: #import "Extensions/Jai_Format";

main :: () -> s32 {
    args := get_command_line_arguments();

    defer array_free(args);

    if args.count < 3 {
        write_string("usage: portable-jaifmt config [--check] files...\n", true);
        return 2;
    }

    config_data, loaded := F.read_entire_file(args[1], log_errors = false);
    if !loaded {
        write_string("cannot read formatter config\n", true);
        return 2;
    }

    defer free(config_data);
    config, parsed, problem := Format.parse_config(config_data);
    if !parsed {
        write_strings(problem, "\n", to_standard_error = true);
        return 2;
    }

    check := false;
    start: s64 = 2;

    if args[2] == "--check" {
        check = true;
        start += 1;
    }

    if start >= args.count {
        write_string("no files supplied\n", true);
        return 2;
    }

    changed := false;

    for i: start..args.count - 1 {
        mark := get_temporary_storage_mark();

        defer set_temporary_storage_mark(mark);
        source, read := F.read_entire_file(args[i], log_errors = false);
        if !read {
            write_strings("cannot read ", args[i], "\n", to_standard_error = true);
            return 2;
        }

        defer free(source);
        output, formatted, error := Format.format_source(source, config);
        if !formatted {
            write_strings(args[i], ": ", error, "\n", to_standard_error = true);
            return 2;
        }

        defer free(output);
        if source == output continue;

        changed = true;

        if check write_strings(args[i], "\n");
        else if !F.write_entire_file(args[i], output) {
            write_strings("cannot write ", args[i], "\n", to_standard_error = true);
            return 2;
        }
    }

    if check && changed return 1;

    return 0;
}
