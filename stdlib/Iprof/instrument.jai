// Compile-time half of Iprof (IMPORT_MODE == .METAPROGRAM): a Metaprogram_Plugin that prepends a profiling
// zone to every sufficiently large procedure, then injects the zone table and runtime hookup.
//
// Note: jaic cannot instantiate metaprogram plugins yet (see Metaprogram_Plugins), so this half only has to
// typecheck for now; the runtime half (IMPORT_MODE=.CLIENT, MANUAL_MODE=true) works standalone.

get_plugin :: () -> *Metaprogram_Plugin {
    p := New(My_Plugin);  // Heap allocated so several instances can coexist.

    p.before_intercept = before_intercept;
    p.add_source       = add_source;
    p.message          = message;
    p.finish           = finish;
    p.shutdown         = shutdown;

    p.log_help          = log_help;
    p.handle_one_option = handle_one_option;

    s := get_working_directory();
    for 0..s.count-1  if s[it] == #char "\\" s[it] = #char "/";
    p.current_working_directory = copy_string(s);

    // my.prepend_main_nodes (the syntax tree of `prepend_main`) is fetched lazily, the first time the entry
    // point is instrumented: compiler_get_nodes needs syntax-tree access, which jaic does not provide yet,
    // and get_plugin() itself should stay callable.
    return p;
}

before_intercept :: (p: *Metaprogram_Plugin, flags: *Intercept_Flags) {
}

add_source :: (p: *Metaprogram_Plugin) {
    w := p.workspace;
    assert(w >= 0);
    add_build_string(TO_INSERT, w);
}

message :: (p: *Metaprogram_Plugin, message: *Message) {
    if injected_final_profiling_code return;

    my := cast(*My_Plugin) p;

    if message.kind == .PHASE {
        phase_message := cast(*Message_Phase) message;

        if phase_message.phase == .TYPECHECKED_ALL_WE_CAN {
            if !injected_final_profiling_code && instrumented_entry_point {
                injected_final_profiling_code = true;
                inject_zone_table(my, message.workspace);
            }
        }
        return;
    }

    if message.kind != .TYPECHECKED return;

    m := cast(*Message_Typechecked) message;

    assert(!injected_final_profiling_code);
    for * tc: m.procedure_bodies {
        body := tc.expression;
        if body.body_flags & .ALREADY_MODIFIED continue;

        h := body.header;
        assert(h != null);

        skip_mask: type_of(h.procedure_flags) = .POLYMORPHIC | .COMPILER_GENERATED | .COMPILE_TIME_ONLY | .QUICK | .TYPE_ONLY | .MACRO;
        if h.procedure_flags & skip_mask continue;

        is_entry_point := (h.procedure_flags & .ENTRY_POINT) != 0;

        file := body.enclosing_load;
        use_guarded_macro := false;

        // #c_call / #no_context procedures have no context to find the profiler in.
        type := cast(*Type_Info_Procedure) h.type;
        if type.procedure_flags & .HAS_NO_CONTEXT continue;

        // Never profile Iprof itself or the language runtime.
        if file && file.enclosing_import {
            import := file.enclosing_import;

            if import.module_name == "Iprof"  continue;
            if import.module_type == .PRELOAD continue;
            if import.module_type == .RUNTIME_SUPPORT continue;

            if import.module_type != .MAIN_PROGRAM {
                if !my.instrument_modules continue;

                if import.module_name == "Pool" continue;  // The runtime needs it before it is initialized.
                if import.module_name == "Thread" use_guarded_macro = true;

                if import.module_name == "Basic" {
                    if h.name == "temporary_allocator_proc" continue;  // Would be circular.
                    if h.name == "IsScalar" continue;
                    if contains(file.fully_pathed_filename, "module.jai") use_guarded_macro = true;
                }
            }
        }

        if !is_entry_point {  // The entry point always gets a zone: that is where startup and shutdown are hooked.
            if tc.subexpressions.count < my.min_size continue;
            if my.should_instrument {
                if !my.should_instrument(body) continue;
            }

            skip := false;
            for h.notes  if it.text == "NoProfile" {
                log("[Iprof] Skipping '%' due to NoProfile note.\n", h.name);
                skip = true;
            }
            if skip continue;
        }

        zone_index := zone_infos.count;

        info := array_add(*zone_infos);
        info.name = h.name;
        info.load = h.enclosing_load;
        info.line = h.l0;

        new_statements: [..] *Code_Node;
        array_reserve(*new_statements, body.block.statements.count + 2);

        if is_entry_point {
            if !my.prepend_main_nodes  my.prepend_main_nodes = compiler_get_nodes(prepend_main);
            array_add(*new_statements, my.prepend_main_nodes);
            instrumented_entry_point = true;
        }

        {
            // Insert `context._Iprof.Automatic_Zone(<index>);` as the first statement.
            s := ifx use_guarded_macro
                then tprint("context._Iprof.Automatic_Zone_Guarded(%);", zone_index)
                else tprint("context._Iprof.Automatic_Zone(%);", zone_index);

            literal := New(Code_Literal);
            literal.kind = .LITERAL;
            literal.value_type = .STRING;
            literal.values._string = s;

            insert := New(Code_Directive_Insert);
            insert.kind = .DIRECTIVE_INSERT;
            insert.expression = literal;
            insert.location = body.location;

            array_add(*new_statements, insert);
        }

        for body.block.statements  array_add(*new_statements, it);
        body.block.statements = new_statements;

        compiler_modify_procedure(message.workspace, body);
    }
}

finish :: (p: *Metaprogram_Plugin) {
}

shutdown :: (p: *Metaprogram_Plugin) {
    free(p);
}

// Zone_Info exists only at compile time: it records which zones were created so that their names
// can be written out as initialization source code.
Zone_Info :: struct {
    name: string;
    load: *Message_File;
    line: s64;
}

zone_infos: [..] Zone_Info;  // The zone index is preserved into runtime.

// Importing Iprof from a global declaration and binding it via #add_context (rather than
// `#add_context :: #import ...`) makes the import happen immediately, so modules Iprof pulls in can
// still add to the context.
TO_INSERT :: #string DONE
__Iprof :: #import "Iprof"(IMPORT_MODE=.CLIENT);
#add_context _Iprof :: __Iprof;
DONE

prepend_main :: #code context._Iprof.Prepend_To_Main();

injected_final_profiling_code := false;
instrumented_entry_point := false;

inject_zone_table :: (my: *My_Plugin, w: Workspace) {
    tally := zone_infos.count;
    log("[Iprof] Adding the zone initialization code for % zones.\n", tally);

    add_build_string(tprint("AUTO_INSTRUMENT_ZONE_COUNT :: %;\n#poke_name __Iprof AUTO_INSTRUMENT_ZONE_COUNT;\nCSV_OUTPUT_FILENAME :: \"%\"; #poke_name __Iprof CSV_OUTPUT_FILENAME;\n", tally, my.csv_output_filename), w);

    add_hook(w, "iprof_per_frame_hook", "()", my.per_frame_hook_name, "()");
    add_hook(w, "iprof_editor_hook", "(filename: string, line: s64)", my.editor_hook_name, "(filename, line)");

    add_build_string(tprint("PROF_FONT_NAME :: \"%\";\n", my.font_name), w);

    builder: String_Builder;
    append(*builder, "_init_zone_names :: () {\n");
    append(*builder, "    z: *__Iprof.Zone;\n");

    for zone_infos {
        hash := crc64(it.name);  // Stable ID derived from the name.

        full_path := "";
        if it.load full_path = it.load.fully_pathed_filename;
        print_to_builder(*builder, "    z = *__Iprof.zones[%]; z.name = \"%\"; z.hash = 0x%; z.filename = \"%\"; z.full_path = \"%\"; z.line = %;\n",
                         it_index, it.name, formatInt(hash, base = 16), full_path, full_path, it.line);
    }
    append(*builder, "} @NoProfile\n");

    source := builder_to_string(*builder);
    defer free(source);
    add_build_string(source, w);
}

// Defines `<iprof_hook_name> :: <args> { <user_hook_name> <user args>; }` in the target program.
add_hook :: (w: Workspace, iprof_hook_name: string, iprof_hook_args: string, user_hook_name: string, user_hook_args: string) {
    insertion := "";
    if user_hook_name insertion = sprint("    % %;\n", user_hook_name, user_hook_args);
    defer if insertion free(insertion.data);

    add_build_string(tprint("% :: % {\n%\n}\n\n", iprof_hook_name, iprof_hook_args, insertion), w);
}

#scope_module

MINIMUM_SIZE_DEFAULT :: 30;

My_Plugin :: struct {
    #as using base: Metaprogram_Plugin;

    // Fill these in after get_plugin():
    should_instrument: (body: *Code_Procedure_Body) -> bool;

    per_frame_hook_name: string;
    editor_hook_name:    string;
    font_name:           string;

    // Set by command-line options:
    csv_output_filename: string;
    min_size := MINIMUM_SIZE_DEFAULT;
    instrument_modules := false;

    // Internal:
    current_working_directory: string;
    prepend_main_nodes: *Code_Node;
}

#import "Crc";
#import "Basic";
#import "Compiler";
#import "File";
#import "String";
