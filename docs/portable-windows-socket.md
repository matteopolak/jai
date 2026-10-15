# Windows Socket wrappers

Socket now selects separate native Unix/Windows lifecycle/control files and shares
address formatting, accept and bind logic. Public signatures/defaults remain
reviewed declarations; private algorithms do not become convenience exports.

| Public API | Windows supported implementation |
| --- | --- |
| Socket / INVALID_SOCKET / SOCKET_ERROR / would-block constants | Canonical SOCKET alias and reviewed native values |
| socket_init | Real WSAStartup2.2, actual status logging/failure; each successful call acquires a native Winsock startup reference |
| get_last_socket_error | Real WSAGetLastError, canonical native error type |
| set_blocking | ioctlsocket/FIONBIO and checked error logging |
| set_keepalive | Socket flag plus synchronous WSAIoctl/SIO_KEEPALIVE_VALS; reviewed Windows direct millisecond values and ignored attempt count |
| to_string / append_address | Shared dotted IPv4/eight-group uncompressed IPv6 plus host-order port; no brackets/zone |
| accept / accept_v6; three bind overloads | Actual Winsock calls and canonical target address records/byte order |
| close_and_reset | Actual closesocket, logged failure, pointer reset to native invalid sentinel |
| IOW / FIONBIO | Official Winsock2 ioctl encoding, real parameter widths and size mask |
| FD_SET / FD_CLR | Native descriptor-array insertion/removal semantics including duplicate/full behavior |
| FD_ISSET | Exact alias chain to foreign __WSAFDIsSet, retaining unknown0 parameter and native ABI |

The reviewed FIONBIO declaration had an incomplete character literal. Microsoft's
official Winsock2 header supplies 'f'/126/u_long32, producing0x8004667e. This is a
native ABI constant clarification, not a Jai body input. No arbitrary ioctl code
or fabricated native result is supplied.

Original encoding failed that assertion with0x8004007e: the compiler narrows a
shift applied directly to a widening cast. Explicit word-sized locals produce
correct ordinary operations; the general pending/widened-bitwise.jai reproducer
remains for the compiler owner. The failure is retained in
target/socket-windows-first-check.log and target/socket-iow-exact.log. This is an
explicit source-level accommodation, not a compiler special case. Proper general
cast/shift-width repair remains required before removing that accommodation.

Generation also exposed a real native-binding source error: a wildcard private
Windows import caused a foreign flags MSG to resolve to Windows' GUI structure.
The generator now uses explicit qualified dependencies from reviewed Windows
declarations, excluding local Socket declarations. No public argument was changed
to a raw integer to hide the mismatch. The original error remains in
target/socket-windows-word-check.log. Regeneration of ABI/facade/ledger is stable.

Pure production ioctl/descriptor kernels execute on this host without emulating
Winsock: all65536 command/group pairs, size-mask boundaries,64 descriptor slots,
duplicates, full-set behavior, removal order and64-bit handles pass interpreter/
native, including O2 and strict lint. Native Windows fixture bodies check both
CPUs, with actual startup/loopback/keepalive/foreign FD_ISSET/error-logging paths,
WSADATA408-byte/fd_set520-byte assertions and numeric IPv4/IPv6 formatting.
Native Windows calls and active Windows strict lint remain unexecuted here.
tools/check_portable_windows_socket.py --native requires a real Windows host.

Operational policy limits: successful startup references must be balanced by
caller WSACleanup through the native binding. Negative keepalive timing values
are outside supported nonnegative inputs; current checked unsigned conversion
diagnoses them. Native option failures can leave partial configuration, as reviewed.
close_and_reset logs failure and resets the caller's value; native close failures
may therefore leave an unretained socket, consistent with this existing wrapper
policy but still a resource-risk question for review. No success boolean hides it.

## Remaining concrete public surface

Unix CMSG_FIRSTHDR/CMSG_ALIGN/CMSG_SIZE/CMSG_LEN/CMSG_DATA are still missing;
CMSG_SIZE's intended relationship to native SPACE/LEN needs review. Native bitfield
get/set families (tcphdr, tcp_info, tcp_connection_info and Windows scope/flow
records) are still missing. The exact named inventory is recorded in
docs/socket-native-ledger.json as authored wrapper/pending helper, not completed
declarations. SHUT and several native record variants have unresolved reviewed
shapes; Windows common wrappers above do not establish the whole native surface.
The Unix FD_BITS_ELEMENT_TYPE expression remains a general compiler dependency.
Full native ABI/runtime coverage for every direct native declaration is unfinished.

Official native C sources:
[Winsock2 header](https://raw.githubusercontent.com/microsoft/win32metadata/main/generation/WinSDK/RecompiledIdlHeaders/um/WinSock2.h),
[ioctlsocket](https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-ioctlsocket),
[keepalive control](https://learn.microsoft.com/en-us/windows/win32/winsock/sio-keepalive-vals).
Reviewed specs remain the Jai API oracle; native sources supply ABI facts only.


Exact still-missing bitfield procedures (reviewed native declarations, no bodies):

- get___pad2
- get_anon_struct_1_ack
- get_anon_struct_1_doff
- get_anon_struct_1_fin
- get_anon_struct_1_psh
- get_anon_struct_1_res1
- get_anon_struct_1_res2
- get_anon_struct_1_rst
- get_anon_struct_1_syn
- get_anon_struct_1_urg
- get_anon_struct_Level
- get_anon_struct_Zone
- get_anon_struct_th_off
- get_anon_struct_th_x2
- get_tcpi_rcv_wscale
- get_tcpi_snd_wscale
- get_tcpi_tfo_cookie_invalid
- get_tcpi_tfo_cookie_rcv
- get_tcpi_tfo_cookie_req
- get_tcpi_tfo_cookie_req_rcv
- get_tcpi_tfo_cookie_sent
- get_tcpi_tfo_cookie_wrong
- get_tcpi_tfo_heuristics_disable
- get_tcpi_tfo_no_cookie_rcv
- get_tcpi_tfo_onebyte_proxy
- get_tcpi_tfo_recv_blackhole
- get_tcpi_tfo_send_blackhole
- get_tcpi_tfo_syn_data_acked
- get_tcpi_tfo_syn_data_rcv
- get_tcpi_tfo_syn_data_sent
- get_tcpi_tfo_syn_loss
- get_th_off
- get_th_x2
- set___pad2
- set_anon_struct_1_ack
- set_anon_struct_1_doff
- set_anon_struct_1_fin
- set_anon_struct_1_psh
- set_anon_struct_1_res1
- set_anon_struct_1_res2
- set_anon_struct_1_rst
- set_anon_struct_1_syn
- set_anon_struct_1_urg
- set_anon_struct_Level
- set_anon_struct_Zone
- set_anon_struct_th_off
- set_anon_struct_th_x2
- set_tcpi_rcv_wscale
- set_tcpi_snd_wscale
- set_tcpi_tfo_cookie_invalid
- set_tcpi_tfo_cookie_rcv
- set_tcpi_tfo_cookie_req
- set_tcpi_tfo_cookie_req_rcv
- set_tcpi_tfo_cookie_sent
- set_tcpi_tfo_cookie_wrong
- set_tcpi_tfo_heuristics_disable
- set_tcpi_tfo_no_cookie_rcv
- set_tcpi_tfo_onebyte_proxy
- set_tcpi_tfo_recv_blackhole
- set_tcpi_tfo_send_blackhole
- set_tcpi_tfo_syn_data_acked
- set_tcpi_tfo_syn_data_rcv
- set_tcpi_tfo_syn_data_sent
- set_tcpi_tfo_syn_loss
- set_th_off
- set_th_x2

Unresolved native shape variants:

- SHUT [OS == .ANDROID]
- addrinfo [OS == .MACOS]
- hostent [OS == .MACOS]
- in_addr [OS == .ANDROID]
- in_pktinfo [OS == .ANDROID]
- ip_mreqn [OS == .ANDROID]
- linger [OS == .ANDROID]
- netent [OS == .MACOS]
- protoent [OS == .MACOS]
- servent [OS == .MACOS]
- sockaddr [OS == .ANDROID]
