#scope_export
make_forward_selection :: (old: Selection) -> Selection {
    result := old;
    if old.start_line > old.end_line || (old.start_line == old.end_line && old.start_character > old.end_character) {
        result.start_line = old.end_line;
        result.end_line = old.start_line;
        result.start_character = old.end_character;
        result.end_character = old.start_character;
    }
    return result;
}

seek_left_one_word :: (s: string, point: int) -> int {
    at := clamp(point, 0, s.count);
    while at > 0 {
        previous := seek_left_one_utf8_character(s, at);
        if !left_word_space(s[previous]) break;
        at = previous;
    }
    while at > 0 {
        previous := seek_left_one_utf8_character(s, at);
        if left_word_space(s[previous]) break;
        at = previous;
    }
    return at;
}

seek_right_one_word :: (s: string, point: int) -> int {
    at := clamp(point, 0, s.count);
    while at < s.count && !left_word_space(s[at]) at = seek_right_one_utf8_character(s, at);
    while at < s.count && left_word_space(s[at]) at = seek_right_one_utf8_character(s, at);
    return at;
}

move_cursor_left_by_word :: (using state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, seek_left_one_word(state.text, state.insert_point), want_selection);
}

move_cursor_right_by_word :: (using state: *Text_Input_State, want_selection := false) {
    move_cursor_to(state, seek_right_one_word(state.text, state.insert_point), want_selection);
}

navigate_history_backward :: (using state: *Text_Input_State) {
    if state.command_history.count == 0 return;
    if state.command_history_index >= state.command_history.count {
        saved := copy_string(state.text);
        free(state.last_saved_input.data);
        state.last_saved_input = saved;
    }
    state.command_history_index = max(state.command_history_index - 1, 0);
    refresh_input_from_history(state);
}

navigate_history_forward :: (using state: *Text_Input_State) {
    state.command_history_index = min(state.command_history_index + 1, state.command_history.count);
    refresh_input_from_history(state);
}

refresh_input_from_history :: (using state: *Text_Input_State) {
    if state.command_history_index >= 0 && state.command_history_index < state.command_history.count set_input(state, state.command_history[state.command_history_index]);
    else set_input(state, state.last_saved_input);
}

copy_selection_to_clipboard :: (using state: *Text_Input_State, cut := false) {
    if !nonempty(state.selection) return;
    Left_Text_Clipboard.os_clipboard_set_text(get_selection(state));
    if cut replace_selection(state, "");
}

reset_auto_complete :: (using state: *Text_Input_State) {
    for text: state.match_array free(text.data);
    array_free(state.match_array);
    state.match_array = .[];
    state.match_selection = 0;
    state.longest_match = -1;
    state.tab_pressed = false;
}

update_auto_complete :: (using state: *Text_Input_State) {
    reset_auto_complete(state);
    if !state.auto_complete.proc return;
    prefix := string.{ state.insert_point, state.text.data };
    matches, longest := state.auto_complete.proc(prefix, state.auto_complete.data);
    state.match_array = NewArray(matches.count, string);
    for text, index: matches state.match_array[index] = copy_string(text);
    state.match_length = prefix.count;
    state.longest_match = longest;
    state.completion_change_time = current_time;
}

advance_auto_complete :: (using state: *Text_Input_State, reverse: bool) {
    if state.match_array.count == 0 update_auto_complete(state);
    else state.match_selection = (state.match_selection + state.match_array.count + (ifx reverse then -1 else 1)) % state.match_array.count;
    state.tab_pressed = true;
    state.completion_change_time = current_time;
}

accept_auto_complete :: (using state: *Text_Input_State) -> bool {
    if state.match_array.count == 0 || state.match_selection < 0 || state.match_selection >= state.match_array.count return false;
    replacement := copy_string(state.match_array[state.match_selection]);
    defer free(replacement.data);
    state.selection = .{ start_line = 0, end_line = 0, start_character = 0, end_character = state.match_length, active = state.match_length > 0 };
    success := insert_text(state, replacement);
    reset_auto_complete(state);
    return success;
}

get_selection_endpoints :: (font: *Font, text: string, effect: Font_Effects, text_x: float, start_character: int, end_character: int) -> (x0: float, x1: float) {
    start := clamp(min(start_character, end_character), 0, text.count);
    end := clamp(max(start_character, end_character), 0, text.count);
    return text_x + draw_procs.prepare_text(font, string.{ start, text.data }, effect), text_x + draw_procs.prepare_text(font, string.{ end, text.data }, effect);
}

update_multiclick_selection :: (using state: *Text_Input_State, point: int) {
    if state.num_consecutive_clicks >= 3 select_all(state);
    else if state.num_consecutive_clicks == 2 {
        start := point;
        while start > 0 && !left_word_space(state.text[seek_left_one_utf8_character(state.text, start)]) start = seek_left_one_utf8_character(state.text, start);
        end := point;
        while end < state.text.count && !left_word_space(state.text[end]) end = seek_right_one_utf8_character(state.text, end);
        state.selection = .{ start_line = 0, end_line = 0, start_character = start, end_character = end, active = end > start };
        state.insert_point = end;
    }
}

#scope_module
Left_Text_Clipboard :: #import "Clipboard";

left_word_space :: (byte: u8) -> bool {
    return byte == 32 || byte == 9 || byte == 10 || byte == 13;
}

left_input_byte_at :: (state: *Text_Input_State, font: *Font, theme: *Text_Input_Theme, x: float) -> int {
    if !font return state.insert_point;
    whole := cast(float) draw_procs.prepare_text(font, state.text, theme.effects);
    origin, baseline := text_origin(*theme.label_theme, font, state.rect, whole);
    origin -= state.camera_x;
    previous: int;
    previous_width: float;
    at := 0;
    while at < state.text.count {
        next := seek_right_one_utf8_character(state.text, at);
        width := cast(float) draw_procs.prepare_text(font, string.{ next, state.text.data }, theme.effects);
        if x - origin < (previous_width + width) / 2 return at;
        at = next;
        previous_width = width;
    }
    return state.text.count;
}

left_text_pointer :: (state: *Text_Input_State, theme: *Text_Input_Theme, font: *Font, status: Status_Flags) {
    if status & .PRESSED {
        point := left_input_byte_at(state, font, theme, mouse_x_float);
        nearby := length(xy(mouse_x_float, mouse_y_float) - state.last_click_position) <= em(theme.distance_to_break_multiclick, font);
        if current_time - state.last_click_time <= theme.multiclick_delay_max && nearby state.num_consecutive_clicks += 1;
        else state.num_consecutive_clicks = 1;
        state.last_click_time = current_time;
        state.last_click_position = .{ mouse_x_float, mouse_y_float };
        move_cursor_to(state, point, (shift_key_state & .DOWN) != 0);
        update_multiclick_selection(state, point);
        if !state.selection.active {
            state.selection.start_character = point;
            state.selection.end_character = point;
        }
        state.cursor_tracking_mouse = true;
    }
    if state.active && state.cursor_tracking_mouse && mouse_button_left_state & .DOWN && state.num_consecutive_clicks == 1 {
        state.selection.active = true;
        state.selection.end_character = left_input_byte_at(state, font, theme, mouse_x_float);
        state.insert_point = state.selection.end_character;
        selection_was_modified(*state.selection);
    }
    if mouse_button_left_state & .END state.cursor_tracking_mouse = false;
}

left_draw_input_contents :: (r: Rect, theme: *Text_Input_Theme, state: *Text_Input_State) {
    label_theme := theme.label_theme;
    if !label_theme.font label_theme.font = get_default_font_at_size(r.h * 0.65);
    font := label_theme.font;
    if !font || !draw_procs.prepare_text return;
    whole := cast(float) draw_procs.prepare_text(font, state.text, label_theme.effects);
    origin, baseline := text_origin(*label_theme, font, r, whole);
    prefix_width := cast(float) draw_procs.prepare_text(font, string.{ state.insert_point, state.text.data }, label_theme.effects);
    if state.active {
        cursor_x := origin + prefix_width - state.camera_x;
        margin := min(em(theme.text_insert_margin, font), max(r.w / 4, 1.0));
        if cursor_x < r.x + margin state.camera_x = origin + prefix_width - r.x - margin;
        if cursor_x > r.x + r.w - margin state.camera_x = origin + prefix_width - r.x - r.w + margin;
    } else state.camera_x = 0;
    origin -= state.camera_x;
    state.last_displayed_text_x = origin;
    push_scissor(r);
    defer pop_scissor();
    if nonempty(state.selection) {
        start, end := get_selection_indices(state);
        x0, x1 := get_selection_endpoints(font, state.text, label_theme.effects, origin, start, end);
        highlight := Rect.{ x0, r.y + r.h * 0.12, max(x1 - x0, 0.0), r.h * 0.76 };
        left_text_fill(highlight, theme.selection_color);
    }
    draw_procs.prepare_text(font, state.text, label_theme.effects);
    draw_procs.draw_prepared_text(font, cast(s64) origin, cast(s64) baseline, label_theme.text_color, label_theme.effects);
    if state.active && frac(cast(float) (current_time - state.last_keypress_time)) < 0.5 {
        cursor := Rect.{ origin + prefix_width, r.y + r.h * 0.15, max(em(theme.cursor_width_inside_text, font), 1.0), r.h * 0.70 };
        left_text_fill(cursor, theme.cursor_color);
    }
    if state.active && state.tab_pressed && state.match_array.count > 0 {
        match := state.match_array[state.match_selection];
        common := min(state.match_length, match.count);
        prefix_matches := common == state.match_length;
        for i: 0..common - 1 if match[i] != state.text[i] prefix_matches = false;
        if prefix_matches && match.count > common {
            suffix := string.{ match.count - common, match.data + common };
            draw_procs.prepare_text(font, suffix, label_theme.effects);
            draw_procs.draw_prepared_text(font, cast(s64) (origin + prefix_width), cast(s64) baseline, theme.text_color_autocomplete, label_theme.effects);
        }
    }
}

left_text_fill :: (r: Rect, color: Vector4) {
    draw_procs.set_shader_for_color(true);
    p0, p1, p2, p3 := get_quad(r);
    draw_procs.immediate_quad(p0, p1, p2, p3, color);
}

left_paste_clipboard :: (state: *Text_Input_State) {
    pasted := Left_Text_Clipboard.os_clipboard_get_text();
    #if OS != .WINDOWS {
        defer if pasted.count > 0 free(pasted.data);
    }
    builder: String_Builder;
    defer free_buffers(*builder);
    for byte: pasted append(*builder, ifx byte == 10 || byte == 13 || byte == 9 then cast(u8) 32 else byte);
    insert_text(state, builder_to_string(*builder));
}
