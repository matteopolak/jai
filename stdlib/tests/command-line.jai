#import "Basic";
#import "Command_Line";

Mode :: enum {
    FAST;
    SAFE;
}
Arguments :: struct {
    ignored :: 77;
    count: s8 = 42;
    enabled: bool;
    title: string;
    ratio: float64;
    coordinates: [2] s16;
    mode: Mode;
}

main :: () {
    argv := string.["test", "-count", "42", "-enabled", "-title", "hello", "-ratio", "1.25", "-coordinates", "-3", "8", "-mode", "SAFE", "file"];
    ok, args, supplied, positional := parse_arguments_from(argv, Arguments);
    assert(ok);
    assert(args.count == 42 && supplied.count);
    assert(args.enabled && supplied.enabled);
    assert(args.title == "hello" && supplied.title);
    assert(args.ratio == 1.25 && supplied.ratio);
    assert(args.coordinates[0] == -3 && args.coordinates[1] == 8 && supplied.coordinates);
    assert(args.mode == .SAFE && supplied.mode);
    assert(positional.count == 1 && positional[0] == "file");
    free(args.title.data);
    for text: positional free(text.data);
    array_free(positional);

    empty := string.["test"];
    default_ok, defaults, defaults_set, default_free := parse_arguments_from(empty, Arguments);
    assert(default_ok && defaults.count == 42 && !defaults_set.count);
    array_free(default_free);

    overflow := string.["test", "-count", "128"];
    overflow_ok, overflow_result, overflow_set, overflow_free := parse_arguments_from(overflow, Arguments, help_triggers = .[]);
    assert(!overflow_ok && overflow_result.count == 42 && !overflow_set.count);
    array_free(overflow_free);

    suffix := string.["test", "-count", "7garbage"];
    suffix_ok, suffix_result, suffix_set, suffix_free := parse_arguments_from(suffix, Arguments, help_triggers = .[]);
    assert(!suffix_ok && suffix_result.count == 42 && !suffix_set.count);
    array_free(suffix_free);

    repeat := string.["test", "-count", "4", "-count", "5"];
    repeat_ok, repeat_result, repeat_set, repeat_free := parse_arguments_from(repeat, Arguments, help_triggers = .[]);
    assert(!repeat_ok && repeat_result.count == 4 && repeat_set.count);
    array_free(repeat_free);

    terminated := string.["test", "--enabled", "--", "--count", "9"];
    terminated_ok, terminated_result, terminated_set, terminated_free := parse_arguments_from(terminated, Arguments, flags = Default_Argument_Flags | .DOUBLE_DASH_REQUIRED);
    assert(terminated_ok && terminated_result.enabled && terminated_set.enabled);
    assert(terminated_free.count == 2 && terminated_free[0] == "--count");
    for text: terminated_free free(text.data);
    array_free(terminated_free);

    missing := string.["test", "-coordinates", "1"];
    missing_ok, _, missing_set, missing_free := parse_arguments_from(missing, Arguments, help_triggers = .[]);
    assert(!missing_ok && !missing_set.coordinates);
    array_free(missing_free);

    invalid_enum := string.["test", "-mode", "UNKNOWN"];
    enum_ok, _, enum_set, enum_free := parse_arguments_from(invalid_enum, Arguments, help_triggers = .[]);
    assert(!enum_ok && !enum_set.mode);
    array_free(enum_free);

    help := string.["test", "-help"];
    help_ok, _, help_set, help_free := parse_arguments_from(help, Arguments);
    assert(!help_ok && !help_set.count);
    array_free(help_free);
}
