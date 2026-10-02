// Normalized API contracts; reference procedure bodies were discarded.
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
    using unknown : IUnknown_VTable;
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
COINIT_APARTMENTTHREADED :: 0;
COINIT_MULTITHREADED :: 1;
COINIT_DISABLE_OLE1DDE :: 2;
COINIT_SPEED_OVER_MEMORY :: 3;
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
    CLSCTX_INPROC :: CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER;
    CLSCTX_ALL :: CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER|CLSCTX_LOCAL_SERVER|CLSCTX_REMOTE_SERVER;
    CLSCTX_SERVER :: CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER|CLSCTX_REMOTE_SERVER;
}
CoInitialize :: (pvReserved: *void) -> HRESULT #foreign Ole32;
CoUninitialize :: () -> void #foreign Ole32;
CoInitializeEx :: (pvReserved: *void, dwCoInit: DWORD) -> HRESULT #foreign Ole32;
REFCLSID :: *IID;
CoCreateInstance :: (rclsid: REFCLSID, pUnkOuter: *IUnknown, dwClsContext: CLSCTX, riid: REFIID, ppv: **void) -> HRESULT #foreign Ole32;
CoCreateFreeThreadedMarshaler :: (punkOuter: *IUnknown, ppunkMarshal: **IUnknown) -> HRESULT #foreign Ole32;
#scope_export
find_visual_studio_in_a_ridiculous_garbage_way :: () -> (library_path := "", linker_path := "") #foreign Native_Adapters "jai_stdlib_Windows_Resources_jai_find_visual_studio_in_a_ridiculous_garbage_way_cfe50806f5cf";
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
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
