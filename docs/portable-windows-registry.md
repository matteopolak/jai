# Windows Registry API inventory

All33 reviewed exports now bind actual Advapi32 procedures/native scalar
types/constants. This is a low-level binding, not an automatic UTF conversion,
allocation or handle-lifecycle wrapper. Independent groups put scalar ABI aliases,
operations and access/type masks together; the public facade exports only reviewed
names and only on Windows. Non-Windows imports are empty. Private library/type
dependencies stay hidden; LSTATUS/REGSAM retain canonical s32/u32 alias metadata.

| Public APIs | Implementation and verification |
| --- | --- |
| RegOpenKeyExA / RegOpenKeyExW | Actual Advapi32 calls, exact pointer widths/parameter names |
| RegQueryValueExA / RegQueryValueExW | Actual native in/out byte counts and type/status outputs |
| RegGetValueA | Actual native type-mask query |
| RegEnumKeyExA | Actual indexed native name/class/FILETIME outputs |
| RegCloseKey | Actual handle close, status exposed unchanged |
| LSTATUS / REGSAM | Canonical32-bit signed status/unsigned rights aliases |
| KEY_QUERY_VALUE / KEY_SET_VALUE / KEY_CREATE_SUB_KEY / KEY_ENUMERATE_SUB_KEYS / KEY_NOTIFY | Reviewed exact immutable access masks |
| KEY_WOW64_64KEY / KEY_WOW64_32KEY / KEY_WRITE / KEY_READ / KEY_EXECUTE | Reviewed exact view/access masks and alias value |
| RRF_RT_REG_SZ / RRF_RT_REG_DWORD / RRF_RT_DWORD / RRF_RT_QWORD | Reviewed exact native type restriction masks |

No native error is swallowed or mapped to success. Callers must check LSTATUS,
size their buffers and close returned real handles. RegQueryValueEx string data
need not include a terminator. No speculative resize/string convenience export.

All ten predefined handles now retain the reviewed immutable positive-pointer
casts. Windows x64/ARM64 #assert checks require exact zero-extended values,
canonical HKEY type identity and immutable assignment rejection. SDK macros
sign-extend through LONG; that discrepancy is preserved, not normalized.
The general compiler pointer-constant repair is adopted from authorized NEW Rust
sources; the original module-independent reproducer passes checking, interpreter
and native ARM64/translated x64 O0/O2. No mutable/function/whitelist workaround.

The existing native fixture now uses public HKEY_CURRENT_USER for real ANSI/wide
open and typed-get calls on its own volatile key. Native Windows execution is
still UNEXECUTED and required; source checks do not prove Advapi32 accepts this
reviewed positive value. Setup retains private RegOpenCurrentUser only to create
and clean its exact test tree, not as a replacement public constant.

Official native ABI inputs:
- https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regopenkeyexw
- https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regqueryvalueexw
- https://raw.githubusercontent.com/microsoft/win32metadata/main/generation/WinSDK/RecompiledIdlHeaders/um/winreg.h

tools/generate_windows_registry.py emits all33 reviewed declarations in independent
ABI/operation/access/namespace groups, normalized by source-built jaifmt. Two
regenerations are byte-identical. tools/check_portable_windows_registry.py checks
all call bodies/constant values/privacy and deliberate constant-write rejection
for Windows x64/ARM64. Target-aware strict lint passes byte-identical staged
production sources and positive fixtures. The intentional write-negative is a
compiler rejection test, not a claimed lint-positive source.

--native still requires actual Windows and runs interpreter/native O0/O2. It has
not run here. Test setup/cleanup does not access arbitrary registry values or
credentials. An abort can leave its volatile test key until cleanup/reboot.
Exact-path collisions diagnose rather than overwrite an existing key.

Initial missing-module failure: target/registry-red.log. The initial fixture
mistook utf8_to_wide's first return for an array; reviewed windows-utf8.md confirms
pointer/success/byte-count. Corrected to capture/check all three outputs; original
failure retained at target/registry-first-bodies.log. This was a test defect,
not a changed conversion API. Passing source evidence: target/registry-final-bodies.log.

Source-built jaifmt/check and active Windows x64/ARM64 strict lint now pass.
The first updated lint attempt used production paths outside JAIC_STDLIB and
correctly failed private-source access checks; the runner now verifies and uses
byte-identical staged library paths. No private import capability was disabled.
Evidence: target/registry-handles-final.log (staging error),
target/registry-handles-verified-final.log (passing source/lint/rejection gates),
target/opaque-pointer-constant-execution.log and target/raw-pointer-compiler-build.log.
Native Windows and full integrated CI remain required.
