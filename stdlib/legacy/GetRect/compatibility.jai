// Historical callable surface backed by authored shared widget operations.
#scope_export
switch_to_bottom_rect :: switch_to_second_rect;
switch_to_right_rect :: switch_to_second_rect;
switch_to_top_rect :: switch_to_first_rect;
switch_to_left_rect :: switch_to_first_rect;
get_aspect :: (r:Rect)->float { if r.h==0 return 0; return r.w/r.h; }
is_grabbing :: ()->bool { return active_widget!=null&&active_widget_is_grabbing; }
set_scissor :: (r:Rect) {
    if scissor_stack.count>0 scissor_stack[scissor_stack.count-1]=r;
    draw_procs.set_scissor(cast(s32)floor(r.x),cast(s32)floor(r.y),cast(s32)ceil(r.x+r.w),cast(s32)ceil(r.y+r.h));
}
get_roundedness_for_rect :: (r:Rect,type:Size_Computation,roundedness:float,global_value:float,limit:=0.5)->float {
    amount:=get_float_parameter(r,type,roundedness,global_value); return clamp(amount,0.0,max(min(r.w,r.h)*limit,0.0));
}
get_y_range :: (font:*Font,text_y:float)->(y0:float,y1:float) {
    if !font return text_y,text_y; return text_y-font.max_descender,text_y+font.max_ascender;
}
my_draw_text :: (font:*Font,x:s64,y:s64,text:string,color:Vector4,effects:Font_Effects=0) {
    assert(font&&draw_procs.prepare_text&&draw_procs.draw_prepared_text,"Text renderer callbacks and font are required");
    if !font||!draw_procs.prepare_text||!draw_procs.draw_prepared_text return;
    draw_procs.prepare_text(font,text,effects); draw_procs.draw_prepared_text(font,x,y,color,effects);
}
core_draw_button_label :: (r:Rect,text:string,state:*Button_State,theme:*Button_Theme) {
    label_theme:=theme.label_theme; label_theme.text_color=theme.text_color;
    if state.status&.OVER label_theme.text_color=theme.text_color_over;
    if state.status&.DOWN label_theme.text_color=theme.text_color_pressed;
    label(shrink(r,state.frame_pixels),text,*label_theme);
}
to_vec3 :: (v2:Vector2)->Vector3 { return .{v2.x,v2.y,0}; }
draw_arrow :: (state:*Button_State,p4:Vector3,p5:Vector3,p6:Vector3,theme:*Button_Theme) {
    surface,frame,thickness:=get_colors_and_thickness_for_button(theme,state); draw_procs.set_shader_for_color(true);
    draw_procs.immediate_triangle(p4,p5,p6,surface,surface,surface);
}
set_initial_value :: (state:*Slider_State,value:$T) {
    state.value_type=type_info(T);
    #if type_info(T).type==.FLOAT {
        #if size_of(T)==4 { state.initial_value_float32=cast(float32)value; }
        else { state.initial_value_float64=cast(float64)value; }
    } else { state.initial_value_int=cast,no_check(int)value; }
}
get_initial_value :: (state:*Slider_State,$T:Type)->T {
    assert(state.value_type==type_info(T),"Slider initial value type changed");
    #if type_info(T).type==.FLOAT {
        #if size_of(T)==4 { return cast(T)state.initial_value_float32; }
        else { return cast(T)state.initial_value_float64; }
    } else { return cast,no_check(T)state.initial_value_int; }
}
set_and_maybe_clamp :: (new_value:$ValueType,pointer:*$T,min_value:T,max_value:T,clamp_low:bool,clamp_high:bool) {
    candidate:=new_value;
    if clamp_low&&candidate<min_value { pointer.*=min_value; return; }
    if clamp_high&&candidate>max_value { pointer.*=max_value; return; }
    pointer.*=cast(T)candidate;
}
start_selecting :: (using state:*Text_Input_State) {
    state.selection=.{start_line=0,end_line=0,start_character=state.insert_point,end_character=state.insert_point,active=true}; state.cursor_tracking_mouse=true;
}
insert_clipboard_at_cursor :: (using state:*Text_Input_State) { left_paste_clipboard(state); }
press_enter :: (using state:*Text_Input_State,shift_pressed:=false) {
    if !shift_pressed&&state.tab_pressed&&accept_auto_complete(state) return;
    state.pending_result_actions|=.ENTERED;
    if state.text.count>0&&(state.command_history.count==0||state.command_history[state.command_history.count-1]!=state.text) array_add(*state.command_history,copy_string(state.text));
    state.command_history_index=state.command_history.count;
}
press_tab :: (using state:*Text_Input_State,shift_pressed:=false) { advance_auto_complete(state,shift_pressed); }
press_escape :: (using state:*Text_Input_State) {
    if state.tab_pressed { reset_auto_complete(state); return; }
    state.pending_result_actions|=.ESCAPED;
}
break_into_lines :: (s:string,between_lines_string:="")->[]string {
    pieces:[..]string; pieces.allocator=Basic.temp; begin:=0; at:=0;
    while at<s.count {
        if s[at]!=10&&s[at]!=13 { at+=1; continue; }
        array_add(*pieces,string.{at-begin,s.data+begin});
        if between_lines_string.count>0 array_add(*pieces,between_lines_string);
        if s[at]==13&&at+1<s.count&&s[at+1]==10 at+=1;
        at+=1; begin=at;
    }
    array_add(*pieces,string.{s.count-begin,s.data+begin}); return pieces;
}
sanitize :: (s:string)->string {
    builder:String.String_Builder; defer String.free_buffers(*builder);
    for part:break_into_lines(s," ") for byte:part {
        if byte==9 String.append(*builder,cast(u8)32);
        else if byte>=32&&byte!=127 String.append(*builder,byte);
    }
    return String.builder_to_string(*builder);
}
get_insert_point_for_cursor :: (state:*Text_Input_State,font:*Font,text:string,current_frame_text_x:float,cursor_x:int,effect:Font_Effects,glyphs_prepped:=false)->int {
    if !font return 0;
    assert(draw_procs.prepare_text,"Cursor mapping needs prepare_text"); if !draw_procs.prepare_text return 0;
    defer draw_procs.prepare_text(font,text,effect);
    width_before:float; at:=0; x:=cursor_x-current_frame_text_x;
    while at<text.count {
        next:=seek_right_one_utf8_character(text,at); width_after:=cast(float)draw_procs.prepare_text(font,string.{next,text.data},effect);
        if x<(width_before+width_after)/2 return at;
        at=next; width_before=width_after;
    }
    return text.count;
}
maybe_diagonalize :: (flag:Resize_Controls,x:float,w:float,margin:float,low:Resize_Controls,high:Resize_Controls,mouse:float)->Resize_Controls {
    if mouse<x+max(margin,0.0) return flag|low;
    if mouse>x+w-max(margin,0.0) return flag|high;
    return flag;
}
adjust_resize_control :: (theme:*Subwindow_Theme,state:*Subwindow_State,f:Resize_Controls)->Resize_Controls {
    result:=f&theme.resize_controls;
    if result&.EW||result&.NS result|=theme.resize_controls&(.SNAP|.PROPORTIONAL);
    if state.info&&state.info.fixed_aspect_ratio>0 result|=.PROPORTIONAL;
    return result;
}
invert_button_theme :: (button_theme:*Button_Theme) {
    button_theme.surface_color=left_inverse_color(button_theme.surface_color); button_theme.surface_color_over=left_inverse_color(button_theme.surface_color_over);
    button_theme.surface_color_down=left_inverse_color(button_theme.surface_color_down); button_theme.surface_color_flash=left_inverse_color(button_theme.surface_color_flash);
    button_theme.frame_color=left_inverse_color(button_theme.frame_color); button_theme.frame_color_over=left_inverse_color(button_theme.frame_color_over);
    button_theme.frame_color_down=left_inverse_color(button_theme.frame_color_down); button_theme.frame_color_flash=left_inverse_color(button_theme.frame_color_flash);
    button_theme.text_color=left_inverse_color(button_theme.text_color); button_theme.text_color_over=left_inverse_color(button_theme.text_color_over); button_theme.text_color_pressed=left_inverse_color(button_theme.text_color_pressed);
    button_theme.label_theme.text_color=left_inverse_color(button_theme.label_theme.text_color);
}
invert_scrollbar :: (using scrollable_region_theme:*Scrollable_Region_Theme) {
    invert_button_theme(*scrollable_region_theme.scrollbar_nib_theme);
    scrollable_region_theme.scrollbar_background.color=left_inverse_color(scrollable_region_theme.scrollbar_background.color);
    scrollable_region_theme.scrollbar_background.frame_color=left_inverse_color(scrollable_region_theme.scrollbar_background.frame_color);
}
#scope_module
left_inverse_color :: (v:Vector4)->Vector4 { return .{1-v.x,1-v.y,1-v.z,v.w}; }
