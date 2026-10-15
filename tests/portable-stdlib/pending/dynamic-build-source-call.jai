// General metaprogram requirement: added source during a run can call scoped code.
using #import "Basic";
C :: #import "Compiler";

seen: s64;

main :: () {}

inject :: () {
    options := C.get_build_options();
    options.output_type = .NO_OUTPUT;
    C.set_build_options(options);
    C.add_build_string("#run { seen = 41; print(\"added %\\n\", seen); }", -1, #code {});
    print("before %\n", seen);
    message := C.compiler_wait_for_message();

    print("after %, message %\n", seen, message != null);
}

#run,stallable inject();
