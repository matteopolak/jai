# Windows Registry API inventory

Twenty-three reviewed exports now bind actual Advapi32 procedures/native scalar
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

Ten predefined pseudo-handles remain INCOMPLETE due to compiler constant freezing:
HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, HKEY_USERS,
HKEY_PERFORMANCE_DATA, HKEY_PERFORMANCE_TEXT, HKEY_PERFORMANCE_NLSTEXT,
HKEY_CURRENT_CONFIG, HKEY_DYN_DATA, HKEY_CURRENT_USER_LOCAL_SETTINGS.
The reviewed expressions cast positive0x800000xx directly to HKEY; the official C
SDK casts through signed32-bit LONG and ULONG_PTR, producing sign-extended64-bit
handles. Refreshed review explicitly establishes positive zero-extension as the
public contract. Do not change that value or assume native acceptance. The new
candidate is blocked by compiler opaque-pointer freezing, not an API question;
see portable-opaque-pointer-constants.md for exact reproducer/candidate files.
Native tests obtain a real root using private test-only RegOpenCurrentUser;
no substitute root constant is exported.

Official native ABI inputs:
- https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regopenkeyexw
- https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regqueryvalueexw
- https://raw.githubusercontent.com/microsoft/win32metadata/main/generation/WinSDK/RecompiledIdlHeaders/um/winreg.h

The committed23-export generator omitted these previously unreviewed handles.
The uncommitted candidate generator now includes their resolved values, emits
independently grouped bindings and normalizes
with source-built jaifmt. Two regenerations are byte-identical.
tools/check_portable_windows_registry.py checks public constants/privacy and all
seven call bodies for Windows x64/ARM64. --native requires actual Windows and runs
interpreter/native O0/O2. That native gate has NOT run here. Its fixture creates
a PID-named volatile key under HKCU Software, sets one DWORD and one child,
checks wide/ANSI open/query, short-buffer status/required size, typed get, enum,
closes every opened handle and deletes its test tree. It does not access arbitrary
registry values, credentials or harness configuration. An abort can leave the
volatile test key until cleanup/reboot; exact-path collision diagnoses rather
than overwriting an existing key.

Initial missing-module failure: target/registry-red.log. The initial fixture
mistook utf8_to_wide's first return for an array; reviewed windows-utf8.md confirms
pointer/success/byte-count. Corrected to capture/check all three outputs; original
failure retained at target/registry-first-bodies.log. This was a test defect,
not a changed conversion API. Passing source evidence: target/registry-final-bodies.log.

Source-built jaifmt/check pass. Earlier active Windows strict lint was unavailable:
that older jailint had no target selector. The NEW rebuilt target-aware linter
is now available and the candidate runner invokes both Windows target triples,
but the pointer-constant compiler failure stops source checking first. Evidence:
target/registry-linter-capabilities.log and target/registry-target-lint-blocker.log.
No global suppression, target constant substitution, emulation or native pass
claim is used. Whole strict lint remains the previously recorded failed gate.
