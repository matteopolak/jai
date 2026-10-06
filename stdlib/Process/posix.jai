P :: #import "POSIX";

create_process :: (process: *Process, args: ..string, working_directory := "", capture_and_return_output := false, arg_quoting := Process_Argument_Quoting.QUOTE_IF_NEEDED, kill_process_if_parent_exits := true) -> success: bool {
    if process.launched || args.count == 0 || !args[0] return false;
    argv := cast(**u8) alloc((args.count + 1) * size_of(*u8), temp);
    for arg, index: args argv[index] = temp_c_string(arg);
    argv[args.count] = null;
    directory := temp_c_string(working_directory);
    child_input: [2] s32 = .[-1, -1];
    child_output: [2] s32 = .[-1, -1];
    child_error: [2] s32 = .[-1, -1];
    launch_error: [2] s32 = .[-1, -1];
    defer close_pair(*launch_error);
    if !safe_pipe(*launch_error) return false;
    if capture_and_return_output {
        // The child's stdin is a stream socket, not a pipe: callers rely on that to pass
        // messages and descriptors both ways (`send`/`recv`, `fstat` reporting S_IFSOCK).
        if !safe_pipe(*child_input, socket = true) return false;
        if !safe_pipe(*child_output) {
            close_pair(*child_input);
            return false;
        }
        if !safe_pipe(*child_error) {
            close_pair(*child_input);
            close_pair(*child_output);
            return false;
        }
    }
    pid := P.fork();
    if pid < 0 {
        close_pair(*child_input);
        close_pair(*child_output);
        close_pair(*child_error);
        return false;
    }
    if pid == 0 {
        P.close(launch_error[0]);
        ok := true;
        if capture_and_return_output {
            ok = P.dup2(child_input[0], 0) >= 0 && P.dup2(child_output[1], 1) >= 0 && P.dup2(child_error[1], 2) >= 0;
            close_pair(*child_input);
            close_pair(*child_output);
            close_pair(*child_error);
        }
        if ok && working_directory ok = P.chdir(directory) == 0;
        // At compile time `OS` is the target, which need not be the host running the compiler
        // (`jaic check -os linux` on macOS), and the parent is the compiler itself.
        #if OS == .LINUX {
            if ok && kill_process_if_parent_exits && !#compile_time ok = process_prctl(1, 9, 0, 0, 0) == 0;
        }
        if ok P.execvp(argv[0], argv);
        failure := P.errno();
        P.write(launch_error[1], *failure, size_of(s32));
        P._exit(127);
    }
    P.close(launch_error[1]);
    launch_error[1] = -1;
    if capture_and_return_output {
        P.close(child_input[0]);
        child_input[0] = -1;
        P.close(child_output[1]);
        child_output[1] = -1;
        P.close(child_error[1]);
        child_error[1] = -1;
    }
    failure: s32;
    count := P.read(launch_error[0], *failure, size_of(s32));
    while count < 0 && P.errno() == P.EINTR count = P.read(launch_error[0], *failure, size_of(s32));
    if count != 0 {
        close_pair(*child_input);
        close_pair(*child_output);
        close_pair(*child_error);
        status: s32;
        P.waitpid(pid, *status, 0);
        return false;
    }
    process.pid = pid;
    process.launched = true;
    process.saved_result = .{ type = .STILL_RUNNING };
    process.input.handle = child_input[1];
    process.output.handle = child_output[0];
    process.error.handle = child_error[0];
    process.output.eof = !capture_and_return_output;
    process.error.eof = !capture_and_return_output;
    Atomics.atomic_increment(*active_command_count);
    return true;
}

deinit :: (process: *Process) {
    deinit(*process.input);
    deinit(*process.output);
    deinit(*process.error);
    if process.launched && process.saved_result.type == .STILL_RUNNING {
        kill_process(process);
        get_process_result(process);
    }
    if process.launched Atomics.atomic_decrement(*active_command_count);
    process.* = .{};
}
deinit :: (pipe: *Process.Pipe) {
    if pipe.handle >= 0 P.close(pipe.handle);
    pipe.handle = -1;
    pipe.eof = true;
}
write_to_process :: (process: *Process, data: [] u8) -> success: bool, bytes_written: int {
    if process.input.handle < 0 || data.count < 0 || data.count > 0 && !data.data return false, 0;
    blocked: P.sigset_t;
    previous: P.sigset_t;
    before: P.sigset_t;
    if P.sigemptyset(*blocked) != 0 || P.sigaddset(*blocked, P.SIGPIPE) != 0 return false, 0;
    if P.pthread_sigmask(P.SIG_BLOCK, *blocked, *previous) != 0 return false, 0;
    defer P.pthread_sigmask(P.SIG_SETMASK, *previous, null);
    originally_pending := P.sigpending(*before) == 0 && P.sigismember(*before, P.SIGPIPE) == 1;
    amount := P.write(process.input.handle, data.data, cast(u64) data.count);
    while amount < 0 && P.errno() == P.EINTR amount = P.write(process.input.handle, data.data, cast(u64) data.count);
    if amount < 0 && P.errno() == P.EPIPE && !originally_pending {
        pending: P.sigset_t;
        ignored: s32;
        if P.sigpending(*pending) == 0 && P.sigismember(*pending, P.SIGPIPE) == 1 P.sigwait(*blocked, *ignored);
    }
    return amount >= 0, cast(int) max(0, amount);
}
// One read from a pipe. End of input and a non-blocking pipe with nothing to read both give
// (true, 0); the handle stays open and `eof` is left to the caller, which knows whether the
// pipe was reported readable (callers watching handles themselves keep them registered).
read_pipe :: (pipe: *Process.Pipe, buffer: [] u8) -> success: bool, bytes_read: int {
    if pipe.handle < 0 return false, 0;
    if buffer.count == 0 return true, 0;
    amount := P.read(pipe.handle, buffer.data, cast(u64) buffer.count);
    while amount < 0 && P.errno() == P.EINTR amount = P.read(pipe.handle, buffer.data, cast(u64) buffer.count);
    if amount < 0 && (P.errno() == P.EAGAIN || P.errno() == P.EWOULDBLOCK) return true, 0;
    return amount >= 0, cast(int) max(0, amount);
}
read_from_process :: (process: *Process, output_buffer: [] u8, error_buffer: [] u8, timeout_ms := -1) -> success: bool, output_bytes: int, error_bytes: int {
    descriptors: [2] P.pollfd;
    descriptors[0].fd = process.output.handle;
    descriptors[1].fd = process.error.handle;
    descriptors[0].events = 1;
    descriptors[1].events = 1;
    if process.output.eof || output_buffer.count == 0 descriptors[0].fd = -1;
    if process.error.eof || error_buffer.count == 0 descriptors[1].fd = -1;
    if descriptors[0].fd == -1 && descriptors[1].fd == -1 return true, 0, 0;
    start := process_monotonic_ms();
    result := P.poll(descriptors.data, 2, cast(s32) timeout_ms);
    while result < 0 && P.errno() == P.EINTR result = P.poll(descriptors.data, 2, cast(s32) remaining_time(start, timeout_ms));
    if result < 0 return false, 0, 0;
    output_bytes: int;
    error_bytes: int;
    ok := true;
    // Readable (or hung up) but nothing read: the writer closed its end.
    if descriptors[0].revents & (1 | 8 | 16) {
        success, output_bytes = read_pipe(*process.output, output_buffer);
        ok = ok && success;
        if success && output_bytes == 0 process.output.eof = true;
    }
    if descriptors[1].revents & (1 | 8 | 16) {
        success, error_bytes = read_pipe(*process.error, error_buffer);
        ok = ok && success;
        if success && error_bytes == 0 process.error.eof = true;
    }
    return ok, output_bytes, error_bytes;
}
kill_process :: (process: *Process) -> bool {
    return process.launched && (process.saved_result.type != .STILL_RUNNING || P.kill(process.pid, 9) == 0);
}
get_process_result :: (process: *Process, timeout_ms := -1) -> success: bool, Process_Result {
    if !process.launched return true, .{ type = .UNSTARTED };
    if process.saved_result.type != .STILL_RUNNING return true, process.saved_result;
    start := process_monotonic_ms();
    while true {
        raw_status: s32;
        options: s32;
        if timeout_ms >= 0 options = P.WNOHANG;
        result := P.waitpid(process.pid, *raw_status, options);
        if result < 0 {
            if P.errno() == P.EINTR continue;
            return false, process.saved_result;
        }
        if result > 0 {
            low_signal := raw_status & 0x7f;
            if low_signal == 0 process.saved_result = .{ type = .EXITED, exit_code = (raw_status >> 8) & 0xff };
            else process.saved_result = .{ type = .SIGNALED, exit_code = -1, signal = low_signal };
            return true, process.saved_result;
        }
        if remaining_time(start, timeout_ms) == 0 return true, process.saved_result;
        P.usleep(1000);
    }
}
close_and_reset :: (fd: *s32, loc := #caller_location) {
    if fd.* >= 0 P.close(fd.*);
    fd.* = -1;
}

#scope_module
close_pair :: (pair: *[2] s32) {
    close_and_reset(*(<<pair)[0]);
    close_and_reset(*(<<pair)[1]);
}
safe_pipe :: (pair: *[2] s32, socket := false) -> bool {
    if socket {
        if process_socketpair(1, 1, 0, pair) != 0 return false; // AF_UNIX, SOCK_STREAM
    } else {
        if P.pipe(pair) != 0 return false;
    }
    fds := pair;
    for i: 0..1 {
        fd := *(<<fds)[i];
        if <<fd < 3 {
            replacement := P.fcntl(<<fd, P.F_DUPFD, cast(s32) 3);
            if replacement < 0 {
                close_pair(pair);
                return false;
            }
            P.close(<<fd);
            <<fd = replacement;
        }
        if P.fcntl(<<fd, P.F_SETFD, cast(s32) P.FD_CLOEXEC) < 0 {
            close_pair(pair);
            return false;
        }
    }
    return true;
}
process_monotonic_ms :: () -> s64 {
    time: P.timespec;
    clock_id: s32 = 1;
    #if OS == .MACOS {
        clock_id = 6;
    }
    if P.clock_gettime(xx clock_id, *time) != 0 return 0;
    return time.tv_sec * 1000 + time.tv_nsec / 1000000;
}
process_socket_libc :: #system_library "libc";
process_socketpair :: (domain: s32, type: s32, protocol: s32, pair: *[2] s32) -> s32 #foreign process_socket_libc "socketpair";
#if OS == .LINUX {
    process_libc :: #system_library "c";
    process_prctl :: (option: s32, value: u64, extra1: u64, extra2: u64, extra3: u64) -> s32 #foreign process_libc "prctl";
}
