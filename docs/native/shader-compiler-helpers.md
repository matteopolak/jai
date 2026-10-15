# Reviewed shader compiler convenience helpers

Both missing D3D string overloads and the DXC version helper are implemented.
All public interfaces, canonical Windows COM prefixes/types and native calls
remain intact. The reviewed D3D contract deliberately ignores the define slice;
no string-to-macro grammar is invented.

The memory D3D overload retains all temporary terminated argument strings
through the native call, copies each returned blob's exact byte range into
caller-allocator strings and releases both COM references, including diagnostics
returned with a failure HRESULT. Embedded and terminal NUL bytes remain part of
that native byte range. The file overload uses strict temporary UTF-16 storage
and transfers the native blob references directly to its caller. An invalid
UTF-8 file argument returns E_INVALIDARG with null outputs before the SDK call.

DXC creates the compiler, queries both version interfaces, obtains the custom
COM string and formats `v<major>.<minor> [<custom-version>]` into an owned Basic
sprint result. All interfaces and the COM-allocated text are released. Native
HRESULT failure enters the active assertion mechanism and cannot proceed to an
unsafe null dereference if that assertion handler returns. No private legacy
CheckCom export is restored. The absent Nintendo SDK/source path is not invented.

Windows x64/ARM64 source regressions use the actual public SDK interfaces;
native execution needs the real D3D compiler and DXC DLLs and remains a later
required Windows gate. Mac executes only the shared portable byte-copy safety
regression: exact binary bytes including NUL, independent storage after source
mutation, surrounding canaries, zero-length/null range and allocator cleanup.
Those results do not claim HLSL compilation or native COM execution on Mac.
