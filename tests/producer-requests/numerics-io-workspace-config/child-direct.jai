using B :: #import "Basic"()(ENABLE_ASSERT = false);
W :: #import "Worker";

main :: () {
    assert(W.disabled());
}
