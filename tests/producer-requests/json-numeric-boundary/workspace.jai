// Pass - <owned scratch directory>; only the child emits output.
#import "Basic";
C :: #import "Compiler";

#run {
    arguments := C.get_build_options().compile_time_command_line;
    output_path := ifx arguments.count > 0 then arguments[0] else "";

    C.set_build_options_dc(.{ do_output = false });
    child := C.compiler_create_workspace("numeric-runtime-contract");
    options := C.get_build_options(child);
    options.output_type = ifx output_path.count > 0 then .EXECUTABLE else .NO_OUTPUT;
    options.os_target = .WASM;
    options.cpu_target = .CUSTOM;
    options.llvm_options.target_system_triple = "wasm64-unknown-wasi";
    options.llvm_options.bitcode_optimization_setting = .O2;
    options.output_path = output_path;
    options.output_executable_name = "numeric-workspace.wasm";
    options.append_executable_filename_extension = false;
    options.text_output_flags = 0;
    C.set_build_options(options, child);
    C.set_build_options_dc(.{ do_output = output_path.count > 0 }, child);
    C.add_build_file(tprint("%../../compiler-semantics/wasm-c-numeric.jai", #filepath), child);
}

main :: () {}
