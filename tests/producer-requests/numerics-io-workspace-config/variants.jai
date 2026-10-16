#import "Basic";
C :: #import "Compiler";

#run {
    w := C.compiler_create_workspace("independent-configured-import");
    options := C.get_build_options(w);
    options.output_type = .NO_OUTPUT;
    options.import_path = .[tprint("%modules", #filepath)];
    options.text_output_flags = 0;
    C.set_build_options(options, w);
    C.remap_import(w, "Worker", "Basic", "No_Assert");
    C.compiler_begin_intercept(w);
    arguments := C.get_build_options().compile_time_command_line;

    assert(arguments.count == 1);
    C.add_build_file(tprint("%%", #filepath, arguments[0]), w);

    while true {
        message := C.compiler_wait_for_message();

        assert(message.kind != .ERROR);

        if message.kind == .COMPLETE {
            assert((cast(*C.Message_Complete) message).error_code == 0);
            break;
        }
    }

    C.compiler_end_intercept(w);
}

main :: () {}
