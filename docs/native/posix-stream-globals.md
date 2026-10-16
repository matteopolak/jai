# POSIX mutable standard-stream globals

The reviewed POSIX contract requires `stdin`, `stdout`, and `stderr` to be
mutable external `*FILE` variables. Their addresses identify libc's current
pointer cells. A cached pointer, accessor procedure, or separately allocated
cell would change the public contract.

Darwin's public SDK `_stdio.h` declares `__stdinp`, `__stdoutp`, and `__stderrp`
as external `FILE *` variables and macro-maps the conventional C identifiers to
them. The SDK `libsystem_c.tbd` exports their Mach-O symbols with the additional
linker underscore. Both reviewed Mac CPU configurations now use the existing
general `#elsewhere libc "C_identifier"` facility. Linux and Android retain
their conventional external identifiers. There is no runtime adapter, pointer
copy, additional export, compiler exception, or change to `FILE`.

The defect was stale generated declarations after the reviewed spec supplied
the rename strings. The current spec parser and generator preserve those
strings; parser, semantic analysis, and LLVM foreign-global lowering already
support arbitrary renamed data symbols. Regeneration changes exactly six lines
in `stdlib/POSIX/declarations.jai`.

`tests/native-bindings/posix-stream-globals.jai` and the independent SDK C probe
check all three global addresses, initial pointer values, assignments from Jai
observed by C, and assignments from C observed by Jai. The program restores all
three globals before reporting an assertion failure, performs no IO while
rotated, and closes no stream. An unrelated renamed integer global exercises
the general facility and bidirectional mutable storage independently of libc.
Physical SDK names must remain absent from POSIX's public exports.

Run `tools/native_bindings/verify_posix_streams.py` with own source-built
`--compiler`, `--jailint`, `--formatter`, and a worker-private `--output-root`.
Its default mode checks Mac ARM64/x64 and Linux ARM64/x64 sources and strict
lint, both Mac SDK objects/relocations, ARM64 O0/O2/sanitizer linking and emitted
external globals, privacy, formatting, and exact spec regeneration. It captures
the actual shared stdlib and verifies immutable input hashes. Compilation and
linking do not establish runtime storage behavior. Add `--native` only after
the integrator releases the serialized execution gate; it runs the three host
programs, including ASan/UBSan. No other target execution is implied.

The original pre-fix reduction, current receipts, compiler input identity,
source hashes, native-gate status, and exact integration manifest are recorded
in `docs/status/bindings-shared-audit.json`. Native Mac x64, Linux, and Android
checks remain distinct unavailable verification gates. This narrow repair does
not waive existing ABI tests or claim a broader POSIX ABI audit.
