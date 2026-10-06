# Command_Line

## What it is

`stdlib/Command_Line.jai` parses program arguments into a user-defined struct by reflection. The struct's members are the flags; a generated `Is_Set(T)` record reports which ones were supplied.

## How it works

`parse_arguments(T, flags, help_triggers)` reads the process arguments and `parse_arguments_from(argv, T, ...)` takes an explicit `[]string` (the first element is the program name). Both return `(success, result, is_set, free_arguments)`.

Flags are written `-name value`. Supported member types are integers (range-checked, trailing garbage rejected), floats, `bool` (presence sets it), `string`, enums (by name), and fixed arrays (one value per element after the flag). Defaults come from the member initializers. Repeating a flag fails. `--` ends flag parsing, and anything left over is returned in `free_arguments` (allowed by `FREE_ARGUMENTS_ALLOWED`, which is on by default). On failure the result keeps its defaults. `help`, `HELP` and `?` print the generated help (`show_help`) and fail; pass `help_triggers=.[]` to disable that.

```jai
Mode :: enum { FAST; SAFE; }
Arguments :: struct {
    count: s8 = 42;
    enabled: bool;
    title: string;
    mode: Mode;
}

argv := string.["prog", "-count", "7", "-enabled", "-mode", "SAFE", "file"];
ok, args, set, rest := parse_arguments_from(argv, Arguments);
// ok, args.count == 7, set.enabled, rest[0] == "file"
```

Strings and the `free_arguments` array are allocated; free them when done. Members with a constant declaration (`ignored :: 77;`) are skipped (`cli_skip_member`).

## How to change it

Value parsing is in `cli_read_value`, help layout in `show_help`; a new member type needs its `Type_Info` handled in both. Keep `Argument_Flags` (`FREE_ARGUMENTS_ALLOWED`, `DOUBLE_DASH_REQUIRED`, `SHOW_HELP_ON_ERROR`, `SORT_HELP`, `ALIGN_HELP`) stable; they are public API.

Test: `stdlib/tests/command-line.jai`. It prints only the help text it exercises.

## Configuration

The `flags` parameter (default `Default_Argument_Flags` = free arguments, sorted and aligned help) and `help_triggers` (default `.["help", "HELP", "?"]`).

## Dependencies

`Basic` and `String`, and the reflection support in the prelude (`type_info`, `Type_Info_Struct`).
