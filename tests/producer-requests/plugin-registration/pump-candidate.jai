// Oracle candidate: requires confirmation, not an accepted compiler regression.
// All callees are declared before execution. No addresses are emitted into source.
using #import "Basic";
C :: #import "Compiler";
S :: #import "String";

#load "registration.jai";

exercise :: () {
    workspace := C.compiler_create_workspace("Registered factory target");

    defer C.compiler_destroy_workspace(workspace);
    name := S.join("Registration_", "Probe");

    defer free(name);
    epoch := begin_registration(1);
    source := sprint("Imported :: #import \"%\"(VALUE=41); #run assert(register_factory(%, 0, Imported.get_plugin));", name, epoch);

    defer free(source);
    C.add_build_string(source, -1, #code register_factory);

    // Bounded probe: do not spin forever if this is not a servicing boundary.
    for 0..7 {
        if registration_ready() break;
        C.compiler_wait_for_message();
    }

    assert(registration_ready() && registration_count == 1);
    defer end_registration();
    plugin := factory_slots[0]();

    assert(plugin != null && plugin.init != null);
    plugin.workspace = workspace;
    options: [1] string = .["registration option 41"];

    assert(plugin.init(plugin, options));
    assert(plugin.workspace == workspace);
    print("registered and initialized before return\n");
}

#run,stallable exercise();

main :: () {}
