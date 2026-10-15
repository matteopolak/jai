// General positive compiler requirement for dynamic compile-time plugin imports.
// Execute the known prefix, typecheck newly added source, then resume its call.
using #import "Basic";
C :: #import "Compiler";

load_and_call :: (value: string) {
    options := C.get_build_options();
    options.output_type = .NO_OUTPUT;
    C.set_build_options(options);
    C.add_build_string(value, -1, #code {});
    answer := continuation();

    assert(answer == 41);
    print("ok\n");
}

#run,stallable load_and_call("continuation :: () -> s64 { return 41; }");
