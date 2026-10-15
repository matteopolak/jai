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
