#load "../File/windows-encoding.jai";
Windows :: #import "Windows";
Utf8 :: #import "Windows_Utf8";

create_process :: (process: *Process, args: ..string, working_directory := "", capture_and_return_output := false, arg_quoting := Process_Argument_Quoting.QUOTE_IF_NEEDED, kill_process_if_parent_exits := true) -> success: bool {
    if process.launched || args.count == 0 || !args[0] return false;
    command: string;
    if arg_quoting == .NEVER_QUOTE command = String.join(..args, separator = " ");
    else command = get_quoted_command_string(args);
    native_command := os_utf8_to_wide(command);
    startup: Windows.STARTUPINFOW;
    startup.cb = size_of(Windows.STARTUPINFOW);
    child_input: Windows.HANDLE;
    child_output: Windows.HANDLE;
    child_error: Windows.HANDLE;
    defer if child_input Windows.CloseHandle(child_input);
    defer if child_output Windows.CloseHandle(child_output);
    defer if child_error Windows.CloseHandle(child_error);
    if capture_and_return_output {
        attributes: Windows.SECURITY_ATTRIBUTES;
        attributes.nLength = size_of(Windows.SECURITY_ATTRIBUTES);
        attributes.bInheritHandle = 1;
        if !Windows.CreatePipe(*child_input, *process.input.handle, *attributes, 0) return false;
        // Unopened ends still hold the invalid-handle default, which deinit skips.
        if !Windows.CreatePipe(*process.output.handle, *child_output, *attributes, 0) || !Windows.CreatePipe(*process.error.handle, *child_error, *attributes, 0) {
            close_pipe_ends(process);
            return false;
        }
        Windows.SetHandleInformation(process.input.handle, 1, 0);
        Windows.SetHandleInformation(process.output.handle, 1, 0);
        Windows.SetHandleInformation(process.error.handle, 1, 0);
        startup.dwFlags = cast(type_of(startup.dwFlags)) 0x100;
        startup.hStdInput = child_input;
        startup.hStdOutput = child_output;
        startup.hStdError = child_error;
    }
    directory: *u16;
    if working_directory directory = os_utf8_to_wide(working_directory);
    flags: Windows.Creation_Flags;
    if kill_process_if_parent_exits flags = cast(Windows.Creation_Flags) 4;
    if !Windows.CreateProcessW(null, native_command, null, null, xx capture_and_return_output, flags, null, directory, *startup, *process.info) {
        log_error("could not start \"%\": %", args[0], System.get_error_string(System.get_error_value()));
        close_pipe_ends(process);
        return false;
    }
    if kill_process_if_parent_exits {
        process.job_handle = Windows.CreateJobObjectA(null, null);
        limits: Windows.JOBOBJECT_EXTENDED_LIMIT_INFORMATION;
        limits.BasicLimitInformation.LimitFlags = cast(Windows.Job_Object_Limit) 0x2000;
        if !process.job_handle || !Windows.SetInformationJobObject(process.job_handle, .ExtendedLimitInformation, *limits, size_of(type_of(limits))) || !Windows.AssignProcessToJobObject(process.job_handle, process.info.hProcess) {
            Windows.TerminateProcess(process.info.hProcess, 127);
            Windows.CloseHandle(process.info.hThread);
            Windows.CloseHandle(process.info.hProcess);
            if process.job_handle Windows.CloseHandle(process.job_handle);
            process.job_handle = cast(Windows.HANDLE) -1;
            close_pipe_ends(process);
            return false;
        }
        Windows.ResumeThread(process.info.hThread);
    }
    process.launched = true;
    process.saved_result = .{ type = .STILL_RUNNING };
    process.output.eof = !capture_and_return_output;
    process.error.eof = !capture_and_return_output;
    Atomics.atomic_increment(*active_command_count);
    return true;
}

deinit :: (pipe: *Process.Pipe) {
    if pipe.handle && pipe.handle != cast(Windows.HANDLE) -1 Windows.CloseHandle(pipe.handle);
    pipe.handle = cast(Windows.HANDLE) -1;
    pipe.eof = true;
}
deinit :: (process: *Process) {
    close_pipe_ends(process);
    if process.launched {
        if process.saved_result.type == .STILL_RUNNING {
            kill_process(process);
            get_process_result(process);
        }
        Windows.CloseHandle(process.info.hThread);
        Windows.CloseHandle(process.info.hProcess);
        if process.job_handle && process.job_handle != cast(Windows.HANDLE) -1 Windows.CloseHandle(process.job_handle);
        Atomics.atomic_decrement(*active_command_count);
    }
    process.* = .{};
}
write_to_process :: (process: *Process, data: [] u8) -> success: bool, bytes_written: int {
    amount: u32;
    success := Windows.WriteFile(process.input.handle, data.data, cast(u32) min(data.count, 0x7fff_ffff), *amount, null) != 0;
    return success, cast(int) amount;
}
read_pipe :: (pipe: *Process.Pipe, buffer: [] u8) -> success: bool, bytes_read: int {
    if pipe.eof || buffer.count == 0 return true, 0;
    available: u32;
    if !Windows.PeekNamedPipe(pipe.handle, null, 0, null, *available, null) {
        if cast(u32) Windows.GetLastError() == 109 {
            deinit(pipe);
            return true, 0;
        }
        return false, 0;
    }
    if available == 0 return true, 0;
    amount: u32;
    request := cast(u32) min(buffer.count, available);
    success := Windows.ReadFile(pipe.handle, buffer.data, request, *amount, null) != 0;
    return success, cast(int) amount;
}
read_from_process :: (process: *Process, output_buffer: [] u8, error_buffer: [] u8, timeout_ms := -1) -> success: bool, output_bytes: int, error_bytes: int {
    start := process_monotonic_ms();
    while true {
        out_ok, out_count := read_pipe(*process.output, output_buffer);
        err_ok, err_count := read_pipe(*process.error, error_buffer);
        if !out_ok || !err_ok return false, out_count, err_count;
        if out_count || err_count || process.output.eof && process.error.eof return true, out_count, err_count;
        if remaining_time(start, timeout_ms) == 0 return true, 0, 0;
        Windows.Sleep(1);
    }
}
kill_process :: (process: *Process) -> bool {
    return process.launched && (process.saved_result.type != .STILL_RUNNING || Windows.TerminateProcess(process.info.hProcess, 137) != 0);
}
get_process_result :: (process: *Process, timeout_ms := -1) -> success: bool, Process_Result {
    if !process.launched return true, .{ type = .UNSTARTED };
    if process.saved_result.type != .STILL_RUNNING return true, process.saved_result;
    native_timeout: u32 = 0xffff_ffff;
    if timeout_ms >= 0 native_timeout = cast(u32) timeout_ms;
    result := Windows.WaitForSingleObject(process.info.hProcess, native_timeout);
    if result == 258 return true, process.saved_result;
    if result != 0 return false, process.saved_result;
    code: u32;
    if !Windows.GetExitCodeProcess(process.info.hProcess, *code) return false, process.saved_result;
    process.saved_result = .{ type = .EXITED, exit_code = cast,no_check(s32) code };
    return true, process.saved_result;
}

#scope_module
process_monotonic_ms :: () -> s64 {
    counter: s64;
    frequency: s64;
    if !Windows.QueryPerformanceCounter(*counter) || !Windows.QueryPerformanceFrequency(*frequency) || frequency <= 0 return 0;
    return counter / frequency * 1000 + (counter % frequency) * 1000 / frequency;
}
