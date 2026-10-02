// Independently normalized ABI contract. No reference procedure bodies or binaries.
D3DCompile :: ( shader : string , source_name : string , pDefines : [ ] string , pInclude : * ID3DInclude , entry_point : string , target : string , Flags1 : u32 , Flags2 : u32 ) -> bytecode : string , errors : string , HRESULT #foreign Native_Adapters ;
D3DCompileFromFile :: ( file_name : string , pDefines : [ ] string , pInclude : * ID3DInclude , entry_point : string , target : string , Flags1 : u32 , Flags2 : u32 ) -> pCode : * ID3DBlob , pErrorMsgs : * ID3DBlob , HRESULT #foreign Native_Adapters ;
#load "d3dcompiler_bindings.jai" ;
#scope_file
d3dcompiler :: #system_library "d3dcompiler_47" ;
#scope_module
#import "Basic" ;
#import "Windows" ;
#import "Windows_Utf8" ;
#import "String" ;

#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
