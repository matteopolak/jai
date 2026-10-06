// Windows resource embedding: application manifests and version information.
Manifest_Options :: struct {
    dpi_aware := true;
    require_administrator := false;
    use_segment_heap := true;
}
ICONDIRENTRY :: struct {
    Width: u8;
    Height: u8;
    Colors: u8;
    Reserved2: u8;
    Planes: WORD;
    BitsPerPixel: WORD;
    dwBytesInResource: DWORD;
    dwImageOffset: DWORD;
}
ICONDIR :: struct {
    Reserved1: WORD;
    ResourceType: WORD;
    ImageCount: WORD;
}
#scope_file
RESOURCE_ID_MANIFEST :: 1;
RESOURCE_ID_FIRST_ICON :: 2;
MEMICONDIR :: struct {
    Reserved1: WORD;
    ResourceType: WORD;
    ImageCount: WORD;
}
MEMICONDIRENTRY :: struct {
    Width: u8;
    Height: u8;
    Colors: u8;
    Reserved2: u8;
    Planes: WORD;
    BitsPerPixel: WORD;
    ImageSize: DWORD;
    nID: WORD;
}
kernel32 :: #system_library "kernel32";
WORD :: u16;
LONG :: s32;
BeginUpdateResourceW :: (pFileName: *u16, bDeleteExistingResources: BOOL) -> HANDLE #foreign kernel32;
UpdateResourceW :: (hUpdate: HANDLE, lpType: *u16, lpName: *u16, wLanguage: WORD, lpData: *void, cbData: DWORD) -> BOOL #foreign kernel32;
EndUpdateResourceW :: (hUpdate: HANDLE, fDiscard: BOOL) -> BOOL #foreign kernel32;
REQUIRE_ADMINISTRATOR_FALSE :: "asInvoker";
REQUIRE_ADMINISTRATOR_TRUE :: "requireAdministrator";
#scope_export
#scope_file
BSTR :: *u16;
COLESTR :: BSTR;
SysAllocString :: (psz: *u16) -> BSTR #foreign OleAut32;
SysFreeString :: (psz: BSTR) -> void #foreign OleAut32;
IEnumSetupInstances_VTable :: struct {
    using unknown: IUnknown_VTable;
    Next: (this: *IEnumSetupInstances, celt: u32, rgelt: **ISetupInstance, pceltFetched: *u32) -> HRESULT #c_call;
    Skip: (this: *IEnumSetupInstances, celt: u32) -> HRESULT #c_call;
    Reset: (this: *IEnumSetupInstances) -> HRESULT #c_call;
    Clone: (this: *IEnumSetupInstances, ppenum: **IEnumSetupInstances) -> HRESULT #c_call;
}
IEnumSetupInstances :: struct {
    using vtable: *IEnumSetupInstances_VTable;
    uuid :: "6380BCFF-41D3-4B2E-8B2E-BF8A6810C848";
}
ISetupInstance_VTable :: struct {
    using unknown: IUnknown_VTable;
    GetInstanceId: (this: *ISetupInstance, pbstrInstanceId: *BSTR) -> HRESULT #c_call;
    GetInstallDate: (this: *ISetupInstance, pInstallDate: *FILETIME) -> HRESULT #c_call;
    GetInstallationName: (this: *ISetupInstance, pbstrInstallationName: *BSTR) -> HRESULT #c_call;
    GetInstallationPath: (this: *ISetupInstance, pbstrInstallationPath: *BSTR) -> HRESULT #c_call;
    GetInstallationVersion: (this: *ISetupInstance, pbstrInstallationVersion: *BSTR) -> HRESULT #c_call;
    GetDisplayName: (this: *ISetupInstance, lcid: LCID, pbstrDisplayName: *BSTR) -> HRESULT #c_call;
    GetDescription: (this: *ISetupInstance, lcid: LCID, pbstrDescription: *BSTR) -> HRESULT #c_call;
    ResolvePath: (this: *ISetupInstance, pwszRelativePath: *COLESTR, pbstrAbsolutePath: *BSTR) -> HRESULT #c_call;
}
ISetupInstance :: struct {
    using vtable: *ISetupInstance_VTable;
    uuid :: "B41463C3-8866-43B5-BC33-2B0676F7F42E";
}
ISetupConfiguration_VTable :: struct {
    using unknown: IUnknown_VTable;
    EnumInstances: (this: *ISetupConfiguration, ppEnumInstances: **IEnumSetupInstances) -> HRESULT #c_call;
    GetInstanceForCurrentProcess: (this: *ISetupConfiguration, ppInstance: **ISetupInstance) -> HRESULT #c_call;
    GetInstanceForPath: (this: *ISetupConfiguration, wzPath: *u16, ppInstance: **ISetupInstance) -> HRESULT #c_call;
}
ISetupConfiguration :: struct {
    using vtable: *ISetupConfiguration_VTable;
    uuid :: "42843719-DB4C-46C2-8E7C-64F1816EFD5B";
}
COINIT_APARTMENTTHREADED :: 2;
COINIT_MULTITHREADED :: 0;
COINIT_DISABLE_OLE1DDE :: 4;
COINIT_SPEED_OVER_MEMORY :: 8;
using CLSCTX :: enum_flags u32 {
    CLSCTX_INPROC_SERVER :: 0x1;
    CLSCTX_INPROC_HANDLER :: 0x2;
    CLSCTX_LOCAL_SERVER :: 0x4;
    CLSCTX_INPROC_SERVER16 :: 0x8;
    CLSCTX_REMOTE_SERVER :: 0x10;
    CLSCTX_INPROC_HANDLER16 :: 0x20;
    CLSCTX_RESERVED1 :: 0x40;
    CLSCTX_RESERVED2 :: 0x80;
    CLSCTX_RESERVED3 :: 0x100;
    CLSCTX_RESERVED4 :: 0x200;
    CLSCTX_NO_CODE_DOWNLOAD :: 0x400;
    CLSCTX_RESERVED5 :: 0x800;
    CLSCTX_NO_CUSTOM_MARSHAL :: 0x1000;
    CLSCTX_ENABLE_CODE_DOWNLOAD :: 0x2000;
    CLSCTX_NO_FAILURE_LOG :: 0x4000;
    CLSCTX_DISABLE_AAA :: 0x8000;
    CLSCTX_ENABLE_AAA :: 0x10000;
    CLSCTX_FROM_DEFAULT_CONTEXT :: 0x20000;
    CLSCTX_ACTIVATE_X86_SERVER :: 0x40000;
    CLSCTX_ACTIVATE_32_BIT_SERVER :: CLSCTX_ACTIVATE_X86_SERVER;
    CLSCTX_ACTIVATE_64_BIT_SERVER :: 0x80000;
    CLSCTX_ENABLE_CLOAKING :: 0x100000;
    CLSCTX_APPCONTAINER :: 0x400000;
    CLSCTX_ACTIVATE_AAA_AS_IU :: 0x800000;
    CLSCTX_RESERVED6 :: 0x1000000;
    CLSCTX_ACTIVATE_ARM32_SERVER :: 0x2000000;
    CLSCTX_PS_DLL :: 0x80000000;
    CLSCTX_INPROC :: CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER;
    CLSCTX_ALL :: CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER;
    CLSCTX_SERVER :: CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER;
}
CoInitialize :: (pvReserved: *void) -> HRESULT #foreign Ole32;
CoUninitialize :: () -> void #foreign Ole32;
CoInitializeEx :: (pvReserved: *void, dwCoInit: DWORD) -> HRESULT #foreign Ole32;
REFCLSID :: *IID;
CoCreateInstance :: (rclsid: REFCLSID, pUnkOuter: *IUnknown, dwClsContext: CLSCTX, riid: REFIID, ppv: **void) -> HRESULT #foreign Ole32;
CoCreateFreeThreadedMarshaler :: (punkOuter: *IUnknown, ppunkMarshal: **IUnknown) -> HRESULT #foreign Ole32;
#scope_export
find_visual_studio_in_a_ridiculous_garbage_way :: () -> (library_path := "", linker_path := "") {
    // S_OK and S_FALSE both require balancing CoUninitialize. A changed apartment
    // already supplies COM; this function must not uninitialize someone else's.
    initialized := CoInitializeEx(null, 0);
    if initialized < 0 && initialized != -2147417850 return "", "";
    defer if initialized >= 0 CoUninitialize();
    clsid := uid("177F0C4A-1CD3-4DE7-A32C-71DBBB9FA36D");
    iid := uid(ISetupConfiguration.uuid);
    configuration: *ISetupConfiguration;
    if CoCreateInstance(*clsid, null, cast(CLSCTX) 1, *iid, cast(**void) *configuration) < 0 || configuration == null return "", "";
    defer IUnknown_Release(cast(*IUnknown) configuration);
    instances: *IEnumSetupInstances;
    if configuration.vtable.EnumInstances(configuration, *instances) < 0 || instances == null return "", "";
    defer IUnknown_Release(cast(*IUnknown) instances);
    best_version: [4] u32;
    while true {
        instance: *ISetupInstance;
        fetched: u32;
        result := instances.vtable.Next(instances, 1, *instance, *fetched);
        if result < 0 || fetched == 0 break;
        if instance == null break;
        defer IUnknown_Release(cast(*IUnknown) instance);
        path_bstr: BSTR;
        version_bstr: BSTR;
        if instance.vtable.GetInstallationPath(instance, *path_bstr) < 0 || path_bstr == null continue;
        defer SysFreeString(path_bstr);
        if instance.vtable.GetInstallationVersion(instance, *version_bstr) < 0 || version_bstr == null continue;
        defer SysFreeString(version_bstr);
        installation, path_ok := wide_to_utf8(path_bstr);
        if !path_ok continue;
        defer free(installation);
        version, version_ok := wide_to_utf8(version_bstr);
        if !version_ok continue;
        defer free(version);
        components, parsed := _sdk_vs_version(version);
        if !parsed continue;
        if library_path.count > 0 && !_sdk_vs_newer(components, best_version) continue;
        version_file := _sdk_vs_join(installation, "VC\\Auxiliary\\Build\\Microsoft.VCToolsVersion.default.txt");
        defer free(version_file);
        tools_version, read_ok := read_entire_file(version_file);
        if !read_ok || tools_version.count == 0 continue;
        defer free(tools_version);
        start: s64 = 0;
        end := tools_version.count;
        while start < end && tools_version[start] <= 32 start += 1;
        while end > start && tools_version[end - 1] <= 32 end -= 1;
        trimmed := string.{ end - start, tools_version.data + start };
        tool_components, tools_parsed := _sdk_vs_version(trimmed);
        if !tools_parsed continue;
        tools_prefix := _sdk_vs_join(installation, "VC\\Tools\\MSVC");
        defer free(tools_prefix);
        tools_root := _sdk_vs_join(tools_prefix, trimmed);
        defer free(tools_root);
        candidate_library: string;
        candidate_linker: string;
        #if CPU == .ARM64 {
            candidate_library = _sdk_vs_join(tools_root, "lib\\arm64");
            candidate_linker = _sdk_vs_join(tools_root, "bin\\Hostarm64\\arm64\\link.exe");
            if !_sdk_vs_file(candidate_linker) {
                free(candidate_linker);
                candidate_linker = _sdk_vs_join(tools_root, "bin\\Hostx64\\arm64\\link.exe");
            }
        } else #if CPU == .X64 {
            candidate_library = _sdk_vs_join(tools_root, "lib\\x64");
            candidate_linker = _sdk_vs_join(tools_root, "bin\\Hostx64\\x64\\link.exe");
        } else {
            // The supplied declarations target Win64 only.
            continue;
        }
        runtime_lib := _sdk_vs_join(candidate_library, "vcruntime.lib");
        defer free(runtime_lib);
        valid := _sdk_vs_file(runtime_lib) && _sdk_vs_file(candidate_linker);
        if !valid {
            free(candidate_library);
            free(candidate_linker);
            continue;
        }
        if library_path.count > 0 free(library_path);
        if linker_path.count > 0 free(linker_path);
        library_path = candidate_library;
        linker_path = candidate_linker;
        best_version = components;
    }
    return library_path, linker_path;
}
#scope_file
BUFFER_LENGTH :: 10000;
Ole32 :: #system_library "ole32";
OleAut32 :: #system_library "oleaut32";
#scope_module
#import "Basic";
#import "File";
#import "Windows";
#import "Windows_Registry";
#import "Windows_Utf8";
#import "File_Utilities";
#import "String";

#scope_export
#load "Windows/resources.jai";


#scope_file
_sdk_vs_join :: (left: string, right: string) -> string {
    builder: String_Builder;
    defer free_buffers(*builder);
    append(*builder, left);
    if left.count > 0 && left[left.count - 1] != 92 && left[left.count - 1] != 47 append(*builder, cast(u8) 92);
    append(*builder, right);
    return builder_to_string(*builder);
}
_sdk_vs_file :: (path: string) -> bool {
    wide, success, bytes := utf8_to_wide(path);
    if !success || wide == null return false;
    defer free(wide);
    attributes := GetFileAttributesW(wide);
    return attributes != 0xffffffff && (attributes & 16) == 0;
}
_sdk_vs_version :: (text: string) -> [4] u32, bool {
    values: [4] u32;
    if text.count == 0 return values, false;
    component: s64 = 0;
    digits := false;
    for character: text {
        if character == 46 {
            if !digits || component == 3 return values, false;
            component += 1;
            digits = false;
        } else {
            if character < 48 || character > 57 return values, false;
            digit := cast(u32) character - 48;
            if values[component] > (0xffffffff - digit) / 10 return values, false;
            values[component] = values[component] * 10 + digit;
            digits = true;
        }
    }
    return values, digits;
}
_sdk_vs_newer :: (left: [4] u32, right: [4] u32) -> bool {
    for index: 0..3 {
        if left[index] > right[index] return true;
        if left[index] < right[index] return false;
    }
    return false;
}
