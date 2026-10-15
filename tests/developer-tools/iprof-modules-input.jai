#import "Basic";
Child :: #import "Measured_Child";

main :: () {
    assert(Child.child_call() == 42);
    print("ok\n");
}
