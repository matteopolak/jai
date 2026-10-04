// Public legacy API layouts and defaults only. All algorithms are in ui.jai.
Per_Window_State :: struct {
    window: Window_Type;
    mouse_x_float, mouse_y_float: float;
}

Draw_Procs :: struct {
    texture_load_from_memory: (texture: *Texture, memory: [] u8, srgb: bool, build_mipmaps: bool) -> bool;
    set_scissor:   (x0: s32, y0: s32, x1: s32, y1: s32);
    clear_scissor: ();
    set_shader_for_color:  (enable_blend := false);
    set_shader_for_images: (texture: *Texture);
    prepare_text:       (font: *Font, text: string, effects: Font_Effects = 0) -> s64;
    draw_prepared_text: (font: *Font, x: s64, y: s64, text_color: Vector4, effects: Font_Effects = 0);
    get_mouse_pointer_position: (window: Window_Type, right_handed: bool) -> (x: int, y: int, success: bool);
    set_pointer_image: (image: Pointer_Image, widget: *Active_Widget);
    get_font_at_size:   (memory: [] u8, pixel_height: int) -> *Font;
    immediate_triangle:  (p0: Vector3, p1: Vector3, p2: Vector3, c0 := Vector4.{1,1,1,1}, c1 := Vector4.{1,1,1,1}, c2 := Vector4.{1,1,1,1}, uv0 := Vector2.{}, uv1 := Vector2.{}, uv2 := Vector2.{}, normal := Vector3.{z=1});
    immediate_quad:  (p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, color := Vector4.{1,1,1,1}, uv0 := Vector2.{0,0}, uv1 := Vector2.{1,0}, uv2 := Vector2.{1,1}, uv3 := Vector2.{0, 1});
    immediate_flush: ();
}

Status_Flags :: enum u32 {
    OVER     :: 0x01;
    FOCUS    :: 0x02;
    DOWN     :: 0x04;
    PRESSED  :: 0x08;
}

Text_Alignment :: enum u8 {
    Left   :: 0;
    Center :: 1;
    Right  :: 2;
}

Status_Flags_Ignore :: enum_flags u8 {
    NOTHING;
    LEFT_CLICK;
    TOOLTIP;
    SCISSOR;
}

Default_Font_Info :: struct {
    pixel_height: int;
    font: *Font;
}

Active_Widget :: struct {
    widget_type: Type;
    deactivate\         _proc: (w: *Active_Widget);
    serial_events\      _proc: (w: *Active_Widget, events: [] Event);
    check_for_activation_proc: (w: *Active_Widget, event: Event) -> bool;
    last_getrect_frame: u64;
    is_on_state_stack := false;
    last_update_time: float64;
    cosmetic_dt:      float32;
    window: Window_Type;
    exists_on_occluder: *Active_Widget;
}

Pointer_Image :: enum u16 {
    NORMAL    :: 0;
    PRESSABLE :: 1;
    LOCKED    :: 2;
    DRAGGING_HORIZONTAL   :: 3;
    DRAGGING_VERTICAL     :: 4;
    DRAGGING_FREE         :: 5;
    DRAGGING_NW_SE        :: 6;
    DRAGGING_NE_SW        :: 7;
}

Popup_Info :: struct {
    proc:   (*void) -> ();
    data:   *void;
    z:      s32;
    serial: s32;
}

Size_Computation :: enum u8 {
    RELATIVE_TO_HEIGHT        :: 0;
    RELATIVE_TO_WIDTH         :: 1;
    ABSOLUTE_FROM_THEME_FIELD :: 2;
    ABSOLUTE_FROM_GLOBAL      :: 3;
}

Rectangle_Shape :: struct {
    roundedness_type: Size_Computation;
    roundedness := .18;
    pixels_per_edge_segment  := 10.0;
    frame_thickness_type: Size_Computation;
    frame_thickness := .02;
    Rounding_Flags :: enum_flags u32 {
        NORTHEAST :: 0x1;
        NORTHWEST :: 0x2;
        SOUTHWEST :: 0x4;
        SOUTHEAST :: 0x8;
        EAST  :: NORTHEAST | SOUTHEAST;
        WEST  :: NORTHWEST | SOUTHWEST;
        SOUTH :: SOUTHEAST | SOUTHWEST;
        NORTH :: NORTHEAST | NORTHWEST;
        ALL :: EAST | WEST;
    }
    rounding_flags := Rounding_Flags.NORTHEAST | .NORTHWEST | .SOUTHWEST | .SOUTHEAST;
}

Label_Theme :: struct {
    font:    *Font;
    effects: Font_Effects;
    text_color                      := Vector4.{1, 1, 1, 1};
    alignment                       := Text_Alignment.Center;
    alignment_pad_ems               := 1.0;
    text_baseline_vertical_position := FLOAT32_INFINITY;
}

Background_Theme :: struct {
    shape: Rectangle_Shape;
    color := Vector4.{.08, .08, .08, 1.0};
    frame_color := Vector4.{.25, .25, .22, 1.0};
}

Margin :: enum_flags {
    Horizontal :: 0x1;
    Vertical   :: 0x2;
}

Overall_Theme :: struct {
    button_theme:            Button_Theme;
    checkbox_theme:          Checkbox_Theme;
    color_picker_theme:      Color_Picker_Theme;
    dropdown_theme:          Dropdown_Theme;
    label_theme:             Label_Theme;
    scrollable_region_theme: Scrollable_Region_Theme;
    slidable_region_theme:   Slidable_Region_Theme;
    slider_theme:            Slider_Theme;
    subwindow_theme:         Subwindow_Theme;
    text_input_theme:        Text_Input_Theme;
    color_animation_editor_theme:  Color_Animation_Editor_Theme;
    font: *Font;
    background_color        := Vector4.{.10, .10, .10, 1.0};
    background_color_bright := Vector4.{.15, .15, .15, 1.0};
    text_color              := Vector4.{.80, .80, .80, 1.0};
    title_bar_color         := Vector4.{.80, .30, .30, 1.0};
    title_bar_color_hilit   := Vector4.{.95, .50, .50, 1.0};
    border_width       := .004;
    outer_margin_size  := .007;
    outer_margin_flags := Margin.Horizontal | .Vertical;
    scrollable_section_margin_width := .007;
    scrollable_section_margin_flags := Margin.Horizontal | .Vertical;
    alpha_scale := 1.0;
}

Default_Themes :: enum {
    Default;
    Grayscale;
    Bentonite;
    Nimbus;
    Blood_Vampire;
    Freddie_Freeloader;
    HIGH_CONTRAST;
}

Theme_Proc :: #type () -> Overall_Theme;

Tooltip :: struct {
    text: string;
    pointer_data: *void;
    int_data:     s64;
}

Button_Theme :: struct {
    using label_theme: Label_Theme;

    rectangle_shape:   Rectangle_Shape;

    surface_color            := Vector4.{.08, .08, .08, 1.0};
    surface_color_over       := Vector4.{.15, .15, .20, 1.0};

    surface_color_flash      := Vector4.{.60, .77, .62, 1.0};
    surface_color_down       := Vector4.{.28, .28, .38, 1.0};

    text_color                = Vector4.{.82, .82, .82, 1.0};
    text_color_over          := Vector4.{.95, .95, .95, 1.0};
    text_color_pressed       := Vector4.{.99, .99, .99, 1.0};

    text_offset_down         := Vector2.{.12, -.12};


    frame_thickness_over     := .04;
    frame_thickness_down     := .05;
    frame_thickness_flash    := .07;
    enable_variable_frame_thickness := false;

    frame_color              := Vector4.{.40, .40, .50, 1.0};
    frame_color_over         := Vector4.{.55, .55, .45, 1.0};
    frame_color_flash        := Vector4.{.99, .99, .65, 1.0};
    frame_color_down         := Vector4.{.75, .75, .55, 1.0};

    press_duration       := 0.7;

    over_fade_in_speed   := 10.0;
    over_fade_out_speed  := 4.0;

    down_fade_in_speed   := 12.0;
    down_fade_out_speed  := 4.0;

    highlight_lighten_parameter := .15;
    highlight_darken_parameter  := .6;

    alpha_scale := 1.0;

    texture_scale := 1.0;

    draw_callback: (r: Rect, text: string, theme: *Button_Theme, texture: *Texture, state: *Button_State);

    properties: enum u64 {
        TOGGLE              :: 0x1;
        TEXTURE_LEFT_HANDED :: 0x2;
        DO_NOT_DRAW         :: 0x4;
    } = .TEXTURE_LEFT_HANDED;
}

Button_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    hash:    u64;
    status: Status_Flags;
    rect:   Rect;
    frame_pixels: float;
    over_duration := 0.0;
    over_effect_t := 0.0;
    down_duration := 0.0;
    down_effect_t := 0.0;
    action_duration   := -1.0;
    action_duration_2 := -1.0;
    over_factor    := 0.0;
    pressed_factor := 0.0;
    pressed := false;
    user_data_float: float;
    user_data_s64:   s64;
}

Checkbox_Theme :: struct {
    using button_theme: Button_Theme;
    surface_color         = .{.55, .55, .55, 1.0};
    surface_color_over    = .{.80, .80, .80, 1.0};
    surface_color_flash   = .{.90, .70, .90, 1.0};
    surface_color_down    = .{.90, .70, .90, 1.0};
    text_color               = .{.55, .55, .55, 1.0};
    text_color_over          = .{.80, .80, .80, 1.0};
    text_color_pressed       = .{.90, .70, .90, 1.0};
    button_color_selected   := Vector4.{.90, .90, .90, 1.0};
    text_color_selected     := Vector4.{.90, .60, .90, 1.0};
    is_radio_button := false;
    alignment         = .Left;
    alignment_pad_ems = 0.2;
}

Checkbox_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    base: Button_State;
    selected_t := 0.0;
}

Color_Animation_Editor_Theme :: struct {
    horizontal_padding  := .015;
    vertical_padding    := .015;
    keyframe_color_inactive := Vector4.{.35, .35, .35, 1};
    keyframe_color_active   := Vector4.{.94, .94, .94, 1};
    keyframe_color_picking  := Vector4.{.87, .87, .87, 1};
    keyframe_color_backing  := Vector4.{.05, .05, .05, 1};
    keyframe_width_relative_to_bar_height_nondragging := 0.10;
    keyframe_scale_when_dragging      := 1.5;
    keyframe_scale_when_color_picking := 1.3;
    keyframe_selection_size_relative_to_visual_size := 1.4;
    keyframe_inset_ratio   := 0.8;
    keyframe_backing_ratio := 0.24;
    background: Background_Theme;
    background.shape.roundedness_type     = .ABSOLUTE_FROM_GLOBAL;
    background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    background.shape.rounding_flags       = .SOUTH;
    background.color                      = Vector4.{.00, .10, .10, 1};
    color_picker_theme:           Color_Picker_Theme;
    color_picker_subwindow_theme: Subwindow_Theme;
    time_view_subwindow_theme:    Subwindow_Theme;
    time_view_subwindow_theme.region_background.frame_color  = .{0.28, 0.28, 0.28, 1.0};
    time_view_subwindow_theme.region_background.color        = .{0.05, 0.05, 0.05, 1.0};
    button_theme:                 Button_Theme;
    label_theme:                  Label_Theme;
    label_theme.alignment = .Right;
    number_input_theme:           Number_Input_Theme;
    dropdown_theme:               Dropdown_Theme;
    checkbox_theme:               Checkbox_Theme;
    default_interpolation := Interpolation.{.OKLAB, .HERMITE, false};
    default_num_clipboard_samples : s32 = 16;
    default_keyframes : [] Color_Keyframe = .[.{.{0.926563, 0.832695, 0.841836, 1}, 0.505263}, .{.{0.828598, 0.029386, 0.579748, 1}, 0.997368}, .{.{1, 0.33835, 0, 1}, 0.003289}, ];
    default_time_view_period := 3.0;
    Draw_Subwidgets_Flags :: enum_flags u8 {
        INTERPOLATION_CONTROLS :: 0x01;
        TIME_VIEW              :: 0x02;
        SAMPLING_CONTROLS      :: 0x04;
        COPY_TO_CLIPBOARD      :: 0x08;
    }
    DRAW_ALL_SUBWIDGETS :: Draw_Subwidgets_Flags.INTERPOLATION_CONTROLS | .TIME_VIEW | .SAMPLING_CONTROLS | .COPY_TO_CLIPBOARD;
    draw_subwidgets_flags := DRAW_ALL_SUBWIDGETS;
}

Interpolation :: struct {
    color_space: enum u8 {
        RGB   :: 0;
        HSV   :: 1;
        OKLAB :: 2;
    }
    geometry: enum u8 {
        LINEAR  :: 0;
        QUADRIC :: 1;
        HERMITE :: 2;
    }
    wrapping := false;
}

Color_Keyframe :: struct {
    color_rgb: Vector4;
    t: float;
}

Color_Pick_Mode :: enum {
    HSV_CIRCLE  :: 0;
    HSV_SLIDERS :: 1;
    RGB_SLIDERS :: 2;
    TYPE_INS    :: 3;
}

Color_Picker_Theme :: struct {
    horizontal_padding  := .06;
    vertical_padding    := .06;
    stashed_color_width := .10;
    margin_between_color_input_and_stashed_colors := .04;
    background: Background_Theme;
    background.shape.roundedness_type     = .ABSOLUTE_FROM_GLOBAL;
    background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    background.shape.rounding_flags       = .SOUTH;
    background.color                      = Vector4.{.00, .10, .10, 1};
    outer_circle_diameter := .99;
    inner_circle_diameter := .73;
    inner_disc_radius     := .95;
    initial_stashed_colors: [] Vector3 = Vector3.[
            .{1,1,1}, .{.1, .1, .1},
            .{.529, .248, .214}, .{.744, .601, .199}, .{.788, .555, .456}, .{.469, .805, .230}, .{.184, .744, .286}, .{.184, .654, .744}, .{.405, .360, .782}, .{.778, .456, .722}
    ];
    apply_and_revert_button_theme: Button_Theme;
    apply_string  := "Apply";
    revert_string := "Revert";
    slider_hue_min := -50.0;
    slider_hue_max := 345.0;
    hue_range_in_zoomed_slider := 60.0;
    stash_button_theme:       Button_Theme;
    mode_switch_button_theme: Button_Theme;
    mode_switch_button_theme.text_color.w  = .45;
    mode_switch_button_theme.texture_scale = .7;
    type_ins_label_theme: Label_Theme;
    type_ins_label_theme.text_color = Vector4.{.30, .65, .65, 1.0};
    type_ins_label_theme.alignment_pad_ems = 0.3;
    type_ins_input_theme: Number_Input_Theme;
    stashed_colors_shape: Rectangle_Shape;
    stashed_colors_shape.frame_thickness = 0.06;
    starting_color_pick_mode := Color_Pick_Mode.HSV_CIRCLE;
}

Dropdown_Theme :: struct {
    theme_for_current_value:  Button_Theme;
    theme_for_each_choice:    Button_Theme;
    theme_for_current_choice: Button_Theme;
    theme_for_current_value.surface_color        = .{.3, .07, .05, 1};
    theme_for_current_value.surface_color_over   = .{.4, .1, .15, 1};
    theme_for_current_value.surface_color_flash  = .{.75, .75, .55, 1};
    theme_for_current_value.surface_color_down   = .{.4, .4, .25, 1};
    theme_for_current_value.frame\  _color       = .{.6, .37, .35, 1};
    theme_for_current_value.frame\  _color_over  = .{.7, .4, .45, 1};
    theme_for_current_value.frame\  _color_flash = .{.95, .95, .85, 1};
    theme_for_current_value.frame\  _color_down  = .{.7, .7, .55, 1};
    theme_for_current_choice.surface_color       = .{.8, .2, .05, 1};
    theme_for_current_choice.surface_color_over  = .{.9, .3, .15, 1};
    theme_for_current_choice.surface_color_flash = .{.95, .75, .55, 1};
    theme_for_current_choice.surface_color_down  = .{.99, .4, .25, 1};
    theme_for_current_choice.frame\ _color       = .{.9, .5, .35, 1};
    theme_for_current_choice.frame\ _color_over  = .{.95, .6, .45, 1};
    theme_for_current_choice.frame\ _color_flash = .{.99, .95, .85, 1};
    theme_for_current_choice.frame\ _color_down  = .{.99, .7, .55, 1};
    theme_for_each\  _choice.surface_color       = .{.15, .05, .05, 1};
    theme_for_each\  _choice.surface_color_over  = .{.25, .12, .12, 1};
    theme_for_each\  _choice.surface_color_flash = .{.65, .55, .35, 1};
    theme_for_each\  _choice.surface_color_down  = .{.40, .20, .10, 1};
    theme_for_each\  _choice.frame\ _color       = .{.35, .20, .20, 1};
    theme_for_each\  _choice.frame\ _color_over  = .{.45, .25, .25, 1};
    theme_for_each\  _choice.frame\ _color_flash = .{.95, .85, .85, 1};
    theme_for_each\  _choice.frame\ _color_down  = .{.70, .50, .35, 1};
    dropdown_indicator_aspect_ratio := 1.0;
    arrow_flip_up_rate   := 2.5;
    arrow_flip_down_rate := 3.9;
}

Dropdown_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    widget.deactivate_proc = dropdown_deactivate;

    open := false;
    open_t := 0.0;
    status : Status_Flags;

    hash:      u64;
    base_rect: Rect;
    choices:   [] string;
    theme:     Dropdown_Theme = ---;
    loc:       Source_Code_Location;
    z:         s32;

    current_value_pointer: *s32;
    current_value_state:   *Button_State;
}

Number_Input_Theme :: struct {
    using text_input_theme: Text_Input_Theme;
    text_input_theme.cursor_width_outside_text = .11;
    text_input_theme.alignment_pad_ems = .2;
    text_input_theme.button_theme.surface_color = .{.08*.7, .208*.7, .236*.7, 1.0};
    clamp_low  := true;
    clamp_high := true;
}

Scrollable_Region_Flags :: enum_flags u8 {
    VERTICAL :: 1;
    HORIZONTAL :: 2;
}

Scrollable_Region_Theme :: struct {
    direction := Scrollable_Region_Flags.VERTICAL;
    horizontal_margin_size := 0.005;
    vertical_margin_size   := 0.005;
    margin_flags := Margin.Horizontal | .Vertical;
    scrollbar_size := 0.03;
    minimum_nib_size := 1.0;
    nib_margin := 0.10;
    scrollbar_nib_theme: Button_Theme;
    scrollbar_nib_theme.surface_color                    = Vector4.{.55, .05, .55, 1};
    scrollbar_nib_theme.surface_color_over               = Vector4.{.70, .05, .70, 1};
    scrollbar_nib_theme.surface_color_flash = Vector4.{.90, .50, .90, 1};
    scrollbar_nib_theme.surface_color_down               = Vector4.{.85, .15, .85, 1};
    scrollbar_nib_theme.rectangle_shape.frame_thickness_type = .RELATIVE_TO_WIDTH;
    scrollbar_nib_theme.rectangle_shape.roundedness_type     = .RELATIVE_TO_WIDTH;
    scrollbar_nib_theme.rectangle_shape.roundedness          = .24;
    scrollbar_nib_theme.enable_variable_frame_thickness = true;
    scrollbar_nib_theme.frame_thickness_over = .1;
    scrollbar_nib_theme.frame_thickness_down = .12;
    scrollbar_nib_theme.frame_thickness_flash = .15;
    scrollbar_nib_theme.frame_color                    = Vector4.{.65, .25, .65, 1};
    scrollbar_nib_theme.frame_color_over               = Vector4.{.72, .45, .72, 1};
    scrollbar_nib_theme.frame_color_flash = Vector4.{.99, .90, .99, 1};
    scrollbar_nib_theme.frame_color_down               = Vector4.{.88, .60, .88, 1};
    region_background: Background_Theme;
    region_background.shape.rounding_flags       = Rectangle_Shape.Rounding_Flags.NORTHWEST | .SOUTHWEST;
    region_background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    region_background.shape.roundedness_type     = .RELATIVE_TO_WIDTH;
    region_background.shape.roundedness          = .06;
    region_background.frame_color                = Vector4.{0.35, 0.28, 0.40, 1.0};
    region_background.color                      = Vector4.{0.08, 0.013, 0.10, 1.0};
    scrollbar_background: Background_Theme;
    scrollbar_background.shape.rounding_flags       = Rectangle_Shape.Rounding_Flags.NORTHEAST | .SOUTHEAST;
    scrollbar_background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    scrollbar_background.shape.roundedness_type     = .RELATIVE_TO_WIDTH;
    scrollbar_background.frame_color                = Vector4.{0.30, 0.22, 0.34, 1.0};
    scrollbar_background.color                      = Vector4.{0.17, 0.015, 0.20, 1.0};
    mouse_wheel_increment := 0.0004;
}

Slidable_Region_Theme :: struct {
    orientation: enum u8 {
        HORIZONTAL :: 0;
        VERTICAL   :: 1;
    }
    divider_theme: Button_Theme;
    divider_theme.surface_color       = .{.4, .6, .7, 1};
    divider_theme.surface_color_over  = .{.7, .8, .9, 1};
    divider_theme.surface_color_down  = .{.8, .9, .95, 1};
    divider_theme.surface_color_flash = .{.9, .87, .99, 1};
    divider_thickness_type := Size_Computation.ABSOLUTE_FROM_GLOBAL;
    divider_thickness      := .02;
    initial_divider_position_type := Size_Computation.RELATIVE_TO_HEIGHT;
    initial_divider_position      := 0.5;
    first_background:  Background_Theme;
    second_background: Background_Theme;
    first_background.shape.frame_thickness_type  = .ABSOLUTE_FROM_GLOBAL;
    first_background.shape.rounding_flags        = Rectangle_Shape.Rounding_Flags.NORTHWEST | .SOUTHWEST;
    second_background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    second_background.shape.rounding_flags       = Rectangle_Shape.Rounding_Flags.NORTHEAST | .SOUTHEAST;
}

Slider_Format_Text_Mode :: enum u8 {
    DISPLAY :: 0;
    EDITING :: 1;
}

Slider_Theme :: struct {
    foreground: Button_Theme;
    foreground.surface_color         = .{0.0, 0.50, 0.35, 1.0};
    foreground.surface_color_over    = .{0.0, 0.60, 0.40, 1.0};
    foreground.surface_color_flash   = .{.03, 0.80, 0.30, 1.0};
    foreground.surface_color_down    = .{.30, 0.60, 0.40, 1.0};
    foreground.frame_color           = .{0.2, 0.70, 0.55, 1.0};
    foreground.frame_color_over      = .{0.2, 0.80, 0.60, 1.0};
    foreground.frame_color_flash     = .{.23, 0.95, 0.50, 1.0};
    foreground.frame_color_down      = .{.50, 0.80, 0.60, 1.0};
    foreground.alignment         = .Center;
    foreground.alignment_pad_ems = .5;
    decimals: s32 = 2;
    background: Button_Theme;
    background.surface_color          = .{0.0, 0.1, 0.00, 1.0};
    background.surface_color_over     = .{0.0, 0.2, 0.00, 1.0};
    background.surface_color_flash    = .{0.0, 0.2, 0.10, 1.0};
    background.surface_color_down     = .{0.0, 0.2, 0.15, 1.0};
    background.frame_color            = .{0.2, 0.3, 0.20, 1.0};
    background.frame_color_over       = .{0.2, 0.4, 0.20, 1.0};
    background.frame_color_flash      = .{0.2, 0.4, 0.30, 1.0};
    background.frame_color_down       = .{0.2, 0.4, 0.35, 1.0};
    surface_margin   := .15;
    text_editable    := true;
    clamp_text_input_low  := true;
    clamp_text_input_high := true;
    sliding_is_relative   := false;
    sliding_becomes_relative_by_pressing_shift := true;
    relative_slide_factor          := 0.7;
    relative_slide_factor_modified := 0.2;
    do_clamp_if_we_are_relative_dragging_but_started_outside_the_clamp_range := false;
    text_input_theme: Text_Input_Theme;
    use_spinboxes        := true;
    spinbox_button_width := 1.0;
    surface_style: enum u8 {
        EXTEND_FROM_LEFT :: 0;
        NUB              :: 1;
    }
    nub_thickness_type := Size_Computation.RELATIVE_TO_HEIGHT;
    nub_thickness      := 1.2;
    spinbox_theme:      Button_Theme;
    spinbox_theme.text_color         = .{ .1, .42, .42, 1 };
    spinbox_theme.text_color_over    = .{ .4, .70, .70, 1 };
    spinbox_theme.text_color_pressed = .{ .5, .99, .99, 1 };
    spinbox_theme.frame_color            = .{0.2, 0.25, 0.40, 1};
    spinbox_theme.frame_color_over       = .{0.2, 0.30, 0.50, 1};
    spinbox_theme.frame_color_flash      = .{0.2, 0.35, 0.60, 1};
    spinbox_theme.frame_color_down       = .{0.2, 0.55, 0.5,  1};
    draw_background := slider_draw_background_default;
    draw_foreground := slider_draw_foreground_default;
    format_text_float := slider_format_text_float_default;
    format_text_int   := slider_format_text_int_default;
    parse_text_float := slider_parse_text_float_default;
    parse_text_int   := slider_parse_text_int_default;
}

Slider_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    background: Button_State;
    foreground: Button_State;
    union {
        initial_value_float32: float32;
        initial_value_float64: float64;
        initial_value_int:     int;
    };
    sliding_t: float;
    slowing_t: float;
    accumulated_delta_for_int_slider := 0.0;
    sliding             := false;
    sliding_is_relative := false;
    inputting_text      := false;
    value_type: *Type_Info;
    current_slide_setting: float;
    surface_margin_this_frame_in_pixels: float;
    changed_this_frame: bool;
}

Subwindow_Flags :: enum_flags u16 {
    TITLE_BAR ::             0x1;
    CLOSE_BUTTON ::          0x2;
    FRINGE ::                0x4;
    VISIBLE_RESIZE_CORNER :: 0x8;
}

Resize_Controls :: enum_flags u16 {
    EAST         :: 0x1;
    NORTH        :: 0x2;
    WEST         :: 0x4;
    SOUTH        :: 0x8;
    CORNER_SE    :: 0x10;
    PROPORTIONAL :: 0x20;
    SNAP_EW      :: 0x40;
    SNAP_NS      :: 0x80;
    NS   :: NORTH | SOUTH;
    EW   :: EAST  | WEST;
    NE   :: NORTH | EAST;
    NW   :: NORTH | WEST;
    SE   :: SOUTH | EAST;
    SW   :: SOUTH | WEST;
    ENWS :: NS | EW;
    SNAP :: SNAP_EW | SNAP_NS;
}

Subwindow_Theme :: struct {
    title_bar_size := 0.03;
    title_bar: Button_Theme;
    title_bar.surface_color                        = .{.165, .233, .379, 1};
    title_bar.surface_color_over                   = .{.183, .311, .484, 1};
    title_bar.surface_color_flash                  = .{.413, .695, .840, 1};
    title_bar.surface_color_down                   = .{.317, .538, .650, 1};
    title_bar.rectangle_shape.rounding_flags       = .NORTH;
    title_bar.rectangle_shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    title_bar.rectangle_shape.roundedness_type     = .RELATIVE_TO_WIDTH;
    title_bar.rectangle_shape.roundedness          = .24;
    title_bar.enable_variable_frame_thickness      = true;
    title_bar.frame_thickness_over                 = .1;
    title_bar.frame_thickness_down                 = .12;
    title_bar.frame_thickness_flash                = .15;
    title_bar.frame_color                          = .{.321, .374, .500, 1};
    title_bar.frame_color_over                     = .{.437, .491, .618, 1};
    title_bar.frame_color_flash                    = .{.734, .772, .861, 1};
    title_bar.frame_color_down                     = .{.537, .584, .695, 1};
    close_button: Button_Theme;
    close_button.surface_color                     = .{.70, .25, .08, 1};
    close_button.surface_color_over                = .{.99, .15, .08, 1};
    close_button.surface_color_flash               = .{.90, .90, .90, 1};
    close_button.surface_color_down                = .{.95, .65, .05, 1};
    close_button.text_color                        = .{.07, .07, .07, 1};
    close_button.text_color_over                   = .{.90, .90, .40, 1};
    close_button.text_color_pressed                = .{.99, .99, .99, 1};
    close_button_width        := 1.2;
    close_button_height       := 0.8;
    close_button_right_margin := 0.4;
    close_button_x_height     := 0.7;
    region_background: Background_Theme;
    region_background.shape.rounding_flags       = Rectangle_Shape.Rounding_Flags.SOUTHEAST | .SOUTHWEST;
    region_background.shape.frame_thickness_type = .ABSOLUTE_FROM_GLOBAL;
    region_background.shape.roundedness_type     = .RELATIVE_TO_WIDTH;
    region_background.shape.roundedness          = .06;
    region_background.frame_color                = .{0.35, 0.28, 0.40, 1.0};
    region_background.color                      = .{0.08, 0.013, 0.10, 1.0};
    horizontal_margin_size := 0.005;
    vertical_margin_size   := 0.005;
    subwindow_flags := Subwindow_Flags.TITLE_BAR | .FRINGE | .CLOSE_BUTTON | .VISIBLE_RESIZE_CORNER;
    fringe_color := Vector4.{0, 0, 0, .2};
    fringe_thickness := 0.004;
    resize_corner_line_thickness := 0.025;
    resize_corner_color          := Vector4.{.4, .4, .4, 1};
    drag_intrusion_east  := 0.006;
    drag_extrusion_east  := 0.008;
    drag_intrusion_west  := 0.006;
    drag_extrusion_west  := 0.008;
    drag_intrusion_north := 0.002;
    drag_extrusion_north := 0.011;
    drag_intrusion_south := 0.006;
    drag_extrusion_south := 0.008;
    drag_corner_margin   := 0.05;
    resize_controls := Resize_Controls.CORNER_SE | .EAST | .NORTH | .WEST | .SOUTH;
    resize_rect_size := 0.05;
    resize_minimum_size := Vector2.{.08, .08};
    resize_snap_margin := 0.02;
}

Text_Input_Action :: enum_flags u8 {
    ACTIVATE   :: 0x1;
    DEACTIVATE :: 0x2;
}

Text_Result_Action :: enum_flags u32 {
    ENTERED       :: 0x1;
    ESCAPED       :: 0x2;
    TEXT_MODIFIED :: 0x4;
}

Selection :: struct {
    start_line       := -1;
    start_character  : int;
    end_line         := -1;
    end_character    : int;
    active := false;
}

Auto_Complete :: struct {
    proc: (str: string, data: *void) -> (results: [] string, longest_match_length: int);
    data: *void;
}

Text_Input_Theme :: struct {
    using button_theme: Button_Theme;
    alignment = .Left;
    button_theme.surface_color        = Vector4.{.07, .07, .20, 1.0};
    button_theme.surface_color_over   = Vector4.{.12, .12, .99, 1.0};
    button_theme.surface_color_down   = Vector4.{.66, .10, .40, 1.0};
    button_theme.surface_color_flash  = Vector4.{.60, .77, .62, 1.0};
    button_theme.frame_color          = Vector4.{.10, .25, .40, 1.0};
    button_theme.frame_color_over     = Vector4.{.15, .45, .75, 1.0};
    button_theme.frame_color_down     = Vector4.{.45, .75, .95, 1.0};
    button_theme.frame_color_flash    = Vector4.{.85, .85, .99, 1.0};
    text_color               = Vector4.{.30, .65, .65, 1.0};
    text_color_over          = Vector4.{.99, .70, .70, 1.0};
    text_color_pressed       = Vector4.{.55, .99, .99, 1.0};
    text_color_autocomplete        := Vector4.{.30, .99, .30, 0.9};
    text_color_autocomplete_failed := Vector4.{.99, .55, .55, 0.9};
    selection_color         := Vector4.{.15, .69, .85, 1.0};
    cursor_color            := Vector4.{1.0, 1.0, 1.0, 1.0};
    text_insert_margin         := 4.7;
    cursor_width_inside_text   := 0.11;
    cursor_width_outside_text  := .55;
    maintain_text_after_escape := false;
    deactivate_on_enter        := true;
    multiclick_delay_max         := 0.5;
    distance_to_break_multiclick := 0.8;
}

Text_Input_State :: struct #type_info_none {
    #as using widget: Active_Widget;
    widget.deactivate_proc           = text_input_deactivate;
    widget.serial_events_proc        = text_input_serial_events;
    widget.check_for_activation_proc = text_input_check_for_activation;
    base: Button_State;
    rect: Rect;
    camera_initted  := false;
    camera_x        := 0.0;
    active_t        := 0.0;
    active         := false;
    disabled       := false;
    shrunken_deadzone_margin := -1.0;
    last_displayed_text_x    := FLOAT32_INFINITY;
    last_keypress_time: float64;
    last_inert_text := "";
    last_click_time       : float64;
    current_click_time    : float64 = -1;
    num_consecutive_clicks : s32;
    last_click_position: Vector2;
    click_position:      Vector2;
    insert_point := 0;
    cursor_tracking_mouse := false;
    did_initial_mouse_click_so_check_for_deadzone_change := false;
    pending_result_actions: Text_Result_Action;
    last_saved_input: string;
    pre_modification_text: string;
    command_history: [..] string;
    command_history_index := 0;
    selection: Selection;
    buffered_events: [..] Event;
    text: string;
    MAX_BUFFER_SIZE :: 8000;
    input_buffer: [MAX_BUFFER_SIZE] u8;
    auto_complete: Auto_Complete;
    tab_pressed := false;
    completion_change_time: float64;
    match_array     : [] string;
    match_length    : int;
    match_selection : int;
    longest_match   : int = -1;
    do_active_widget_deactivate_all := false;
}
