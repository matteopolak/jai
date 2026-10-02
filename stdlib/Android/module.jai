// Normalized API contracts; reference procedure bodies were discarded.
#module_parameters ()(DEFINE_ANDROID_MAIN_AND_CALL_THIS: () -> () = null);
#load "bindings.jai";
#import "Android/Jni";
#import "Android/Log";
#import "Android/Native_App";
#import "POSIX";
Input :: #import "Input";
#if DEFINE_ANDROID_MAIN_AND_CALL_THIS {
    android_main :: (app: *Android_App) #c_call #foreign Native_Adapters "jai_stdlib_Android_module_jai_android_main_49464a5d4a7b";
    my_android_handle_command :: (app: *Android_App, cmd: s32) #c_call #foreign Native_Adapters "jai_stdlib_Android_module_jai_my_android_handle_command_707ce297bc77";
    my_android_handle_input :: (app: *Android_App, event: *AInputEvent) -> (s32) #c_call #foreign Native_Adapters "jai_stdlib_Android_module_jai_my_android_handle_input_9904d5e51557";
}

#scope_file
Native_Adapters :: #system_library "jai-stdlib-native-adapters";
