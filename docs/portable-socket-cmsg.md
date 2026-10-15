# Socket ancillary message helpers

Four reviewed procedures now execute real native control-buffer arithmetic.
Socket/cmsg.jai reexports exact procedures from internal/net/socket-cmsg.jai;
canonical msghdr/cmsghdr types remain the same ABI entities.

| Public API | Supported behavior |
| --- | --- |
| CMSG_FIRSTHDR(mhdr:*msghdr) -> *cmsghdr | Null if msg_controllen is shorter than a native header; otherwise returns caller's msg_control, including null |
| CMSG_DATA(cmsg:*cmsghdr) -> *u8 | Payload pointer immediately beyond the aligned native header |
| CMSG_ALIGN(size:int) -> int | macOS four-byte alignment; current Linux/Android64-bit native long/size_t eight-byte alignment |
| CMSG_LEN(size:int) -> u32 | Aligned header plus unrounded payload length, within representable u32 range |
| CMSG_SIZE(size:int) -> u32 | MISSING: reviewed declaration does not establish SPACE/LEN/other relationship |

Callers supply valid live native records/control storage. No allocation, syscall,
hidden copy or fabricated native return occurs in these helpers. Negative extents
and alignment/length overflow diagnose as independent byte-extent safety policy;
no reviewed wrapping result is claimed for unrepresentable inputs. CMSG_LEN tests
the exact maximum u32 result; CMSG_ALIGN tests the maximum representable aligned
signed integer. Null pointer arithmetic outside a live cmsg is not supported.
These boundaries remain a fine oracle question, not evidence that the reference
uses the same diagnostics.

ABI inputs are native public C macros only: actual Apple SDK sys/socket.h,
official Linux glibc sysdeps/unix/sysv/linux/bits/socket.h and official bionic
libc/include/sys/socket.h. The generic glibc bits/socket.h is a BSD fallback,
not the Linux target header; Linux ABI decisions use the correct target header.
No Jai bodies or external helper algorithms are inputs.
- https://raw.githubusercontent.com/bminor/glibc/master/sysdeps/unix/sysv/linux/bits/socket.h
- https://raw.githubusercontent.com/aosp-mirror/platform_bionic/master/libc/include/sys/socket.h

tools/check_portable_socket_cmsg.py source-builds an independent C program against
the actual host SDK. It produces4097 vectors of payload alignment (native
CMSG_SPACE difference), CMSG_LEN, FIRSTHDR threshold/identity and DATA offset.
Actual public Jai procedures match those vectors in interpreter and native O0/O2,
including translated x64 on this ARM64 macOS host. Linux/macOS bothCPU #run
assertions execute actual pure procedures, without native Linux kernel calls.
Native Linux/Android execution remains pending; Android CLI target is unavailable.
The tool can execute actual Linux SDK/native vectors on a future Linux CI host.

socket-cmsg-layout.jai adds ordinary runtime layout/extreme-boundary/visibility
coverage to the required portable suite. Two new checked-fault fixtures retain
negative-extent and u32-overflow diagnostics; no assertion is skipped or folded
into an optional fixture. Active private facade/implementation and all positive
fixtures pass source-built strict jailint. Full owned strict lint remains a
separate failed gate, with compiler/configuration/intentional-negative categories.

Missing-export failure is retained at target/socket-cmsg-red.log. Initial test
compared signed/public sizes directly with unsigned64 wire vectors; explicit
native-boundary conversions repair that test's type mismatch without changing
production signatures or dropping assertions (target/socket-cmsg-green.log).
Passing SDK/execution evidence: target/socket-cmsg-verified.log.
Passing focused strict lint: target/socket-cmsg-focused-strict.log.
