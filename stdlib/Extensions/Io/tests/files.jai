// Extensions/Io files: whole-file reads and writes, modes, positions and offsets, errors, and
// several fibers using files at once.
#load "lib/suite.jai";

main :: () {
    #if OS == .WINDOWS {
        print("skipped: Extensions/Io has no IO on Windows yet\n");
    } else {
        run_group(run_files);
        print("ok (backend %)\n", last_backend);
    }
}
