// Runs every Extensions/Io engine test once per backend the system can offer, forcing each with
// JAI_IO_BACKEND: io_uring and epoll on Linux, kqueue on macOS. A backend the system refuses
// (io_uring in a container, on an old kernel, or with io_uring_disabled) is skipped with a message.
// The default backend and the forced ones must pass the same tests.
#load "lib/suite.jai";

#if OS != .WINDOWS {
    libc :: #system_library "libc";
    setenv :: (name: *u8, value: *u8, overwrite: s32) -> s32 #foreign libc;
}

backend_found: string;

probe_backend :: () {
    backend_found = Io.backend_name();
}

main :: () {
    #if OS == .WINDOWS {
        print("skipped: Extensions/Io has no IO on Windows yet\n");
    } else {
        #if OS == .LINUX names := string.["io_uring", "epoll"];
        else names := string.["kqueue"];

        passed := 0;

        for names {
            setenv("JAI_IO_BACKEND", temp_c_string(it), 1);

            Io.io_run(probe_backend);

            if backend_found != it {
                print("skipped %: the scheduler got % instead\n", it, backend_found);

                continue;
            }

            started := now_ms();

            run_group(run_all);
            passed += 1;

            print("% passed (% ms)\n", it, now_ms() - started);
        }

        assert(passed > 0, "no backend ran");
    }
}
