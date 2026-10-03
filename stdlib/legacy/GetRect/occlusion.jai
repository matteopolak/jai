// Frame-buffered coverage. Records borrow stable UI-owned widget pointers.
#scope_export
occlusions_current_frame:[..]Occlusion_Record;
occlusions_next_frame:[..]Occlusion_Record;
occluder_being_drawn:*Active_Widget;
occlusion_per_frame_update :: () {
    previous:=occlusions_current_frame; occlusions_current_frame=occlusions_next_frame; occlusions_next_frame=previous; occlusions_next_frame.count=0;
    for i:1..occlusions_current_frame.count-1 {
        item:=occlusions_current_frame[i]; at:=i;
        while at>0&&occlusions_current_frame[at-1].serial<item.serial { occlusions_current_frame[at]=occlusions_current_frame[at-1]; at-=1; }
        occlusions_current_frame[at]=item;
    }
    assert(left_occluder_stack.count==0,"Finish occluders before changing frame"); occluder_being_drawn=null; occluder_under_the_cursor=null;
}
occlusion_per_window_update :: (window:Window_Type) {
    occluder_under_the_cursor=null;
    for record:occlusions_current_frame {
        if !record.widget||record.widget.window!=window continue;
        if is_inside(mouse_x_float,mouse_y_float,record.rect) { occluder_under_the_cursor=record.widget; return; }
    }
}
occluder_start :: (widget:*Active_Widget,rect:Rect) {
    assert(widget,"An occluder needs a retained widget"); if !widget return;
    array_add(*occlusions_next_frame,.{serial=cast(s32)occlusions_next_frame.count+1,rect=rect,widget=widget});
    array_add(*left_occluder_stack,widget); occluder_being_drawn=widget;
}
occluder_finish :: (widget:*Active_Widget,rect:=Rect.{}) {
    assert(left_occluder_stack.count>0&&left_occluder_stack[left_occluder_stack.count-1]==widget,"Unbalanced occluder stack");
    if left_occluder_stack.count==0 return;
    if rect.w!=0 {
        found:=false; i:=occlusions_next_frame.count;
        while i>0 { i-=1; if occlusions_next_frame[i].widget==widget { occlusions_next_frame[i].rect=rect; found=true; break; } }
        assert(found,"Occluder was not registered this frame");
    }
    left_occluder_stack.count-=1; occluder_being_drawn=null;
    if left_occluder_stack.count>0 occluder_being_drawn=left_occluder_stack[left_occluder_stack.count-1];
}
events_occluded :: (widget_if_querying_outside_of_render_time:*Active_Widget=null)->bool {
    blocker:=occluder_under_the_cursor; if !blocker return false;
    query:=widget_if_querying_outside_of_render_time;
    if !query&&state_stack.count>0 query=state_stack[state_stack.count-1];
    if query==blocker||(query&&query.exists_on_occluder==blocker)||blocker.is_on_state_stack return false;
    return true;
}
Occlusion_Record :: struct { serial:s32; rect:Rect; widget:*Active_Widget; }
#scope_module
left_occluder_stack:[..]*Active_Widget;
occluder_under_the_cursor:*Active_Widget;
