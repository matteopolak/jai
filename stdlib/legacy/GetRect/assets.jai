// Historical blob roles are genuine caller-provided resources, retained by this module.
#scope_export
getrect_asset_root:string;
getrect_asset_filenames:=string.["ui_radiobox_full.png","ui_radiobox_empty.png","ui_checkbox_full.png","ui_checkbox_empty.png","Karla-Regular.ttf","mode_circle.png","mode_hsl.png","mode_rgb.png","mode_numbers.png"];
set_asset_root :: (path:string) {
    assert(!initialized,"Configure assets before initializing GetRect"); if initialized return;
    owner:=context.allocator; saved:=copy_string(path);
    right_release_assets(); right_release_asset_root();
    right_asset_root_allocator=owner; right_owned_asset_root=saved; getrect_asset_root=saved;
}
release_asset_data :: () {
    assert(!initialized,"Deinitialize GetRect before releasing borrowed asset buffers"); if initialized return;
    right_release_assets();
}
get_rect_get_global_data :: ()->string,string,string,string,string,string,string,string,string {
    a,b,c,d,e,f,g,h,i:=get_global_data(); return a,b,c,d,e,f,g,h,i;
}
#scope_module
RH_Assets_File :: #import "File";
right_owned_asset_root:string;
right_asset_root_allocator:Allocator;
right_asset_buffers:[9]string;
right_asset_paths:[9]string;
right_asset_allocators:[9]Allocator;
right_asset_path :: (filename:string)->string {
    owner:=context.allocator;
    root:=getrect_asset_root;
    default_root:string;
    defer free(default_root.data,allocator=owner);
    if root.count==0 {
        default_root=String.join(#filepath,"data",separator="/");
        if default_root.count==0 return "";
        root=default_root;
    }
    return String.join(root,filename,separator="/");
}
global_data :: (filename:string)->(memory:string,success:bool) {
    owner:=context.allocator;
    path:=right_asset_path(filename);
    defer free(path.data,allocator=owner);
    if path.count==0 return "",false;
    memory,success=RH_Assets_File.read_entire_file(path,log_errors=true);
    return memory,success;
}
right_cached_asset :: (index:int)->(memory:string,success:bool) {
    assert(index>=0&&index<right_asset_buffers.count); if index<0||index>=right_asset_buffers.count return "",false;
    owner:=context.allocator;
    path:=right_asset_path(getrect_asset_filenames[index]);
    transferred:=false;
    defer { if !transferred free(path.data,allocator=owner); }
    if path.count==0 return "",false;
    if right_asset_buffers[index].count>0 {
        same:=right_asset_paths[index]==path;
        assert(same,"Asset path changed while borrowed data is retained; release asset data before reconfiguration");
        return right_asset_buffers[index],same;
    }
    bytes,loaded:=RH_Assets_File.read_entire_file(path,log_errors=true);
    if !loaded||bytes.count==0 { free(bytes.data,allocator=owner); return "",false; }
    right_asset_allocators[index]=owner;
    right_asset_buffers[index]=bytes; right_asset_paths[index]=path; transferred=true;
    return bytes,true;
}
get_global_data :: ()->string,string,string,string,string,string,string,string,string {
    for name,index:getrect_asset_filenames {
        memory,loaded:=right_cached_asset(index);
        assert(loaded&&memory.count>0,tprint("GetRect asset read failed: %. Configure genuine PNG/font resources before calling the nine-blob getter.",name));
    }
    return right_asset_buffers[0],right_asset_buffers[1],right_asset_buffers[2],right_asset_buffers[3],right_asset_buffers[4],right_asset_buffers[5],right_asset_buffers[6],right_asset_buffers[7],right_asset_buffers[8];
}
right_release_assets :: () {
    for index:0..right_asset_buffers.count-1 {
        owner:=right_asset_allocators[index];
        free(right_asset_buffers[index].data,allocator=owner);
        free(right_asset_paths[index].data,allocator=owner);
        right_asset_buffers[index]=""; right_asset_paths[index]="";
        right_asset_allocators[index]=.{};
    }
}
right_release_asset_root :: () {
    free(right_owned_asset_root.data,allocator=right_asset_root_allocator);
    right_owned_asset_root=""; right_asset_root_allocator=.{}; getrect_asset_root="";
}
