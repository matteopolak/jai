G :: #import "GetRect";
I :: #import "Input";
M :: #import "Math";
draw_calls:int;
record_fill :: (rect:G.Rect,color:M.Vector4) { draw_calls+=1; }
record_text :: (rect:G.Rect,text:string,alignment:G.Alignment,color:M.Vector4) { draw_calls+=1; }
record_flush :: () { draw_calls+=1; }
frame :: (left:I.Key_Current_State) {
    I.input_button_states[I.Key_Code.MOUSE_BUTTON_LEFT]=left;
    I.events_this_frame.count=0;
    G.ui_per_frame_update(0,100,100,1);
}
modern_ui_cases :: ()->bool {
    G.ui_init(); G.ui_draw_procs=.{record_fill,record_text,record_flush};
    r:=G.get_rect(0,0,20,20);
    G.ui_set_pointer(10,10); frame(.START|.DOWN);
    if G.button(r,"Press") return false;
    G.draw_popups(); frame(.END);
    if !G.button(r,"Press") return false;
    G.draw_popups();
    value:float=0; theme:=G.getrect_theme.slider_theme;
    G.ui_set_pointer(13,10); frame(.START|.DOWN);
    if !G.slider(r,*value,0,10,2,*theme,"","")||value!=6 return false;
    G.draw_popups(); frame(.END); G.slider(r,*value,0,10,2,*theme,"",""); G.draw_popups();
    choice:s32=0; choices:=string.["First","Second"];
    G.ui_set_pointer(10,10); frame(.START|.DOWN);
    state:=G.dropdown(r,choices,*choice); if !state.open return false;
    G.draw_popups();
    G.ui_set_pointer(10,-30); frame(.START|.DOWN);
    G.dropdown(r,choices,*choice); G.draw_popups();
    if choice!=1||draw_calls<10 return false;
    G.ui_deinit(); return true;
}
#assert #run modern_ui_cases();
main :: () { modern_ui_cases(); }
