#import "Basic";
#if OS == .WINDOWS {
    #import "Windows";
    #load "generated_windows.jai";
    Socket :: SOCKET;
    WINSOCK_VERSION: u16 : 0x0202;
    SOCKET_WOULDBLOCK :: WSAEWOULDBLOCK;
    SIO_KEEPALIVE_VALS :: 0x98000004;
} else {
    #import "POSIX";
    Socket :: s32;
    INVALID_SOCKET: Socket : -1;
    SOCKET_ERROR :: -1;
    SOCKET_WOULDBLOCK :: EWOULDBLOCK;
    #if OS == .MACOS || OS == .IOS #load "generated_macos.jai";
    else #if OS == .ANDROID #load "generated_android.jai";
    else #load "generated_linux.jai";
}

socket_init :: () -> bool {
    #if OS == .WINDOWS {
        data: WSAData;
        return WSAStartup(WINSOCK_VERSION, *data) == 0;
    } else return true;
}
get_last_socket_error :: () -> OS_Error_Code {
    #if OS == .WINDOWS return WSAGetLastError();
    else return errno();
}
set_blocking :: (s: Socket, blocking: bool) -> bool {
    #if OS == .WINDOWS {
        mode: u32 = 1;
        if blocking mode = 0;
        return ioctlsocket(s, FIONBIO, *mode) == 0;
    } else {
        flags := fcntl(s, F_GETFL);
        if flags < 0 return false;
        if blocking flags &= ~O_NONBLOCK;
        else flags |= O_NONBLOCK;
        return fcntl(s, F_SETFL, flags) == 0;
    }
}
set_keepalive :: (s: Socket, keepalive: bool, idle_seconds_before_keepalive: s32 = 0,
    keepalive_interval_seconds: s32 = 0, num_keepalive_attempts: s32 = 0) -> bool {
    if idle_seconds_before_keepalive < 0 || keepalive_interval_seconds < 0 || num_keepalive_attempts < 0 return false;
    enabled: s32 = 0;
    if keepalive enabled = 1;
    if setsockopt(s, SOL_SOCKET, SO_KEEPALIVE, cast(*u8) *enabled, 4) != 0 return false;
    if !keepalive return true;
    #if OS == .WINDOWS {
        if idle_seconds_before_keepalive != 0 {
            if setsockopt(s, cast(s32) IPPROTO.TCP, TCP_KEEPIDLE, cast(*u8) *idle_seconds_before_keepalive, 4) != 0 return false;
        }
        if keepalive_interval_seconds != 0 {
            if setsockopt(s, cast(s32) IPPROTO.TCP, TCP_KEEPINTVL, cast(*u8) *keepalive_interval_seconds, 4) != 0 return false;
        }
    } else {
        #if OS == .MACOS || OS == .IOS idle_option :: TCP_KEEPALIVE;
        else idle_option :: 4;
        if idle_seconds_before_keepalive != 0 {
            if setsockopt(s, cast(s32) IPPROTO.TCP, idle_option, *idle_seconds_before_keepalive, 4) != 0 return false;
        }
        if keepalive_interval_seconds != 0 {
            #if OS == .MACOS || OS == .IOS interval_option :: 0x101;
            else interval_option :: 5;
            if setsockopt(s, cast(s32) IPPROTO.TCP, interval_option, *keepalive_interval_seconds, 4) != 0 return false;
        }
    }
    if num_keepalive_attempts != 0 {
        #if OS == .MACOS || OS == .IOS count_option :: 0x102;
        else #if OS == .WINDOWS count_option :: 16;
        else count_option :: 6;
        if setsockopt(s, cast(s32) IPPROTO.TCP, count_option, cast(*u8) *num_keepalive_attempts, 4) != 0 return false;
    }
    return true;
}

to_string :: (addr: sockaddr_in) -> string {
    builder: String_Builder;
    append_address(*builder, addr.sin_addr.s_addr);
    append(*builder, ":"); append_decimal(*builder, ntohs(addr.sin_port));
    return builder_to_string(*builder);
}
to_string :: (addr: sockaddr_in6) -> string {
    bytes: [16] u8;
    memcpy(*bytes, *addr.sin6_addr, 16);
    builder: String_Builder;
    append(*builder, "["); append_address(*builder, bytes);
    append(*builder, "]:"); append_decimal(*builder, ntohs(addr.sin6_port));
    return builder_to_string(*builder);
}
append_address :: (builder: *String_Builder, address: u32) {
    bytes: [4] u8;
    memcpy(*bytes, *address, 4);
    for byte, i: bytes {
        if i != 0 append(builder, ".");
        append_decimal(builder, byte);
    }
}
append_address :: (builder: *String_Builder, address: [16] u8) {
    words: [8] u16;
    for i: 0..7 words[i] = (cast(u16) address[i*2]) << 8 | cast(u16) address[i*2+1];
    longest_start: s64 = -1; longest_count: s64 = 1;
    i: s64 = 0;
    while i < 8 {
        if words[i] != 0 { i += 1; continue; }
        begin := i;
        while i < 8 && words[i] == 0 i += 1;
        if i - begin > longest_count { longest_start = begin; longest_count = i - begin; }
    }
    i = 0;
    while i < 8 {
        if i == longest_start {
            append(builder, "::"); i += longest_count;
        } else {
            if i != 0 && i != longest_start + longest_count append(builder, ":");
            append_hex(builder, words[i]); i += 1;
        }
    }
}
accept :: (s: Socket) -> Socket, sockaddr_in {
    address: sockaddr_in;
    length := cast(type_of_socket_length) size_of(sockaddr_in);
    accepted := accept(s, cast(*sockaddr) *address, *length);
    return accepted, address;
}
accept_v6 :: (s: Socket) -> Socket, sockaddr_in6 {
    address: sockaddr_in6;
    length := cast(type_of_socket_length) size_of(sockaddr_in6);
    accepted := accept(s, cast(*sockaddr) *address, *length);
    return accepted, address;
}
bind :: (s: Socket, address: string, port: u16, family: type_of(sockaddr_in.sin_family) = AF_INET) -> s32 {
    terminated := to_c_string(address);
    if terminated == null return -1;
    defer free(terminated);
    if family == AF_INET {
        endpoint: sockaddr_in;
        endpoint.sin_family = family;
        endpoint.sin_port = htons(port);
        #if OS == .MACOS || OS == .IOS endpoint.sin_len = cast(u8) size_of(sockaddr_in);
        if inet_pton(AF_INET, terminated, *endpoint.sin_addr) != 1 return -1;
        return bind(s, cast(*sockaddr) *endpoint, size_of(sockaddr_in));
    }
    if family == AF_INET6 {
        endpoint: sockaddr_in6;
        endpoint.sin6_family = family;
        endpoint.sin6_port = htons(port);
        #if OS == .MACOS || OS == .IOS endpoint.sin6_len = cast(u8) size_of(sockaddr_in6);
        if inet_pton(AF_INET6, terminated, *endpoint.sin6_addr) != 1 return -1;
        return bind(s, cast(*sockaddr) *endpoint, size_of(sockaddr_in6));
    }
    return -1;
}
bind :: (s: Socket, address: u32, port: u16) -> s32 {
    endpoint: sockaddr_in;
    endpoint.sin_family = AF_INET; endpoint.sin_port = htons(port);
    endpoint.sin_addr.s_addr = address;
    #if OS == .MACOS || OS == .IOS endpoint.sin_len = cast(u8) size_of(sockaddr_in);
    return bind(s, cast(*sockaddr) *endpoint, size_of(sockaddr_in));
}
bind :: (s: Socket, address: [16] u8, port: u16) -> s32 {
    endpoint: sockaddr_in6;
    endpoint.sin6_family = AF_INET6; endpoint.sin6_port = htons(port);
    memcpy(*endpoint.sin6_addr, *address, 16);
    #if OS == .MACOS || OS == .IOS endpoint.sin6_len = cast(u8) size_of(sockaddr_in6);
    return bind(s, cast(*sockaddr) *endpoint, size_of(sockaddr_in6));
}
close_and_reset :: (s: *Socket, loc := #caller_location) {
    if s.* == INVALID_SOCKET return;
    #if OS == .WINDOWS result := closesocket(s.*);
    else result := close(s.*);
    assert(result == 0, "socket close failed", loc = loc);
    s.* = INVALID_SOCKET;
}

#if OS == .WINDOWS {
    FIONBIO :: cast(s32) 0x8004667e;
    IOW :: (x: u8, y: u8, $T: Type) -> s32 {
        return cast(s32) (0x80000000 | ((size_of(T) & 0x7f) << 16) | ((cast(u32) x) << 8) | y);
    }
    FD_ISSET :: __WSAFDIsSet;
    FD_SET :: (fd: Socket, set: *fd_set) {
        if FD_ISSET(fd, set) != 0 return;
        if set.fd_count >= set.fd_array.count return;
        set.fd_array[set.fd_count] = fd; set.fd_count += 1;
    }
    FD_CLR :: (fd: Socket, set: *fd_set) {
        for i: 0..cast(s64) set.fd_count-1 {
            if set.fd_array[i] != fd continue;
            set.fd_count -= 1; set.fd_array[i] = set.fd_array[set.fd_count]; return;
        }
    }
} else {
    FD_BITS_ELEMENT_TYPE :: fd_mask;
    BITS_PER_FD_SET_MASK :: size_of(FD_BITS_ELEMENT_TYPE) * 8;
    check_fd_set :: (fd: s32, set: *fd_set) -> bool {
        return set != null && fd >= 0 && fd < size_of(fd_set) * 8;
    }
    FD_ISSET :: (fd: s32, set: *fd_set) -> s32 {
        if !check_fd_set(fd, set) return 0;
        mask := cast(FD_BITS_ELEMENT_TYPE) ((cast(u64) 1) << (fd % BITS_PER_FD_SET_MASK));
        if (set.fds_bits[fd / BITS_PER_FD_SET_MASK] & mask) != 0 return 1;
        return 0;
    }
    FD_SET :: (fd: s32, set: *fd_set) {
        if !check_fd_set(fd, set) return;
        set.fds_bits[fd / BITS_PER_FD_SET_MASK] |= cast(FD_BITS_ELEMENT_TYPE) ((cast(u64) 1) << (fd % BITS_PER_FD_SET_MASK));
    }
    FD_CLR :: (fd: s32, set: *fd_set) {
        if !check_fd_set(fd, set) return;
        set.fds_bits[fd / BITS_PER_FD_SET_MASK] &= ~cast(FD_BITS_ELEMENT_TYPE) ((cast(u64) 1) << (fd % BITS_PER_FD_SET_MASK));
    }
    CMSG_FIRSTHDR :: (mhdr: *msghdr) -> *cmsghdr {
        if mhdr == null || mhdr.msg_control == null || mhdr.msg_controllen < size_of(cmsghdr) return null;
        return cast(*cmsghdr) mhdr.msg_control;
    }
    CMSG_ALIGN :: (size: int) -> int {
        alignment := size_of(type_of(cmsghdr.cmsg_len));
        return ((size + alignment - 1) / alignment) * alignment;
    }
    CMSG_SIZE :: (size: int) -> u32 { return cast(u32) (CMSG_ALIGN(size_of(cmsghdr)) + CMSG_ALIGN(size)); }
    CMSG_LEN :: (size: int) -> u32 { return cast(u32) (CMSG_ALIGN(size_of(cmsghdr)) + size); }
    CMSG_DATA :: (cmsg: *cmsghdr) -> *u8 { return cast(*u8) cmsg + CMSG_ALIGN(size_of(cmsghdr)); }
}

#if OS == .MACOS || OS == .IOS {
    htons :: (hostshort: u16) -> u16 {
        bytes: [2] u8 = .[cast(u8) (hostshort >> 8), cast(u8) hostshort];
        result: u16; memcpy(*result, *bytes, 2); return result;
    }
    htonl :: (hostlong: u32) -> u32 {
        bytes: [4] u8 = .[cast(u8) (hostlong >> 24),cast(u8) (hostlong >> 16),cast(u8) (hostlong >> 8),cast(u8) hostlong];
        result: u32; memcpy(*result, *bytes, 4); return result;
    }
    ntohs :: (netshort: u16) -> u16 {
        bytes: [2] u8; memcpy(*bytes, *netshort, 2);
        return (cast(u16) bytes[0]) << 8 | bytes[1];
    }
    ntohl :: (netlong: u32) -> u32 {
        bytes: [4] u8; memcpy(*bytes, *netlong, 4);
        return (cast(u32) bytes[0]) << 24 | (cast(u32) bytes[1]) << 16 | (cast(u32) bytes[2]) << 8 | bytes[3];
    }
}

// Winsock's WSA* errno values; each is its POSIX-style number offset by WSABASEERR.
#if OS == .WINDOWS {
    WSABASEERR :: 10000;
    WSAEINTR :: (WSABASEERR+4);
    WSAEBADF :: (WSABASEERR+9);
    WSAEACCES :: (WSABASEERR+13);
    WSAEFAULT :: (WSABASEERR+14);
    WSAEINVAL :: (WSABASEERR+22);
    WSAEMFILE :: (WSABASEERR+24);
    WSAEWOULDBLOCK :: (WSABASEERR+35);
    WSAEINPROGRESS :: (WSABASEERR+36);
    WSAEALREADY :: (WSABASEERR+37);
    WSAENOTSOCK :: (WSABASEERR+38);
    WSAEDESTADDRREQ :: (WSABASEERR+39);
    WSAEMSGSIZE :: (WSABASEERR+40);
    WSAEPROTOTYPE :: (WSABASEERR+41);
    WSAENOPROTOOPT :: (WSABASEERR+42);
    WSAEPROTONOSUPPORT :: (WSABASEERR+43);
    WSAESOCKTNOSUPPORT :: (WSABASEERR+44);
    WSAEOPNOTSUPP :: (WSABASEERR+45);
    WSAEPFNOSUPPORT :: (WSABASEERR+46);
    WSAEAFNOSUPPORT :: (WSABASEERR+47);
    WSAEADDRINUSE :: (WSABASEERR+48);
    WSAEADDRNOTAVAIL :: (WSABASEERR+49);
    WSAENETDOWN :: (WSABASEERR+50);
    WSAENETUNREACH :: (WSABASEERR+51);
    WSAENETRESET :: (WSABASEERR+52);
    WSAECONNABORTED :: (WSABASEERR+53);
    WSAECONNRESET :: (WSABASEERR+54);
    WSAENOBUFS :: (WSABASEERR+55);
    WSAEISCONN :: (WSABASEERR+56);
    WSAENOTCONN :: (WSABASEERR+57);
    WSAESHUTDOWN :: (WSABASEERR+58);
    WSAETOOMANYREFS :: (WSABASEERR+59);
    WSAETIMEDOUT :: (WSABASEERR+60);
    WSAECONNREFUSED :: (WSABASEERR+61);
    WSAELOOP :: (WSABASEERR+62);
    WSAENAMETOOLONG :: (WSABASEERR+63);
    WSAEHOSTDOWN :: (WSABASEERR+64);
    WSAEHOSTUNREACH :: (WSABASEERR+65);
    WSAENOTEMPTY :: (WSABASEERR+66);
    WSAEPROCLIM :: (WSABASEERR+67);
    WSAEUSERS :: (WSABASEERR+68);
    WSAEDQUOT :: (WSABASEERR+69);
    WSAESTALE :: (WSABASEERR+70);
    WSAEREMOTE :: (WSABASEERR+71);
    WSASYSNOTREADY :: (WSABASEERR+91);
    WSAVERNOTSUPPORTED :: (WSABASEERR+92);
    WSANOTINITIALISED :: (WSABASEERR+93);
    WSAEDISCON :: (WSABASEERR+101);
    WSAENOMORE :: (WSABASEERR+102);
    WSAECANCELLED :: (WSABASEERR+103);
    WSAEINVALIDPROCTABLE :: (WSABASEERR+104);
    WSAEINVALIDPROVIDER :: (WSABASEERR+105);
    WSAEPROVIDERFAILEDINIT :: (WSABASEERR+106);
    WSASYSCALLFAILURE :: (WSABASEERR+107);
    WSASERVICE_NOT_FOUND :: (WSABASEERR+108);
    WSATYPE_NOT_FOUND :: (WSABASEERR+109);
    WSA_E_NO_MORE :: (WSABASEERR+110);
    WSA_E_CANCELLED :: (WSABASEERR+111);
    WSAEREFUSED :: (WSABASEERR+112);
    WSAHOST_NOT_FOUND :: (WSABASEERR+1001);
    WSATRY_AGAIN :: (WSABASEERR+1002);
    WSANO_RECOVERY :: (WSABASEERR+1003);
    WSANO_DATA :: (WSABASEERR+1004);
    WSA_QOS_RECEIVERS :: (WSABASEERR + 1005);
    WSA_QOS_SENDERS :: (WSABASEERR + 1006);
    WSA_QOS_NO_SENDERS :: (WSABASEERR + 1007);
    WSA_QOS_NO_RECEIVERS :: (WSABASEERR + 1008);
    WSA_QOS_REQUEST_CONFIRMED :: (WSABASEERR + 1009);
    WSA_QOS_ADMISSION_FAILURE :: (WSABASEERR + 1010);
    WSA_QOS_POLICY_FAILURE :: (WSABASEERR + 1011);
    WSA_QOS_BAD_STYLE :: (WSABASEERR + 1012);
    WSA_QOS_BAD_OBJECT :: (WSABASEERR + 1013);
    WSA_QOS_TRAFFIC_CTRL_ERROR :: (WSABASEERR + 1014);
    WSA_QOS_GENERIC_ERROR :: (WSABASEERR + 1015);
    WSA_QOS_ESERVICETYPE :: (WSABASEERR + 1016);
    WSA_QOS_EFLOWSPEC :: (WSABASEERR + 1017);
    WSA_QOS_EPROVSPECBUF :: (WSABASEERR + 1018);
    WSA_QOS_EFILTERSTYLE :: (WSABASEERR + 1019);
    WSA_QOS_EFILTERTYPE :: (WSABASEERR + 1020);
    WSA_QOS_EFILTERCOUNT :: (WSABASEERR + 1021);
    WSA_QOS_EOBJLENGTH :: (WSABASEERR + 1022);
    WSA_QOS_EFLOWCOUNT :: (WSABASEERR + 1023);
    WSA_QOS_EUNKOWNPSOBJ :: (WSABASEERR + 1024);
    WSA_QOS_EPOLICYOBJ :: (WSABASEERR + 1025);
    WSA_QOS_EFLOWDESC :: (WSABASEERR + 1026);
    WSA_QOS_EPSFLOWSPEC :: (WSABASEERR + 1027);
    WSA_QOS_EPSFILTERSPEC :: (WSABASEERR + 1028);
    WSA_QOS_ESDMODEOBJ :: (WSABASEERR + 1029);
    WSA_QOS_ESHAPERATEOBJ :: (WSABASEERR + 1030);
    WSA_QOS_RESERVED_PETYPE :: (WSABASEERR + 1031);
}

#scope_file
#if OS == .WINDOWS type_of_socket_length :: s32;
else type_of_socket_length :: socklen_t;
append_decimal :: (builder: *String_Builder, value: u32) {
    digits: [10] u8; count: s64 = 0; remaining := value;
    while true { digits[count] = cast(u8) (48 + remaining % 10); count += 1; remaining /= 10; if remaining == 0 break; }
    while count > 0 { count -= 1; append(builder, digits[count]); }
}
append_hex :: (builder: *String_Builder, value: u16) {
    digits :: "0123456789abcdef";
    shift: s64 = 12;
    while shift > 0 && (value >> shift) == 0 shift -= 4;
    while shift >= 0 { append(builder, digits[(value >> shift) & 15]); shift -= 4; }
}
