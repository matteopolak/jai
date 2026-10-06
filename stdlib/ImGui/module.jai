// Dear ImGui bindings (1.89.6).
ImVec2 :: Vector2;
ImVec4 :: Vector4;
ImColor :: Vector4;
ImVector :: struct(T: Type) {
    Size: s32;
    Capacity: s32;
    Data: *T;
}
ImDrawCallback :: #type (parent_list: *ImDrawList, cmd: *ImDrawCmd) #c_call;
#scope_module
#import "Basic";
#import "Math";
#if OS == .WINDOWS {
    #load "windows.jai";
    ImGui_User32 :: #system_library,link_always "user32";
} else {
    #load "unix.jai";
}
