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

Only those36 accessor APIs are completed here. Linux/Android TCP/tcp_info and
CMSG helpers and unresolved shapes remain
named in portable-windows-socket.md/socket-native-ledger.json. Whole strict lint,
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
--native refuses a non-Linux host. Android's matching named APIs remain missing
pending official bionic ABI verification and compiler target availability.

Initial missing-export failure: target/socket-linux-fields-red.log. Initial
fixture used an overflowing checked narrowing cast; the corrected test masks the
low byte explicitly and retains every assertion. Another fixture omitted Basic
for runtime assert; adding its import fixes only test setup. Those failure logs
remain target/socket-linux-fields-green.log and green2.log. Passing cross-target
evidence: target/socket-linux-fields-final.log. Whole strict lint still fails;
host lint cannot activate Linux-only implementation without target selection.
