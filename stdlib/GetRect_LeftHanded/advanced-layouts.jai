// Read-only public field/default contracts; algorithm bodies are authored separately.
#scope_export
Scrollable_Region_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    nib_state:  Button_State;
    outer_rect: Rect;
    inner_rect: Rect;
    bar_rect:   Rect;
    dragging    := false;
    teleporting := false;
    theme: Scrollable_Region_Theme;
}

Number_Input_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    widget.widget_type = #this;
    text_input_state: Text_Input_State;
    inputting_text := false;
}

Subwindow_Info :: struct {
    rect: Rect;
    title_text: string;
    fixed_aspect_ratio := -1.0;
    snap_to_size: Vector2;
    user_data: *void;
    draw: (content_rect: Rect, user_data: *void);
    open := true;
    wants_a_raise := false;
}

Subwindow_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    base: Button_State;
    title_bar_rect: Rect;
    content_rect:   Rect;
    info: *Subwindow_Info;
    wants_draw    := false;
    wants_a_raise := false;
    hash:           u64;
    render_target_width:  s32;
    render_target_height: s32;
    dragging: enum u8 { TITLE :: 0x1; RESIZE :: 0x2; };
    dragging_start:  Vector2;
    dragging_last:   Vector2;
    dragging_offset: Vector2;
    dragging_resize_control: Resize_Controls;
    resizing_aspect: float;
    theme: Subwindow_Theme;
}

Slidable_Region_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    divider_state:  Button_State;
    left_or_top_rect:     Rect;
    right_or_bottom_rect: Rect;
    divider_rect:         Rect;
    theme:                *Slidable_Region_Theme;
    divider_t:              float;
    divider_over_factor:    float;
    divider_pressed_factor: float;
    dragging    := false;
}

Flowable_Text :: struct {
    unflowed_lines: [..] Unflowed_Line;
    flowed_lines:   [..] Flowed_Line;
    num_flowed_lines : s32 = 0;
    flowed_rect: Rect;
}

Text_Display_Theme :: struct {
    using text_theme: Label_Theme;
    top_margin_type: Size_Computation;
    top_margin:      float;
    left_margin_type: Size_Computation;
    left_margin:     float;
    right_margin_type: Size_Computation;
    right_margin:     float;
    auto_reflow_text := false;
}

Text_Display_State :: struct #type_info_none {
    using widget: Active_Widget;
    rect: Rect;
    text: *Flowable_Text;
    selecting := false;
}

Color_Picker_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    ring_point     := Vector2.{1, 0};
    disc_point     := Vector2.{1, 0};
    dragging_in_ring:    bool;
    dragging_in_disc:    bool;
    dragging_in_h: bool;
    dragging_in_h_zoom: bool;
    dragging_in_s: bool;
    dragging_in_l: bool;
    dragging_in_r: bool;
    dragging_in_g: bool;
    dragging_in_b: bool;
    dragging_in_hsv_rectangle: bool;
    dragging_in_ring_t: float;
    dragging_in_disc_t: float;
    dragging_in_h_t: float;
    dragging_in_h_zoom_t: float;
    dragging_in_s_t: float;
    dragging_in_l_t: float;
    dragging_in_r_t: float;
    dragging_in_g_t: float;
    dragging_in_b_t: float;
    dragging_in_hsv_rectangle_t: float;
    toggled_s: bool;
    toggled_v: bool;
    toggled_s_t: float;
    toggled_v_t: float;
    hsv_picker_in_rectangle_mode := true;
    circle_picker_in_warped_mode := false;
    zoom_hue_center := 0.0;
    color_pick_mode := Color_Pick_Mode.HSV_CIRCLE;
    current_hsv_color: Vector3;
    current_rgb_color: Vector3;
    original_rgb_color: Vector3;
    stashed_colors: [..] Vector3;
}
Color_Animation_Editor_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    ring_point     := Vector2.{1, 0};
    disc_point     := Vector2.{1, 0};
    dragging_in_strip:       bool;
    dragging_keyframe_index: int;
    color_picker_keyframe_index: int;
    color_picker_subwindow_info: Subwindow_Info;
    color_picker_subwindow_info.open = false;
    time_view_subwindow_info: Subwindow_Info;
    time_view_subwindow_info.open = false;
    color_picker_editing_color_applied: Vector3;
    color_picker_subwindow_rect_initialized := false;
    time_view\  _subwindow_rect_initialized := false;
    theme: *Color_Animation_Editor_Theme;
    last_color_picker_state: *Color_Picker_State;
    color_samples: [..] Vector4;
    num_clipboard_samples: s32;
    interpolation_color_space_s32: s32;
    interpolation_geometry_s32:    s32;
    interpolation_wrapping :=      false;
    output_type_s32: s32 = xx Output_Type.RESAMPLED_ARRAY;
    time_view_period: float;
    time_view_playing := true;
    time_view_current_time: float64;
    color_keyframes: [..] Augmented_Keyframe;
}

Augmented_Keyframe :: struct {
    using base: Color_Keyframe;
    active:   bool;
    active_t: float;
    dragging_t:      float;
    color_picking_t: float;
    pos_x: float;
}

Output_Type :: enum {
    RESAMPLED_ARRAY  :: 0;
    SOURCE_KEYFRAMES :: 1;
}

Unflowed_Line :: struct {
    pieces: [] Unflowed_Line_Piece;
}

Unflowed_Line_Piece :: struct {
    font: *Font;
    effects: Font_Effects;
    text: string;
    color: Vector4;
}

Flowed_Line :: struct {
    pieces: [] Unflowed_Line_Piece;
}

Flowed_Line_Piece :: struct {
    font: *Font;
    effects: Font_Effects;
    text: string;
    color: Vector4;
}
