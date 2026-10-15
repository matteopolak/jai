// Original dependency reduction for the integrator; Linux compile is currently
// blocked by Io_Uring's obsolete ordering arguments, outside this worker's scope.
Uring :: #import "Extensions/Io_Uring";

main :: () {
    ring: Uring.Ring;
    Uring.submit_and_wait(*ring, 1);
}
