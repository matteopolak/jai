# Native TCP field accessors

Thirty-six previously missing macOS Socket accessors now execute native bitfield
extraction/mutation using the reviewed canonical tcphdr/tcp_connection_info
records. Apple SDK netinet/tcp.h supplies C ABI positions; no Jai body is an input.
Implementation: internal/net/socket-fields-macos.jai; exact public aliases:
Socket/fields.jai. Parameter names/types and canonical aggregate metadata remain.

| Public families | Native behavior |
| --- | --- |
| get/set_th_off and get/set_th_x2 | Four-bit header values, preserving the other nibble and neighboring bytes |
| get/set_tcpi_tfo_cookie_req/rcv/req_rcv/sent/invalid/wrong | Native independent cookie flag bits |
| get/set_tcpi_tfo_syn_loss/data_sent/data_acked/data_rcv | Native independent SYN flag bits |
| get/set_tcpi_tfo_no_cookie_rcv/heuristics_disable/send_blackhole/recv_blackhole/onebyte_proxy | Native diagnostic flag bits |
| get/set___pad2 | Seventeen-bit field, preserving fifteen low flags |

Unsigned values truncate to native bitfield width. Bool setters set/clear only
their bit. No allocation, syscall or hidden registry is introduced; getters take
records by value and setters require a live record pointer. No untested big-endian
support is claimed. The generator verifies all public names against reviewed
declarations, preserves explicit ABI offsets and independently groups related
queries/mutations alphabetically. Native layouts remain untouched; normalized
generation is byte-stable and passes source-built jaifmt --check.

check_portable_socket_fields.py builds independent C including the official SDK
header, assigns its actual bitfields, and writes256 whole-record pairs. Public
Jai accessors check neighboring-bit preservation and compare every record byte
against the C results. Large inputs test four-/seventeen-bit truncation; counts,
sizes, read success and full output remain asserted. Source-built C host/x64
outputs match exactly. Interpreter and actual host/x64 native O0/O2 pass; x64
executes under macOS translation on this ARM64 host. C builds deny warnings;
active strict Jai lint passes implementation/fixture roots. No fake native backend
or reused library oracle is used.

The missing-export red run remains at target/socket-fields-red.log. Initial
fixture relative path incorrectly assumed the process working directory; the
interpreter roots relative paths at the source directory. #file anchoring repairs
only test generation. Failure remains at target/socket-fields-green.log; no file
loader or assertion was weakened. Passing evidence:
target/socket-fields-both-cpus.log and target/socket-fields-final-lint.log.

The initial36 macOS accessor batch is followed by the platform batches below.
CMSG helpers and unresolved shapes remain named in portable-windows-socket.md/socket-native-ledger.json. Whole strict lint,
native Windows execution and active Windows lint remain separate failed/pending
gates. No full Socket/native surface completeness claim.

Windows SCOPE_ID adds four implemented accessors; verification limits are in portable-windows-socket.md.

Twenty-six Linux TCP/tcp_info accessors now implement the reviewed canonical
record signatures. ABI positions come from official native glibc netinet/tcp.h:
https://raw.githubusercontent.com/bminor/glibc/master/sysdeps/gnu/netinet/tcp.h .
Only the baseline reviewed tcp_info record is used, without claiming the current
larger native version is identical. tcphdr low/high nibbles, six single-bit flags,
reserved fields and tcp_info scales preserve all neighboring bits. No C source
implementation is copied. Explicit little-endian x64/ARM64 scope is enforced.
tools/generate_socket_linux_fields.py groups declarations independently by field
and validates export names against the reviewed inventory. Repeated generation
is normalized by source-built jaifmt.

tools/check_portable_linux_socket_fields.py executes actual public accessors
inside #run for both Linux CPUs, checking256 original word patterns and all256
input byte values for unsigned setters, plus bool set/clear and overlay-sized
record checks. This is host interpreter execution of cross-target pure records,
not native Linux execution or SDK C ABI validation. Both remain pending CI;
--native refuses a non-Linux host. Android's22 matching TCP APIs now share these real bodies, as described below.

Initial missing-export failure: target/socket-linux-fields-red.log. Initial
fixture used an overflowing checked narrowing cast; the corrected test masks the
low byte explicitly and retains every assertion. Another fixture omitted Basic
for runtime assert; adding its import fixes only test setup. Those failure logs
remain target/socket-linux-fields-green.log and green2.log. Passing cross-target
evidence: target/socket-linux-fields-final.log. Whole strict lint still fails;
host lint cannot activate Linux-only implementation without target selection.


Android TCP source batch: official bionic bits/tcphdr.h confirms identical
little-endian twenty-byte overlay and bit positions. Shared code now lives in
internal/net/socket-fields-tcp-unix.jai; Socket/tcp-unix-fields.jai exports22
TCP accessors on Linux/Android and four tcp_info scale accessors only on Linux.
No Android scale export is invented. Superseded Linux-only files are removed.
Generator checks each per-OS export against parsed reviewed declarations, rather
than accepting names merely because they occur on another platform.

Official native C header input:
https://raw.githubusercontent.com/aosp-mirror/platform_bionic/master/libc/include/bits/tcphdr.h
SHA256 a0eff7a70a268072c0cd12c14a92ba38f8a40925cca86bc9cb90cacaad910d1f.
Downloaded intact, including its native license, only to target/bionic-tcphdr.h.
No external implementation bodies enter our library. Initial web-cache fetch
failed; ordinary public-header HTTPS retrieval succeeded within the existing OS
sandbox, with no permissions override or access to forbidden inputs.

tools/check_portable_bionic_tcp_header.py --header target/bionic-tcphdr.h builds
the actual supplied public C header and exercises65536 whole-word layout cases
with neighboring-byte preservation. Host ARM64 and translated x64 probes pass.
This is native host C layout evidence, not native Android execution. The same
independent header-check helper is used by the prepared actual Linux SDK probe;
Linux tcp_info-prefix checks remain separate. First manual probe used one excess
parent directory in its include path; the runner now supplies the exact resolved
header path directly, without assertion changes.

Actual public shared Jai bodies still execute under Linux x64/ARM64 #run checks.
Android compiler checking remains BLOCKED: current source-built CLI rejects
-os android and lists linux/windows/macos/wasm. Evidence:
target/socket-android-target-unavailable.log. No OS constant override, disguised
Linux pass, fake Android SDK/system calls or completed Android test claim.
Passing host C/header and Linux shared-body evidence:
target/socket-bionic-header-verified.log and target/socket-tcp-unix-final.log.

Complete reviewed accessor source inventory: macOS36, Windows4, Linux26, Android22
conditional variants. Android body checking/native, Linux native, Windows native
and active target-aware lint remain pending. Remaining missing Socket algorithms
are CMSG_SIZE (four other helpers now implemented in portable-socket-cmsg.md), plus named unresolved
native shapes and Unix reflected fd_set element-type compiler gap.
