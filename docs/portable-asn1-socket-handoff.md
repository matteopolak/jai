# ASN.1 and Socket closure handoff

The owner now works in the shared clean tree. Integration reconciled the named
producer checkpoint through 67c9dc52; ten key owned paths were confirmed
byte-identical before owner edits. Integration also installed the single ASN.1
extension load in the shared Android facade. This owner never applied commits
or changed the shared index. Global inventory, Extensions and prelude are outside
this owner's edits.

Fresh shared verification uses the current compiler and production stdlib,
without archives, overlays or facade rewriting. Evidence is under assigned T7
`shared-target/asn1-socket-gvcqn9rw`: 100/100 host gates, including 54 actual
interpreter/native Mac ARM64 O0/O2 executions; 34/34 supported-platform source
and lint gates; one blocked Android gate. All 1,277 recorded compiler/library/
formatter source hashes were unchanged across verification. The receipt records
shared HEAD 71c54d8e584789d5513b4786b5b4f8279b2da019 and actual working-file hashes.

## Exact integration

Integration has replaced these six direct loads in Android/Toolchain/module.jai:

```jai
#load "../../internal/android-toolchain/asn1-identity.jai";
#load "../../internal/android-toolchain/asn1-tags.jai";
#load "../../internal/android-toolchain/asn1-values.jai";
#load "../../internal/android-toolchain/asn1-records.jai";
#load "../../internal/android-toolchain/asn1-diagnostics.jai";
#load "../../internal/android-toolchain/byte-readers.jai";
```

with this line before X.509:

```jai
#load "asn1-extension.jai";
```

The extension loads those canonical files plus new asn1-hex.jai. Retain the
existing format-helpers.jai load exactly once: both hex overloads reuse its
fh2/fh aliases and Basic's formatter/builder allocation. Canonical alias
dependency origin: clean commit 39e1e3e6d92f54b7d3549001dfc04f9b47d60102. Both
overloads use the current shared canonical definitions. No duplicate formatter,
tag, OID, value, parser, provider or context is introduced.

The string hex overload formats input-order bytes using two lowercase digits.
The eight-element overload formats numeric values in array order with at least
twice the integer type width in digits. Results are separate caller-owned strings.
Existing records/readers/printer retain promoted tags, borrowed payload/TLV
views, complete-value cursor consumption, expected class/number ignoring form,
iterative nesting, four-space/skip indentation and little-endian u32 prefixes.

## Socket changes

CMSG_SIZE implements reviewed native space: size_of(cmsghdr)+CMSG_ALIGN(payload).
Unsupported negative/unrepresentable extents diagnose as independent safety
policy; no compatible recovery result is claimed. Five CMSG procedures are
compared against 4,097 fresh actual host SDK vectors and valid u32 boundaries.

Android SHUT/aliases, sockaddr, linger, in_addr, ip_mreqn and in_pktinfo now live
in the canonical socket-native-completions ABI load and are reexported by Socket.
Existing SDK layouts are intact. Android linger uses two signed 32-bit fields,
confirmed by reviewed inbox and permitted public bionic sys/socket.h.

Unix select's unchanged TIMEVAL spelling resolves through a private alias to
canonical POSIX.timeval, without another layout or public alias. A separate
minimal real select test reproduces the missing alias and verifies the correction.

Reviewed Unix FD_SET/FD_CLR now ignore descriptors at or above capacity before
the remaining assertion, matching FD_ISSET's zero membership there. Valid-bit
mutation stays intact. Negative descriptors/null sets remain outside the public
domain; no new no-op guarantee was introduced. Windows helpers already honor
opaque SOCKET values, duplicate/full SET and absent CLR; their pure behavior is
checked under both Windows CPU targets without native Winsock calls. There is
no public FD_ZERO: tests zero-initialize the record.

## Reproduction

Run python3 -B tools/check_asn1_socket_closure.py with this worker's assigned
CARGO_TARGET_DIR and the installed LLVM development prefix configured. It
checks clean compiler checkpoint ancestry, source-builds compiler/linter in a
fresh T7 directory and uses the current shared stdlib directly. Existing vector
assertions are retained; only their fixture data paths are relocated. Receipts
record source hashes, commands, stdout/stderr and exit status.

The suite covers actual Jai interpreter/native host Mac O0/O2, 517 independent
INTEGER / 183 OID vectors, borrowed-view mutation and framing, malformed inputs,
printer overloads / 300 nested frames, hex widths/order/independent allocations,
real loopback/select, SDK CMSG vectors, negative extent/overflow faults, full
active Mac Socket/scoped ASN.1 strict lint and source-built formatter checks.

Run --targets-only <verification-directory> for source checking and full active
Socket lint on macOS/Linux/Windows x64/ARM64. Any changed recorded source rejects
continuation of that build. Other native platforms remain
separate gates; Android is never disguised as Linux.
The target continuation exits 2 when the Android CLI gate is blocked, even if
all supported-platform checks pass. Unexpected Android errors remain failures.
If actual Android target selection becomes available, record checks and active
Android lint must also pass; an empty-program success alone is not completion.

Run python3 -B tools/check_android_socket_header_shapes.py to check permitted
public bionic headers with Clang's Android aarch64/x86_64 targets. Shape/offset/
signedness/CMSG_SPACE static assertions pass on both. Each CPU gets a separate
header closure with URL/hash receipts. This is C cross-target ABI evidence,
not Android execution or Jai checking.

## Precise remaining gates

The current source-built shared compiler rejects -os android, even for the empty program in
tests/cleanroom-language/android-target-minimal.jai. Android Jai record checking
and active lint await a named compiler handoff; native Android needs a device.

The legacy negative/null descriptor expectations were outside the now-reviewed
domain and were removed from the active fixture. Required capacity and higher
descriptor checks remain and are strengthened by the new descriptor-domain
fixture (all valid bits, alternating clears, nonempty preservation, s32 maximum
and sentinel storage). Its independent pre-fix FD_SET(capacity) failure proves
the production defect separately from the invalid legacy premise.

The fixture also assumed CMSG_FIRSTHDR(null) would succeed and that negative
keepalive timing must fail without a state change. Neither is a reviewed helper
requirement; the keepalive rollback premise directly conflicts with the reviewed
partial-configuration warning. These unsupported invocations are documented,
with original failures preserved. Valid CMSG record cases, positive keepalive /
disabled-state checks and actual transport assertions remain. Production CMSG
and keepalive behavior was not modified for those premises. See the
[unsupported-test record](specs/stdlib/unsupported-socket-descriptor-tests.md).

The earlier undeclared ipv4_bits call was separately corrected to inspect the
public IPv4 field while retaining the same network-order assertion. Shared
facade integration stays with the portable owner; both hex overloads must be
adopted from this producer rather than duplicated; the shared facade now does so.

The filtered full-corpus report identifies `cluster-build` failing with unknown
`CMSG_SIZE` in three modes. The shared export now passes independent public
layout/SDK fixtures in interpreter and native O0/O2. Root must replay the opaque
case to close that corpus failure; this owner has not read its source or logs.
Latest reviewed Socket descriptor/CMSG/Android and hex prose synchronization was
requested through the append-only inbox; shared module docs still lack those
newer paragraphs. No undocumented behavior was invented to satisfy old tests.

## Historical producer evidence (before shared transition)

The final source snapshot is recorded under assigned T7 output
`asn1-socket-7kk0_dkg`: all 100 recorded host gates pass, including 54 actual
interpreter/native Mac ARM64 O0/O2 checks. The comprehensive loopback fixture
now passes all three modes, exercising partial/peeked reads, 300 KiB echo,
nonblocking readiness, closed/refused peers, UDP, available IPv6 and descriptor
passing. Descriptor-domain checks are included in the runtime suite.

The same source-identical snapshot passes 34 supported-platform source/lint
gates. Its target receipt records the actual Android CLI rejection as blocked;
no Android Jai source or native completion credit is assigned. Native Windows /
Linux/device and translated Mac x64 execution remain unverified.

Socket lint manifests report complete actual OS/CPU contexts with no unvisited
owned active roots. Strict fixture/production lint and source-built formatting
pass. Earlier failure directories remain intact, including the independent
supported FD_SET(capacity) red case and the archived unsupported legacy cases.
The scoped inventory lists all 24 ASN.1 declarations separately and keeps the
six Android transfer rows partial.

See [scoped status](status/asn1-socket-remaining.json) and
[inbox](worker-inbox.md) for current verified/partial distinctions, remaining
contract synchronization requests and evidence paths.
