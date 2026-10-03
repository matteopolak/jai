// Actual source helpers; opaque window values are comparison tags, never native calls.
L :: #import "GetRect_LeftHanded";
B :: #import "Basic";
compatibility_cases :: ()->bool {
    lines:=L.break_into_lines("one\r\ntwo\n"," ");
    B.assert(lines.count==5&&lines[0]=="one"&&lines[1]==" "&&lines[2]=="two"&&lines[4]=="");
    B.assert(L.sanitize("a\r\nb\t") == "a b ");
    input:L.Text_Input_State; L.set_input(*input,"alpha beta"); L.move_cursor_left_by_word(*input); B.assert(input.insert_point==6);
    L.start_selecting(*input); L.move_cursor_to_beginning(*input,true); B.assert(L.get_selection(*input)=="alpha ");
    L.insert_text(*input,"x "); B.assert(input.text=="x beta"); L.reset(*input);
    slider:L.Slider_State; L.set_initial_value(*slider,cast(s64)0x7fff_ffff_ffff_ff00); B.assert(L.get_initial_value(*slider,s64)==0x7fff_ffff_ffff_ff00);
    picker:L.Color_Picker_State; picker.circle_picker_in_warped_mode=true;
    for s:0..4 for v:0..4 {
        point:=L.backsolve_disc_point_from_hsv(*picker,180,cast(float)s/4,cast(float)v/4);
        B.assert(L.Math.length(point)<=1.00001);
        maximum:=B.max(L.Math.abs(point.x),L.Math.abs(point.y)); magnitude:=L.Math.length(point);
        if maximum>0 { square:=point*(magnitude/maximum); B.assert(L.Math.abs((square.x+1)/2-cast(float)s/4)<0.00001&&L.Math.abs((1-square.y)/2-cast(float)v/4)<0.00001); }
    }
    back:L.Active_Widget; front:L.Active_Widget; back.window=cast(L.Window_Type)0; front.window=back.window;
    L.occluder_start(*back,.{0,0,20,20}); L.occluder_finish(*back);
    L.occluder_start(*front,.{5,5,10,10}); L.occluder_finish(*front);
    L.mouse_x_float=7; L.mouse_y_float=7; L.occlusion_per_frame_update(); L.occlusion_per_window_update(front.window);
    B.assert(L.events_occluded(*back)&&!L.events_occluded(*front));
    child:L.Active_Widget; child.exists_on_occluder=*front; B.assert(!L.events_occluded(*child));
    L.occlusion_per_frame_update(); L.occlusion_per_window_update(front.window); B.assert(!L.events_occluded(*back));
    L.ui_deinit(); return true;
}
#assert #run compatibility_cases();
main :: () { compatibility_cases(); }
