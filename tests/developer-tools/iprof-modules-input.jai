#import "Basic";
Child :: #import "Measured_Child";

main :: () {
    memory := cast(*u8) alloc(8);
    memory[0] = 42;
    assert(memory[0] == Child.child_call());
    free(memory);
    print("ok\n");
}
