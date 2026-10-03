#scope_export
THEME_COUNT :: cast(int)Default_Themes.HIGH_CONTRAST+1;
default_theme_procs:[THEME_COUNT]Theme_Proc=Theme_Proc.[theme_proc_default,theme_proc_grayscale,theme_proc_bentonite,theme_proc_nimbus,theme_proc_blood_vampire,theme_proc_freddie_freeloader,theme_proc_high_contrast];
set_theme_from_base_colors :: (theme:*Overall_Theme,main_surface_color:Vector4,border_color:Vector4,interact_color:Vector4,atop_surface_text:Vector4,atop_border_text:Vector4) {
    base:=theme.button_theme;
    base.surface_color=main_surface_color; base.surface_color_over=lerp(main_surface_color,interact_color,0.25); base.surface_color_down=lerp(main_surface_color,interact_color,0.60); base.surface_color_flash=interact_color;
    base.frame_color=border_color; base.frame_color_over=lerp(border_color,interact_color,0.5); base.frame_color_down=interact_color; base.frame_color_flash=interact_color;
    base.text_color=atop_surface_text; base.text_color_over=atop_surface_text; base.text_color_pressed=atop_border_text;
    theme.button_theme=base; theme.checkbox_theme.button_theme=base; theme.checkbox_theme.alignment=.Left;
    theme.label_theme.text_color=atop_surface_text; theme.text_color=atop_surface_text; theme.text_input_theme.button_theme=base;
    theme.text_input_theme.selection_color=lerp(border_color,interact_color,0.7); theme.text_input_theme.cursor_color=atop_surface_text;
    theme.slider_theme.background=base; theme.slider_theme.foreground=base; theme.slider_theme.foreground.surface_color=interact_color;
    theme.dropdown_theme.theme_for_current_value=base; theme.dropdown_theme.theme_for_each_choice=base; theme.dropdown_theme.theme_for_current_choice=base;
    theme.dropdown_theme.theme_for_current_choice.surface_color=interact_color;
    theme.scrollable_region_theme.scrollbar_nib_theme=base; theme.slidable_region_theme.divider_theme=base;
    theme.subwindow_theme.title_bar=base; theme.subwindow_theme.close_button=base;
    theme.color_picker_theme.apply_and_revert_button_theme=base; theme.color_picker_theme.mode_switch_button_theme=base; theme.color_picker_theme.stash_button_theme=base;
    theme.color_animation_editor_theme.button_theme=base; theme.color_animation_editor_theme.label_theme.text_color=atop_surface_text;
    theme.background_color=main_surface_color; theme.background_color_bright=lerp(main_surface_color,interact_color,0.1);
    theme.title_bar_color=border_color; theme.title_bar_color_hilit=interact_color;
    theme.scrollable_region_theme.region_background.color=main_surface_color; theme.scrollable_region_theme.region_background.frame_color=border_color;
    theme.scrollable_region_theme.scrollbar_background.color=main_surface_color; theme.scrollable_region_theme.scrollbar_background.frame_color=border_color;
    theme.slidable_region_theme.first_background.color=main_surface_color; theme.slidable_region_theme.second_background.color=main_surface_color;
    theme.subwindow_theme.region_background.color=main_surface_color; theme.subwindow_theme.region_background.frame_color=border_color;
}
theme_proc_default :: ()->Overall_Theme { return left_palette(.{0.11,0.16,0.22,1},.{0.28,0.43,0.57,1},.{0.39,0.75,0.95,1},.{0.95,0.97,1,1}); }
theme_proc_grayscale :: ()->Overall_Theme { return left_palette(.{0.12,0.12,0.12,1},.{0.42,0.42,0.42,1},.{0.72,0.72,0.72,1},.{0.96,0.96,0.96,1}); }
theme_proc_bentonite :: ()->Overall_Theme { return left_palette(.{0.23,0.18,0.14,1},.{0.48,0.39,0.28,1},.{0.87,0.70,0.40,1},.{1,0.96,0.87,1}); }
theme_proc_nimbus :: ()->Overall_Theme { return left_palette(.{0.82,0.87,0.93,1},.{0.32,0.42,0.54,1},.{0.37,0.66,0.88,1},.{0.06,0.10,0.16,1}); }
theme_proc_blood_vampire :: ()->Overall_Theme { return left_palette(.{0.17,0.05,0.07,1},.{0.44,0.13,0.21,1},.{0.92,0.29,0.39,1},.{1,0.91,0.91,1}); }
theme_proc_freddie_freeloader :: ()->Overall_Theme { return left_palette(.{0.09,0.20,0.17,1},.{0.24,0.47,0.40,1},.{0.64,0.88,0.61,1},.{0.94,1,0.91,1}); }
theme_proc_high_contrast :: ()->Overall_Theme { return left_palette(.{0,0,0,1},.{1,1,1,1},.{1,0.85,0,1},.{1,1,1,1}); }
#scope_module
left_palette :: (surface:Vector4,border:Vector4,accent:Vector4,text:Vector4)->Overall_Theme { result:Overall_Theme; set_theme_from_base_colors(*result,surface,border,accent,text,text); return result; }
