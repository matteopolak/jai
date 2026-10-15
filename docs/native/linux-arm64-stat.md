# Linux ARM64 stat marshalling

The reviewed Linux surface exposes x64 syscall constants and a 144-byte x64
`stat_t` on both CPUs. ARM64's kernel uses different syscall numbers and a
128-byte record with different prefix field offsets. Passing the public record
with public x64 numbers did not implement stat on ARM64.

The public type, fields, defaults, constants, names and signatures remain exact.
The three named wrappers now use `internal/bindings/linux-arm64-kernel` on
ARM64. Its complete private record and syscall/flag values are generated from
the pinned official Linux UAPI header copies in the complete Bionic source
archive. Clang targets `aarch64-linux-gnu`; every field size/offset and the
record size/alignment are asserted. All transitive native headers are checked
against archive bytes; no host header fallback or invented number is used.
The existing strict LP64 record translator is shared with Android generation.

`stat`/`lstat` use the native fstatat syscall with the current-directory sentinel
and appropriate follow flag. `fstat` uses its native syscall. A successful
private result is explicitly copied into every meaningful public field;
reserved/padding fields retain zero defaults. A failed native call leaves the
public output untouched and preserves native errno. Null output pointers are
passed to the actual kernel call, preserving native error precedence rather
than fabricating an early error. Other invalid raw pointers remain caller errors.

The x64 wrapper route stays unchanged. Direct user calls to `syscall` with the
public x64 numbers on ARM64 retain the reviewed raw-binding limitation; this
adapter fixes the three named convenience wrappers, not all low-level syscall
constants or every Linux aggregate's native compatibility.

The new regression preserves the public size/offset/constants with assertions
and tests real file/FD/symlink status, native errors and failure output behavior.
Both Linux CPUs and both macOS CPUs pass source checks. Both macOS executables
run successfully, including x64 through OS translation. Linux ARM64 runtime is
unavailable on this host and remains required; GNU ARM64 C header checks are
not counted as native Linux execution. Explicit marshalling adds a fixed-size
stack record and field-copy cost. A future reviewed target-specific public
record could avoid that cost, but changing the existing layout is not a fix.

Evidence: `.work/linux-arm64-kernel-header-check.json`,
`.work/posix-stat-current-foundations.json`, `.work/posix-stat-sdk-both-cpus.json`.
