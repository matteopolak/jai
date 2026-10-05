// The metaprogram half: a Metaprogram_Plugin that rewrites the target program so that each
// procedure body starts with `__iprof_runtime.Automatic_Zone(<index>, <name>, <file>, <line>)`, and
// the entry point also starts the runtime and prints a report when it returns.
//
// Each call site carries its own zone's description, so there is no zone table to generate after
// the fact: a procedure can be instrumented whenever its body arrives, before or after `main`.
// Every module that gets an instrumented procedure also gets the `__iprof_runtime` import.

Iprof_Plugin :: struct {
    #as using base: Metaprogram_Plugin;

    // Optional, set after get_plugin(): return false to keep a procedure uninstrumented.
    should_instrument: (body: *Code_Procedure_Body) -> bool;

    // Set by command-line options (see log_help).
    csv_filename:    string;
    min_size:        int = DEFAULT_MIN_SIZE;
    include_modules: bool;

    // Read-only for users.
    zones_planned:    s64;   // Instrumented procedures so far.
    entry_point_done: bool;  // The entry point has been instrumented.

    // Internal.
    modules_with_import: [..] *Message_Import;
    zone_template:  *Code_Procedure_Call;
    entry_template: *Code_Procedure_Call;
}

get_plugin :: () -> *Metaprogram_Plugin {
    p := New(Iprof_Plugin);
    p.before_intercept  = plugin_before_intercept;
    p.add_source        = plugin_add_source;
    p.message           = plugin_message;
    p.finish            = plugin_finish;
    p.shutdown          = plugin_shutdown;
    p.handle_one_option = handle_one_option;
    p.log_help          = log_help;
    return p;
}

handle_one_option :: (p: *Metaprogram_Plugin, options: [] string, cursor: int) -> new_cursor: int {
    me := cast(*Iprof_Plugin) p;
    option := options[cursor];
    has_value := cursor + 1 < options.count;

    if option == "-modules" {
        me.include_modules = true;
        return cursor + 1;
    }

    if option == "-csv" {
        if !has_value {
            log_error("[Iprof] -csv needs a file name.\n");
            return cursor + 1;
        }
        me.csv_filename = options[cursor + 1];
        return cursor + 2;
    }

    if option == "-min_size" {
        if !has_value {
            log_error("[Iprof] -min_size needs a number.\n");
            return cursor + 1;
        }
        text := options[cursor + 1];
        value, ok, rest := string_to_int(text);
        if !ok || rest.count {
            log_error("[Iprof] -min_size expects a whole number, not '%'.\n", text);
        } else {
            me.min_size = value;
        }
        return cursor + 2;
    }

    return cursor;  // Not ours.
}

log_help :: (p: *Metaprogram_Plugin) {
    log(#string TEXT
Iprof options:
  -csv <file>      Also write the exit report to <file> as CSV. The file is written by the
                   profiled program each time it runs, not by the compiler.
  -min_size <n>    Only instrument procedures of at least <n> expressions (default %1).
                   Small, frequently called procedures cost more to measure than they take.
                   The entry point is always instrumented.
  -modules         Instrument imported modules too, not just the main program.
  Mark a procedure @NoProfile to leave it out.
TEXT, DEFAULT_MIN_SIZE);
}

#scope_module

DEFAULT_MIN_SIZE :: 30;

RUNTIME_IMPORT :: "__iprof_runtime :: #import \"Iprof\"(IMPORT_MODE = .CLIENT);\n";

plugin_before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags) {
}

plugin_add_source :: (p: *Metaprogram_Plugin) {
    add_build_string(RUNTIME_IMPORT, p.workspace);
}

plugin_message :: (p: *Metaprogram_Plugin, message: *Message) {
    if message.kind != .TYPECHECKED  return;
    me := cast(*Iprof_Plugin) p;
    checked := cast(*Message_Typechecked) message;
    for checked.procedure_bodies  maybe_instrument(me, it.expression, it.subexpressions.count);
}

plugin_finish :: (p: *Metaprogram_Plugin) {
    me := cast(*Iprof_Plugin) p;
    if !me.entry_point_done  log_error("[Iprof] No entry point was instrumented, so nothing will be profiled.\n");
}

plugin_shutdown :: (p: *Metaprogram_Plugin) {
    me := cast(*Iprof_Plugin) p;
    array_free(me.modules_with_import);
    free(me);
}

SKIPPED_PROCEDURE_FLAGS :: Code_Procedure_Header.procedure_flags.COMPILE_TIME_ONLY
                         | .POLYMORPHIC | .MACRO | .C_CALL | .ELSEWHERE | .INTRINSIC | .COMPILER_GENERATED
                         | .SYNTACTICALLY_MARKED_AS_NO_CONTEXT | .SYNTACTICALLY_MARKED_AS_COMPILE_TIME;

maybe_instrument :: (me: *Iprof_Plugin, body: *Code_Procedure_Body, size: s64) {
    header := body.header;
    if !header || body.body_flags & .ALREADY_MODIFIED  return;
    if header.procedure_flags & SKIPPED_PROCEDURE_FLAGS  return;
    if !header.name  return;  // Nameless procedures would make unreadable rows.
    for header.notes  if it.text == "NoProfile"  return;

    file := body.enclosing_load;
    if !file || !file.enclosing_import  return;
    owner := file.enclosing_import;
    in_main := owner.module_type == .MAIN_PROGRAM;
    if !in_main {
        if !me.include_modules  return;
        if owner.module_type == .PRELOAD || owner.module_type == .RUNTIME_SUPPORT  return;
        if owner.module_name == "Iprof"  return;
    }

    is_entry := in_main && header.name == "main" && !me.entry_point_done;
    if !is_entry && size < me.min_size  return;
    if me.should_instrument && !me.should_instrument(body)  return;

    if !me.zone_template  load_templates(me);
    if !in_main && !array_find(me.modules_with_import, owner) {
        add_build_string(RUNTIME_IMPORT, me.workspace, owner);
        array_add(*me.modules_with_import, owner);
    }

    me.zones_planned += 1;
    index := me.zones_planned;  // 0 is the root zone.

    statements: [..] *Code_Node;
    if is_entry  array_add(*statements, with_literals(me.entry_template, .[me.csv_filename]));
    line := cast(s64) body.l0;
    array_add(*statements, with_literals(me.zone_template, .[index, header.name, file.fully_pathed_filename, line]));
    for body.block.statements  array_add(*statements, it);
    body.block.statements = statements;
    compiler_modify_procedure(me.workspace, body);

    if is_entry  me.entry_point_done = true;
}

load_templates :: (me: *Iprof_Plugin) {
    me.zone_template  = cast(*Code_Procedure_Call) compiler_get_nodes(#code __iprof_runtime.Automatic_Zone(0, "", "", 0));
    me.entry_template = cast(*Code_Procedure_Call) compiler_get_nodes(#code __iprof_runtime.Prepend_To_Main(""));
}

// A copy of `template` whose literal arguments take `values` (s64 or string), in order.
with_literals :: (template: *Code_Procedure_Call, values: [] Any) -> *Code_Node {
    call := New(Code_Procedure_Call);
    call.* = template.*;

    count := template.arguments_unsorted.count;
    assert(count == values.count);
    unsorted := NewArray(count, Code_Argument);
    sorted   := NewArray(count, *Code_Node);
    for i: 0..count-1 {
        literal := New(Code_Literal);
        literal.* = (cast(*Code_Literal) template.arguments_unsorted[i].expression).*;
        value := values[i];
        if value.type.type == .STRING  literal._string = (cast(*string) value.value_pointer).*;
        else                           literal._s64    = (cast(*s64) value.value_pointer).*;
        unsorted[i].expression = literal;
        sorted[i] = literal;
    }
    call.arguments_unsorted = unsorted;
    call.arguments_sorted   = sorted;
    return call;
}

#import "Basic";
#import "Compiler";
