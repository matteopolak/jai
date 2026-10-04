// Authored historical color helpers share the production interpolation path.
#scope_export
MAX_STASHED_COLORS :: 10;
EPSILON :: 0.0001;
backsolve_disc_point_from_rgb :: (state:*Color_Picker_State,rgb:Vector3)->Vector2 {
    h,s,v:=rgb_to_hsv(rgb.x,rgb.y,rgb.z); return backsolve_disc_point_from_hsv(state,h*360,s,v);
}
backsolve_disc_point_from_hsv_warp :: (h:float,s:float,v:float)->Vector2 {
    square:=Vector2.{2*clamp(s,0.0,1.0)-1,1-2*clamp(v,0.0,1.0)};
    magnitude:=length(square); if magnitude<=EPSILON return .{};
    return square*(max(abs(square.x),abs(square.y))/magnitude);
}
backsolve_disc_point_from_hsv :: (state:*Color_Picker_State,h:float,s:float,v:float)->Vector2 {
    if state.circle_picker_in_warped_mode return backsolve_disc_point_from_hsv_warp(h,s,v);
    return .{2*clamp(s,0.0,1.0)-1,1-2*clamp(v,0.0,1.0)};
}
find_index_of_t :: (sorted:[]*Augmented_Keyframe,t:float)->(index:int) {
    low:=0; high:=sorted.count;
    while low<high { middle:=low+(high-low)/2; if sorted[middle].t<=t low=middle+1; else high=middle; }
    return low-1;
}
update_keyframe_color_due_to_open_color_picker :: (state:*Color_Animation_Editor_State) {
    if !state.color_picker_subwindow_info.open||state.color_picker_keyframe_index<0||state.color_picker_keyframe_index>=state.color_keyframes.count return;
    rgb:=state.color_picker_editing_color_applied; old:=state.color_keyframes[state.color_picker_keyframe_index].color_rgb;
    state.color_keyframes[state.color_picker_keyframe_index].color_rgb=.{rgb.x,rgb.y,rgb.z,old.w};
}
init_color_by_interpolation :: (state:*Color_Animation_Editor_State,keyframe_index:int) {
    if keyframe_index<0||keyframe_index>=state.color_keyframes.count return;
    sorted:=get_sorted_keyframes(state,keyframe_index);
    state.color_keyframes[keyframe_index].color_rgb=left_color_sample_at(sorted,get_interpolation(state),state.color_keyframes[keyframe_index].t);
}
draw_color_gradient_bar :: (area:Rect,theme:*Color_Animation_Editor_Theme,state:*Color_Animation_Editor_State,top_margin:float) {
    if !GETRECT_Y_UP area.y+=max(top_margin,0.0); area.h=max(area.h-max(top_margin,0.0),0.0); left_color_strip(area,state,1.0);
}
draw_color_keyframe :: (index:int,rect:Rect,theme:*Color_Animation_Editor_Theme,state:*Color_Animation_Editor_State) {
    if index<0||index>=state.color_keyframes.count return;
    frame:=*state.color_keyframes[index]; breadth:=rect.h*theme.keyframe_width_relative_to_bar_height_nondragging;
    if state.dragging_in_strip&&state.dragging_keyframe_index==index breadth*=theme.keyframe_scale_when_dragging;
    marker:=Rect.{rect.x+clamp(frame.t,0.0,1.0)*rect.w-breadth/2,rect.y,max(breadth,1.0),rect.h}; frame.pos_x=marker.x+marker.w/2;
    active:=frame.active||(state.dragging_in_strip&&state.dragging_keyframe_index==index)||(state.color_picker_subwindow_info.open&&state.color_picker_keyframe_index==index);
    left_color_fill(marker,ifx active then theme.keyframe_color_active else theme.keyframe_color_inactive);
    left_color_fill(shrink(marker,marker.w*(1-theme.keyframe_inset_ratio)/2),frame.color_rgb);
}
update_keyframes :: (rect:Rect,theme:*Color_Animation_Editor_Theme,state:*Color_Animation_Editor_State) {
    halfwidth:=rect.h*theme.keyframe_width_relative_to_bar_height_nondragging*theme.keyframe_selection_size_relative_to_visual_size/2; hit:=-1;
    for *frame,index:state.color_keyframes {
        marker:=Rect.{rect.x+clamp(frame.t,0.0,1.0)*rect.w-halfwidth,rect.y,2*halfwidth,rect.h};
        if is_inside(mouse_x_float,mouse_y_float,marker) hit=index;
    }
    status:=get_status_flags(rect,state);
    if status&.PRESSED {
        if hit<0 {
            created:=array_add(*state.color_keyframes); created.t=clamp((mouse_x_float-rect.x)/max(rect.w,1.0),0.0,1.0); hit=state.color_keyframes.count-1;
            init_color_by_interpolation(state,hit);
        }
        for *frame,index:state.color_keyframes frame.active=index==hit;
        if shift_key_state&.DOWN { state.color_picker_keyframe_index=hit; open_color_picker(theme,state,hit,rect); }
        else { state.dragging_in_strip=true; state.dragging_keyframe_index=hit; active_widget_add(state,true); }
    }
    if mouse_button_right_state&.START&&hit>=0&&has_focus(rect) {
        for i:hit+1..state.color_keyframes.count-1 state.color_keyframes[i-1]=state.color_keyframes[i]; state.color_keyframes.count-=1;
        state.dragging_in_strip=false; state.color_picker_subwindow_info.open=false; active_widget_remove(state);
    }
    if state.dragging_in_strip&&state.dragging_keyframe_index>=0&&state.dragging_keyframe_index<state.color_keyframes.count {
        state.color_keyframes[state.dragging_keyframe_index].t=clamp((mouse_x_float-rect.x)/max(rect.w,1.0),0.0,1.0);
        if mouse_button_left_state&.END { state.dragging_in_strip=false; active_widget_remove(state); }
    }
    update_keyframe_color_due_to_open_color_picker(state);
}
my_color_slider :: (rect:Rect,alpha:float,theme:*Color_Animation_Editor_Theme,state:*Color_Animation_Editor_State)->(changed:bool) {
    before:=NewArray(state.color_keyframes.count,Color_Keyframe,allocator=Basic.temp);
    for frame,index:state.color_keyframes before[index]=frame.base;
    update_keyframes(rect,theme,state); left_color_strip(rect,state,clamp(alpha,0.0,1.0));
    for frame,index:state.color_keyframes draw_color_keyframe(index,rect,theme,state);
    if before.count!=state.color_keyframes.count return true;
    for frame,index:state.color_keyframes if frame.t!=before[index].t||frame.color_rgb!=before[index].color_rgb return true;
    return false;
}
#scope_module
left_color_strip :: (rect:Rect,state:*Color_Animation_Editor_State,alpha:float) {
    if rect.w<=0||rect.h<=0 return;
    count:=max(cast(int)ceil(rect.w),1); array_resize(*state.color_samples,count); generate_color_samples(get_sorted_keyframes(state),get_interpolation(state),state.color_samples);
    for color,index:state.color_samples { color.w*=alpha; left_color_fill(.{rect.x+rect.w*index/count,rect.y,rect.w/count+1,rect.h},color); }
}
left_color_sample_at :: (sorted:[]*Augmented_Keyframe,interp:Interpolation,t:float)->Vector4 {
    shifted:=NewArray(sorted.count,*Color_Keyframe,allocator=Basic.temp); values:=NewArray(sorted.count,Color_Keyframe,allocator=Basic.temp);
    for frame,index:sorted { values[index]=frame.base; values[index].t-=t; shifted[index]=*values[index]; }
    output:[1]Vector4; generate_color_samples(shifted,interp,output); return output[0];
}
left_disc_square :: (point:Vector2,warp:bool)->Vector2 {
    if !warp return .{clamp(point.x,-1.0,1.0),clamp(point.y,-1.0,1.0)};
    magnitude:=min(length(point),1.0); maximum:=max(abs(point.x),abs(point.y));
    if maximum<=EPSILON return .{}; return point*(magnitude/maximum);
}
