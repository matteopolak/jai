#scope_export
flow_text :: (text:*Flowable_Text,r:Rect,flowed_count:s32) {
    assert(text!=null); if !text return;
    for *line:text.flowed_lines array_free(line.pieces);
    text.flowed_lines.count=0; text.num_flowed_lines=0; text.flowed_rect=r;
    current:[..]Unflowed_Line_Piece; defer array_reset(*current);
    limit:=text.unflowed_lines.count; if flowed_count>0 limit=min(limit,flowed_count);
    width:=max(r.w,1.0); used:float;
    for index:0..limit-1 {
        for piece:text.unflowed_lines[index].pieces {
            if !piece.font continue;
            start:=0; point:=0;
            while point<piece.text.count {
                next:=seek_right_one_utf8_character(piece.text,point);
                if piece.text[point]==10 {
                    if point>start { fragment:=piece; fragment.text=.{point-start,piece.text.data+start}; array_add(*current,fragment); }
                    left_flush_flow_line(text,*current); used=0; point=next; start=point; continue;
                }
                candidate:=string.{next-start,piece.text.data+start}; advance:=cast(float)draw_procs.prepare_text(piece.font,candidate,piece.effects);
                if used+advance>width&&(point>start||current.count>0) {
                    if point>start { fragment:=piece; fragment.text=.{point-start,piece.text.data+start}; array_add(*current,fragment); }
                    left_flush_flow_line(text,*current); used=0; start=point;
                    continue;
                }
                point=next;
            }
            if point>start {
                fragment:=piece; fragment.text=.{point-start,piece.text.data+start}; array_add(*current,fragment);
                used+=cast(float)draw_procs.prepare_text(piece.font,fragment.text,piece.effects);
            }
        }
        left_flush_flow_line(text,*current); used=0;
    }
    text.num_flowed_lines=cast(s32)text.flowed_lines.count;
}
maybe_reflow_text_if_rect_dimensions_changed :: (text:*Flowable_Text,r:Rect) {
    if text.flowed_rect.w!=r.w||text.flowed_rect.h!=r.h||text.flowed_lines.count==0 flow_text(text,r,cast(s32)text.unflowed_lines.count);
}
text_display :: (r:Rect,text:*Flowable_Text,offset_y:float,line_stride:float,theme:*Text_Display_Theme=null,identifier:s64=0,loc:=#caller_location) {
    if !text||line_stride<=0 return; if !theme theme=*left_text_display_theme;
    state:=find_or_create_state(Text_Display_State,get_hash(loc,identifier)); defer stop_using_state(state); state.rect=r; state.text=text;
    content:=r;
    left:=get_float_parameter(r,theme.left_margin_type,theme.left_margin,theme.left_margin);
    right:=get_float_parameter(r,theme.right_margin_type,theme.right_margin,theme.right_margin);
    top:=get_float_parameter(r,theme.top_margin_type,theme.top_margin,theme.top_margin);
    content.x+=left; content.w=max(content.w-left-right,0.0); if !GETRECT_Y_UP content.y+=top; content.h=max(content.h-top,0.0);
    if theme.auto_reflow_text maybe_reflow_text_if_rect_dimensions_changed(text,content);
    view:=left_text_view(state); view.content=content; view.offset=offset_y; view.stride=line_stride;
    status:=get_status_flags(content,state);
    if status&.PRESSED { start_selection(text,mouse_x,mouse_y); state.selecting=true; active_widget_add(state,true); }
    if state.selecting { update_selection_endpoint_for_mouse_position(render_target_width,render_target_height); if mouse_button_left_state&.END { state.selecting=false; active_widget_remove(state); } }
    for event,index:events_to_handle_this_frame if left_event_window(index)==state.window text_display_handle_event(state,event);
    push_scissor(content); defer pop_scissor();
    for line,line_index:text.flowed_lines {
        y:=ifx GETRECT_Y_UP then right_flow_line_y(content,offset_y,line_stride,line_index) else content.y+offset_y+line_index*line_stride; if y+line_stride<content.y||y>=content.y+content.h continue;
        x:=content.x; character:int;
        selected:=make_forward_selection(view.selection);
        for piece:line.pieces {
            if !piece.font continue;
            width:=cast(float)draw_procs.prepare_text(piece.font,piece.text,piece.effects);
            if selected.active&&line_index>=selected.start_line&&line_index<=selected.end_line {
                begin:=ifx line_index==selected.start_line then selected.start_character else 0;
                end:=ifx line_index==selected.end_line then selected.end_character else 0x7fff_ffff;
                a:=clamp(begin-character,0,piece.text.count); b:=clamp(end-character,0,piece.text.count);
                if b>a { x0,x1:=get_selection_endpoints(piece.font,piece.text,piece.effects,x,a,b); left_text_fill(.{x0,y,max(x1-x0,0.0),line_stride},.{0.15,0.40,0.65,0.7}); }
            }
            draw_procs.prepare_text(piece.font,piece.text,piece.effects);
            draw_procs.draw_prepared_text(piece.font,cast(s64)x,cast(s64)(y+default_text_baseline(piece.font,line_stride)),piece.color,piece.effects);
            x+=width; character+=piece.text.count;
        }
    }
}
find_line_and_character :: (text:*Flowable_Text,rt_width:int,rt_height:int,cursor_x:int,cursor_y:int)->(found:bool,line:int,character:int) {
    view:=left_text_view_for_text(text); if !view||text.flowed_lines.count==0 return false,0,0;
    index:=ifx GETRECT_Y_UP then right_flow_line_index(view.content,view.offset,view.stride,cursor_y,text.flowed_lines.count) else clamp(cast(int)floor((cursor_y-view.content.y-view.offset)/view.stride),0,text.flowed_lines.count-1);
    x:=view.content.x; column:int;
    for piece:text.flowed_lines[index].pieces {
        if !piece.font continue; point:=0; previous:float;
        while point<piece.text.count {
            next:=seek_right_one_utf8_character(piece.text,point); width:=cast(float)draw_procs.prepare_text(piece.font,string.{next,piece.text.data},piece.effects);
            if cursor_x<x+(previous+width)/2 return true,index,column+point;
            previous=width; point=next;
        }
        x+=previous; column+=piece.text.count;
    }
    return true,index,column;
}
start_selection :: (text:*Flowable_Text,cursor_x:int,cursor_y:int) {
    view:=left_text_view_for_text(text); if !view return;
    found,line,character:=find_line_and_character(text,render_target_width,render_target_height,cursor_x,cursor_y);
    if found view.selection=.{start_line=cast(s32)line,end_line=cast(s32)line,start_character=character,end_character=character,active=true};
}
update_selection_endpoint_for_mouse_position :: (rt_width:int,rt_height:int) {
    for *view:left_text_views if view.state.selecting {
        found,line,character:=find_line_and_character(view.state.text,rt_width,rt_height,mouse_x,mouse_y);
        if found { view.selection.end_line=cast(s32)line; view.selection.end_character=character; }
    }
}
text_display_handle_event :: (state:*Text_Display_State,event:Event) {
    if event.type!=.KEYBOARD||!event.key_pressed||!(event.ctrl_pressed||event.cmd_meta_pressed)||cast(s32)event.key_code!=67 return;
    view:=left_text_view(state); selected:=make_forward_selection(view.selection); if !selected.active return;
    builder:String_Builder; defer free_buffers(*builder);
    for line,index:state.text.flowed_lines if index>=selected.start_line&&index<=selected.end_line {
        column:int;
        for piece:line.pieces {
            start:=ifx index==selected.start_line then selected.start_character else 0;
            end:=ifx index==selected.end_line then selected.end_character else 0x7fff_ffff;
            a:=clamp(start-column,0,piece.text.count); b:=clamp(end-column,0,piece.text.count);
            if b>a append(*builder,string.{b-a,piece.text.data+a}); column+=piece.text.count;
        }
        if index<selected.end_line append(*builder,cast(u8)10);
    }
    Left_Text_Clipboard.os_clipboard_set_text(builder_to_string(*builder));
}
deinit :: (text:*Flowable_Text) {
    for *line:text.flowed_lines array_free(line.pieces); array_reset(*text.flowed_lines); text.num_flowed_lines=0;
    // Original pieces/text/font bytes are borrowed and remain caller-owned.
    for *view:left_text_views if view.state.text==text { view.state.text=null; view.selection=.{}; }
}
#scope_module
left_text_display_theme:Text_Display_Theme;
Left_Text_View :: struct { state:*Text_Display_State; selection:Selection; content:Rect; offset:float; stride:float; }
left_text_views:[..]Left_Text_View;
left_text_view :: (state:*Text_Display_State)->*Left_Text_View {
    for *view:left_text_views if view.state==state return view;
    result:=array_add(*left_text_views); result.state=state; return result;
}
left_text_view_for_text :: (text:*Flowable_Text)->*Left_Text_View { for *view:left_text_views if view.state.text==text return view; return null; }
left_flush_flow_line :: (text:*Flowable_Text,pieces:*[..]Unflowed_Line_Piece) {
    row:=array_add(*text.flowed_lines); row.pieces=NewArray(pieces.count,Unflowed_Line_Piece);
    for piece,index:pieces.* row.pieces[index]=piece; pieces.count=0;
}
