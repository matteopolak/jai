#import "Basic";
String :: #import "String";
System :: #import "System";
Atomics :: #import "Atomics";

Process_Argument_Quoting :: enum { QUOTE_IF_NEEDED :: 0; NEVER_QUOTE :: 1; }
Process_Result_Type :: enum s32 { UNSTARTED; STILL_RUNNING; FAILED_TO_LAUNCH; EXITED; SIGNALED; }
Process_Result :: struct { type: Process_Result_Type; exit_code: s32; signal: s32; }
Run_Command_Result :: struct {
    exit_code: s64;
    standard_output: string;
    standard_error: string;
    timed_out: bool;
}

Process :: struct {
    input: Pipe;
    output: Pipe;
    error: Pipe;
    #if OS == .WINDOWS {
        job_handle: Windows.HANDLE = cast(Windows.HANDLE) -1;
        info: Windows.PROCESS_INFORMATION;
    } else {
        pid: s32;
        #if OS == .MACOS { kevent_queue: s32 = -1; }
    }
    Pipe :: struct {
        #if OS == .WINDOWS {
            handle: Windows.HANDLE = cast(Windows.HANDLE) -1;
            overlapped: *Windows.OVERLAPPED;
        } else { handle: s32 = -1; }
        eof: bool;
    }
    saved_result: Process_Result;
    launched: bool;
}

#if OS == .WINDOWS { #load "windows.jai"; }
else { #load "posix.jai"; }

break_command_into_strings :: (input: string) -> [..] string {
    result: [..] string;
    result.allocator = temp;
    index: int;
    while index < input.count {
        while index < input.count && command_space(input[index]) index += 1;
        if index == input.count break;
        word: String_Builder;
        init_string_builder(*word);
        quote: u8;
        while index < input.count {
            byte := input[index];
            if quote == 0 && command_space(byte) break;
            if byte == #char "\"" || byte == #char "'" {
                if quote == 0 { quote = byte; index += 1; continue; }
                if quote == byte { quote = 0; index += 1; continue; }
            }
            if byte == #char "\\" && quote != #char "'" && index + 1 < input.count {
                next := input[index + 1];
                if next == #char "\"" || next == #char "\\" || command_space(next) index += 1;
            }
            append(*word, String.slice(input, index, 1));
            index += 1;
        }
        array_add(*result, builder_to_string(*word));
        free_buffers(*word);
    }
    return result;
}

// jaic extension: split a command line into arguments and run it.
run_command_line :: (command: string, capture_and_return_output := false) -> (exit_code: s64, standard_output: string, standard_error: string, timed_out: bool) {
    arguments := break_command_into_strings(command);
    status, output, error, timeout := run_command(..arguments, capture_and_return_output = capture_and_return_output);
    code: s64 = -1;
    if status.type == .EXITED code = status.exit_code;
    else if status.type == .SIGNALED code = 128 + status.signal;
    return code, output, error, timeout;
}

run_command :: (args: .. string, working_directory := "", capture_and_return_output := false, print_captured_output := false, timeout_ms := -1, arg_quoting := Process_Argument_Quoting.QUOTE_IF_NEEDED) -> (process_result: Process_Result, output_string := "", error_string := "", timeout_reached := false) {
    process: Process;
    if !create_process(*process, ..args, working_directory, capture_and_return_output, arg_quoting) return .{type = .FAILED_TO_LAUNCH};
    defer deinit(*process);
    out: String_Builder;
    err: String_Builder;
    init_string_builder(*out);
    init_string_builder(*err);
    defer free_buffers(*out);
    defer free_buffers(*err);
    start := process_monotonic_ms();
    timed_out := false;
    if capture_and_return_output {
        output_buffer: [16384] u8;
        error_buffer: [16384] u8;
        while !process.output.eof || !process.error.eof {
            remaining := remaining_time(start, timeout_ms);
            if timeout_ms >= 0 && remaining == 0 { timed_out = true; kill_process(*process); break; }
            success, output_bytes, error_bytes := read_from_process(*process, output_buffer, error_buffer, remaining);
            if !success { kill_process(*process); break; }
            if output_bytes > 0 {
                bytes: string = .{output_bytes, output_buffer.data};
                append(*out, bytes);
                if print_captured_output write_string(bytes);
            }
            if error_bytes > 0 {
                bytes: string = .{error_bytes, error_buffer.data};
                append(*err, bytes);
                if print_captured_output write_string(bytes, true);
            }
        }
    }
    remaining := remaining_time(start, timeout_ms);
    success, status := get_process_result(*process, remaining);
    if success && status.type == .STILL_RUNNING {
        timed_out = true;
        kill_process(*process);
        success, status = get_process_result(*process);
    }
    if !success status = .{type = .FAILED_TO_LAUNCH, exit_code = -1};
    return status, builder_to_string(*out), builder_to_string(*err), timed_out;
}

run_command_arguments :: (args: .. string, working_directory := "", capture_and_return_output := false, print_captured_output := false, timeout_ms := -1, arg_quoting := Process_Argument_Quoting.QUOTE_IF_NEEDED) -> (process_result: Process_Result, output_string := "", error_string := "", timeout_reached := false) {
    return run_command(..args, working_directory, capture_and_return_output, print_captured_output, timeout_ms, arg_quoting);
}

get_quoted_command_string :: (args: [] string) -> string {
    result: String_Builder;
    init_string_builder(*result);
    defer free_buffers(*result);
    for argument, index: args {
        if index > 0 append(*result, " ");
        append_quoted(*result, argument);
    }
    return builder_to_string(*result);
}

append_quoted :: (builder: *String_Builder, s: string) {
    quote_needed := s.count == 0;
    for byte: s if command_space(byte) || byte == #char "\"" quote_needed = true;
    if !quote_needed { append(builder, s); return; }
    append(builder, "\"");
    slashes: int;
    for byte, i: s {
        if byte == #char "\\" { slashes += 1; continue; }
        repetitions := slashes;
        if byte == #char "\"" repetitions = slashes * 2 + 1;
        for j: 0..repetitions-1 append(builder, "\\");
        slashes = 0;
        append(builder, String.slice(s, i, 1));
    }
    for j: 0..slashes * 2-1 append(builder, "\\");
    append(builder, "\"");
}

thread_is_done :: () -> bool { return Atomics.atomic_read(*active_command_count) == 0; }
shutdown :: () {
    // Every synchronous runner releases its own descriptors before this wait ends.
    while !thread_is_done() sleep_milliseconds(1);
}

#scope_module
active_command_count: s64;
command_space :: (byte: u8) -> bool { return byte == 32 || byte == 9 || byte == 10 || byte == 13; }
remaining_time :: (start: s64, timeout: int) -> int {
    if timeout < 0 return -1;
    elapsed := max(0, process_monotonic_ms() - start);
    return cast(int) max(0, timeout - elapsed);
}
