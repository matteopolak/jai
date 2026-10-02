// Maintained open-jai public layouts; behavior is independently implemented.
#scope_module
UI_Input :: #import "Input";
UI_Draw :: #import "Simp";
UI_Math :: #import "Math";
UI_Windows :: #import "Window_Type";
#scope_export
#load "interaction.jai";
Alignment :: enum { Left; Center; Right; }
Default_Themes :: enum { Grayscale; }
Label_Theme :: struct { alignment: Alignment; }
Button_Theme :: struct { label_theme: Label_Theme; }
Slider_Foreground_Theme :: struct { alignment: Alignment; }
Slider_Theme :: struct { foreground: Slider_Foreground_Theme; }
Overall_Theme :: struct { button_theme: Button_Theme; slider_theme: Slider_Theme; }
Dropdown_State :: struct { open: bool; }
Default_Theme_Proc :: #type () -> Overall_Theme;
getrect_theme: Overall_Theme;
default_theme_procs :: Default_Theme_Proc.[default_grayscale_theme];
default_grayscale_theme :: () -> Overall_Theme {
    result: Overall_Theme;
    result.button_theme.label_theme.alignment=.Center;
    result.slider_theme.foreground.alignment=.Center;
    return result;
}
set_default_theme :: (theme: Overall_Theme) { getrect_theme=theme; }
ui_init :: () {
    getrect_theme=default_grayscale_theme();
    ui_capture=null; ui_focus=null; ui_initialized=true;
}
// Additive configuration keeps all maintained theme layouts unchanged.
UI_Draw_Procs :: struct {
    fill: (rect: Rect, color: UI_Math.Vector4);
    text: (rect: Rect, text: string, alignment: Alignment, color: UI_Math.Vector4);
    flush: ();
}
ui_draw_procs: UI_Draw_Procs = .{ui_simp_fill,ui_simp_text,ui_simp_flush};
ui_pointer_query: (window: s64) -> float64,float64,bool = null;
ui_font: *UI_Draw.Dynamic_Font;
ui_surface_color := UI_Math.Vector4.{0.18,0.18,0.18,1};
ui_hover_color := UI_Math.Vector4.{0.30,0.30,0.30,1};
ui_pressed_color := UI_Math.Vector4.{0.42,0.42,0.42,1};
ui_text_color := UI_Math.Vector4.{0.95,0.95,0.95,1};
ui_accent_color := UI_Math.Vector4.{0.60,0.60,0.60,1};
ui_set_pointer :: (x:float64,y:float64) { ui_mouse_x=x; ui_mouse_y=y; }
ui_push_id :: (id:u64) { array_add(*ui_id_stack,ui_id_scope); ui_id_scope=ui_id_scope*1099511628211^id; }
ui_pop_id :: () {
    assert(ui_id_stack.count>0,"Unbalanced GetRect ID stack");
    if ui_id_stack.count>0 { ui_id_scope=ui_id_stack[ui_id_stack.count-1]; ui_id_stack.count-=1; }
}
ui_per_frame_update :: (window:s64,width:int,height:int,current_time:float64) {
    if !ui_initialized ui_init();
    assert(ui_id_stack.count==0,"Finish GetRect ID scopes before beginning a frame");
    ui_window=window; ui_width=max(width,0); ui_height=max(height,0);
    ui_time=current_time; ui_ordinal=0; ui_popups.count=0; ui_consumed_click=false;
    ui_left_down=(UI_Input.input_button_states[UI_Input.Key_Code.MOUSE_BUTTON_LEFT]&.DOWN)!=0;
    ui_left_start=(UI_Input.input_button_states[UI_Input.Key_Code.MOUSE_BUTTON_LEFT]&.START)!=0;
    ui_left_end=(UI_Input.input_button_states[UI_Input.Key_Code.MOUSE_BUTTON_LEFT]&.END)!=0;
    ui_pending_key=.UNKNOWN;
    if ui_pointer_query {
        x,y,success:=ui_pointer_query(window); if success ui_set_pointer(x,y);
    } else if UI_Input.input_pointer_source {
        x,y:=UI_Input.get_mouse_pointer_position(cast(UI_Windows.Window_Type)window,true);
        ui_set_pointer(x,cast(float64)height-y);
    }
    for event:UI_Input.events_this_frame getrect_handle_event(event);
    if ui_capture && ui_capture.last_frame+1<ui_frame ui_capture=null;
    if ui_focus && ui_focus.last_frame+1<ui_frame ui_focus=null;
    ui_frame+=1;
}
getrect_handle_event :: (event:$T) {
    #if T==UI_Input.Event {
        if event.window!=cast(UI_Windows.Window_Type)ui_window return;
        if event.type==.KEYBOARD && event.key_code==.MOUSE_BUTTON_LEFT {
            ui_left_down=event.key_pressed;
            if event.key_pressed && !event.repeat ui_left_start=true;
            if !event.key_pressed ui_left_end=true;
        }
        if event.type==.KEYBOARD && event.key_pressed ui_pending_key=event.key_code;
    } else { assert(false,"GetRect accepts the authored Input.Event record; adapt other records explicitly"); }
}
button :: (r:Rect,label:string)->bool {
    state:=ui_state(.BUTTON); state.rect=r;
    over:=ui_hit(r)&&(!ui_capture||ui_capture==state)&&!ui_popup_occludes(r);
    transition:=ui_pointer_activation(ui_capture==state,over,ui_left_start,ui_left_end,!ui_consumed_click);
    if over&&ui_left_start&&!ui_consumed_click { ui_focus=state; ui_consumed_click=true; }
    if transition.capture ui_capture=state;
    if !transition.capture&&ui_capture==state ui_capture=null;
    clicked:=transition.clicked;
    if ui_focus==state&&(ui_pending_key==.ENTER||ui_pending_key==.SPACEBAR) { clicked=true; ui_pending_key=.UNKNOWN; }
    color:=ui_surface_color; if over color=ui_hover_color; if ui_capture==state&&ui_left_down color=ui_pressed_color;
    ui_draw_procs.fill(r,color); ui_draw_procs.text(r,label,getrect_theme.button_theme.label_theme.alignment,ui_text_color);
    return clicked;
}
slider :: (r:Rect,value:*float,min:float64,max:float64,step:float64,theme:*Slider_Theme,prefix:string,suffix:string)->bool {
    assert(value!=null&&max>=min,"Invalid GetRect slider range"); if !value||max<min return false;
    state:=ui_state(.SLIDER); state.rect=r;
    over:=ui_hit(r)&&!ui_popup_occludes(r);
    if over&&ui_left_start&&!ui_consumed_click { ui_capture=state; ui_focus=state; ui_consumed_click=true; }
    before:=value.*; candidate:=cast(float64)before;
    if ui_capture==state&&ui_left_down&&r.w>0 candidate=min+(max-min)*clamp((ui_mouse_x-r.x)/r.w,0.0,1.0);
    if ui_focus==state&&ui_pending_key==.ARROW_LEFT { candidate-=step; ui_pending_key=.UNKNOWN; }
    if ui_focus==state&&ui_pending_key==.ARROW_RIGHT { candidate+=step; ui_pending_key=.UNKNOWN; }
    if step>0 candidate=min+UI_Math.floor((candidate-min)/step+0.5)*step;
    value.*=cast(float)clamp(candidate,min,max);
    if ui_capture==state&&ui_left_end ui_capture=null;
    ui_draw_procs.fill(r,ifx over then ui_hover_color else ui_surface_color);
    fraction:=0.0; if max>min fraction=clamp((cast(float64)value.*-min)/(max-min),0.0,1.0);
    foreground:=r; foreground.w*=fraction; ui_draw_procs.fill(foreground,ui_accent_color);
    alignment:=getrect_theme.slider_theme.foreground.alignment; if theme alignment=theme.foreground.alignment;
    ui_draw_procs.text(r,tprint("%%%",prefix,value.*,suffix),alignment,ui_text_color);
    return value.*!=before;
}
dropdown :: (r:Rect,items:$T,value:*s32)->Dropdown_State {
    assert(value!=null); if !value return .{};
    state:=ui_state(.DROPDOWN); state.rect=r;
    label:=""; if value.*>=0&&value.*<items.count label=items[value.*];
    over:=ui_hit(r);
    if over&&ui_left_start&&!ui_consumed_click { state.open=!state.open; ui_focus=state; ui_consumed_click=true; }
    if state.open&&ui_pending_key==.ESCAPE { state.open=false; ui_pending_key=.UNKNOWN; }
    if state.open&&ui_pending_key==.ARROW_DOWN { value.*=cast(s32)clamp(value.*+1,0,items.count-1); ui_pending_key=.UNKNOWN; }
    if state.open&&ui_pending_key==.ARROW_UP { value.*=cast(s32)clamp(value.*-1,0,items.count-1); ui_pending_key=.UNKNOWN; }
    ui_draw_procs.fill(r,ifx state.open then ui_pressed_color else ifx over then ui_hover_color else ui_surface_color);
    ui_draw_procs.text(r,label,getrect_theme.button_theme.label_theme.alignment,ui_text_color);
    if state.open {
        popup:=array_add(*ui_popups); popup.state=state; popup.value=value; popup.choices.count=0;
        for item:items array_add(*popup.choices,item);
        popup.bounds=.{r.x,r.y-r.h*items.count,r.w,r.h*items.count};
        state.popup_bounds=popup.bounds;
    }
    return .{state.open};
}
draw_popups :: () {
    for *popup:ui_popups {
        for text,index:popup.choices {
            r:=popup.state.rect; r.y-=r.h*(index+1);
            over:=ui_hit(r);
            color:=ui_surface_color; if index==popup.value.* color=ui_accent_color; if over color=ui_hover_color;
            ui_draw_procs.fill(r,color); ui_draw_procs.text(r,text,getrect_theme.button_theme.label_theme.alignment,ui_text_color);
            if over&&ui_left_start&&!ui_consumed_click { popup.value.*=cast(s32)index; popup.state.open=false; ui_consumed_click=true; }
        }
        if ui_left_start&&!ui_consumed_click&&!ui_hit(popup.state.rect)&&!ui_hit(popup.bounds) popup.state.open=false;
        array_reset(*popup.choices);
    }
    ui_popups.count=0;
    if ui_left_start&&!ui_consumed_click ui_focus=null;
    ui_draw_procs.flush();
}
ui_deinit :: () {
    for state:ui_states free(state);
    for *popup:ui_popups array_reset(*popup.choices);
    array_reset(*ui_states); array_reset(*ui_popups); array_reset(*ui_id_stack);
    ui_capture=null; ui_focus=null; ui_initialized=false;
}
#scope_module
UI_Widget_Kind :: enum { BUTTON; SLIDER; DROPDOWN; }
UI_Widget :: struct { window:s64; id:u64; kind:UI_Widget_Kind; rect:Rect; popup_bounds:Rect; open:bool; last_frame:u64; }
UI_Popup :: struct { state:*UI_Widget; value:*s32; choices:[..]string; bounds:Rect; }
ui_states:[..]*UI_Widget; ui_popups:[..]UI_Popup; ui_id_stack:[..]u64;
ui_capture:*UI_Widget; ui_focus:*UI_Widget;
ui_window:s64; ui_width: int; ui_height: int; ui_frame:u64; ui_time:float64; ui_ordinal:u64;
ui_mouse_x: float64; ui_mouse_y: float64; ui_id_scope:u64=14695981039346656037;
ui_left_down: bool; ui_left_start: bool; ui_left_end: bool; ui_consumed_click: bool; ui_initialized: bool;
ui_pending_key:UI_Input.Key_Code=.UNKNOWN;
ui_state :: (kind:UI_Widget_Kind)->*UI_Widget {
    ui_ordinal+=1; id:=ui_id_scope^ui_ordinal;
    for state:ui_states if state.window==ui_window&&state.id==id&&state.kind==kind { state.last_frame=ui_frame; return state; }
    state:=New(UI_Widget); state.window=ui_window; state.id=id; state.kind=kind; state.last_frame=ui_frame; array_add(*ui_states,state); return state;
}
ui_hit :: (r:Rect)->bool { return r.w>0&&r.h>0&&ui_mouse_x>=r.x&&ui_mouse_y>=r.y&&ui_mouse_x<r.x+r.w&&ui_mouse_y<r.y+r.h; }
ui_popup_occludes :: (r:Rect)->bool {
    for state:ui_states if state.window==ui_window&&state.open&&state.kind==.DROPDOWN&&state.last_frame+1>=ui_frame {
        if ui_hit(state.popup_bounds) return true;
    }
    return false;
}
ui_simp_fill :: (r:Rect,color:UI_Math.Vector4) {
    UI_Draw.set_shader_for_color(true);
    UI_Draw.immediate_quad(cast(float)r.x,cast(float)r.y,cast(float)(r.x+r.w),cast(float)(r.y+r.h),color);
}
ui_simp_text :: (r:Rect,text:string,alignment:Alignment,color:UI_Math.Vector4) {
    if !ui_font||text.count==0 return;
    width:=UI_Draw.prepare_text(ui_font,text); x:=r.x+4;
    if alignment==.Center x=r.x+(r.w-width)/2;
    if alignment==.Right x=r.x+r.w-width-4;
    y:=r.y+(r.h-ui_font.max_ascender-ui_font.max_descender)/2+ui_font.max_descender;
    UI_Draw.set_scissor(cast(s32)r.x,cast(s32)r.y,cast(s32)(r.x+r.w),cast(s32)(r.y+r.h));
    UI_Draw.draw_prepared_text(ui_font,cast(s64)x,cast(s64)y,color);
    UI_Draw.clear_scissor();
}
ui_simp_flush :: () { UI_Draw.immediate_flush(); }
