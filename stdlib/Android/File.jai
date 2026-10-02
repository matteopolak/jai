// Normalized API contracts; reference procedure bodies were discarded.
visit_files :: (asset_manager: *AAssetManager, dir_name: string, recursive: bool, user_data: $T, proc: (info: *File_Visit_Info, user_data: T), visit_files := true, visit_directories := false, visit_symlinks := false, follow_directory_symlinks := false) -> bool #foreign Native_Adapters "jai_stdlib_Android_File_jai_visit_files_a3f8772bd962";
#import "Android";
#import "Basic";
#import "File_Utilities";
#import "POSIX";
#import "String";

#scope_export
#load "asset-read.jai";

#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
