#import "Basic";
String :: #import "String";

Processor_Query_Type :: enum u8 {
    ALL_PHYSICAL;
    ALL_LOGICAL;
    PERFORMANCE_PHYSICAL;
    PERFORMANCE_LOGICAL;
}

#if OS == .WINDOWS {
    #load "File/windows-encoding.jai";
    Windows :: #import "Windows";
    Utf8 :: #import "Windows_Utf8";

    OS_Error_Code :: Windows.OS_Error_Code;
    get_error_value :: Windows.GetLastError;

    get_path_of_running_executable :: () -> string {
        capacity: s32 = 512;
        while capacity <= 32768 {
            buffer := cast(*u16) alloc(cast(s64) capacity * 2, temp);
            length := Windows.GetModuleFileNameW(null, buffer, capacity);
            if length == 0 return "";
            if length < capacity return os_wide_to_utf8(buffer, length);
            capacity *= 2;
        }
        return "";
    }

    get_username :: () -> string, success: bool {
        buffer: [257] u16;
        length: u32 = xx buffer.count;
        if !Windows.GetUserNameW(buffer.data, *length) return "", false;
        return os_wide_to_utf8(buffer.data), true;
    }

    get_home_directory :: (username := "") -> string, success: bool {
        if username return "", false;
        value := Windows.getenv(temp_c_string("USERPROFILE"));
        if !value return "", false;
        return copy_string(to_string(value)), true;
    }

    get_machinename :: () -> string {
        buffer: [256] u16;
        length: u32 = xx buffer.count;
        if !Windows.GetComputerNameW(buffer.data, *length) return "";
        return os_wide_to_utf8(buffer.data, xx length);
    }

    get_error_string :: (error_code: OS_Error_Code) -> string {
        buffer: [2048] u16;
        count := Windows.FormatMessageW(0x1000 | 0x200, null, cast(u32) error_code, 0, cast(**u16) buffer.data, xx buffer.count, null);
        if count == 0 return tprint("OS error %", error_code);
        return os_wide_to_utf8(buffer.data, count);
    }
} else {
    P :: #import "POSIX";

    OS_Error_Code :: P.OS_Error_Code;
    get_error_value :: P.errno;

    get_path_of_running_executable :: () -> string {
        #if OS == .MACOS || OS == .IOS {
            count: u32;
            system_executable_path(null, *count);
            if count == 0 return "";
            buffer := cast(*u8) alloc(count, temp);
            if system_executable_path(buffer, *count) != 0 return "";
            return to_string(buffer);
        } else {
            capacity: s64 = 256;
            while capacity <= 1048576 {
                buffer := cast(*u8) alloc(capacity, temp);
                length := P.readlink(temp_c_string("/proc/self/exe"), buffer, xx capacity);
                if length < 0 return "";
                if length < capacity return .{ length, buffer };
                capacity *= 2;
            }
            return "";
        }
    }

    #if OS == .LINUX || OS == .ANDROID || OS == .MACOS {
        // Results live in temporary storage. An empty username means the current user.
        get_passwd_for_user :: (username := "") -> (success: bool, p: P.passwd) {
            buffer_size: s64 = 1024;
            while true {
                buffer := cast(*u8) alloc(buffer_size, temp);
                result_pwd: *P.passwd;
                pwd: P.passwd;
                result: s32;
                if username result = P.getpwnam_r(temp_c_string(username), *pwd, buffer, cast(u64) buffer_size, *result_pwd);
                else result = P.getpwuid_r(P.getuid(), *pwd, buffer, cast(u64) buffer_size, *result_pwd);
                if result != 0 {
                    if P.errno() == P.ERANGE && buffer_size < 16384 {
                        buffer_size *= 2;
                        continue;
                    }
                    return false, .{};
                }
                if !result_pwd return false, pwd;
                return true, pwd;
            }
            return false, .{};
        }
    }

    get_username :: () -> string, success: bool {
        entry := P.getpwuid(P.getuid());
        if !entry || !entry.pw_name return "", false;
        return copy_string(to_string(entry.pw_name)), true;
    }

    get_home_directory :: (username := "") -> string, success: bool {
        entry: *P.passwd;
        if username entry = P.getpwnam(temp_c_string(username));
        else entry = P.getpwuid(P.getuid());
        if !entry || !entry.pw_dir return "", false;
        return copy_string(to_string(entry.pw_dir)), true;
    }

    get_machinename :: () -> string {
        buffer: [256] u8;
        if P.gethostname(buffer.data, buffer.count - 1) != 0 return "";
        buffer[buffer.count - 1] = 0;
        return copy_string(to_string(buffer.data));
    }

    get_error_string :: (error_code: OS_Error_Code) -> string {
        description := system_strerror(cast(s32) error_code);
        if !description return tprint("OS error %", error_code);
        return copy_string(to_string(description));
    }

    #scope_module
    system_libc :: #system_library "c";
    system_strerror :: (code: s32) -> *u8 #foreign system_libc "strerror";

    #if OS == .MACOS || OS == .IOS {
        system_executable_path :: (buffer: *u8, count: *u32) -> s32 #foreign system_libc "_NSGetExecutablePath";
    }
    #scope_export
}

get_error_value_and_string :: () -> (error_code: OS_Error_Code, description: string) {
    code := get_error_value();
    return code, get_error_string(code);
}

get_number_of_processors :: ($type: Processor_Query_Type = .PERFORMANCE_LOGICAL) -> count: s32 {
    return cast(s32) get_number_of_processors_for_type(type);
}

get_number_of_processors_for_type :: (type: Processor_Query_Type = .PERFORMANCE_LOGICAL) -> s64 {
    return system_processor_count(type);
}

#scope_module
#if OS == .WINDOWS {
    system_processor_count :: (query: Processor_Query_Type) -> s64 {
        length: u32;
        Windows.GetLogicalProcessorInformationEx(.RelationProcessorCore, null, *length);
        if length == 0 return 0;
        buffer := cast(*u8) alloc(length, temp);
        if !Windows.GetLogicalProcessorInformationEx(.RelationProcessorCore, cast(*Windows.SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX) buffer, *length) return 0;
        largest_class: u8;
        offset: u32;
        while offset < length {
            if length - offset < 32 return 0;
            record := cast(*Windows.SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX) (buffer + offset);
            if record.Size < 32 || record.Size > length - offset return 0;
            largest_class = max(largest_class, record.Processor.EfficiencyClass);
            offset += record.Size;
        }
        physical := query == .ALL_PHYSICAL || query == .PERFORMANCE_PHYSICAL;
        all := query == .ALL_PHYSICAL || query == .ALL_LOGICAL;
        result: s64;
        offset = 0;
        while offset < length {
            record := cast(*Windows.SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX) (buffer + offset);
            if all || record.Processor.EfficiencyClass == largest_class {
                if physical result += 1;
                else {
                    groups := record.Processor.GroupCount;
                    if 32 + cast(u32) groups * size_of(Windows.GROUP_AFFINITY) > record.Size return 0;
                    masks := cast(*Windows.GROUP_AFFINITY) (buffer + offset + 32);
                    for i: 0..groups - 1 {
                        bits := masks[i].Mask;
                        while bits != 0 {
                            result += 1;
                            bits &= bits - 1;
                        }
                    }
                }
            }
            offset += record.Size;
        }
        return result;
    }
} else #if OS == .MACOS || OS == .IOS {
    system_processor_count :: (query: Processor_Query_Type) -> s64 {
        name := "hw.logicalcpu";
        fallback := name;
        if query == .ALL_PHYSICAL || query == .PERFORMANCE_PHYSICAL {
            name = "hw.physicalcpu";
            fallback = name;
        }
        if query == .PERFORMANCE_PHYSICAL name = "hw.perflevel0.physicalcpu";
        if query == .PERFORMANCE_LOGICAL name = "hw.perflevel0.logicalcpu";
        value: s32;
        bytes: u64 = size_of(s32);
        if P.sysctlbyname(temp_c_string(name), *value, *bytes, null, 0) != 0 {
            bytes = size_of(s32);
            if P.sysctlbyname(temp_c_string(fallback), *value, *bytes, null, 0) != 0 return 0;
        }
        if bytes != size_of(s32) || value < 0 return 0;
        return value;
    }
} else {
    system_processor_count :: (query: Processor_Query_Type) -> s64 {
        logical := max(P.sysconf(._SC_NPROCESSORS_ONLN), 0);
        if query == .ALL_LOGICAL || query == .PERFORMANCE_LOGICAL return logical;
        // Without a readable CPU topology (no /sys in a container or sandbox), count each
        // logical processor as a core rather than report none.
        directory := P.opendir(temp_c_string("/sys/devices/system/cpu"));
        if !directory return logical;
        defer P.closedir(directory);
        cores: [..] string;
        cores.allocator = temp;
        while true {
            entry := P.readdir(directory);
            if !entry break;
            name := to_string(entry.d_name.data);
            if name.count < 4 || String.slice(name, 0, 3) != "cpu" continue;
            valid := true;
            for i: 3..name.count - 1 if name[i] < #char "0" || name[i] > #char "9" valid = false;
            if !valid continue;
            base := String.join("/sys/devices/system/cpu/", name);
            online := topology_text(String.join(base, "/online"));
            if online == "0" continue;
            siblings := topology_text(String.join(base, "/topology/thread_siblings_list"));
            if !siblings continue;
            duplicate := false;
            for core: cores if core == siblings {
                duplicate = true;
                break;
            }
            if !duplicate array_add(*cores, siblings);
        }
        if cores.count == 0 return logical;
        return cores.count;
    }

    topology_text :: (path: string) -> string {
        descriptor := P.open(temp_c_string(path), P.O_RDONLY);
        if descriptor < 0 return "";
        defer P.close(descriptor);
        bytes: [1024] u8;
        count := P.read(descriptor, bytes.data, bytes.count);
        if count <= 0 || count == bytes.count return "";
        return copy_temporary_string(String.trim(string.{ count, bytes.data }));
    }
}
