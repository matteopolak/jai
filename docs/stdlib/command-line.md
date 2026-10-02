# Command-line arguments

## What it is

`stdlib/Command_Line.jai` implements the supplied standard-library `Command_Line` API with independently authored Jai source. It reflects an application struct into named options and generates a matching `Is_Set(T)` struct so callers can distinguish an explicit value from a default.

`rluba/jaison` is a third-party application/library compatibility target, not a standard-library module. Its pinned source remains unchanged; no Jaison replacement is included here.

## How it works

```jai
#import "Command_Line";

Options :: struct {
    verbose: bool;
    limit: s32 = 20;
    path: string;
}

success, options, supplied, positional := parse_arguments(Options);
// -verbose -limit 20 -path data.txt
// supplied.limit is true even though options.limit still equals its default.
```

The parser skips `argv[0]`, matches struct member names, and retains defaults for options that are absent. A boolean option sets its field to `true` without consuming a value. Strings, bounded integers, floats, ordinary enum names, and fixed arrays consume subsequent tokens. Fixed arrays can nest; each scalar element is handled using its reflected type. Constants and imported members do not become options or generated marker fields.

Unknown options, duplicate options, missing values, out-of-range integers, incomplete numeric tokens, unsupported field types, and invalid enum names return `success = false`. The result and positional list can contain values parsed before the failure. An option's marker is set only after all its values parse successfully; a failed fixed array may contain an already parsed prefix. Repeated options preserve the first parsed value. `enum_flags`, pointers, structs as option values, view arrays, and resizable arrays are unsupported.

`parse_arguments_from(argv, T, flags, help_triggers)` is an additive entry with the same result contract. It accepts a borrowed explicit argument vector, including a program name at element zero, so callers and tests can exercise parsing without replacing process globals.

The generated `Is_Set` fields are matched by reflected name and offset. This avoids assuming that source member indices equal offsets in the generated bool struct. `show_help(T, flags, help_triggers)` omits constants/imported members, reads descriptions from notes beginning with `?`, optionally sorts names, and aligns descriptions. A help trigger prints help and returns `success = false`.

String option values and positional arguments are heap copies. Callers own them, along with the returned positional array, on both success and failure. The process-argv wrapper frees its temporary argument copies after parsing. Default strings retain their original ownership, so free only string values marked as supplied, including initialized elements of a partially parsed array when applicable.

## How to change it

Add supported reflected value types in `cli_read_value`. Keep numeric conversion in temporary aligned storage until the entire token is accepted. Extend marker generation and matching together when adding aliases or nested option groups. Update `stdlib/tests/command-line.jai` when changing parsing semantics; it covers defaults, explicit default values, strings, booleans, integer range/suffix rejection, floats, fixed arrays, enum names, duplicate rejection, `--`, and help triggers.

The module and authored test fixture pass the existing source parser. They have not completed semantic checking or executed. With the immutable `b1b82044` compiler, the explicit Runtime Support profile currently stops while evaluating `stdlib/Basic/String_Builder.jai:2:38`: `this constant expression requires typed compile-time evaluation`. Disabling automatic Runtime Support instead reaches its imported module's missing required parameter. These are dependency/compiler admission limits, not evidence that the command-line assertions passed.

The supplied parser also rejects the source spelling `@"?description"`; the test fixture omits that syntax. `show_help` still consumes reflected description notes, but description rendering remains unverified until the compiler admits the note form and the full module executes.

## Configuration

The public flag values and defaults match the supplied interface:

| Flag | Value | Effect |
| --- | --- | --- |
| `FREE_ARGUMENTS_ALLOWED` | `0x1` | Collect positional arguments and recognize `--` as the end of options. |
| `DOUBLE_DASH_REQUIRED` | `0x2` | Recognize options beginning with `--`; help uses that prefix too. |
| `SHOW_HELP_ON_ERROR` | `0x4` | Print help after a parsing error. |
| `SORT_HELP` | `0x8` | Sort option names lexicographically by bytes. |
| `ALIGN_HELP` | `0x10` | Align description text to the longest option name. |

`Default_Argument_Flags` enables positional arguments, sorting, and alignment. The default help triggers are `help`, `HELP`, and `?`. With double-dash mode, a single-dash token is positional if positional arguments are allowed. There is no `--name=value` shorthand or single-character bundling.

Syntax-only verification:

```sh
target/debug/examples/source-check stdlib/Command_Line.jai
target/debug/examples/source-check stdlib/tests/command-line.jai
```

The bounded semantic probe uses `JAI_RS_MODULE_PATH=$PWD/stdlib`, `JAI_RS_PRELOAD=$PWD/prelude/Preload.jai`, `JAI_RS_RUNTIME_SUPPORT=search`, and all three explicit Runtime Support booleans set to `false`. Run `check-library stdlib/Command_Line.jai` with the published immutable repository compiler; no supplied compiler or native dependency is needed for this probe.

## Dependencies

The authored `Basic` module provides argv, heap/string/array ownership, the legacy `String_Builder`, diagnostics, and printing. The authored `Reflection` module converts complete numeric tokens with integer range checks and stores enum values. The compiler provides canonical `Type_Info` descriptors and compile-time source insertion for `Is_Set`. Sorting and help formatting are implemented locally; no platform library is imported directly by `Command_Line`.
